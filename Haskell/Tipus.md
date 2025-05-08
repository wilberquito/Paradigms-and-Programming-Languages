
## Our own types

So far, we've run into a lot of data types. Bool, Int, Char, Maybe, etc.
But how do we make our own? Well, one way is to use the data keyword to define a type.

```haskell
data Point = Point Float Float
    deriving Show
data Shape = Circle Point Float | Rectangle Point Point
    deriving Show
```

The keyword `data` means that we're defining a new data type.
The part before the `=` denotes the **type**.
The parts after the `=` are **value constructors**.

The keyword `deriving` is used to automatically generate instances of certain type class.
Being instance of the typeclass `Show` allows the type to being show in your screen.

The `Shape` type has two value constuctors `Circle` which has tree arguments
and `Rectangle` that has four arguments.

We can ask `ghci` the type of value constructors.

Example:

```haskell
GHCi> :t Point
Point :: Float -> Float -> Point
GHCi> :t Circle
Circle :: Point -> Float -> Shape
GHCi> :t Rectangle
Rectangle :: Point -> Point -> Shape
```

We can also do pattern matching on value constructors.

Example:

```haskell
surface :: Shape -> Float
surface (Circle _ r) = pi * r ^ 2
surface (Rectangle (Point x1 y1) (Point x2 y2)) = (abs $ x2 - x1) * (abs $ y2 - y1)
```

Here is an other example with the predifined `Bool` type.

```haskell
data Bool = False | True deriving (Show, . . .)

infixr 3 &&
(&&) :: Bool -> Bool -> Bool
False && x  = False
True && x   = x

infixr 2 ||
( || ) :: Bool -> Bool -> Bool
False || x  = x
True || x   = True
```

### Symbolic value constructor

Imagine we have the type `Rational` defined as:

```haskell
data Rational = Pair Integer Integer
  deriving Show
```

and we want to define some behavior for this type,
for example, the multiplication. To do it, we create
an operator that multiplies two Rationals.

```haskell
infixl 7 >*<
(>*<) :: Rational -> Rational -> Rational
(Pair a b) >*< (Pair c d) = Pair (a * c) (b * d)
```

And now we multiply two Rationals.

```haskell
GHCi> Pair 2 2 >*< Pair 3 4
Pair 6 8
```

But if the data constructor is binary it's name can be symbolic.
But the symbolic constructor must start with `(:)`, and the
constructor is written infix.


```haskell
infix 9 :/
data Rational = Integer :/ Integer
  deriving Show
```

We adjust now the operator `>*<` for the new data constructor as:


```haskell
infixl 7 >*<
(>*<) :: Rational -> Rational -> Rational
(a :/ b) >*< (c :/ d) = (a * c) :/ (b * d)
```

And now we can multiply two Rationals in an "easer" way.

```haskell
GHCi> 2 :/ 2 >*< 3 :/ 4
6 :/ 8
```

### Recursive types

As we've seen, a constructor in an algebraic data type
can have several (or none at all) fields and each field must be of some concrete type.
With that in mind, we can make types whose constructors have fields that are of the same type!
Using that, we can create recursive data types,
where one value of some type contains values of that type, which in turn
contain more values of the same type and so on.

Naturals can be represented by a recurive data type.

```haskell
data Nat = Zero | Suc Nat
  deriving Show
```

Example:

```haskell
isEven :: Nat -> Bool
isEven Zero     = True
isEven (Suc n)  = not (isEven n)

-- (n + 1) + m = (n + m) + 1
infixl 6 <+>
(<+>) :: Nat -> Nat -> Nat
Zero <+> m    = m
(Suc n) <+> m = Suc (n <+> m)

-- (n + 1) * m = n * m + m
infixl 7 <*>
(<*>) :: Nat -> Nat -> Nat
Zero <*> m    = Zero
(Suc n) <*> m = n <*> m <+> m
```

### Polymorphic type constructor

If you'd want to construct a binary tree to store Strings, you could imagine doing something like

```haskell
data SBTree = Leaf String
            | Branch String SBTree SBTree
```

But! What if we also wanted to be able to store Bool,
we'd have to create a new binary tree. It could look something like this:

```haskell
data BBTree = Leaf Bool
            | Branch Bool BBTree BBTree
```

Both SBTree and BBTree are type constructors. But there's a glaring problem.
Do you see how similar they are?
That's a sign that you really want a parameter somewhere.

So we can do this:

```haskell
data BTree a = Leaf a
             | Branch a (BTree a) (BTree a)
```

Now we introduce a type variable a as a parameter to the type constructor.
In this declaration, BTree has become a function. It takes a type as its argument and it returns a new type.

```haskell
BTree :: * -> *
```

#### The Maybe type constructor

```haskell
data Maybe a = Nothing | Just a
  deriving Show
```

The `Maybe` type constructor allows us to represent
values that may or may not be present.

The `a` here is the type parameter. And because there's a type parameter involved,
we call `Maybe` a type constructor.
Depending on what we want this data type to hold when it's not Nothing

So if we pass `Char` as the type parameter to `Maybe`, we get a type of `Maybe Char`.
The value `Just 'a'` has a type of `Maybe Char`.

Example:

```haskell
GHCi> Just "Haha"
Just "Haha"
GHCi> Just 84
Just 84
GHCi> :t Just "Haha"
Just "Haha" :: Maybe [Char]
GHCi> :t Just 84
Just 84 :: (Num t) => Maybe t
GHCi> :t Nothing
Nothing :: Maybe a
GHCi> Just 10 :: Maybe Double
Just 10.0
```

#### The Either type constructor

The `Either` type constructor is used to create a new type that
represents the union of other two types.

```haskell
data Either a b = Left a | Right b
  deriving Show
```

Example:

```haskell
l1 :: [Either Integer Bool]
l1 = [Left 1, Right True, Left 3, Left 5]
l2 :: [Either Bool Integer ]
l2 = [Rigth 2, Left False, Right 5]
```

```haskell
GHCi> :t l1
l1 :: [Either Integer Bool]
GHCi> Right 20
Right 20
GHCi> Left "w00t"
Left "w00t"
GHCi> :t Right 'a'
Right 'a' :: Either a Char
GHCi> :t Left True
Left True :: Either Bool b
```

#### When not to use polymorphic types

Using type parameters
is very beneficial, but only when using them makes sense.
sually we use them when our data type would work regardless
of the type of the value it then holds inside it.

We could change the `Car` type definition from this:

```haskell
data Car = Car { company    :: String
               , model      :: String
               , year       :: Int
               } deriving (Show)
```

to this:

```haskell
data Car a b c = Car { company  :: a
                     , model    :: b
                     , year     :: c
                     } deriving (Show)
```

Would we really benefit? probably no... because we may just end using functions
that work on `Car String String Int` type.

## Type synonyms

Previously, we mentioned that when writing types, the [Char] and String types are equivalent and interchangeable.
That's implemented with type synonyms. Type synonyms don't really do anything per se,
they're just about giving some types different names so that they make more sense
to someone reading our code and documentation.

Example:

```haskell
type String = [Char]
```

Type synonyms can also be parameterized. If we want a type that represents an association
list type but still want it to be general so it can use any type as the keys and values,
we can do this:

```haskell
type AssocList k v = [(k,v)]
```


## Your time to practice


```haskell
-- Exercise: you'll find below the types Time, Distance and Velocity,
-- which represent time, distance and velocity in seconds, meters and
-- meters per second.
--
-- Implement the functions below.

data Distance = Distance Double
  deriving (Show,Eq)

data Time = Time Double
  deriving (Show,Eq)

data Velocity = Velocity Double
  deriving (Show,Eq)

-- velocity computes a velocity given a distance and a time
velocity :: Distance -> Time -> Velocity
velocity = undefined

-- travel computes a distance given a velocity and a time
travel :: Velocity -> Time -> Distance
travel = undefined
```
