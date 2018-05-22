agora(File, When, Missing) :-
    read_input(File, _, Villages),
    findStart(Villages, Start),
    reverse(Villages,Rev),
    findStart(Rev, End),
    runningLcm(Villages,Start,List),
    runningLcm(Rev,End,RevList),
    reverse(RevList,RevRevList),
    splitList(RevRevList, _, NewList),
    splitList(NewList, SolverStart, FinalList),
    solver(List,FinalList,When,Missing,SolverStart,0,1),
    !.

read_input(File, N, Villages) :-
    open(File, read, Stream),
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atom_number(Atom, N),
    read_lines(Stream, N, Villages).

read_lines(Stream, N, Villages) :-
    ( N == 0 -> Villages = []
    ; N > 0 -> read_line(Stream, Villages)
    ).

read_line(Stream, Villages) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ' , Atom),
    maplist(atom_number, Atoms, Villages). 


runningLcm([],_,_).
runningLcm([Head|Tail], Previous, [Curr | Rest]) :-
    lcm(Previous, Head, Curr),
    runningLcm(Tail ,Curr, Rest).

lcm(A,B,Res) :-
    Res is abs(A*B) / gcd(A,B).

findStart([],_).
findStart([Head |_], Start) :- Start is Head.

splitList([H | T], H, T).

solver([],_,When,Missing,When,Missing,_).
solver(_,[],When,Missing,When,Missing,_).
solver([LH|LT], [RH|RT], When, Missing, TempW, TempM,Counter) :-
   lcm(LH,RH,Temp),
   ( Temp < TempW -> TempW1 is Temp,
       TempM1 is Counter + 1,
       Counter1 is Counter + 1,
       solver(LT,RT,When,Missing,TempW1,TempM1,Counter1)
   ;
       Counter1 is Counter + 1,
       solver(LT,RT,When,Missing,TempW,TempM,Counter1)
   ).
