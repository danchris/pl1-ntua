mundial(File, Answer,Stop,Cont):-
    read_input(File, _, Answer),
    returnTeams(Answer,[],[],Stop,Cont).


read_input(File, N, Teams) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_number(Atom, N),
    read_lines(Stream, N, Teams).

read_lines(Stream, N, Teams) :-
    ( N == 0 -> Teams = []
    ; N > 0  -> read_line(Stream, Team),
                Nm1 is N-1,
                read_lines(Stream, Nm1, RestTeams),
                Teams = [Team | RestTeams]).

read_line(Stream, team(Name, P, A, B)) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat([Name | Atoms], ' ', Atom),
    maplist(atom_number, Atoms, [P, A, B]).


returnTeams([],A,B,A,B).
returnTeams([team(N,M,G,F)|T],InitS,InitC,Stop,Cont):-
    (M == 1 ->
        append(InitS,[team(N,M,G,F)],Init1),
        returnTeams(T,Init1,InitC,Stop,Cont)
    ;
        append(InitC,[team(N,M,G,F)],Init2),
        returnTeams(T,InitS,Init2,Stop,Cont)
    ).
