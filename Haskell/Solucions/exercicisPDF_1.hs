{- 
Exercici 1.1
-}
xorr :: Bool -> Bool -> Bool 
xorr True False = True
xorr False True = True
xorr _ _ = False

-- Exercici 1.2
xorr2 :: Bool -> Bool -> Bool
xorr2 a b = a == not b


--Exercici 1.3
maximo3 :: Integer -> Integer -> Integer -> Integer
maximo3 x y z 
 | x >= y && x >= z = x
 | y >= x && y >= z = y
 | otherwise = z

-- Exercici 1.4
max2 :: Integer -> Integer -> Integer
max2 x y
 | x >= y = x
 | otherwise = y

max3 :: Integer -> Integer -> Integer -> Integer
max3 x y z = max2 (max2 x y) z

max4 :: Integer -> Integer -> Integer -> Integer -> Integer
max4 a b c d = max2 (max2 a b) (max2 c d)

--Exercici 1.5
tresDiferentes :: Integer -> Integer -> Integer -> Bool
tresDiferentes a b c = a /=b && b/=c && a/=c

--Exercici 1.6
cuatroIguales :: Integer -> Integer -> Integer -> Integer -> Bool
cuatroIguales a b c d = a==b && b==c && c==d

-- Exercici 1.7
media3 :: Double -> Double -> Double -> Double
media3 a b c = (a+b+c)/3


--Versio 1: casuistica de if-then-else
cuantosSobreMedia3 :: Double -> Double -> Double -> Integer
cuantosSobreMedia3 a b c = 
 if a > media then 
  if bSobre || cSobre then 2 else 1
 else
  if bSobre && cSobre
   then 2
   else 
    if bSobre || cSobre then 1 else 0
 where
  media = media3 a b c
  bSobre = b > media
  cSobre = c > media

--Versio 2: fem servir una funcio auxiliar boolToInt
cuantosSobreMedia3_2 a b c = (boolToInt (a>m)) + (boolToInt (b>m)) + (boolToInt (c>m))
 where 
  m = (media3 a b c)
  boolToInt b = if b then 1 else 0


--Exercici 1.8
producto :: Integer -> Integer -> Integer
producto a b
 | a > 0 = b + (producto (a-1) b)
 | a < 0 = - (producto (-a) b)
 | otherwise = 0 -- En aquest cas a == 0

-- Exercici 1.9
raiz :: Integer -> Integer
raiz x 
 | x < 0 = error "No te arrel real"
 | otherwise = buscarDesde 0 x


buscarDesde :: Integer -> Integer -> Integer
buscarDesde i n 
 | (i+1)*(i+1) > n = i
 | otherwise = buscarDesde (i+1) n

-- Exercici 1.10
pot2 :: Integer -> Integer
pot2 0 = 1
pot2 x 
 | (x `mod` 2) == 0 =  v2m * v2m
 | otherwise = 2 * v2m * v2m
  where
   m = x `div` 2
   v2m = pot2 m
