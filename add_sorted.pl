% add_sorted(X, L1, L2)
add_sorted(X, [], [X]).
add_sorted(X, [L1_HEAD | L1_TAIL], L2) :-
    X =< L1_HEAD,
    L2 = [X, L1_HEAD | L1_TAIL].

add_sorted(X, [L1_HEAD | L1_TAIL], L2) :-
    X > L1_HEAD,
    add(X, L1_TAIL, ACC),
    L2 = [L1_HEAD | ACC].

