% sublist_(Lp,L) => Lp es subllista de L
% Posar el cas llista buida explicitament al primer cas, i prohibir-lo al segon cas, evita repeticions.
sublist_([],_).
sublist_([X|Xs], L) :- prefix(L2,L),suffix([X|Xs],L2).

% palindrome_(L) => L es un palindrom (es capicua)
palindrome_([]).
palindrome_([_]).
palindrome_([X|Xs]) :- append(Y,[X],Xs), palindrome_(Y).
%alternativa:
%palindrome_(L):- reverse(L,L2), L=L2.

% insert_(+X, +Xs, Ys) => Ys es el resultat dinserir ordenadament X a Xs, assumint que Xs esta en ordre ascendent
insert_(X, [], [X]).
insert_(X, [Y|Ys], [X,Y|Ys]) :- X=<Y.
insert_(X, [Y|Ys], [Y|L]) :- X>Y, insert_(X,Ys,L).

% sort_insert_(+L, Ls) => Ls es la llista L ordenada. Feu servir insert_
sort_insert_([],[]).
sort_insert_([X|Xs], L) :- sort_insert_(Xs,L2),insert_(X,L2,L).

% union_(+Xs, +Ys, Zs) => Zs = Xs unio Ys
union_(Xs,Ys,Zs) :- sort_insert_(Xs,XSort),sort_insert_(Ys,YSort),union_i_(XSort,YSort,Zs).

% union_i_(+Xs, +Ys, Zs) =>  Si Xs i Ys estan ordenades creixentment, Zs = Xs unio Ys
union_i_([],[],[]).
union_i_([X|Xs],[],[X|Xs]).
union_i_([],[Y|Ys],[Y|Ys]).
union_i_([X|Xs],[X|Ys],[X|Zs]) :- union_i_(Xs,Ys,Zs).
union_i_([X|Xs],[Y|Ys],[X|Zs]) :- X<Y, union_i_(Xs,[Y|Ys],Zs).
union_i_([X|Xs],[Y|Ys],[Y|Zs]) :- X>Y, union_i_([X|Xs],Ys,Zs).

% intersection_(+Xs, +Ys, Zs) => Zs = Xs unio Ys
intersection_(Xs,Ys,Zs) :- sort_insert_(Xs,XSort),sort_insert_(Ys,YSort),intersection_i_(XSort,YSort,Zs).

% intersection_i_(+Xs, +Ys, Zs) => Si Xs i Ys estan ordenades creixentment, Zs = Xs unio Ys
intersection_i_([],[],[]).
intersection_i_([_|_],[],[]).
intersection_i_([],[_|_],[]).
intersection_i_([X|Xs],[X|Ys],[X|Zs]) :- intersection_i_(Xs,Ys,Zs).
intersection_i_([X|Xs],[Y|Ys],Zs) :- X<Y, intersection_i_(Xs,[Y|Ys],Zs).
intersection_i_([X|Xs],[Y|Ys],Zs) :- X>Y, intersection_i_([X|Xs],Ys,Zs).

% difference_(+Xs, +Ys, Zs) => Zs = Xs \ Ys
difference_(Xs, Ys, Zs) :- sort_insert_(Xs,XSort),sort_insert_(Ys,YSort),difference_i_(XSort,YSort,Zs).

% difference_i_(+Xs, +Ys, Zs) => Si Xs i Ys estan ordenades creixentment, Zs = Xs \ Ys
difference_i_([X|Xs],[],[X|Xs]).
difference_i_([],_,[]).
difference_i_([X|Xs],[X|Ys],Zs) :- difference_i_(Xs,Ys,Zs).
difference_i_([X|Xs],[Y|Ys],[X|Zs]) :- X<Y, difference_i_(Xs,[Y|Ys],Zs).
difference_i_([X|Xs],[Y|Ys],Zs) :- X>Y, difference_i_([X|Xs],Ys,Zs).

% multiset_to_set_(+Xs, Zs) => Zs is Xs sense repeticions
multiset_to_set_(Xs,Zs) :- sort_insert_(Xs,XSort), multiset_to_set_i_(XSort,Zs).

% multiset_to_set_i_(+Xs, Zs) => Si Xs esta ordenada creixentment, Zs is Xs sense repeticions
multiset_to_set_i_([], []).
multiset_to_set_i_([X], [X]).
multiset_to_set_i_([X,X|Xs], Zs) :- multiset_to_set_i_([X|Xs],Zs).
multiset_to_set_i_([X,Y|Xs], [X|Zs]) :- X\=Y, multiset_to_set_i_([Y|Xs],Zs).

% sum_(+L,N) => N es la suma dels elements de L
sum_([],0).
sum_([X|Xs], N) :- sum_(Xs,N2), N is N2+X.

% sum_even_(+L,N) => N es la suma dels nombres parells de L
sum_even_([],0).
sum_even_([X|Xs],N) :- X mod 2 =:= 0, sum_even_(Xs,N2), N is N2+X.
sum_even_([X|Xs],N) :- X mod 2 =:= 1, sum_even_(Xs,N).

% gcd_(+A, +B, M) => M es el maxim comu divisor de A i B
gcd_(A, B, B) :- A mod B =:= 0.
gcd_(A, B, M) :- R is A mod B, R\=0, gcd_(B,R,M).


%============================ Paths ===========================
%paths(E,X,Y,P): P es un cami de X a Y, d'acord amb la llista d'arestes dirigides E,
% on una aresta V1->V2 es representa amb ar(V1,V2)
paths(E,X,Y,[X,Y]) :- member(ar(X,Y),E).
paths(E,X,Y,[X|Xs]) :- member(ar(X,Z),E), paths(E,Z,Y,Xs).

%============================ Clique ==========================

%between(+X,+Y,Z): X <= Z <= Y. Ja hi es built in
%between(X,Y,X):- X=<Y.
%between(X,Y,Z):- X<Y, X2 is X+1, between(X2,Y,Z).

%allConnected(V,C,E): V es un node, C una llista de nodes, i E una llista d'arestes. 
% Es demostrable si V esta connnectat amb arestes d'E a tots els nodes de C.
allConnected(_,[],_).
allConnected(V,[V2|Cs],E):-
	member(ar(V,V2),E),
	allConnected(V,Cs,E).

%cliqueN(N,g(V,E),C): C es un clique de mida N del graf g(V,E)
%assumim que el graf no conte una aresta d'un node cap a ell mateix (self loop), 
% es a dir, ar(X,X) no pertany a E per cap valor d'X
cliqueN(1,g(V,_),[X]):-member(X,V).
cliqueN(2,g(_,E),[X,Y]):-member(ar(X,Y),E).
cliqueN(N,g(V,E),[Vx|C]):-
	N>2,
	N2 is N-1, 
	cliqueN(N2,g(V,E),C),
	member(Vx,V),
	allConnected(Vx,C,E).

%clique(g(V,E),C): C es un clique del graf g(V,E)
clique(g(V,E),C) :- 
	length(V,NV), 
	between(1,NV,N),
	cliqueN(N,g(V,E),C).
