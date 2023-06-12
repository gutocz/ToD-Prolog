:- consult('../Database/Database.pl').

createToDoList(Username, NomeLista, DescricaoLista) :-
    createToDoListDatabase(Username, NomeLista, DescricaoLista).

deleteToDoList(Username, Name) :-
    deleteToDoListDatabase(Username, Name).

addUserToList(Usuario, Creator, Name) :- 
    addUserToListDatabase(Usuario, Creator, Name).

removeUserFromList(Param1, Param2, Param3) :-
    removeUserFromListDatabase.

getSharedList(Param1, []) :-
    getSharedListDatabase(Username, Lists).

addTask(Param1, Param2, Param3, Param4, Param5, Param6, Param7) :-
    addTaskDatabase.

showTaskContent(Param1, Param2, Param3, []) :- 
    showTaskContentDatabase.

deleteTask(Param1, Param2, Param3, Param4) :- 
    deleteTaskDatabase.

editTask(Param1, Param2, Param3, Param4, Param5, Param6) :-
    editTaskDatabase.
