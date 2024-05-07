--Exercici 2.1
opera::(a->a->a)->[a]->a
opera _ [] = error "Llista buida"
opera _ [x] = x
opera f (x:xs) = f x (opera f xs)

--Exercici 2.2
opera2::(a->a->a)->[a]->[a]
opera2 _ [] = []
opera2 _ [_] = error "Nombre d'elements senar"
opera2 f (x:y:xs) = f x y : opera2 f xs

--Exercici 2.3
filtra:: (Integer -> Bool) -> [Integer] -> [Integer]
filtra _ [] = []
filtra f (x:xs) = if f x then (x:altres) else altres
 where altres = filtra f xs

--Exercici 2.4
rechaza::(Integer -> Bool) -> [Integer] -> [Integer]
rechaza f l = filtra (not.f) l

--Exercici 2.5
divideA::Integer->Integer->Bool
divideA x 0 = False
divideA x y = (x `mod` y) == 0

--Exercici 2.6
divisores::Integer->[Integer]
divisores x = filtra (divideA x) [1..x]

--Exercici 2.7
mcd::Integer->Integer->Integer
mcd 0 x = x
mcd x 0 = 0
mcd x y
 | x >= y = mcd (x-y) y
 | otherwise = mcd (y-x) x











