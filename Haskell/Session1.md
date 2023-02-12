# Section 1

Learning Haskell is much like learning to program for the first time — it's fun! It forces you to think differently.

## What is Haskell?

Haskell is a pure functional programming language. What exactly functional programming means? 
Functional programming is a programming paradigm that emphasizes the use of pure functions and immutability.
It is a declarative style of programming, in which the focus is on describing what the program should do,
rather than how it should be done.

Haskell doesn't have:

- Asigments

```python
a = 2
```
- Loops

```python
numbers = [1, 2, 3, 4]
for n in numnbers:
  pass
```
- Side effects

```python
def add1():
  x = x + 1 # where x came from?
  return x
```
- Memory managment

```cpp
using namespace std;
void geeks()
{
    int var = 20;
  
    // declare pointer variable
    int* ptr;
  
    // note that data type of ptr and var must be same
    ptr = &var;
}
```

Haskell have:

- Lazy evaluation: hat means that unless specifically told otherwise, 
Haskell won't execute functions and calculate things until it's really forced to show you a result. 
That goes well with referential transparency and it allows you to think of programs as a series of transformations
on data. It also allows cool things such as infinite data structures. 

  - Infinite extructure

    ```haskell
    infiniteList :: [Int]
    infiniteList = [1..]
    ```
  - Hang
    
    ```haskell
    mayHang :: a -> b -> b
    mayHang x y = y

    mayHang infiniteList (1 + 1) -- it does'nt hang
    mayHang (1 + 1) infiniteList -- it hangs
    ```
- Functions, it's all you need: 

  In mathematics the application of function is denotated with parenthesis:

  ```text
  f (a, b) + c × d -- applies the function f to the parameters a and b
  ```

  In Haskell the function application is denotated by a space:

  ```haskell
  f a b + c * d -- same as f (a, b) + c × d
  ```

  In Haskell the application of functions has maximum priority:

  ```haskell
  g a + b -- means (g a) + b and NO g (a + b)
  ```

  In Haskell the compound arguments go between parentheses:

  ```haskell
  f (a + b) c -- applies f function to 2 arguments.
  ```

  In Haskell functions are considered first-class citizens, which means they can be passed as arguments, 
  returned as values, and composed together to form more complex operations. 
  Functions in functional programming are also pure, meaning they do not have side effects and always produce 
  the same output for a given input.

  ```haskell
  map :: (a -> b) -> [a] -> [b]
  map f []     = []
  map f (x:xs) = f x : map f xs
  ```

  Every function in Haskell officially only takes one parameter. So how is it possible that we 
  defined and used several functions that take more than one parameter so far? Well, it's a clever trick! 
  All the functions that accepted several parameters so far have been curried functions.

  The following two calls are equivalent:
  
  ```haskell
  max :: Ord a => a -> a -> a -- same as max :: Ord a => a -> (a -> a)
  max 4 5
  (max 4) 5
  ```

  Does other languages support this feature? not by default, for example, in JS you can emulate this as:
  
  ```js
  function max(a) {
    return function(b) {
        return a > b ? a : b
    }
  }
  ```
