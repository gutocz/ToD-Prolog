:- consult('../Users/Users.pl').

menuInicial :-
    write('ToD - Sua agenda pessoal'), nl,
    write('1 - Login'), nl,
    write('2 - Cadastro'), nl,
    write('3 - Sair'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            telaLogin
        ;
        Opcao = 2 ->
            telaCadastro
        ;
            write('Opcao Invalida!'), nl
    ).

telaLogin :-
    write('Login: '), nl,
    read(Login),
    write('Senha: '), nl,
    read(Senha),
    loginUser(Login, Senha),
    write('Login realizado com sucesso!'), nl,
    menuInicial.

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