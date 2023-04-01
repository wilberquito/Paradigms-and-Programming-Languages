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

For GHCi, you use the `:q` command
to exit:

```haskell
$ ghci
GHCi> :q
Leaving GHCi.
```

Working with GHCi is much like working with interpreters in most interpreted programming languages such as Python and Node for JS.
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

We rather persist our code into files. The [`Main.hs`](Examples/Main.hs) Haskell module has the following code:

```haskell
main = print (fac 20)

fac 0 = 1
fac n = n * fac (n-1)
```

You can save `Main.hs` anywhere you like, but if you save it somewhere other than the current directory then you will need to change to the right directory in GHCi:

```haskell
GHCi> :cd dir
```

To load a Haskell source file into GHCi, use the `:load` command:

```haskell
GHCi> :load Main
Compiling Main             ( Main.hs, interpreted )
Ok, modules loaded: Main.
```

If you make some changes to the source code and want GHCi to recompile the program, use the `:reload` command. The program will be recompiled as necessary, with GHCi doing its best to avoid actually recompiling modules if their external dependencies haven’t changed.

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

### Haskell doesn't have

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

Everything in Haskell has a type, so the compiler can reason quite a lot about your program before compiling it, Unlike Java or C, Haskell has type inference. If we write a number, we don't have to tell Haskell it's a number. It can infer that on its own, so we don't have to explicitly write out the types of our functions and expressions to get things done.

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
there’s some function `f` that takes a parameter `x` and maps to a value `y`.
In mathematics, every `x` can map to one and only one `y`.

In mathematics the application of function is denotated with parenthesis.

```text
-- applies the function f to the parameters a and b
f (a, b) + c × d
```

In Haskell the function application is denotated by a space.

```haskell
-- same as f (a, b) + c × d
f a b + c * d
```

The application of functions has maximum priority.

```haskell
-- means (g a) + b and NO g (a + b)
g a + b
```

Compound arguments go between parentheses.

```haskell
-- applies f function to 2 arguments.
f (a + b) c
```

In Haskell functions are considered first-class citizens, which means they can be passed as arguments,
returned as values, and composed together to form more complex operations.

Example:

```haskell
map :: (a -> b) -> [a] -> [b]
map f []     = []
map f (x:xs) = f x : map f xs
```

Functions are pure, where its return value depends solely on its input parameters. In other words, functions
in Haskell don't produce side effects. Because functions are pure, formal verification is relatively easy.

Example:

```haskell
double :: Int -> Int
double x = x * 2
```

Curried functions, every function in Haskell only takes one parameter.
But wee saw functions that take more than one parameter so far, didn't wee?
Well, it's a clever trick!.

All the functions that accepted several parameters so far have been curried functions.
Currying is the process of transforming a function that takes multiple arguments,
into a function that takes just a single argument
and returns another function which accepts further arguments,
one by one, that the original function would receive.
This process is also known as `partial application`.

Example:

```haskell
GHCi> :t max
max :: Ord a => a -> a -> a
GHCi> max 4 5
5
GHCi> f = max 4
GHCi> :t f
f :: (Ord a, Num a) => a -> a
GHCi> f 5
5
```

Does other languages support this feature? the vast majority don't. For example, in JS you can emulate this.

Example:

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

> Saw in theory; reduction strategies (lambda-calcul-breu-pdf)

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
GHCi> 2
GHCi> mayHang (1 + 1) infiniteList
[1,2,3...]
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
your code and avoid repetition, for example, the following function takes two
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

Many languages use the `++` operator to increment a value; for example, `x++`
increments `x`. Do you think Haskell has an operator or function that works this way?

## Built-in types

Previously we mentioned that Haskell has a static type system.
The type of every expression is known at compile time, which leads to safer code.
If you write a program where you try to divide a boolean type with some number, it won't even compile.

### What are types by the way?

Intuitively, we can think of types as sets of values and a set of allowed operations on those values.

### Syntax of types

|       Type        |          Literals          |                                  Use                                   |                  Operations                   |
| :---------------: | :------------------------: | :--------------------------------------------------------------------: | :-------------------------------------------: |
|        Int        |          1, 2, -3          |                      Number type (signed, 64bit)                       |       +, -, \*, div, mod, fromIntegral        |
|      Integer      | 1, -2, 900000000000000000  |                         Unbounded number type                          | +, -, \*, div, mod, fromInteger, fromIntegral |
|       Float       |         0.1, 1.2e5         |                         Floating point numbers                         |               +, -, \*, /, sqrt               |
|      Double       |         0.1, 1.2e5         | Floating point numbers. Aproximations are more precise than Float type |               +, -, \*, /, sqrt               |
|       Bool        |        True, False         |                              Truth values                              |           &&, \|\|, not, otherwise            |
|       Char        | 'a', 'Z', '\n', '\t', '\\' |  Represents a character (a letter, a digit, a punctuation mark, etc)   | ord, chr, isAlpha, isDigit, isUpper, isLower  |
| String aka [Char] |         "abcd", ""         |                         Strings of characters                          |                  reverse, ++                  |

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

So, as `Int` and `Integer` types are part of the typeclass `Integral` they both implement the `div` operator.

<details>
    <summary>Toggle to see the Prelude Haskell class hierarchy</summary>
    <img src="Gif/classes.gif"/>
</details>

### Equality and order operators

For all commented basic types the following binary operators are defined, which return a boolean value:

| Operator |      Description      |
| :------: | :-------------------: |
|    >     |     greater than      |
|    >=    | greater than or equal |
|    <     |       less than       |
|    <=    |  less than or equal   |
|    ==    |      equal than       |
|    /=    |    different than     |

The type of the two arguments must be of the same type. We can not compare values of different types. Haskell will yield a type error match.

Example:

```haskell
GHCi> 10 /= 10
False
GHCi> "hello" == "hello"
True
GHCi> True < 'a'
<interactive>:6:8: error:
    • Couldn't match expected type ‘Bool’ with actual type ‘Char’
    • In the second argument of ‘(<)’, namely ‘'a'’
      In the expression: True < 'a'
      In an equation for ‘it’: it = True < 'a'
```

## Type constructor


It is possible to declare the type corresponding to the different functions. For it
we have a single constructor: `->`. Type constructor is right associative.

```text
If t1, t2, . . . , tn, tr are valid types then t1->t2-> . . . tn->tr is the type
of a function with n arguments. The type of the result is tr

If t1, t2, . . . , tn, tr are valid types then t1->(t2->( . . . (tn->tr))) is the type
of a function with n arguments. The type of the result is tr
```

Example:

```haskell
inc :: Integer -> Integer
inc x = x + 1

sumSquares :: Integer -> Integer -> Integer
sumSquares x y = x^2 + y^2
```

```haskell
GHCi> f = sumSquares (inc 2)
GHCi> f 2
13
```

## Pattern matching

Pattern matching consists of specifying patterns to which some data should
conform and then checking to see if it does and deconstructing the data according to those patterns.

When defining functions, you can define separate function bodies for different patterns.
This leads to really neat code that's simple and readable.
You can pattern match on any data type — numbers, characters, lists, tuples, etc.

Example:

```haskell
lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER SEVEN!"
lucky x = "Sorry, you're out of luck, pal!"
```

When you call lucky, the patterns will be checked from top to bottom and when it conforms to a pattern,
the corresponding function body will be used. The only way a number can conform to the first
pattern here is if it is 7. If it's not, it falls through to the second pattern, which matches anything and binds it to x.

Note that if we move the last pattern (the catch-all one) to the top it would always say "Sorry, you're out of luck, pal!"
because it would catch all the numbers and they wouldn't have a chance to fall through and be checked for any other patterns.

Note also that if we remove the pattern (the catch-all one), the pattern match(es)
are non-exhastive for the function `lucky`
meaning that for some values the function's behaviour is not specified.

Example:

```haskell
lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER SEVEN!"
```

```haskell
GHCi> lucky 14
*** Exception: Lucky.hs: Non-exhaustive pattern in function lucky
```

When making patterns, we should always include a catch-all pattern so that our program doesn't crash if we get some unexpected input.

## Tuples

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
GHCi> :type ('a', False, 1.5)
('a', False, 1.5) :: Fractional c => (Char, Bool, c)
```

## Lists

A list is a collection of zero or more elements, all of the same type.

There are two constructors for lists

- `[]` represents an empty list
- `(:)` it allows to add elements at the very beggining of a list

```text
If v1, v2, . . . , vn are values with type t then
v1 : (v2 : (. . . (vn−1 : (vn : [])))) is a list with type [t]
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
x1 : x2 : . . . xn−1 : xn : [] ===> x1 : (x2 : (. . . (xn−1 : (xn : []))))
```

Haskell allows a more convenient syntax for lists:

```text
[x1, x2, . . . xn−1, xn] ===> x1 : (x2 : (. . . (xn−1 : (xn : []))))
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

Lists themselves can also be used in pattern matching. You can match with the empty list `[]`
or any pattern that involves `:`.

A pattern like `x:xs` will bind the head of the list to `x` and the rest of
it to `xs`, even if there's only one element so `xs` ends up being an empty list.

Example:

```haskell
head' :: [a] -> a
head' [] = error "Can't call head on an empty list, dummy!"
head' (x:_) = x
```

## The underlined pattern

- It take the form `_`
- Unify with any argument
- They don't produce binding

Example:

```haskell
-- number of elements from a list of Int
length :: [Int] -> Int
length [] = 0
length (_:xs) = 1 + length xs
```

## Nested patterns

It's allowed neested patterns

Example:

```haskell
-- function that sums all elements from a list of tuples
sumPairs :: [(Integer, Integer)] -> Integer
sumPairs [] = 0
sumPairs ((x,y):xs) = x + y + sumPairs(xs)
```

## The if-else expression

```haskell
if boolExpression then ifExpression else noExpression
```

- The type of *boolExpression* must be `Bool`
- The types of *ifExpression* and *noExpression* must be the same
- The else part is mandatory
- The evaluation is lazy

Example:

```haskell
-- a function that multiplies a number by 2 but only
-- if that number is smaller than or equal to 100
-- because numbers bigger than 100 are big enough as it is!
doubleSmallNumber x = if x > 100
                        then x
                        else x*2

-- a function that multiplies a number by 2 but only
-- if that number is smaller than or equal to 100
-- because numbers bigger than 100 are big enough as it is!.
-- Adds 1
doubleSmallNumber' x = (if x > 100 then x else x*2) + 1
```

## Guards, guards

Whereas patterns are a way of making sure a value conforms to some form and deconstructing it, guards are a way of testing whether some property of a value (or several of them) are true or false.

- The expressions between the symbols `| y =` are called guards (type Bool)
- The result corresponding to the first true guard is returned
- Many times, the last guard is `otherwise`. Otherwise is a function that always evaluate to `True` and catches everything.

Example:

```haskell
GHCi> :type otherwise
otherwise :: Bool
GHCi> otherwise
True
```

```haskell
bmiTell :: (RealFloat a) => a -> String
bmiTell bmi
    | bmi <= 18.5 = ":/"
    | bmi <= 25.0 = ":D"
    | bmi <= 30.0 = ":)"
    | otherwise   = ":/"
```

## Case expression

```haskell
case expression of pattern -> result
                   pattern -> result
                   pattern -> result
                   ...
```

It allow us evaluate expressions based on the possible cases of
the value of a variable, and we can also do pattern matching on them.
If non pattern unifies it throws an error.

- The expression and all patterns must have the same type
- Every result must have the same type

Example:

```haskell
head' :: [a] -> a
head' xs = case xs of [] -> error "No head for empty lists!"
                      (x:_) -> x

describeList :: [a] -> String
describeList xs = "The list is " ++ case xs of [] -> "empty."
                                               [x] -> "a singleton list."
                                               xs -> "a longer list."
```

## Your turn to practice

### Power

```haskell
-- Ex 1: power n k should compute n to the power k (i.e. n^k)
-- Use recursion.

power :: Integer -> Integer -> Integer
. . .
```

### Euclidian distance

```haskell
-- Ex 2: define the function distance. It should take four arguments of
-- type Double: x1, y1, x2, and y2 and return the (euclidean) distance
-- between points (x1,y1) and (x2,y2).
--
-- Give distance a type signature, i.e. distance :: something.
--
-- PS. if you can't remember how the distance is computed, the formula is:
--   square root of ((x distance) squared + (y distance) squared)
-- Haskell implements the function `abs` which compute the absolute value of a number.
-- You might prefer use the  `where` code block to declare variables.
--
-- Examples:
--   distance 0 0 1 1  ==>  1.4142135...
--   distance 1 1 4 5  ==>  5.0

distance :: something
. . .
```

### Add three

```haskell
-- Ex 3. Define the function `addThree` of type Int -> Int -> Int -> Int
-- to define `addThree` you previously should define the `add`
-- function of type Int -> Int -> Int. Use `add` to define `addThree`.
--
-- PS. the sum (+) haskell operator has the type Num a => a -> a
--
-- Examples:
--  addThree 2 2 3 ==> 7

addThree :: Int -> Int -> Int -> Int
. . .
```

### nSum

```haskell
-- Ex 4. define the function nSum. It should take an argument of
-- type Num a => [a] and returns the sum of all elements in the list
-- Use recursion.
--
-- PS. the sum (+) haskell operator has the type Num a => a -> a
--
-- Examples:
--  nSum [1,3,6] ==> 10

nSum :: Num a => [a] -> a
. . .
```

### Postage price

```haskell
-- Ex 5: A postal service prices packages the following way.
-- Packages that weigh up to 500 grams cost 250 credits.
-- Packages over 500 grams cost 300 credit + 1 credit per gram.
-- Packages over 5000 grams cost a constant 6000 credits.
--
-- Write a function postagePrice that takes the weight of a package
-- in grams, and returns the cost in credits.
--
-- Use guards.

postagePrice :: Int -> Int
. . .
```

### Intepreter

```haskell
-- Ex 6: in this exercise you get to implement an interpreter for a
-- simple language. You should keep track of the x and y coordinates,
-- and interpret the following commands:
--
-- up -- increment y by one
-- down -- decrement y by one
-- left -- decrement x by one
-- right -- increment x by one
-- printX -- print value of x
-- printY -- print value of y
--
-- The interpreter will be a function of type [String] -> [String].
-- Its input is a list of commands, and its output is a list of the
-- results of pthe print commands in the input.
--
-- PS. You might need the function `show`
-- the function `show` has type: Show a => a -> String
-- Numbers are part of the Show category so they implement the
-- function show that transforms numbers to strings
--
-- Both coordinates start at 0.
--
-- Examples:
--
-- interpreter ["up","up","up","printY","down","printY"] ==> ["3","2"]
-- interpreter ["up","right","right","printY","printX"] ==> ["1","2"]
--
-- Surprise! after you've implemented the function, try running this in GHCi:
--     interact (unlines . interpreter . lines)
-- after this you can enter commands on separate lines and see the
-- responses to them
--
-- The suprise will only work if you generate the return list directly
-- using (:). If you build the list in an argument to a helper
-- function, the surprise won't work.

interpreter :: [String] -> [String]
. . .
```
