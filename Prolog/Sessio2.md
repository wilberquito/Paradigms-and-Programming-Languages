# Sessió 2

A la sessió 1 hem vist només un fragment del Prolog limitat a lògica de primer ordre amb clàusules de Horn. 
En aquesta sessió veurem característiques de Prolog que no corresponen a aquest fragment i que fan de Prolog 
un llenguatge més potent. 

## Negació

L'operador *not* `\+` de Prolog és un meta-predicat incorporat. Un meta-predicat és un predicat que té com a arguments altres predicats, 
en lloc de dades.
L'operador *not* rep un únic predicat com a argument, i en nega el valor. 

Alerta: **no és una negació lògica**. Si permetéssim l'ús de negacions lògiques `¬` al cos de les regles, aquestes deixarien de ser clàusules de Horn. Per exemple,
```prolog
p(X) :- a(X), ¬b(X)
``` 
Equivaldria a la clàusula:

${\displaystyle p(X) \vee ¬a(X) \vee b(X)}$

En canvi, l'operador ` \+` és conegut com a l'operador de `negation-as-failure` (negació per fracàs), perquè 
demostra la negació d'un objectiu quan fracassa en demostrar aquest objectiu.

Fixeu-vos en la fórmula següent: ${\displaystyle (q(a) \wedge p(X) \vee ¬q(X)) }$

En Prolog:
```prolog
q(a).
p(X):-q(X).
```

Clarament *p(b)* no és conseqüència lògica de la fòrmula. 
Per tant, si afegeixo la clàusula *¬p(b)* i faig servir resolució, 
no obtindré la clàusula buida (no puc demostrar *p(b)* ). 
En termes de Prolog, la consulta `? p(b).` dirà *no*.

Semblantment, tampoc puc demostrar que *¬p(b)* sigui conseqüència lògica de la fórmula,
ja que afegint *p(b)* i fent resolució tampoc obtindré la clàusula buida.
Ara bé, si fem la consulta `? \+ p(b)`, Prolog ens dirà *yes*. 
Això passa perquè primer, internament, ha fet la consulta `p(b)` i s'ha obtingut *no*,
(ha *fracassat* a demostrar *p(b)* ). Ho podeu comprovar com a exercici.

Així doncs, Prolog en realitat fa **SLDNF-resolució** (SLD-resolució amb *negation-as-failure*). 

Comproveu els resultats de les consultes `non_domestic_animal(X).` i `non_domestic_animal(hamster).`.


```prolog
domestic_animal(cat).
domestic_animal(dog).

non_domestic_animal(X) :- \+ domestic_animal(X).
```



## Aritmètica

Recordeu que en Prolog tot és un terme. Per tant, els nombres `33, -2, 2.3` són termes,
com també ho són expressions aritmètiques com `3+3, 33*3+1...`. L'operador `=` no avalua, sinó que **unifica**.

```prolog
?- 4 = 2+2.
no
```

```prolog
?- X = 2+2.
X = 2+2
```

Per **avaluar** expressions cal fer servir el predicat `is`. L'àtom lògic `E1 is E2` significa que`E1` **unifica amb el valor aritmètic de** `E2`.
Per tant, hi ha un detall tècnic molt rellevant: `E2` **ha de ser una expressió aritmètica avaluable amb la unificació actual**.

```prolog
?- 4 is 2+2.
yes
```

```prolog
?- X is 3 * 4.
X = 12
```
```prolog
?- Y=4, X is 3 * Y.
X = 12
```

Fixeu-vos que la part avaluable de `is` ha de ser la de la dreta.

```prolog
?- 2+2 is 4.
no
```

```prolog
?- 4 is X.
Inst. error
```

```prolog
?- 4 is 2+X.
Inst. error
```

Hi ha predicats relacionals que avaluen tots dos costats (si són avaluables): `<`, `=<`, `>`, `>=`, `=:=` and `=\=`.
Bàsicament, és com si utilitzéssim `is` en totes dues direccions.

```prolog
?- 2+2 =:= 9/2.
no
```

```prolog
?- 2+2 =:= 9//2.
yes
```

```prolog
?- 4 mod 2 >= 2+X.
Inst. error
```

```prolog
?- 2+2 =\= 3+1.
no
```


### Predicat factorial

```prolog
% fact(+N,F) => F es el factorial de N.
fact(0,1).
fact(N,F) :- N>0,
             Np is N-1,
             fact(Np,F1),
             F is F1 * N.
```

Aquesta definició pot calcular recursivament el factorial d'un enter positiu `N`
multiplicant N pel factorial de `N-1`, fins que arribem al cas base `fact(0,1)`.

```prolog
?- fact(3,6).
yes
```

```prolog
?- fact(3,F).
F=6
```

El predicat `fact` no és bidireccional, en el sentit que no podem fer la consulta següent:

```prolog
?- fact(N,6).
Inst. error
```

Això passa perquè `N` ha de tenir un valor definit quan s'avalua amb `is`.
Indicarem a la documentació que un argument `N` ha de tenir un valor definit (**ha d'estar instanciat**) amb `+N`, per exemple `%fact(+N,F)`.



## LListes

Prolog té incorporporada una estructura de dades llista, que representa una seqüència de termes, 
no necessàriament del mateix tipus. La sintàxi per representar-la explícitament és una seqüència d'elements separats per coma `,` 
delimitada per claudàtors `[ ]`.

Possibles exemples de llistes:
- Llista d'enters `[1, 2, 3, 4]` 
- Llista d'objectes `[a, b]` 
- Llista de termes diversos `[a, 3, f(a,3), [1, b, [ ], "12"],'a']`

En Prolog les llistes són estructures de dades recursives, és a dir, es poden definir a partir d'altres llistes.
Una llista és:
- Una llista buida `[]`, o
- Una llista no buida `[ Cap | Cua ]`, on Cap és el primer terme de la llista, i Cua és la llista 
dels termes que succeeixen el Cap. Fixeu-vos que Cua pot ser una llista buida. 

Tenim múltiples maneres de representar una mateixa llista, combinant representacions explícites i recursives. Per exemple:
- `[X,Y,Z]`
- `[X | [Y, Z]]`
- `[X | [Y | [Z] ] ]`
- `[X | [ Y | [Z | [] ] ] ]`
- `[X,Y,Z | [] ]`
- `[X,Y | [Z] ]`

Exemples d'unificacions amb llistes:

```prolog
?- [1,2,3] = [X,Y|L].
L=[3], X=1, Y=2
```

```prolog
?- [1,2,3] = [X,Y,Z|L].
L=[], X=1, Y=2, Z=3
```

```prolog
?- [1,2|3,4] = [X,Y|L].
Syntax error
```

```prolog
% Exemple anterior expressat correctament. La cua d'una llista ha de ser una llista.
?- [1,2|[3,4]] = [X,Y|L].
L=[3,4], X=1, Y=2
```

```prolog
?- [1,2,3] = [X,Y,Z,T].
no
```

```prolog
?- [1,2|L] = [X,Y,X].
L=[1], X=1, Y=2
```

### Predicats sobre llistes

Prolog té un conjunt de predicats sobre llistes integrats. A continuació es mostra la seva definició
per entendre el seu comportament i el comportament de l'arbre de resolució, però no cal implementar-los.

#### Member

```prolog
% member(X,L) => X apareix a la llista L.
member(X,[X|_]).
member(X,[_|XS]) :- member(X,XS).
```

El fet `member(X,[X|_])` estableix que `X` és membre d'una llista si és el primer element de la llista.

La segona clàusula `member(X,[_|XS]) :- member(X,XS)` estableix que `X` és membre d'una llista si és membre
de la cua de la llista. Fixeu-vos en l'ús del `_` per ometre els valors no rellevants.

Fixeu-vos que la consulta `member(X,[])` no es pot satisfer, perquè cap de les dues clàusules contempla que la llista rebuda
al segon paràmetre sigui buida.

Què creieu que dirà Prolog a les consultes següents?

```prolog
?- member(X,[1,2,3]).
```

```prolog
% aquesta es mes complicada
?- member(1,X).
```

#### Append

```prolog
append([],Ys,Ys).
append([X|Xs],Ys,[X|Zs]) :- append(Xs,Ys,Zs).
```
El predicat demana que el tercer argument sigui el resultat de concatenar els dos primers arguments, que han de ser llistes.
Es pot fer servir de diverses maneres, per exemple per calcular una concatenació, o per trobar tots els parells de subllistes
en què es pot dividir una llista. 

Exemples d'ús d'aquest predicat:

```prolog
?- append([1,2],[3,4], L).
L = [1,2,3,4]
```

```prolog
?- append([1,2],L,[1,2,9,8]).
L = [9,8]
```

```prolog
?- append(Xs,Ys,[1,2,3]).
Xs=[], Ys=[1,2,3] ;
Xs=[1], Ys=[2,3] ;
Xs=[1,2], Ys=[3] ;
Xs=[1,2,3], Ys=[] 
yes
```

El predicat `append` és molt útil, i ens serveix per definir altres predicats.

```prolog
% member(X,L) => L conte X
member(X,L) :- append(_,[X|_],L).
```

```prolog
% permutation(L1,L2) => L2 es una permutacio de L1
permutation([],[]).
permutation(L,[X|Xs]) :- append(V,[X|P],L),
                         append(V,P,W),
                         permutation(W,Xs).
```

```prolog
% reverse(L,In) => In es L capgirada
reverse([],[]).
reverse([X|Xs],In) :- reverse(Xs,Ps), append(Ps,[X],In).
```

```prolog
% prefix(P,L) => P es un prefix de L.
prefix(P,L) :- append(P,_,L).
```

```prolog
% suffix(S,L) => S es un sufix de L.
suffix(S,L) :- append(_,S,L).
```
#### Implementem altres predicats: remove

Considereu el següent predicat remove, que estableix la relació *L2 és la llista L1 sense cap ocurrència de X*.


```prolog
% remove(X,L1,L2) => L2 es L1 sense cap ocurrencia de X.
remove(_,[],[]).
remove(X,[X|L1],L2) :- remove(X,L1,L2).
remove(X,[Y|L1],[Y|L2]) :- remove(X,L1,L2).
```

Hi veieu algun problema? Proveu de demanar més d'una solució per la consulta:

```prolog
?- remove(1,[1,2,1],L).
```

<details>

<summary>Com l'arreglem?</summary>

```prolog
% remove(X,L1,L2) => L2 es L1 sense cap ocurrencia de X.
remove(_,[],[]).
remove(X,[X|L1],L2) :- remove(X,L1,L2).
remove(X,[Y|L1],[Y|L2]) :- X\=Y, remove(X,L1,L2).
```

Recordeu: **dues variables amb nom diferent també es poden unificar**.

</details>



### Combinació de llistes i aritmètica

```prolog
% length(L,N) => N es la llargada de L.
length([],0).
length([_|Xs],N) :- length(Xs,Np), N is Np+1.
```

```prolog
% count(L,X,N) => N es el nombre de vegades que X apareix a L.
count([],_,0).
count([X|Xs],X,N) :- count(Xs,X,Np), N is Np+1.
count([Y|Xs],X,N) :- X\=Y, count(Xs,X,N).
```

```prolog
% nessim(L,N,X) => X apareix a la posicio N de L.
nessim([X|_],0,X).
nessim([_|Xs],N,X) :- N>0,
                      Np is N-1,
                      nessim(Xs,Np,X).
```

```prolog
% split(X,L,LEQ,GT) => LEQ son els elements de L menors o iguals que X, GT son els mes grans que X
split(_,[],[],[]).
split(X,[Y|L],[Y|LEQs],GT) :- Y=<X, split(X,L,LEQs,GT).
split(X,[Y|L],LEQ,[Y|GTs]) :- Y>X, split(X,L,LEQ,GTs).
```

```prolog
% quicksort(L1,L2) => L2 es la llista L1 ordenada.
quicksort([],[]).
quicksort([X|Xs],L) :- split(X,Xs,LEQ,GT),
                       quicksort(LEQ,LEQsort),
                       quicksort(GT,GTsort),
                       append(LEQsort,[X|GTsort],L).
```


## Més sobre unificació

Recordeu que dos termes són unificables si existeix alguna substitució que els faci sintàcticament iguals.
En Prolog, els operadors de unificar (i no unificar) són `=` i `\=`. 
Els operadors `=`, `==` (i les seves negacions `\=`, `\==`) són difrents.
L'expressió `E1 = E2` significa `E1` és unificable amb `E2`, mentre que l'expressió `E1 == E2`
significa que E1 i E2 **ja han estat unificats** a un mateix terme.

```prolog
?- X=Y.
Y=X
yes
```

```prolog
?- 2+X=2+Y.
Y=X
yes
```

```prolog
?- 2+X=2+X.
yes
```

```prolog
?- X==Y.
no
```

```prolog
?- X=A,X==Y.
no
```

```prolog
?- X=A,Y=A,X==Y.
X=A
Y=A
yes
```

```prolog
?- 2+X==2+X.
yes
```


## Metapredicat findall

El metapredicat `findall` ens permet capturar totes les unificacions que demostren una consulta, incloure-les en una llista amb el format desitjat.
El primer paràmetre indica el format, el segon la consulta, i el tercer la llista resultant.

```prolog
%Amb el fitxer lovers.pl
?- findall([X,Y], loves(X,Y), L).
L = [[john,ann],[ann,michael],[luis,isabel],[michael,ann],[laura,john],[isabel,luis]]
yes

?- findall(l(X,Y), loves(X,Y), L).
L = [l(john,ann),l(ann,michael),l(luis,isabel),l(michael,ann),l(laura,john),l(isabel,luis)]
yes

?- findall(loves_someone(X), loves(X,_), L).
L = [loves_someone(john),loves_someone(ann),loves_someone(luis),loves_someone(michael),loves_someone(laura),loves_someone(isabel)]
yes
```

##  És el vostre torn 

Implementeu els predicats següents.

#### sublist

```prolog
% sublist_(Lp,L) => Lp es subllista de L
sublist_(Lp, L) :- ...
```


#### palindrome

```prolog
% palindrome_(L) => L es un palindrom (es capicua) 
palindrome_(L) :- ...
```

#### insert

```prolog
% insert_(X, Xs, Ys) => Ys es el resultat d'inserir ordenadament X a Xs, assumint que Xs esta en ordre ascendent
insert_(X, Xs, Ys) :- ...
```

#### sort_insert
Feu servir *insert* per implementar-lo

```prolog
% sort_insert_(L, Ls) => Ls es la llista L ordenada. Feu servir insert_
sort_insert_(L, Ls) :- ...
```

### Predicats sobre [multiconjunts](https://en.wikipedia.org/wiki/Multiset). 

Assumirem que Xs, Ys i Zs són multiconjunts.

#### union

```prolog
% union_(Xs, Ys, Zs) => Zs = Xs unio Ys
union_(Xs, Ys, Zs) :- ...
```

#### intersection

```prolog
% intersection_(Xs, Ys, Zs) => Zs = Xs interseccio Ys
intersection_(Xs, Ys, Zs) :- ...
```

#### difference
Podeu fer servir el predicat [substract](https://www.swi-prolog.org/pldoc/doc_for?object=subtract/3).

```prolog
% difference_(Xs, Ys, Zs) => Zs = Xs \ Ys
difference_(Xs, Ys, Zs) :- ...
```

#### multiset_to_set
Podeu fer servir el predicat [sort](https://www.swi-prolog.org/pldoc/man?predicate=sort/2).

```prolog
% multiset_to_set_(Xs, Zs) => Zs is Xs sense repeticions
multiset_to_set_(Xs, Zs) :- ...
```


#### sum

```prolog
% sum_(L,N) => N es la suma dels elements de L
sum_(L, N) :- ...
```

#### sum_even

```prolog
% sum_even_(L,N) => N es la suma dels nombres parells de L
sum_even_(L,N) :- ...
```

### Altres predicats

#### gcd

Podeu fer servir [l'Algorisme d'Euclides](https://ca.wikipedia.org/wiki/Algorisme_d%27Euclides).

```prolog
% gcd_(A, B, M) => M es el maxim comu divisor de A i B
gcd_(A, B, M) :- ...
```

#### paths

```prolog
% paths(E,X,Y,P) 
% E son les arestes d'un graf dirigit aciclic.
% La llista P conte un cami de X a Y.
paths(E,X,Y,P) :- ...

%Exemple d'execucio, graf sessio 1
%paths([ar(1,2),ar(1,3),ar(2,5),ar(3,5),ar(3,6),ar(4,3),ar(4,7),ar(5,6)],3,6,P).
%P = [3,6] ? ;
%P = [3,5,6] ? ;
%no
```

#### cliques
```prolog
% clique(g(V,E),C) 
% V,E son els nodes i arestes d'un graf. 
% Les arestes son parelles ordenades de nodes ar(N1,N2) tal que N1 < N2
% La llista C conte un clique ordenat del graf g(V,E).
clique(g(V,E),C) :- ...

%Exemples d'execucio

%clique(g([1,2,3],[ar(1,2),ar(1,3),ar(2,3)]),C).
%C = [1] ? ;
%C = [2] ? ;
%C = [3] ? ;
%C = [1,2] ? ;
%C = [1,3] ? ;
%C = [2,3] ? ;
%C = [1,2,3] ? ;
no

%Graf de la sessio 1
%findall(C,clique(g([1,2,3,4,5,6],[ar(1,2),ar(1,4),ar(1,6),ar(2,3),ar(2,4),ar(2,6),ar(3,4),ar(4,5),ar(4,6),ar(5,6)]),C),L).
% L = [[1],[2],[3],[4],[5],[6],[1,2],[1,4],[1,6],[2,3],[2,4],[2,6],[3,4],[4,5],[4,6],[5,6],[1,2,4],[1,2,6],[1,4,6],[2,3,4],[2,4,6],[4,5,6],[1,2,4,6]]
yes
```
