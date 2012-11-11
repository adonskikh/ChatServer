#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include<pthread.h>
#include<stdbool.h>
#include <fcntl.h>
#include <time.h>
#include <errno.h>
#include <string.h>
#include "common.h"

struct Inf
{
    int socket;
    bool *finish;
};

int message_count;

void* Reader(void *data)
{
    struct Inf inf = *((struct Inf *)data);
    struct Message message;
    while(!(*(inf.finish)))
    {
        char buf[sizeof(message)];
        int bytes_read = 0;
        int bytes_left = sizeof(message);

        while(bytes_left > 0 && !(*(inf.finish)))
        {
            int bytes = recv(inf.socket, buf + bytes_read, bytes_left, MSG_WAITALL | MSG_DONTWAIT);
            if(bytes > 0)
            {
                bytes_read += bytes;
                bytes_left -= bytes;
                //printf("%d bytes_read: %d bytes_left: %d\n", getpid(), bytes_read, bytes_left);
            }
            else if(bytes == 0)
            {
                printf("Server closed connection.\n");
                (*(inf.finish)) = true;
                break;
            }
        }

        if (bytes_read < sizeof(message))
        {
            continue;
        }

        if(!(*(inf.finish)))
        {
            message = *((struct Message *)(buf));
            time_t curr_time = time(NULL);
            struct tm *timeinfo;
            timeinfo = localtime ( &curr_time );
            //printf ( "Current local time and date: %s",  asctime (timeinfo));

            printf("[%s->%d, delay = %d sec]: %s\n", message.sender, getpid(), (int)(curr_time - message.send_time), message.text);

        }

    }
    pthread_exit(NULL);
}

int Sender(int sock, int count, int sleep_time)
{
    int i = 0;
    struct sockaddr_in addr;

    //printf("sock = %d\n", sock);
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
    inf.finish = &finish;

    if(pthread_create(&thr, NULL, Reader, (void*)(&inf)))
        printf("Thread creation error!\n");

    sleep(rand()%10);

    //int count = atoi(argv[1]);
    while(i < count && !finish)
    {
        sleep(sleep_time);
        struct Message message;
        int size;
        size = sprintf(message.text, "%s", "Hello! This is ");
        size +=  sprintf(message.text + size, "%i", getpid());
        //size +=  sprintf(message.text + size, "%s", "\n");

        size = sprintf(message.sender, "%i", getpid());

        message.send_time = time(NULL);
        int bytes;
        int bytes_sent = 0;

        while(bytes_sent < sizeof(message) && !finish)
        {
            //printf("%d writing to %d\n", id, element->value);
            bytes = send(sock, &(message) + bytes_sent, sizeof(message) - bytes_sent, MSG_NOSIGNAL);
            //printf("%d wrote\n", id);
            if(bytes > 0)
            {
                bytes_sent+=bytes;
                //printf("bytes_sent = %d\n", bytes_sent);
            }
        }

        i++;
        message_count++;
    }

    finish = true;
    void *status;
    //printf("Joining reader\n");
    pthread_join(thr, &status);
    //printf("Joined reader\n");
    printf("%d sent %d messages.\n", getpid(), message_count);
    close(sock);

    return 0;
}

int main(int argc, char *argv[])
{
    int proc_count = atoi(argv[3]);
    int j;
    int processes[proc_count];
    printf("proc_count = %d\n", proc_count);
    for(j = 0; j < proc_count; j++)
    {
        int sock = socket(AF_INET, SOCK_STREAM, 0);
        processes[j] = fork();
        if (processes[j] == 0)
        {
            Sender(sock, atoi(argv[1]), atoi(argv[2]));
            exit(0);
        }
    }

    int status;
    for(j=0; j<proc_count; j++)//Waiting for processes
    {
        waitpid(processes[j], status, 0);
        //printf("Process %d finished!\n", j);
    }

    return 0;
}
