:- consult('../Database/Database.pl').

createUser(Username, Name, Password, Description) :-
    createUserDatabase(Username, Name, Password, Description).

deleteUser(Username) :-
    deleteUserDatabase(Username).

loginUser(Username, Password) :-
    loginUserDatabase(Username, Password).

getDados(Username, Dados) :-
    getDadosDatabase(Username, Dados).