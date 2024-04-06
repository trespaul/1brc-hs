{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}

module Main where

import System.Environment (getArgs)
import Data.Foldable (foldl')
import qualified Data.Map.Strict as M
import qualified Data.ByteString.Char8 as C

type Results = M.Map C.ByteString (Float, Float, Float)

main :: IO ()
main = do
  [path] <- getArgs
  txt <- C.readFile path -- I've got 16GB RAM this'll work right
  print $ foldl' addCity M.empty . C.lines $ txt

addCity :: Results -> C.ByteString -> Results
addCity results line =
  let (city, temp) = parseLine line
  in M.insertWith f city (temp, temp, temp) results
      where f (temp, _, _) (oldMin, oldMean, oldMax) =
              (min temp oldMin, (temp + oldMean) / 2, max temp oldMax)

parseLine :: C.ByteString -> (C.ByteString, Float)
parseLine line =
  (x, read (C.unpack y) :: Float)
    where (x, y) = splitOn ';' line

splitOn :: Char -> C.ByteString -> (C.ByteString, C.ByteString)
splitOn c l = (a, C.drop 1 b)
    where (a, b) = C.splitAt =<< (C.length . C.takeWhile (/= c)) $ l
