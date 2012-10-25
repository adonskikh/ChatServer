#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include<pthread.h>
#include<stdbool.h>
#include <fcntl.h>


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

struct Inf
{
    int socket;
    bool *finish;
};

//char buf[sizeof(text)];

void* ThreadProc(void *data)
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
            int bytes = recv(inf.socket, buf + bytes_read, bytes_left, 0);
            if(bytes > 0)
            {
                bytes_read += bytes;
                bytes_left -= bytes;
                printf("bytes_read: %d bytes_left: %d\n", bytes_read, bytes_left);
            }
        }

        if (bytes_left > 0)
        {
            continue;
        }

        message = *((struct Message *)(buf));

        printf("[%s]: %s\n", message.sender, message.text);
    }
    pthread_exit(NULL);
}

int main(int argc, char *argv[])
{
    int i = 0;
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
    inf.finish = &finish;

    if(pthread_create(&thr, NULL, ThreadProc, (void*)(&inf)))
        printf("Thread creation error!\n");


    int count = atoi(argv[1]);
    while(i < count)
    {
        sleep(5);
        struct Message message;
        int size;
        size = sprintf(message.text, "%s", "Hello! This is ");
        size +=  sprintf(message.text + size, "%i", getpid());
        //size +=  sprintf(message.text + size, "%s", "\n");

        size = sprintf(message.sender, "%i", getpid());


        printf(">Process sending message: %s<\n", message.text);
        int n = send(sock, &message, sizeof(message), 0);

        if (n == 0)
        {
            printf("Server closed connection\n");
            break;
        }

        i++;
    }

    finish = true;
    void *status;
    pthread_join(thr, &status);

    close(sock);



    return 0;
}
