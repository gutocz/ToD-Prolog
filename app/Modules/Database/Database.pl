:- consult('../Util/Util.pl').
:- use_module(library(system)).


directoryDatabase(Directory) :-
    Directory = 'Modules/Database/LocalUsers/'.

%Funções relacionadas a Users
createUserDatabase(Username, Name, Password, Description) :-
    directoryDatabase(Directory),
    concatenar_strings(Directory, Username, DirectoryUser),
    concatenar_strings(Username, '.txt', Usernametxt),
    criar_pasta(Directory, Username),
    criar_pasta(DirectoryUser, 'listas'),
    criar_pasta(DirectoryUser, 'sharedWithMe'),
    criar_arquivo(DirectoryUser, Usernametxt),
    escrever_em_arquivo(DirectoryUser, Usernametxt, Username, Name, Password, Description).

getDadosDatabase(Username, Dados) :-
    directoryDatabase(Directory),
    concatenar_strings(Directory, Username, DirectoryUser),
    concatenar_strings(Username, '.txt', Usernametxt),
    concatenar_strings(DirectoryUser, '/', DirectoryUser2),
    concatenar_strings(DirectoryUser2, Usernametxt, DirectoryUserFinal),
    ler_user(DirectoryUserFinal, Dados).

%Funções relacionadas a login
loginUserDatabase(Username, Password) :-
    directoryDatabase(Directory),
    concatenar_strings(Directory, Username, DirectoryUser),
    concatenar_strings(Username, '.txt', Usernametxt),
    concatenar_strings(DirectoryUser, '/', DirectoryUser2),
    concatenar_strings(DirectoryUser2, Usernametxt, DirectoryUserFinal),
    ler_user(DirectoryUserFinal, Dados),
    verificar_senha(Dados, Password).

%Funções relacionadas a ToDoList 
createToDoListDatabase(Username, ListName, ListDesc) :-
    directoryDatabase(Directory),
    atomic_list_concat([Directory, '/', Username, '/listas/'], ListDir),
    atomic_list_concat([ListDir, '/', ListName, '.txt'], FilePath),
    open(FilePath, write, Stream),
    format(Stream, "~w~n", [ListDesc]),
    format(Stream, "~w~n", [ListName]),
    close(Stream).

deleteToDoListDatabase(Username, Name) :-
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName], DirectoryPath),
    delete_directory(DirectoryPath).

addUserToListDatabase(Usuario, Creator, Name) :-
    atomic_list_concat([directoryDatabase, Username, '/sharedWithMe'], ListDir),
    atomic_list_concat([ListDir, '/', ListName], UserList),
    exists_directory(ListDir),
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
    exists_file(FilePath),
    read_file_to_string(FilePath, Contents, []),
    split_string(Contents, "\n", "\n", Lines),
    exclude(=(Username), Lines, NewLines),
    atomic_list_concat(NewLines, "\n", NewContents),
    open(FilePath, write, Stream),
    write(Stream, NewContents),
    close(Stream).

getSharedListDatabase(Username, Lists) :-
    atomic_list_concat([directoryDatabase, Username, '/sharedWithMe'], FilePath),
    exists_directory(FilePath),
    directory_files(FilePath, Contents),
    exclude(=(.), Contents, Lists).

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
    exists_file(FilePath),
    delete_file(FilePath).

editTaskDatabase(Username, ListName, TaskName, NewData, OldData) :-
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/', TaskName], FilePath),
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/', TaskName, '(editado)'], NewFilePath),
    read_file_to_string(FilePath, Contents, []),
    split_string(Contents, "\n", "\n", Lines),
    replace_task_data(Lines, OldData, NewData, NewLines),
    atomic_list_concat(NewLines, "\n", NewContents),
    open(NewFilePath, write, Stream),
    write(Stream, NewContents),
    close(Stream).

replace_task_data(Lines, "name", NewData, [NewData|Rest]) :-
    append([_|Rest], Lines).
replace_task_data(Lines, "description", NewData, [Head, NewData|Rest]) :-
    append([Head|Rest], Lines).
replace_task_data(Lines, "date", NewData, [Head1, Head2, NewData|Rest]) :-
    append([Head1, Head2|Rest], Lines).
replace_task_data(Lines, "priority", NewData, [Head1, Head2, Head3, NewData|Rest]) :-
    append([Head1, Head2, Head3|Rest], Lines).

ifNewTaskExists(Username, ListName, TaskName) :-
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/', TaskName, '.new'], FilePath),
    exists_file(FilePath), % Verifica se o arquivo existe
    atomic_list_concat([directoryDatabase, Username, '/listas/', ListName, '/', TaskName], OriginalFilePath),
    delete_file(OriginalFilePath),
    rename_file(FilePath, OriginalFilePath).