#!/usr/bin/python3

import sys
import os

def printList(myList):
    for i in myList:
        print(i)


def main(argv):

    file = open(sys.argv[1],"r")
    last = tuple()
    N = 1
    myList = list()

    with file as f:
        N = int(f.readline())
        while True:
            line = f.readline()
            if not line: break
            line = line.replace("\r", "").replace("\n", "")
            last = line.split(" ")
            myList.append(last)

        f.close()

    print(N)
    printList(myList)
if __name__ =="__main__":
    main(sys.argv)
