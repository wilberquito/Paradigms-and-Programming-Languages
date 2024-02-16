# Sessió 1 (primeres 13 transparències del PdF) [^1][^2]

El nom Prolog deriva del francès "PROgramation LOGique". És un llenguatge de programació declaratiu basat en lògica.

La programació lògica és un paradigma de programació declaratiu, és a dir, els programes especifiquen **quin** problema volem resoldre. Això contrasta amb la programació imperativa, en que els programes especifiquen **com** s'ha de resoldre el problema. Altres exemples paradigmes declaratius són la programació funcional o la programació basada en restriccions. 

En el cas de Prolog, un programa consisteix en un conjunt de fets i regles especificades amb el fragment de les clàuses de Horn de la lògica de primer ordre (també anomenada lògica de predicats).

Una càusula de Horn és tota clausula (disjunció de literals) que té com a molt un literal positiu.

Per exemple, en lògica proposicional, una clàusula de Horn pot tenir la forma:

${\displaystyle \neg p\lor \neg q\vee \cdots \vee \neg t\vee u}$

Una clàusula de Horn també es pot reescriure equivalentment com a una implicació d'una conjunció de literals positius cap a un literal positiu:

${\displaystyle p\wedge q\wedge \cdots \wedge t\rightarrow u}$

Un exemple en lògica de primer ordre (no proposicional):

${\displaystyle p(X)\wedge q(Y) \wedge t(X,Y)\rightarrow u(X,Y)}$

El predicat anterior, en Prolog s'escriu:

${\displaystyle u(X,Y)}$ :- ${\displaystyle p(X), q(Y), t(X,Y).}$

## Programació Lògica vs Programació Imperativa

En programació imperativa, un programa consisteix en una seqüència de procediments que s'executen de manera ordenada. Tenim també estructures alternatives (if-else) i repetitives (bucles). Per altra banda, en programació lògica, un programa consisteix en una base de coneixement. Un mecanisme subjacent de raonament trobarà resposta a les nostres consultes basant-se en la base de coneixement. 

![logic-vs-procedural](Img/logic_functional_programming.jpg)

Com ja s'ha dit, en Prolog especificarem quin problema volem resoldre i no com el volem resoldre. El *com* el gestiona l'intèrpret de Prolog internament. En particular, el còmput de les solucions es basa en un mecanisme deductiu, SLD-resolució.

## Prolog: definició el llenguatge

Prolog és particularment útil per fer programes de manipulació simbòlia, i per tant és un bon candidat per aplicacions d'Intel·ligència Artificial on la manipulació simbòlica i la inferència siguin tasques fonamentals. 

Prolog destaca per la simplicitat del llenguatge. Té tres elements principals: 

- **Fets**: són àtoms lògics (típicament predicats relacionant diversos elements) que són certs. Per exemple, el següent fet expressa "En Tom és el pare d'en Jack".

  ```prolog
  father(tom, jack).
  ```
  El significat que donem a un fet és una decisió del programador. El fet anterior podria tenir la lectura alternativa "el pare d'en Tom és en Jack". Per això és **molt recomanable** afegir comentaris sobre com llegir els predicats del programa, almenys la primera vegada que apereixen. Per exemple:

  ```prolog
  % En Tom es el pare d'en Jack
  father(tom, jack).
  ```

  De fet, Prolog ignora el significat dels fets, només en detecta l'estructura sintàctica. Fixeu-vos que això és una propietat comuna de qualsevol llenguatge de programació. Per exemple, en un programa en C++, llevat de paraules clau del llenguatge (if, bool, ...), sempre podem reanomenar les variables, funcions, etc., sempre que siguem consistents amb totes les occurrències dintre de l'àmbit. Semblantment, el fet anterior es podria reanomenar com a:

  ```prolog
  % En tom es el pare d'en jack
  f(tom, jack).
  ```

- **Regles**: són extensions dels fets que representen implicacions. Més concretament, són clàusules de Horn en forma d'implicació. El símbol `:-` s'ha de llegir com a *si*, o *està implicat per*. Sovint es denomina la part de l'esquerra del `:-` com a **cap**, i la part de la dreta com a **cos**. Des d'un punt de vista més proper al mecanisme d'inferència subjacent (SLD-resolució), es pot llegir com a: si vols que demostri el cap, primer ha demostrar tots els literals del cos. Un exemple de regla:

  ```prolog
  grandfather(X, Y) :- father(X, Z), parent(Z, Y).
  ```
  Fixeu-vos que normalment les regles contenen **variables** (identificadors que comencen en majúscula). Les variables estan quantificades universalment. És a dir, s'ha de llegir com: *per tot valor de X, Y i Z, si X és el pare de Z i Z és el pare o mare de Y, llavors X és l'avi de Y*. Dues variables diferents poden tenir el mateix valor. Si ho volem evitar, ho hem d'especificar explícitament al cos:
  
  ```prolog
    siblings(X, Y) :- parent(Z, X), parent(Z, Y), X\=Y.
    ```

  Podem tenir diferents regles (diferents maneres) per arribar a la mateixa conclusió:
   ```prolog
    parent(X, Y) :- father(X, Y).
    parent(X, Y) :- mother(X, Y).
    ```


- **Consultes**: També *queries* o *objectius*. Donada una base de coneixement, formada per fets i regles, per executar un programa farem una *consulta*. A les consultes les variables estan quantificades existencialment. És a dir, fem la pregunta: existeix algun valor per cadascuna de les variables tal que es pugui demostrar aquesta *conjunció d'àtoms*?

  Exemple: existeix algú (alguna X) que sigui el pare d'en will?
  
    ```prolog
    father(X, will).
    no
    ```
  Exemple: existeix algú (alguna X) que sigui el pare d'en jack?
  
    ```prolog
    father(X, jack).
    X = tom
    yes
    ```

  Exemple: existeix algú (alguna X) que sigui el pare d'en jack i d'en will?

  ```prolog
  father(X, jack),father(X,will).
  no
  ```

## Prolog: primers passos

En aquest material treballarem sobretot amb GNU prolog, encara que hi ha altres implementacions. Tot i que es poden entrar fets i regles una per una a la consola interactiva, es recomana guardar-los en un fitxer (extensió .pl), i carregar-lo.

Si fem servir la consola del sistema, ho podem fer en el moment d'exexutar gprolog:

  ```console
  gprolog --consult-file fitxer.pl
  ```
Altrament hem d'assegurar que estem ubicats al directori correcte.

  Pas 1 − File > Change Dir.

  Pas 2 − Seleccionar el directori i clicar OK.

  ![Canviar directori](Img/select_working_directory.jpg)


  ![Prolog console](Img/prolog_console.jpg)

Finalment podem carregar el fitxer. Fixeu-vos que no afegim l'extensió *.pl*.

 ```prolog
  [fitxer].
  ```

Per fer una consulta, escriurem el fet conjunt de literals que volem demostrar, sempre acabat en punt `.`. Prolog no acaba la resolució de la consulta quan troba una resposta, sinó **quan ha explorat tot l'arbre de cerca**. Pot ser que el programa no acabi: la SLD-resolució de Prolog no és completa. En cas que la resposta sigui *yes*, dirà quin valor prenen les variables que hi hagi. Si encara no ha explorat tot l'arbre, esperarà una instrucció:
  - `;`: continua la cerca. Mostra el següent valor de variables que demostra la consulta, si és que n'hi ha més.
  - `a`: mostra totes les solucions. Poden ser infinites!
  - `[ENTER]`: atura la cerca. 

Prolog suporta variables anònimes, representades amb el caràcter de guió baix ‘_’. Cada variable anonima es considera una variable diferent. S'utilitzen quan només volem saber si la resposta d'una consulta és afirmativa o negativa, independentment del valor que reben les variables de la consulta. Compara el comportament de `hates(X,tom).` i `hates(_,tom)` sobre la següent base de coneixement.

Fitxer [var_anonymous.pl](Examples/var_anonymous.pl).
```prolog
hates(jim,tom).
hates(pat,bob).
hates(dog,fox).
hates(peter,tom).
```


## És el vostre torn (I)

### [lovers.pl](Examples/lovers.pl)

Feu servir el fitxer lovers.pl i feu les següents consultes en Prolog:

- A qui li agrada en John?
- Qui li agrada a l'Ann?
- Qui està enamorat d'algú?
- Qui és estimat per algú?
- Quines dues persones s'estimen mútuament?
- Qui estima sense ser correspost? (Nota: podeu fer servir `not(loves(...))`

## Els termes

Siguem més precisos amb la nomenclatura. En Prolog, tant els fets, com les regles, com les consultes estan composades per **termes**. Els tipus de termes que tenim són: constants, variables, i termes complexos (or estructures)

TODO: repassar a les transpes

- *Constants*

  - *Term atoms*: són els components més bàsics de prolog i es representen amb un identificador únic.  are the basic building blocks of Prolog, and they represent a unique identifier, 
  such as a constant or a string. Term atoms can be either a name, like "dog" or "cat", or a string 
  enclosed in single quotes, like 'dog' or 'cat'.

  - *Numbers* In Prolog, numbers are used to represent integers, floating-point numbers, or rational numbers. 
  They are used to perform mathematical operations, like addition, subtraction, and multiplication. 
  **Numbers aren’t particularly important in typical Prolog applications**.

- *Variables* are also terms. Variables in Prolog start with an uppercase letter, like X or Y, 
and they can be used to represent any value. The variable `_` (that is, a single underscore character) is rather special. It’s called the anonymous variable,
and we discuss late.

- *Complex Terms*, in Prolog you can define terms that represent more complex data structures, like lists, trees, and graphs, using a combination of atoms, numbers, 
and other terms.

  For example, you can define a term to represent a point in two-dimensional space, like this:

  ```prolog
  point(X, Y).
  ```

  Complex terms can also be facts or rules.

  ```prolog
  loves(vincent,mia).
  ```

![Data types](Img/data_objects.jpg)

## Tracejar l'execució

En Prolog podem tracejar l'execució. Per fer entrar en el mode de tracejar, escriurem `trace.` Per sortir del mode de tracing, entreu `notrace.`. El següent exemple mostra quines regles s'utilitzen i quines unificacions es fan per deduïr que en Jack i la Lisa són germans.


```prolog
father(tom,jack).
father(tom,lisa).
father(will,tom).
mother(ann,tom).
mother(ann,john).
parent(X,Y):-father(X,Y).
parent(X,Y):-mother(X,Y).
grandfather(X,Y):-father(X,Z),parent(Z,Y).
siblings(X,Y):-parent(Z,X),parent(Z,Y),X\=Y.

```

![Trace](Img/trace.png)

## És el vostre torn (II)

### [els_simpsons.pl](Examples/els_simpson.pl)

Donada la base de coneixement de els_simpsons.pl, definiu les regles següents:

- Ancestor
- Grandfather
- Grandmother
- Uncle
- Aunt



[^1]: [tutorialspoint](https://www.tutorialspoint.com/prolog)
[^2]: [learnprolog](http://www.let.rug.nl/bos/lpn//lpnpage.php?pagetype=html&pageid=lpn-htmlse1)

**Agraïments: Wilber Quito, autor de la primera versió del material.**
