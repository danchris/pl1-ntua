pistes(File, Answer):-
    read_input(File,_,Pistes),
    getHeadAndReturnTail(Pistes,pista(Id,Ki,Ri,Si,K,R),_),
    solver([state(pista(Id,Ki,Ri,Si,K,R),R,Si,[Id])],Pistes,Si,Answer).



read_input(File,N,Pistes):-
    open(File,read,Stream),
    read_line_to_codes(Stream,Line),
    atom_codes(Atom,Line),
    atom_number(Atom,N),
    N1 is N+1,
    read_lines(Stream,N1,Pistes,0).


read_lines(Stream,N,Pistes,Id):-
    ( N == 0 -> Pistes = []
    ; N > 0 -> read_line(Stream, Pista,Id),
                Nm1 is N-1,
                Id1 is Id+1,
                read_lines(Stream,Nm1,RestPistes,Id1),
                Pistes = [Pista | RestPistes]
    ).

read_line(Stream, pista(Id,Ki,Ri,Si,K,R),Id):-
    read_line_to_codes(Stream,Line),
    atom_codes(Atom,Line),
    atomic_list_concat(Atoms,' ',Atom),
    maplist(atom_number,Atoms,L),
    getHeadAndReturnTail(L,Ki,L1),
    getHeadAndReturnTail(L1,Ri,L2), 
    getHeadAndReturnTail(L2,Si,L3),
    readList(L3,Ki,K),
    append(K,L4,L3),
    readList(L4,Ri,R),
    !.
   /* createKeyList(KH,[],[],K),
    createKeyList(RH,[],[],R),
    !.
    */

solver([],_,Answer,Answer).
solver([state(_,Own,Points,Visited)|T],Pistes,CurrMax,Answer):-
    giveMePistes(Own,Visited,Pistes,PistesToPlay),
    playPistes(PistesToPlay,Own,Points,Visited,[],CurrMax,NewStates,NewBest),
    append(NewStates,T,Tail),
    (NewBest > CurrMax -> solver(Tail,Pistes,NewBest,Answer)
    ;
        solver(Tail,Pistes,CurrMax,Answer)
    ).
    

returnAvailable(A,[],_,A):-!.
returnAvailable([],_,A,A):-!.
returnAvailable([],[],[],A):-A=[],!.
returnAvailable([pista(Id,Ki,Ri,Si,K,R)|T],Visited,Init,Return):-
    (\+member(Id,Visited) -> append(Init,[pista(Id,Ki,Ri,Si,K,R)],Init1),
                            returnAvailable(T,Visited,Init1,Return)
    ;
    returnAvailable(T,Visited,Init,Return)
    ).




enoughKeys(_,[],_).
enoughKeys(K,Needed,Own):-
    countNumber(Needed,K,0,N),
    countNumber(Own,K,0,O),
    O >= N.


canPlayThisPista([],_):-!.
canPlayThisPista([H|T],Own):-
    member(H,Own),
    enoughKeys(H,[H|T],Own),
    canPlayThisPista(T,Own),
    !.

pistesCanPlay([],_,A,A):-!.
pistesCanPlay([pista(Id,Ki,Ri,Si,K,R)|T],Own,Init,Return):-
    ( canPlayThisPista(K,Own) -> append(Init,[pista(Id,Ki,Ri,Si,K,R)],Init1),
        pistesCanPlay(T,Own,Init1,Return)
    ; pistesCanPlay(T,Own,Init,Return)
    ),
    !.





giveMePistes(Own,Visited,Pistes,Return):-
    returnAvailable(Pistes,Visited,[],Available),
    pistesCanPlay(Available,Own,[],Return).

addKeys(Own,Add,Return):-append(Own,Add,Return).

removeKeys([],A,A):-!.
removeKeys([H|T],Own,Answer):-
    countNumber([H|T],H,0,N),
    removeNTimes(H,N,Own,Return),
    removeNTimes(H,N,[H|T],Return1),
    removeKeys(Return1,Return,Answer).

playPista(pista(_,_,_,Si,K,R),Own,Stars,NewStars,Return):-
    removeKeys(K,Own,Removed),
    append(Removed,R,Return),
    NewStars is Si + Stars.


playPistes([],_,_,_,A,B,A,B):-!.
playPistes([pista(Id,Ki,Ri,Si,K,R)|T],Own,CurrStars,Visited,Init,CurrBest,ReturnList,FinalBest):-
    playPista(pista(Id,Ki,Ri,Si,K,R),Own,CurrStars,NewStars,NewOwn),
    append(Visited,[Id],Visited1),
    append(Init,[state(pista(Id,Ki,Ri,Si,K,R),NewOwn,NewStars,Visited1)],Init1),
    (NewStars > CurrBest ->
        NewBest is NewStars,
        playPistes(T,Own,CurrStars,Visited,Init1,NewBest,ReturnList,FinalBest)
    ;
        playPistes(T,Own,CurrStars,Visited,Init1,CurrBest,ReturnList,FinalBest)
    ).



getHeadAndReturnTail([],_,_).
getHeadAndReturnTail([H|T],H,T).

readList(_,0,L):- L = [],!.
readList([H|T],N,[H|TR]):-
    N > 0,
    N1 is N - 1,
    readList(T,N1,TR).

/* The bellow predicate (myAppend) got from https://stackoverflow.com/questions/32720673/prolog-insert-the-number-in-the-list-by-the-tail 
* myAppend([],E,[E]):-!.
myAppend([H|T],E,[H|T1]):-myAppend(T,E,T1).
*/
countNumber([],_,C,C):-!.
countNumber([H|T],N,C,A):-
    ( H == N -> C1 is C + 1
    ; C1 is C
    ),
    countNumber(T,N,C1,A).

/* Got from https://stackoverflow.com/questions/19782622/remove-first-occurrence-of-an-element-in-prolog */
removeFirst(X,[X|Xs],Xs).
removeFirst(X,[Y|Xs],[Y|Ys]) :- 
    X \= Y,
    removeFirst(X,Xs,Ys).


removeNTimes(_,0,R,R):-!.
removeNTimes(K,N,L,R):-
    removeFirst(K,L,R1),
    N1 is N - 1,
    removeNTimes(K,N1,R1,R),!.
/*
returnKey([],_,_):-!.
returnKey(L,N,key(N,A)):-
    countNumber(L,N,0,A).


createKeyList([],A,_,A):-!.
createKeyList([],[],[],A):- A = [],!.
createKeyList([H|T],L,Checked,R):-
    ( \+ member(H,Checked) -> returnKey([H|T],H,Key),
    append(Checked,[H],Checked1),
    append(L,[Key],L1),
    createKeyList(T,L1,Checked1,R)
    ; createKeyList(T,L,Checked,R)
    ).
*/
