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
    write('2 - Deletar Perfil'), nl,
    write('3 - Sair'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            telaExibirPerfil(Login)
        ;
        Opcao = 2 ->
            deleteUser(Login),
            write('Perfil deletado com sucesso!'), nl,
            menuInicial
        ;
        Opcao = 3 ->
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
    telaAcessoLista(Login, Login, FolderName).

% Função exemplo para ser executada
my_function(FolderName) :-
    write('Executando função com a pasta: '), write(FolderName), nl.

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
    listar_arquivos(DirectoryLista, Username, Creator, Name).
% Parte que lista as tarefas
% ===========================================================================================
% Predicado principal para listar arquivos com extensão diferente de ".txt"
listar_arquivos(Pasta, Username, Creator, Name) :-
    directory_files(Pasta, Arquivos),
    filtrar_arquivos(Arquivos, Pasta, -1, ArquivosFiltrados),
    choose_folder(ArquivosFiltrados, Pasta).

% Predicado auxiliar para filtrar arquivos com extensão diferente de ".txt"
filtrar_arquivos([], _, _, []).
filtrar_arquivos([Arquivo|Outros], Pasta, Numero, [Arquivo|FiltradosResto]) :-
    Arquivo \= '.',
    Arquivo \= '..',
    atomic_list_concat([Pasta, '/', Arquivo], Caminho),
    \+ file_name_extension(_, 'txt', Caminho),
    write(Numero), write(': '), writeln(Arquivo),
    NovoNumero is Numero + 1,
    filtrar_arquivos(Outros, Pasta, NovoNumero, FiltradosResto).
filtrar_arquivos([_|Outros], Pasta, Numero, Filtrados) :-
    NovoNumero is Numero + 1,
    filtrar_arquivos(Outros, Pasta, NovoNumero, Filtrados).

% Predicado para escolher uma pasta pelo número
choose_folder(Files, Pasta) :-
    write('Escolha o número da pasta (ou 0 para sair): '),
    read(Number),
    process_choice(Number, Files, Pasta).

% Predicado para processar a escolha do usuário
process_choice(0, _, _) :- telaListarTarefas(Username, Creator, Name).
process_choice(Number, Files, Pasta) :-
    number(Number),
    nth1(Number, Files, Arquivo),
    select_folder(Arquivo, Pasta).

process_choice(_, Files, Pasta) :-
    write('Opção inválida. Tente novamente.'), nl,
    fail. % Retorna ao início do repeat para que o usuário insira uma opção válida

% Predicado para selecionar uma pasta pelo nome e executar uma função
select_folder(Folder, Pasta) :-
    \+ member(Folder, ['.', '..']), % Ignorar as pastas "." e ".."
    atomic_list_concat([Pasta, '/', Folder], PastaSelecionada),
    exists_directory(PastaSelecionada),
    write('Você escolheu a pasta: '), write(PastaSelecionada), nl,
    % Chame a função desejada aqui
    telaAcessoTarefa(Username, Creator, Name, PastaSelecionada).
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

