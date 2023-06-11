:- consult('../Database/Database.pl').
:- consult('../Util/Util.pl').

teste :-
    directoryDatabase(Dir),
    criar_pasta(Dir, 'teste').