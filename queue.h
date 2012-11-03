struct QueueElement
{
    struct QUEUE_TYPE value;
    struct QueueElement *next;
};

struct Queue
{
    int count;
    struct QueueElement *first;
    struct QueueElement *last;
};

bool QueueIsEmpty(struct Queue *queue)
{
    return((queue->count) < 1);
}

void AddToQueue(struct Queue *queue, struct QUEUE_TYPE value)
{
    struct QueueElement *element = malloc(sizeof(struct QueueElement));
    element->value = value;
    element->next = NULL;
    if(QueueIsEmpty(queue))
    {
        queue->first = element;
        queue->last = element;
    }
    else
    {
        queue->last->next = element;
        queue->last = element;
    }
    (queue->count)++;
}

struct QUEUE_TYPE GetFromQueue(struct Queue *queue)
{
    if(!QueueIsEmpty(queue))
    {
        struct QueueElement *element;
        element = queue->first;
        queue->first = element->next;
        (queue->count)--;
        struct QUEUE_TYPE value = element->value;
        free(element);
        return value;
    }
    else
    {
        printf("Queue is empty!\n");
        exit(-1);
    }
}
void InitializeQueue(struct Queue *queue)
{
    queue->count = 0;
    queue->first = NULL;
    queue->last = NULL;
}
