pistes(File, Answer):-
    read_input(File,_,Answer).



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
    readList(L4,Ri,R).
    


getHeadAndReturnTail([H|T],H,T).

readList(_,0,L):- L = [],!.
readList([H|T],N,[H|TR]):-
    N > 0,
    N1 is N - 1,
    readList(T,N1,TR).

