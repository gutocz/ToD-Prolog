:- consult('../Users/Users.pl').
:- consult('../Util/Util.pl').
:- consult('../ToDoList/ToDoList.pl').
:- consult('../Database/Database.pl').

menuInicial :-
    write('ToD - Sua agenda pessoal'), nl,
    write('1 - Login'), nl,
    write('2 - Cadastro'), nl,
    write('3 - Sair'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            login
        ;
        Opcao = 2 ->
            telaCadastro
        ;
        Opcao = 3 ->
            write('Saindo...'), nl
        ;
            write('Opcao Invalida!'), nl
    ).

login :-
    write('Username: '), nl,
    read(Login),
    write('Senha: '), nl,
    read(Senha),
    (
        loginUser(Login, Senha) ->
            write('Login realizado com sucesso!'), nl,
            telaLogin(Login)
        ;
            write('Senha incorreta!'), nl,
            login
    ).


telaCadastro :-
    write('Nome: '), nl,
    read(Nome),
    write('Username: '), nl,
    read(Username),
    write('Senha: '), nl,
    read(Senha),
    write('Descrição: '), nl,
    read(Descricao),
    createUser(Username, Name, Senha, Descricao),
    write('Usuário cadastrado com sucesso!'), nl,
    menuInicial.

telaLogin(Login) :-
    write('Menu>Login'), nl,
    write('1 - Perfil'), nl,
    write('2 - Listas'), nl,
    write('3 - Logout'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            telaPerfil(Login)
        ;
        Opcao = 2 ->
            telaListas(Login)
        ;
        Opcao = 3 ->
            menuInicial
        ;
            write('Opcao Invalida!'), nl
    ).

telaPerfil(Login) :-
    write('Menu>Login>Opcoes>Perfil'), nl,
    write('1 - Exibir Perfil'), nl,
    %write('2 - Deletar Perfil'), nl,
    write('2 - Sair'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            telaExibirPerfil(Login)
        ;
        Opcao = 2 ->
            telaLogin(Login)
        ;
            write('Opcao Invalida!'), nl
    ).

telaExibirPerfil(Login) :-
    write('Menu>Login>Opcoes>Perfil>MenuPerfil'), nl,
    write('Nome: '), nl,
    getDados(Login, Dados),
    nth0(0, Dados, Nome),
    write(Nome), nl,
    write('Descricao: '), nl,
    nth0(3, Dados, Descricao),
    write(Descricao), nl,
    write('0 - Voltar'), nl,
    read(Opcao),
    (
        Opcao = 0 ->
            telaPerfil(Login)
        ;
            write('Opcao Invalida!'), nl
    ).

telaListas(Login) :-
    write('Menu>Login>Opcoes>Listas'), nl,
    write(''), nl,
    write('1- Minhas Listas'), nl,
    write('2- Listas Compartilhadas'), nl,
    write('3- Criar Lista'), nl,
    write('4- Sair'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            telaListasPerfil(Login)
        ;
        Opcao = 2 ->
            telaListasCompartilhadas(Login)
        ;
        Opcao = 3 ->
            telaCadastroListas(Login)
        ;
        Opcao = 4 ->
            telaLogin(Login)
        ;
            write('Opcao Invalida!'), nl
    ).

telaListasPerfil(Login) :-
    directoryDatabase(Directory),
    concatenar_strings(Directory, Login, DirectoryLogin),
    concatenar_strings(DirectoryLogin, '/', DirectoryLoginBarra),
    concatenar_strings(DirectoryLoginBarra, 'listas', DirectoryListas),
    write('Menu>Login>Opcoes>Listas>Minhas Listas'), nl,
    write(''), nl,
    write('Minhas Listas:'), nl,
    list_folders(DirectoryListas, Login, Login).
    
telaListasCompartilhadas(Login) :-
    directoryDatabase(Directory),
    atomic_list_concat([Directory, Login, '/sharedWithMe/'], DirectoryShared),
     write('Menu>Login>Opcoes>Listas>ListasCompartilhadas'), nl,
    write(''), nl,
    write('Listas Compartilhadas Comigo'), nl,
    getSharedList(Login, Lists),
    write('0. Sair'), nl,
    listasNumeradas(Listas, ListasNumeradas),
    printListasNumeradas(ListasNumeradas),
    readOption(Option),
    handleListasCompartilhadasOption(Option, Username, Listas).

%Funções auxiliares pra listar listas
%==================================================
list_folders(Directory, Username, Username) :-
    directory_files(Directory, Files),
    exclude(hidden_file, Files, Folders),
    print_folder_names(Folders, 1),
    choose_folder(Folders, Username, Username).

print_folder_names([], _).
print_folder_names([Folder|Rest], N) :-
    \+ special_folder(Folder), % Verifica se a pasta é "." ou ".."
    format('~d - ~w~n', [N, Folder]),
    NextN is N + 1,
    print_folder_names(Rest, NextN).

print_folder_names([_|Rest], N) :-
    NextN is N + 1,
    print_folder_names(Rest, NextN).

choose_folder(Folders, Username, Username) :-
    write('Escolha o número da pasta (ou 0 para sair): '),
    read(Number),
    process_choice(Number, Folders, Username, Username).

process_choice(0, _, _, _) :- telaListas(Username).
process_choice(Number, Folders, Username, Username) :-
    number(Number),
    nth1(Number, Folders, Folder),
    format('Você escolheu a pasta: ~w~n', [Folder]),
    telaAcessoLista(Username, Username, Folder).

hidden_file(File) :-
    sub_atom(File, 0, 1, _, '.').
    
special_folder('.').
special_folder('..').
%===========================================================================

telaCadastroListas(Username) :-
    write('Menu>Login>Opcoes>Listas>Criar Lista'), nl,
    write(''), nl,
    write('Nome da Lista: '), nl,
    read(NomeLista),
    write('Descrição da Lista: '), nl,
    read(DescricaoLista),
    createToDoList(Username, NomeLista, DescricaoLista),
    write('Lista criada com sucesso!'), nl,
    telaListas(Username).

telaAcessoLista(Username, Creator, Name) :-
    write('Menu>Login>Opcoes>Listas>Tarefas'),
    write(''), nl,
    write('1- Adicionar Tarefa'), nl,
    write('2- Listar Tarefas'), nl,
    write('3- Compartilhar Lista'), nl,
    write('4- Deletar Lista'), nl,
    write('5- Sair'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            telaAdicionarTarefa(Username, Creator, Name)
        ;
        Opcao = 2 ->
            telaListarTarefas(Username, Creator, Name)
        ;
        Opcao = 3 ->
            write('Digite o nome do usuario que deseja compartilhar a lista: '), nl,
            read(Usuario),
            addUserToList(Usuario, Creator, Name),
            telaAcessoLista(Username, Creator, Name)
        ;
        Opcao = 4 ->
            write('Tem certeza que deseja deletar a lista? (S/N)'), nl,
            read(Resposta),
            (
                Resposta = 'S' ->
                    deleteToDoList(Username, Name),
                    telaListas(Username)
                ;
                Resposta = 'N' ->
                    telaAcessoLista(Username, Creator, Name)
                ;
                    write('Opcao Invalida!'), nl,
                    telaAcessoLista(Username, Creator, Name)
            )
        ;
        Opcao = 5 ->
            telaListas(Username)
        ;
            write('Opcao Invalida!'), nl,
            telaAcessoLista(Username, Creator, Name)
    ).

telaListarTarefas(Username, Creator, Name) :-
    directoryDatabase(Directory),
    concatenar_strings(Directory, Creator, DirectoryCreator),
    concatenar_strings(DirectoryCreator, '/', DirectoryCreatorBarra),
    concatenar_strings(DirectoryCreatorBarra, 'listas', DirectoryListas),
    concatenar_strings(DirectoryListas, '/', DirectoryListasBarra),
    concatenar_strings(DirectoryListasBarra, Name, DirectoryLista),
    write('Menu>Login>Opcoes>Listas>Tarefas>Listar Tarefas'), nl,
    write(''), nl,
    write('Tarefas:'), nl,
    listar_pastas(DirectoryLista, Username, Creator, Name).
% Parte que lista as tarefas
% ===========================================================================================
% Predicado principal para listar arquivos com extensão diferente de ".txt"
listar_pastas(Directory, Username, Creator, Name) :-
    directory_files(Directory, Files),
    exclude(hidden_file, Files, Folders),
    print_folder(Folders, 1),
    escolher_pastas(Folders, Username, Creator, Name).

print_folder([], _).
print_folder([Folder|Rest], N) :-
    \+ special_folder(Folder), % Verifica se a pasta é "." ou ".."
    format('~d - ~w~n', [N, Folder]),
    NextN is N + 1,
    print_folder_names(Rest, NextN).

print_folder([_|Rest], N) :-
    NextN is N + 1,
    print_folder_names(Rest, NextN).

escolher_pastas(Folders, Username, Creator, Name) :-
    write('Escolha o número da pasta (ou 0 para sair): '),
    read(Number),
    processar_escolha(Number, Folders, Username, Creator, Name).

processar_escolha(0, _, _, _, _) :- telaAcessoLista(Username, Creator, Name).
processar_escolha(Number, Folders, Username, Creator, Name) :-
    number(Number),
    nth1(Number, Folders, Folder),
    format('Você escolheu a pasta: ~w~n', [Folder]),
    telaAcessoTarefa(Username, Username, Folder).

hidden_file(File) :-
    sub_atom(File, 0, 1, _, '.').
    
special_folder('.').
special_folder('..').
% ===========================================================================================
% Funções auxiliares listas Compartilhadas

listasNumeradas(Listas, ListasNumeradas) :-
    listasNumeradas(Listas, 1, ListasNumeradas).

listasNumeradas([], _, []).
listasNumeradas([Lista|Listas], Index, [(Index, Lista)|ListasNumeradas]) :-
    NextIndex is Index + 1,
    listasNumeradas(Listas, NextIndex, ListasNumeradas).

printListasNumeradas([]).
printListasNumeradas([(Index, Lista)|Listas]) :-
    write(Index), write('. '), write(Lista), nl,
    printListasNumeradas(Listas).

readOption(Option) :-
    read_line_to_string(user_input, Option).

handleListasCompartilhadasOption("0", _, _) :-
    telaListas(Username).
handleListasCompartilhadasOption(Option, Username, Listas) :-
    number_string(Index, Option),
    nth1(Index, Listas, ListName),
    atomic_list_concat([directoryDatabase, Username, '/sharedWithMe/', ListName], FilePath),
    read_file_to_string(FilePath, FileContent, []),
    split_string(FileContent, "\n", "", Lines),
    nth1(1, Lines, Creator),
    telaAcessoLista(Username, Creator, ListName).

telaAdicionarTarefa(Username, Creator, Name) :-
    write('Menu>Login>Opcoes>Listas>Tarefas>Adicionar Tarefa'), nl,
    write(''), nl,
    write('Nome da Tarefa: '), nl,
    read(NomeTarefa),
    write('Descrição da Tarefa: '), nl,
    read(DescricaoTarefa),
    write('Pra qual dia você quer adicionar essa tarefa? (dd/mm/aaaa)'),
    read(Data),
    write('Qual a prioridade dessa tarefa? (1 - 5)'),
    read(Prioridade),
    addTask(Username, Name, NomeTarefa, DescricaoTarefa, Data, Prioridade),
    write('Tarefa criada com sucesso!'), nl,
    telaAcessoLista(Username, Creator, Name).