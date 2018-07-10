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
        if (self.matches != other.matches):
            return self.matches < other.matches
        if (self.fails != other.fails):
            return self.fails > other.fails
        return self.goals < other.goals


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
        if (len(self.prevMatches) != len(other.prevMatches)):
            return len(self.prevMatches) > len(other.prevMatches)
        return len(self.otherTeams) < len(other.otherTeams)


def playMatch(host,guest):

    f_host = host.name
    #print("--------",f_host)
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

    #print("Epaiksa", end=' ')
    #print(f_host, "-", f_guest," ", f_g, "-" , f_f)

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




'''
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
'''



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

    if (finalGG == finalGH):
        return None
    if (h.matches < 2 and (afterGH!=0 or afterFH!=0)):
        return None
    if (g.matches < 2 and (afterGG!=0 or afterFG!=0)):
        return None

    newH = Team(h.name,h.matches-1,afterGH,afterFH)
    newG = Team(g.name,g.matches-1,afterGG,afterFG)
    newM = Match(h.name,g.name,finalGH,finalGG)

    retTuple = (newH,newG,newM)

    return retTuple


def checkAndReturn(pa,pMatches):

    newTeams = []
    newMatches = pMatches[:]

    for i in pa:
        guest,host = i
       # host,guest = i
        testMatch = Match(host.name,guest.name,-1,-1)
        if (testMatch not in pMatches):
            ch = canPlay(host,guest)
            if (ch is None):
                return None
            else:
                a,b,c=ch
                if (a.matches!=0):
                    hq.heappush(newTeams,a)
                    #newTeams.append(a)
                if (b.matches!=0):
                    hq.heappush(newTeams,b)
                    #newTeams.append(b)
                newMatches.append(c)
                #c.printMatch()

    retState = State(newTeams,newMatches)
    return retState

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


    #myList contains teams

    #for i in myList:
     #   i.printTeam()

    hq.heapify(myList)
    openSet = list()
    rootState = State(myList,[])
    openSet.append(rootState)

    while len(openSet) > 0:
        currState = hq.heappop(openSet)
        #currState = openSet.pop()
        if (len(currState.otherTeams) == 0):
            for i in reversed(currState.prevMatches):
                i.printMatch()
            return
        listOfPossibleMatches = list(generateGroups(currState.otherTeams, 2))
        print(len(listOfPossibleMatches))
        for pairs in reversed(listOfPossibleMatches):
            #tmpSt is a list of pairs now we must check if this state can be valid

            retSt = checkAndReturn(pairs,currState.prevMatches)
            if (retSt is not None):
                hq.heappush(openSet,retSt)
                #openSet.append(retSt)



#    while len(openSet) > 0:
#        currState = openSet.pop()
#        print("ekana pop to ", end = ' ')
#        currState.printState()
#        if (len(currState.otherTeams) == 0):
#            for i in currState.prevMatches:
#                i.printMatch()
#            return
#        for it in currState.otherTeams:
#            tmpState = currState
#            retList = testAndReturn(tmpState)
#            print("epestrepsa me ta eksis : ", end = ' ')
#            for i in retList:
#                i.printState()
#                openSet.append(i)


#    for i in currState.prevMatches:
#        i.printMatch()

if __name__ =="__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 mundial.py [input.file]")
    else:
        main(sys.argv)
