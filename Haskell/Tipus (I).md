# More about types


## Our own types

So far, we've run into a lot of data types. `Bool`, `Int`, `Char`, `Maybe`, etc.
But how do we make our own? Well, one way is to use the `data` keyword to define a type.

```haskell
data Point = Point Float Float
    deriving Show

data Shape = Circle Point Float | Rectangle Point Point
    deriving Show
```

The keyword `data` means that we're defining a new data type.

- The part before the `=` denotes the **type**.
- The parts after the `=` are **value constructors**.
- The keyword `deriving` is used to automatically generate instances of certain type class (being instance of the typeclass `Show` allows the type to being show in your screen).

> The `Shape` type has two value constuctors `Circle` and `Rectangle`. Whereas the type `Point` has only one value constructor `Point`.

We can ask `ghci` the type of value constructors.

```haskell
ghci> :t Point
Point :: Float -> Float -> Point
ghci> :t Circle
Circle :: Point -> Float -> Shape
ghci> :t Rectangle
Rectangle :: Point -> Point -> Shape
```

We can also do pattern matching on value constructors.

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

We can define a `Rational` number as:

```haskell
data Rational = Pair Integer Integerderiving Show
```

among other operations, the multiplication of rationals makes sense. We do
it by defining the multiplication through an operator.

```haskell
infixl 7 >*<
(>*<) :: Rational -> Rational -> Rational
(Pair a b) >*< (Pair c d) = Pair (a * c) (b * d)
```

And now we multiply two rationals.

```haskell
ghci> Pair 2 2 >*< Pair 3 4
Pair 6 8
```

If the data constructor is binary it's name can be symbolic.
But the symbolic constructor must start with `(:)`, and the
constructor is written infix.

> Do you remember the `:` data constructor of lists?

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
ghci> 2 :/ 2 >*< 3 :/ 4
6 :/ 8
```

### Recursive types

A constructor in an algebraic data type might have several fields and each field must be of some concrete type.
With that in mind, we can make types which constructors have fields that are of the same type.

> A recursive data type is a type in which at least one value contains another value of the same type, which may in turn contain additional values of that type, and so on indefinitely.

Naturals can be represented by a recurive data type.

```haskell
data Nat = Zero | Suc Nat
  deriving Show
```

Operations over `Nat`:

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

## Parametric polymorphic types

### Trees

If you'd want to construct a binary tree to store string, you could imagine doing something like:

```haskell
data S_Tree = S_Leaf String | S_Branch String S_Tree S_Tree
```

But! What if we also wanted to be able to store Bool,
we'd have to create a new binary tree. It could look something like this:

```haskell
data B_Tree = B_Leaf Bool | B_Branch Bool B_Tree B_Tree
```

Both `S_Tree` and `B_Tree` are type constructors. But there's a glaring problem. Do you see how similar they are? It seems like
a tree should work regardless of the type it "wraps".

We can define a tree as parametric polymorphic type.

```haskell
data Tree a = Leaf a | Branch a (Tree a) (Tree a)
```

> `Tree` is a type constructor and it uses a type variable `a` as argument for constructing a type `Tree a`.

**`Tree` itself is not a concrete type - it is a type constructor of kind:**

```haskell
ghci> :info Tree
Tree :: * -> *  
```

### Lists

List are actually defined as recursive parametric polymorphic types.

```haskell
data List a = Null | Const a (List a)
    deriving Show
```

- `List a` is a type
- `List` is a type constructor (as it requires a type variable for defining an actual type)
- `Null` and `Const a (List a)` are value constructors of type `List a`.

### Maybe

```haskell
ghci> :info Maybe
type Maybe :: * -> *
data Maybe a = Nothing | Just a
```

The `Maybe` type constructor allows us to represent values that may or may not be present.

The `Maybe` type constructor has two value constructor:

- `Just a`: a value of type `a` is present.
- `Nothing`: there is nothing present.


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

### Either

The `Either` type constructor is used to create a new type that
represents the union of other two types.

```haskell
ghci> :info Either
type Either :: * -> * -> *
data Either a b = Left a | Right b
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

## When not to use parametric polymorphic types

Using type parameters
is very beneficial but only when using them makes sense. It makes sense when the data type works regardless of the type of the value it holds.

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

The types `[Char]` and `String` are equivalent and interchangeable.
That's implemented with _type synonyms_. Type synonyms don't really do anything _per se_,
they're just about giving some types different names so that they make more sense
to someone reading our code and documentation.


```haskell
type String = [Char]
```

Type synonyms can also be parameterized by type variables:

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
