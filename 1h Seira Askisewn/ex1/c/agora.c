#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <inttypes.h>
#include <math.h>


long long int findlcm (long long int a, long long int b);
long long int gcd (long long int a, long long int b);
int cmpfunc (const void * a, const void * b);
int cmpfuncRev (const void * a, const void * b);

int64_t safemult(int64_t a, int64_t b);
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
    long long int *villages = malloc(N*sizeof(long long int)), *runningLcm = malloc(N*sizeof(long long int)), *runningLcmReverse = malloc(N*sizeof(long long int));


    long long int temp;
    while((fscanf(file,"%lli", &villages[i])) == 1) i++;
    runningLcm[0] = villages[0];
    runningLcmReverse[N-1] = villages[N-1];

    for(i=1;i<N;i++){
       runningLcm[i] = temp = findlcm(runningLcm[i-1],villages[i]);
       runningLcmReverse[N-i-1] = findlcm(runningLcmReverse[N-i],villages[N-i-1]);
    }

    long long int max = runningLcmReverse[0];
    long long int min = max;
    int v = 0;

    for(i=0; i<N;i++){
        printf("runningLcm[%d] = %lli runningLcmReverse[%d] = %lli\n", i, runningLcm[i], i, runningLcmReverse[i]);
    }
    printf("---------------------------------\n");

    for(i=1; i<N-1; i++){
        printf("runningLcm[%d] = %lli runningLcmReverse[%d] = %lli\n", i-1, runningLcm[i-1], i+1, runningLcmReverse[i+1]);
        temp = findlcm(runningLcm[i-1],runningLcmReverse[i+1]);
        if(runningLcm[i-1] < runningLcm[i] && runningLcmReverse[i] > runningLcmReverse[i+1]) {
            temp = findlcm(runningLcm[i-1],runningLcmReverse[i+1]);
            printf("temp = %lld\n", temp);
            if(temp<min && temp>0){
                printf("prin = %lld meta = %lld\n", min, temp);
                min = temp;
                v = i+1;
            }
        }
    }

    printf("%lld %d\n", min, v);
    fclose(file);
    free(villages);
    free(runningLcm);
    free(runningLcmReverse);

    return 0;
}

long long int gcd(long long int a, long long int b){


    if (b==0) return a;

    return gcd(b,a%b);
}


long long int findlcm (long long int a, long long int b){


 //   return safemult(a,b) / gcd(a,b);
 long long int ans = (a*b)/gcd(a,b);
 if(ans > 0) return ans;
 return LLONG_MAX + ans/64;
  //  return (ans > 0 ) ? ans : (a/64 * b/64)/gcd(a/64,b/64);
   // return  (a*b)/gcd(a,b) ;
}

int cmpfunc (const void * a, const void * b){
    if( *(long long int*)a - *(long long int*)b < 0 )
        return -1;
    if( *(long long int*)a - *(long long int*)b > 0 )
        return 1;
    return 0;
}

int cmpfuncRev (const void * a, const void * b){
    return !cmpfunc(a,b);
}

int64_t safemult(int64_t a, int64_t b) {
  double dx;

  dx = (double)a * (double)b;

  if ( fabs(dx) < (double)9007199254740992 )
    return (int64_t)dx;

  if ( (double)INT64_MAX < fabs(dx) )
    return INT64_MAX;

  return a*b;
}
