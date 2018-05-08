#!/usr/bin/python3

import sys
import os
import numpy as np


## Global defines
myMap = np.chararray((1002,1002), unicode=True)
N , M = 1,1


def printList(a):
    print("Function that prints a list", end='')
    for k in a: print(k, end='')

    return

def printMap ():

    global myMap, N, M
    for i in range(1,N):
        for k in range(1,M):
            print(myMap[i,k], end='')
        print('\n',end='')

    return



## Main function
def main(argv):

    file = open(sys.argv[1],"r")

    global N, M, myMap
    myList = list()
    last = tuple()
    j = 1

    myMap[1,0] = 'X'

    with file as f:
        while True:
            c = f.read(1)
            if (not c): break
            elif (c.isspace()):
                M = j
                myMap[N,j] = 'X'
                N += 1
                myMap[N,0] = 'X'
                j = 1;
            else:
                myMap[N,j] = c
                if (c == '+' or c == '-'):
                    last = (N,j,c,0)
                    myList.append(last)
                j += 1


    file.close()

    for i in range(0,M+1) :
        myMap[0,i] = 'X'
        myMap[N,i] = 'X'


    end = 0
    t = 0
    prevT = 0
    while (len(myList)):

        item = myList.pop(0)
        it_i = item[0]
        it_j = item[1]
        it_c = item[2]
        it_t = item[3]

        if (end and it_t > prevT):
            break

        ## Right
        if(myMap[it_i,it_j+1] == '.'):
            myMap[it_i,it_j+1] = it_c
            last = (it_i,it_j+1,it_c,it_t+1)
            myList.append(last)
        elif( myMap[it_i,it_j+1] != 'X' and myMap[it_i,it_j+1] != it_c):
            myMap[it_i,it_j+1] = '*'
            t = it_t+1
            end = 1;

        ## Left
        if(myMap[it_i,it_j-1] == '.'):
            myMap[it_i,it_j-1] = it_c
            last = (it_i,it_j-1,it_c,it_t+1)
            myList.append(last)
        elif( myMap[it_i,it_j-1] != 'X' and myMap[it_i,it_j-1] != it_c):
            myMap[it_i,it_j-1] = '*'
            t = it_t+1
            end = 1;

        ## Up
        if(myMap[it_i-1,it_j] == '.'):
            myMap[it_i-1,it_j] = it_c
            last = (it_i-1,it_j,it_c,it_t+1)
            myList.append(last)
        elif( myMap[it_i-1,it_j] != 'X' and myMap[it_i-1,it_j] != it_c):
            myMap[it_i-1,it_j] = '*'
            t = it_t+1
            end = 1;


        ## Down
        if(myMap[it_i+1,it_j] == '.'):
            myMap[it_i+1,it_j] = it_c
            last = (it_i+1,it_j,it_c,it_t+1)
            myList.append(last)
        elif( myMap[it_i+1,it_j] != 'X' and myMap[it_i+1,it_j] != it_c):
            myMap[it_i+1,it_j] = '*'
            t = it_t+1
            end = 1;

        prevT = it_t


    if (not end): print ("the world is saved")
    else: print(t)
    printMap()

    return

if __name__ =="__main__":
    main(sys.argv)
