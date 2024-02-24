
%Les arestes no son dirigides, pero s'especifiquen sense repeticions i ordenades lexicograficament
%aresta(X,Y) => hi ha una aresta entre X i Y, i X precedeix lexicograficament Y
%per exemple, es pot demostrar aresta(n1,n2), pero no aresta(n2,n1)
aresta(n1,n2).
aresta(n1,n4).
aresta(n1,n6).
aresta(n2,n3).
aresta(n2,n4).
aresta(n2,n6).
aresta(n3,n4).
aresta(n4,n5).
aresta(n4,n6).
aresta(n5,n6).


%clique3(A,B,C) => El conjunt {A,B,C} es un clique, i la sequencia A,B,C esta ordenada lexicograficament.
%per exemple, es pot demostrar clique3(n1,n2,n4), pero no clique3(n1,n4,n2).
%Per tant, posarem "aresta(A,B)", "aresta(A,C)" i "aresta(B,C)" en lloc de "aresta(B,A)", "aresta(C,A)" o "aresta(C,B)"
clique3(A,B,C) :- aresta(A,B), aresta(A,C), aresta(B,C).


%clique4(A,B,C,D) => El conjunt {A,B,C,D} es un clique, i la sequencia A,B,C,D esta ordenada lexicograficament
clique4(A,B,C,D) :- clique3(A,B,C), aresta(A,D), aresta(B,D), aresta(C,D).

%Alternativa menys eficient. Tot i que aquesta definicio es correcta, l'opcio anterior es millor, perque demostrar aresta es molt mes facil que demostrar clique3.
%clique4(A,B,C,D) :- clique3(A,B,C), clique3(A,B,D), clique3(A,C,D), clique3(B,C,D).
