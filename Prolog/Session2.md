# Session 2

## Lists

In Prolog, a list is a built-in data structure that represents a sequence of elements of the same type. It is denoted by enclosing the elements 
within square brackets `[ ]` and separating them by commas `,`.

For example, a list of integers `[1, 2, 3, 4]` represents a sequence of four integers, and a list of term-atoms `[a, b, c, d]` represents 
a sequence of four atoms.

Lists in Prolog are also recursive data structures, which means that they can be defined in terms of themselves. 
A list is either an empty list, represented as `[]`, or a non-empty list, represented as `[Head | Tail]`, where 'Head' is the first element 
of the list and 'Tail' is the rest of the list.

List key points:

- The empty list is represented as `[ ]`.
- `[X|L]` represents a list with X as its head and L as its tail.
- `[X,Y|L]` represents a list with X and Y as its first two elements and L as its tail.
- `[X,Y,Z]` represents a list with three elements.

Examples:

```prolog
[1,2,3]=[X,Y|L].
% L=[3], X=1, Y=2
[1,2,3]=[X,Y,Z|L].
% L=[], X=1, Y=2, Z=3
[1,2,3]=[X,Y,Z,T].
% no
```
