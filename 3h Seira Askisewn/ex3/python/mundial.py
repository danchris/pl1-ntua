#!/usr/bin/python3

import sys
import os
import copy
import heapq as hq


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


def playMatch(host,guest):

    f_host = host.name
    print("--------",f_host)
    f_guest = guest.name
    f_g = 0
    f_f = 0

    if (host.goals !=0 and guest.fails !=0):
        if (host.goals >= guest.fails):
            f_g = guest.fails
            #host.goals -= guest.fails
            #guest.fails -= guest.fails
        else:
            f_g = host.goals
            #host.goals -= host.goals
            #guest.fails -= host.goals


    if (host.fails !=0 and guest.goals !=0):
        if (host.fails <= guest.goals):
            f_f = host.fails
            #guest.goals -= host.fails
            #host.fails -= host.fails
        else:
            f_f = guest.goals
            #guest.goals -= guest.goals
            #host.fails -= guest.goals

    #host.matches -= 1
    #guest.matches -= 1

    print("Epaiksa", end=' ')
    print(f_host, "-", f_guest," ", f_g, "-" , f_f)

    retMatch = Match(f_host,f_guest,f_g,f_f)
    return retMatch


#     if (host.matches == 0):
#         retHost = None
#     else:
#         retHost = Team(host.name,host.matches,host.goals,host.fails)
#
#     if (guest.matches == 0):
#         retGuest = None
#     else:
#         retGuest = Team(guest.name,guest.matches,guest.goals,guest.fails)
#
#     retMatch = Match(f_host,f_guest,f_g,f_f)
#
#     if guest in otherTeams:
#         otherTeams.remove(guest)
#     if (retGuest != None):
#         otherTeams.append(retGuest)
#     prevMatches.append(retMatch)
#
#     if (retHost == None and len(prevMatches) != N-1):
#         return None
#     newState = State(retHost,otherTeams,prevMatches)
#
#     return newState
#

def canPlay(curr,test):

    print("Mpika sthn can play")

    checkCurr = int(test.fails) - int(curr.goals)
    checkTest = int(curr.fails) - int(test.goals)

    #  if (checkCurr == 0 and checkTest == 0) return True

    if (checkCurr !=0 and curr.matches < 2):
        print("krima")
        return False
    if (checkTest !=0 and test.matches < 2):
        return False

    return True


def testAndReturn(test:State)->list():

    print("Mpika sthn testAndReturn")
    retList = []
    h = test.otherTeams.pop()
    o = copy.copy(test.otherTeams)
    for it in o:
        host = copy.copy(h)
        testMatch = Match(host.name,it.name,-1,-1)
        if (testMatch not in test.prevMatches):
            print("allh katastash")
            guest = copy.copy(it)
            #guest = copy.deepcopy(it)
            retMatch = playMatch(host,it)
            host.matches -= 1
            host.goals -= retMatch.goalsHost
            host.fails -= retMatch.goalsGuest
            guest.matches -= 1
            guest.goals -= retMatch.goalsGuest
            guest.fails -= retMatch.goalsHost
            if (host.matches < 1 and (host.goals !=0 or host.fails !=0)):
                print("host dn mporei")
                continue
            if (guest.matches < 1 and (guest.goals !=0 or guest.fails !=0)):
                print("guest dn mporei")
                continue
            test.otherTeams.remove(it)
            newOtherTeams = copy.copy(test.otherTeams)
            if(host.goals != 0 or host.fails != 0):
                print("Nai host", end = ' ')
                host.printTeam()
                newOtherTeams.append(host)
            if (guest.goals !=0 or guest.fails !=0):
                print("nai guest", end = ' ')
                guest.printTeam()
                newOtherTeams.append(guest)
            newPrevMatches = copy.copy(test.prevMatches)
            newPrevMatches.append(retMatch)
            newState = []
            newState = State(newOtherTeams,newPrevMatches)
            retList.append(newState)

            for a in retList:
                print("Mexri twra h retLIst exei: ", end = ' ')
                a.printState()



    return retList

#def printList(myList):
#    for i in myList:
#    print(i.name, " ",i.matches, " ",i.goals, " ", i.fails, end =' | ')


#def printState(state):
#    print("Name is ", state.team.name, end = ' | ' )
#    print("Other teams are: ", end='')
#    printList(state.otherTeams)
#    print("\nAnd matches played are: ", state.prevMatches)

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


    #myList contains States, and states are listofteams, and list with previous Matches

    openSet = list()
    rootState = State(myList,[])
    openSet.append(rootState)

    while len(openSet) > 0:
        currState = openSet.pop()
        print("ekana pop to ", end = ' ')
        currState.printState()
        if (len(currState.otherTeams) == 0):
            for i in currState.prevMatches:
                i.printMatch()
            return
        for it in currState.otherTeams:
            tmpState = currState
            retList = testAndReturn(tmpState)
            print("epestrepsa me ta eksis : ", end = ' ')
            for i in retList:
                i.printState()
                openSet.append(i)


    for i in currState.prevMatches:
        i.printMatch()

if __name__ =="__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 mundial.py [input.file]")
    else:
        main(sys.argv)
