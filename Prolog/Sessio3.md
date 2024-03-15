# Sessió 3

##  Arbre de cerca

Un arbre de cerca mostra la manera en què Prolog troba una resposta a una consulta. 
Mostra tots els passos de raonament per a arribar a una resposta, 
de manera que també podeu anomenar-lo un *arbre de demostració*, utilitzant terminologia lògica.

### Un primer exemple

```prolog
q(X):- p(X).
q(0).

p(X):- a(X), b(X).
p(1).

a(2).
a(3).

b(2).
b(2).
b(3).
```

Vegem com es genera l'arbre de cerca per a la consulta:

```prolog
?- q(X).
```
```text
                  [q(X)]
                  /    \
            X=X' /      \ X=0
                /        \
             [p(X')]      []
             /     \ 
     X'=X'' /       \ X'=1
           /         \
    [a(X''),b(X'')]   []
        /     \
 X''=2 /       \ X''=3
      /         \
   [b(2)]      [b(3)]
   /    \         \
  /      \         \
 []      []        []
```
Recordeu que les consultes i les regles poden compartir noms de variable, però això no significa que siguin la mateixa variable.
Així doncs, quan convingui reanomenarem les variables de les regles, per exemple afegint apòstrofs (X', X'', ...).

Les solucions s'enumeren llegint l'arbre d'esquerra a dreta, i es reconstrueixen mitjançant la composició de substitució, per exemple:
`{X'' -> 2}∘{X' -> X''}∘{X -> X'}` per tant `X -> 2`. La seqüència de solucions en l'exemple anterior és `X=2, X=2, X=3, X=1, X=0`.

### Un segon exemple

Recordeu el predicat `member`?

```prolog
% member(A,B), element A occurs in list B
member(X,[X|_]).
member(X,[_|L]):- member(X,L).
```


Vegem com es genera l'arbre de cerca per a la consulta:


```prolog
?- member(X,[a,b,c]).
```

```text
 [member(X,[a,b,c])]
      /     \
 X=a /       \ X=X'
    /         \
  []      [member(X',[b,c])]
               /     \
        X'= b /       \ X'= X''
             /         \
           []    [member(X'',[c])]
                      /     \
              X''= c /       \ X''=X'''
                    /         \
                  []     [member(X''',[])]
                              /     \   
                             /       \
                            *         * 
```

Aquesta consulta té tres solucions: `X=a, X=b` (perquè `X=X'` i `X'=b`), i `X=c` (perquè `X=X'` i `X'=X''` i `X''=c`).


### Control sobre l'arbre de cerca: el tall

Prolog té els avantatges de ser declaratiu, però sovint això ho paguem amb un cost computacional significatiu.
L'ordre i la repetició de clàusules poden provocar redundància en les respostes i en els fracassos.

Problemes que volem resoldre:
- Ineficiència
- Comportaments no especificats

Prolog té un predicat incorporat anomenat tall (*cut*), que s'escriu `!`, i que ens permet controlar l'arbre de cerca mitjançant la poda de branques redundants o innecessàries.
És un predicat que sempre té èxit, i talla les branques obertes de l'arbre de cerca.
D'aquesta manera, es dona un control directe en l'exploració de l'arbre de cerca.
Els talls s'utilitzen per fer que els programes en Prolog siguin eficients. Això sovint té la contrapartida que
els programes Prolog siguin menys declaratius i llegibles.

El tall **sempre té èxit** i provoca que es descartin totes les branques alternatives que estan pendents d'explorar.
Es pot entendre com una porta de no retorn: **després d'haver demostrat el tall en el cos d'una regla, no podem recular
més enrere d'ell fent backtracking, ni tampoc podem visitar fets o regles pendents d'explorar**.

Donada una regla de forma:

```text
A:- B1,...,Bk,!,Bk+1,...,Bn. % Branca 1
A:- (branca alternativa per la consulta G) % Branca 2
A:- (branca alternativa per la consulta G) % Branca 3
...
```


tal que `A` the s'unifica amb la consulta `G`: després d'haver demostrat B1,...,Bk, per la branca 1,
el tall es demostra automàticament, i el seu efecte és:

1) Si l'intent de satisfer Bk+1,...,Bn falla, el Backtracking només és permès fins al tall.
2) Les branques posteriors (Branca 2, Branca 3, ...) són descartades.

Vegem com funciona el tall en el primer exemple.

Definició del coneixement de base.

```prolog
q(X):- p(X).
q(0).

p(X):- a(X), !, b(X).
p(1).

a(2).
a(3).

b(2).
b(2).
b(3).
```


Comparació entre l'arbre podat i l'arbre original a partir del primer exemple.

```text
                 (pruned)                    (original)    
                                                           
                  [q(X)]                       [q(X)]      
                  /    \                       /    \ 
            X=X' /      \ X=0            X=X' /      \ X=0
                /        \                   /        \
             [p(X')]      []              [p(X')]      []
             /     \                      /     \ 
     X'=X'' /      ---            X'=X'' /       \ X'=1
           /                            /         \
   [a(X''),!,b(X'')]             [a(X''),b(X'')]   []
        /     \                     /     \
 X''=2 /      ---            X''=2 /       \ X''=3
      /                           /         \
  [!,b(2)]                     [b(2)]      [b(3)]
   /    \                      /    \         \
  /      \                    /      \         \
 []      []                  []      []        []
```


Canviant una mica el codi, les solucions ara són `X=2, X=2, X=0`.

### Factorial amb tall


```prolog
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
```
Què creus que passarà amb la següent consulta?

```prolog
?- findf(X,2).
```

Una possible solució és controlar la satisfactibilitat de la segona clàusula afegint la restricció `N>0`, 
com hem vist en la sessió anterior.

```prolog
% fact(+N,F) => F is the factorial of N
fact(0,1).
fact(N,F):- N>0,
            Np is N-1,
            fact(Np,F1),
            F is F1 * N.
```
Alternativament podem fer servir el tall. Fixeu-vos que aquí té un efecte d'exclusió mútua de les dues clàusules,
és a dir, proves la segona si i només si la primera falla.

```prolog
% fact(+N,F) => F is the factorial of N
fact(0,1):- !.
fact(N,F):- Np is N-1,
            fact(Np,F1),
            F is F1 * N.
```

### Sort amb tall

```prolog
% sorted(+L) => L is ascending sorted
sorted([]).
sorted([_]).
sorted([X,Y|Zs]):- X=<Y, 
                   sorted([Y|Zs]).

% sort(X,Y) => Y is the result of sort X.
sort(Xs,Xs):- sorted(Xs), !.
sort(Xs,Ys):- append(As,[X,Y|Ns],Xs), 
              X>Y, !,
              append(As,[Y,X|Ns],Xs1), 
              sort(Xs1,Ys).
```

El primer tall torna a fer la funció d'exclusió mútua: si ja està ordenada, no cal provar la regla següent.

La segona regla busca un parell d'elements consecutius desordenats (X,Y), si hi són els ordena i repeteix el procés recursivamen.
El tall aquí ens prohibeix ordenar més d'una vegada la llista: a cada crida recursiva, agafa només el primer parell d'elements desordenats que trobis.

## La negació per fracàs

Recordeu el metapredicat de negació per fracàs `\+Q`. Una consulta negada té èxit si s'intenta
falsificar-ho falla.

La seva implementació fa ús del tall `!` i el predicat integrat `fail`, que sempre falla:

```prolog
not(Q) :- call(Q), !, fail. %Branca 1
not(Q). % Branca 2
```

Vist com a arbre:

```prolog
           [\+Q]         
          /     \             
         /       \          
        /         \          
  [Q,!,fail]       []     
```

Tenim dos escenaris possibles, que efectivament compleixen amb la negació per fracàs:
- La consulta `Q` es pot demostrar: en aquest cas, la primera branca avança fins a fallar amb `fail`,
  i el tall prohibeix explorar la segona branca. Per tant `\+Q` no es pot demostrar.
- La consulta `Q` no es pot demostrar: en aquest cas la primera branca fallarà abans d'arribar al fail, s'explorarà
  la segona branca, que demostrarà `\+Q`.

## I/O i tall

```prolog
% repeat => a built-in predicate that always satisfy.
repeat.
repeat:- repeat.

% read_number(X) => X is a number read from the keyboard.
read_number(X):-  repeat, 
                  write("PSS. enter a number: "),
                  read(X), 
                  number(X), !.
              
% treat_number(X) => If X is 0 then satisfy otherwise 
% the square of the number is computed and then fail,
treat_number(0):- !.
treat_number(X):- R is X*X, 
                  writeln([X, '^ 2=', R]), 
                  fail.

% squares => Read integers and show the square of the numbers
% until a 0 is reached.
squares:- repeat, 
          read_number(X), 
          treat_number(X), !.
```

Fixeu-vos que els string al write (o print) van entre **cometes simples**.

Més entada i sortida: http://www.gprolog.org/manual/html_node/gprolog039.html


## Tipus de dades a partir de termes

Prolog no ens permet crear nous tipus (de fet no hi ha tipus). Per simular tipus de dades,
necessitem definir el comportament dels termes.

```prolog
% buidtree(N,A,B,T) => T is the tree with node N, A as left son, B as right son.
bluidtree(N,T1,T2,tree(N,T1,T2)).

% node(T,N) => N is the root of the tree T.
node(tree(N,_,_),N).

% ls(T,T1)/rs(T,T2) => T1/T2 left son/right son.
ls(tree(_,T1,_),T1).
rs(tree(_,_,T2),T2).

% preorder(T,L) => L is the preorder of T.
preorder(tree(N,T1,T2),[N|L]):-  preorder(T1,L1),
                                 preorder(T2,L2),
                                 append(L1,L2,L).
preorder(tempty,[]).
```

Exemple:

```prolog
?- 
| bluidtree(1,tempty,tempty,T1), 
| bluidtree(3,tempty,tempty,T2), 
| bluidtree(2,T1,T2,T), 
| preorder(T,P).
T1 = tree(1, tempty, tempty),
T2 = tree(3, tempty, tempty),
T = tree(2, tree(1, tempty, tempty), tree(3, tempty, tempty)),
P = [2, 1, 3].
```


## Enumerar solucions 
Imaginem el predicat `multiplicar(+X,+Y,Z)`. La seva implementació seria trivial: `Z is X*Y`. En canvi, si volguéssim treure la precondició que
`X` i `Y` estiguin instanciats, això ja no funciona.
En aquests casos, la implementació sovint requereix enumerar els possibles valors (total o parcialment definits) 
d'una variable. En aquests casos, els predicats que ens acostumen a fer servei són `between`, `member` i `append`.


Exemple il·lustratiu, taules de multiplicar:

``` prolog
taulesMultiplicar:-
   between(1,10,X),
   print('\n=== Taula del '), 
   print(X), print(' ===\n'), 
   between(1,10,Y),
   Z is X*Y, 
   format("\n%d*%d=%d\n",[X,Y,Z]).
```

Alternativament (rang s'ha d'implementar, exercici a continuació):


``` prolog
taulesMultiplicar:-
   rang(1,10,L),
   member(X,L),
   print('\n=== Taula del '), 
   print(X), print(' ===\n'), 
   member(Y,L),
   Z is X*Y, 
   format("\n%d*%d=%d\n",[X,Y,Z]).
```


## El vostre torn

Intenta fer servir el tall per implementar el predicat `rang`.

### Rang

```prolog
% rang(+B,+D,L) => L is the list of numbers from B to D. B < D.
rang(B,D,L):- ...
```

<details>
  <summary>Aquí teniu una solució (primer proveu-ho sense mirar-la)</summary>

  ```prolog
   rang(D,D,[D]):- !.
   rang(B,D,[B|L]):- C is B+1, rang(C,D,L).
  ```
</details>
