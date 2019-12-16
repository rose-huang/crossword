{-
stack ghc -- --make -Wall -O crosswordSolver.hs
./crosswordSolver test_sites.txt

-}

import qualified Data.Map.Strict as Map
import System.IO(readFile)
import System.Environment(getArgs)
import System.Exit(die)

type Square    = (Int, Int)
data Site      = Site {squares :: [Square], len :: Int} deriving (Show,Eq)


toSites :: [String] -> [Site]
toSites s = map (\x -> Site {squares = map (\y -> read y::(Int, Int)) 
  $ words x, len = length $ words x}) s


toDict :: [String] -> Map.Map Int [String]
toDict dictWords = Map.fromListWithKey (\_ x y -> x++y) $ map (\w -> (length w, [w])) dictWords


-- this currently just reads dict and sites and prints them
main :: IO ()
main = do 
  args <- getArgs
  case args of 
    [dictFile, siteFile] -> do
      dictContents <- readFile dictFile
      siteContents <- readFile siteFile 

      putStrLn $ show $ toDict $ lines dictContents
      mapM_ putStrLn $ map (\x -> show x) $ toSites $ lines siteContents 
    _ -> do die $ "error"