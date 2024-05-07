-- Exercici 1

infixl 2 -->

(-->) :: Bool -> Bool -> Bool
a --> b = not a || b

infixl 1 <-->
(<-->) :: Bool -> Bool -> Bool
(<-->) = (==)

-- Exercici 2
map2::(a->a->a) -> [a] -> [a] -> [a]
map2 _ _ [] = []
map2 _ [] _ = []
map2 f (x:xs) (y:ys) = (f x y):(map2 f xs ys)

sumallistes l1 l2 = map2 (\x y -> x+y) l1 l2
productellistes l1 l2 = map2 (*) l1 l2

--Exercici 3
maybeMap :: (a-> Maybe a) -> [a] -> [a]
maybeMap _ [] = []
maybeMap f (x:xs) = case (f x) of
 Just y -> y:rest
 Nothing -> rest
 where
  rest = maybeMap f xs

-- Alternativa fent servir map i filter amb instanciacio parcial
maybeMap2 :: (a-> Maybe a) -> [a] -> [a]
maybeMap2 f l = (map getJust . filter isJust . map f) l
 where 
 getJust (Just x) = x
 isJust (Nothing) = False
 isJust (Just _) = True