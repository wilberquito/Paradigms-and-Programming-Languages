# Session 1 [^1][^2]

Prolog as the name itself suggests, is the short form of LOGic PROgramming. It is a logic-based declarative programming language. Before diving deep into the concepts of Prolog, let us first understand what exactly logic programming is.

Logic Programming is one of the Computer Programming Paradigm, in which the program statements express the facts and rules about different problems within a system of formal logic, namely the Horn clauses fragment of first-order logic.

In propositional logic, a logical formula is a Horn clause if it is a clause (disjunction of literals) with at most one positive literal.

${\displaystyle \neg p\lor \neg q\vee \cdots \vee \neg t\vee u}$

This formula can also be rewritten equivalently as an implication.

${\displaystyle (p\wedge q\wedge \cdots \wedge t)\rightarrow u}$

## Logic and Procedural Programming

From this illustration, we can see that in Procedural (imperative) Programming, we have to define the procedures, 
and the rule how the procedures work. These procedures work step by step to solve one specific problem based on the algorithm. On the other hand, for the Logic Programming, we will provide knowledge base. Using this knowledge base, the machine can find answers by means of reasoning to the given questions, which is totally different from procedural programming.

![logic-vs-procedural](Img/logic_functional_programming.jpg)

In procedural programming, we have to mention how one problem can be solved, but in logic programming we have to specify for which problem we actually want the solution, then the deductive mechanism (resolution) automatically finds a suitable solution that will help us solve that specific problem.

## What's Prolog?

Prolog or PROgramming in LOGics is a logic-based declarative programming language. It is particularly suitable for programs that involve symbolic or non-numeric-intensive computation. This is the main reason to use Prolog as the programming language in Artificial Intelligence, where symbol manipulation and inference manipulation are the fundamental tasks.

In Prolog, we need not mention the way how one problem can be solved, we just need to mention what the problem is, so that Prolog automatically solves it. However, in Prolog we are supposed to give clues as the solution method.

Prolog language is really simple and basically has three different elements.

- *Facts* are logical atoms (typically a predicate relating some elements) that are true, for example, if we say, “Tom is the father of Jack”, then this is a fact.

  ```prolog
  father(tom, jack).
  ```

  Since previous fact could also be read as "the father of Tom is Jack" we **Strongly recommend** to add comments to clarify, e.g.:

  ```prolog
  % tom is the father of jack
  father(tom, jack).
  ```
  at least the first time a predicate is used...

- *Rules* are extinctions of facts that contain conditional clauses. To satisfy a rule these conditions should be met. 
More generally, the `:-` should be read as “if”, or “is implied by”. The part on the left hand side of the `:-` is called the head of the rule, 
the part on the right hand side is called the body. So in general rules say: if the body of the rule is true, then the head of the rule is also true; alternatively rules can also be read as: if you want me to prove the head of the rule you need to prove all the **literals** (logical atoms and negations of logical atoms) of the body.

  This is extreamly powerful, because **Prolog can use the mechanism of inference `resolution` to deduce head**.

  ```prolog
  grandfather(X, Y) :- father(X, Z), parent(Z, Y).
  ```

- And to run a prolog program, we need some *Questions*, and those questions can be answered by the given facts and rules. In queries, variables are existentially quantified. The question is whether there exists a value for the variables that makes a certain conjunction of literals true according to the theory.

  ```prolog
  father(X, wil).
  X = santos ? ;
  no
  ```

## Hello World Program


A CLASSE HI HA EL SICSTUS TAMBÉ DIRIA...

After running the GNU prolog or an interactive Prolog instance in your terminal, we can write hello world program directly from the console. To do so, we have to write the command as follows

  ```prolog
  write('Hello World').
  ```

Now let us see how to run the Prolog script file (extension is *.pl) into the Prolog console.

Before running *.pl file, we must store the file into the directory where the GNU prolog console is pointing, otherwise just change the directory by the following steps −

Step 1 − From the prolog console, go to File > Change Dir, then click on that menu.

Step 2 − Select the proper folder and press OK.

![Change directory](Img/select_working_directory.jpg)

Now we can see in the prolog console, it shows that we have successfully changed the directory.

![Prolog console](Img/prolog_console.jpg)

Step 3 − Now create one file (extension is *.pl) and write the code as follows. Or use the [hello.pl](Examples/hello.pl) already given for you.

```prolog
main :- write('Hello World').
```

Now, when you load the program and ask for the query main, to prove it Prolog needs to prove write('Hello World'), and this is done by its execution, i.e., by writing Hello World.

## Anonymous Variables in Prolog

Anonymous variables have no names. The anonymous variables in prolog is written by a single underscore character ‘_’. One important thing is that each individual anonymous variable is treated as different. They are not same.

Now the question is, where should we use these anonymous variables? It's usuful when what matters is to know if exist any constant that in variable sustitution satisty the logic equation instead of knowing which are the terms that satisfy the logic equation.

<details>
    <summary>Toggle me to see the var_anonymous.pl knowledge</summary>

```prolog
hates(jim,tom).
hates(pat,bob).
hates(dog,fox).
hates(peter,tom).
```
</details>

![Anonymous variable example](Img/anonymous_variable.png)

For a practical implementation see the knowledge base of the [var_anonymous.pl](Examples/var_anonymous.pl).

## The not meta-predicate

The "not" operator in Prolog is a built-in meta-predicate. A meta-predicate is a predicate that takes one or more predicates as arguments, rather than data. The "not" operator takes a single predicate as its argument and negates its truth value.

The "not" operator is also known as the negation-as-failure operator, because it works by attempting to prove the negation of the goal and failing if it cannot be proven. It does not actually perform logical negation, but rather it checks if the goal can be proven to be false.

The "not" operator is one of several built-in meta-predicates in Prolog that allow for more advanced logical reasoning and rule-based programming. Other examples of meta-predicates in Prolog include "call", "findall", and "assert" that we may see latter.

```prolog
domestic_animal(cat).
domestic_animal(dog).

non_domestic_animal(X) :- not(domestic_animal(X)).
```

## It's your turn to practice (I)

### [lovers.pl](Examples/lovers.pl)

Use the knowledge in lovers.pl and write in Prolog the following questions.

- Who does "John" love?
- Who loves "Ann"?
- Who loves someone?
- Who is loved by someone?
- Who love each other mutually?
- Who loves without being loved back?

## Belive in terms 

It’s time for precision: exactly what are facts, rules, and queries built out of? In Prolog, 
the answer is terms, and there are four kinds of term in Prolog: term atoms, numbers, variables, and complex terms (or structures)

- *Constants*

  - *Term atoms* are the basic building blocks of Prolog, and they represent a unique identifier, 
  such as a constant or a string. Term atoms can be either a name, like "dog" or "cat", or a string 
  enclosed in single quotes, like 'dog' or 'cat'.

  - *Numbers* In Prolog, numbers are used to represent integers, floating-point numbers, or rational numbers. 
  They are used to perform mathematical operations, like addition, subtraction, and multiplication. 
  **Numbers aren’t particularly important in typical Prolog applications**.

- *Variables* are also terms. Variables in Prolog start with an uppercase letter, like X or Y, 
and they can be used to represent any value. The variable `_` (that is, a single underscore character) is rather special. It’s called the anonymous variable,
and we discuss late.

- *Complex Terms*, in Prolog you can define terms that represent more complex data structures, like lists, trees, and graphs, using a combination of atoms, numbers, 
and other terms.

  For example, you can define a term to represent a point in two-dimensional space, like this:

  ```prolog
  point(X, Y).
  ```

  Complex terms can also be facts or rules.

  ```prolog
  loves(vincent,mia).
  ```

![Data types](Img/data_objects.jpg)

## Tracing the ouput

In Prolog we can trace the execution. To trace the output, you have to enter into the trace mode by typing “trace.”. Then from the output we can see that we are just tracing “marge is mother of whom?”. See the tracing output by taking X = marge, and Y as variable, there Y will be { bart, maggie ... } as answer. To come out from the tracing mode press “notrace.”

Given the knowledge:

<details>
    <summary>Toggle me to see the knowledge</summary>

```prolog
nen(bart).
nen(milhouse).
nen(lisa).
nen(maggie).
nen(rod).
nen(todd).
nen(ralph).

home(abe).
home(homer).
home(bart).
home(ned).
home(rod).
home(todd).
home(chief_wiggum).
home(ralph).
home(milhouse).
home(mr_burns).
home(smithers).
home(groundskeeper_willie).
home(principal_skinner).

dona(marge).
dona(lisa).
dona(maggie).
dona(maude).
dona(mrs_krabappel).
dona(ms_hoover).
dona(patty).
dona(selma).
dona(jacqueline).

pare(abe, homer).
pare(homer, bart).
pare(homer, lisa).
pare(homer, maggie).
pare(ned, rod).
pare(ned, todd).
pare(chief_wiggum,ralph).

mare(marge, bart).
mare(marge, lisa).
mare(marge, maggie).
mare(jacqueline, marge).
mare(jacqueline, patty).
mare(jacqueline, selma).
mare(maude, rod).
mare(maude, todd).

casat(homer, marge).
casat(ned, maude).

amic(bart, milhouse).
amic(homer, ned).
amic(marge, maude).

viu(homer, adr("Evergreen Terrace", 742, "Springfield")).
viu(ned, adr("Evergreen Terrace", 744, "Springfield")).
```

</details>

![Trace](Img/trace-example.png)

## It's your turn to practice (II)

### [els_simpsons.pl](Examples/els_simpson.pl)

Given the knowlage of els_simpsons.pl, think how would you define the following questions.

- Ancestor
- Grandfather
- Grandmother
- Uncle
- Aunt

[^1]: [tutorialspoint](https://www.tutorialspoint.com/prolog)
[^2]: [learnprolog](http://www.let.rug.nl/bos/lpn//lpnpage.php?pagetype=html&pageid=lpn-htmlse1)
