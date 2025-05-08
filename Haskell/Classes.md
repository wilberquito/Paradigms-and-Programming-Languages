## Classes system

### Overloaded functions

- It makes sense for some types, not for all
- Can have diferent definitions per each type

Consider the following types:

```haskell
type Side   = Float
type Radius = Float
type Area   = Float
data Square = ASquare Side deriving Show
data Circle = ACircle Radius deriving Show
```

We would like to compute the area for this types:

```haskell
-- Computes the area of a square
area :: Square -> Area
area (ASquare s) = s*s

-- Computes the area of a circle
area :: Circle -> Area
area (ACircle r) = pi * r^2
```

The `area` function makes sense for types `Square` and `Circle`
but not for `Bool`. Hence it's not a polymorphic function.

The problem here is that Haskell does not support `overloaded functions`
as show above. You need to create a `class`.

```haskell
type Area = Float

class HasArea t where
    area :: t -> Area
```

- `t` is type variable.
- The function `area` is just defined to the types `t` that are instances of the typeclass.

To make a type be an instance of a typeclass, you can do the following.

```haskell
instance HasArea Square where
    area (ASquare s) = s*s
instance HasArea Circle where
    area (ACircle r) = pi * r^2
```

If you try to use the function `area` with a non instance
of `HasArea`, the compiler will throw an error.

```haskell
GHCi> area (ASquare 3)
9.0 :: Area
GHCi> area (ACircle 3)
28.2743 :: Area
GHCi> area True
<interactive>:1:1: error:
    • No instance for (HasArea Bool) arising from a use of ‘area’
    • In the expression: area True
      In an equation for ‘it’: it = area True
```

## Predifined classes and instances

Some of the built-in classes:

- `Eq` denotates equality: `(==)` and `(/=)`
- `Ord` denotates order: `<=`, `(<)`, `(>=)`,...
- `Num` numeric types: `(+)`, `(-)`, `(*)`,...
- `Show` types that can be printed in the console: `show`
- `Read` types that can be readed from the console: `read`

To know if a `type` is an instance of a typeclass you can
ask it to the compiler.

For example, let's see from which classes the type
`Double` is instance.

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

This classes are thought to work with i/o.
To show types in console or read string
and transform them into a type.

```haskell
class Show a where
    show :: a -> String
class Read a where
    read :: (Read a) => String -> a
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

