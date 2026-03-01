# Sessió 2

A la sessió 1 hem vist només un fragment del Prolog limitat a lògica de primer ordre amb clàusules de Horn. 
En aquesta sessió veurem característiques de Prolog que no corresponen a aquest fragment i que fan de Prolog 
un llenguatge més potent. 


## Més sobre unificació

Recordeu que dos termes són unificables si existeix alguna substitució que els faci sintàcticament iguals.
En Prolog, els operadors de unificar (i no unificar) són `=` i `\=`. 
Els operadors `=`, `==` (i les seves negacions `\=`, `\==`) són diferents.
L'expressió `E1 = E2` significa `E1` és unificable amb `E2`, mentre que l'expressió `E1 == E2`
significa que E1 i E2 **ja han estat unificats** a un mateix terme.

```prolog
?- X=X.
X=X
yes
```

```prolog
?- X=Y.
Y=X
yes
```

```prolog
?- X==X.
yes
```

```prolog
?- X==Y.
no
```

```prolog
?- tupla(X,Y)==tupla(X,Y).
yes
```

```prolog
?- X=john,X=Y.
X=john
Y=john
yes
```

```prolog
?- X=john,X==Y.
no
```

```prolog
?- X=john,Y=john,X==Y.
X=john
Y=john
yes
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
Y = 4
```

Fixeu-vos que la part avaluable de `is` ha de ser la de la dreta.

```prolog
% 4 s'avalua com a expressió aritmètica, donant com a resultat un 4, però, 4 no unifica amb 2+2.
?- 2+2 is 4.
no
```

```prolog
% X no és una expressió aritmètica evaluable.
?- 4 is X.
Inst. error
```

```prolog
% X+2 no és una expressió aritmètica evaluable.
?- 4 is 2+X.
Inst. error
```

```prolog
?- X=2, 4 is 2+X.
X = 2
yes
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
% fact(+N,?F) => F es el factorial de N.
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

<details>
<summary>Per què?</summary>

Això passa perquè `N` ha de tenir un valor definit quan s'avalua amb `is`. 
</details>

## Precondicions sobre la instanciació

L'exemple del factorial ens ensenya que hi ha predicats que tenen precondicions d'intanciació sobre els paràmetres a l'hora de ser consultats. Això ho indicarem **a la documentació** del predicat, en forma de comentari. Tot i que hi ha altres casos, els més habituals són:
- `+P`: el paràmetre `P` ha d'estar instanciat.
- `-P`: el paràmetre `P` no pot estar instanciat.
- `?P`: no hi ha cap precondició d'instanciació sobre el paràmetre `P`.
- `0P`: el paràmetre pot ser utilitzat com a consulta.

Per exemple `%fact(+N,?F)` indica que, en el moment de consultar `fact(N,F)`, `N` ha d'estar instanciat , i `F` no cal (però pot estar-ho). 



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
- Una llista no buida `[ Cap | Cua ]`, on `Cap` és el primer terme de la llista, i `Cua` és la llista 
dels termes que succeeixen el `Cap`.

Tenim múltiples maneres de representar una mateixa llista, combinant representacions explícites i recursives. Per exemple:
- `[X,Y,Z]`
- `[X | [Y, Z]]`
- `[X | [Y | [Z] ] ]`
- `[X | [ Y | [Z | [] ] ] ]`
- `[X,Y,Z | [] ]`
- `[X,Y | [Z] ]`

Exemples d'unificacions amb llistes:

```prolog
?- [1,2,3] = [X|L].
L=[2,3], X=1
```

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
% Una llista de 3 termes no pot unificar amb una llista de 4 termes.
?- [1,2,3] = [X,Y,Z,T].
no
```

```prolog
?- [1,2|L] = [X,Y,X].
L=[1], X=1, Y=2
```

## Primers predicats sobre llistes
Implementem els predicats `llista1`, `sumatori`, `producte` i `llargada` del fitxer [llistes.pl](Exercicis/llistes.pl).


#### Implementem altres predicats

Considereu el següent predicat remove, que estableix la relació *L2 és la llista L1 sense cap ocurrència de X*.


```prolog
% remove(+X,+L1,?L2) => L2 es L1 sense cap ocurrencia de X.
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
% remove(+X,+L1,?L2) => L2 es L1 sense cap ocurrencia de X.
remove(_,[],[]).
remove(X,[X|L1],L2) :- remove(X,L1,L2).
remove(X,[Y|L1],[Y|L2]) :- X\=Y, remove(X,L1,L2).
```

Recordeu: **dues variables amb nom diferent també es poden unificar**.

</details>


```prolog
% nessim(?L,+N,?X) => X apareix a la posicio N de L.
nessim([X|_],0,X).
nessim([_|Xs],N,X) :- N>0,
                      Np is N-1,
                      nessim(Xs,Np,X).
```

```prolog
% split(+X,+L,?LEQ,?GT) => LEQ son els elements de L menors o iguals que X, GT son els mes grans que X
split(_,[],[],[]).
split(X,[Y|L],[Y|LEQs],GT) :- Y=<X, split(X,L,LEQs,GT).
split(X,[Y|L],LEQ,[Y|GTs]) :- Y>X, split(X,L,LEQ,GTs).
```

#### El vostre torn
Implementeu la resta de predicats del fitxer [llistes.pl](Exercicis/llistes.pl).

<details>
<summary>Pista per capgira</summary>
Feu servir el predicat afegirFinal.
</details>


<details>
<summary>Pista per ordenar</summary>
Feu servir el predicat inserir.
</details>

## Predicats més habituals sobre llistes

Prolog té un conjunt de predicats sobre llistes integrats. A continuació es mostra la seva definició
per entendre el seu comportament i el comportament de l'arbre de resolució, però no cal implementar-los.

### Member

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
% N'hi ha un nombre finit de sol·lucions?
?- member(1,L).
```

### Append

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
% quicksort(L1,L2) => L2 es la llista L1 ordenada.
quicksort([],[]).
quicksort([X|Xs],L) :- split(X,Xs,LEQ,GT),
                       quicksort(LEQ,LEQsort),
                       quicksort(GT,GTsort),
                       append(LEQsort,[X|GTsort],L).
```

```prolog
% prefix(P,L) => P es un prefix de L.
prefix(P,L) :- append(P,_,L).
```

```prolog
% suffix(S,L) => S es un sufix de L.
suffix(S,L) :- append(_,S,L).
```


<details>
<summary>Pensem'ho</summary>
Entre tots...
</details>

```prolog
% sublist_(Lp,L) => Lp es subllista de L
sublist_(Lp, L) :- ...
```

```prolog
% palindrome_(L) => L es un palindrom (es capicua) 
palindrome_(L) :- ...
```

##  És el vostre torn 

Implementeu els predicats següents.


### Predicats sobre [multiconjunts](https://en.wikipedia.org/wiki/Multiset). 

Assumirem que Xs, Ys i Zs són multiconjunts d'enters.
Assumirem tambe que Zs està ordenada.
Podeu fer servir el predicat [msort](https://www.swi-prolog.org/pldoc/doc_for?object=msort/2).


#### unio

```prolog
% unio(+Xs, +Ys, ?Zs) => Zs = Xs unio Ys
unio(Xs, Ys, Zs) :- ...
```

<details>
<summary>Exemples de sortida:</summary>
  
```prolog
| ?- unio([],[],[]).
yes
  
| ?- unio([a,b],[c,a],Xs).
Xs = [a,a,b,c]
yes

| ?- unio([],[c,a],Xs).
Xs = [a,c]
yes
```
</details>


#### intersecció

```prolog
% interseccio(+Xs, +Ys, ?Zs) => Zs = Xs interseccio Ys
interseccio(Xs, Ys, Zs) :- ...
```

<details>
<summary>Exemples de sortida</summary>

```prolog
| ?- interseccio([],[1,2,3],Xs).
Xs = []
yes

| ?- interseccio([1],[],Xs).
Xs = []
yes

| ?- interseccio([1,b],[a,b,1,a,b],Xs).
Xs = [1,b]
yes

| ?- interseccio([1,b,1],[a,b,1,a,b,1],Xs).
Xs = [1,1,b]
yes
```
</details>

#### diferència
```prolog
% diferencia(+Xs, +Ys, ?Zs) => Zs = Xs \ Ys
diferencia(Xs, Ys, Zs) :- ...
```

<details>
<summary>Exemples de sortida</summary>

```prolog
| ?- diferencia([1,1],[1],Xs).
Xs = [1]
yes

| ?- diferencia([1,1],[1,2],Xs).
Xs = [1]
yes

| ?- diferencia([1,1,2,2,2],[1,2],Xs).
Xs = [1,2,2]
yes
```
</details>

#### multiconjunt_a_conjunt

  
```prolog
% multiconjunt_a_conjunt(+Xs, ?Zs) => Zs es Xs sense repeticions
multiconjunt_a_conjunt(Xs, Zs) :- ...
```

<details>
<summary>Exemples de sortida</summary>

```prolog
| ?- multiconjunt_a_conjunt([2, 3, 1, 1],Xs).
Xs = [1,2,3]
yes

| ?- multiconjunt_a_conjunt([2,3,1,1],Xs).
Xs = [1,2,3]
yes

| ?- multiconjunt_a_conjunt([2],Xs).
Xs = [2]
yes

| ?- multiconjunt_a_conjunt([],Xs).
Xs = []
yes

| ?- multiconjunt_a_conjunt([2,1,2],[1,2]).
(1 ms) yes
```
</details>

### Altres predicats

#### mcd

Podeu fer servir [l'Algorisme d'Euclides](https://ca.wikipedia.org/wiki/Algorisme_d%27Euclides).

```prolog
% mcd(+A, +B, ?M) => M es el maxim comu divisor de A i B
mcd(A, B, M) :- ...
```

#### camins

```prolog
% camins(+E,+X,+Y,?P) 
% E son les arestes d'un graf dirigit aciclic.
% La llista P conte un cami de X a Y.
camins(E,X,Y,P) :- ...

%Exemple d'execucio, graf sessio 1
%camins([ar(1,2),ar(1,3),ar(2,5),ar(3,5),ar(3,6),ar(4,3),ar(4,7),ar(5,6)],3,6,P).
%P = [3,6] ? ;
%P = [3,5,6] ? ;
%no
```


