----------------- Practica 3 ----------------
data Nat = Cero | Suc Nat deriving Show


-- 3.1 --
instance Eq Nat where
 (==) Cero Cero = True
 (==) (Suc _) Cero = False
 (==) Cero (Suc _) = False
 (==) (Suc x) (Suc y) = x == y

-- 3.2 -- 
instance Ord Nat where
 Cero <= _ = True
 (Suc _) <= Cero = False
 (Suc x) <= (Suc y) = x<=y

-- 3.3 --
instance Num Nat where
 Cero + x = x
 x + Cero = x
 (Suc x) + y = Suc (x+y)
 
 Cero * _ = Cero
 _ * Cero = Cero
 (Suc x) * y = y + x*y

 abs x = x

 signum Cero = Cero
 signum _ = Suc Cero
 
 fromInteger x
  | x < 0 = error "Els naturals no poden representar negatius"
  | x == 0 = Cero
  | otherwise = Suc (fromInteger (x-1))
  
 negate Cero = Cero 
 negate x = error "No es pot negar un natural"
 
instance Enum Nat where
 toEnum x
  | x < 0 = error "Els naturals no poden representar negatius"
  | x == 0 = Cero
  | otherwise = Suc (toEnum (x-1))
 
 fromEnum Cero = 0
 fromEnum (Suc x) = 1 + (fromEnum x)
 
instance Real Nat
 
instance Integral Nat where
 toInteger = toInteger.fromEnum
 
 divMod _ Cero = error "Divisio per zero"
 divMod Cero _ = (Cero, Cero)
 divMod x y = (fromInteger(xI `div` yI),fromInteger(xI `mod` yI)) where
  xI = toInteger x
  yI = toInteger y
  

