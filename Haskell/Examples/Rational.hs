-- data MyRational = Pair Integer Integer
--   deriving Show
--
-- infixl 7 >*<
-- (>*<) :: MyRational -> MyRational -> MyRational
-- (Pair a b) >*< (Pair c d) = Pair (a * c) (b * d)
--


infix 9 :/
data MyRational = Integer :/ Integer
  deriving Show

infixl 7 >*<
(>*<) :: MyRational -> MyRational -> MyRational
(a :/ b) >*< (c :/ d) = (a * c) :/ (b * d)
