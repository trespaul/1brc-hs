{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}

module Main where

import System.Environment (getArgs)
import Data.Foldable (foldl')
import qualified Data.Map.Strict as M
import qualified Data.Text as T

type Results = M.Map T.Text (Float, Float, Float)

main :: IO ()
main = do
  [path] <- getArgs
  txt <- readFile path
  print $ M.toList . foldl' addCity M.empty . T.lines . T.pack $ txt

addCity :: Results -> T.Text -> Results
addCity results line =
  let (city, temp) = parseLine line
  in M.insertWith f city (temp, temp, temp) results
      where f (temp, _, _) (oldMin, oldMean, oldMax) =
              (min temp oldMin, (temp + oldMean) / 2, max temp oldMax)

parseLine :: T.Text -> (T.Text, Float)
parseLine line =
  (x, read (T.unpack y) :: Float)
    where [x, y] = T.splitOn ";" line
