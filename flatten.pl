flatten(LIST, RES)
flatten(HEAD, [HEAD]).
flatten([], []).
flatten([HEAD | TAIL], RES) :-
	flatten(HEAD, RES1),
    flatten(TAIL, RES2),
	append(RES1, RES2, RES).
