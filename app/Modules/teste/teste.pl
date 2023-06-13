:- use_module(library(file_systems)).
:- use_module(library(lists)).

list_folders(Directory) :-
    directory_files(Directory, Files),
    exclude(hidden_file, Files, Folders),
    print_folder_names(Folders, 1),
    choose_folder(Folders).

print_folder_names([], _).
print_folder_names([Folder|Rest], N) :-
    \+ special_folder(Folder), % Verifica se a pasta é "." ou ".."
    format('~d - ~w~n', [N, Folder]),
    NextN is N + 1,
    print_folder_names(Rest, NextN).

print_folder_names([_|Rest], N) :-
    NextN is N + 1,
    print_folder_names(Rest, NextN).

choose_folder(Folders) :-
    write('Escolha o número da pasta (ou 0 para sair): '),
    read(Number),
    process_choice(Number, Folders).

process_choice(0, _) :- !.
process_choice(Number, Folders) :-
    number(Number),
    nth1(Number, Folders, Folder),
    format('Você escolheu a pasta: ~w~n', [Folder]),
    my_function(Folder).

hidden_file(File) :-
    sub_atom(File, 0, 1, _, '.').
    
special_folder('.').
special_folder('..').

my_function(Folder) :-
    write('Você está na pasta: '),
    writeln(Folder).