# Session 3

## Let's recap

Before digging in the topics of this session, remember:

- Prolog works by answering queries with respect to a knowledge base
- A Prolog knowledge (or database) comprises clauses that are either rules or facts
- Rules introduce new possible queries
- Facts lead to positive answers
- A query with variables for which Prolog returns a positive answer, will also instantiate the
  variable with values that make the query true
- Queries on non defined knowledge or a piece of information that can not be deduced simply fails

## Search Tree

Prolog’s backbone is based on a depth-first search strategy that operates on facts and rules
declared in a database. This sounds harmless, but it is not always straightforward to predict how a Prolog program behaves
in response to a certain query given to it. The best way to find out how Prolog reacts to a query, 
given a certain knowledge base, is to draw a search tree.
 
A search tree shows the way Prolog finds an answer to a query. It shows all the steps
of reasoning to come to an answer, so you may also call it a *proof tree*, using more logical
terminology.

### A first example

Definition of the base knowledge.

```prolog
q(X) :- p(X).
q(0).

p(X) :- a(X), b(X).
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
in a query that is also used in the rule. In the tree above the renaming is represented as  `X', X''`. 
However, you could also chose `X1, X2` or other variables renaming method.

The solutions are enumerated from the left to the right. As `X=X'` and `X'=X'' -> X=X''`, the solutions are `X=2, X=2, X=3, X=1, X=0`.

### A second example

Do you remember de predicate `member`?

```prolog
member(X,[X|_]).
member(X,[_|L]) :- member(X,L).
```
Let's see how the search tree is generated for the query:

```prolog
member(X,[a,b,c]).
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
                            x         x 
```

This query has tree solutions. `X=a, X=b` (because `X=X'` and `X'=b`), and `X=c` (because `X'=X''` and `X''=c`).

## Control over the search tree

Prolog is a highly declarative. To achieve declarativity, sometimes it is paid sometimes with a high computational cost.

The order of the clauses and the repetition of clauses can lead to redundancies in answers and in failures. 

Problems we want to solve:

- Inefficiency
- Unspecified behaviors

Prolog has a built-in predicate named cut `!` that allows us to prune the search spaces. In other words, it helps us to modify
the way the search trees are constructed.

### The cut

The cut `!` is a predicate that always succeeds. But it has an extremely useful
side-effect: it cuts open branches from the search tree, thereby giving direct control on memory
management. Cuts are used to make Prolog programs efficient. This often goes at the cost of
making Prolog programs less declarative and readable.

It always succeeds and causes the discard of all alternative (branches) that were pending
be explored from the moment it was used to resolve the rule containing the cut.

```text
[!]      [!,Q]
 |         |
 |         |
 []       [Q]
```

Given a clause:

```text
A :- B1,...,Bk,!,Bk+1,...,Bn.
```

Such that `A` unifies with the objective `G` we want to solve, and `B1,...,Bk` unifies, the cut effect is:

- Any other clause that it could be applied to resolve `G` is ignored. Discard alternative branches
- If the attempt to satisfy any `Bi` among `Bk+1,...,Bn` is fails, the BACKTRAKING is done until the cut
- If it is necessary to redo the cut, it goes back to the previous choice of `G` and performs backtracking from there. Meaning that Prolog 
  won't try to attemp to satisfy any `Bi` among `B1,..,Bk`.
  
Let's see how the cut performs in the first example.

Definition of the base knowledge.

```prolog
q(X) :- p(X).
q(0).

p(X) :- a(X), !, b(X).
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
     X'=X'' /                     X'=X'' /       \ X'=1
           /                            /         \
   [a(X''),!,b(X'')]             [a(X''),b(X'')]   []
        /     \                     /     \
 X''=2 /                     X''=2 /       \ X''=3
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
findf(X,Y):- nums(X), fact(X,Z), Z>Y
```

What do you think that happend with the following query?

```prolog
findf(X,2).
```

A possible solution is to cut the altenative clause when `fact(0,1)` is demostrated.

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
              X>Y,
              !,
              append(As,[Y,X|Ns],Xs1), 
              sort(Xs1,Ys).
```

The first cut tells us "there is only one order, so there is no need to check if I can order in a different way".

The second cut tells us, "if you find a pair of elements messy, surely they should be sorted, therefore there is 
no need to try to leave them for late".

## Terms, program with unification

Prolog does not allow us to create new types. To create new types, need to define the behavior of this terms.

```prolog
% plant(N,A,B,T) => T is the tree with node N, T1 as left son, T2 as right son.
plant(N,T1,T2,tree(N,T1,T2)).

% node(T,N) => N is the root of the tree T.
node(tree(N,_,_),N).

% ls(T,T1)/rs(T,T2) => T1/T2 left son/right son.
ls(tree(_,T1,_),T1).
rs(tree(_,_,T2),T2).

% preorder(T,L) => L is the preorder of T.
preorder(tree(N,T1,T2),[N|L]):-  preorder(T1,L1),
                                 preorder(T2,L2),
                                 append(L1,L2,L),
                                 preorder(tempty,[]).
```

Example:

```prolog
?- 
| plant(1,tempty,tempty,L1), 
| plant(3,tempty,tempty,L2), 
| plant(2,L1,L2,R), 
| preorder(R,P).
L1 = tree(1, tempty, tempty),
L2 = tree(3, tempty, tempty),
R = tree(2, tree(1, tempty, tempty), tree(3, tempty, tempty)),
P = [2, 1, 3].
```

http://cs.uns.edu.ar/~grs/InteligenciaArtificial/Programacion%20en%20PROLOG(2)-2009-ByN.pdf

https://arxiv.org/pdf/2001.08133.pdf#:~:text=A%20search%20tree%20shows%20the,tree%2C%20using%20more%20logical%20terminology.

diagrams.net
