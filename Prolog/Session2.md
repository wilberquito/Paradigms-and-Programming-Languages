# Session 2

## Lists

In Prolog, a list is a built-in data structure that represents a sequence of elements of the same type. It is denoted by enclosing the elements
within square brackets `[]` and separating them by commas `,`.

For example, a list of integers `[1, 2, 3, 4]` represents a sequence of four integers, and a list of term-atoms `[a, b]` represents
a sequence of two term-atoms.

Lists in Prolog are also recursive data structures, which means that they can be defined in terms of themselves.
A list is either an empty list, represented as `[]`, or a non-empty list, represented as `[Head | Tail]`, where `Head` is the first element
of the list and `Tail` is the list that follows `Head`.

- The empty list is represented as `[]`.
- `[X|L]` represents a list with X as its head and L as its tail.
- `[X,Y|L]` represents a list with X and Y as its first two elements and L as its tail.
- `[X,Y,Z]` represents a list with three elements.

Unification examples with lists:

```prolog
[1,2,3] = [X,Y|L].
L=[3], X=1, Y=2
```

```prolog
[1,2,3] = [X,Y,Z|L].
L=[], X=1, Y=2, Z=3
```

```prolog
[1,2|3,4] = [X,Y|L].
L=[3,4], X=1, Y=2
```

```prolog
[1,2,3] = [X,Y,Z,T].
no
```

### List predicates

#### Member

```prolog
% member(X,L) => X appears in L.
member(X,[X|_]).
member(X,[_|XS]) :- member(X,XS).
```

The first clause `member(X,[X|_])` states that `X` is a member of the list if `X` is the first element of the list.

The second clause `member(X,[_|XS]) :- member(X,XS)` states that `X` is a member of the list if it is a member of the tail of the list. The `_` is used
to indicate that we do not care about the first element of the list, as we are only interested in the rest of the list. The second clause is a recursive definition. This continues until either `X` is found in the list or the end of the list is reached.

When the `member` predicate is called (recursive or not) with an empty list as the second argument, i.e., `member(X,[])`, the predicate will fail. This
is because the first clause only matches non-empty lists that start with `X`, and the second clause only matches non-empty lists where `X` is a member
of the tail. Since an empty list has no head or tail, neither of the clauses will match it. Therefore, when `member` is called with an empty list, Prolog will backtrack
and try to find an alternative solution if one exists. If no alternative solution is found, the predicate will simply fail.

What do you think Prolog will respond to the following questions?

```prolog
member(X,[1,2,3]).
```

```prolog
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
permutation(L,[X|Xs]) :- append(V,[X|P],L),
                         append(V,P,W),
                         permutation(W,Xs).
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

To evaluate arithmetic expressions you need to use the `is` predicate. Technically, if we have the following expression `E1 is E2`, `E1` **unifies with the arithmetic value** of `E2`. `E2` must be arithmetically evaluable.

The is operator can be used to perform basic arithmetic operations such as addition, subtraction, multiplication, and division.
It can also be used to evaluate more complex expressions involving multiple operations and parentheses.

```prolog
X is 3 * 4.
X = 12
```

Note that the `is` operator can only be used with variables on the left-hand side of the operator. And an evaluable arithmetic expression on the right hand.

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

Relational predicates like `<`, `=<`, `>`, `>=`, `=:=` and `=\=` evaluate both sides (as long as they are evaluable).

```prolog
2+2 =:= 9/2.
no
```

```prolog
2+2 =:= 9//2.
yes
```

```prolog
4 mod 2 >= 2+X.
Inst. error
```

```prolog
2+2 =\= 3+1.
no
```

Notice that the operators `=`, `==` and their negations (`\=`, `=\=`) are not the same. This expresion; `E1 = E2` means, `E1` unifies with `E2` and the expression `E1 == E2` means that they are the same terms.

```prolog
2+X=2+Y.
X=Y
```

```prolog
2+X==2+Y.
no
```

```prolog
2+X=2+X.
yes
```

```prolog
2+X==2+X.
yes
```

### Factorial predicate

The first clause, `fact(0,1)`, states that the factorial of 0 is 1. The base case.

The second line, `fact(N,F):- N>0, ...`, defines the recursive case for calculating the factorial of N. The N>0 condition ensures that the predicate only applies to positive integers.

The next line, Np is N-1, subtracts 1 from N and assigns the result to a new variable, Np.

The line `fact(Np,F1)` recursively calls the fact predicate with Np as the argument and assigns the result to F1.

Finally, the line `F is F1 * N` calculates the factorial of N by multiplying F1 (the factorial of N-1) by N.

Overall, this definition recursively calculates the factorial of a given positive integer N by multiplying it with the factorial of N-1 until it reaches the base case of 0, where the factorial is defined as 1.

```prolog
% fact(+N,F) => F is the factorial of N.
fact(0,1).
fact(N,F):- N>0,
            Np is N-1,
            fact(Np,F1),
            F is F1 * N.
```

The predicate `fact`, "does not go in both directions" because +N has to be a definite number due to the use of `is`.

```prolog
fact(3,6).
yes
```

```prolog
fact(3,F).
F=6
```

```prolog
fact(N,6).
Inst. error
```

## List and arithmetic

```prolog
% length(L,N) => N is the length of L.
length([],0).
length([_|Xs],N) :- length(Xs,Np), N is Np+1.
```

```prolog
% count(L,X,N) => N is the number of times that X appear in L.
count([],_,0).
count([X|Xs],X,N) :- count(Xs,X,Np), N is Np+1.
count([Y|Xs],X,N) :- X\=Y, count(Xs,X,N).
```

```prolog
% nessim(L,N,X) => X appear in the N position in L.
nessim([X|_],0,X).
nessim([_|Xs],N,X) :- N>0,
                      Np is N-1,
                      nessim(Xs,Np,X).
```

```prolog
% split(X,L,Min,Max) => Min are the elements of L minors than X, Max are the elements bigger than X
split( ,[],[],[]).
split(X,[Y|L],[Y|Mn],Mx) :- Y =< X, split(X,L,Mn,Mx).
split(X,[Y|L],Mn,[Y|Mx]):- Y > X, split(X,L,Mn,Mx).
```

```prolog
% quicksort(L1,L2) => L2 is the sorted list of L1.
quicksort([],[]).
quicksort([X|Xs],L) :- split(X,Xs,Min,Max),
                       quicksort(Min,MinOrd),
                       quicksort(Max,MaxOrd),
                       append(MinOrd,[X|MaxOrd],L).
```

## Your turn to practice (II)

- Implement the sum predicate

```prolog
% sum_(L,N) => N is the sum of numbers in L
sum_(L, N) :- ...
```

- Implement the sum evens predicate, you might need the operator [mod](https://www.swi-prolog.org/pldoc/man?function=mod%2f2)

```prolog
% sum_evens_(L,N) => N is the sum of the even numbers in L
sum_evens_(L,N) :- ...
```

- Implement the gcd predicate

```prolog
% gcd_(A, B, M) => M is the gcd_ (greatest common division) of A and B
gcd_(A, B, M) :- ...
```
