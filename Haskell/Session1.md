# Session 1

Learning Haskell is much like learning to program for the first time — it's fun! It forces you to think differently.

## Functional programming

Functional programming is a programming paradigm that is based on the principles of lambda calculus. Lambda calculus is a formal system developed in the 1930s by [Alonzo Church](https://es.wikipedia.org/wiki/Alonzo_Church) as a way of representing mathematical functions.

With functional programming we aim to write clear, concise, and highly abstracted programs. Functional programming emphasizes in the use of pure functions and immutability. It is a declarative style of programming, in which the focus is on describing what the program should do,
rather than how it should be done.

> 1936 - Alan Turing invents every programming language that will ever be but is shanghaied by British Intelligence to be 007 before he can patent them.

> 1936 - Alonzo Church also invents every language that will ever be but does it better. His lambda calculus is ignored because it is insufficiently C-like. This criticism occurs in spite of the fact that C has not yet been invented.

## What is Haskell?

Haskell is a pure functional programming language.

> 1990 - A committee formed by Simon Peyton-Jones, Paul Hudak, Philip Wadler, Ashton Kutcher, and People for the Ethical Treatment of Animals creates Haskell, a pure, non-strict, functional language. Haskell gets some resistance due to the complexity of using monads to control side effects. Wadler tries to appease critics by explaining that "a monad is a monoid in the category of endofunctors, what's the problem?"

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

- Strong static type system. The type system in Haskell ensures that every expression in the program has a well-defined type, and type's expressions are checked at compile-time. Inconsistent use of types leads to type errors, and Haskell's compiler is so great that found before executing the program.

  ```haskell
  -- (+) is an operator that expects two number to be added, but here, one of it's parameters is a string.
  ghci> (+) "hello friend" 2

  <interactive>:4:1: error:
      • No instance for (Num [Char]) arising from a use of ‘+’
      • In the expression: (+) "hello friend" 2
        In an equation for ‘it’: it = (+) "hello friend" 2
  ```

- Type inference. Everything in Haskell has a type, so the compiler can reason quite a lot about your program before compiling it, Unlike Java or Python, Haskell has type inference. If we write a number, we don't have to tell Haskell it's a number. It can infer that on its own, so we don't have to explicitly write out the types of our functions and expressions to get things done.

  ```haskell
  ghci> :t 'a'  
  'a' :: Char  
  ghci> :t True  
  True :: Bool  
  ghci> :t "HELLO!"  
  "HELLO!" :: [Char]  
  ghci> :t (True, 'a')  
  (True, 'a') :: (Bool, Char)  
  ghci> :t 4 == 5  
  4 == 5 :: Bool
  ghci> :t (+) 
  (+) :: Num a => a -> a -> a -> a
  ```

- Normal order reduction. Expressions are reduced outside in

  ```text
  lambda x. x² (lambda x. (x + 1) 2))
  (lambda x. (x + 1) 2)²
  (2 + 1)²
  3²
  9
  ```
  
  Notice that this is different from the application order reduction that always evaluate the arguments of a function before
  evaluating the function itself.
  
   ```text
  lambda x. x² (lambda x. (x + 1) 2))
  lambda x. x² (2 + 1)
  lambda x. x² (3)
  3²
  9
  ```
  
- Infinite extructures

  ```haskell
  infiniteList :: [Int]
  infiniteList = [1..]
  ```

- Lazy evaluation

  ```haskell
  mayHang :: a -> b -> b
  mayHang x y = y
  ```

  ```haskell
  ghci> mayHang infiniteList (1 + 1)
  ```

  ```haskell
  ghci> mayHang (1 + 1) infiniteList
  ```

- Functions, it's all you need (to compute)

  - In mathematics the application of function is denotated with parenthesis

    ```text
    f (a, b) + c × d -- applies the function f to the parameters a and b
    ```

  - In Haskell the function application is denotated by a space

    ```haskell
    f a b + c * d -- same as f (a, b) + c × d
    ```

  - The application of functions has maximum priority

    ```haskell
    g a + b -- means (g a) + b and NO g (a + b)
    ```
    
  - Compound arguments go between parentheses

    ```haskell
    f (a + b) c -- applies f function to 2 arguments.
    ```

  - In Haskell functions are considered first-class citizens, which means they can be passed as arguments,
    returned as values, and composed together to form more complex operations
    
    ```haskell
    map :: (a -> b) -> [a] -> [b]
    map f []     = []
    map f (x:xs) = f x : map f xs
    ```

  - Functions are pure, where its return value depends solely on its input parameters. In other words, functions
    in Haskell respect the referencial transparency property, meaning that they don't produce side effects. Because functions
    are pure, formal verification is relatively easy

    ```haskell
    double :: Int -> Int
    double x = x * 2
    ```

  - Curried functions, every function in Haskell only takes one parameter. Didn't wee see functions that take more than one parameter so far? 
    Well, it's a clever trick!. All the functions that accepted several parameters so far have been curried functions. 
    Currying is the process of transforming a function that takes multiple arguments, into a function that takes just a single argument 
    and returns another function which accepts further arguments, one by one, that the original function would receive in the rest of that tuple

    ```haskell
    -- same as max :: Ord a => a -> (a -> a)
    max :: Ord a => a -> a -> a 
    ```
    
    ```haskell
    ghci> max 4 5
    5
    ```
    
    ```haskell
    ghci> let f = max 4
    ghci> f 5
    5
    ```

    Does other languages support this feature? the vast majority don't. For example, in JS you can emulate this as:

    ```js
    function max(a) {
      return function(b) {
        return a > b ? a : b
      }
    }
    ```
    
    or
    
     ```js
    const max = (a) => (b) => a > b ? a : b
    ```
    
    ```js
    const f = max(4)
    f(5)
    5
    ```
