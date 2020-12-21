parent(pam,bob).
% parent(pam,liz).
% descomentando a linha acima, irmaos(bob, liz) será verdadeiro
parent(tom,bob).
parent(tom,liz).
parent(bob,ann).
parent(bob,pat).
parent(pat,jim).
female(pam).
female(liz).
female(ann).
female(pat).
male(tom).
male(bob).
male(jim).
father(X,Y) :- male(X), parent(X,Y).
mother(X,Y) :- female(X), parent(X,Y).
same_father(X,Y) :- father(PAI, X), father(PAI, Y).
same_mother(X,Y) :- mother(MAE, X), mother(MAE, Y).

irmaos(X,Y) :- same_father(X,Y), same_mother(X,Y), X \== Y.

/*
    pam      tom
      \     /   \
        bob     liz
       /   \
    ann    pat
             \
             jim
*/
% ?- irmaos(bob,liz)

