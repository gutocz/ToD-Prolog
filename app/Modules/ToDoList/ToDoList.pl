:- consult('../Database/Database2.pl').

createToDoList(Param1, Param2, Param3, Param4) :-
    createToDoListDatabase.

deleteToDoList(Param1, Param2, Param3) :-
    deleteToDoListDatabase.

addUserToList(Param1, Param2, Param3, Param4) :- 
    addUserToListDatabase.

removeUserFromList(Param1, Param2, Param3) :-
    removeUserFromListDatabase.

getSharedList(Param1, []) :-
    getSharedListDatabase.

addTask(Param1, Param2, Param3, Param4, Param5, Param6, Param7) :-
    addTaskDatabase.

showTaskContent(Param1, Param2, Param3, []) :- 
    showTaskContentDatabase.

deleteTask(Param1, Param2, Param3, Param4) :- 
    deleteTaskDatabase.

editTask(Param1, Param2, Param3, Param4, Param5, Param6) :-
    editTaskDatabase.