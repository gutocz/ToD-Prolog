:- consult('../Database/Database.pl').
:- consult('../Util/Util.pl').

teste :-
    getNameDatabase('teste', Name),
    write(Name).