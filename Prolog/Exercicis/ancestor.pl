% Defineix les regles per a la relació d'ancestre
% propasades a l'enunciat. Comenta en cada cas el que fa Prolog.

parent(alice, bob).
parent(bob, eve).

% I
% ancestor(X,Y):-parent(X,Y).
% ancestor(X,Y):-parent(X,Z),ancestor(Z,Y).

% II
% ancestor(X,Y):-parent(X,Y).
% ancestor(X,Y):-ancestor(Z,Y),parent(X,Z).

% III
% ancestor(X,Y):-parent(X,Z),ancestor(Z,Y).
% ancestor(X,Y):-parent(X,Y).

% IV
% ancestor(X,Y):-ancestor(Z,Y),parent(X,Z).
% ancestor(X,Y):-parent(X,Y).