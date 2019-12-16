{-
stack ghc -- --make -Wall -O crosswordSolver.hs
./crosswordSolver test_sites.txt

-}

import qualified Data.Map.Strict as Map
import qualified Data.List as List
import System.IO(readFile)
import System.Environment(getArgs)
import System.Exit(die)

import Control.Monad
import Data.Ord (comparing)
import Data.Function (on)

type Square    = (Int, Int)
data Site      = Site {squares :: [Square], len :: Int} deriving (Show,Eq)
data Crossword = Crossword {wdict :: Map.Map Int [String], sites :: [Site]}  deriving (Show,Eq)


toSites :: [String] -> [Site]
toSites s = map (\x -> Site {squares = map (\y -> read y::(Int, Int)) 
  $ words x, len = length $ words x}) s


toDict :: [String] -> Map.Map Int [String]
toDict dictWords = Map.fromListWithKey (\_ x y -> x++y) $ map (\w -> (length w, [w])) dictWords


-- reads dict and sites file, construct Crossword, solve
main :: IO ()
main = do 
  args <- getArgs
  case args of 
    [dictFile, siteFile] -> do
      dictContents <- readFile dictFile
      siteContents <- readFile siteFile
      putStrLn $ show $ solve $ Crossword (toDict (lines dictContents)) (toSites (lines siteContents))

    _ -> do die $ "error"


-- test whether there exist no two different letters on the same squares
verifySquares :: [(String, Site)] -> Bool
verifySquares xs = all allEqual groupedByCoordXs
    where groupedByCoordXs = groupedByCoord xs
          allEqual []     = True
          allEqual (x:xss) = all (x==) xss


-- make into list of lists of chars, grouped by coordinates
groupedByCoord :: [(String, Site)] -> [[Char]]
groupedByCoord xs = map (map snd) . List.groupBy ((==) `on` fst) . List.sortBy (comparing fst) 
                        . concatMap makeSqChar $ xs


-- assign each character to a square
makeSqChar :: (String, Site) -> [(Square, Char)]
makeSqChar (str,s) = zip (squares s) str


-- return solution of crossword as a list of squares and letters
solve :: Crossword -> [[(Square, Char)]]
solve cw = map (concatMap makeSqChar) solution
    where solution = solve' (wdict cw) (sites cw)

solve' :: Map.Map Int [String] -> [Site] -> [[(String, Site)]]
solve' _     []     = [[]]
solve' dict (s:ss) = if possWords == []
                        then error ("No words of length " ++ show (len s))
                        else do try <- possWords
                                solveAgain <- solve' dict ss
                                let attempt = (try, s) : solveAgain
                                Control.Monad.guard $ verifySquares attempt
                                return attempt
    where possWords = Map.findWithDefault [] (len s) dict
