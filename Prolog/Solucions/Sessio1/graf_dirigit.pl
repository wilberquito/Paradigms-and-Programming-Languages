%aresta(X,Y) => hi ha una aresta de X cap a Y

aresta(n1,n2).
aresta(n1,n3).
aresta(n2,n5).
aresta(n3,n5).
aresta(n3,n6).
aresta(n4,n3).
aresta(n4,n7).
aresta(n5,n6).

%cami(X,Y) => hi ha un cami de X a Y
cami(X,Y) :- aresta(X,Y).
cami(X,Y) :- aresta(X,Z), cami(Z,Y).

%l'alternativa seguent, logicament correcta, faria que el programa es pengi
% cami(X,Y) :- cami(X,Z), aresta(Z,Y).
