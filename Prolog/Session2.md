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
L=[3], X=1, Y=2
```

```prolog
[1,2,3] = [X,Y,Z|L].
L=[], X=1, Y=2, Z=3
```

```prolog
[1,2,3] = [X,Y,Z,T].
no
```

### List predicates

#### Member

The first clause `member(X,[X|_])` states that `X` is a member of the list if `X` is the first element of the list.

The second clause `member(X,[_|XS]) :- member(X,XS)` states that `X` is a member of the list if it is a member of the tail of the list. The `_` is used
to indicate that we do not care about the first element of the list, as we are only interested in the rest of the list. The second clause is a recursive definition. This continues until either `X` is found in the list or the end of the list is reached.

When the `member` predicate is called (recursive or not) with an empty list as the second argument, i.e., `member(X,[])`, the predicate will fail. This
is because the first clause only matches non-empty lists that start with `X`, and the second clause only matches non-empty lists where `X` is a member
of the tail. Since an empty list has no head or tail, neither of the clauses will match it. Therefore, when `member` is called with an empty list, Prolog will backtrack
and try to find an alternative solution if one exists. If no alternative solution is found, the predicate will simply fail.

```prolog
% member(X,L) => X appears in L.
member(X,[X|_]).
member(X,[_|XS]) :- member(X,XS).
```

What do you think Prolog will respond to this questions?

```prolog
member(X,[1,2,3]).
member(1,X). % this one is tricky
```

#### Remove

Let's define a predicate that remove all occurrences of a given element X from a list.

The predicate has three clauses:

The first clause `remove(_,[],[])` states that if the input list is empty, then the output list is also empty.

The second clause `remove(X,[X|L1],L2) :- remove(X,L1,L2)` states that if `X` is the head of the input list, then we remove it and continue
recursively with the tail `L1` to produce the output list `L2`.

The third clause `remove(X,[Y|L1],[Y|L2]) :- remove(X,L1,L2)` states that if `X` is not the head of the input list, then we keep the head `Y`
and continue recursively with the tail `L1` to produce the output list `L2`.

Together, the three clauses cover all possible cases for removing all occurrences of an element `X` from a list.

Note: that this predicate will remove all occurrences of `X` from the input list, not just the first occurrence.
If the input list does not contain `X`, then the predicate will return the input list unchanged as the output list.

```prolog
% remove(X,L1,L2) => L2 is L1 without X.
remove(_,[],[]).
remove(X,[X|L1],L2) :- remove(X,L1,L2).
remove(X,[Y|L1],[Y|L2]) :- remove(X,L1,L2).
```

What happend if you ask more than one solution?

```prolog
remove(1,[1,2,1],L).
```

#### Append

The predicate is used to concatenate two lists, where the third argument is the result of appending the first two arguments together.

The predicate has two clauses:

The first clause `append([],Ys,Ys)` states that if the first argument is an empty list, then the result is the second argument.

The second clause `append([X|Xs],Ys,[X|Zs]) :- append(Xs,Ys,Zs)` states that if the first argument is a non-empty list with head `X` and tail `Xs`,
then the result is the list that starts with `X` and continues with the concatenation of `Xs` and `Ys`, which is represented by the variable `Zs`.
This clause is defined recursively by calling `append` on the tail `Xs`, the second argument `Ys`, and the variable `Zs`.

```prolog
append([],Ys,Ys).
append([X|Xs],Ys,[X|Zs]) :- append(Xs,Ys,Zs).
```

Example:

```prolog
append([1,2],[3,4], L). % L = [1,2,3,4]
append([1,2],[], L). % L = [1,2]
append([],[], L). % L = []
```

The `append` predicate is really useful, it allows us define other predicates.

```prolog
% member(X,L) => X in L
member(X,L) :- append(_,[X|_],L).
```

```prolog
% permutation(L1,L2) => L2 is a permutation of L1.
permutation([],[]).
permutation(L,[X|Xs]) :- append(V,[X|P],L), append(V,P,W), permutation(W,Xs).
```

```prolog
% reverse(L,In) => In is L reversed.
reverse([],[]).
reverse([X|Xs],In) :- reverse(Xs,Ps), append(Ps,[X],In).
```

```prolog
% prefix(P,L) => P is prefix of L.
prefix(P,L) :- append(P,_,L).
```

```prolog
% suffix(S,L) => S is suffix of L.
suffix(S,L) :- append(_,S,L).
```

## Your turn to practice (I)

- Implement the sublist predicate

```prolog
% sublist_(Lp, L) => Lp is a sublist of L
sublist_(Lp, L) :- ...
```

- Implement the palindrom predicate

```prolog
% palindrome_(L) => true if L is a palindrome
palindrome_(L) :- ...
```

- Implement the insert predicate

```prolog
% insert_(X, Xs, Ys) => Ys is the resulting list of inserting X into the sorted ascending Xs list
insert_(X, Xs, Ys) :- ...
```

- Implement the sort predicate

```prolog
% sort_insert_(L, Ls) => Ls is the sorted list of L. Use the insert predicate already defined to solve it
sort_insert_(L, Ls) :- ...
```

- Implement the union predicate

```prolog
% union_(Xs, Ys, Zs) => Zs is the union of the sets Xs and Ys. Zs can be a multiset
union_(Xs, Ys, Zs) :- ...
```

- Implement the intersection predicate

```prolog
% intersection_(Xs, Ys, Zs) => Zs is the intersection of the sets Xs and Ys. Zs can be a multiset
intersection_(Xs, Ys, Zs) :- ...
```

- Implement the difference predicate, you might find interesting the predicate [substract](https://www.swi-prolog.org/pldoc/doc_for?object=subtract/3) to solve the problem

```prolog
% difference_(Xs, Ys, Zs) => Zs is the complement of the intersection of Xs and Ys.
difference_(Xs, Ys, Zs) :- ...
```

- Implement the multiset to set predicate, you might find interesting the predicate [sort](https://www.swi-prolog.org/pldoc/man?predicate=sort/2) to solve the problem

```prolog
% multiset_to_set_(Xs, Zs) => Zs is Xs without repetitions.
multiset_to_set_(Xs, Zs) :- ...
```

## Arithmetic

Remember, in Prolog all data structures are terms, numbers like `33, -2, 2.3` are terms and expressions arithmetics like
`3+3, 33*3+1...`, are also terms.

```prolog
4 = 2+2.
no
```

```prolog
X = 2+2.
X = 2+2
```

To evaluate arithmetic expressions you need to use the `is` predicate. Technically, if we have the following expression `E1 is E2`, `E1` unifies with
*the arithmetic value* of `E2`. `E2` must be arithmetically evaluable.

The is operator can be used to perform basic arithmetic operations such as addition, subtraction, multiplication, and division.
It can also be used to evaluate more complex expressions involving multiple operations and parentheses.

```prolog
X is 3 + 4.
X = 7
```

```prolog
Y is X * 2.
Y = 14
```

```prolog
Z is (X + Y) / 2.
Z = 10.5
```

Note that the is operator can only be used with variables on the left-hand side of the operator. And an evaluable arithmetic expression on the right hand.

```prolog
2+2 is 4.
no
```

```prolog
4 is X.
Inst. error
```

```prolog
4 is 2+X.
Inst. error
```
