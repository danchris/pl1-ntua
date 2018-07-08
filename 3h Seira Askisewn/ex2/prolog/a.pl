myAppend([],E,[E]).
myAppend([H|T],E,[H|T1]):-myAppend(T,E,T1).


countNumber([],_,C,C).
countNumber([H|T],N,C,A):-
    ( H == N -> C1 is C + 1
    ; C1 is C
    ),
    countNumber(T,N,C1,A).

returnKey(L,N,key(N,A)):-
    countNumber(L,N,0,A).

createKeyList([],L,_,L).
createKeyList([H|T],L,Checked,R):-
    ( \+ member(H,Checked) -> returnKey([H|T],H,Key),
    myAppend(Checked,H,Checked1),
    myAppend(L,Key,L1),
    createKeyList(T,L1,Checked1,R)
    ; createKeyList(T,L,Checked,R)
    ).

    
