#define NAME_LENGTH 32
#define MESSAGE_LENGTH 1024

struct Message
{
    char sender[NAME_LENGTH];
    char text[MESSAGE_LENGTH];
    time_t send_time;
};
