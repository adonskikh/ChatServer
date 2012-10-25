#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <fcntl.h>
#include <sys/epoll.h>
#include <stdbool.h>


struct Message
{
    char sender[32];
    char text[1024];
    char text1[32000];
    char text2[30000];
    /*char text3[32000];
    char text4[32000];
    char text5[32000];
    char text6[32000];
    char text7[32000];
    char text8[32000];*/
};

//char buf[sizeof(text)];

const int MAX_EPOLL_EVENTS = 1;

int main(int argc, char *argv[])
{
    int i = 0;
    //int count = 3;
    int pid;
    /*for (i = 0; i < count - 1; i++)
    {
        pid = fork();
        if(pid == 0)//Child
            break;
    }*/

    int sock;
    struct sockaddr_in addr;

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if(sock < 0)
    {
        perror("socket");
        exit(1);
    }


    addr.sin_family = AF_INET;
    addr.sin_port = htons(3425); // порт
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    if(connect(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0)
    {
        perror("connect");
        exit(2);
    }
    fcntl(sock, F_SETFL, O_NONBLOCK); //назначение сокета неблокирующим

    // Создание дескриптора epoll
    int efd = epoll_create(MAX_EPOLL_EVENTS);

    // Добавляем дескриптор слушающего сокета в массив ожидания событий
    struct epoll_event server_events;
    server_events.events = EPOLLIN /*есть данные для чтения*/| EPOLLPRI/*есть срочные данные для чтения*/| EPOLLOUT /*готов для записи*/ | EPOLLET/*Edge-Triggered*/;//флаги отслеживаемых событий
    server_events.data.fd = sock;
    if (epoll_ctl(efd, EPOLL_CTL_ADD, sock, &server_events) < 0) //теперь epoll следит за наступлением указанных событий для сокета sock
    {
        perror("Epoll fd add");
        return -1;
    }

    struct epoll_event events[MAX_EPOLL_EVENTS]; //структуры epoll_event для всех наступивших событий

    struct Message message;
    char *buf = (char *)malloc(sizeof(message));

    int count = atoi(argv[1]);
    bool disconnected;
    while(i < count && !disconnected)
    {
        sleep(5);
        int size;        

        int nfds = epoll_wait(efd, events, MAX_EPOLL_EVENTS, -1);

        int n;
        for (n = 0; n < nfds; ++n)
        {
            struct Message message;
            // Выполням работу с дескриптором
            int fd = events[n].data.fd;//получаем дескриптор из структур epoll_event массива events


            if (events[n].events & EPOLLOUT)//сокет готов для записи
            {
                size = sprintf(message.text, "%s", "Hello! This is ");
                size +=  sprintf(message.text + size, "%i", getpid());
                size +=  sprintf(message.text + size, "%s", "\n");
                size = sprintf(message.sender, "%i", getpid());

                buf = (char *)(&message);

                printf("Process sending message: %s\n", message.text);

                int bytes_sent = 0;
                int bytes_left = sizeof(message);

                while(bytes_left > 0)
                {
                    //printf("addr = %d\n", (int)(&(inf.message) + bytes_read));
                    int bytes = send(fd, buf + bytes_sent, bytes_left, 0);
                    if(bytes > 0)
                    {
                        bytes_sent += bytes;
                        bytes_left -= bytes;
                        printf("bytes_sent = %d\n", bytes_sent);
                        printf("bytes_left = %d\n", bytes_left);
                    }
                    if(bytes < 0)
                        perror("send");

                    if(bytes == 0) // Соединение разорвано
                    {
                        disconnected = true;
                        /*epoll_ctl(efd, EPOLL_CTL_DEL, fd, 0);
                        close(fd);*/
                        break;
                    }
                }
                printf("Sent %d of %d bytes\n", bytes_sent, sizeof(message));
                i++;
            }



            if (events[n].events & EPOLLIN)// Поступили данные от сервера, читаем их
            {
                int bytes_read = 0;
                int bytes_left = sizeof(message);

                while(bytes_left > 0)
                {
                    //printf("addr = %d\n", (int)(&(inf.message) + bytes_read));
                    int bytes = recv(fd, buf + bytes_read, bytes_left, 0);
                    if(bytes > 0)
                    {
                        bytes_read += bytes;
                        bytes_left -= bytes;
                        printf("bytes_read = %d\n", bytes_read);
                        printf("bytes_left = %d\n", bytes_left);
                    }
                    if(bytes < 0)
                        perror("recv");/*
                        printf("n = %d\n", n);*/

                    if(bytes == 0) // Соединение разорвано, удаляем сокет из epoll и множества
                    {
                        disconnected = true;
                        /*epoll_ctl(efd, EPOLL_CTL_DEL, fd, 0);
                        close(fd);*/
                        break;
                    }
                }
                if (bytes_left > 0)
                {
                    printf("Reading error\n");
                    //disconnected = true;
                    continue;
                }
                else
                {
                    message = *((struct Message *)buf);
                    printf("\n>>%s: %s\n", message.sender, message.text);
                }
            }

            if (events[n].events & EPOLLRDHUP)//Клиент закрыл соединение на своей стороне, удаляем сокет
            {
                disconnected = true;
                /*epoll_ctl(efd, EPOLL_CTL_DEL, fd, 0);
                close(fd);*/
            }

        }

        //printf("Process sending message: %s\n", message.text);
        //int n = send(sock, &message, sizeof(message), 0);
        //recv(sock, &message, sizeof(message), 0);

        /*size = sprintf(text, "%i", getpid());
            size += sprintf(text + size, "%s", " recieved message: ");
            size += sprintf(text + size, "%s", buf);
            printf(text);*/
        //printf("%s: %s\n", message.sender, message.text);
    }

    free(buf);
    close(sock);

    return 0;
}
