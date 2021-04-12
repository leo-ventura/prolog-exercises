% Faça um programa Prologque dadas duas listas L1 e L2,
% retorne a lista L3 que é a união de L1 e L2.
% Note que nesta união não pode haver elementos repetidos.
remove_duplicates([], []).
remove_duplicates([HEAD | TAIL], [HEAD | RES]) :-
    not(member(HEAD, TAIL)),
    remove_duplicates(TAIL, RES).

remove_duplicates([HEAD | TAIL], RES) :-
    member(HEAD, TAIL),
    remove_duplicates(TAIL, RES).

union(L1, L2, RES) :-
    append(L1, L2, L3),
    remove_duplicates(L3, RES).


% Faça um programa Prolog que dadas duas listas L1 e L2,
% retorne a lista L3 que contém todos os elementos de L1 que não estão em L2.
not_in([], _, []).
not_in([HEAD | TAIL], L2, [HEAD | L3]) :-
    not(member(HEAD, L2)),
    not_in(TAIL, L2, L3).

not_in([HEAD | TAIL], L2, L3) :-
    member(HEAD, L2),
    not_in(TAIL, L2, L3).
