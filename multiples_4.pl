% Calcula os multiplos de 4 menores que X, os salvando na lista RES
multiplos4(X, RES) :-
    COUNTER is 0,
    multiplos_iter(X, [], COUNTER, RES).

multiplos_iter(X, ACC, COUNTER, RES) :-
    COUNTER =< X,
    NEXT_ACC = [COUNTER | ACC],
    NEXT_COUNTER is COUNTER + 4,
    multiplos_iter(X, NEXT_ACC, NEXT_COUNTER, RES).

multiplos_iter(X, ACC, COUNTER, RES) :-
    COUNTER > X,
    RES = ACC.
