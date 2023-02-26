# Session 2

## Lists

In Prolog, a list is a built-in data structure that represents a sequence of elements of the same type. It is denoted by enclosing the elements 
within square brackets `[]` and separating them by commas `,`.

For example, a list of integers `[1, 2, 3, 4]` represents a sequence of four integers, and a list of term-atoms `[a, b]` represents 
a sequence of two term-atoms.

Lists in Prolog are also recursive data structures, which means that they can be defined in terms of themselves. 
A list is either an empty list, represented as `[]`, or a non-empty list, represented as `[Head | Tail]`, where 'Head' is the first element 
of the list and 'Tail' is the rest of the list.

- The empty list is represented as `[]`.
- `[X|L]` represents a list with X as its head and L as its tail.
- `[X,Y|L]` represents a list with X and Y as its first two elements and L as its tail.
- `[X,Y,Z]` represents a list with three elements.

Examples:

```prolog
[1,2,3] = [X,Y|L].
% L=[3], X=1, Y=2
[1,2,3] = [X,Y,Z|L].
% L=[], X=1, Y=2, Z=3
[1,2,3] = [X,Y,Z,T].
% no
```

### List predicates

#### The member predicate.

The first clause `member(X,[X|_])` states that `X` is a member of the list if `X` is the first element of the list.

The second clause `member(X,[_|XS]) :- member(X,XS)` states that `X` is a member of the list if it is a member of the tail of the list. The `_` is used 
to indicate that we do not care about the first element of the list, as we are only interested in the rest of the list.

The second clause is recursive. This continues until either `X` is found in the list or the end of the list is reached. 
When the `member` predicate is called (recursive or not) with an empty list as the second argument, i.e., `member(X,[])`, the predicate will fail. This 
is because the first clause only matches non-empty lists that start with `X`, and the second clause only matches non-empty lists where `X` is a member 
of the tail. Since an empty list has no head or tail, neither of the clauses will match it. Therefore, when `member` is called with an empty list, Prolog will backtrack 
and try to find an alternative solution if one exists. If no alternative solution is found, the predicate will simply fail.

```
% member(X,L) => X appears in L.
member(X,[X|_]).
member(X,[_|XS]) :- member(X,XS).
```
