#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include<pthread.h>
#include<stdbool.h>
#include <fcntl.h>
#include <string.h>
#include <time.h>
#include "common.h"

struct QUEUE_TYPE
{
    char sender[NAME_LENGTH];
    char text[MESSAGE_LENGTH];
    time_t send_time;/*
    char text1[32000];
    char text2[30000];*/
    /*char text3[32000];
    char text4[32000];
    char text5[32000];
    char text6[32000];
    char text7[32000];
    char text8[32000];*/
};

#include "queue.h"


struct Inf
{
    int socket;
    bool *finish;
    bool *paused;
};

int message_count;


void* Reader(void *data)
{
    struct Queue queue;
    InitializeQueue(&queue);
    struct Inf inf = *((struct Inf *)data);
    struct Message message;
    while(!(*(inf.finish)))
    {
        char buf[sizeof(message)];
        int bytes_read = 0;
        int bytes_left = sizeof(message);

        while(bytes_left > 0 && !(*(inf.finish)))
        {
            if(!(*(inf.paused)))
            {
                //printf("q_count = %d!\n", queue.count);
                while(!(QueueIsEmpty(&queue)))
                {
                    struct QUEUE_TYPE mes = GetFromQueue(&queue);
                    time_t curr_time = time(NULL);
                    struct tm *timeinfo;
                    timeinfo = localtime ( &curr_time );
                    //printf ( "Current local time and date: %s",  asctime (timeinfo));

                    printf("[#%d][%s]: %s [delay = %d sec]\n", ++message_count, mes.sender, mes.text, (int)(curr_time - mes.send_time));
                }
            }
            int bytes = recv(inf.socket, buf + bytes_read, bytes_left, 0);
            if(bytes > 0)
            {
                bytes_read += bytes;
                bytes_left -= bytes;
                //printf("bytes_read: %d bytes_left: %d\n", bytes_read, bytes_left);
            }
            else if(bytes == 0)
            {
                printf("Server closed connection. Press any button to continue.\n");
                (*(inf.finish)) = true;
                break;
            }
        }

        if (bytes_left > 0)
        {
            continue;
        }

        message = *((struct Message *)(buf));

        if(!(*(inf.paused)))
        {
            time_t curr_time = time(NULL);
            struct tm *timeinfo;
            timeinfo = localtime ( &curr_time );
            //printf ( "Current local time and date: %s",  asctime (timeinfo));

            printf("[#%d][%s]: %s [delay = %d sec]\n", ++message_count, message.sender, message.text, (int)(curr_time - message.send_time));
        }
        else
        {
            //printf("Adding message\n");
            AddToQueue(&queue, *((struct QUEUE_TYPE*)(&message)));
        }
    }
    pthread_exit(NULL);
}

int main(/*int argc, char *argv[]*/)
{
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

    pthread_t thr;

    struct Inf inf;
    inf.socket = sock;
    bool finish = false;
    bool paused = true;
    inf.finish = &finish;
    inf.paused = &paused;

    if(pthread_create(&thr, NULL, Reader, (void*)(&inf)))
        printf("Thread creation error!\n");


    struct Message message;

    printf("Please, enter your name: ");
    fgets(message.sender, sizeof(message.sender), stdin);
    char *pos;
    if ((pos = strchr(message.sender, '\n')) != NULL)
        *pos = '\0';
    printf("Hello, %s.\nPress 'Enter' to start writing message.\nPress 'Enter' again to send it.\n", message.sender);

    paused = false;

    //int count = atoi(argv[1]);

    while(!finish)
    {
        if(paused)
        {

            printf("[You]: ");
            fgets(message.text, sizeof(message.text), stdin);
            if ((pos = strchr(message.text, '\n')) != NULL)
                *pos = '\0';
            message.send_time = time(NULL);

            //printf(">Process sending message: %s<\n", message.text);
            int n = send(sock, &message, sizeof(message), 0);

            paused = false;
            printf("[working]\n");

            if (n == 0)
            {
                printf("Server closed connection\n");
                finish = true;
                break;
            }
        }
        else
        {
            char command[5];
            fgets(command, sizeof(command), stdin);
            if ((pos = strchr(command, '\n')) != NULL)
                *pos = '\0';
            paused = true;
            printf("[paused]");
            if(strcmp(command, "x") == 0)
            {
                finish = true;
            }
        }
    }

    void *status;
    pthread_join(thr, &status);

    close(sock);

    return 0;
}
