#include <stdio.h>
#include <stdlib.h>


int main (int argc, char **argv){

    FILE *file = fopen(argv[1],"r");

    int N = 1, M = 1, j = 1;
    char c, map[1002][1002];

    map[1][0] = 'X';

    while((c = getc(file)) != EOF){
        if(c!= '\n'){
            map[N][j++] = c;
        }
        else {
            M = j;
            map[N][j] = 'X';
            N++;
            map[N][0] = 'X';
            j = 1;
        }
    }

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


    fclose(file);
    return 0;
}
