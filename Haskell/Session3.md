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

 - The first argument is the first element of the list.
 - The second argument is what `f` returned from the rest of the list.
