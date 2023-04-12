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

If (?) is an operator, we have the following equivalences.

```haskell
(x ?) ===> \y -> x ? y
(? y) ===> \x -> x ? y
(?)   ===> \x y -> x ? y
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
fun 0 = e
fun m = let n = m-1
        in f m (fun n)
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

sumatorio :: Integer -> Integer
sumatorio = iter (+) 0
```

## Polymorphism

Polymorphism refers to the phenomenon of something taking many forms.

### The indentity function

```haskell
id :: a -> a
id x = x
```

The identity function and just returns its argument.

```haskell
GHCi> id 'd'
'd'
GHCi> id [1,2,0]
[1,2,0]
```

The `id` function seems a bit useless, but sometimes with higher-order functions
it’s useful to have a function that does nothing.

```haskell
GHCi> filter id [True, False, True]
[True, True]
```

### Tuples

The functions `fst` and `snd` allows us to get components.

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

#### The length

```haskell
length' :: [a] -> Int
length' [] = 0
length' (x:xs) = 1 + length xs
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
"hello"
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
init (x:xs) = xs
```

```haskell
GHCi> tail ["hello", "world", "!"]
["hello", "world"]
GHCi> tail []
*** Exception: Prelude.tail: empty list
```

#### Concat lists

You can concatenate lists using the operator `++`.

```haskell
infix 5 ++
(++) :: [a] -> [a]
[] ++ ys      = ys
(x:xs) ++ ys  = x : (xs ++ ys)
```

```haskell
GHCi> tail ["hello", "world", "!"]
"hello"
GHCi> tail []
*** Exception: Prelude.tail: empty list
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
tells whether something is true or not, so in our case, a function that returns a boolean value)
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

> By the way which type do you thing the expression
`let notNull x = not (null x) in filter notNull [[1,2,3],[],[3,4,5],[2,2],[],[],[]]` has?

### Functions application with $ operator

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
which is 3. We could have write `sqrt (3 + 4 +9)` of if we use `$` we can
write it like `sqrt $ 3 + 4 +9`.

Appart from getting rid of paren, `$` means that function application can be
treated just like another function.


```haskell
GHCi>  map ($ 3) [(4+), (10*), (^2), sqrt]
[7.0,30.0,9.0,1.7320508075688772]
```

### Function composition
