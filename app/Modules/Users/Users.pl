:- consult('../Database/Database.pl').

createUser(Username, Name, Password, Description) :-
    createUserDatabase(Username, Name, Password, Description).

loginUser(Username, Password) :-
    loginUserDatabase(Username, Password).

getName(Username, Name) :-
    getNameDatabase(Username, Name).

getDesc(Username, Desc) :-
    getDescDatabase(Username, Desc).