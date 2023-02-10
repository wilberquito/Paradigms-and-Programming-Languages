% Hechos
hombre(juan).
hombre(pedro).
hombre(carlos).
mujer(ana).
mujer(maria).
mujer(lucia).

es_hijo_de(juan, pedro).
es_hijo_de(ana, maria).
es_hijo_de(carlos, pedro).
es_hijo_de(maria, lucia).

% Reglas
abuelo(X, Y) :- es_hijo_de(Y, Z), es_hijo_de(Z, X).
padre(X, Y) :- hombre(X), es_hijo_de(Y, X).
madre(X, Y) :- mujer(X), es_hijo_de(Y, X).
hermano(X, Y) :- hombre(X), es_hijo_de(X, Z), es_hijo_de(Y, Z), X \= Y.
hermana(X, Y) :- mujer(X), es_hijo_de(X, Z), es_hijo_de(Y, Z), X \= Y.

