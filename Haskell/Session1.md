# Session 1

Learning Haskell is much like learning to program for the first time — it's fun! It forces you to think differently.

## Functional programming

Functional programming is a programming paradigm that is based on the principles of lambda calculus. Lambda calculus is a formal system developed in the 1930s by [Alonzo Church](https://es.wikipedia.org/wiki/Alonzo_Church) as a way of representing mathematical functions.

With functional programming we aim to write clear, concise, and highly abstracted programs. Functional programming emphasizes in the use of pure functions and immutability. It is a declarative style of programming, in which the focus is on describing what the program should do,
rather than how it should be done.

> 1936 - Alan Turing invents every programming language that will ever be but is shanghaied by British Intelligence to be 007 before he can patent them.

> 1936 - Alonzo Church also invents every language that will ever be but does it better. His lambda calculus is ignored because it is insufficiently C-like. This criticism occurs in spite of the fact that C has not yet been invented.

## What you need to dive in?

A text editor and a Haskell compiler. A good way to get started is to downlaod [GHCup](https://www.haskell.org/ghcup/) which is the main installer for general purpose language Haskell. Once you had downloaded any GHC version (Haskell compiler) you can take a Haskell script with `.hs` extension and compile it but it also has an interactive mode which allows you to interactively interact with scripts.

Suppose we have the following Haskell source code, which we place in a file Main.hs:

```haskell
main = print (fac 20)

fac 0 = 1
fac n = n * fac (n-1)
```

You can save Main.hs anywhere you like, but if you save it somewhere other than the current directory then we will need to change to the right directory in GHCi:

```haskell
ghci> :cd dir
```

To load a Haskell source file into GHCi, use the `:load` command:

```haskell
ghci> :load Main
Compiling Main             ( Main.hs, interpreted )
Ok, modules loaded: Main.
```

If you make some changes to the source code and want GHCi to recompile the program, give the `:reload` command. The program will be recompiled as necessary, with GHCi doing its best to avoid actually recompiling modules if their external dependencies haven’t changed.

```haskell
ghci> :reload
Compiling Main                ( Main.hs, interpreted )
Ok, modules loaded: Main.
```

## What is Haskell?

Haskell is a pure functional programming language.

> 1990 - A committee formed by Simon Peyton-Jones, Paul Hudak, Philip Wadler, Ashton Kutcher, and People for the Ethical Treatment of Animals creates Haskell, a pure, non-strict, functional language. Haskell gets some resistance due to the complexity of using monads to control side effects. Wadler tries to appease critics by explaining that "a monad is a monoid in the category of endofunctors, what's the problem?"

Haskell doesn't have:

- Asigments, but we do have binding

  ```python
  a = 2
  a = 1
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
    # This is unsafe, 
    # I can mutate the state of the app
    # and it's difficult to track 💀
    global x
    x = x + 1
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

- Strong static type system. The type system in Haskell ensures that every expression in the program has a well-defined type, and type's expressions are checked at compile-time. Inconsistent use of types leads to type errors, and Haskell's compiler is so great that find them before executing the program.

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
  (+) :: Num a => a -> a -> a
  ```

- Normal order reduction. Expressions are reduced outside in. 

  Example
  
  ```haskell
  -- equivalent to: 
  -- add1 = (+1)
  add1 x = x + 1

  -- equivalent to: 
  -- square = (^2)
  square x = x^2
  ```
  
  ```haskell
  ghci> square(add1 2)
  9
  ```
  
  The evaluator look for a redex in the expression, reduce it and repeat this process until the expression is in normal form.
  When an expression cannot be further reduced it is said to be in normal form.

  ```text
  lambda x. x² (lambda x. (x + 1) 2))
  ==> { by square definition }
  (lambda x. (x + 1) 2)²
  ==> { by add1 definition }
  (2 + 1)²
  ==> { by (+) operator }
  3²
  ==> { by (^) operator }
  9
  ```
  
  This aprouch has many benefits
  
  - If the expression has normal form, a reduction by means of this order reaches it. (Standardization theorem).
  - Expressions are passed as arguments without necessarily evaluating (pass by name)
  - Any time you give a value a name, it gets shared. This means that every occurrence of the name points at
    the same (potentially unevaluated) expression (Sharing)
    
    Example
    
    ```haskell
    square x = x*x
    ```
    
    Based on the previous sections, you might imagine evaluation works like the following.
    
    ```text
    square (2+2)
    ==> (2+2) * (2+2)   -- definition of square
    ==>   4   * (2+2)   -- (*) forces left argument
    ==>   4   *   4     -- (*) forces right argument
    ==>      16         -- definition of (*)
    ```
    
    However, what really happens is that the expression 2+2 named by the variable x is only computed once. 
    The result of the evaluation is then shared between the two occurrences of x inside square.
    
    ```text
    square (2+2)
    ==> (2+2) * (2+2)
    ==>   4   *   4
    ==>      16
    ```
  
  
  Notice that this is different from the application order reduction that always evaluate the arguments of a function before
  evaluating the function itself.
  
   ```text
  lambda x. x² (lambda x. (x + 1) 2))
  ==> { by add1 definition }
  lambda x. x² (2 + 1)
  ==> { by (+) operator }
  lambda x. x² (3)
  ==> { by square definition }
  3²
  ==> { by (^) operator }
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
    and returns another function which accepts further arguments, one by one, that the original function would receive.
    
    ```haskell
    -- same as max :: Ord a => a -> (a -> a)
    ghci> :t max
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
    
    // or
    
    const max = (a) => (b) => a > b ? a : b
    ```
    
    ```js
    const f = max(4)
    f(5)
    5
    ```
