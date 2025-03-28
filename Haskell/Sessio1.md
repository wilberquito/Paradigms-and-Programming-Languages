# Sessió 1

Podem alliberar la programació de l'estil von Neumann?

## Programació funcional

La programació funcional és un paradigma de programació que es basa en els
principis del lambda-càlcul. El lambda-càlcul és un sistema formal 
desenvolupat la dècada de 1930 per [Alonzo Church](https://es.wikipedia.org/wiki/Alonzo_Church)  com una manera 
de representar funcions matemàtiques. 


> 1936 - Alan Turing invents every programming language that will ever be but
is shanghaied by British Intelligence to be 007 before he can patent them.
> 
> 1936 - Alonzo Church also invents every language that will ever be but does it better.
His lambda calculus is ignored because it is insufficiently C-like.
This criticism occurs in spite of the fact that C has not yet been invented.
> 
> Font: [A Brief, Incomplete, and Mostly Wrong History of programming languages](http://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)

Els fonaments de la programació funcional són notacions matemàtiques abstractes
de càlcul que transcendeixen una implementació específica. Això
ens porta cap a un mètode de programació que sovint resol problemes simplement 
descrivint-los[^1]. 

És a dir, estem parlant d'un **llenguatge declaratiu**.

## Entorn de treball

Només es necessita un editor de text i un compilador de Haskell. 
Podeu instal·lar el [GHCup](https://www.haskell.org/ghcup/install/), que conté el compilador (*ghc*) i intèrpret (*ghci*),
i cabal-install, el gestor de llibreries. També els podeu instal·lar [separadament](https://www.haskell.org/ghc/).
Tot i que la web diu que està disponible per diferents plataformes,
per aquest document s'ha treballat amb la versió per Ubuntu.
En cas de necessitat, els usuaris de Mac i Windows podeu utilitzar [multipass](https://multipass.run/),
que permet crear màquines virtuals lleugeres, només amb interfície de línia de comandes.

Els fitxers de codi Haskell acaben amb l'extensió `.hs`.
Els podem compilar i executar, o els podem carregar des de l'intèrpret, semblantment com fèiem amb Prolog.

Obrim l'intèrpret:

```haskell
$ ghci
Prelude>
```

Sortim de l'intèrpret amb la comanda `:q`:

```haskell
$ ghci
Prelude> :q
Leaving GHCi.
```

Treballar amb GHCi és molt semblant a treballar amb intèrprets en la majoria de llenguatges de programació interpretats com Python i Node per a JS.
Es pot utilitzar com a calculadora senzilla:

```haskell
Prelude> 1 + 1
2
```

També podeu entrar-hi codi:

```haskell
Prelude> x = 2 + 2
Prelude> x
4
```

Tot i que és millor treballar amb el codi sobre un fitxer. El codi [`Main.hs`](Examples/Main.hs) que teniu d'exemple conté:

```haskell
main = print (fac 20)

fac 0 = 1
fac n = n * fac (n-1)
```

El podeu guardar on vulgueu, `Main.hs`, però perquè sigui visible heu d'estar situats al directori de treball correcte.

```haskell
Prelude> :cd dir
```

També podeu utilitzar les comandes habituals del terminal, precedides per `:!`.
```haskell
Prelude> :! ls
Baixades Documents Escriptori
Prelude> :! pwd
/home/plp
```

Per carregar un fitxer amb GHCi, feu servir la comanda `:load`:

```haskell
Prelude> :load Main
Compiling Main             ( Main.hs, interpreted )
Ok, modules loaded: Main.
```

Si feu canvis al fitxer i els voleu tornar a compilar, feu servir `:reload`.
El programa es tornarà a compilar segons sigui necessari, i GHCi farà 
tot el possible per evitar tornar a 
compilar mòduls si les seves dependències externes no han canviat.
```haskell
Prelude> :reload
Compiling Main                ( Main.hs, interpreted )
Ok, modules loaded: Main.
```

## Què és Haskell?

Haskell és un llenguatge purament funcional.
De la mateixa manera que C és l'encarnació gairebé perfecta de l'estil de programació de von Neumann,
Haskell és el llenguatge de programació funcional més pur que pots aprendre.

> 1990 - A committee formed by Simon Peyton-Jones, Paul Hudak, Philip Wadler, Ashton Kutcher, and People for the Ethical Treatment of Animals creates Haskell, a pure, non-strict, functional language. Haskell gets some resistance due to the complexity of using monads to control side effects. Wadler tries to appease critics by explaining that "a monad is a monoid in the category of endofunctors, what's the problem?"
>
> Font: [A Brief, Incomplete, and Mostly Wrong History of programming languages](http://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)

### Haskell no té...

#### Assignacions

```c++
a = 2
a = 1
```

Però tenim vinculació de noms.

#### Bucles imperatius

```c++
for(int i = 0; i < 10; i++)
    cout << i;
```


Però tenim recursivitat. 
Tot allò que es pot resoldre iterativament, també pot ser resolt recursivament.

#### Efectes colaterals

```c++
int x;

int add1(){
  // L'us de variables globals pot tenir efectes indesitjats
  // i es dificil de tracejar 
  x = x + 1
  return x
}
```

#### Gestió de memòria

```c++
MyType * x = new MyType(); //Necessita destructor
MyType & y = variables[3]; //Compte si s'allibera l'espai de memoria de 'variables' !
```

### Haskell sí que te...

#### Sistema de tipus estàtic

El sistema de tipus de Haskell assegura que cada expressió del programa 
té un tipus ben definit. Les expressions de tipus es comproven en temps de compilació. 
L'ús incoherent dels tipus condueix a errors en temps de compilació.
  ```haskell
  -- L'operador (+) espera dos nombres...
  Prelude> (+) "hello friend" 2

  <interactive>:4:1: error:
      • No instance for (Num [Char]) arising from a use of ‘+’
      • In the expression: (+) "hello friend" 2
        In an equation for ‘it’: it = (+) "hello friend" 2
  ```

#### Inferència de tipus

Tot a Haskell té un tipus, de manera que el compilador pot raonar molt sobre el 
programa abans de compilar-lo. A diferència de Java o C, Haskell té inferència de 
tipus. Si escrivim un nombre, no cal dir-li a Haskell que és un nombre, sinó que el
compilador ho pot inferir tot sol. Així doncs, tot i que sigui un llenguatge tipat,
no cal escriure els tipus explícitament. Podem comprovar el tipus d'una expressió amb `:t`.
```haskell
Prelude> :t 'a'
'a' :: Char
Prelude> :t True
True :: Bool
Prelude> :t "HELLO!"
"HELLO!" :: [Char]
Prelude> :t (True, 'a')
(True, 'a') :: (Bool, Char)
Prelude> :t 4 == 5
4 == 5 :: Bool
Prelude> :t (+)
(+) :: Num a => a -> a -> a
```

Tot i que no sigui obligatori especificar els tipus, hi ha diversos motius pels quals és recomanable.

- Serveixen per tenir codi autodocumentat
- Actuen com a restriccions que el compilador comprovarà: ajuda a detectar errors
- Podem especificar tipus més concrets dels que el compilador inferiria altrament. Per exemple:


```haskell
doubleMe x = x + x

doubleMe2 :: Int -> Int
doubleMe2 x = x + x
```

```haskell
Prelude> :type doubleMe
doubleMe :: Num a => a -> a
Prelude> :type doubleMe2
doubleMe2 :: Int -> Int
```

#### Funcions

El concepte de funció a Haskell manté el significat que li donem en matemàtiques: una funció `f(x1,...,xn)=y`
és una relació entre valors de`x1,...,xn` i un únic valor de retorn `y`.

##### Aplicació

El que matemàticament denotem entre parèntesis, amb Haskell ho escrivim separat per espais
```text
```haskell
-- Es el mateix que f (a, b) + c × d
f a b + c * d
```

L'aplicació de funcions té prioritat màxima.

```haskell
-- Significa (f a) + b, no pas f (a + b)
f a + b
```

Podem canviar-ho amb parèntesis:

```haskell
-- Aplica la funció f a dos arguments
f (a + b) c
```

##### Funcions d'ordre superior

A Haskell podem fer de tot amb les funcions: passar-les com a paràmetre, retornar-les, o combinar-les
per formar operacions més complexes.

Exemple:

```haskell
map :: (a -> b) -> [a] -> [b]
map f []     = []
map f (x:xs) = f x : map f xs
```

##### Funcions pures

Les funcions són *pures* en el sentit que el seu valor de retorn depèn únicament dels seus paràmetres,
a diferència dels llenguatges imperatius. Gràcies a això, la verificació formal és
relativament fàcil.

Exemple:

```haskell
double :: Int -> Int
double x = x * 2
```

##### Funcions currificades

En realitat, les funcions a Haskell reben un sol paràmetre. Però fins ara hem vist
multiples exemples en què això no és així. Com s'entén?

Totes les funcions que accepten múltiples paràmetres són funcions currificades.
Currificar és el procés de transformar una funció amb més d'un paràmetre en una composició de funcions que incorporen 
progressivament, d'un en un, els paràmetres de la funció original.
També anomenem aquest procés *aplicació parcial*.

Exemple:

```haskell
Prelude> :t max
max :: Ord a => a -> a -> a
Prelude> max 4 5
5
Prelude> f = max 4
Prelude> :t f
f :: (Ord a, Num a) => a -> a
Prelude> f 5
5
```

La definició de tipus d'una funció, com ja hem vist, es fa mitjançant `->`: 
és el **constructor de tipus**, i és associatiu per la dreta.
Per exemple, la funció:

```haskel
f :: a -> b -> c -> d -> e
```

També es pot escriure com a:
```haskel
f :: a -> (b -> c -> d -> e)
```

O bé:
```haskel
f :: a -> (b -> (c -> d -> e))
```

O també:
```haskel
f :: a -> (b -> (c -> (d -> e)))
```

Però compte! **No és el mateix** que, per exemple:
```haskel
f :: (a -> b) -> c -> d -> e
```



La majoria de llenguatges no permeten això. Amb JavaScript podem simular-ho amb:


```js
function max(a) {
  return function(b) {
    return a > b ? a : b
  }
}
```

```js
const f = max(4)
f(5)
5
```

##### Ordre normal de reducció

> Vist a teoria; estratègies de reducció

#### Estructures infinites

```haskell
infiniteList :: [Int]
infiniteList = [1..]
```

#### Avaluació lazy

Els valors només s'avaluen quan es necessiten.
Això permet treballar amb estructures infinites i obtenir programes més eficients.

```haskell
mayHang :: a -> b -> b
mayHang x y = y
```

```haskell
Prelude> mayHang infiniteList (1 + 1)
Prelude> 2
Prelude> mayHang (1 + 1) infiniteList
[1,2,3...]
```

#### Variables

En Haskell també tenim variables:
```haskell
Prelude> x = 3
```
Però no en el sentit convencional de mantenir (i modificar) un estat.
El següent donaria error de compilació:

```haskell
main = do
  let x = 3
      x = 2
   . . .
```

És millor entendre les variables com a definicions o àlies.

L'ús principal de les variables és per clarificar el codi i evitar repeticions.
Per exemple, en la funció següent per calcular la resta si és més gran que 0
```haskell
restaGT0 a b = if b - a > 0
                        then b - a
                        else 0
```

Podem definir una variable al bloc `where` per estalviar repeticions:

```haskell
restaGT0 a b = if resta > 0
                        then resta
                        else 0
  where resta = b – a
```
**El where ha d'estar indentat un pas a la dreta del no de la funció. És una mica primmirat...**
## Pregunta...

Diferents llenguatges inclouen l'operador `++` per incrementar un valor; 
per exemple, en llenguatge C++,  `x++` incrementa `x`. 
Creus que Haskell també té un operador semblant?

## Tipus integrats

Hem mencionat anteriorment que Haskell té un sistema de tipus estàtic, i el tipus de les expressions
es determina en temps de compilació.

### Què són els tipus

Intuïtivament, podem entendre un tipus com un conjunt de valors permesos i conjunt d'operacions sobre aquests valors.


### Sintaxi dels tipus

|       Tipus       |          Literals          |                                   Ús                                   |                  Operacions                   |
|:-----------------:| :------------------------: |:----------------------------------------------------------------------:|:---------------------------------------------:|
|        Int        |          1, 2, -3          |                      Number type (signed, 64bit)                       |       +, -, \*, div, mod, fromIntegral        |
|      Integer      | 1, -2, 900000000000000000  |                         Unbounded number type                          | +, -, \*, div, mod, fromInteger, fromIntegral |
|       Float       |         0.1, 1.2e5         |                         Floating point numbers                         |               +, -, \*, /, sqrt               |
|      Double       |         0.1, 1.2e5         | Floating point numbers. Aproximations are more precise than Float type |               +, -, \*, /, sqrt               |
|       Bool        |        True, False         |                              Truth values                              |                     &&, \|\|, not, otherwise            |
|       Char        | 'a', 'Z', '\n', '\t', '\\' |  Represents a character (a letter, a digit, a punctuation mark, etc)   | ord, chr, isAlpha, isDigit, isUpper, isLower  |
| String aka [Char] |         "abcd", ""         |                         Strings of characters                          |                  reverse, ++                  |

Algunes d'aquestes operacions estan definides per un tipus més generic que el de la taula, un typeclass.
Un *typeclass* és una mena d'interfície que defineix cert comportament. 
Si un tipus pertany a un typeclass, significa suporta **i implementa** el comportament del typeclass.

Per exemple, si preguntem a Haskell el tipus de l'operador `div`:

```haskell
Prelude> :type div
div :: Integral a => a -> a -> a
```

Veiem que el símbol `=>`. La part esquera del `=>` s'anomena una restricció.
Ho podem llegir tot plegat de la manera següent: la funció `div` rep dos valors tals que tinguin el mateix tipus i retorna un valor 
del mateix tipus (part `a -> a -> a`). A més a més, el tipus `a` ha de ser un membre del typeclass `Integral`
(restricció, part `Integral a`).

Per tant, com que `Int` i `Integer` pertanyen al typeclass `Integral`, tots dos implementen l'operador `div`.

<details>
    <summary>Desplegueu per veure la jerarquia de typeclass del Prelude (mòdul per defecte) de Haskell</summary>
    <img src="Gif/classes.gif"/>
</details>

[Més informació](https://www.haskell.org/onlinereport/haskell2010/haskellch6.html)

### Operadors d'igualtat i ordre

Els següents operadors binaris, que retornen un Booleà, estan definits per tots els tipus basics esmentats anteriorment:

| Operador |      Descripció       |
|:--------:|:---------------------:|
|    >     |     greater than      |
|    >=    | greater than or equal |
|    <     |       less than       |
|    <=    |  less than or equal   |
|    ==    |      equal than       |
|    /=    |    different than     |

Els dos arguments d'aquests operadors han de tenir el mateix tipus, altrament Haskell donarà error de tipus:
Exemple:

```haskell
Prelude> 10 /= 10
False
Prelude> "hello" == "hello"
True
Prelude> True < 'a'
<interactive>:6:8: error:
    • Couldn't match expected type ‘Bool’ with actual type ‘Char’
    • In the second argument of ‘(<)’, namely ‘'a'’
      In the expression: True < 'a'
      In an equation for ‘it’: it = True < 'a'
```


## Pattern matching

El *pattern matching* consisteix a especificar patrons amb els quals les dades han d'enxaixar,
i tractar les dades segons amb quin patró han encaixat.

Quan definim funcions, podem separar el ceu cos amb diferents patrons. 
Això ens permet obtenir un code més net, simple i llegible.
Podem definir patrons per qualsevol tipus de dades: nombres, caràcters, llistes, tuples, etc.

Exemple:

```haskell
lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER SEVEN!"
lucky x = "Sorry, you're out of luck, pal!"
```

Quan cridem `lucky`, els patrons es comproven de dalt a baix, i ens quedem amb el primer que encaixa:
aquest serà el que ens definirà la funció pels paràmetres que hem passat.
En aquest cas, si cridem `lucky 7`, la implementació és la primera, i si cridem `lucky 6` (per exemple),
la implementació serà la segona. Ho podem veure com una mena de funció definida a trossos.

Detall important: es queda sempre **només amb el primer patró que troba** de dalt a baix.
Per exemple, si ho implementem com a:

```haskell
lucky :: (Integral a) => a -> String
lucky x = "Sorry, you're out of luck, pal!"
lucky 7 = "LUCKY NUMBER SEVEN!"
```

Sempre retornarà "Sorry, you're out of luck, pal!", encara que cridem `lucky 7`.


Fixeu-vos també que si no contemplem tots els paràmetres possibles amb els diferents patrons, la funció pot ser indefinida per alguns paràmetres,
i ens pot donar un error en temps d'execució.

Exemple:

```haskell
lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER SEVEN!"
```

```haskell
Prelude> lucky 14
*** Exception: Lucky.hs: Non-exhaustive pattern in function lucky
```

**ALERTA: no té res a veure amb les diferents regles per un mateix predicat amb Prolog!**


## Tuples

Una tupla és un tipus de dades compost, en què cada element pot tenir un tipus diferent.

```text
Si v1, v2, . . . ,vn són valors amb tipus t1, t2, . . . ,tn
llavors (v1, v2, . . . ,vn) és una tupla amb tipus (t1, t2, . . . ,tn)
```

Exemples:

```haskell
Prelude> :type ()
() :: ()
Prelude> :type ('a', False)
('a', False) :: (Char, Bool)
Prelude> :type ('a', False, 1.5)
('a', False, 1.5) :: Fractional c => (Char, Bool, c)
```

## Llistes

Una llista és una col·lecció de zero o més elements **del mateix tipus**.

Hi ha dos constructors de llistes:

- `[]` representa una llista buida.
- `(:)` permet afegir un element al principi d'una llista.

```text
Si v1, v2, . . . , vn son valors amb tipus t
llavors v1 : (v2 : (. . . (vn−1 : (vn : [])))) és una llista amb tipus [t]
```

Exemple:

```haskell
Prelude> :type []
[] :: [a]
Prelude> 1:[]
[1]
Prelude> 'a':(1:[])
<interactive>:20:6: error:
    • No instance for (Num Char) arising from the literal ‘1’
    • In the first argument of ‘(:)’, namely ‘1’
      In the second argument of ‘(:)’, namely ‘(1 : [])’
      In the expression: 'a' : (1 : [])
```

El constructor `(:)` és associatiu per la dreta.

```text
x1 : x2 : . . . xn−1 : xn : [] ===> x1 : (x2 : (. . . (xn−1 : (xn : []))))
```

Haskell permet una sintaxi més convenient per llistes.

```text
[x1, x2, . . . xn−1, xn] ===> x1 : (x2 : (. . . (xn−1 : (xn : []))))
```

Exemple:

```haskell
Prelude> 1:(2:(3:[]))
[1,2,3]
Prelude> 1:2:3:[]
[1,2,3]
Prelude> [1,2,3]
[1,2,3]
```

També podem fer servir llistes per a pattern matching, fent servir tant el constructor de llista
buida `[]` com el constructor `:`.

El patró `x:xs` anomenarà `x` el primer element de la llista, i la resta d'elements seran la llista `xs` (pot ser una llita buida).

Exemples:

```haskell
head' :: [a] -> a
head' [] = error "Can't call head on an empty list, dummy!"
head' (x:_) = x
```
Podem fer patrons combinats, en aquest cas per a llista de tuples:

```haskell
-- function that sums all elements from a list of tuples
sumPairs :: [(Integer, Integer)] -> Integer
sumPairs [] = 0
sumPairs ((x,y):xs) = x + y + sumPairs(xs)
```

## El patró guió baix

- Pren la forma `_`
- S'unifica amb qualsevol paràmetre
- No dona nom al paràmetre (no el podem fer servir per a la implementació)

Exemples:

```haskell
-- number of elements from a list of Int
length :: [Int] -> Int
length [] = 0
length (_:xs) = 1 + length xs
```

```haskell
lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER SEVEN!"
lucky _ = "Sorry, you're out of luck, pal!"
```


## Expressió if-then-else 

```haskell
if boolExpression then ifExpression else noExpression
```

- El tipus de *boolExpression* ha de ser `Bool`
- Els tipus de *ifExpression* i *noExpression* han de ser el mateix
- Sempre hi ha d'haver un else
- L'avaluació és lazy

Exemple:

```haskell
-- a function that multiplies a number by 2 but only
-- if that number is smaller than or equal to 100
-- because numbers bigger than 100 are big enough as it is!
doubleSmallNumber x = if x > 100
                        then x
                        else x*2

-- a function that multiplies a number by 2 but only
-- if that number is smaller than or equal to 100
-- because numbers bigger than 100 are big enough as it is!.
-- Adds 1
doubleSmallNumber' x = (if x > 100 then x else x*2) + 1
```

## Guardes

Mentre que els patrons ens permeten identificar formes sobre el conjunt de paràmetres,
les guardes ens permeten fer consultes booleanes sobre el seu contingut, i distingir diferents casos:
- Cada patró pot tenir les seves guardes
- Les expressions entre els simbols `|` i `=` s'anomenen guardes (tipus Bool)
- Semblantment com amb els patrons, ens quedem amb la primera definició tal que la seva guarda retorni `True`
- Sovint, l'última guarda és `otherwise`, que és una funció que sempre retorna `True`

Exemple:

```haskell
Prelude> :type otherwise
otherwise :: Bool
Prelude> otherwise
True
```

```haskell
bmiTell :: (RealFloat a) => a -> String
bmiTell bmi
    | bmi <= 18.5 = ":/"
    | bmi <= 25.0 = ":D"
    | bmi <= 30.0 = ":)"
    | otherwise   = ":/"
```

**Les guardes també han d'estar indentades a la dreta.**

## Case

```haskell
case EXPRESSIO of  PATRO -> RESULTAT
                   PATRO -> RESULTAT
                   PATRO -> RESULTAT
                   ...
```

Ens permet avaluar expressions basant-se en els possibles casos del valor d'una variable, i podem
fer pattern matching per cada valor. 
Si cap patró unifica, obtindrem un error.

- L'expressió i tots els patrons han de tenir el mateix tipus
- Cada resultat ha de tenir el mateix tipus

Exemple:

```haskell
head' :: [a] -> a
head' xs = case xs of [] -> error "No head for empty lists!"
                      (x:_) -> x

describeList :: [a] -> String
describeList xs = "The list is " ++ case xs of [] -> "empty."
                                               [_] -> "a singleton list."
                                               _ -> "a longer list."
```

## El vostre torn

Feu els exercicis 1.1, 1.2, 1.3, 1.4, 1.7, 1.8, 1.9 i 1.10 del fitxer del Moodle *Exercicis addicionals*.

Si acabeu podeu fer també els 1.5 i 1.6. 

De cara a la sessió 2, feu també els exercicis següents:

### Distancia euclidiana

```haskell
-- Ex 1: define the function distance. It should take two arguments that are tuples, of
-- type (Double,Double). 
--    distance (x1,y1) (x2,y2) 
--    returns the (euclidean) distance between points (x1,y1) and (x2,y2).
--
-- Give distance a type signature, i.e. distance :: something.
--
-- PS. if you can't remember how the distance is computed, the formula is:
--   square root of ((x distance) squared + (y distance) squared)
-- You might prefer use the  `where` code block to declare variables.
--
-- Examples:
--   distance (0,0) (1,1)  ==>  1.4142135...
--   distance (1,1) (4,5)  ==>  5.0

distance :: something
. . .
```



### Intepreter

```haskell
-- Ex 3: in this exercise you get to implement an interpreter for a
-- simple language. You should keep track of the x and y coordinates,
-- and interpret the following commands:
--
-- up -- increment y by one
-- down -- decrement y by one
-- left -- decrement x by one
-- right -- increment x by one
-- printX -- print value of x
-- printY -- print value of y
--
-- The interpreter will be a function of type [String] -> [String].
-- Its input is a list of commands, and its output is a list of the
-- results of pthe print commands in the input.
--
-- PS. You might need the function `show`
-- the function `show` has type: Show a => a -> String
-- Numbers are part of the Show category so they implement the
-- function show that transforms numbers to strings
--
-- Both coordinates start at 0.
--
-- Examples:
--
-- interpreter ["up","up","up","printY","down","printY"] ==> ["3","2"]
-- interpreter ["up","right","right","printY","printX"] ==> ["1","2"]
--
-- Surprise! after you've implemented the function, try running this in GHCi:
--     interact (unlines . interpreter . lines)
-- after this you can enter commands on separate lines and see the
-- responses to them
--
-- The suprise will only work if you generate the return list directly
-- using (:). If you build the list in an argument to a helper
-- function, the surprise won't work.

interpreter :: [String] -> [String]
. . .
```



[^1]: [Get Programming with Haskell](https://livebook.manning.com/book/get-programming-with-haskell/about-this-book/).
