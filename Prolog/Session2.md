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

#### Member

The first clause `member(X, [X|_])` states that `X` is a member of the list if `X` is the first element of the list.

The second clause `member(X, [_|XS]) :- member(X, XS)` states that `X` is a member of the list if it is a member of the tail of the list. The `_` is used 
to indicate that we do not care about the first element of the list, as we are only interested in the rest of the list. The second clause is a recursive definition. This continues until either `X` is found in the list or the end of the list is reached. 

When the `member` predicate is called (recursive or not) with an empty list as the second argument, i.e., `member(X, [])`, the predicate will fail. This 
is because the first clause only matches non-empty lists that start with `X`, and the second clause only matches non-empty lists where `X` is a member 
of the tail. Since an empty list has no head or tail, neither of the clauses will match it. Therefore, when `member` is called with an empty list, Prolog will backtrack 
and try to find an alternative solution if one exists. If no alternative solution is found, the predicate will simply fail.

```prolog
% member(X,L) => X appears in L.
member(X, [X|_]).
member(X, [_|XS]) :- member(X, XS).
```

What do you think Prolog will respond to this questions?

```prolog
member(X, [1,2,3]).
member(1, X). % this one is tricky
```

#### Remove

Let's define a predicate that remove all occurrences of a given element X from a list.

The predicate has three clauses:

The first clause `remove(_, [], [])` states that if the input list is empty, then the output list is also empty.

The second clause `remove(X, [X|L1], L2) :- remove(X, L1, L2)` states that if `X` is the head of the input list, then we remove it and continue 
recursively with the tail `L1` to produce the output list `L2`.

The third clause `remove(X, [Y|L1], [Y|L2]) :- remove(X, L1, L2)` states that if `X` is not the head of the input list, then we keep the head `Y`
and continue recursively with the tail `L1` to produce the output list `L2`.

Together, the three clauses cover all possible cases for removing all occurrences of an element `X` from a list.

Note: that this predicate will remove all occurrences of `X` from the input list, not just the first occurrence. 
If the input list does not contain `X`, then the predicate will return the input list unchanged as the output list.

```prolog
% remove(X,L1,L2) => L2 is L1 without X.
remove(_, [], []).
remove(X, [X|L1], L2) :- remove(X, L1, L2).
remove(X, [Y|L1], [Y|L2]) :- remove(X, L1, L2).
```
What happend if you ask more than one solution?

```prolog
remove(1, [1,2,1], L).
```

