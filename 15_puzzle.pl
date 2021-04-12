% Felipe Kuhnert - 117059590
% Leonardo Ventura - 117093706


%%%% Como o tabuleiro é definido
% Pode ser recuperado com tabuleiro(T)

%%%%%% Estado Inicial do PDF, Insolucionável %%%%%%
% tabuleiro([
%    15,  2,  1, 12,
%    8,  5,  6, 11,
%    4,  9, 10, 7,
%    3, 14, 13, 255
% ]).

%%%%%%%%%%%%%%%%% TESTE 1 %%%%%%%%%%%%%%%%%
% tabuleiro([
%    255,  1,  8, 6,
%    5,  2,  4, 3,
%    9, 10,  7, 11,
%    13, 14, 15, 12
% ]).

%%%%%%%%%%%%%%%%% TESTE 2 %%%%%%%%%%%%%%%%%
% tabuleiro([
%    5,  1,  3,  4,
%    2,  7,  255,  8,
%    9, 6, 15, 11,
%   13, 10, 14, 12
% ]).

%%%%%%%%%%%%%%%%% TESTE 3 %%%%%%%%%%%%%%%%%
tabuleiro([
   5,  1,  4,  8,
   2,  7,  3,  11,
   9, 6, 15, 12,
  13, 255, 10, 14
]).

% Define o estado objetivo
objetivo([
   1,  2,  3,  4,
   5,  6,  7,  8,
   9, 10, 11, 12,
  13, 14, 15, 255
]).

even(N) :- N mod 2 =:= 0.

%%%%%%%%%%%%% Checagem se tabuleiro é resolvível ou não %%%%%%%%%%%%%
% Se o vazio estiver numa linha ímpar, e o número de inversões for par, é resolvível
valida_tabuleiro(T) :-
   nth0(INDEX, T, 255),
   B is INDEX//4,
   not(even(B)),
   conta_inversoes(C),
   even(C).

% Se o vazio estiver numa linha par, e o número de inversões for ímpar, é resolvível
valida_tabuleiro(T) :-
   nth0(INDEX, T, 255),
   B is INDEX//4,
   even(B),
   conta_inversoes(C),
   not(even(C)).

% Contador de inversões
% Inversão: se a>b e "a" aparece antes de "b" na lista
conta_inversoes(Cont) :-
   tabuleiro([H|T]),
   soma_inversoes_total(H,T,Cont).

soma_inversoes_total(_, [], 0).
soma_inversoes_total(H,[T1|T2],Cont) :-
   H \= 255,
   soma_inversoes(H,[T1|T2],Cont1),
   soma_inversoes_total(T1,T2,Cont2),
   Cont is Cont1 + Cont2.

soma_inversoes_total(H,[T1|T2],Cont) :-
   H = 255,
   soma_inversoes_total(T1,T2,Cont).

soma_inversoes(_,[],0).
soma_inversoes(H,[T1|T2],Cout) :-
   H > T1,
   soma_inversoes(H,T2,Cout2),
   Cout is Cout2 + 1.

soma_inversoes(H,[T1|T2],Cout) :-
   H =< T1,
   soma_inversoes(H,T2,Cout).
%%%%%%%%%%%%%%%%%%%%%%%%%% FIM Checagem %%%%%%%%%%%%%%%%%%%%%%%%%%

% Caso em que o tabuleiro não é válido
busca(_, _, _) :-
   tabuleiro(T),
   not(valida_tabuleiro(T)), !,
   writeln("Não existe caminho"),
   false.

% Busca usando a heurística de número de peças fora do lugar
busca(h1, Sequencia, TotalNosGerados) :-
   tabuleiro(T),
   valida_tabuleiro(T),
   resolve_tabuleiro_h1((0,0, T, []), [], [], Sequencia, TotalNosGerados).

% Busca usando a heurística de Distância Manhattan
busca(h2, Sequencia, TotalNosGerados) :-
   tabuleiro(T),
   valida_tabuleiro(T),
   resolve_tabuleiro_h2((0,0, T, []), [], [], Sequencia, TotalNosGerados).

%%%%%%%%%%%%%% INICIO Loop Principal h1 %%%%%%%%%%%%%%
% Functor para resolver o tabuleiro `T` usando heuristica h1
resolve_tabuleiro_h1((_, _, T, Acoes), _, TabuleirosVisitados, Sequencia, TotalNosGerados) :-
   objetivo(T),
   length(TabuleirosVisitados, TotalNosGerados),
   reverse(Acoes, Sequencia).

resolve_tabuleiro_h1((_, G_n, T, Acoes), FilaDeCusto, TabuleirosVisitados, Sequencia, TotalNosGerados) :-
   not(objetivo(T)),
   not(member(T, TabuleirosVisitados)),
   vizinho(T, Acoes, TabuleirosFilhos),
   NextG_n is G_n + 1,
   calcula_h1_e_insere_filhos(TabuleirosFilhos, NextG_n, FilaDeCusto, [MenorEstado | OutrosEstados]),
   resolve_tabuleiro_h1(MenorEstado, OutrosEstados, [T | TabuleirosVisitados], Sequencia, TotalNosGerados).

resolve_tabuleiro_h1((_, _, T, _), [MenorEstado | OutrosEstados], TabuleirosVisitados,
                     Sequencia, TotalNosGerados) :-
   member(T, TabuleirosVisitados),
   resolve_tabuleiro_h1(MenorEstado, OutrosEstados, TabuleirosVisitados, Sequencia, TotalNosGerados).
%%%%%%%%%%%%%% FIM Loop Principal h1 %%%%%%%%%%%%%%


%%%%%%%%%%%%%% INICIO Loop Principal h2 %%%%%%%%%%%%%%
% Functor para resolver o tabuleiro `T` usando heuristica h1
resolve_tabuleiro_h2((_, _, T, Acoes), _, TabuleirosVisitados, Sequencia, TotalNosGerados) :-
   objetivo(T),
   length(TabuleirosVisitados, TotalNosGerados),
   reverse(Acoes, Sequencia).

resolve_tabuleiro_h2((_, G_n, T, Acoes), FilaDeCusto, TabuleirosVisitados, Sequencia, TotalNosGerados) :-
   not(objetivo(T)),
   not(member(T, TabuleirosVisitados)),
   vizinho(T, Acoes, TabuleirosFilhos),
   NextG_n is G_n + 1,
   calcula_h2_e_insere_filhos(TabuleirosFilhos, NextG_n, FilaDeCusto, [MenorEstado | OutrosEstados]),
   resolve_tabuleiro_h2(MenorEstado, OutrosEstados, [T | TabuleirosVisitados], Sequencia, TotalNosGerados).

resolve_tabuleiro_h2((_, _, T, _), [MenorEstado | OutrosEstados], TabuleirosVisitados,
                     Sequencia, TotalNosGerados) :-
   member(T, TabuleirosVisitados),
   resolve_tabuleiro_h2(MenorEstado, OutrosEstados, TabuleirosVisitados, Sequencia, TotalNosGerados).
%%%%%%%%%%%%%% FIM Loop Principal h2 %%%%%%%%%%%%%%


%%%%%%%%%%%%%% HEURISTICAS %%%%%%%%%%%%%%
% Calcula a quantidade de peças fora do lugar
% Utilizado para a heuristica 1
pecas_fora_do_lugar(T,Cont) :-
   objetivo(O),
   pecas_fora_do_lugar_iter(T,O,Cont).

pecas_fora_do_lugar_iter([], [], 0).
pecas_fora_do_lugar_iter([HE|TE], [HO|TO], C2) :-
   HE \= HO,!,
   pecas_fora_do_lugar_iter(TE,TO,C1),
   C2 is C1 + 1.

pecas_fora_do_lugar_iter([_|TE], [_|TO], C) :-
   pecas_fora_do_lugar_iter(TE,TO,C).

% Calcula a distância manhattan
% Utilizado para a heuristica 2
distancia_manhattan(T,Cont) :-
   manhattan_total(T,T,Cont).

manhattan_total(_, [], 0).
manhattan_total(TAB,[H|T],Cont) :-
% 255 foi o valor que utilizamos para definir onde fica o espaço vazio
% do nosso puzzle
   H = 255,!,
   manhattan_total(TAB, T, Cont).

manhattan_total(TAB,[H|T],Cont) :-
   manhattan(TAB, H, Dist),
   manhattan_total(TAB, T, Cont2),
   Cont is Dist + Cont2.

manhattan(T, V1, Dist) :-
   nth0(INDEX1, T, V1),
   LinhaAtual is INDEX1//4,
   ColunaAtual is INDEX1 mod 4,

   objetivo(O),
   nth0(INDEX2, O, V1),
   LinhaFinal is INDEX2//4,
   ColunaFinal is INDEX2 mod 4,

   Dist is abs(LinhaFinal - LinhaAtual) + abs(ColunaFinal - ColunaAtual).
%%%%%%%%%%%%%% FIM HEURISTICAS %%%%%%%%%%%%%%


%%%%%%%%%%%%%% Funcoes Auxiliares %%%%%%%%%%%%%%
calcula_h1_e_insere_filhos([], _, FilaDeCusto, FilaDeCusto).
calcula_h1_e_insere_filhos([(TabuleiroFilho, Acoes) | OutrosTabuleirosFilhos], G_n,
                          FilaDeCusto, NovaFilaDeCusto) :-
   pecas_fora_do_lugar(TabuleiroFilho, PecasForaDoLugar),
   Custo is PecasForaDoLugar + G_n,
   ordered_insert((Custo, G_n, TabuleiroFilho, Acoes), FilaDeCusto, MeioFilaDeCusto),
   calcula_h1_e_insere_filhos(OutrosTabuleirosFilhos, G_n, MeioFilaDeCusto, NovaFilaDeCusto).


calcula_h2_e_insere_filhos([], _, FilaDeCusto, FilaDeCusto).
calcula_h2_e_insere_filhos([(TabuleiroFilho, Acoes) | OutrosTabuleirosFilhos], G_n,
                          FilaDeCusto, NovaFilaDeCusto) :-
   distancia_manhattan(TabuleiroFilho, PecasForaDoLugar),
   Custo is PecasForaDoLugar + G_n,
   ordered_insert((Custo, G_n, TabuleiroFilho, Acoes), FilaDeCusto, MeioFilaDeCusto),
   calcula_h2_e_insere_filhos(OutrosTabuleirosFilhos, G_n, MeioFilaDeCusto, NovaFilaDeCusto).


ordered_insert(Tab, [], [Tab]).
ordered_insert((Custo, G_n, Tab, Acoes), [(MenorCusto, MenorG_n, Tabuleiro, AcoesMenor) | Tail],
               [(Custo, G_n, Tab, Acoes),(MenorCusto, MenorG_n, Tabuleiro, AcoesMenor) | Tail]) :-
   Custo =< MenorCusto, !.

ordered_insert(EstadoTabuleiro, [Head | Tail], [Head | EstadosOrdenados]) :-
   ordered_insert(EstadoTabuleiro, Tail, EstadosOrdenados).

vizinho(TAB, AcoesPai, NN) :-
   findall((TAB2, [Acao | AcoesPai]), acao(TAB, Acao, TAB2), NN).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%% Solução mais inteligente para achar as ações possíveis
%%% Desenvolvemos esses 4 métodos, mas eles não são muito eficientes com o espaço em memória.

% acao(Tabuleiro, direita, NovoTabuleiro) :-
%    nth0(Index255, Tabuleiro, 255),
%    Index255 mod 4 \= 3,		% Garanto que não estou no máximo à direita
%    Next255Index is Index255 + 1,
%    nth0(Next255Index, Tabuleiro, PecaAnterior),
%    replace_nth0(Tabuleiro, Index255, PecaAnterior, MidTabuleiro),
%    replace_nth0(MidTabuleiro, Next255Index, 255, NovoTabuleiro).

% acao(Tabuleiro, esquerda, NovoTabuleiro) :-
%    nth0(Index255, Tabuleiro, 255),
%    Index255 mod 4 =:= 0,		% Garanto que não estou no máximo à esquerda
%    Next255Index is Index255 - 1,
%    nth0(Next255Index, Tabuleiro, PecaAnterior),
%    replace_nth0(Tabuleiro, Index255, PecaAnterior, MidTabuleiro),
%    replace_nth0(MidTabuleiro, Next255Index, 255, NovoTabuleiro).

% acao(Tabuleiro, baixo, NovoTabuleiro) :-
%    nth0(Index255, Tabuleiro, 255),
%    Index255 < 11,		% Garanto que não estou na última linha
%    Next255Index is Index255 + 4,
%    nth0(Next255Index, Tabuleiro, PecaAnterior),
%    replace_nth0(Tabuleiro, Index255, PecaAnterior, MidTabuleiro),
%    replace_nth0(MidTabuleiro, Next255Index, 255, NovoTabuleiro).

% acao(Tabuleiro, cima, NovoTabuleiro) :-
%    nth0(Index255, Tabuleiro, 255),
%    Index255 > 4,		% Garanto que não estou na primeira linha
%    Next255Index is Index255 - 4,
%    nth0(Next255Index, Tabuleiro, PecaAnterior),
%    replace_nth0(Tabuleiro, Index255, PecaAnterior, MidTabuleiro),
%    replace_nth0(MidTabuleiro, Next255Index, 255, NovoTabuleiro).

% replace_nth0(List, Index, NewElem, NewList) :-
%    nth0(Index,List,_,Transfer),
%    nth0(Index,NewList,NewElem,Transfer).

%%%%%%%%% Início da Declaração das Ações Possíveis %%%%%%%%%
% Mover para a direita
acao([
  255, A, B, C,
  D, E, F, G,
  H, I, J, K,
  L, M, N, O
], direita, [
  A, 255, B, C,
  D, E, F, G,
  H, I, J, K,
  L, M, N, O
]).
acao([
  A, 255, B, C,
  D, E, F, G,
  H, I, J, K,
  L, M, N, O
], direita, [
  A, B, 255, C,
  D, E, F, G,
  H, I, J, K,
  L, M, N, O
]).
acao([
  A, B, 255, C,
  D, E, F, G,
  H, I, J, K,
  L, M, N, O
], direita, [
  A, B, C, 255,
  D, E, F, G,
  H, I, J, K,
  L, M, N, O
]).

acao([
  A, B, C, D,
  255, E, F, G,
  H, I, J, K,
  L, M, N, O
], direita, [
  A, B, C, D,
  E, 255, F, G,
  H, I, J, K,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, 255, F, G,
  H, I, J, K,
  L, M, N, O
], direita, [
  A, B, C, D,
  E, F, 255, G,
  H, I, J, K,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, F, 255, G,
  H, I, J, K,
  L, M, N, O
], direita, [
  A, B, C, D,
  E, F, G, 255,
  H, I, J, K,
  L, M, N, O
]).

acao([
  A, B, C, D,
  E, F, G, H,
  255, I, J, K,
  L, M, N, O
], direita, [
  A, B, C, D,
  E, F, G, H,
  I, 255, J, K,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  I, 255, J, K,
  L, M, N, O
], direita, [
  A, B, C, D,
  E, F, G, H,
  I, J, 255, K,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  I, J, 255, K,
  L, M, N, O
], direita, [
  A, B, C, D,
  E, F, G, H,
  I, J, K, 255,
  L, M, N, O
]).

acao([
  A, B, C, D,
  E, F, G, H,
  I, J, K, L,
  255, M, N, O
], direita, [
  A, B, C, D,
  E, F, G, H,
  I, J, K, L,
  M, 255, N, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  I, J, K, L,
  M, 255, N, O
], direita, [
  A, B, C, D,
  E, F, G, H,
  I, J, K, L,
  M, N, 255, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  I, J, K, L,
  M, N, 255, O
], direita, [
  A, B, C, D,
  E, F, G, H,
  I, J, K, L,
  M, N, O, 255
]).

% Mover para a esquerda
acao([
   A, 255, B, C,
   D, E, F, G,
   H, I, J, K,
   L, M, N, O
], esquerda, [
   255, A, B, C,
   D, E, F, G,
   H, I, J, K,
   L, M, N, O
]).
acao([
   A, B, 255, C,
   D, E, F, G,
   H, I, J, K,
   L, M, N, O
], esquerda, [
   A, 255, B, C,
   D, E, F, G,
   H, I, J, K,
   L, M, N, O
]).
acao([
   A, B, C, 255,
   D, E, F, G,
   H, I, J, K,
   L, M, N, O
], esquerda, [
   A, B, 255, C,
   D, E, F, G,
   H, I, J, K,
   L, M, N, O
]).
 
acao([
   A, B, C, D,
   E, 255, F, G,
   H, I, J, K,
   L, M, N, O
], esquerda, [
   A, B, C, D,
   255, E, F, G,
   H, I, J, K,
   L, M, N, O
]).
acao([
   A, B, C, D,
   E, F, 255, G,
   H, I, J, K,
   L, M, N, O
], esquerda, [
   A, B, C, D,
   E, 255, F, G,
   H, I, J, K,
   L, M, N, O
]).
acao([
   A, B, C, D,
   E, F, G, 255,
   H, I, J, K,
   L, M, N, O
], esquerda, [
   A, B, C, D,
   E, F, 255, G,
   H, I, J, K,
   L, M, N, O
]).
 
acao([
   A, B, C, D,
   E, F, G, H,
   I, 255, J, K,
   L, M, N, O
], esquerda, [
   A, B, C, D,
   E, F, G, H,
   255, I, J, K,
   L, M, N, O
]).
acao([
   A, B, C, D,
   E, F, G, H,
   I, J, 255, K,
   L, M, N, O
], esquerda, [
   A, B, C, D,
   E, F, G, H,
   I, 255, J, K,
   L, M, N, O
]).
acao([
   A, B, C, D,
   E, F, G, H,
   I, J, K, 255,
   L, M, N, O
], esquerda, [
   A, B, C, D,
   E, F, G, H,
   I, J, 255, K,
   L, M, N, O
]).
 
acao([
   A, B, C, D,
   E, F, G, H,
   I, J, K, L,
   M, 255, N, O
], esquerda, [
   A, B, C, D,
   E, F, G, H,
   I, J, K, L,
   255, M, N, O
]).
acao([
   A, B, C, D,
   E, F, G, H,
   I, J, K, L,
   M, N, 255, O
], esquerda, [
   A, B, C, D,
   E, F, G, H,
   I, J, K, L,
   M, 255, N, O
]).
acao([
   A, B, C, D,
   E, F, G, H,
   I, J, K, L,
   M, N, O, 255
], esquerda, [
   A, B, C, D,
   E, F, G, H,
   I, J, K, L,
   M, N, 255, O
]).

% Mover para cima
acao([
  A, B, C, D,
  255, E, F, G,
  H, I, J, K,
  L, M, N, O
], cima, [
  255, B, C, D,
  A, E, F, G,
  H, I, J, K,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, 255, F, G,
  H, I, J, K,
  L, M, N, O
], cima, [
  A, 255, C, D,
  E, B, F, G,
  H, I, J, K,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, F, 255, G,
  H, I, J, K,
  L, M, N, O
], cima, [
  A, B, 255, D,
  E, F, C, G,
  H, I, J, K,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, F, G, 255,
  H, I, J, K,
  L, M, N, O
], cima, [
  A, B, C, 255,
  E, F, G, D,
  H, I, J, K,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  255, I, J, K,
  L, M, N, O
], cima, [
  A, B, C, D,
  255, F, G, H,
  E, I, J, K,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  I, 255, J, K,
  L, M, N, O
], cima, [
  A, B, C, D,
  E, 255, G, H,
  I, F, J, K,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  I, J, 255, K,
  L, M, N, O
], cima, [
  A, B, C, D,
  E, F, 255, H,
  I, J, G, K,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  I, J, K, 255,
  L, M, N, O
], cima, [
  A, B, C, D,
  E, F, G, 255,
  I, J, K, H,
  L, M, N, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  I, J, K, L,
  255, M, N, O
], cima, [
  A, B, C, D,
  E, F, G, H,
  255, J, K, L,
  I, M, N, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  I, J, K, L,
  M, 255, N, O
], cima, [
  A, B, C, D,
  E, F, G, H,
  I, 255, K, L,
  M, J, N, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  I, J, K, L,
  M, N, 255, O
], cima, [
  A, B, C, D,
  E, F, G, H,
  I, J, 255, L,
  M, N, K, O
]).
acao([
  A, B, C, D,
  E, F, G, H,
  I, J, K, L,
  M, N, O, 255
], cima, [
  A, B, C, D,
  E, F, G, H,
  I, J, K, 255,
  M, N, O, L
]).

% Mover para baixo
acao([
   255, B, C, D,
   A, E, F, G,
   H, I, J, K,
   L, M, N, O
], baixo, [
   A, B, C, D,
   255, E, F, G,
   H, I, J, K,
   L, M, N, O
]).

acao([
   A, 255, C, D,
   E, B, F, G,
   H, I, J, K,
   L, M, N, O
], baixo, [
   A, B, C, D,
   E, 255, F, G,
   H, I, J, K,
   L, M, N, O
]).

acao([
   A, B, 255, D,
   E, F, C, G,
   H, I, J, K,
   L, M, N, O
], baixo, [
   A, B, C, D,
   E, F, 255, G,
   H, I, J, K,
   L, M, N, O
]).

acao([
   A, B, C, 255,
   E, F, G, D,
   H, I, J, K,
   L, M, N, O
], baixo, [
   A, B, C, D,
   E, F, G, 255,
   H, I, J, K,
   L, M, N, O
]).

acao([
   A, B, C, D,
   255, F, G, H,
   E, I, J, K,
   L, M, N, O
], baixo, [
   A, B, C, D,
   E, F, G, H,
   255, I, J, K,
   L, M, N, O
]).

acao([
   A, B, C, D,
   E, 255, G, H,
   I, F, J, K,
   L, M, N, O
], baixo, [
   A, B, C, D,
   E, F, G, H,
   I, 255, J, K,
   L, M, N, O
]).

acao([
   A, B, C, D,
   E, F, 255, H,
   I, J, G, K,
   L, M, N, O
], baixo, [
   A, B, C, D,
   E, F, G, H,
   I, J, 255, K,
   L, M, N, O
]).

acao([
   A, B, C, D,
   E, F, G, 255,
   I, J, K, H,
   L, M, N, O
], baixo, [
   A, B, C, D,
   E, F, G, H,
   I, J, K, 255,
   L, M, N, O
]).

acao([
   A, B, C, D,
   E, F, G, H,
   255, J, K, L,
   I, M, N, O
], baixo, [
   A, B, C, D,
   E, F, G, H,
   I, J, K, L,
   255, M, N, O
]).

acao([
   A, B, C, D,
   E, F, G, H,
   I, 255, K, L,
   M, J, N, O
], baixo, [
   A, B, C, D,
   E, F, G, H,
   I, J, K, L,
   M, 255, N, O
]).

acao([
   A, B, C, D,
   E, F, G, H,
   I, J, 255, L,
   M, N, K, O
], baixo, [
   A, B, C, D,
   E, F, G, H,
   I, J, K, L,
   M, N, 255, O
]).

acao([
   A, B, C, D,
   E, F, G, H,
   I, J, K, 255,
   M, N, O, L
], baixo, [
   A, B, C, D,
   E, F, G, H,
   I, J, K, L,
   M, N, O, 255
]).

%%%%%%%%% Fim da Declaração das Ações Possíveis %%%%%%%%%