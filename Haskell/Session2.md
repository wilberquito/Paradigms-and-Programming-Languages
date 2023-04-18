# Session 2

## Higher order functions

Functions can take functions as parameters and also return functions.
They are useful because they allow capturing general computational schemes (abstraction).

Example:

```haskell
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)
```

Notice the type declaration. In the majority of cases we don't need parentheses because
`->` is naturally right-associative. However here, they are mandatory.
They indicate that the first parameter is a function that takes something and returns that same thing.

The first parameter is a function (of type `a -> a`) and the second is that same `a`.
The function can also be `Int -> Int` or `String -> String` or whatever.
But then, the second parameter to also has to be of that type.


## Lambdas

Lambdas are basically anonymous functions that are used because we need some functions only once.
Normally, we make a lambda with the sole purpose of passing it to a higher-order function.
We usually surround them by parentheses, because otherwise they extend all the way to the right.

Example:

```haskell
GHCi> :t (\x -> x+1)
(\x -> x+1) :: Num a => a -> a
GHCi> (\x -> x+1) 10
11
```

You can create functions with more than one argument using lambda functions.

Example:

```haskell
GHCi> :t (\x y -> x+y)
(\x y -> x+y) :: Num a => a -> a -> a
GHCi> (\x y -> x+y) 1 2
3
GHCi>
```

Using lambda functions with higher-order functions.

Example:

```haskell
GHCi> applyTwice f x = f (f x)
GHCi> :t applyTwice
applyTwice :: (a -> a) -> a -> a
GHCi> applyTwice (\x -> x+1) 1
3
```

## Partial application

If `f` is a function of `n` arguments and it is
apply `k ≤ n` arguments with the appropriate types, the result is obtained
a new function that waits for the remaining `n − k` arguments.

Example:

```haskell
fun :: Int -> Int -> Int
fun x y z = x*(2*y + z)
```

![Partial application example](./Img/partial-aplication.png)

## Operators

Operators are functions of two arguments with a symbolic name.
They are usually used in infix mode.

Example:

```haskell
GHCi> 1 + 2
3
```

But you can use them between parentheses.

Example:

```haskell
GHCi> (+) 1 2
3
```

A function with two arguments can be used in infix mode.

```haskell
GHCi> 10 `div` 3
3
```

To define operators you can use any or more than:

```haskell
: ! # $ % & ∗ + . / < = > ? @ \ ∧ | − ∼
```

An operator has it's own priority. The priority goes from `0` to `9`. The greater the number
the greater the priority.

As well has operators has it's priority, it also has it's own asociativity. Left asociativity `infixl`,
right asociativity `infixr` or none `infix`.

Here you can see the GHCi operators definition.

```haskell
infixr 9 .
infixl 9 !!
infixr 8 ∧, ∧∧, ∗∗
infixl 7 ∗, /, ‘quot‘, ‘rem‘, ‘div‘, ‘mod‘
infixl 6 +, −
infixr 5 :
infixr 5 ++
infix  4 ==, /=, <, <=, >=, >, ‘elem‘, ‘notElem‘
infixr 3 &&
infixr 2 ||
infixl 1 >>, >>=
infixr 1 =<<
infixr 0 $, $!, ‘seq‘
```

We can create our own operators. Imagine we want to create the or exclusive operator.

Example:

```haskell
-- Define the type of asociativity and the priority
infixr 2 |||

(|||) :: Bool -> Bool -> Bool
True ||| True   = False
False ||| False = False
_ ||| _         = False
```

Finally, binary operators have sections. Sections are partially applied operators.
The section of an operator is obtained by writing the
operator and one of its arguments in parentheses. We obtein functions of one argument.

If (✶) is an operator, we have the following equivalences.

```haskell
(x ✶) ===> \y -> x ✶ y
(✶ y) ===> \x -> x ✶ y
(✶)   ===> \x y -> x ✶ y
```

Example:

```haskell
GHCi> applyTwice f x = f (f x)
GHCi> :t applyTwice
applyTwice :: (a -> a) -> a -> a
GHCi> applyTwice (\x -> x+1) 1
3
GHCi> applyTwice (+1) 1
3
```

## Capture of computation with higher-order functions

A lot of function that works with numbers follow this scheme:

- Base case: they return a base value
- Recursive step: you compute the `n` step from the `n-1` step

Example:

```haskell
factorial :: Integer -> Integer
factorial 0 = 1
factorial m = let n = m-1
              in m * factorial n

sumatorio :: Integer -> Integer
sumatorio 0 = 0
sumatorio m = let n = m-1
              in (+) m (sumatorio n)
```

Both functions follows the scheme:

```haskell
fun :: Integer -> Integer
fun 0 = ☆
fun ◊ = let n = m-1
        in ◊ m (fun n)
```

From this we can create a higher-order function that capture the compute as follow:

```haskell
iter :: (Integer -> Integer -> Integer) ->
        Integer -> Integer -> Integer
iter f e = fun
  where
    fun :: Integer -> Integer
    fun 0 = e
    fun m = let n = m-1
            in f m (fun n)
```

Thanks to capture the pattern into a function, we can define the previous functions more compact.

```haskell
factorial' :: Integer -> Integer
factorial = iter (*) 1

sumatorio' :: Integer -> Integer
sumatorio' = iter (+) 0
```

## Polymorphism

Polymorphism refers to the phenomenon of something taking many forms.

### The indentity function

```haskell
id :: a -> a
id x = x
```

The identity function just returns its argument.

```haskell
GHCi> id 'd'
'd'
GHCi> id [1,2,0]
[1,2,0]
```

The function seems a bit useless, but sometimes with higher-order functions
it’s useful to have a function that does nothing.

```haskell
GHCi> filter id [True, False, True]
[True, True]
```

### Tuples

The functions `fst` and `snd` allows us to get components of tuples of pairs.

Examples:

```haskell
GHCi> fst (8,11)
8
GHCi> fst ("Wow", False)
"Wow"
GHCi> snd (8,11)
11
GHCi> snd ("Wow", False)
False
GHCi> snd ("Wow", False)
False
```
Here you can notice that it's used two type variables. This mean
that the type of each component can be different, but it's not mandatory.

```haskell
:t fst
fst :: (a, b) -> a
:t snd
snd :: (a, b) -> b
```

Although you can create tuples of any number of components,
the functions `fst` and `snd` only operates on pairs.

```haskell
GHCi> fst (1, True, "Eeeh")
<interactive>:8:5: error:
    • Couldn't match expected type ‘(a, b0)’
                  with actual type ‘(a0, Bool, [Char])’
    • In the first argument of ‘fst’, namely ‘(1, True, "Eeeh")’
      In the expression: fst (1, True, "Eeeh")
      In an equation for ‘it’: it = fst (1, True, "Eeeh")
    • Relevant bindings include it :: a (bound at <interactive>:8:1)
```

### Lists

Let's see some function defined on a list of any type.
The function is defined at such a high level of abstraction that the precise input type
simply never comes into play, yet the result is of a particular type (sometimes).

#### Length

```haskell
length' :: [a] -> Int
length' []      = 0
length' (x:xs)  = 1 + length xs
```

The length function exhibits parametric polymorphism because it acts
uniformly on a range of types that share a common structure, in this case, lists.

```haskell
GHCi> :t length' [1,2,3,4,5]
length' [1,2,3,4,5] :: Int
GHCi> :t length' ['1','2','3','4','5']
length' ['1','2','3','4','5'] :: Int
```

#### Head

To get the first element of a list you can use the `head` function.

```haskell
head :: [a] -> a
head (x:_) = x
```

```haskell
GHCi> head ["hello", "world", "!"]
"hello"
GHCi> head []
*** Exception: Prelude.head: empty list
```

#### Tail

To get the tail of the list you can use the function `tail`.

```haskell
tail :: [a] -> [a]
tail (_:xs) = xs
```

```haskell
GHCi> tail ["hello", "world", "!"]
["world", "!"]
GHCi> tail []
*** Exception: Prelude.tail: empty list
```

#### Last

To get the last element of a list, you can use the function `last`.

```haskell
last :: [a] -> a
last [x]    = x
last (_:xs) = last xs
```

```haskell
GHCi> last ["hello", "world", "!"]
"!"
GHCi> last []
*** Exception: Prelude.last: empty list
```

To get all elements except the last one, you can use the function `init`.

```haskell
init :: [a] -> [a]
init [x]    = []
init (x:xs) = x : init xs
```

```haskell
GHCi> init ["hello", "world", "!"]
["hello", "world"]
GHCi> init []
*** Exception: Prelude.tail: empty list
```

#### Concatenation

You can concatenate lists using the operator `++`.

```haskell
infix 5 ++
(++) :: [a] -> [a]
[] ++ ys      = ys
(x:xs) ++ ys  = x : (xs ++ ys)
```

#### Association

To produce a new list from a list, you can use the `map` function that takes a function as it's first argument
and a list and applies that function to every element in the list,
producing a new list.

```haskell
map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (x:xs) = f x : map f xs
```

```haskell
GHCi> map (+3) [1,5,3,1,6]
[4,8,6,4,9]
GHCi> map (++ "!") ["BIFF", "BANG", "POW"]
["BIFF!","BANG!","POW!"]
GHCi> map (replicate 3) [3..6]
[[3,3,3],[4,4,4],[5,5,5],[6,6,6]]
GHCi> map (map (^2)) [[1,2],[3,4,5,6],[7,8]]
[[1,4],[9,16,25,36],[49,64]]
GHCi> map fst [(1,2),(3,5),(6,3),(2,6),(2,5)]
[1,3,6,2,2]
```

#### Filters

`filter` is a function that takes a predicate (a predicate is a function that
tells whether something is true or not)
and a list and then returns the list of elements that satisfy the predicate.

```haskell
filter :: (a -> Bool) -> [a] -> [a]
filter _ [] = []
filter p (x:xs)
    | p x       = x : filter p xs
    | otherwise = filter p xs
```

```haskell
GHCi> filter (>3) [1,5,3,2,1,6,4,3,2,1]
[5,6,4]
GHCi> filter (==3) [1,2,3,4,5]
[3]
GHCi> filter even [1..10]
[2,4,6,8,10]
GHCi> let notNull x = not (null x) in filter notNull [[1,2,3],[],[3,4,5],[2,2],[],[],[]]
[[1,2,3],[3,4,5],[2,2]]
GHCi> filter (`elem` ['a'..'z']) "u LaUgH aT mE BeCaUsE I aM diFfeRent"
```

> By the way, which type do you thing the expression
`let notNull x = not (null x) in filter notNull [[1,2,3],[],[3,4,5],[2,2],[],[],[]]` has?

## Function application with $ operator

```haskell
infixr 0 $
($) :: (a -> b) -> a -> b
f $ x = f x
```

It's just function application... Well, almost,
but not quite! Whereas normal function application
(putting a space between two things) has a really high precedence,
the `$` function has the lowest precedence.

Function application with space, is left-associative meanwhile function
application with `$` is right-associative.

For example, what if I want to compute the `sqrt` of `3 + 4 + 9`, we can't
write `sqrt 3 + 4 + 9` because `sqrt` would be applied to the first argument
which is 3. We could have write `sqrt (3 + 4 +9)` or if we use `$` we can
write it like `sqrt $ 3 + 4 + 9`.

Appart from getting rid of parentheses, `$` means that function application can be
treated just like another function.


```haskell
GHCi> map ($ 3) [(4+), (10*), (^2), sqrt]
[7.0,30.0,9.0,1.7320508075688772]
```

## Function composition

In mathematics, function composition is defined like this:
`(fℴg)(x) = f(g(x))`, meaning that composing two functions
produces a new function that, when called with a parameter,
say `x`, is the equivalent of calling `g` with the parameter `x`
and then calling `f` with that result.

In Haskell function composition is denoted with `.`.

```haskell
infixr 9 .
(.) :: (b -> c) -> (a -> b) -> a -> c
f . g = \x -> f (g x)
```

- The result of composing `f` and `g` is another function `f.g :: a -> c`
- The type result of `g` must match with the input type of `f`, otherwise composition fails.

Example:

```haskell
GHCi> map (\x -> negate (abs x)) [5,-3,-6,7,-3,2,-19,24]
[-5,-3,-6,-7,-3,-2,-19,-24]
GHCi> map (negate . abs) [5,-3,-6,7,-3,2,-19,24]
[-5,-3,-6,-7,-3,-2,-19,-24]
GHCi> map (\xs -> negate (sum (tail xs))) [[1..5],[3..6],[1..7]]
[-14,-15,-27]
GHCi> map (negate . sum . tail) [[1..5],[3..6],[1..7]]
[-14,-15,-27]
```

## Our own types

So far, we've run into a lot of data types. Bool, Int, Char, Maybe, etc.
But how do we make our own? Well, one way is to use the data keyword to define a type.

```haskell
data Point = Point Float Float deriving (Show)
  deriving Show
data Shape = Circle Float Float Float | Rectangle Float Float Float Float
  deriving Show
```

The keyword `data` means that we're defining a new data type.
The part before the `=` denotes the **type**, which is Bool.
The parts after the `=` are **value constructors**.

The keyword `deriving` is used to automatically generate instances of certain type class.
Being instance of the typeclass `Show` allows the type to being show in your screen.

The `Shape` type has two value constuctors `Circle` which has tree arguments
and `Rectangle` that has four arguments.

We can ask `ghci` the type of value constructors.

Example:

```haskell
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

### Symbolic constructors

Imagine we have the type `Rational` defined as:

```haskell
data MyRational = Pair Integer Integer
  deriving Show
```

and we want to define some behavior for this type,
for example, the multiplication. To do it, we create
an operator that multiplies two Rationals.

```haskell
infixl 7 >*<
(>*<) :: MyRational -> MyRational -> MyRational
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
data MyRational = Integer :/ Integer
  deriving Show
```

We adjust now the operator `>*<` for the new data constructor as:


```haskell
infixl 7 >*<
(>*<) :: MyRational -> MyRational -> MyRational
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

-- (n + 1) ∗ m = n ∗ m + m
infixl 7 <*>
(<*>) :: Nat -> Nat -> Nat
Zero <*> m    = Zero
(Suc n) <*> m = n <*> m <+> m
```

### Polymorphics types

A value constructor can take some values parameters and then produce a new value.

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

#### A recursive polymorphic type

We can define a binary polymorphic tree with data in the nodes as:

```haskell
data Tree a = Empty | Node (Tree a) a (Tree a)
  deriving Show
```

- Can be an empty tree, represented as `Empty`
- Can be a tree with one or more levels with the `Node` value constructor.

```haskell
a :: Tree Int
a = Node l 2 r
  where
    l = Node Empty 3 Empty
    r = Empty
```

It would produce a tree such as:

```text
        2
      /   \
     /    --
    3
  /   \
--    --
```

This function computes the sum of all node's values

```haskell
sumTree :: Tree Int -> Int
sumTree Empty       = 0
sumTree Tree l v r  = sumTree l + v + sumTree r
```

#### When not to use polymorphic types

Using type parameters
is very beneficial, but only when using them makes sense.
sually we use them when our data type would work regardless
of the type of the value it then holds inside it.

We could change the `Car` type definition from this:

```haskell
data Car = Car { company :: String
               , model :: String
               , year :: Int
               } deriving (Show)
```

to this:

```haskell
data Car a b c = Car { company :: a
                     , model :: b
                     , year :: c
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
