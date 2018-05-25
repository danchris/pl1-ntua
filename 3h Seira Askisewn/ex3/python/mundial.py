#!/usr/bin/python3

import sys
import os
import heapq as hq


def Solver(state):
    curr = state[0]
    List = state[1]

    currM = curr[0]
    currG = curr[1]
    currF = curr[2]

    print("Eimaii h omada", curr[3], "kai tha paiksw me")
    for it in List:
        print(" Team ", it[3], end='')
        tmpM = it[0]
        tmpG = it[1]
        tmpF = it[2]

        if (currG >= tmpF):
            print("Mporw na to paiksw")
        else:
            print(" Den mporw giati", currG, " kai ", tmpG )



def printList(myList):
    for i in myList:
        print(i)


def main(argv):


    file = open(sys.argv[1],"r")
    last = tuple()
    N = 1
    myList = []
    tmpTuple = tuple()

    with file as f:
        N = int(f.readline())
        while True:
            line = f.readline()
            if not line: break
            line = line.replace("\r", "").replace("\n", "")
            last = line.split(" ")
            tmpTuple = (last[1],last[2],last[3],last[0])
            myList.append(tmpTuple)

        f.close()

    print(N)
    ## convert list to heapq
    ## list contains tuples of (matches,goals,fails,team)
    hq.heapify(myList)
    printList(myList)


    openSet = list()
    openSet.append((hq.heappop(myList),myList))

    while len(openSet) > 0:
        tmpState = openSet.pop()
        Solver(tmpState)



if __name__ =="__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 mundial.py [input.file]")
    else:
        main(sys.argv)
