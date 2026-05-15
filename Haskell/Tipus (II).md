## Overloading

Consider the following types:

```haskell
type Side   = Float
data Square = Square Side deriving Show

type Radius = Float
data Circle = Circle Radius deriving Show

-- Mesure of the are of any >= 2D figure
type Area   = Float
```

Computing the `area` of a `Square` or a `Circle` makes sense, but, Haskell does not support traditional _overloaded functions_, i.e, creating
functions with the same name but with different number of parameters or types.

In Haskell, this is not possible:

```haskell
area :: Square -> Area
area (Square s) = s * s

area :: Circle -> Area
area (Square r) = pi * r * r
```

Computing the `area` only make sense for certain types (what is the area of a `Bool`?). Hence, **`area` can not be defined as a parametric polymorfic function**.

> Remember, a parametric polymorfic function is a function defined generically, and the behaviour of the function works regardless of the type.

## Typeclasses

In Haskell, overloading is only acceptable by using _typeclasses_. **A typeclass is a sort of interface that defines some behavior**. If a type is a part of a typeclass, that means that it supports and implements the behaviour the typeclass describes.

```haskell
type Area = Float

class Shape a where
 area :: a -> Area
```

- `a` is a type variable.
- `area` is just defined to the types `a` that are instances of the typeclass.

Making a type to be part of a group or instance of a typeclass:

```haskell
class Shape a where
    area :: a -> Area

instance Shape Square where
    area (Square s) = s * s

instance Shape Circle where
    area (Circle r) = pi * r * r
```

Nothice the type constraint appearing in `area` when asking about its type information.

```haskell
ghci> :t area
area :: Shape a => a -> Area
```


If you try to use the function `area` with a non-instance
of `Shape`, the compiler will throw an error.

```haskell
GHCi> area (Square 3)
9.0
GHCi> area (Circle 3)
28.2743
GHCi> area True
<interactive>:1:1: error:
    • No instance for (HasArea Bool) arising from a use of ‘area’
    • In the expression: area True
      In an equation for ‘it’: it = area True
```

## Predifined classes and instances

Some of the built-in classes:

- `Eq` denotates equality: `(==)` and `(/=)`
- `Ord` denotates order: `<=`, `(<)`, `(>=)`, ...
- `Num` numeric types: `(+)`, `(-)`, `(*)`, ...
- `Show` types that can be printed in the console: `show`
- `Read` types that can be readed from the console: `read`

To know if a `type` is an instance of a typeclass you can
ask it to the compiler. e.g.,

```haskell
GHCi> :info Double
type Double :: *
data Double = GHC.Types.D# GHC.Prim.Double#
        -- Defined in ‘GHC.Types’
instance Eq Double -- Defined in ‘GHC.Classes’
instance Ord Double -- Defined in ‘GHC.Classes’
instance Enum Double -- Defined in ‘GHC.Float’
instance Floating Double -- Defined in ‘GHC.Float’
instance Fractional Double -- Defined in ‘GHC.Float’
instance Num Double -- Defined in ‘GHC.Float’
instance Real Double -- Defined in ‘GHC.Float’
instance RealFloat Double -- Defined in ‘GHC.Float’
instance RealFrac Double -- Defined in ‘GHC.Float’
instance Show Double -- Defined in ‘GHC.Float’
instance Read Double -- Defined in ‘GHC.Read’
```

### Eq class

```haskell
class Eq a where
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool

    -- The minimum implementation is (==) or (/=)

    x == y = not (x /= y)
    x /= y = not (x == y)
```

- The definitions in the class `(==)` and `(/=)` denotates
a default behavior. This default behavior is used if you don't
define de desired behavior in the instance.

- It is enought to define one of the `Eq` functions to be
instance of the typeclass.

### Ord class

The `Ord` class is a subclass of `Eq`, it means that
all type instances of `Ord` are instances of `Eq`.

```haskell
data Ordering = LT | EQ | GT

class Eq a => Ord a where
    (<), (<=), (>=), (>) :: a -> a -> Bool
    max , min :: a -> a -> a
    compare :: a -> a -> Ordering

    -- The minimum implementation is (<=) or `compare`
    compare x y
        | x == y    = EQ
        | x <= y    = LT
        | otherwise = GT
    x <= y = compare x y    /= GT
    x < y = compare x y     == LT
    x >= y = compare x y    /= LT
    x > y = compare x y     == GT
    max x y
        | x >= y    = x
        | otherwise = y
    min x y
        | x <= y    = x
        | otherwise = y
```

### Show and Read classes

This typeclasses are mainly thought to work with I/O. Although
are quite usuful for casting (show non-string values through the console or read string
and transform them into a value of different type)

```haskell
class Show a where
    show :: a -> String

class Read a where
    read :: (Read a) => String -> a
```

Example:

```haskell
ghci> show 9.9
"9.9"
ghci> read "9.9" :: Float
9.9
```

```haskell
-- Exercise: below you'll find a way of representing
-- calculator operations.
--
-- -- Your task is to add:
--  * create a typeclass `Calculator`
--  which declares a function `compute` an
--  the function `show'`
--
--  * Make the type `Operation` instance of `Calculator`
--
-- Examples:
--   compute (Multiply 2 3) ==> 6
--   show' (Add 2 3) ==> "2+3"
--   show' (Multiply 4 5) ==> "4*5"
--   show' (Subtract 2 3) ==> "2-3"
--   show' (Multiply 4 5) ==> "4*5"

data Operation =  Add Int Int
                | Subtract Int Int
                | Multiply Int Int
  deriving Show
```

