struct ListElement
{
    int value;
    struct ListElement *next;
};

struct List
{
    int count;
    struct ListElement *first;
    struct ListElement *last;
};

bool ListIsEmpty(struct List *list)
{
    return((list->count) < 1);
}

void AddToList(struct List *list, int value)
{
    struct ListElement *element = malloc(sizeof(struct ListElement));
    element->value = value;
    element->next = NULL;
    if(ListIsEmpty(list))
    {
        list->first = element;
        list->last = element;
    }
    else
    {
        list->last->next = element;
        list->last = element;
    }
    (list->count)++;
}

void RemoveFromList(struct List *list, int value)
{
    //pthread_mutex_lock(&queue_mutex);================================================================================================
    if(!ListIsEmpty(list))
    {
        struct ListElement *element = list->first;
        struct ListElement *found_element = NULL;
        if(element->value == value)
        {
            found_element = element;
            list->first = element->next;
            (list->count)--;
            free(found_element);
        }
        else
            while(element->next != NULL)
            {
                if (element->next->value == value)
                {
                    found_element = element->next;
                    if(found_element == list->last)
                        list->last = element;
                    element->next = found_element->next;
                    (list->count)--;
                    free(found_element);
                    break;
                }
                else
                    element = element->next;
            }
    }
    //pthread_mutex_unlock(&queue_mutex);//=============================================================================================
}

void ClearList(struct List *list)
{
    if(!ListIsEmpty(list))
    {
        struct ListElement *element = list->first;
        struct ListElement *current_element = NULL;
        while(element != NULL)
        {
            current_element = element;
            element = element->next;
            (list->count)--;
            free(current_element);
        }
    }
}

void InitializeList(struct List *list)
{
    list->count = 0;
    list->first = NULL;
    list->last = NULL;
}
