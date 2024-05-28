# Paradigmes i Llenguatges de Programació 2023-24
## Pràctica de Haskell

El matemàtic George Boole (1815-1864) pretenia determinar les lleis que regeixen el pensament humà. Per a això, va dissenyar a mitjans del segle XIX l'àlgebra de Boole. Es tracta d'una estructura algebraica que captura l'essència de les operacions lògiques *i* , *o* i *no*.

Una fórmula proposicional (per brevetat, l'anomenarem proposició d'ara endavant) en aquesta àlgebra consisteix en una expressió en la qual poden aparèixer les constants True i False (per representar la noció de cert i fals), variables amb domini {True, False}, 
la conjunció de dues proposicions (representada com p1 & p2), que serà certa si totes dues proposicions són certes, 
la disjunció de dues proposicions (representada com p1 v p2), que serà certa si almenys una de les proposicions és certa, 
i la negació d'una proposició (representada com ¬p), que serà certa si la proposició p és falsa.

Alguns exemples de proposicions són True & a, a & ¬a i (a & b) v ¬c. 
Per tal d'estalviar parèntesis a l'hora d'escriure proposicions, es considerarà que la negació té la màxima prioritat, 
seguida de la conjunció i finalment la disjunció.

Les següents definicions de tipus poden ser utilitzades per representar proposicions de l'àlgebra de Boole en Haskell:
```haskell
type Nom = String
infixl 7 :/\
infixl 6 :\/
data Prop = Const Bool
 | Var Nom
 | No Prop
 | Prop :/\ Prop
 | Prop :\/ Prop deriving Show
```
Amb aquesta definició de tipus, les proposicions d'exemple anteriors es definirien així:
```haskell
e1, e2, e3 :: Prop
e1 = Const True :/\ Var "a"
e2 = Var "a" :/\ No (Var "a")
e3 = (Var "a" :/\ Var "b") :\/ No (Var "c")
```
**Inclou el fragment de codi anterior a la teva solució**.

Observa que el tipus anterior permet representar proposicions com a arbres amb nodes binaris (els corresponents a :/\ i :\/) o unaris (la resta). Per exemple, l'arbre corresponent a e3 és:

```
     :\/
     /  \
  :/\    No
  /  \    |
Var Var  Var
 |   |    |
 a   b    c
```

Fent servir aquestes definició de tipus, es demanen un seguit d'exercicis per muntar tot un sistema d'especificació i resolució de lògica proposicional.
La puntuació és la següent:

- Exercicis de l'1 al 8: 6 punts en total
- Exercici 9: 1 punt
- Exercici 10: 3 punts


### Exercici 1 
Per avaluar una proposició en què apareixen variables és necessari assignar a cada variable 
un valor del domini {True, False}. Per exemple, si assignem el valor *True* a la variable *a*, 
el valor *False* a la variable *b* i el valor *True* a la variable *c* 
(el que denotarem com `[a -> True, b -> False, c -> True]`), l'avaluació de la proposició (a & b) v (¬c) seria *False*, 
ja que aquest és el valor que s'obté en substituir a la proposició cada variable pel seu valor assignat.

En Haskell podem representar l'assignació d'un valor a una variable amb el tipus:
```haskell
data Assig = Nom :-> Bool deriving Show
```
i una assignació a diverses variables com una llista d'aquestes:
```haskell
tipus Assignacio = [Assig]
```
Així, l'assignació de variables anterior s'escriuria [ "a" :-> True, "b" :-> False, "c" :-> True ] en Haskell.

Defineix una funció `avaluar :: Prop -> Assignacio -> Bool` , de manera que avaluar 
`p s` retorni l'avaluació de la proposició *p* amb l'assignació de variables donada per *s*.
Per exemple:

```haskell
? avaluar e3 [ "a" :-> True, "b" :-> False, "c" :-> True ]
False :: Bool
? avaluar e3 [ "a" :-> True, "b" :-> True, "c" :-> True ]
True :: Bool
```
Suggeriment: pot ser útil definir primer una funció `valorDe :: Nom -> Assignacio -> Bool` , que retorni el valor d'una variable donada per una assignació.

```haskell
? valorDe "b" [ "a" :-> True, "b" :-> False, "c" :-> True ]
False :: Bool
```

### Exercici 2
Defineix una funció `variables :: Prop -> [Nom]`, que retorni una llista amb tots els noms de variable (sense repetir) que apareixen en una proposició. Per exemple:

```haskell
? variables e3
["a", "b", "c"] :: [Nom]
? variables e2
["a"] :: [Nom]
```
Per implementar la funció *variables* implementeu l'operador `+++` que concateni dues llistes sense repeticions,
per exemple: 
```haskell
*Main> [1,2,3]+++[2,3,4]
[1,2,3,4]
```
implementeu `+++` fent servir *foldr*. 
La funció que passeu al `foldr` ha de ser `+:`, que heu d'implementar, i que permet afegir un element al cap d'una llista només si no hi era.

**L'exemple anterior ha de donar el mateix resultat 
amb el mateix ordre.**

### Exercici 3
Per a una proposició amb *n* variables diferents existeixen *2^n* assignacions de valors possibles, 
ja que cada variable pot prendre dos valors (*True* o *False*). 
Per exemple, per a la proposició `Var "a" : \/ Var "b"` existeixen 4 assignacions possibles: 
`[a-> True, b-> True]`, `[a -> True, b-> False]`, 
`[a -> False, b -> True]` i `[a -> False, b -> False]`. 

Defineix una funció `assignacionsPossibles :: [Nom] -> [Assignacio]`, que retorni totes les assignacions possibles per a una llista de variables. Per exemple:

```haskell
? assignacionsPossibles [ "a" ]
[ [ "a" :-> True], [ "a" :-> False] ]
? assignacionsPossibles [ "a", "b" ]
[ [ "a" :-> True, "b" :-> True], [ "a" :-> True, "b" :-> False],
[ "a" :-> False, "b" :-> True], [ "a" :-> False, "b" :-> False] ]
```

**Heu de fer servir un `map`.**

### Exercici 4 

Es diu que una proposició és satisfactible si és possible trobar una assignació de variables 
per a la qual el valor de l'expressió sigui cert. Així, la proposició `e1` és satisfactible
ja que, per exemple, amb l'assignació de variables `[ "a" :-> True, "b" :-> True, "c" :-> True ]`
el valor de la proposició és *True*. 
Defineix una funció `esSatisfactible :: Prop -> Bool` que retorni *True* si la proposició
que pren com a paràmetre és satisfactible. Per exemple:

```haskell
? esSatisfactible e1
True :: Bool
? esSatisfactible e2
False :: Bool
```
Suggeriment: hauràs d'avaluar la proposició sota qualsevol assignació possible de variables
i veure si almenys una avaluació és certa. 

**Fes servir les funcions predefinides `map` i `or`**

### Exercici 5

Es diu que una proposició és una tautologia si, sota qualsevol assignació de variables 
possible, el seu valor és sempre cert. Un exemple de tautologia és l'expressió 
`Var "a" : \/ No (Var "a")`. Defineix una funció 
`esTautologia :: Prop -> Bool` que retorni *True* si la proposició 
que pren com a paràmetre és una tautologia. Per exemple:

```haskell
? esTautologia e3
False :: Bool
? esTautologia (Var "a" :\/ No (Var "a"))
True :: Bool
```

### Exercici 6

L'operador lògic implicació (escrit com *p1 -> p2*) denota que la proposició *p1* implica la
proposició *p2*. S'interpreta com una proposició que
serà certa si sempre que es compleix p1 es compleix p2. 
Una definició per a aquesta proposició d'acord amb la interpretació anterior és 
p1 -> p2 *equival a*  ¬(p1 v p2). Per tant, podem definir en Haskell el següent operador d'implicació:

```haskell
infixl 5 --> 
(-->) :: Prop -> Prop -> Prop
a --> b = No a :\/ b
```
Escriurem la conseqüència lògica entre p1 i p2 com a p1 => p2 (amb fletxa doble).
Això denota que la implicació p1 -> p2 és una tautologia, és a dir, és certa sota qualsevol 
assignació de variables. Completa la següent definició de l'operador (==>) que permeti 
comprovar conseqüències lògiques:

```haskell
infixl 5 ==>
(==>) :: Prop -> Prop -> Bool
a ==> b = ...
```
Per exemple:

```haskell
? Var "a" ==> Var "a" :\/ Var "b"
True :: Bool
? Var "c" ==> Var "a" :\/ Var "b"
False :: Bool
```

### Exercici 7
De la mateixa manera, completa la definició dels següents operadors per comprovar que dues proposicions són equivalents:

```haskell
infixl 4 <-->
(<-->) :: Prop -> Prop -> Prop
a <--> b = (a --> b) :/\ (b --> a)

infixl 4 <==>
(<==>) :: Prop -> Prop -> Bool
a <==> b = ...
```


Pots fer servir l'operador anterior per demostrar les següents equivalències lògiques i conseqüències lògiques:

- Doble negació: ¬(¬a) <=> a
- Llei de De Morgan: ¬(a & b) <=> ¬a v ¬b
- Llei de De Morgan: ¬(a v b) <=> ¬a & ¬b
- Demostració absurda: a -> b <=> ¬b -> ¬a
- Deducció: a & (a -> b) => b


### Exercici 8

Fes que els tipus de dades `Prop` i `Assig` siguin instància de la classe `Show` amb una implementació
personalitzada (sense el `deriving Show`). Així és com s'han de mostrar els exemples de proposicions que teniu:
```haskell
*Main> e1
(True /\ a)
*Main> e2
(a /\ !a)
*Main> e3
((a /\ b) \/ !c)
```
I així es mostren les assignacions:
```haskell
*Main> assignacionsPossibles ["a","b"]
[[a:=True,b:=True],[a:=True,b:=False],[a:=False,b:=True],[a:=False,b:=False]]

```
Fes que `Assig` també sigui instància de `Eq`. Després implementa la funció 
`assignacionsIguals :: Assignacio -> Assignacio -> Bool`. Dues assignacions són iguals si contenen el mateix conjunt de `Assig` (l'ordre no importa i les repeticions tampoc).

### Exercici 9
Fes una funció `sat::Prop->Maybe Assignacio` que no només diu si una proposició és satisfactible sinó que, en cas que ho sigui, 
retorna un *model* de la proposició (una assignació que la satisfà). En cas que tingui més d'un model, n'ha de
retornar un qualsevol.

```haskell
*Main> sat e1
Just [a:=True]
*Main> sat e2
Nothing
*Main> sat e3
Just [a:=True,b:=True,c:=True]
*Main>
```

### Exercici 10
Defineix el tipus de dades `WProp`:

```haskell
type Weight = Int
data WProp = Hard Prop | Soft Prop Weight
```

Aquest tipus distingeix entre proposicions *hard*, i proposicions *soft* amb un pes associat.
El problema MaxSAT consisteix en, donada una llista de WProp, determinar si hi ha alguna assignació que 
satisfaci totes les proposicions hard, i en cas que hi sigui, trobar-ne una que minimitzi la suma
de pesos de les proposicions soft falsificades.

Defineix la funció `maxSat::[WProp]->Maybe (Assignacio, Weight)`, que donada una llista `l`:
- Retorna `Nothing` si no hi ha cap assignació que satisfaci totes les proposicions hard de `l`.
- Retorna `Maybe a w` altrament, on:
  - `a` és una assignació que satisfà totes les proposicions hard de `l`
  - `w` és la suma dels pesos de les proposicions soft de `l` no satisfetes per `a`
  - no hi ha cap altra parell d'assignació i suma de pesos `(a',w')` que satisfacin els dos punts anteriors
  i  que `w'<w`.

Conjunts de proposicions d'exemple (**inclou també aquest codi a la teva solució**):
```haskell
me1, me2, me3, me4 :: [WProp]
me1=[Soft (Var "x") 10, Soft (No (Var "x")) 4]
me2=[Hard (Var "x"), Hard (Var "y"), Hard ((No (Var "x")) :\/ (No (Var "y")))]
me3=[Hard (Var "x"), Hard ((No (Var "x")) :\/ (No (Var "y"))),Soft (Var "x") 10, 
 Soft (No (Var "x")) 4, Soft (Var "y") 5, Soft (Var "z") 10, Soft (No (Var "z")) 4]
me4=[Soft ((No (Var "x")) :\/ (No (Var "y"))) 4, Soft ((Var "x") :\/ (Var "y")) 4, 
 Soft ((No (Var "x")) :\/ (No (Var "z"))) 3, Soft ((Var "x") :\/ (Var "z")) 3, 
 Soft ((No (Var "z")) :\/ (No (Var "y"))) 5, Soft ((Var "z") :\/ (Var "y")) 5]
```

Resultats de `maxSat` (l'assignació pot variar en diferents implementacions, però la suma de pesos no):
```haskell
*Main> maxSat me1
Just ([x:=True],4)
*Main> maxSat me2
Nothing
*Main> maxSat me3
Just ([x:=True,y:=False,z:=True],13)
*Main> maxSat me4
Just ([x:=False,z:=False,y:=True],3)
```

Fes `WProp` instància de `Show` per obtenir els següents resultats:
```haskell
*Main> me1
[(x,10),(!x,4)]
*Main> me2
[x,y,(!x \/ !y)]
*Main> me3
[x,(!x \/ !y),(x,10),(!x,4),(y,5),(z,10),(!z,4)]
*Main> me4
[((!x \/ !y),4),((x \/ y),4),((!x \/ !z),3),((x \/ z),3),((!z \/ !y),5),((z \/ y),5)]
```

## Procediment d'entrega
**Termini d'entrega:** 2 de juny

**Cal que feu les pràctiques en parelles**. Heu d'entregar pel Moodle un fitxer comprimit `Cognom1Nom1_Cognom2Nom2.zip`
que contingui:

- El codi Haskell, anomenat `prop.hs` . Aquest fitxer, independentment de quines part hàgiu implementat, **ha de compilar**. Si alguna part no compila, desactiveu-la amb comentaris. Cal que el nom de les funcions i tipus de dades demanats coincideixin **exactament** amb els de l'enunciat. Podeu copiar els exemples d'execució de l'enunciat per comprovar-ho.

- Un fitxer PDF anomenat `informe.pdf`, de no més d'una pàgina, que digui quines parts heu fet i quins problemes us heu trobat.

Possiblement es demani fer una entrega presencial de la pràctia.
