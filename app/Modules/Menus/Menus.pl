:- consult('../Users/Users.pl').
:- consult('../Util/Util.pl').
:- consult('../ToDoList/ToDoList.pl').

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
    write('Login: '), nl,
    read(Login),
    write('Senha: '), nl,
    read(Senha),
    (
        loginUser(Login, Senha) ->
            write('Login realizado com sucesso!'), nl,
            telaLogin(Login)
        ;
            write('Login ou senha incorretos!'), nl,
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
    createUser(Nome, Username, Senha, Descricao),
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
    directory_files(DirectoryListas, Files),
    print_folder_names(Files),
    repeat,
    choose_folder(Files, Login),
    halt.

%Funções auxiliares pra listar listas
%==================================================
% Predicado para imprimir os nomes das pastas
print_folder_names(Files) :-
    print_folder_names(Files, 1).

print_folder_names([], _).
print_folder_names([File|Rest], N) :-
    atom_concat(N, '- ', NumberPrefix),
    atom_concat(NumberPrefix, File, FolderName),
    write(FolderName), nl,
    NextN is N + 1,
    print_folder_names(Rest, NextN).

% Predicado para escolher uma pasta pelo número
choose_folder(Files, Login) :-
    write('Escolha o número da pasta (ou 0 para sair): '),
    read(Number),
    process_choice(Number, Files, Login).

% Predicado para processar a escolha do usuário
process_choice(0, _, Login) :- !, telaListas(Login).
process_choice(Number, Files, Login) :-
    number(Number),
    select_folder(Number, Files),
    nl.

process_choice(_, Files, Login) :-
    write('Opção inválida. Tente novamente.'), nl,
    fail. % Retorna ao início do repeat para que o usuário insira uma opção válida

% Predicado para selecionar uma pasta pelo número e executar uma função
select_folder(Number, Files) :-
    length(Files, NumFolders),
    Number > 0,
    Number =< NumFolders,
    nth1(Number, Files, Folder),
    atom_concat('listas/', FolderName, Folder),
    directory_exists(FolderName),
    write('Você escolheu a pasta: '), write(FolderName), nl,
    % Chame a função desejada aqui
    my_function(FolderName).

% Função exemplo para ser executada
my_function(FolderName) :-
    write('Executando função com a pasta: '), write(FolderName), nl.

%===========================================================================

telaCadastroListas(Login) :-
    write('Menu>Login>Opcoes>Listas>Criar Lista'), nl,
    write(''), nl,
    write('Nome da Lista: '), nl,
    read(NomeLista),
    write('Descrição da Lista: '), nl,
    read(DescricaoLista),
    createToDoList(Login, NomeLista, DescricaoLista),
    write('Lista criada com sucesso!'), nl,
    telaListas(Login).