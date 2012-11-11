#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <sys/stat.h>


pthread_mutex_t mutexWrArray;

struct thread_data
{
    int first_index;
    int last_index;
    int cur_index;
    int *arr;
    int *new_arr;
    int *global_count;
    int count;
};

int ReadFromFile(char *input_file, char **arr_pointer)
{
    FILE *input;

    if((input=fopen(input_file,"rb"))==0)
    {
        printf("Can't open input file.\n");
        exit(-1);
    }

    struct stat file_stat;
    stat(input_file, &file_stat);
    int count = file_stat.st_size/sizeof(char);

    //printf("count = %d\n\n", count);

    int i = 0;
    char *arr = malloc(count * sizeof(char));

    while (fread(&arr[i++], sizeof(char), count, input)){}

    *arr_pointer = arr;
    fclose(input);
    return count;
}


void WriteToFile(char *output_file, char *arr, int count)
{
    FILE *output;
    int i;

    if((output=fopen(output_file,"w"))==0)
    {
        puts ("Can't open output file.");
        exit(-1);
    }

    for (i=0; i<count; i++)
    {
        fprintf(output, "\\x%x\n", arr[i]);
    }
    fclose(output);
}


int main(int argc, char *argv[])
{
    char *arr = NULL;

    int count = ReadFromFile(argv[1], &arr);

    WriteToFile(argv[2], arr, count);

    free(arr);

    return 0;
}

