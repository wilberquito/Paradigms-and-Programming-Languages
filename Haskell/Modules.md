
## Modules

A Haskell module is a collection of related
functions, types and typeclasses.
A Haskell program is a collection
of modules where the main module loads
up the other modules and then uses the
functions defined in them to do something.
Having code split up into several modules
has quite a lot of advantages.
If a module is generic enough, the functions it exports
can be used in a multitude of different programs

### Using existing modules

The syntax for importing modules in a Haskell
script is `import <module name>`.
This must be done before defining any functions,
so imports are usually done at the top of the file.

```haskell
import Data.List

numUniques :: (Eq a) => [a] -> Int
numUniques = length . nub
```

You can use the same syntax to import modules
in `ghci`.

```haskell
GHCi> import Data.List
```

But you could also import modules like this:

```haskell
GHCi> :m + Data.List Data.Map
```

The main difference is that this last syntax allows you
to import multiple modules at once.

If you just need a couple of functions from a module,
you can selectively import just those functions

```haskell
import Data.List (nub, sort)
```

A way of dealing with name clashes of different modules,
is to do qualified imports.

```haskell
import qualified Data.List as L

numUniques :: (Eq a) => [a] -> Int
numUniques = length . L.nub
```

### Making our own modules

Almost every programming language enables
you to split your code up into several
files and Haskell is no different.

We'll start by creating a file called `Geometry.hs`.
At the beginning of a module,
we specify the module name.
If we have a file called `Geometry.hs`,
then we should name our module `Geometry`.
Then, we specify the functions that it exports and after that,
we can start writing the functions.

```haskell
module Geometry
( sphereVolume
, sphereArea
, cubeVolume
, cubeArea
, cuboidArea
, cuboidVolume
, Geometry(..)
) where

data Geometry = Circle | Rectangle
    deriving Show

sphereVolume :: Float -> Float
sphereVolume radius = (4.0 / 3.0) * pi * (radius ^ 3)

sphereArea :: Float -> Float
sphereArea radius = 4 * pi * (radius ^ 2)

cubeVolume :: Float -> Float
cubeVolume side = cuboidVolume side side side

cubeArea :: Float -> Float
cubeArea side = cuboidArea side side side

cuboidVolume :: Float -> Float -> Float -> Float
cuboidVolume a b c = rectangleArea a b * c

cuboidArea :: Float -> Float -> Float -> Float
cuboidArea a b c = rectangleArea a b * 2 + rectangleArea a c * 2 + rectangleArea c b * 2

rectangleArea :: Float -> Float -> Float
rectangleArea a b = a * b
```

The `(..)` syntax means, export all constructors for the preceding type.

To use our module, we just do:

```haskell
import Geometry
```

