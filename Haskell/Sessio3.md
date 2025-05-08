# Sessió 3

## Rangs

Els rangs són una manera de construir llistes que són seqüències aritmètiques d’elements que es poden enumerar.

```haskell
GHCi> [1..20]
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
GHCi> ['a'..'z']
"abcdefghijklmnopqrstuvwxyz"
GHCi> ['K'..'Z']
"KLMNOPQRSTUVWXYZ"
```

Els rangs suporten un pas diferent de 1.

```haskell
GHCi> [2,4..20]
[2,4,6,8,10,12,14,16,18,20]
GHCi> [3,6..20]
[3,6,9,12,15,18]
```

L'enumeració també pot ser decreixent.

```haskell
GHCi> [20,19..0]
[20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
GHCi> [20,18..0]
[20,18,16,14,12,10,8,6,4,2,0]
```

## Llistes per comprensió

Les llistes per comprensió són una variant en forma de llista dels conjunts per comprensió, 
que és una sintaxi utilitzada en matemàtiques per generar un conjunt a partir d’un altre conjunt original.

El següent exemple mostra la sintaxi d'un conjunt per comprensió:

![setnotation](Img/setnotation.png)

- La part anterior a la barra vertical és la funció de sortida.
- `x` és una variable que prendrà, un per un, els valors de conjunt original `N`
- `x <= 10` és un predicat

Aquesta expressió matemàtica genera un conjunt que conté el doble de tots els naturals més petits o iguals que 10.



Les llistes per comprensió segueixen una sintaxi similar que els conjunts, però preserven l'ordre de l'enumeració. En podem trobar en diferents llenguatges,  no només Haskell.


Suposem que volem una comprensió que substitueixi
cada nombre senar més gran que 10 per "BANG!"
i cada nombre senar menor que 10 per "BOOM!".
Si un nombre no és senar, el descartem de la nostra llista. En Haskell ho farem així:

```haskell
GHCi> boomBangs xs = [if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]
GHCi> boomBangs [1..20]
["BOOM!","BOOM!","BOOM!","BOOM!","BOOM!","BANG!","BANG!","BANG!","BANG!","BANG!"]
```

Podem incloure diversos predicats.
Si volguéssim tots els nombres del 10 al 20 que no són el 13, 15 o 19, faríem:



```haskell
GHCi> [x*2 | x <- [10..20], x \= 13, x \= 15, x \= 19]
[20,22,24,28,32,34,36,40]
```

No només podem tenir diversos predicats en una llista per comprensió,
també podem extreure elements de diverses llistes.
Quan n'extraiem de més d'una llista,
es generen totes les combinacions possibles entre elements de les llistes donades
i es poden utilitzar a la funció de sortida que proporcionem.


```haskell
GHCi> [x*y | x <- [2,5,10], y <- [8,10,11]]
[16,20,22,40,50,55,80,100,110]
GHCi> [(x,y) | x <- [2,5,10], y <- [8,10,11]]
[(2,8),(2,10),(2,11),(5,8),(5,10),(5,11),(10,8),(10,10),(10,11)]
```

## Folding

### Foldr

Considereu les funcions següents:
```haskell
--sumatori l = suma dels elements de l
sumatori :: Num a => [a] -> a
sumatori [] = 0
sumatori (x:xs) = x + sumatori xs

--producte l = producte dels elements de l
producte :: Num a => [a] -> a
producte [] = 1
producte (x:xs) = x * producte xs

--llargada l = llargada de l
llargada :: [a] -> Integer
llargada [] = 0
llargada (_:xs) = 1 + llargada xs


--comptar x l = nombre de vegades que x apareix a l
comptar :: Eq a => a -> [a] -> Integer
comptar _ [] = 0
comptar x (y:ys) = (if x == y then 1 else 0) + comptar x ys
```

Semblantment a com vam veure amb les funcions que es poden implementar amb `filter`, totes segueixen un patró: efectuen una operació sobre una llista, si la llista és buida retornen una constant (l'*element neutre*), altrament combinen el primer element amb el resultat d'efectuar l'operació sobre la resta d'elements. En certa manera, *pleguen* (fold) els elements d'una llista.


Haskell té les funcions d'ordre superior incorporades `foldr` i `foldl`, que pertanyen a la classe `Foldable`. En el cas de llistes, la funció `foldr` generalitza totes les que acabem de veure:

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr _ y []     = y
foldr f y (x:xs) = f x (foldr f y xs)
```

La lectura dels paràmetres és la següent:
* El primer paràmetre és una funció que combina el retorn de la crida recursiva amb el primer element de la llista.
* El segon paràmetre és l'element neutre, és a dir, què retorna la nostra operació si s'efectua sobre una llista buida.

### Foldl

De vegades ens pot interessar a plegar la llista per l'esquerra, és a dir,
el primer element que es processa és el cap de la llista. En aquest cas, farem servir `foldl`.

La seva definició per llistes és la següent `foldl`.

```haskell
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl _ y []     = y
foldl f y (x:xs) = foldl f (f y x) xs
```
Fixeu-vos en la diferència en l'ordre d'execució:

```haskell
GHCi> -- foldr :: (a -> b -> b) -> b -> [a] -> b
GHCi> foldr (\x acc -> x + acc) 0 [1,2,3]  ==>  1+(2+(3+0))
GHCi> -- foldl :: (b -> a -> b) -> b -> [a] -> b
GHCi> foldl (\acc x -> acc + x) 0 [1,2,3]  ==>  ((0+1)+2)+3
```
