#!/usr/bin/python3

import sys
import os
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

    def __lt__(self,other):
        return len(self.prevMatches) > len(other.prevMatches)






def canPlay(h,g):


    if (g.goals>0 and h.fails==0):
        return None
    if (h.goals>0 and g.fails==0):
        return None

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
        return None
    if (g.matches < 2 and (afterGG!=0 or afterFG!=0)):
        return None

    newH = Team(h.name,h.matches-1,afterGH,afterFH)
    newG = Team(g.name,g.matches-1,afterGG,afterFG)
    newM = Match(h.name,g.name,finalGH,finalGG)
    retTuple = (newH,newG,newM)

    return retTuple


def printOpen(oS):
    for i in oS:
        t = i.otherTeams
        m = i.prevMatches
        for omades in t:
            omades.printTeam()
        for matc in m:
            matc.printMatch()

    return
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

    hq.heapify(myList)
    openSet = list()
    rootState = State(myList,[])
    openSet.append(rootState)

    while openSet:
        currState = hq.heappop(openSet)
        if (not currState.otherTeams):
            for i in currState.prevMatches:
                i.printMatch()
            return
        currHost = hq.heappop(currState.otherTeams)
        for currGuest in currState.otherTeams:
            testMatch = Match(currHost.name,currGuest.name,-1,-1)
            pMatches = currState.prevMatches[:]
            if (testMatch not in pMatches):
                ch = canPlay(currHost,currGuest)
                if (ch != None):
                    newTeams = currState.otherTeams[:]
                    newTeams.remove(currGuest)
                    a,b,c=ch
                    pMatches.append(c)
                    if (a.matches!=0):
                        hq.heappush(newTeams,a)
                    if (b.matches!=0):
                        hq.heappush(newTeams,b)
                    newS = State(newTeams,pMatches)
                    hq.heappush(openSet,newS)

    return


if __name__ =="__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 mundial.py [input.file]")
    else:
        main(sys.argv)


