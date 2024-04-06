module Main where

import System.Environment (getArgs)
import Data.Foldable (foldl')
import Data.Maybe (isNothing, fromJust)

type Results = [(String, (Float, Float, Float))]

main :: IO ()
main = do
  [path] <- getArgs
  txt <- readFile path

  let results =
          foldl' addCity []
        . map parseLine
        . lines
        $ txt

  print results

parseLine :: String -> (String, Float)
parseLine line =
  (x, read y :: Float)
    where (x, y) = splitOn ';' line

addCity :: Results -> (String, Float) -> Results
addCity results (city, temp) =
  let
    oldCityInfo = lookup city results
  in
    if isNothing oldCityInfo
    then results ++ [(city, (temp, temp, temp))]
    else replace results (city, fromJust oldCityInfo)
                         (city, (newMin, newMean, newMax))
      where newMin = min temp oldMin
            newMax = max temp oldMax
            newMean = (temp + oldMean) / 2
            (oldMin, oldMean, oldMax) = fromJust $ lookup city results
            --TODO: reuse oldCityInfo

replace :: Eq a => [a] -> a -> a -> [a]
replace list oldItem newItem =
    a ++ [newItem] ++ b
      where (a, b) = splitOn oldItem list


splitOn :: Eq a => a -> [a] -> ([a], [a])
splitOn i list = (a, drop 1 b)
    where (a, b) = splitAt =<< (length . takeWhile (/= i)) $ list
