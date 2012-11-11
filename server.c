#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/epoll.h>
#include<pthread.h>
#include<stdbool.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <sys/sem.h>
#include "common.h"
#include "list.h"

struct QUEUE_TYPE
{
    int clientfd;
    struct List *clients;
    struct Message message;
    int message_size;
    bool finish;
};
#include "queue.h"

const int MAX_EPOLL_EVENTS = 1000;
const int BACK_LOG = 1000;

pthread_mutex_t list_mutex;
pthread_mutex_t tasks_mutex;

int message_count = 1;

int semid;

static struct sembuf sop_lock = {
    0, -1, 0
};

static struct sembuf sop_unlock = {
    0, 1, 0
};

struct ServerData
{
    int threads_count;
    bool *finish;
    bool *inf_mode;
};

int thr_id = 0;

void PrintMessage(struct Message message)
{
    char buf[256];
    strcpy(buf, message.text);
    //long c = 9;
    (*((long *)(buf+256+12)))+=9;
    printf("Recieved message[%d]: %s\n", message_count, buf);
}

void* Broadcast(void *data)
{
    int id = thr_id++;
    //int pipe_read_fd = *((int *)data);
    struct Queue *tasks = (struct Queue *)data;
    struct QUEUE_TYPE task;
    while(1)
    {
        semop(semid, &sop_lock, 1);

        pthread_mutex_lock(&tasks_mutex);//mutex========================================================================================================================

        struct QUEUE_TYPE temp_task = GetFromQueue(tasks);
        memcpy(&task, &temp_task, sizeof(task));

        pthread_mutex_unlock(&tasks_mutex);//mutex========================================================================================================================

        if (task.finish)
        {
            printf("Thread finished\n");
            break;
        }

        pthread_mutex_lock(&list_mutex);//mutex========================================================================================================================
        struct ListElement *element = task.clients->first;

        while(element != NULL)//отправляем сообщение всем подключенным клиентам, кроме отправителя
        {
            if((element->value) != task.clientfd)
            {
                int bytes_sent = 0;
                int bytes;

                while(bytes_sent < sizeof(task.message))
                {
                    bytes = send(element->value, &(task.message) + bytes_sent, sizeof(task.message) - bytes_sent, MSG_NOSIGNAL);

                    if(bytes > 0)
                    {
                        bytes_sent+=bytes;
                    }
                    else
                    {
                        if(bytes == 0 /*|| (/*bytes < 0 &&*/ /*errno == EFAULT*//*)*/ /*|| errno == EPIPE*/) // Соединение разорвано
                        {
                            break;
                        }
                        if(bytes<0 && errno != EAGAIN)
                        {
                            break;
                        }
                    }
                }
            }
            element = element->next;
        }
        pthread_mutex_unlock(&list_mutex);//mutex========================================================================================================================
    }
    return NULL;
}

void* Server(void *data)
{
    printf("Server started\n");
    printf("Commands: stop, inf\n");
    int listenfd;
    struct sockaddr_in addr;
    struct ServerData server_data = *((struct ServerData *)data);
    int threads_count = server_data.threads_count;

    listenfd = socket(AF_INET, SOCK_STREAM, 0); //создание internet-сокета для приема запросов на соединение от клиентов
    if(listenfd < 0)
    {
        perror("Socket creation error\n");
        exit(1);
    }

    fcntl(listenfd, F_SETFL, O_NONBLOCK); //назначение сокета неблокирующим

    addr.sin_family = AF_INET;
    addr.sin_port = htons(3425); //номер порта сокета
    addr.sin_addr.s_addr = INADDR_ANY; //ip-адрес сетевого интерфейса, через который совершается соединение (здесь - любой)
    if(bind(listenfd, (struct sockaddr *)&addr, sizeof(addr)) < 0) //связывание сокета с адресом
    {
        perror("Binding error");
        exit(2);
    }

    listen(listenfd, BACK_LOG); //перевод сервера в режим ожидания запросов

    struct List list;//список дескрипторов сокетов подключенных клиентов
    InitializeList(&list);



    // Создание дескриптора epoll
    int efd = epoll_create(MAX_EPOLL_EVENTS);

    // Добавляем дескриптор слушающего сокета в массив ожидания событий
    struct epoll_event listenev;
    listenev.events = EPOLLIN /*есть данные для чтения*/| EPOLLPRI/*есть срочные данные для чтения*/ /*| EPOLLET/*Edge-Triggered*/;//флаги отслеживаемых событий
    listenev.data.fd = listenfd;
    if (epoll_ctl(efd, EPOLL_CTL_ADD, listenfd, &listenev) < 0) //теперь epoll следит за наступлением указанных событий для сокета listenfd
    {
        perror("Epoll fd add");
        return;
    }

    socklen_t client;

    struct epoll_event events[MAX_EPOLL_EVENTS]; //структуры epoll_event для всех наступивших событий
    struct epoll_event connev;
    struct sockaddr_in cliaddr; //структура для сохранения в ней адреса подключаемого клиента

    int events_count = 1; //число сокетов, для которых отслеживаются события

    struct Queue tasks;

    semid = semget(IPC_PRIVATE, 1, 0666|IPC_CREAT);

    if(semid==-1)
    {
        perror("Semaphore creation failed\n");
        exit(EXIT_FAILURE);
    }

    int i;

    pthread_t *threads = (pthread_t *)malloc(sizeof(pthread_t) * threads_count);
    for(i = 0; i < threads_count; i++)
    {
        if(*(server_data.inf_mode))
            printf("Creating thread %d\n", i);

        int error = pthread_create(&(threads[i]), NULL, Broadcast, (void*)(&tasks/*pipe_read_fd*/));

        if(error)
            printf("Thread creation error!\n");
    }

    while(!*(server_data.finish))
    {
        // Блокирование до готовности одного или нескольких дескрипторов
        int nfds = epoll_wait(efd, events, MAX_EPOLL_EVENTS, /*timeout*/1000);//когда наступает хотя бы одно событие, функция возвращает число наступивших событий, а их структуры записывает в events
        if(nfds < 1)
            continue;

        //Вывод списка клиентов
        if(*(server_data.inf_mode))
        {
            pthread_mutex_lock(&list_mutex);
            printf("========================Connected clients========================\n");
            struct ListElement *element = list.first;
            while(element != NULL)
            {
                printf("client %d\n", element->value);
                element = element->next;
            }
            pthread_mutex_unlock(&list_mutex);
        }

        int n;
        for (n = 0; n < nfds; ++n)
        {
            if (events[n].data.fd == listenfd)// Готов слушающий дескриптор
            {
                client = sizeof(cliaddr);
                int connfd = accept(listenfd, (struct sockaddr*) &cliaddr, &client); //принять запрос на соединение от клиента
                if (connfd < 0)
                {
                    perror("accept");
                    continue;
                }


                if (events_count == MAX_EPOLL_EVENTS-1)// Недостаточно места в массиве ожидания, закрываем соединение
                {
                    printf("Event array is full\n");
                    close(connfd);
                    continue;
                }

                // Добавление клиентского дескриптора в массив ожидания
                fcntl(connfd, F_SETFL, O_NONBLOCK); //назначение сокета неблокирующим
                connev.data.fd = connfd;
                connev.events = EPOLLIN /*есть данные для чтения*//*| EPOLLOUT /*готов для записи*//*| EPOLLET/*edge-triggered*/ | EPOLLRDHUP/*сокет клиента закрыл соединение*/;
                if (!epoll_ctl(efd, EPOLL_CTL_ADD, connfd, &connev) < 0) //добавляем, теперь epoll отслеживает события и для этого сокета
                {
                    perror("Epoll fd add");
                    close(connfd);
                    continue;
                }
                pthread_mutex_lock(&list_mutex);//mutex========================================================================================================================
                AddToList(&list, connfd);// Добавляем сокет в список клиентов
                pthread_mutex_unlock(&list_mutex);//mutex========================================================================================================================

                ++events_count;
            }
            // Готов клиентский дескриптор
            else
            {
                // Выполням работу с дескриптором
                int fd = events[n].data.fd;//получаем дескриптор из структур epoll_event массива events

                // новое задание
                if (events[n].events & EPOLLIN)// Поступили данные от клиента, читаем их
                {
                    char buf[sizeof(struct Message)];
                    int bytes_read = 0;
                    int bytes_left = sizeof(struct Message);

                    while(bytes_left > 0 && !(*(server_data.finish)))
                    {
                        int bytes = recv(fd, buf + bytes_read, bytes_left, MSG_WAITALL);
                        if(bytes > 0)
                        {
                            bytes_read += bytes;
                            bytes_left -= bytes;
                            if(*(server_data.inf_mode))
                                printf("bytes_read: %d bytes_left: %d\n", bytes_read, bytes_left);
                        }

                        if(bytes == 0) // Соединение разорвано, удаляем сокет из epoll и списка
                        {
                            epoll_ctl(efd, EPOLL_CTL_DEL, fd, &connev);
                            --events_count;
                            //perror("recv");

                            pthread_mutex_lock(&list_mutex);//mutex========================================================================================================================
                            if(*(server_data.inf_mode))
                                printf("deleing client: %d \n", fd);
                            close(fd);
                            RemoveFromList(&list, fd);
                            pthread_mutex_unlock(&list_mutex);//mutex========================================================================================================================

                            break;
                        }
                    }
                    if(*(server_data.inf_mode))
                        printf("Read %d of %d bytes.\n", bytes_read, sizeof(struct Message));

                    if (bytes_left > 0)
                    {
                        //printf("continue\n");
                        continue;
                    }
                    //Заполняем задание
                    struct QUEUE_TYPE task;
                    task.finish = false;
                    task.clientfd = fd;
                    task.message = *((struct Message *)buf);
                    task.message_size = bytes_read;
                    task.clients = &list;
                    pthread_mutex_lock(&tasks_mutex);//mutex========================================================================================================================
                    AddToQueue(&tasks, task);
                    //++message_count;
                    semop(semid, &sop_unlock, 1);
                    if(*(server_data.inf_mode))
                    {
                        PrintMessage(task.message);//exploit----------------------------------------------------------------------------------------
                        ++message_count;
                        printf("Printing finished %d\n", message_count);
                    }
                    pthread_mutex_unlock(&tasks_mutex);//mutex========================================================================================================================
                }

                /*if (events[n].events & EPOLLOUT)
                {
                    do_write(fd);
                }*/

                if (events[n].events & EPOLLRDHUP)//Клиент закрыл соединение на своей стороне, удаляем сокет
                {
                    epoll_ctl(efd, EPOLL_CTL_DEL, fd, &connev);
                    --events_count;

                    pthread_mutex_lock(&list_mutex);//mutex========================================================================================================================
                    if(*(server_data.inf_mode))
                        printf("deleing client: %d \n", fd);
                    close(fd);
                    RemoveFromList(&list, fd);
                    pthread_mutex_unlock(&list_mutex);//mutex========================================================================================================================
                }
            }
        }
    }
    printf("Creating finish tasks\n");

    for(i=0; i<threads_count; i++)
    {
        struct QUEUE_TYPE task;
        task.finish = true;
        pthread_mutex_lock(&tasks_mutex);//mutex========================================================================================================================
        AddToQueue(&tasks, task);
        semop(semid, &sop_unlock, 1);
        pthread_mutex_unlock(&tasks_mutex);//mutex========================================================================================================================
    }
    printf("Finish tasks created\n");


    void *status;

    for(i=0; i<threads_count; i++)//Waiting for threads
    {
        pthread_join(threads[i], &status);
    }
    printf("All threads joined\n");

    pthread_mutex_lock(&list_mutex);
    struct ListElement *element = list.first;
    while(element != NULL)
    {
        int fd = element->value;
        epoll_ctl(efd, EPOLL_CTL_DEL, fd, &connev);
        --events_count;
        close(fd);
        element = element->next;
    }
    pthread_mutex_unlock(&list_mutex);
    close(listenfd);
    printf("All sockets closed\n");


    free(threads);

    ClearList(&list);

    printf ("Server stopped\n");

    return NULL;
}


int main(int argc, char *argv[])
{
    pthread_mutex_init(&list_mutex, NULL);
    pthread_mutex_init(&tasks_mutex, NULL);

    struct ServerData data;
    bool finish = false;
    bool inf_mode = false;
    data.finish = &finish;
    data.inf_mode = &inf_mode;
    data.threads_count = atoi(argv[1]);

    pthread_t thread;
    int error = pthread_create(&thread, NULL, Server, (void*)(&data));

    if(error)
        printf("Server thread creation error!\n");

    while(!finish)
    {
        char command[5];
        char *pos;
        fgets(command, sizeof(command), stdin);
        if ((pos = strchr(command, '\n')) != NULL)
            *pos = '\0';
        if(strcmp(command, "stop") == 0)
        {
            finish = true;
        }
        else if(strcmp(command, "inf") == 0)
        {
            inf_mode = !inf_mode;
        }
    }

    void *status;
    pthread_join(thread, &status);


    pthread_mutex_destroy(&list_mutex);
    pthread_mutex_destroy(&tasks_mutex);

    return 0;
}
