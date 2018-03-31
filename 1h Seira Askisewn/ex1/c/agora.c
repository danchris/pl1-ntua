#include <stdio.h>
#include <stdlib.h>


long int findlcm (long int a, long int b);
int gcd (long int a, long int b);

int main (int argc, char **argv){

    if (argc < 2) {
        printf("Usage: ./agora [input.file]\n");
        exit(1);
    }

    FILE *file = fopen(argv[1],"r");

    int N;
    if(fscanf(file, "%d", &N)==0){
        printf("Failed to read\n");
        fclose(file);
        exit(1);
    }

    int i = 0;
    int *villages = malloc(N*sizeof(int));
    long int *runningLcm = malloc(N*sizeof(long int)), *runningLcmReverse = malloc(N*sizeof(long int));


    /* Read from file
     * and store data to
     * villages int array
     */

    while((fscanf(file,"%d", &villages[i++])) == 1);

    fclose(file);

    /*
     * Now we will compute
     * runnings LCM
     *
     */

    runningLcm[0] = villages[0];
    runningLcmReverse[N-1] = villages[N-1];

    for(i=1;i<N;i++){
        runningLcm[i] = findlcm(runningLcm[i-1],villages[i]);
        runningLcmReverse[N-i-1] = findlcm(runningLcmReverse[N-i],villages[N-i-1]);
    }

    long int min = runningLcm[N-1], temp, tempM = -1;
    int v = 0, flag = 0, tempV = 0;

    for(i=1; i<N-1; i++){
        if(runningLcm[i-1] == runningLcmReverse[i+1]) {
            tempV = i+1;
            tempM = runningLcm[i-1];
            flag++;
        }
        else {
            temp = findlcm(runningLcm[i-1],runningLcmReverse[i+1]);
            if(temp<min && temp>0){
                min = temp;
                v = i+1;
            }
        }
    }

    if(tempM!=-1 && flag==1) printf("%ld %d\n", tempM, tempV);
    else printf("%ld %d\n", min, v);

    free(villages);
    free(runningLcm);
    free(runningLcmReverse);

    return 0;
}

int gcd(long int a, long int b){


    if (b==0) return a;

    return gcd(b,a%b);
}


long int findlcm (long int a, long int b){

    return  a*(b/gcd(a,b));
}

