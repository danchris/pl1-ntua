

#!/usr/bin/python3

import sys
import os
import copy
import heapq as hq
import itertools

N = 1
class Team():

    def __init__(self,name,matches,goals,fails):
        self.name = name
        self.matches = int(matches)
        self.goals = int(goals)
        self.fails = int(fails)

    def printTeam(self):
        print("Team Name: ", self.name, ", Number of Matches: ", self.matches, ", Goals: ", self.goals, ", Fails: ", self.fails)

    def __eq__(self,other):
        if self is other:
            return True
        else:
            return False

    def __lt__(self,other):
        return self.matches < other.matches


class Match():

    def __init__(self,host,guest,goalsHost,goalsGuest):
        self.host = host
        self.guest = guest
        self.goalsHost = int(goalsHost)
        self.goalsGuest = int(goalsGuest)

    def __eq__(self,other):
        if (self.host == other.host and self.guest == other.guest):
            return True
        else:
            return False

    def printMatch(self):
        h = self.host
        g = self.guest
        gH = self.goalsHost
        gG = self.goalsGuest
        print(h,"-",g," ", gH, "-", gG,sep='')

class State():

    def __init__(self,otherTeams,prevMatches):
        self.otherTeams = otherTeams
        self.prevMatches = prevMatches


    def printState(self):
        print("\n\t--------------Start printState--------------\t\n")
        for it in self.otherTeams:
            print("oi omades einai ws eksis: ", end = ' ')
            it.printTeam()

        for it in self.prevMatches:
            print("kai ta match einai ws eksis: ", end = ' ')
            it.printMatch()
        print("\n\t--------------End printState--------------\t\n")






#This function got from https://stackoverflow.com/questions/5360220/how-to-split-a-list-into-pairs-in-all-possible-ways

def generateGroups(lst, n):
    if not lst:
        yield []
    else:
        for group in (((lst[0],) + xs) for xs in itertools.combinations(lst[1:], n-1)):
            for groups in generateGroups([x for x in lst if x not in group], n):
                yield [group] + groups


def canPlay(h,g):



    if (h.goals <= g.fails):
        finalGH = h.goals
    else:
        finalGH = g.fails

    if (g.goals <= h.fails):
        finalGG = g.goals
    else:
        finalGG = h.fails

    afterGH = h.goals - finalGH
    afterFH = h.fails - finalGG
    afterGG = g.goals - finalGG
    afterFG = g.fails - finalGH


    if (h.matches < 2 and (afterGH!=0 or afterFH!=0)):
        return tuple()
    if (g.matches < 2 and (afterGG!=0 or afterFG!=0)):
        return tuple()

    newH = Team(h.name,h.matches-1,afterGH,afterFH)
    newG = Team(g.name,g.matches-1,afterGG,afterFG)
    newM = Match(h.name,g.name,finalGH,finalGG)
    retTuple = (newH,newG,newM)

    return retTuple


def checkAndReturn(pa,pMatches):

    newTeams = []
    newMatches = copy.copy(pMatches)
    for i in pa:
        host,guest = i
        testMatch = Match(host.name,guest.name,-1,-1)
        if (testMatch not in pMatches):
            ch = canPlay(host,guest)
            if (len(ch)==0):
                return None
            else:
                a,b,c=ch
                if (a.matches!=0):
                    newTeams.append(a)
                if (b.matches!=0):
                    newTeams.append(b)
                newMatches.append(c)


    retState = State(newTeams,newMatches)
    return retState


def main(argv):


    file = open(sys.argv[1],"r")
    last = tuple()
    global N
    myList = []
    tmpTuple = tuple()

    with file as f:
        N = int(f.readline())
        while True:
            line = f.readline()
            if not line: break
            line = line.replace("\r", "").replace("\n", "")
            last = line.split(" ")
            tmpTeam = Team(last[0],last[1],last[2],last[3])
            myList.append(tmpTeam)

        f.close()


    #myList contains teams


    openSet = list()
    rootState = State(myList,[])
    openSet.append(rootState)

    while len(openSet) > 0:
        currState = openSet.pop(0)
        if (len(currState.otherTeams) == 0):
            for i in currState.prevMatches:
                i.printMatch()
            return
        listOfPossibleMatches = list(generateGroups(currState.otherTeams, 2))

        for pairs in listOfPossibleMatches:
            #tmpSt is a list of pairs now we must check if this state can be valid
            retSt = checkAndReturn(pairs,currState.prevMatches)
            if (retSt is not None):
                openSet.insert(0,retSt)



if __name__ =="__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 mundial.py [input.file]")
    else:
        main(sys.argv)

