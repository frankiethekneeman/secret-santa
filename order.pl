last(X,[X]).
last(X,[_|Z]) :- last(X,Z).

canGive(A, B) :- giver(A),
	giver(B),
	A \= B,
	\+ cannotGive(A,B).

canGiveH(_, []).
canGiveH(A, [H|_]) :- canGive(A, H).

validGiveOrder([]).
validGiveOrder([H|T]) :- canGiveH(H, T),
    validGiveOrder(T).

validGiveCycle([H|T]) :- last(L, T),
    canGive(L,H).

notIn(_, []).
notIn(E, [H|T]) :- E \= H,
    notIn(E, T).

allUnique([]).
allUnique([H|T]) :- notIn(H, T),
    allUnique(T).

allGivers([]).
allGivers([H|T]) :- giver(H),
    allGivers(T).

countGivers(L) :- aggregate_all(count, giver(_), L).

winner(L) :- countGivers(N),
    length(L, N),
    allGivers(L),
    allUnique(L),
    validGiveOrder(L),
    validGiveCycle(L).

pickOne(X) :- aggregate(set(W), winner(W), L), random_member(X, L).
