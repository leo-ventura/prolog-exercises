fibo(1,0).
fibo(2,1).
fibo(N, ACC) :-
    N > 2,
    F1 is N-1,
    F2 is N-2,
    fibo(F1, RES1),
    fibo(F2, RES2),
    ACC is RES1 + RES2.
