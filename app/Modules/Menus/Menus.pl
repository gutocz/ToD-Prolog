:- consult('../Users/Users.pl').
:- consult('../Util/Util.pl').

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
            write('listas')
            %telaListas(Login)
        ;
        Opcao = 3 ->
            menuInicial
        ;
            write('Opcao Invalida!'), nl
    ).

telaPerfil(Login) :-
    write('Menu>Login>Opcoes>Perfil>MenuPerfil'), nl,
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
    write('Menu>Login>Opcoes>Perfil'), nl,
    write('Nome: '), nl,
    getName(Login, Nome).