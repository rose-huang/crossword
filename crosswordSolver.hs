{-
stack build
stack ghc -- -O2 -threaded -eventlog -rtsopts --make -Wall -O crosswordSolver.hs
./crosswordSolver words44.txt test_sites.txt +RTS -ls -N2
../threadscope.osx crosswordSolver.eventlog
-}

import qualified Data.Map.Strict as Map
import qualified Data.List as List
import qualified Data.Matrix as Matrix
import System.IO(readFile)
import System.Environment(getArgs)
import System.Exit(die)
import Data.Ord (comparing)
import Data.Function (on)
import Data.Char(isAlpha, toLower)
import Control.Parallel.Strategies hiding (parPair)
import Control.Monad

type Square    = (Int, Int)
data Site      = Site {squares :: [Square], len :: Int} deriving (Show,Eq)
data Crossword = Crossword {wdict :: Map.Map Int [String], sites :: [Site]}  deriving (Show,Eq)

-- convert list of strings from site file to list of sites
toSites :: [String] -> [Site]
toSites s = map (\x -> Site {squares = map (\y -> read y::(Int, Int)) 
            $ words x, len = length $ words x}) s

-- convert list of strings from dict file to map with length as key and list of words as value
toDict :: [String] -> Map.Map Int [String]
toDict dictWords = Map.fromListWithKey (\_ x y -> x++y) 
                   $ map (\w -> (length w, [w])) dictWords

-- test to ensure there are no two different letters on the same squares
verifySquares :: [(String, Site)] -> Bool
verifySquares xs = all allEqual $ groupBySquare xs
    where allEqual []     = True
          allEqual (x:xss) = all (x==) xss

-- make into list of lists of chars, grouped by squares
groupBySquare :: [(String, Site)] -> [[Char]]
groupBySquare xs = map (map snd) $ List.groupBy ((==) `on` fst) $ List.sortBy (comparing fst) 
                   $ concatMap makeSqChar $ xs

-- assign each character to a square
makeSqChar :: (String, Site) -> [(Square, Char)]
makeSqChar (str,s) = zip (squares s) str

-- parallel evaluation in pairs
parPair :: Strategy (a, b)
parPair (a, b) = do
    a' <- rpar a
    b' <- rpar b
    return (a', b')

-- return solution of crossword as a list of squares and letters
solve :: Crossword -> [Map.Map Square Char]
solve cw = map (Map.fromList . (concatMap makeSqChar)) solutions
    where solutions = List.nub $ solve' (wdict cw) (sites cw)

solve' :: Map.Map Int [String] -> [Site] -> [[(String, Site)]]
solve' _ []     = [[]]
solve' dict (s:ss) = if possWords == []
                        then error ("No words of length " ++ show (len s))
                        else do
                            let splitWords = splitAt (length possWords `div` 2) possWords
                            let (a, b) = (trySolve (fst splitWords), trySolve (snd splitWords)) `using` parPair
                            a ++ b
    where possWords = Map.findWithDefault [] (len s) dict
          trySolve thiswords = do
                try <- thiswords
                solveAgain <- solve' dict ss
                let attempt = (try, s) : solveAgain
                Control.Monad.guard $ verifySquares attempt
                return attempt

-- return solution as prettyMatrix String
toMatrix :: Int -> Int -> Map.Map Square Char -> String
toMatrix rows cols solution = Matrix.prettyMatrix $ Matrix.matrix rows cols getLetter where 
    getLetter (i,j) = case Map.lookup (i,j) solution of
        Nothing -> ' '
        Just c -> c

-- reads dict and sites file, construct Crossword, solve
main :: IO ()
main = do 
  args <- getArgs
  case args of 
    [dictFile, siteFile] -> do
      dictContents <- readFile dictFile
      siteContents <- readFile siteFile
      let dimensions:siteStrings = lines siteContents
          processedWords = map (map toLower . filter isAlpha) (lines dictContents)
          solutions = solve $ Crossword (toDict processedWords) (toSites (siteStrings))
          originalBoard = Map.fromList $ zip (concatMap squares (toSites siteStrings)) (repeat 'X')
      case (map (\x -> read x :: Int) $ words dimensions) of
        [rows, cols] -> do
            putStrLn "original board:"
            putStrLn $ toMatrix rows cols originalBoard
            putStrLn "solutions:"
            mapM_ putStrLn $ map (toMatrix rows cols) solutions
        _ -> do die $ "siteFile doesn't include dimensions"
    _ -> do die $ "Usage: ./crosswordSolver <dict file> <site file>"
