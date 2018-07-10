myAppend([],E,[E]):-!.
myAppend([H|T],E,[H|T1]):-myAppend(T,E,T1).

countNumber([],_,C,C):-!.
countNumber([H|T],N,C,A):-
    ( H == N -> C1 is C + 1
    ; C1 is C
    ),
    countNumber(T,N,C1,A).
returnAvailable(A,[],_,A):-!.
returnAvailable([],_,A,A):-!.
returnAvailable([],[],[],A):-A=[],!.
returnAvailable([pista(Id,Ki,Ri,Si,K,R)|T],Visited,Init,Return):-
    (\+member(Id,Visited) -> append(Init,[pista(Id,Ki,Ri,Si,K,R)],Init1),
                            returnAvailable(T,Visited,Init1,Return)
    ;
    returnAvailable(T,Visited,Init,Return)
    ).

myMember(key(K,_),[H|T]):-
    member(key(K,_),[H|T]).
    

findOther(K,[key(A,N)|T],R):-
    ( K==A -> R is N,!
    ; findOther(K,T,R)
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
/*
canPlayThisPista([],_).
canPlayThisPista([H|T],Own):-
    myMember(H,Own),
    enoughKeys(H,Own),
    canPlayThisPista(T,Own),
    !.
*/
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


/*
removeKeys([],_,A,A):-!.
removeKeys([key(K,N)|T1],Own,Init,Return):-
    (myMember(key(K,N),Own) ->
        findOther(K,Own,MyN),
        NewN is MyN - N,
        append(Init,[key(K,NewN)],Init1),
        removeKeys(T1,Own,Init1,Return)
    ;
        append(Init,[key(K,N)],Init2),
        removeKeys(T1,Own,Init2,Return)
    ).
*/

%addOrRemoveKeys([],A,[],A,_):-!.
addOrRemoveKeys(Own,Own,[],Own,_):-!.
addOrRemoveKeys(Own,[],[],Own,_):-!.
%addOrRemoveKeys([],Other,[],Other,_):-!.
%addOrRemoveKeys([],_,Return,Return,_):-!.
addOrRemoveKeys([key(Key,Number)|T],Needed,Init,Return,Add):-
    (myMember(key(Key,Number),Needed) -> 
        findOther(Key,Needed,OtherN),
        (Add == 0 ->
            NewN is Number - OtherN
        ;
            NewN is Number + OtherN
        ),
        (NewN == 0 ->
                        addOrRemoveKeys(T,Needed,Init,Return,Add)
        ;               
                        append(Init,[key(Key,NewN)],Init1),
                        addOrRemoveKeys(T,Needed,Init1,Return,Add)
        )
    ;
        
    append(Init,[key(Key,Number)],Init1),
    addOrRemoveKeys(T,Needed,Init1,Return,Add)
    ).

playPista(pista(_,_,_,Si,K,R),Own,Stars,NewStars,Return):-
    addOrRemoveKeys(Own,K,[],Removed,0),
    addOrRemoveKeys(Removed,R,[],Return,1),
    NewStars is Si + Stars.

playPistes([],_,_,_,A,_,A).
playPistes([(pista(Id,Ki,Ri,Si,K,R))|T],Own,CurrStars,Visited,Init,CurrBest,Return):-
    playPista(pista(Id,Ki,Ri,Si,K,R),Own,CurrStars,NewStars,NewOwn),
    append(Visited,[Id],Visited1),
    append(Init,[state(pista(Id,Ki,Ri,Si,K,R),NewOwn,NewStars,Visited1)],Init1),
    (NewStars > CurrBest -> 
        NewBest is NewStars,
        playPistes(T,Own,CurrStars,Visited,Init1,NewBest,Return)
    ;
        playPistes(T,Own,CurrStars,Visited,Init1,CurrBest,Return)
    ).

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
removeI([],_,Return,Return).
removeI([H|T],K,Init,Return):-
    (H \= K ->
        append([H],Init,Init1),
        removeI(T,K,Init1,Return)
    ;
        removeI(T,K,Init,Return)
    ).
*/
