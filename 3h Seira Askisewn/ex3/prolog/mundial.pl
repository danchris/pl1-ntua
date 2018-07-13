mundial(File, Answer):-
    read_input(File, N, Teams),
    logbN(N,2,FinalRnd),
    Ch is N - 2,
    solver([state(Teams,1,[],[])],Ch,[],Answer,FinalRnd,0),
    !.


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

solver(_,_,A,A,_,1):-!.
solver([state(Teams,Rnd,Prev,Buf)|T],N,Init,Answer,FinalRnd,Flag):-
    %write("\n-----------------Solver: Start-------------------\n"),
    (Rnd =:= FinalRnd,length(Prev,PLenght),PLenght =:= N,length(Teams,TLength),TLength==2,returnFinalTeams(Teams,Host,Guest), canPlayFinal(Host,Guest) ->
        %write("Solver: Final\n"),
        playFinal(Host,Guest,_,Prev,Answer),
        solver(_,_,Answer,Answer,_,1)
    ;
        returnTeams(Teams,[],[],Stop,Cont),
        %write("Solver: epestrepsa stop k cont\n"),
        myLast(Stop,LastStop),
        %write("Solver: epestrepsa LastStop\n"),
        returnNewStates(Rnd,Stop,Cont,Prev,Buf,Stop,LastStop,[],NewStates),
        %write("Solver: Epestrepsa new States\n"),
        %write(T),
        append(NewStates,T,NewTail),
        %write("Solver: Ta kollisa sthn arxi\n"),
        %append(T,NewStates,NewTail),
        %write(NewTail),
        solver(NewTail,N,Init,Answer,FinalRnd,Flag)
    ).

returnTeams([],A,B,A,B):-!.
returnTeams([team(N,M,G,F)|T],InitS,InitC,Stop,Cont):-
    (M == 1 ->
        append(InitS,[team(N,M,G,F)],Init1),
        returnTeams(T,Init1,InitC,Stop,Cont)
    ;
        append(InitC,[team(N,M,G,F)],Init2),
        returnTeams(T,InitS,Init2,Stop,Cont)
    ),
    !.



returnNewStates(_,[],_,_,_,_,_,R,R):-!.
returnNewStates(Rnd,[ToStop|T1],Cont,Prev,Buf,Stop,LastStop,Init,Return):-
    findTeamsThatCanPlay(ToStop,Cont,[],TeamsThatCanPlay),
    removeThis(ToStop,Stop,[],TmpStop),
    playMatches(ToStop,Prev,Buf,TmpStop,TeamsThatCanPlay,Cont,Rnd,LastStop,[],ReturnStates),
    append(Init,ReturnStates,Init1),
    returnNewStates(Rnd,T1,Cont,Prev,Buf,Stop,LastStop,Init1,Return),
    !.

playMatches(_,_,_,_,[],_,_,_,R,R):-!.
playMatches(ToStop,Prev,Buf,TmpStop,[ToCont|T],Cont,Rnd,LastStop,Init,Return):-
    myLast([ToCont|T],LastCont),
    removeThis(ToCont,Cont,[],TmpCont),
    playMatch(ToCont,ToStop,NewM,NewCont),
    append(Prev,[NewM],Prev1),
    append(Buf,[NewCont],Buf1),
    ( ToStop == LastStop, ToCont == LastCont ->
                                                NewRnd is Rnd + 1,
                                                append(Init,[state(Buf1,NewRnd,Prev1,[])],Init1)
    ;
                                                append(TmpStop,TmpCont,NewTeams),
                                                append(Init,[state(NewTeams,Rnd,Prev1,Buf1)],Init1)
    ),
    playMatches(ToStop,Prev,Buf,TmpStop,T,Cont,Rnd,LastStop,Init1,Return),
    !.


findTeamsThatCanPlay(_,[],R,R):-!.
findTeamsThatCanPlay(ToStop,[H|T],Init,Return):-
    ( canPlay(H,ToStop) -> 
                            append(Init,[H],Init1),
                            findTeamsThatCanPlay(ToStop,T,Init1,Return)
    ;
                            findTeamsThatCanPlay(toStop,T,Init,Return)
    ).


myLast([],team(-1,-1,-1,-1)):-!.
myLast([A],A):-!.
myLast([_|T],A):-myLast(T,A).
removeThis(_,[],R,R):-!.
removeThis(X,[H|T],Init,Return):-
    (X \= H -> append(Init,[H],Init1),
        removeThis(X,T,Init1,Return)
    ;
        append(Init,T,Init1),
        removeThis(X,[],Init1,Return)
    ).
canPlay(team(_,_,HG,HF),team(_,_,GG,GF)):-
    HG >= GF,
    HF >= GG,
    GF > GG.

playMatch(team(HN,HM,HG,HF),team(GN,_,GG,GF),match(HN,GN,GF,GG),team(HN,NewM,NewG,NewF)):-
    NewM is HM - 1,
    NewG is HG - GF,
    NewF is HF - GG.

    
canPlayFinal(team(_,_,HG,HF),team(_,_,GG,GF)):-
    %write("canPlayFinal: Start\n"),
    HG == GF,
    GG == HF,
    \+ HF == GF.
%write("canPlayFinal: Mporei\n").

playFinal(team(HN,_,_,HF),team(GN,_,_,GF),match(HN,GN,GF,HF),Prev,Answer):-append(Prev,[match(HN,GN,GF,HF)],Answer).

returnFinalTeams([Host,Guest],Host,Guest).

/* Got from https://stackoverflow.com/questions/36322760/logarithm-base-b-in-prolog
*/

logbN(1,_,0).
logbN(N,B,Ans):-
    N > 1,
    N1 is N/B,
    logbN(N1, B, A),
    Ans is A + 1.
