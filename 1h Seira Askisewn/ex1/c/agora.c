#include <stdio.h>
#include <stdlib.h>


int isPrime (long long int num);
long long int findlcm (long long int arr[], int n, int e);
long long int gcd (long long int a, long long int b);

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

    long long int maxVillage = -1, maxPrimeValue = -1, *villages = malloc(N*sizeof(long long int));
    int i = 0, max = -1, maxPrime = -1;

    /*
     * Read input file
     * and store
     * to array
     * Also store maximum value of array
     * and maximum prime value of array if exists
     */

    long long int lcm = 0, other = -1;
    while((fscanf(file,"%lld", &villages[i])) == 1){
        if(villages[i] > max){
            max = villages[i];
            maxVillage = i;
        }
        if(i==1) lcm = villages[0];
        if(i) {
            lcm =( ((villages[i]*lcm)) / (gcd(villages[i],lcm)) );
        }
        if(isPrime(villages[i])){
            if(villages[i] > maxPrimeValue){
                maxPrime = i;
                maxPrimeValue = villages[i];
            }
        }
        i++;
    }

//    long long int lcm = findlcm(villages,N,-1), other = -1;     //calculate lcm of array
    int v = -1, otherP = -1, otherV = -1;

    /*
     * If exists prime calculate lcm again with it
     * or calculate lcm without biggest element
     * and compare with lcm
     */
    if (maxPrime != -1){
        other = findlcm(villages,N,maxPrime);
        otherP = maxPrime;
    }
    else {
        other = findlcm(villages,N,maxVillage);
        otherV = maxVillage;
    }

    if (other!= -1 && other < lcm){
        lcm = other;
        v = ( otherP > otherV ? otherP : otherV);
    }

    printf("%lld %d\n", lcm, v+1);

    free(villages);
    fclose(file);

    return 0;
}

int isPrime(long long int num){

    if (num <= 1) return 0;
    if (num % 2 == 0 && num > 2) return 0;
    for (int i = 3; i < num / 2; i+=2){
        if (num % i == 0){
            return 0;
        }
    }
    return 1;
}

long long int gcd(long long int a, long long int b){


    if (b==0) return a;

    return gcd(b,a%b);
}

long long int findlcm(long long int arr[], int n, int e){

    long long int ans = arr[0];

    for (int i = 1; i < n; i++){
        if (i == e) continue;
        ans = ( ((arr[i]*ans)) / (gcd(arr[i],ans)) );
    }

    return ans;
}
