
# I/O

`I/O` operations are not pure functions. They change
**_"THE WORLD"_**. Read and write operations changes the
state of the outside world (this is known as producing a _side effect_), because
when we read from the console, we are not just manipuling
data within the program. We interact with the user, reading
input from the keyword.

Similarly, if we write output to the console, we are not just
printing some text, we also causing text to be displayed
on the screen, which is an effect that can be observed outside
the program itself.

As `I/O` operations behave different than Haskell pure functions,
we need different framework to work with them. This framework
is calle the `Monad` framework, but we will just work with a specific
type of `Monad`, the `Monad IO`.


For example, let's try to read something from the console.
To read something from the console we use the action `getLine`.

```haskell
GHCi> :t getLine
getLine :: IO String
GHCi> getLine
Hello World!
"Hello World!"
```

The `getLine` is a `I/O` action that contains a result of type `String`. 

To write something in the console we can use the `putStrLn`.

```haskell
GHCi> :t putStrLn
putStrLn :: String -> IO ()
GHCi> putStrLn "Hello World!"
Hello World!
```

Printing a string to the console doesn't really
have any kind of meaningful return value,
so a dummy value of `()` is used, the `unit`.

> The `unit` or `()` is a type with a single value; the empty tuple represented as `()`.

## main

The $99\%$ of our code can be written with just pure functions, yet,
frequently, the programs needs user interaction, as a result `I/O` actions are required.

In our code, I/O actions will perform when there is `main` function
and we run the program.

```haskell
main :: IO ()
main = do
    putStrLn "Hello, what's your name?"
    name <- getLine
    putStrLn ("Hey " ++ name ++ ", you rock!")
```

The `do` notation is syntax suggar to work with all kind of `Monads`,
the `do` notation opens a block of inpurity. That's why
can perform dirty actions here.

Here is another example, this is a litle bit more complex than the previous main.

```haskell
main :: IO()
main = do
  putStrLn "Capturing multiples of m from factorials in range [0..n]" -- output action + jump line
  putStr "n: "                                      -- output action
  n <- fmap (\str -> (read str :: Int)) getLine     -- input action + cast the read String to an Int
  putStr "m: "                                      -- output action
  m <- fmap (\str -> (read str :: Int)) getLine     -- input action + cast the read String to an Int
  -- define pure logic in the do block
  let 
    f = (\ps x -> if x `elem` [0,1] then [1] else (x * head ps) : ps)
    p = (\x -> x `mod` m == 0)
    factorials     = foldl f [] [1..n]
    multiples      = filter p factorials
    notMultiples   = filter  (not . p) factorials
  putStrLn $ "In range [0.." ++ show n ++ "] there are " ++ show (length multiples) ++ " factorials multiples of " ++ show m
  putStrLn $ show multiples

  -- last line of the do block is the 'return' value, it matches the return type of the main function with IO()
  putStrLn $ "In range [0.." ++ show n ++ "] there are " ++ show (length notMultiples) ++ " factorials not multiples of " ++ show m
  putStrLn $ show notMultiples
```

We can _map over_ `IO String` using `fmap` because it is an instance of `Monad` and every monad is a `Functor` (things that can be mapped over).

### Other I/O actions

There are a lot of I/O actions
in the Haskell language that we are not covering,
but here are a fewer more:

```haskell
GHCi>:t putChar :: Char -> IO ()
GHCi>:t putStr :: String -> IO ()
GHCi>:t putStrLn :: String -> IO ()
GHCi>:t readFile :: FilePath -> IO String
GHCi>:t writeFile :: FilePath -> String -> IO ()
```
