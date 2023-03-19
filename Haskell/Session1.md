# Session 1

Can programming be liberated from the von Neumann style?

## Functional programming

Functional programming is a programming paradigm that is based on the principles of lambda calculus. 
Lambda calculus is a formal system developed in the 1930s by 
[Alonzo Church](https://es.wikipedia.org/wiki/Alonzo_Church) as a way of representing mathematical functions.

> 1936 - Alan Turing invents every programming language that will ever be but 
is shanghaied by British Intelligence to be 007 before he can patent them.

> 1936 - Alonzo Church also invents every language that will ever be but does it better. 
His lambda calculus is ignored because it is insufficiently C-like. 
This criticism occurs in spite of the fact that C has not yet been invented.

The foundations of functional programming are abstract,
mathematical notions of computation that transcend a specific implementation. This
leads to a method of programming that often solves problems simply by describing
them. By focusing on computation, not computers.

## What you need to dive in?

A text editor and a Haskell compiler. A good way to get started is to 
downlaod [GHCup](https://www.haskell.org/ghcup/) which is the main installer 
for general purpose language Haskell. Once you had downloaded any GHC version (Haskell compiler) 
you can take a Haskell script with `.hs` extension and compile it but you can use `GHCi` 
and interactive interface for `GHC`, GHCi is started with a simple command: `ghci`, 
you’ll be greeted with a new prompt:

```haskell
$ ghci
GHCi> 
```

For GHCi, you use the :q command
to exit:

```haskell
$ ghci
GHCi> :q
Leaving GHCi.
```

Working with GHCi is much like working with interpreters in most interpreted programming languages such as Python and Node. 
It can be used as a simple calculator:

```haskell
GHCi> 1 + 1
2
```

You can also write code on the fly in GHCi:

```haskell
GHCi> x = 2 + 2
GHCi> x
4
```

We rather persist our code into files. The `Main.hs` Haskell module has the following code:

```haskell
main = print (fac 20)

fac 0 = 1
fac n = n * fac (n-1)
```

You can save `Main.hs` anywhere you like, but if you save it somewhere other than the current directory then we will need to change to the right directory in GHCi:

```haskell
GHCi> :cd dir
```

To load a Haskell source file into GHCi, use the `:load` command:

```haskell
GHCi> :load Main
Compiling Main             ( Main.hs, interpreted )
Ok, modules loaded: Main.
```

If you make some changes to the source code and want GHCi to recompile the program, give the `:reload` command. The program will be recompiled as necessary, with GHCi doing its best to avoid actually recompiling modules if their external dependencies haven’t changed.

```haskell
GHCi> :reload
Compiling Main                ( Main.hs, interpreted )
Ok, modules loaded: Main.
```

## What is Haskell?

Haskell is a pure functional programming language.
Just as C is the nearly perfect embodiment of the von Neumann style of programming,
Haskell is the purest functional programming language you can learn.

> 1990 - A committee formed by Simon Peyton-Jones, Paul Hudak, Philip Wadler, Ashton Kutcher, and People for the Ethical Treatment of Animals creates Haskell, a pure, non-strict, functional language. Haskell gets some resistance due to the complexity of using monads to control side effects. Wadler tries to appease critics by explaining that "a monad is a monoid in the category of endofunctors, what's the problem?"

### Haskell doesn't have...

#### Asigments

```python
a = 2
a = 1
```

But we do have name binding.

#### Imperative loops

```python
numbers = [1, 2, 3, 4]
for n in numbers:
  pass
```

```python
while True:
  pass
```

But we do have recursion. Problems that can be solved iteratively can also be solved recursively.

#### Side effects

```python
def add1():
  # This is unsafe, 
  # I can mutate the state of the app
  # and it's difficult to track 💀
  global x
  x = x + 1
  return x
```

#### Memory managment

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

### Haskell do have

#### Static type system

The type system in Haskell ensures that every expression in the program has a well-defined type, and type's expressions are checked at compile-time. Inconsistent use of types leads to type errors, and Haskell's compiler is so great that find them before executing the program.

  ```haskell
  -- (+) is an operator that expects two number to be added, but here, one of it's parameters is a string.
  ghci> (+) "hello friend" 2

  <interactive>:4:1: error:
      • No instance for (Num [Char]) arising from a use of ‘+’
      • In the expression: (+) "hello friend" 2
        In an equation for ‘it’: it = (+) "hello friend" 2
  ```

#### Type inference

Everything in Haskell has a type, so the compiler can reason quite a lot about your program before compiling it, Unlike Java or Python, Haskell has type inference. If we write a number, we don't have to tell Haskell it's a number. It can infer that on its own, so we don't have to explicitly write out the types of our functions and expressions to get things done.

```haskell
GHCi> :t 'a'  
'a' :: Char  
GHCi> :t True  
True :: Bool  
GHCi> :t "HELLO!"  
"HELLO!" :: [Char]  
GHCi> :t (True, 'a')  
(True, 'a') :: (Bool, Char)  
GHCi> :t 4 == 5  
4 == 5 :: Bool
GHCi> :t (+) 
(+) :: Num a => a -> a -> a
```

Since Haskell has type inference, you don’t need to give any type annotations. 
However even though type annotations aren’t required, there are multiple reasons to add them.

Example:

```haskell
doubleMe :: Int -> Int
doubleMe x = x + x  
```

- They act as documentation
- They act as assertions that the compiler checks: help you spot mistakes
- You can use type annotations to give a function a narrower type than Haskell infers
  
#### Functions 

The behavior of functions in Haskell
comes directly from mathematics. In math, we often say things like `f(x) = y`, meaning
there’s some function *f* that takes a parameter *x* and maps to a value *y*.
In mathematics, every *x* can map to one and only one *y*.

In mathematics the application of function is denotated with parenthesis.

```text
f (a, b) + c × d -- applies the function f to the parameters a and b
```

In Haskell the function application is denotated by a space.

```haskell
f a b + c * d -- same as f (a, b) + c × d
```

The application of functions has maximum priority.

```haskell
g a + b -- means (g a) + b and NO g (a + b)
```

Compound arguments go between parentheses.

```haskell
f (a + b) c -- applies f function to 2 arguments.
```

In Haskell functions are considered first-class citizens, which means they can be passed as arguments,
returned as values, and composed together to form more complex operations.

```haskell
map :: (a -> b) -> [a] -> [b]
map f []     = []
map f (x:xs) = f x : map f xs
```

Functions are pure, where its return value depends solely on its input parameters. In other words, functions
in Haskell don't produce side effects. Because functions are pure, formal verification is relatively easy.

```haskell
double :: Int -> Int
double x = x * 2
```

Curried functions, every function in Haskell only takes one parameter. Didn't wee see functions that take more than one parameter so far? 
Well, it's a clever trick!. All the functions that accepted several parameters so far have been curried functions. 
Currying is the process of transforming a function that takes multiple arguments, into a function that takes just a single argument 
and returns another function which accepts further arguments, one by one, that the original function would receive.

```haskell
-- same as max :: Ord a => a -> (a -> a)
GHCi> :t max
max :: Ord a => a -> a -> a 
```

```haskell
GHCi> max 4 5
5
```

```haskell
GHCi> f = max 4
GHCi> f 5
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

```js
const f = max(4)
f(5)
5
```

#### Normal order reduction

Expressions are reduced outside-in. 

Example:

```haskell
-- equivalent to: 
-- add1 = (+1)
add1 x = x+1

-- equivalent to: 
-- square = (^2)
square x = x^2
```

```haskell
GHCi> square(add1 2)
9
```

The evaluator look for a redex in the expression, reduce it and repeat this process until the expression is in normal form.
When an expression cannot be further reduced it is said to be in normal form.

```text
λx. x² (λx. (x+1) 2))
===> { by square definition }
(λx. (x+1) 2)²
===> { by add1 definition }
(2 + 1)²
===> { by (+) operator }
3²
===> { by (^) operator }
9
```
  
Notice that the normal order reduction is different from the application order reduction that always evaluate the arguments of a function before
evaluating the function itself. Evaluation process is inside-out.

 ```text
λx. x² (λx. (x+1) 2))
===> { by add1 definition }
λx. x² (2+1)
===> { by (+) operator }
λx. x² (3)
===> { by square definition }
3²
===> { by (^) operator }
9
```

Normal order reduction has many benefits

- If the expression has normal form, a reduction by means of this order reaches it. (Standardization theorem).
- Expressions are passed as arguments without necessarily evaluating (pass by name)
- Any time you give a value a name, it gets shared. This means that every occurrence of the name points at
  the same (potentially unevaluated) expression (Sharing)

  Example:

  ```haskell
  square x = x*x
  ```

  You might imagine evaluation works like the following

  ```text
  square (2+2)
  ===> (2+2) * (2+2)   -- definition of square
  ===>   4   * (2+2)   -- (*) forces left argument
  ===>   4   *   4     -- (*) forces right argument
  ===>      16         -- definition of (*)
  ```
    
  However, what really happens is that the expression `2+2` named by the variable `x` is only computed once. 
  The result of the evaluation is then shared between the two occurrences of `x`.

  ```text
  square (2+2)
  ===> (2+2) * (2+2)
  ===>   4   *   4
  ===>      16
  ```

If an incorrect redex is selected, the expression may fail to produce its normal form.

Example:

```haskell
-- What happend if you call infinite by itself?
infinite :: Integer
infinite = 1 + infinite

zero :: Integer -> Integer
zero x = 0
```

```text
∀n :: Integer. zero n => 0
```
  
If we try to to produce the normal form with the application order reduction, it hangs.

```text
zero infinite
===> { by infinite definition }
cero (1 + infinite)
===> { by infinite defintion }
cero (1 + (1 + infinite))
===> { by infinite definition }
. . .
```

On the other hand, if we use normal order reduction, it generates the normal form.

 ```text
zero infinite
===> { by zero defintion }
0
. . .
```
 
#### Infinite extructures

```haskell
infiniteList :: [Int]
infiniteList = [1..]
```

#### Lazy evaluation

Values are only evaluated when they are needed. This makes it possible to work with 
infinite data structures, and also makes pure programs more efficient.

```haskell
mayHang :: a -> b -> b
mayHang x y = y
```

```haskell
GHCi> mayHang infiniteList (1 + 1)
```

```haskell
GHCi> mayHang (1 + 1) infiniteList
```

#### Variables

Variables in Haskell are straightforward. Here you’re assigning 3 to the variable x.

```haskell
GHCi> x = 3
```

The only catch with variables in Haskell is that they’re not really variable at all! If you
were to try to compile the following bit of Haskell, you’d get an error.

```haskell
main = do
  let x = 3
      x = 2
   . . .
```

A better way to think about variables in Haskell is as definitions or name binding.

The key benefit of variables in programming is to clarify 
your code and avoid repetition, for example:

This function takes two
arguments: how much is owed and how much is given. If you’re given enough money,
you return the difference. But if you aren’t given enough money, you don’t want to give
negative dollars; you’ll return 0.

```haskell
calcChange owed given = if given - owed > 0
                        then given - owed
                        else 0
```

And now with the use of variable defined in the `where` block.

```haskell
calcChange owed given = if change > 0
                        then change
                        else 0
  where change = given – owed
```

## Quick check

Many languages use the ++ operator to increment a value; for example, x++
increments x. Do you think Haskell has an operator or function that works this way?

## Built-in types
  
Previously we mentioned that Haskell has a static type system. 
The type of every expression is known at compile time, which leads to safer code. 
If you write a program where you try to divide a boolean type with some number, it won't even compile.
  
### What are types by the way?

Intuitively, we can think of types as sets of values and a set of allowed operations on those values.

### Syntax of types

| Type |	Literals | Use | Operations |
|:----:|:---------:|:---:|:----------:|
| Int |	1, 2, -3 | Number type (signed, 64bit) | +, -, \*, div, mod, fromIntegral |
| Integer |	1, -2, 900000000000000000	| Unbounded number type |	+, -, \*, div, mod, fromInteger, fromIntegral |
| Float | 0.1, 1.2e5	| Floating point numbers | +, -, \*, /, sqrt |
| Double | 0.1, 1.2e5	| Floating point numbers. Aproximations are more precise than Float type | +, -, \*, /, sqrt |
| Bool | True, False | Truth values	| &&, \|\|, not, otherwise |
| Char | 'a', 'Z', '\n', '\t', '\\' | Represents a character (a letter, a digit, a punctuation mark, etc) | ord, chr, isAlpha, isDigit, isUpper, isLower |
| String aka [Char] |	"abcd", ""	| Strings of characters	| reverse, ++ |

Many of this operations are defined for a bigger group in a typeclass, 
not just for the specific type. A typeclass is a sort of interface that defines some behavior. 
If a type is a part of a typeclass, that means that it supports and 
implements the behavior that the typeclass describes.

For example, if we have ask Haskell about `div` operator type.

```haskell
GHCi> :type div
div :: Integral a => a -> a -> a
```

Interesting. We see the `=>` symbol. Everything before the `=>` symbol is called a class constraint. 
We can read the previous type declaration like this: the `div` function takes any two values 
that are of the same type and returns a value of the same type. 
The type of those three values must be a member of the `Integral` class (this was the class constraint).

So, as `Int` and `Integral` types are part of the typeclass `Integral` they both implement the `div` operator.

<details>
    <summary>Toggle to see the Prelude Haskell class hierarchy</summary>
    <img src="Gif/classes.gif"/>
</details>

### Equality and order operators

For all commented basic types the following binary operators are defined, which return a boolean value:

| Operator |	Description |
|:----:|:---------:|
| > |	greater than |
| >= |	greater than or equal |
| < |	less than |
| <= |	less than or equal |
| == |	equal than |
| /= |	different than |

The type of the two arguments must be of the same type. We can not compare values of different types. Haskell will yield a type error match.

Examples:

```haskell
GHCi> 10 /= 10
False
GHCi> "hello" == "hello"
True
GHCi> True <= 'a'
<interactive>:6:8: error:
    • Couldn't match expected type ‘Bool’ with actual type ‘Char’
    • In the second argument of ‘(<)’, namely ‘'a'’
      In the expression: True < 'a'
      In an equation for ‘it’: it = True < 'a'
```

## Built-in type constructors

Haskell defines structured types that allow you to represent collections of objects.

### Tuples

A tuple is a composite data where the type of each component can be
distinct.

```text
If v1, v2, . . . ,vn are values with type t1, t2, . . . ,tn
then (v1, v2, . . . ,vn) is a tuple with type (t1, t2, . . . ,tn)
``` 

Examples:

```haskell
GHCi> :type ()
() :: ()
GHCi> :type ('a', False)
('a', False) :: (Char, Bool)
GHCi> :type ('a', False)
('a', False, 1.5) :: Fractional c => (Char, Bool, c)
```

### Lists

A list is a collection of zero or more elements, all of the same type.

There are two constructors for lists

- `[]` represents an empty list
- `(:)` it allows to add elements at the very beggining of a list

```text
If v1, v2, . . . , vn are values with type t
then v1 : (v2 : (. . . (vn−1 : (vn : [ ])))) is a list
with type [t]
```

Example:

```haskell
GHCi> :type []
[] :: [a]
GHCi> 1:[]
[1]
GHCi> 'a':(1:[])
<interactive>:20:6: error:
    • No instance for (Num Char) arising from the literal ‘1’
    • In the first argument of ‘(:)’, namely ‘1’
      In the second argument of ‘(:)’, namely ‘(1 : [])’
      In the expression: 'a' : (1 : [])
```

The constructor `(:)` is right associative:

```text
x1 : x2 : . . . xn−1 : xn : [ ] ===> x1 : (x2 : (. . . (xn−1 : (xn : [ ]))))
```

Haskell allows a more convenient syntax for lists:

```text
[x1, x2, . . . xn−1, xn] ===> x1 : (x2 : (. . . (xn−1 : (xn : [ ]))))
```

Example:

```haskell
GHCi> 1:(2:(3:[]))
[1,2,3]
GHCi> 1:2:3:[]
[1,2,3]
GHCi> [1,2,3]
[1,2,3]
```
