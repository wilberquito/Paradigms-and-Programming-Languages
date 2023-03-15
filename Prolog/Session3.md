# Session 3

## Let's recap

Before digging in the topics of this session, remember:

- Prolog works by answering queries with respect to a knowledge base
- A Prolog knowledge (or database) comprises clauses that are either rules or facts
- Rules introduce new possible queries (due to resolution)
- Facts lead to positive answers
- A query with variables for which Prolog returns a positive answer, will also instantiate the
  variable with values that make the query true
- Queries on non defined knowledge or a piece of information that can not be deduced simply fails (due to "Closed World Assumption")

## Search Tree

Prolog’s backbone is based on a depth-first search strategy that operates on facts and rules
declared in a database. This sounds harmless, but it is not always straightforward to predict how a Prolog program behaves
in response to a certain query given to it. The best way to find out how Prolog reacts to a query, 
given a certain knowledge base, is to draw its search tree.
 
A search tree shows the way Prolog finds an answer to a query. It shows all the steps
of reasoning to come to an answer, so you may also call it a *proof tree*, using more logical
terminology.

### A first example

```prolog
q(X):- p(X).
q(0).

p(X):- a(X), b(X).
p(1).

a(2).
a(3).

b(2).
b(2).
b(3).
```

Let's see how the search tree is generated for the query:

```prolog
?- q(X).
```

The corresponding search tree.

```text
                  [q(X)]
                  /    \
            X=X' /      \ X=0
                /        \
             [p(X')]      []
             /     \ 
     X'=X'' /       \ X'=1
           /         \
    [a(X''),b(X'')]   []
        /     \
 X''=2 /       \ X''=3
      /         \
   [b(2)]      [b(3)]
   /    \         \
  /      \         \
 []      []        []
```

Sometimes variables need to be renamed when drawing a search tree. This is required when there is a variable occuring 
in a query that is also used in the rule. In the tree above the renaming is represented as  `X'=X''`. 
Notice also that you could  chose `X1, X2` or other variables for renaming.

The solutions are enumerated from the left to the right and are reconstruted by means of substitution composition, e.g.: `{X'' -> 2}∘{X' -> X''}∘{X -> X'}` hence `X -> 2`, the solutions are `X=2, X=2, X=3, X=1, X=0`.

### A second example

Do you remember de predicate `member`?

```prolog
% member(A,B), element A occurs in list B
member(X,[X|_]).
member(X,[_|L]):- member(X,L).
```

Let's see how the search tree is generated for the query:

```prolog
?- member(X,[a,b,c]).
```

The corresponding search tree.

```text
 [member(X,[a,b,c])]
      /     \
 X=a /       \ X=X'
    /         \
  []      [member(X',[b,c])]
               /     \
        X'= b /       \ X'= X''
             /         \
           []    [member(X'',[c])]
                      /     \
              X''= c /       \ X''=X'''
                    /         \
                  []     [member(X''',[])]
                              /     \   
                             /       \
                            *         * 
```

This query has tree solutions. `X=a, X=b` (because `X=X'` and `X'=b`), and `X=c` (because `X=X'` and `X'=X''` and `X''=c`).

## Control over the search tree

Prolog is  highly declarative. However declarativity has sometimes a significant computational cost.

The order and the repetition of clauses can lead to redundancies in answers and in failures. 

Problems we want to solve:

- Inefficiency
- Unspecified behaviors

Prolog has a built-in predicate named cut `!` that allows us to control the search tree by means of prunning redundant or unnecessary branches.

### The cut

The cut `!` is a predicate that always succeeds. But it has an extremely useful
side-effect: it cuts open branches from the search tree, 
thereby giving direct control in the search tree exploration.
Cuts are used to make Prolog programs efficient. This often goes at the cost of
making Prolog programs less declarative and readable.

Cut always succeeds and causes the discard of all alternative (branches) that were pending
to be explored from the moment it (the cut) was used to resolve the rule containing the cut.

```text
[!]      [!,Q]
 |         |
 |         |
 []       [Q]
```

Given a clause:

```text
A:- B1,...,Bk,!,Bk+1,...,Bn.
A:- (alternative branch for G)
A:- (alternative branch for G)
...
```

such that `A` unifies with the objective `G` we want to solve at a certain moment of the search, and `B1,...,Bk` are already satisfied, the cut is automatically satisfied and its effect is:

1) Any other clause that  could be applied to resolve `G` is ignored, i.e. those alternative branches are discarted for possible backtracking. 
2) If the attempt to satisfy any `Bi` among `Bk+1,...,Bn` fails,  BACKTRAKING is allowed until the cut, 
3) if it is necessary to redo the cut, it goes back to the previous choice of `G` and performs backtracking from there. Meaning that Prolog  won't attemp to satisfy again any `Bi` among `B1,..,Bk` or alternative branches prunned in 1).
  
Let's see how the cut performs in the first example.

Definition of the base knowledge.

```prolog
q(X):- p(X).
q(0).

p(X):- a(X), !, b(X).
p(1).

a(2).
a(3).

b(2).
b(2).
b(3).
```

Comparation between the pruned tree and the original tree from the first example.

```text
                 (pruned)                    (original)
                 
                  [q(X)]                       [q(X)]
                  /    \                       /    \ 
            X=X' /      \ X=0            X=X' /      \ X=0
                /        \                   /        \
             [p(X')]      []              [p(X')]      []
             /     \                      /     \ 
     X'=X'' /      ---            X'=X'' /       \ X'=1
           /                            /         \
   [a(X''),!,b(X'')]             [a(X''),b(X'')]   []
        /     \                     /     \
 X''=2 /      ---            X''=2 /       \ X''=3
      /                           /         \
  [!,b(2)]                     [b(2)]      [b(3)]
   /    \                      /    \         \
  /      \                    /      \         \
 []      []                  []      []        []
```

Changing a little bit the code, the solutions now are `X=2, X=2, X=0`.

### Factorial and cut

```prolog
% fact(+N,F) => F is the factorial of N
fact(0,1).
fact(N,F):- Np is N-1,
            fact(Np,F1),
            F is F1 * N.

% nums(X) => X is a natural number. Starts with 0.
nums(0).
nums(X):- nums(Xp), X is Xp+1.

% findf(X,+Y) => X factorial is bigger than Y.
findf(X,Y):- nums(X), fact(X,Z), Z>Y.
```

What do you think that happend with the following query?

```prolog
?- findf(X,2).
```

A possible solution is to cut the altenative clause when `fact(0,1)` is satisfied.

```prolog
% fact(+N,F) => F is the factorial of N
fact(0,1):- !.
fact(N,F):- Np is N-1,
            fact(Np,F1),
            F is F1 * N.
```

Or control the satisfiability of the second clause adding the constraint `N>0`. As we have seen in the previous session.

```prolog
% fact(+N,F) => F is the factorial of N
fact(0,1).
fact(N,F):- N>0,
            Np is N-1,
            fact(Np,F1),
            F is F1 * N.
```

### Sort and cut

```prolog
% sorted(L) => L is ascending sorted
sorted([]).
sorted([_]).
sorted([X,Y|Zs]):- X=<Y, 
                   sorted([Y|Zs]).

% sort(X,Y) => Y is the result of sort X.
sort(Xs,Xs):- sorted(Xs), !.
sort(Xs,Ys):- append(As,[X,Y|Ns],Xs), 
              X>Y, !,
              append(As,[Y,X|Ns],Xs1), 
              sort(Xs1,Ys).
```

The first cut tells us "there is only one order, so there is no need to check if I can order in a different way".

The second cut tells us, "if you find a pair of elements unordered,  there is 
no need to try to leave them for late because these must be ordered".

## Terms, program with unification

Prolog does not allow us to create new types. To create a new type, we need to define the behavior of the terms.

```prolog
% buidtree(N,A,B,T) => T is the tree with node N, A as left son, B as right son.
bluidtree(N,T1,T2,tree(N,T1,T2)).

% node(T,N) => N is the root of the tree T.
node(tree(N,_,_),N).

% ls(T,T1)/rs(T,T2) => T1/T2 left son/right son.
ls(tree(_,T1,_),T1).
rs(tree(_,_,T2),T2).

% preorder(T,L) => L is the preorder of T.
preorder(tree(N,T1,T2),[N|L]):-  preorder(T1,L1),
                                 preorder(T2,L2),
                                 append(L1,L2,L).
preorder(tempty,[]).
```

Example:

```prolog
?- 
| bluidtree(1,tempty,tempty,T1), 
| bluidtree(3,tempty,tempty,T2), 
| bluidtree(2,T1,T2,T), 
| preorder(T,P).
T1 = tree(1, tempty, tempty),
T2 = tree(3, tempty, tempty),
T = tree(2, tree(1, tempty, tempty), tree(3, tempty, tempty)),
P = [2, 1, 3].
```

##  Negation as failure

In Prolog, a negated query `Q` is written as `not(Q)` or `\+Q`. A negated query succeeds if an attempt
to falsify it fails. This is called *negation as failure*. In other words, in Prolog, what cannot be proved to be true is false (Closed World Assumption).

Prolog's negation makes use of the cut `!` and the built-in predicate `fail` (always fail). When used, it creates
two new branches in the tree. In the first branch the query in the scope is placed followed by the
cut and fail predicate. The second branch succeeds (but it will be cut from the tree in case the query
of the first branch succeeds).

```prolog
          [\+p(X)]               [\+p(X),Q]
          /     \                 /      \
         /       \               /        \
        /         \             /          \
  [p(X),!,fail]   []      [p(X),!,fail]    [Q]
```

## I/O, cut and arithmetic

```prolog
% repeat => a built-in predicate that always satisfy.
repeat.
repeat:- repeat.

% read_number(X) => X is a number read from the keyboard.
read_number(X):-  repeat, 
                  write("PSS. enter a number: "),
                  read(X), 
                  number(X), !.
              
% treat_number(X) => If X is 0 then satisfy otherwise 
% the square of the number is computed and then fail,
treat_number(0):- !.
treat_number(X):- R is X*X, 
                  writeln([X, '^ 2=', R]), 
                  fail.

% squares => Read integers and show the square of the numbers
% until a 0 is reached.
squares:- repeat, 
          read_number(X), 
          treat_number(X), !.
```

## It's your turn to practice

Try to implement the cut in your solutions for the following predicates.

### Rang

```prolog
% rang(B,D,L) => L is the list of numbers from B to D. B < D.
rang(B,D,L):- ...
```

### Dice

The list L expresses a way to add P points by discarding N
dice So if P is 5 and N is 2, a solution of L would be [1,4]; the rest of the solutions
would be [3,2], [4,1] and [2,3]. Note that the length of the lists is 2. P and N have
to be initially instantiated.

```prolog
% dice(P,N,L) => L is a list and a way to express the sum of P rolling N dices
dice(P,N,L):- ...
```

### Indexes

```prolog
% indexes(X,L,O) where O is the list of positions in L where X appears.
% For example, if X is 1 and L is [1,2,1] the solution would be [0,2].
indexes(X,L,O):- ...
```

### Echo

Create the predicate echo, that takes a list of numbers and first prints the even numbers and then the odd numbers, for example:

```prolog
?- echo([1,2,3,4,5]).
Printing evens
2
4
Printing odds
1
3
5
true.
```

```prolog
% echo(L) => L is the list to be printed
echo(L):- ...
```
