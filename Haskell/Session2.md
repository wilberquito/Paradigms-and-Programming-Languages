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
**They indicate that the first parameter is a function that takes something and returns that same thing**.

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
