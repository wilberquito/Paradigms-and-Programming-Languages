
## I/O

I/O operations are not pure functions. They change
*"THE WORLD"*. Read and write operations changes the
state of the outside world (side effect), because
when we read from the console, we are not just manipuling
data within the program. We interact with the user, reading
input from the keyword.

Similarly, if we write output to the console, we are not just
printing some text, we also causing text to be displayed
on the screen, which is an effect that can be observed outside
the program itself.

As I/O operations behave different than Haskell pure functions,
we need different framework to work with them. This framework
is call `Monad`, but we will just work with a specific
type of `Monad`, the `Monad IO`.

Most programs needs some I/O operation. Haskell allows
us to work with this inpurity with actions that are
instances of the type `IO`.

For example, let's try to read something from the console.
To read something from the console we use the action `getLine`.

```haskell
GHCi> :t getLine
getLine :: IO String
GHCi> getLine
Hello World!
"Hello World!"
```

Reading from the console means take what is written
and parse it to a `String`. That's why the `getLine`
action is of type `IO String`.

Now, what if I want to write something in the console?
To achieve it, we can use for example the action `putStrLn`.

```haskell
GHCi> :t putStrLn
putStrLn :: String -> IO ()
GHCi> putStrLn "Hello World!"
Hello World!
```

Printing a string to the console doesn't really
have any kind of meaningful return value,
so a dummy value of `()` is used, the unit.

> The empty tuple is a value of () and it also has a type of ().

### The main function

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
import Random

main :: IO ()
main = do
    putStrLn "How is your name?"
    name <- getLine
    putStrLn ("Hello " ++ name ++ ", give me your number" )
    number <- getLine
    let num = read number :: Int
    ra <- randomRIO (1::Int, num)
    putStrLn ("Here is a random number from 1 to "
        ++ show num ++ " it is: "++ show ra)
```

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
