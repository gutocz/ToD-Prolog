:- consult('../Util/Util.pl').

directoryDatabase(Directory) :-
    Directory = '../Database/LocalUsers/'.

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

%Funções relacionadas a login
loginUserDatabase(Username, Password) :-
    directoryDatabase(Directory),
    concatenar_strings(Directory, Username, DirectoryUser),
    concatenar_strings(Username, '.txt', Usernametxt),
    concatenar_strings(DirectoryUser, '/', DirectoryUser2),
    concatenar_strings(DirectoryUser2, Usernametxt, DirectoryUserFinal),
    ler_user(DirectoryUserFinal, Dados),
    verificar_senha(Dados, Password).