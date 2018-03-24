#include <stdio.h>
#include <stdlib.h>

typedef struct Node node;
node *insertEnd(node **head, int i, int j, char c);     /* insert node to end of list and returns pointer of last node */
void deleteNode(node **head, int i, int j, char c);     /* delete a node from list */
void printList(node *n);                                /* prints a list of nodes */
void printMap(char map[1002][1002], int N, int M);      /* prints the map */

typedef struct Node {
    int i;
    int j;
    char c;
    struct Node *next;
}node;


int main (int argc, char **argv){


    if (argc < 2) {
        printf("Usage: ./doomsday [input.file]\n");
        exit(1);
    }

    FILE *file = fopen(argv[1],"r");

    int N = 1, M = 1, j = 1, time = 0, end = 0, right = 0, left = 0, up = 0, down = 0, flag=0;
    char c, map[1002][1002];

    node *head = NULL;
    node *last = NULL;

    map[1][0] = 'X';

    while((c = getc(file)) != EOF){
        if(c!= '\n'){
            map[N][j++] = c;
            if(c!='.' && c!='X'){
                last = insertEnd(&head,N,j-1,c);
            }
        }
        else {
            M = j;
            map[N][j] = 'X';
            N++;
            map[N][0] = 'X';
            j = 1;
        }
    }

    fclose(file);

    for(int k = 0; k<=M; k++){
        map[0][k] = 'X';
        map[N][k] = 'X';
    }


    node *temp = head;
    node *newList = NULL;
    node *tempLast = NULL;

    while(temp!= NULL){

        right = left = up = down = 0;

        if(map[temp->i][temp->j+1] == '.'){                 /* go right */
            map[temp->i][temp->j+1] = temp->c;
            right = 1;
        }
        else if(map[temp->i][temp->j+1] != 'X' && map[temp->i][temp->j+1] != temp->c){      /* matter and andimatter conflict */
            map[temp->i][temp->j+1] = '*';
            end = 1;
        }

        if(map[temp->i][temp->j-1] == '.'){                 /* go left */
            map[temp->i][temp->j-1] = temp->c;
            left = 1;
        }
        else if(map[temp->i][temp->j-1] != 'X' && map[temp->i][temp->j-1] != temp->c){      /* matter and andimatter conflict */
            map[temp->i][temp->j-1] = '*';
            end = 1;
        }

        if(map[temp->i-1][temp->j] == '.'){                 /* go up */
            map[temp->i-1][temp->j] = temp->c;
            up = 1;
        }
        else if(map[temp->i-1][temp->j] != 'X' && map[temp->i-1][temp->j] != temp->c){      /* matter and andimatter conflict */
            map[temp->i-1][temp->j] = '*';
            end = 1;
        }

        if(map[temp->i+1][temp->j] == '.'){                 /* go down */
            map[temp->i+1][temp->j] = temp->c;
            down = 1;
        }
        else if(map[temp->i+1][temp->j] != 'X' && map[temp->i+1][temp->j] != temp->c){      /* matter and andimatter conflict */
            map[temp->i+1][temp->j] = '*';
            end = 1;
        }

        /* Update the new node list */

        if(right) tempLast = insertEnd(&newList,temp->i,temp->j+1,temp->c);
        if(left) tempLast = insertEnd(&newList,temp->i,temp->j-1,temp->c);
        if(up) tempLast = insertEnd(&newList,temp->i-1,temp->j,temp->c);
        if(down) tempLast = insertEnd(&newList,temp->i+1,temp->j,temp->c);

        /* Delete the node just examinated */
        deleteNode(&head,temp->i,temp->j,temp->c);

        /* If the examination of list of current time ends increase time and continue to new list
         * also check if the end of the world come
         * else continue to the examination of next node
         */

        if(temp == last) {
            time++;
            if(end) {
                flag = 1;
                break;
            }
            if (newList != NULL) {
                head = newList;
                temp = head;
                last = tempLast;
                newList = NULL;
            }
            else break;
        }
        else temp = temp->next;
    }

    if (flag) printf("%d\n",time);
    else printf("the world is saved\n");
    printMap(map,N,M);

    return 0;
}

node *insertEnd(node **head, int i, int j, char c){

    node *new = (node *)malloc(sizeof(node));

    new->i = i;
    new->j = j;
    new->c = c;
    new->next = NULL;

    if(*head == NULL){
        *head = new;
        return new;
    }

    node *last = *head;

    while(last->next != NULL){
        last = last->next;
    }
    last->next = new;

    return new;
}

void deleteNode(node **head, int i, int j, char c){

    node *temp = *head, *prev = NULL;

    if (temp != NULL && (temp->i == i && temp->j == j && temp->c == c)){
        *head = temp->next;
        free(temp);
        return ;
    }


    while(temp != NULL){
        if(temp->i == i && temp->j == j && temp->c == c) break;
        prev = temp;
        temp = temp->next;
    }

    if (temp == NULL) return ;


    prev->next = temp->next;

    free(temp);

    return ;

}

void printList(node *n){
    while (n != NULL){
        printf("i = %d, j = %d, c = %c \n", n->i, n->j, n->c);
        n = n->next;
    }
}

void printMap(char map[1002][1002], int N, int M){

    for(int i = 1; i<N; i++){
        for(int k = 1; k<M; k++){
            putchar(map[i][k]);
        }
        putchar('\n');
    }
}

