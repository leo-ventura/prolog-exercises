soma(1, ACC) :- ACC is 1.
soma(N, ACC) :- NEXT is N-1, soma(NEXT, RES), ACC is RES + N.

factorial(1, ACC) :- ACC is 1.
factorial(N, ACC) :- NEXT is N-1, factorial(NEXT, RES), ACC is RES * N.
