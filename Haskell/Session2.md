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

Here you can see the Prelude operators definition.

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
