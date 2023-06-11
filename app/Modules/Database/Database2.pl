:- use_module(library(file_systems)).
:- use_module(library(system)).

createToDoListDatabase(Username, ListName, ListDesc) :-
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName], ListDir),
    atomic_list_concat([ListDir, '/', '0', ListName, '.txt'], FilePath),
    \+ exists_directory(ListDir), % Verifica se o diretório não existe
    create_directory(ListDir),
    open(FilePath, write, Stream),
    format(Stream, "~w~n", [ListDesc]),
    format(Stream, "~w~n", [ListName]),
    close(Stream).

deleteToDoListDatabase(Username, ListName) :-
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName], FilePath),
    remove_directory_recursive(FilePath).

addUserToListDatabase(Username, Creator, ListName) :-
    atomic_list_concat([directoryDatabase, Username, '/sharedWithMe'], ListDir),
    atomic_list_concat([ListDir, '/', ListName], UserList),
    exists_directory(ListDir), % Verifica se o diretório existe
    (exists_file(UserList) ->
        open(UserList, append, Stream),
        format(Stream, "~w~n~w~n", [Creator, ListName]),
        close(Stream)
    ;
        open(UserList, write, Stream),
        format(Stream, "~w~n~w~n", [Creator, ListName]),
        close(Stream)
    ).

removeUserFromListDatabase(Username, ListName) :-
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/users.txt'], FilePath),
    exists_file(FilePath), % Verifica se o arquivo existe
    read_file_to_string(FilePath, Contents, []),
    split_string(Contents, "\n", "\n", Permissions),
    delete(Permissions, Username, NewPermissions),
    atomic_list_concat(NewPermissions, "\n", NewContents),
    open(FilePath, write, Stream),
    write(Stream, NewContents),
    close(Stream).

getSharedListDatabase(Username, Lists) :-
    atomic_list_concat([directoryDatabase, Username, '/sharedWithMe'], FilePath),
    exists_directory(FilePath), % Verifica se o diretório existe
    directory_files(FilePath, Contents),
    include(\=(.), Contents, Filtered), % Filtra os nomes de diretórios "." e ".."
    Lists = Filtered.

addTaskDatabase(Username, ListName, TaskName, TaskDesc, TaskDate, TaskPriority) :-
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/', TaskName], FilePath),
    open(FilePath, write, Stream),
    format(Stream, "~w~n~w~n~w~n", [TaskName, TaskDesc, TaskDate, TaskPriority]),
    close(Stream).

showTaskContentDatabase(Username, ListName, TaskName, Content) :-
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/', TaskName], FilePath),
    read_file_to_string(FilePath, Contents, []),
    split_string(Contents, "\n", "\n", Content).

deleteTaskDatabase(Username, ListName, TaskName) :-
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/', TaskName], FilePath),
    delete_file(FilePath).

editTaskDatabase(Username, ListName, TaskName, NewData, OldData) :-
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/', TaskName], FilePath),
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/', TaskName, '(editado)'], NewFilePath),
    read_file_to_string(FilePath, Contents, []),
    split_string(Contents, "\n", "\n", Lines),
    (OldData = "name" ->
        replace_task_data(Lines, 0, NewData, NewLines)
    ; OldData = "description" ->
        replace_task_data(Lines, 1, NewData, NewLines)
    ; OldData = "date" ->
        replace_task_data(Lines, 2, NewData, NewLines)
    ; OldData = "priority" ->
        replace_task_data(Lines, 3, NewData, NewLines)
    ),
    atomic_list_concat(NewLines, "\n", NewContents),
    open(NewFilePath, write, Stream),
    write(Stream, NewContents),
    close(Stream).

replace_task_data(Lines, Index, NewData, NewLines) :-
    nth0(Index, Lines, OldData),
    nth0(Index, NewLines, NewData, Lines, OldData).

ifNewTaskExists(Username, ListName, TaskName) :-
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/', TaskName, '.new'], FilePath),
    exists_file(FilePath), % Verifica se o arquivo existe
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/', TaskName], OriginalFilePath),
    delete_file(OriginalFilePath),
    rename_file(FilePath, OriginalFilePath).