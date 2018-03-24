#include <stdio.h>
#include <stdlib.h>

typedef struct Node node;
void insertEnd(node **head, int i, int j, char c);
void deleteNode(node **head, int i, int j, char c);
void printList(node *n);

typedef struct Node {
    int i;
    int j;
    char c;
    struct Node *next;
}node;


int main (int argc, char **argv){

    FILE *file = fopen(argv[1],"r");

    int N = 1, M = 1, j = 1;
    char c, map[1002][1002];

    node *head = NULL;

    map[1][0] = 'X';

    while((c = getc(file)) != EOF){
        if(c!= '\n'){
            map[N][j++] = c;
            if(c!='.' && c!='X'){
                insertEnd(&head,N,j,c);
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

    for(int i = 0; i<=N; i++){
        for(int k = 0; k<=M; k++){
            putchar(map[i][k]);
       }
        putchar('\n');
    }
    printList(head);



    return 0;
}

void insertEnd(node **head, int i, int j, char c){

    node *new = (node *)malloc(sizeof(node));

    new->i = i;
    new->j = j;
    new->c = c;
    new->next = NULL;

    if(*head == NULL){
        *head = new;
        return;
    }

    node *last = *head;

    while(last->next != NULL){
        last = last->next;
    }
    last->next = new;

    return;
}

void deleteNode(node **head, int i, int j, char c){

    node *temp = *head, *prev = NULL;

    if (temp != NULL && (temp->i == i && temp->j == j && temp->c == c)){
        *head = temp->next;
        free(temp);
        return ;
    }

    while(temp != NULL && (temp->i != i && temp->j != j && temp->c != c)){
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
