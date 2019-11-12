
> import qualified Data.Map as M
> import qualified System.Random as R
> import qualified Control.Monad.Trans.State.Lazy as S

2.7.1
Define a higher-order function (or a function object) memoize in your favorite language. This function takes a pure function f as an argument and returns a function that behaves almost exactly like f, except that it only calls the original function once for every argument, stores the result internally, and subsequently returns this stored result every time it’s called with the same argument. You can tell the memoized function from the original by watching its performance. For instance, try to memoize a function that takes a long time to evaluate. You’ll have to wait for the result the first time you call it, but on subsequent calls, with the same argument, you should get the result immediately.

> memoize :: Ord a => (a -> b) -> M.Map a b -> a -> (b, M.Map a b)
> memoize f m k = case M.lookup k m of
>                   Nothing -> let v = f k
>                              in (v, M.insert k v m)
>                   Just v  -> (v, m)

We could "parse, don't validate" better here if we had a data type that stored the map and the function, and could only be constructed with the function.

For showing that effects aren't pure, let's implement monadic memoize.

> memoizeM :: (Ord a, Monad m) => (a -> m b) -> M.Map a b -> a -> m (b, M.Map a b)
> memoizeM f m k = case M.lookup k m of
>                    Nothing -> do v <- f k
>                                  return (v, M.insert k v m)
>                    Just v  -> return (v, m)

2.7.2
Try to memoize a function from your standard library that you normally use to produce random numbers. Does it work?

Nope. It would return the same number every time if it were memoized, rather than random numbers.

2.7.3
Most random number generators can be initialized with a seed. Implement a function that takes a seed, calls the random number generator with that seed, and returns the result. Memoize that function. Does it work?

> randWithSeed :: R.Random a => Int -> a
> randWithSeed = fst . R.random . R.mkStdGen


2.7.4. Which of these C++ functions are pure? Try to memoize them and observe what happens when you call them multiple times: memoized and not.
(a) The factorial function from the example in the text.

> fac n = product [1..n]

(b) std::getchar()

> stdGetChar = getChar

(c) bool f() {
std::cout << "Hello!" << std::endl; return true;
}

> greet :: () -> IO Bool
> greet _ = putStrLn "Hello!" >> return True

(d) int f(int x) {
static int y = 0;
y += x;
return y; }

> globalMutable :: Int -> S.State Int Int
> globalMutable inc = do S.modify (+inc)
>                        S.get


2.7.5
How many different functions are there from Bool to Bool? Can you implement them all?
There are four functions. In general there are |b|^|a| functions of type

> f :: a -> b
> f = undefined

where |a| is the cardinality of the type `a`, a.k.a. the number of "generalized elements" of type `a`. Here are the functions from Bool to Bool:

> true :: Bool -> Bool
> true _ = True

> false :: Bool -> Bool
> false _ = False

> myNot :: Bool -> Bool
> myNot = not

> myId :: Bool -> Bool
> myId = id


2.7.6
Draw a picture of a category whose only objects are the types Void, () (unit), and Bool; with arrows corresponding to all possible functions between these types. Label the arrows with the names of the functions.

absurd/id              true  false  not   id
--------             -----------------------
|      |   absurd    |     |     |     |    |
---> Void ------> Bool <--- <---- <---- <---
       |          | ^^
absurd |     bunit| ||
       --> () <---- || ufalse
        /  /\_______||
       /__/  \_______|
        id     utrue

               () -> Bool has 2^1 = 2 functions by the above statement
               Bool -> () has 1^2 = 1 function.

> main :: IO ()
> main = do
>          let m   = M.empty
>              f    = (+1)
>              app1 = (f 1, m)
>              app2 = memoize f m 1
>              app3 = memoize f m 1
>          putStrLn $ "Unmemoized map is different from memoized map:" ++
>                     show (app1 /= app2)
>          putStrLn $ "Several calls to memoize same input are equal:" ++
>                     show (app2 == app3)
>
>          let memRand = memoize randWithSeed m
>              rand1   = fst $ memRand 5 :: Int
>              rand2   = fst $ memRand 5 :: Int
>          putStrLn $ "Memoized seeded rands are equal:" ++
>                     show (rand1 == rand2)
>
>          putStrLn $ "Factorial is pure:" ++
>                     show (fac 5 == fst (memoize fac m 5))
>          putStrLn "Enter two different characters:"
>          char1 <- getChar
>          char2 <- getChar
>          putStrLn $ "GetChar is not pure in the general case:" ++
>                     show (char1 /= char2)
>          putStrLn "If greet is pure, \"Hello\" will print twice:"
>          (_, m1) <- memoizeM greet m ()
>          (_, m2) <- memoizeM greet m1 ()
>          putStrLn $ "even though the maps are equal: " ++
>                     show m1 ++ show m2
>
>          let initState = 0
>              st1       = memoizeM globalMutable m 5 :: S.State Int (Int, M.Map Int Int)
>              (gm1, m3) = S.evalState st1 initState :: (Int, M.Map Int Int)
>          print m3
>          let st2       = memoizeM globalMutable m3 5 :: S.State Int (Int, M.Map Int Int)
>              (gm2, m4) = S.evalState st2 gm1
>          print m4
>          putStrLn $ "globalMutable is pure: " ++
>                     show (gm1 == gm2 && gm1 == initState && m3 == m4)
>          return ()
