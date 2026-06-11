% ============================================================
%  BIBLIOTECA PESSOAL - Trabalho T2 de Programacao em Logica
%  Disciplina: Programacao em Logica (Prolog)
%  Augusto Peroni Baldino, Joao Oliveira Galeazzi e Mateus Simões Neubarth
% ============================================================

% --------------------------------------------------------------
% 1. BASE DE CONHECIMENTO (FATOS)
% --------------------------------------------------------------

:- dynamic livro/4.
:- dynamic autor/2.
:- dynamic pessoa/2.
:- dynamic emprestado/3.

% --- Autores ---
autor('Machado de Assis', 'Brasileira').
autor('J. K. Rowling',    'Britanica').
autor('George Orwell',    'Britanica').
autor('J. R. R. Tolkien', 'Britanica').
autor('Sun Tzu',          'Chinesa').

% --- Livros ---
livro('Dom Casmurro',                     'Machado de Assis', 1899, 'Romance').
livro('Harry Potter e a Pedra Filosofal', 'J. K. Rowling',    1997, 'Fantasia').
livro('1984',                             'George Orwell',    1949, 'Ficcao').
livro('O Senhor dos Aneis',               'J. R. R. Tolkien', 1954, 'Fantasia').
livro('A Arte da Guerra',                 'Sun Tzu',           500, 'Estrategia').

% --- Pessoas ---
pessoa('Maria Silva', 101).
pessoa('Joao Pedro',  102).
pessoa('Ana Souza',   103).

% --- Emprestimos iniciais ---
emprestado('1984', 101, '2026-05-20').
emprestado('Dom Casmurro', 102, '2026-05-25').


% ==============================================================
% 2. REGRAS DE CONSULTA
% ==============================================================

%% livros_por_autor(+Autor, -Titulo)
%  Verdadeiro quando Titulo e um livro escrito por Autor.
livros_por_autor(Autor, Titulo) :-
    livro(Titulo, Autor, _, _).

%% livros_antigos(+AnoMaximo, -Titulo)
%  Verdadeiro quando Titulo foi publicado em AnoMaximo ou antes.
livros_antigos(AnoMaximo, Titulo) :-
    livro(Titulo, _, Ano, _),
    Ano =< AnoMaximo.

%% disponivel(+Titulo)
%  Verdadeiro se o livro existe e NAO esta emprestado.
%  Usa negacao por falha (\+).
disponivel(Titulo) :-
    livro(Titulo, _, _, _),
    \+ emprestado(Titulo, _, _).

%% livros_emprestados_por(+NomePessoa, -Titulo)
%  Verdadeiro quando NomePessoa tem Titulo emprestado.
%  Liga o nome da pessoa ao seu identificador via pessoa/2.
livros_emprestados_por(NomePessoa, Titulo) :-
    pessoa(NomePessoa, ID),
    emprestado(Titulo, ID, _).


% ==============================================================
% 3. REGRAS DE ATUALIZACAO
% ==============================================================

%% inserir_livro(+Titulo, +Autor, +Ano, +Categoria)
%  Insere um novo livro na base, caso ainda nao exista.
inserir_livro(Titulo, Autor, Ano, Categoria) :-
    ( livro(Titulo, _, _, _) ->
        format("Erro: o livro '~w' ja existe na base.~n", [Titulo])
    ;
        assertz(livro(Titulo, Autor, Ano, Categoria)),
        format("Livro '~w' inserido com sucesso!~n", [Titulo])
    ).

%% emprestar_livro(+Titulo, +NomePessoa, +Data)
%  Registra o emprestimo de um livro a uma pessoa, verificando
%  que o livro existe, a pessoa existe e o livro esta disponivel.
emprestar_livro(Titulo, NomePessoa, Data) :-
    ( \+ livro(Titulo, _, _, _) ->
        format("Erro: o livro '~w' nao existe na base.~n", [Titulo])
    ; \+ pessoa(NomePessoa, _) ->
        format("Erro: a pessoa '~w' nao esta cadastrada.~n", [NomePessoa])
    ; emprestado(Titulo, _, _) ->
        format("Erro: o livro '~w' ja esta emprestado.~n", [Titulo])
    ;
        pessoa(NomePessoa, ID),
        assertz(emprestado(Titulo, ID, Data)),
        format("Livro '~w' emprestado para ~w em ~w.~n", [Titulo, NomePessoa, Data])
    ).

%% devolver_livro(+Titulo, +NomePessoa)
%  Remove o registro de emprestimo (retract), efetivando a devolucao.
devolver_livro(Titulo, NomePessoa) :-
    ( \+ livro(Titulo, _, _, _) ->
        format("Erro: o livro '~w' nao existe na base.~n", [Titulo])
    ; \+ pessoa(NomePessoa, _) ->
        format("Erro: a pessoa '~w' nao esta cadastrada.~n", [NomePessoa])
    ;
        pessoa(NomePessoa, ID),
        ( retract(emprestado(Titulo, ID, _)) ->
            format("Livro '~w' devolvido por ~w com sucesso!~n", [Titulo, NomePessoa])
        ;
            format("Erro: nao ha registro de emprestimo de '~w' para ~w.~n",
                   [Titulo, NomePessoa])
        )
    ).


% ==============================================================
% 4. INTERFACE TEXTUAL - BONUS
%    Para iniciar: ?- menu.
% ==============================================================

sep :-
    writeln('============================================================').

pressione_enter :-
    write('[ Pressione Enter para continuar... ] '),
    read(_).

menu :-
    nl, sep,
    writeln('        SISTEMA DE BIBLIOTECA PESSOAL'),
    sep,
    writeln(' 1. Listar todos os livros'),
    writeln(' 2. Buscar livros por autor'),
    writeln(' 3. Buscar livros antigos (ate um ano)'),
    writeln(' 4. Verificar disponibilidade de livro'),
    writeln(' 5. Ver livros emprestados por uma pessoa'),
    writeln(' 6. Inserir novo livro'),
    writeln(' 7. Emprestar livro'),
    writeln(' 8. Devolver livro'),
    writeln(' 9. Listar todos os emprestimos ativos'),
    writeln(' 0. Sair'),
    sep,
    write('Escolha uma opcao: '),
    read(Opcao), nl,
    executar(Opcao).

% Opcao 0 - Sair
executar(0) :-
    writeln('Encerrando o sistema. Ate logo!'), nl.

% Opcao 1 - Listar todos os livros
executar(1) :-
    sep, writeln('TODOS OS LIVROS DA BIBLIOTECA:'), sep,
    forall(
        livro(T, A, Ano, Cat),
        format(" - ~w (~w) | Autor: ~w | Ano: ~w~n", [T, Cat, A, Ano])
    ),
    nl, pressione_enter, menu.

% Opcao 2 - Livros por autor
executar(2) :-
    sep, writeln('BUSCA POR AUTOR'),
    write('Nome do autor (entre apostrofos, ex: \'George Orwell\'): '),
    read(Autor), nl,
    findall(T, livros_por_autor(Autor, T), Lista),
    ( Lista = [] ->
        format("Nenhum livro encontrado para o autor '~w'.~n", [Autor])
    ;
        format("Livros de ~w:~n", [Autor]),
        forall(member(T, Lista), format("  - ~w~n", [T]))
    ),
    nl, pressione_enter, menu.

% Opcao 3 - Livros antigos
executar(3) :-
    sep, writeln('BUSCA POR ANO DE PUBLICACAO'),
    write('Ano maximo (ex: 1950): '),
    read(Ano), nl,
    findall(T, livros_antigos(Ano, T), Lista),
    ( Lista = [] ->
        format("Nenhum livro encontrado ate o ano ~w.~n", [Ano])
    ;
        format("Livros publicados ate ~w:~n", [Ano]),
        forall(member(T, Lista), format("  - ~w~n", [T]))
    ),
    nl, pressione_enter, menu.

% Opcao 4 - Disponibilidade
executar(4) :-
    sep, writeln('VERIFICAR DISPONIBILIDADE'),
    write('Titulo do livro (entre apostrofos): '),
    read(Titulo), nl,
    ( \+ livro(Titulo, _, _, _) ->
        format("Livro '~w' nao encontrado na base.~n", [Titulo])
    ; disponivel(Titulo) ->
        format("O livro '~w' esta DISPONIVEL para emprestimo.~n", [Titulo])
    ;
        format("O livro '~w' esta EMPRESTADO no momento.~n", [Titulo])
    ),
    nl, pressione_enter, menu.

% Opcao 5 - Livros por pessoa
executar(5) :-
    sep, writeln('LIVROS EMPRESTADOS POR PESSOA'),
    write('Nome da pessoa (entre apostrofos): '),
    read(Nome), nl,
    ( \+ pessoa(Nome, _) ->
        format("Pessoa '~w' nao encontrada na base.~n", [Nome])
    ;
        findall(T, livros_emprestados_por(Nome, T), Lista),
        ( Lista = [] ->
            format("~w nao possui livros emprestados.~n", [Nome])
        ;
            format("Livros emprestados para ~w:~n", [Nome]),
            forall(member(T, Lista), format("  - ~w~n", [T]))
        )
    ),
    nl, pressione_enter, menu.

% Opcao 6 - Inserir livro
executar(6) :-
    sep, writeln('INSERIR NOVO LIVRO'),
    write('Titulo (entre apostrofos): '),    read(Titulo), nl,
    write('Autor (entre apostrofos): '),     read(Autor),  nl,
    write('Ano de publicacao (numero): '),   read(Ano),    nl,
    write('Categoria (entre apostrofos): '), read(Cat),    nl,
    inserir_livro(Titulo, Autor, Ano, Cat),
    nl, pressione_enter, menu.

% Opcao 7 - Emprestar livro
executar(7) :-
    sep, writeln('EMPRESTAR LIVRO'),
    write('Titulo do livro (entre apostrofos): '), read(Titulo), nl,
    write('Nome da pessoa (entre apostrofos): '),  read(Nome),   nl,
    write('Data do emprestimo (ex: \'2026-06-07\'): '), read(Data), nl,
    emprestar_livro(Titulo, Nome, Data),
    nl, pressione_enter, menu.

% Opcao 8 - Devolver livro
executar(8) :-
    sep, writeln('DEVOLVER LIVRO'),
    write('Titulo do livro (entre apostrofos): '), read(Titulo), nl,
    write('Nome da pessoa (entre apostrofos): '),  read(Nome),   nl,
    devolver_livro(Titulo, Nome),
    nl, pressione_enter, menu.

% Opcao 9 - Emprestimos ativos
executar(9) :-
    sep, writeln('EMPRESTIMOS ATIVOS:'), sep,
    findall(T-Nome-D,
            ( emprestado(T, ID, D), pessoa(Nome, ID) ),
            Lista),
    ( Lista = [] ->
        writeln('Nenhum livro emprestado no momento.')
    ;
        forall(
            member(T-Nome-D, Lista),
            format(" - '~w'~n   Para: ~w | Data: ~w~n", [T, Nome, D])
        )
    ),
    nl, pressione_enter, menu.

% Opcao invalida
executar(_) :-
    writeln('Opcao invalida! Escolha entre 0 e 9.'),
    nl, menu.
