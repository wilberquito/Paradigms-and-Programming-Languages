q(X):- p(X).
q(0).

p(X):- a(X), b(X), !.
p(1).

a(2).
a(3).

b(2).
b(2).
b(3).

% member(A,B), element A occurs in list B
member_(X,[X|_]).
member_(X,[_|L]):- member_(X,L).

% fact(+N,F) => F is the factorial of N
fact(0,1).
fact(N,F):- Np is N-1,
            fact(Np,F1),
            F is F1 * N.

% nums(X) => X is a natural number. Starts with 0.
nums(0).
nums(X):- nums(Xp), X is Xp+1.

% findf(X,+Y) => X factorial is bigger than Y.
findf(X,Y):- nums(X), fact(X,Z), Z>Y.

