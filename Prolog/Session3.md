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
                   q(X)
                  /    \
            X=X' /      \ X=0
                /        \
              p(X')      []
             /     \ 
     X'=X'' /       \ X'=1
           /         \
     a(X''),b(X'')   []
        /     \
 X''=2 /       \ X''=3
      /         \
    b(2)        b(3)
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
  member(X,[a,b,c])
      /     \
 X=a /       \ X=X'
    /         \
  []       member(X',[b,c])
               /     \
        X'= b /       \ X'= X''
             /         \
           []     member(X'',[c])
                      /     \
              X''= c /       \ X''=X'''
                    /         \
                  []      member(X''',[])
                              /     \   
                             /       \
                             x       x 
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
                 
                   q(X)                         q(X)
                  /    \                       /    \ 
            X=X' /      \ X=0            X=X' /      \ X=0
                /        \                   /        \
              p(X')      []                p(X')      []
             /     \                      /     \ 
     X'=X'' /                     X'=X'' /       \ X'=1
           /                            /         \
    a(X''),!,b(X'')                a(X''),b(X'')   []
        /     \                     /     \
 X''=2 /                     X''=2 /       \ X''=3
      /                           /         \
   !,b(2)                       b(2)        b(3)
   /    \                      /    \         \
  /      \                    /      \         \
 []      []                  []      []        []
```

Changing a little bit the code, the solutions now are `X=2, X=2, X=0`.


http://cs.uns.edu.ar/~grs/InteligenciaArtificial/Programacion%20en%20PROLOG(2)-2009-ByN.pdf

https://arxiv.org/pdf/2001.08133.pdf#:~:text=A%20search%20tree%20shows%20the,tree%2C%20using%20more%20logical%20terminology.

diagrams.net
