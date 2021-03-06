#!/usr/bin/python3

import sys
import os
import copy
import heapq as hq
import itertools
import math
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
        #return (self.matches+self.goals + self.fails) < (other.matches +other.goals+other.fails)
        if (self.matches != other.matches):
            return self.matches < other.matches
        if (self.fails != other.fails):
            return self.fails > other.fails
        if ( self.goals != other.goals):
            return self.goals < other.goals
        return self.name < other.name

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

    def __init__(self,otherTeams,rnd,prevMatches,buf):
        self.otherTeams = otherTeams
        self.rnd = rnd
        self.prevMatches = prevMatches
        self.buf = buf


    def printState(self):
        print("\n\t--------------Start printState--------------\t\n")
        print("Round: ", end = ' ')
        print(self.rnd)
        for it in self.otherTeams:
            print("oi omades einai ws eksis : ", end = ' ')
            it.printTeam()


        for it in self.prevMatches:
            print("kai ta match einai ws eksis: ", end = ' ')
            it.printMatch()

        print("Buffer ")
        for it in self.buf:
            it.printTeam()

        print("\n\t--------------End printState--------------\t\n")

    def __lt__(self,other):
        r = self.rnd
        oR = other.rnd
        t = len(self.otherTeams)
        oT = len(other.otherTeams)
        p = len(self.prevMatches)
        oP = len(other.prevMatches)
        b = len(self.buf)
        oB = len(other.buf)
        return int(r+p+b+t) > int(oR+oT+oP+oB)



def canPlay(h,g):

    #print(h.name,'-',g.name, end = ' ')


    # An o host dn mporei na valei tosa goals osa thelei o guest na apokleistei tote return None
    if (h.goals < g.fails):
        #print("host ligotera goals")
        return None

    #An o guest prepei na valei parapanw apo auta pou mporei na faei o host tote return None
    if(h.fails < g.goals):
        #print("host ligotera fails")
        return None

    finalHostGoals = g.fails
    finalGuestGoals = g.goals

    if (finalHostGoals <= finalGuestGoals):
        return None

    afterHostGoals = h.goals - finalHostGoals
    afterHostFails = h.fails - finalGuestGoals

    newH = Team(h.name,h.matches-1,afterHostGoals,afterHostFails)
    newM = Match(h.name,g.name,finalHostGoals,finalGuestGoals)
    return (newH,newM)


def playTelikos(h,g):

    if (h.goals != g.fails or g.goals != h.fails or h.fails == g.fails):
        return None
    finalGH = g.fails
    finalGG = h.fails
    newM = Match(h.name,g.name,finalGH,finalGG)

    return newM

def returnTeams(lst):

    stop = list()
    cont = list()
    for i in lst:
        number = i.matches
        if (number == 1):
            hq.heappush(stop,i)
        else:
            hq.heappush(cont,i)

    return (stop,cont)

def findTeamsThatCanPlay(t,lst):
    retL = list()
    for i in lst:
        ch = canPlay(i,t)
        if (ch is None): continue
        else:
            retL.append((i,ch))

    return retL
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
            hq.heappush(myList,tmpTeam)
            #myList.append(tmpTeam)

        f.close()


    #myList contains teams


    myList.reverse()
    root = State(myList,1,[],[])


    openSet = list()
    openSet.append(root)

    allL = list()
    finalRnd = int(math.log(N,2))
    while openSet:

        currState = hq.heappop(openSet)

        if (len(currState.prevMatches) == N - 2 and currState.rnd == finalRnd and len(currState.otherTeams)==2):
            newM = playTelikos(currState.otherTeams[0],currState.otherTeams[1])
            if (newM is None):
                continue
            else:
                currState.prevMatches.append(newM)
                for i in reversed(currState.prevMatches):
                    i.printMatch()
                return

        stop,cont = returnTeams(currState.otherTeams)


        sStop = stop[:]
        for toStop in reversed(stop):
            retL = findTeamsThatCanPlay(toStop,reversed(cont))
            if (not retL):
                break
            tmpStop = sStop[:]
            tmpStop.remove(toStop)
            pMatches = currState.prevMatches[:]
            he = retL[-1]
            a,b = he
            for it in retL:
                tmpCont = cont[:]
                toCont,ch = it
                newH,newM = ch
                tmpCont.remove(toCont)
                if (stop[-1]==toStop and a==toCont):
                #if (stop[-1]==toStop and cont[-1]==toCont):
                    tmp = currState.buf[:]
                    hq.heappush(tmp,newH)
                    #tmp.reverse()
                    newS = State(tmp,currState.rnd+1,pMatches+[newM],[])
                else:
                    tmp = currState.buf[:]
                    tmp.append(newH)
                    #hq.heappush(tmp,newH)
                    #tmp.reverse()
                    tmp1 = tmpStop+tmpCont
                    hq.heapify(tmp1)
                    #tmp1.reverse()
                    newS = State(tmp1,currState.rnd,pMatches+[newM],tmp)
                hq.heappush(openSet,newS)











if __name__ =="__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 mundial.py [input.file]")
    else:
        main(sys.argv)
