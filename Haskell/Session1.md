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

What does haskell has?

- Lazy evaluation: hat means that unless specifically told otherwise, 
Haskell won't execute functions and calculate things until it's really forced to show you a result. 
That goes well with referential transparency and it allows you to think of programs as a series of transformations
on data. It also allows cool things such as infinite data structures. 

Infinite list

```haskell
infiniteList :: [Int]
infiniteList = [1..]
```
