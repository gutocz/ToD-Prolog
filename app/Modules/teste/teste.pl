% Predicado principal para listar arquivos com extensão diferente de ".txt"
listar_arquivos(Pasta) :-
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
process_choice(0, _, _) :- !.
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
    my_function(PastaSelecionada).

% Função exemplo para ser executada
my_function(PastaSelecionada) :-
    write('Executando função com a pasta: '), write(PastaSelecionada), nl.
