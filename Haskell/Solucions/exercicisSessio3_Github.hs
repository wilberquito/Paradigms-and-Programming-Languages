-- Exercici 1
joinToLength :: Int -> [String] -> [String]
joinToLength x l = [s1++s2| s1 <- l, s2 <- l, length s1 + length s2 == x]


-- Exerici2
sumSuccess ::  [Either String Int] -> (Either String Int)
sumSuccess l = foldr sumaDades (Left "No data") l where
 sumaDades (Left _) d = d
 sumaDades (Right x) (Left _) = Right x
 sumaDades (Right x) (Right y) = Right (x+y)

-- Exercici 3
multiCompose :: [a->a] -> (a->a)
multiCompose l = foldr (.) id l

-- Exercici 4

data Distance = Distance Double
  deriving (Show,Eq)

data Time = Time Double
  deriving (Show,Eq)

data Velocity = Velocity Double
  deriving (Show,Eq)

-- velocity computes a velocity given a distance and a time
velocity :: Distance -> Time -> Velocity
velocity (Distance d) (Time t) = Velocity (d/t)

-- travel computes a distance given a velocity and a time
travel :: Velocity -> Time -> Distance
travel (Velocity v) (Time t) = Distance (v*t)


-- Exercici 5
data Operation =  Add Int Int
                | Subtract Int Int
                | Multiply Int Int
  deriving Show

class Calculator a where
 compute::a -> Int
 show'::a -> String


instance Calculator Operation where
 compute (Add x y) = x + y
 compute (Subtract x y) = x-y
 compute (Multiply x y) = x*y
 show' (Add x y) = show x ++ "+" ++ show y
 show' (Subtract x y) = show x ++ "-" ++ show y
 show' (Multiply x y) = show x ++ "*" ++ show y



