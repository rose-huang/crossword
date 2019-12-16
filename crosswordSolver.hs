{-
stack ghc -- --make -Wall -O crosswordSolver.hs
./crosswordSolver test_sites.txt

-}

import Data.List
import System.IO(readFile)
import System.Environment(getArgs)
import System.Exit(die)

type Square    = (Int, Int)
data Site      = Site {squares :: [Square], len :: Int} deriving (Show,Eq)


toSites :: [String] -> [Site]
toSites s = map (\x -> Site {squares = map (\y -> read y::(Int, Int)) $ words x, len = length $ words x}) s


-- this currently just reads sites and prints them
main :: IO ()
main = do 
  args <- getArgs
  case args of 
    [siteFile] -> do
      contents <- readFile siteFile 
      mapM_ putStrLn $ map (\x -> show x) $ toSites $ lines contents 
    _ -> do die $ "error"