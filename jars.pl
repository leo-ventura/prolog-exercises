% Escreva os fatos Prolog que representam quais são os estados finais do problema.
% Use o predicado unário objetivo
% objetivo(J1, J2).
objetivo((2, _)).

% Defina o predicado ternário acao((J1,J2),ACAO,(J1a,J2a)) que transforma o estado das jarras
% (J1,J2) no estado (J1a,J2a) quando uma ação ACAO (ACAO ∈ {encher1, encher2, esvaziar1,
% esvaziar2, passar12, passar21}) for executada.
% Por exemplo,
%	acao((J1,J2),encher1,(4,J2)):- J1<4.
acao((J1,J2),encher1,(4,J2)):- J1<4.
acao((J1,J2),encher2,(J1,3)):- J2<3.

acao((J1,J2),esvaziar1,(0,J2)):- J1>0.
acao((J1,J2),esvaziar2,(J1,0)):- J2>0.

acao((J1,J2),passar12,(J1a,J2a)) :-
    J1 > 0,
    J2Partial is J1 + J2,
    J2Partial > 3,
    J1a is J2Partial - 3,
    J2a = 3,
    (J1,J2) \= (J1a, J2a).

acao((J1,J2),passar12,(J1a,J2a)) :-
    J1 > 0,
    J2Partial is J1 + J2,
    J2Partial =< 3,
	J1a = 0,
    J2a = J2Partial,
    (J1,J2) \= (J1a, J2a).

acao((J1,J2),passar21,(J1a,J2a)) :-
    J2 > 0,
    J1Partial is J1 + J2,
    J1Partial > 4,
    J2a is J1Partial - 4,
    J1a = 4,
    (J1,J2) \= (J1a, J2a).

acao((J1,J2),passar21,(J1a,J2a)) :-
    J2 > 0,
    J1Partial is J1 + J2,
    J1Partial =< 3,
	J2a = 0,
    J1a = J1Partial,
    (J1,J2) \= (J1a, J2a).

% O predicado ternário findall permite obter todas as instâncias que satisfazem uma dada consulta.
% Por exemplo, se tivermos o programa Prolog:
% p(a).
% p(b).
% q(X):-p(X).
% e fizermos a consulta ?- findall(Y,q(Y),L)., ou seja, queremos obter a lista L formada por todos os
% elementos Y que satisfazem q(Y), obteremos como resposta L = [a,b].
% Usando o predicado findall, defina o predicado binário vizinho(N,FilhosN) que dado uma con-
% figuração das jarras N retorna todas as configurações possíveis que podemos obter aplicando cada
% uma das ações definidas para o problema ao estado representado por N.
vizinho(N, FilhosN) :-
    findall(X, acao(N, _, X), FilhosN).

% Usando os predicados objetivo e vizinhos, implemente em Prolog o algoritmo de busca em largura
% apresentado em aula. Faça uma consulta que represente a busca de uma solução a partir do estado
% inicial (0,0). O que ocorre? Por que?
busca_largura_resultado(Estado, Output) :-
    busca_largura_resultado_iter([Estado], Output).

busca_largura_resultado_iter([Estado | _], Estado) :- objetivo(Estado), !.
busca_largura_resultado_iter([Estado | OutrosEstados], Output) :-
    vizinho(Estado, Filhos),
    append(OutrosEstados, Filhos, EstadosAExplorar),
    busca_largura_resultado_iter(EstadosAExplorar, Output).

% Modifique o programa do item anterior para que seja guardada a sequência de configurações dos
% estados das jarras.
vizinho_historico((N, Path), FilhosN) :-
    findall((X, [N | Path]), acao(N, _, X), FilhosN).

busca_largura_historico(EstadoInicial, Output) :-
    busca_largura_historico_iter([(EstadoInicial, [])], ResultadoBusca),
    reverse(ResultadoBusca, Output).

busca_largura_historico_iter([(Estado, Path) | _], [Estado | Path]) :- objetivo(Estado).
busca_largura_historico_iter([Node | RemainingNodes], Output) :-
    vizinho_historico(Node, Filhos),
    append(RemainingNodes, Filhos, EstadosAExplorar),
    busca_largura_historico_iter(EstadosAExplorar, Output).

% Até agora não nos preocupamos em evitar os estados repetidos. Para isso, ao acrescentar os el-
% ementos novos na fronteira, devemos desconsiderar os nós que já foram gerados anteriormente.
% Podemos fazer isso comparando a lista formada pelos filhos de um dado nó com os nós já gerados,
% e acrescentar na fronteira apenas aqueles que estão na primeira lista e não na segunda.
% Por exemplo, os nós em vermelho na figura devem ser desconsiderados.
vizinho_sem_repeticao((N, Path), FilhosN) :-
    findall((X, [N | Path]), acao(N, _, X), FilhosN).

busca_largura_sem_repeticao(EstadoInicial, Output) :-
    busca_largura_sem_repeticao_iter([(EstadoInicial, [])], [], ResultadoBusca),
    reverse(ResultadoBusca, Output).

busca_largura_sem_repeticao_iter([(Estado, Path) | _], _, [Estado | Path]) :- objetivo(Estado).
busca_largura_sem_repeticao_iter([Node | RemainingNodes], NosVisitados, Output) :-
    (Estado, _) = Node,
    not(member(Estado, NosVisitados)),
    vizinho_sem_repeticao(Node, Filhos),
    append(RemainingNodes, Filhos, EstadosAExplorar),
    busca_largura_sem_repeticao_iter(EstadosAExplorar, [Estado | NosVisitados], Output).

busca_largura_sem_repeticao_iter([Node | RemainingNodes], NosVisitados, Output) :-
    (Estado, _) = Node,
    member(Estado, NosVisitados),
    busca_largura_sem_repeticao_iter(RemainingNodes, NosVisitados, Output).