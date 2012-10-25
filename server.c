#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
//#include <algorithm> //для max
#include <sys/epoll.h>
#include <set>
#include<pthread.h>
using namespace std;


pthread_mutex_t mutex;

struct Message
{
    char sender[32];
    char text[1024];
    char text1[32000];
    char text2[30000];
};

struct Task
{
    int clientfd;
    set<int> *clients;
    struct Message message;
    int message_size;
    bool finish;
};

void* ThreadProc(void *data)
{
    int pipe_read_fd = *((int *)data);
    struct Task task;
    while(1)
    {
        read(pipe_read_fd, &task, sizeof(Task));
        if (task.finish)
            break;
        for(set<int>::iterator it = (*(task.clients)).begin(); it != (*(task.clients)).end(); it++)//отправляем сообщение всем подключенным клиентам, кроме отправителя
        {
            //printf("client: %d\n", *it);
            if((*it) != task.clientfd)
                send(*it, &(task.message), task.message_size, 0);
        }
    }
    pthread_exit(NULL);
}


int main()
{
    int listenfd;
    struct sockaddr_in addr;
    int threads_count = 4;
    //char buf[1024];

    const int MAX_EPOLL_EVENTS = 100;
    const int BACK_LOG = 100;

    listenfd = socket(AF_INET, SOCK_STREAM, 0); //создание internet-сокета (потокового) (это сокет для приема запросов на соединение от клиентов)
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

    set<int> clients; //множество дескрипторов сокетов подключенных клиентов
    clients.clear();



    // Создание дескриптора epoll
    int efd = epoll_create(MAX_EPOLL_EVENTS);

    // Добавляем дескриптор слушающего сокета в массив ожидания событий
    struct epoll_event listenev;
    listenev.events = EPOLLIN /*есть данные для чтения*/| EPOLLPRI/*есть срочные данные для чтения*/ | EPOLLET/*Edge-Triggered*/;//флаги отслеживаемых событий
    listenev.data.fd = listenfd;
    if (epoll_ctl(efd, EPOLL_CTL_ADD, listenfd, &listenev) < 0) //теперь epoll следит за наступлением указанных событий для сокета listenfd
    {
        perror("Epoll fd add");
        return -1;
    }

    socklen_t client;
	
    struct epoll_event events[MAX_EPOLL_EVENTS]; //структуры epoll_event для всех наступивших событий
    struct epoll_event connev;
    struct sockaddr_in cliaddr; //структура для сохранения в ней адреса подключаемого клиента

    int events_count = 1; //число сокетов, для которых отслеживаются события

    int pfd[2];

    if (pipe(pfd) == -1)// канал для заданий
    {
        perror("Pipe creation error\n");
        exit(EXIT_FAILURE);
    }

    int pipe_read_fd = pfd[0];
    int pipe_write_fd = pfd[1];

    int i;


    pthread_mutex_init(&mutex, NULL);

    pthread_t *threads = (pthread_t *)malloc(sizeof(pthread_t) * threads_count);
    for(i = 0; i < threads_count; i++)
    {
        printf("Creating thread %d\n", i);

        int error = pthread_create(&(threads[i]), NULL, ThreadProc, (void*)(&pipe_read_fd));

        if(error)
            printf("Thread creation error!\n");
    }	
    //Работу сервера (этот цикл while) вынести в отдельную нить/процесс, а главная нить будет в бесконечном цикле спрашивать у пользователя команды (информация о сервере, завершение работы и т.п.)
    while(1)
    {
        // Блокирование до готовности одного или нескольких дескрипторов
        int nfds = epoll_wait(efd, events, MAX_EPOLL_EVENTS, -1);//когда наступает хотя бы одно событие, функция возвращает число наступивших событий, а их структуры записывает в events

        //Вывод списка клиентов
        printf("====================================================\n");
        for(set<int>::iterator it = clients.begin(); it != clients.end(); it++)
        {
            printf("client: %d\n", *it);
        }


        for (int n = 0; n < nfds; ++n)
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
                connev.events = EPOLLIN /*есть данные для чтения*//*| EPOLLOUT /*готов для записи*/| EPOLLET/*edge-triggered*/ | EPOLLRDHUP/*сокет клиента закрыл соединение*/;
                if (!epoll_ctl(efd, EPOLL_CTL_ADD, connfd, &connev) < 0) //добавляем, теперь epoll отслеживает события и для этого сокета
                {
                    perror("Epoll fd add");
                    close(connfd);
                    continue;
                }
                clients.insert(connfd); // Добавляем сокет во множество клиентов

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
                    char buf[sizeof(Message)];
                    int bytes_read = 0;
                    int bytes_left = sizeof(Message);

                    while(bytes_left > 0)
                    {
                        //printf("addr = %d\n", (int)(&(inf.message) + bytes_read));
                        int bytes = recv(fd, buf + /*&(inf.message)*/ + bytes_read, bytes_left, 0);
                        if(bytes > 0)
                        {
                            bytes_read += bytes;
                            bytes_left -= bytes;
                            printf("bytes_read: %d bytes_left: %d\n", bytes_read, bytes_left);
                        }
                        if(bytes < 0)
                            perror("recv");/*
                        printf("n = %d\n", n);*/

                        if(bytes == 0) // Соединение разорвано, удаляем сокет из epoll и множества
                        {
                            epoll_ctl(efd, EPOLL_CTL_DEL, fd, &connev);
                            --events_count;
                            close(fd);
                            clients.erase(fd);
                            break;
                        }
                    }
                    if (bytes_left > 0)
                    {
                        printf("Reading error\n");
                        continue;
                    }

                    printf("Read %d of %d bytes.\n", bytes_read, sizeof(Message));
                    //заполняем задание
                    struct Task inf;
                    inf.finish = false;
                    inf.clientfd = fd;
                    inf.message = *((struct Message *)(/*(void *)*/buf));
                    inf.message_size = bytes_read;
                    inf.clients = &clients;
                    write(pipe_write_fd, &inf, sizeof(Task));//записываем задание в канал
                }

                /*if (events[n].events & EPOLLOUT)
                {
                    do_write(fd);
                }*/

                if (events[n].events & EPOLLRDHUP)//Клиент закрыл соединение на своей стороне, удаляем сокет
                {                    
                    epoll_ctl(efd, EPOLL_CTL_DEL, fd, &connev);
                    --events_count;
                    close(fd);
                    clients.erase(fd);
                    continue;
                }
            }
        }
    }

    void *status;
    for(i=0; i<thread_count; i++)//Waiting for threads
    {
        pthread_join(threads[i], &status);
    }
    free(threads);

    pthread_mutex_destroy(&mutex);

    return 0;
}
