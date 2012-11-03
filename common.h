#define NAME_LENGTH 32
#define MESSAGE_LENGTH 1024

struct Message
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
