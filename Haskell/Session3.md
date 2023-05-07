# Session 3

## Ranges

Ranges are a way of making
lists that are arithmetic sequences of
elements that can be enumerated.
Numbers can be enumerated. One, two, three, four, etc.
Characters can also be enumerated.
The alphabet is an enumeration of characters from A to Z.
Names can't be enumerated. What comes after "John"? I don't know.

```haskell
GHCi> [1..20]
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
GHCi> ['a'..'z']
"abcdefghijklmnopqrstuvwxyz"
GHCi> ['K'..'Z']
"KLMNOPQRSTUVWXYZ"
```

Ranges support steps.

```haskell
GHCi> [2,4..20]
[2,4,6,8,10,12,14,16,18,20]
GHCi> [3,6..20]
[3,6,9,12,15,18]
```

The enumeration can go in the other way.

```haskell
GHCi> [20,19..0]
[20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
GHCi> [20,18..0]
[20,18,16,14,12,10,8,6,4,2,0]
```

## Comprehension list

Comprehension list cames from *set comprehension*
which is a mathematical concept of generating a small
set from a general one.

Set comprehensions have the following form:

![setnotation](Img/setnotation.png)

- The part before the pipe is called the output function
- `x` is a variable and `N` is the input set
- `x <= 10` is a predicate

This mathematical expression generates a set that
contains the doubles of all natural that satisty the predicate.

Now, we can generate lists by comprehension in Haskell using the
following syntax:

```haskell
GHCi> [x*2 | x <- [1..10]]
[2,4,6,8,10,12,14,16,18,20]
GHCi> [x*2 | x <- [1..], x <= 10]
[2,4,6,8,10,12,14,16,18,20]
```

Notice that the predicate part in the comprehension list
syntax is not mandatory.

Let's say we want a comprehension that replaces
each odd number greater than 10 with "BANG!"
and each odd number that's less than 10 with "BOOM!".
If a number isn't odd, we throw it out of our list.

```haskell
GHCi> boomBangs xs = [if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]
GHCi> boomBangs [1..20]
["BOOM!","BOOM!","BOOM!","BOOM!","BOOM!","BANG!","BANG!","BANG!","BANG!","BANG!"]
```

We can include several predicates.
If we wanted all numbers from
10 to 20 that are not 13, 15 or 19, we'd do:

```haskell
GHCi> [x*2 | x <- [10..20], x \= 13, x \= 15, x \= 19]]
[20,22,24,28,32,34,36,40]
```

Is there another way to create this comprehension list?
Yes, remember the functions `map` and `filter`.

```haskell
GHCi> map (*2) . filter (`notElem` [13,15,19]) $ [10..20]
[20,22,24,28,32,34,36,40]
```

Not only can we have multiple predicates in list comprehensions,
we can also draw from several lists.
When drawing from several lists,
comprehensions produce all combinations of
the given lists and then join them by the output function we supply.

```haskell
GHCi> [x*y | x <- [2,5,10], y <- [8,10,11]]
[16,20,22,40,50,55,80,100,110]
```

## Folding

Consider the functions
`myMaximum :: [Int] -> Int`
 and `countNothings :: [Maybe Int] -> Int`.

```haskell
-- Returns the biggest number in a list
myMaximum :: [Int] -> Int
myMaximum []        = 0
myMaximum (x:xs)    = go x xs
  where go biggest []       = biggest
        go biggest (x:xs)   = go (max biggest x) xs

-- Counts the occurrences of Nothing in a list
countNothings :: [Maybe a] -> Int
countNothings []                = 0
countNothings (Nothing : xs)    = 1 + countNothings xs
countNothings (Just _  : xs)    = countNothings xs
```

They have one common characteristic.
They take a list and produce a value that depends
on the values of the elements in the given list.
**They fold a list of many values into a single value**.

Haskell has the built-in function `foldr` to perform
a *right associative fold* over a `Foldable` data type.
Guess what? list, are instances of the `Foldable` type.

```haskell
GHCi> :info []
type [] :: * -> *
data [] a = [] | a : [a]
        -- Defined in ‘GHC.Types’
instance Applicative [] -- Defined in ‘GHC.Base’
instance Eq a => Eq [a] -- Defined in ‘GHC.Classes’
instance Functor [] -- Defined in ‘GHC.Base’
instance Monad [] -- Defined in ‘GHC.Base’
instance Monoid [a] -- Defined in ‘GHC.Base’
instance Ord a => Ord [a] -- Defined in ‘GHC.Classes’
instance Semigroup [a] -- Defined in ‘GHC.Base’
instance Show a => Show [a] -- Defined in ‘GHC.Show’
instance MonadFail [] -- Defined in ‘Control.Monad.Fail’
instance Read a => Read [a] -- Defined in ‘GHC.Read’
instance Foldable [] -- Defined in ‘Data.Foldable’
instance Traversable [] -- Defined in ‘Data.Traversable
```

Let's see the definition of `foldr`
that works just for lists (but the `foldr` definition
is more generic than we see here).

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr _ y []     = y
foldr f y (x:xs) = f x (foldr f y xs)
```

How it works?

- For an empty list `[] :: [a]`, `foldr` returns a default value `y :: b`.
- For any other list `(x:xs) :: [a]`, `foldr` applies `f :: (a -> b -> b)`
to `x :: a` and the folding of the rest of the list `foldr f y xs :: b`.

What `foldr` is doing in the recursive call is applying
the function `f` repeadly with two arguments.

```text
> foldr f z [x1, x2, ..., xn] == x1 `f` (x2 `f` ... (xn `f` z)...)
```

 - The first argument is the first element of the list.
 - The second argument is what `f` returned from the rest of the list.

 Basic usage:

 ```haskell
GHCi> foldr (||) False [False, True, False]
True
GHCi> foldr (||) False []
False
GHCi> foldr (\c acc -> acc ++ [c]) "foo" ['a', 'b', 'c', 'd']
"foodcba"
 ```

Applying `foldr` to infinite structures usually doesn't terminate.

```haskell
GHCi> foldr (+) 0 [1..]
```

But it works nicely with lazy or short-circuiting operations.

```haskell
GHCi> foldr (||) False (repeat True)
True
```

Now it's time to add some stricness to the fold process, This
is rarely what you want, but can work well for structures with efficient
right-to-left sequencing and an operator that is lazy in its left
argument. Let's have a look at the cousin of `foldr`, `foldl`.

While `foldr` processes a list right-to-left,
`foldl` processes a list left-to-right (*left associative fold*).

```haskell
GHCi> foldr (+) 0 [1,2,3]  ==>  1+(2+(3+0))
GHCi> foldl (+) 0 [1,2,3]  ==>  ((0+1)+2)+3
```

Let's see the definition of `foldr`.

```haskell
foldl :: (a -> b -> b) -> b -> [a] -> b
foldl _ y []     = y
foldl f y (x:xs) = foldl f (f y x) xs
```

`foldl` needs to process the whole list in order to produce a value.
The reason is that foldl remains in the leftmost-outermost
position for as long as its list argument remains non-empty.
This makes `foldl` the priority for **lazy evaluation**.
Only after the list becomes empty does the evaluation
proceed into simplifying the folded values.

```text
> foldl f z [x1, x2, ..., xn] == (...((z `f` x1) `f` x2) `f`...) `f` xn
```

Using `foldr`:

```haskell
head (foldr (++) [] ["Hello","World","lorem","ipsum"])
==> head ("Hello" ++ (foldr (++) [] ["World","lorem","ipsum"]))
==> head ('H':("ello" ++ (foldr (++) [] ["World","lorem","ipsum"])))
==> 'H'
```

Using `foldl`:

```haskell
    head (foldl (++) [] ["Hello","World","lorem","ipsum"])
==> head (foldl (++) ([]++"Hello") ["World","lorem","ipsum"])
==> head (foldl (++) (([]++"Hello")++"World") ["lorem","ipsum"])
==> head (foldl (++) ((([]++"Hello")++"World")++"lorem") ["ipsum"])
==> head (foldl (++) (((([]++"Hello")++"World")++"lorem")++"ipsum") [])
==> head (((([]++"Hello")++"World")++"lorem")++"ipsum")
-- head forces the last ++, which forces the next-to-last ++, and so on
==> head ((("Hello"++"World")++"lorem")++"ipsum")
-- same happens again
==> head ((('H':("ello"++"World"))++"lorem")++"ipsum")
-- for clarity, let's drop the "ello"++"World" expression which isn't needed
==> head ((('H':__)++"lorem")++"ipsum")
-- now the next-to-last ++ can operate
==> head (('H':(__++"lorem"))++"ipsum")
-- let's drop the __++"lorem" expression
==> head (('H':__)++"ipsum")
-- now the last ++ can operate
==> head ('H':(__++"ipsum"))
==> 'H'
```

## Classes system

### Overloaded functions

- It makes sense for some types, not for all
- Can have diferent definitions per each type

Consider the following types:

```haskell
type Side   = Float
type Radius = Float
type Area   = Float
data Square = ASquare Side deriving Show
data Circle = ACircle Radius deriving Show
```

We would like to compute the area for this types:

```haskell
-- Computes the area of a square
area :: Square -> Area
area (ASquare s) = s*s

-- Computes the area of a circle
area :: Circle -> Area
area (ACircle r) = pi * r^2
```

The `area` function makes sense for types `Square` and `Circle`
but not for `Bool`. Hence it's not a polymorphic function.

The problem here is that Haskell does not support `overloaded functions`
as show above. You need to create a `class`.

```haskell
type Area = Float

class HasArea t where
    area :: t -> Area
```

- `t` is type variable.
- The function `area` is just defined to the types `t` that are instances of the typeclass.

To make a type be an instance of a typeclass, you can do the following.

```haskell
instance HasArea Square where
    area (ASquare s) = s*s
instance HasArea Circle where
    area (ACircle r) = pi * r^2
```

If you try to use the function `area` with a non instance
of `HasArea`, the compiler will throw you an error.

```haskell
GHCi> area (ASquare 3)
9.0 :: Area
GHCi> area (ACircle 3)
28.2743 :: Area
```

## Predifined class and instances

Some of the built-in classes:

- `Eq` denotates equality: `(==)` and `(/=)`
- `Ord` denotates order: `<=`, `(<)`, `(>=)`,...
- `Num` numeric types: `(+)`, `(-)`, `(*)`,...
- `Show` types that can be printed in the console: `show`
- `Read` types that can be readed from the console: `read`

To know if a `type` is an instance of a typeclass you can
ask it to the compiler.

For example, let's see from which classes the type
`Double` is instance.

```haskell
GHCi> :info Double
type Double :: *
data Double = GHC.Types.D# GHC.Prim.Double#
        -- Defined in ‘GHC.Types’
instance Eq Double -- Defined in ‘GHC.Classes’
instance Ord Double -- Defined in ‘GHC.Classes’
instance Enum Double -- Defined in ‘GHC.Float’
instance Floating Double -- Defined in ‘GHC.Float’
instance Fractional Double -- Defined in ‘GHC.Float’
instance Num Double -- Defined in ‘GHC.Float’
instance Real Double -- Defined in ‘GHC.Float’
instance RealFloat Double -- Defined in ‘GHC.Float’
instance RealFrac Double -- Defined in ‘GHC.Float’
instance Show Double -- Defined in ‘GHC.Float’
instance Read Double -- Defined in ‘GHC.Read’
```

### Eq class

```haskell
class Eq a where
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool

    -- The minimum implementation is (==) or (/=)

    x == y = not (x /= y)
    x /= y = not (x == y)
```

- The definitions in the class `(==)` and `(/=)` denotates
a default behavior. This default behavior is use in case
they are not defined in the instance.

- It is enought to define one of the `Eq` functions to be
instance of the typeclass.

### Ord class

The `Ord` class is a subclass of `Eq`, it means that
all type instances of `Ord` are instances of `Eq`.

```haskell
data Ordering = LT | EQ | GT

class Eq a => Ord a where
    (<), (<=), (>=), (>) :: a -> a -> Bool
    max , min :: a -> a -> a
    compare :: a -> a -> Ordering

    -- The minimum implementation is (<=) or `compare`
    compare x y
        | x == y    = EQ
        | x <= y    = LT
        | otherwise = GT
    x <= y = compare x y    /= GT
    x < y = compare x y     == LT
    x >= y = compare x y    /= LT
    x > y = compare x y     == GT
    max x y
    | x >= y    = x
    | otherwise = y
    min x y
    | x <= y    = x
    | otherwise = y
```

### Show and Read class

This classes are thought to work with i/o.
To show types in console or read string from console
and transform them into a type.

```haskell
class Show a where
    show :: a -> String
class Read a where
    read :: (Read a) => String -> a
```

## I/O

I/O operations are not pure functions. They change
"THE WORLD". Read and write operations changes the
state of the outside world (side effect), because
when we read from the console, we are not just manipuling
data within the program. We interact with the user, reading
input from the keyword.

Similarly, if we write output to the console, we are not just
printing some text, we also causing text to be displayed
on the screen, which is an effect that can be observed outside
the program itself.

As I/O operations behave different than Haskell pure functions,
we need different framework to work with them. This framework
is call `Monad`, but we will just work with the `Monad IO`.

Most programs needs some I/O operation. Haskell allows
us to work with this inpurity with types that are
instances of the type `IO`.

For example, let's try to read something from the console.
To read something from the console we use the action `getLine`.

```haskell
GHCi> :t getLine
getLine :: IO String
GHCi> getLine
Hello World!
"Hello World!"
```

Reading from the console means take what is written
and parse it to a `String`. That's why the `getLine`
action is of type `IO String`.

Now, what if I want to write something in the console?
To achieve it, we can use for example the action `putStrLn`.

```haskell
GHCi> :t putStrLn
putStrLn :: String -> IO ()
GHCi> putStrLn "Hello World!"
Hello World!
```

Printing a string to the console doesn't really
have any kind of meaningful return value,
so a dummy value of `()` is used, the unit.

> The empty tuple is a value of () and it also has a type of ().

### The main function

In our code, I/O actions will perform when there is `main` function
and we run the program.

```haskell
main :: IO ()
main = do
    putStrLn "Hello, what's your name?"
    name <- getLine
    putStrLn ("Hey " ++ name ++ ", you rock!")
```

The `do` notation is syntax suggar for work with all `Monads`,
the `do` notation opens a block of inpurity. That's why why
can perform dirty actions here.

Here is another example a litle bit more complex than the previous main.

```haskell
import Random
main = do
    putStrLn "How is your name?"
    name <-getLine
    putStrLn ("Hello " ++ name ++ ", give me your number" )
    number <- getLine
    let num = read number :: Int
    ra <- randomRIO (1::Int, num)
    putStrLn ("Here is a random number from 1 to "
        ++ show num ++ " it is: "++ show ra)
```

### Other I/O actions

There are a lot of I/O actions
in the Haskell language that we are not covering,
but here are a fewer more:

```haskell
GHCi>:t putChar :: Char -> IO ()
GHCi>:t putStr :: String -> IO ()
GHCi>:t putStrLn :: String -> IO ()
GHCi>:t readFile :: FilePath -> IO String
GHCi>:t writeFile :: FilePath -> String -> IO ()
```

## Modules

A Haskell module is a collection of related
functions, types and typeclasses.
A Haskell program is a collection
of modules where the main module loads
up the other modules and then uses the
functions defined in them to do something.
Having code split up into several modules
has quite a lot of advantages.
If a module is generic enough, the functions it exports
can be used in a multitude of different programs

### Using existing modules

The syntax for importing modules in a Haskell
script is `import <module name>`.
This must be done before defining any functions,
so imports are usually done at the top of the file.

```haskell
import Data.List

numUniques :: (Eq a) => [a] -> Int
numUniques = length . nub
```

You can use the same syntax to import modules
in `ghci`. But you could also import modules as follow:

```haskell
GHCi> :m + Data.List Data.Map
```

The main difference is that this last syntax allows you
to import multiple modules at once.

If you just need a couple of functions from a module,
you can selectively import just those functions

```haskell
import Data.List (nub, sort)
```

A way of dealing with name clashes of different modules,
is to do qualified imports.

```haskell
import qualified Data.List as L
numUniques :: (Eq a) => [a] -> Int
numUniques = length . L.nub
```

### Making our own modules

Almost every programming language enables
you to split your code up into several
files and Haskell is no different.

We'll start by creating a file called `Geometry.hs`.
At the beginning of a module,
we specify the module name.
If we have a file called `Geometry.hs`,
then we should name our module `Geometry`.
Then, we specify the functions that it exports and after that,
we can start writing the functions.

```haskell
module Geometry
( sphereVolume
, sphereArea
, cubeVolume
, cubeArea
, cuboidArea
, cuboidVolume
) where

sphereVolume :: Float -> Float
sphereVolume radius = (4.0 / 3.0) * pi * (radius ^ 3)

sphereArea :: Float -> Float
sphereArea radius = 4 * pi * (radius ^ 2)

cubeVolume :: Float -> Float
cubeVolume side = cuboidVolume side side side

cubeArea :: Float -> Float
cubeArea side = cuboidArea side side side

cuboidVolume :: Float -> Float -> Float -> Float
cuboidVolume a b c = rectangleArea a b * c

cuboidArea :: Float -> Float -> Float -> Float
cuboidArea a b c = rectangleArea a b * 2 + rectangleArea a c * 2 + rectangleArea c b * 2

rectangleArea :: Float -> Float -> Float
rectangleArea a b = a * b
```
