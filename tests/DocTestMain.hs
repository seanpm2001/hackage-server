module Main where

import Data.List
         ( isPrefixOf )
import System.Environment
         ( getArgs )

import Distribution.ModuleName
         ( components )

import Test.DocTest
         ( mainFromLibrary )
import Test.DocTest.Helpers
         ( Library(..), extractSpecificCabalLibrary, findCabalPackage )

main :: IO ()
main = do
  args <- getArgs
  pkg  <- findCabalPackage "hackage-server"
  -- Need to give the library name, otherwise the parser does not find it.
  lib  <- extractSpecificCabalLibrary (Just "lib-server") pkg
  print lib
  -- Need to filter out the @Paths_*@ modules, as they are not found by doctest-parallel.
  let f    = not . ("Paths_" `isPrefixOf`) . head . components
  let lib' = lib
       { libModules = filter f $ libModules lib
       -- , libSourceDirectories = ["."]  -- does not change anything
       }
  mainFromLibrary lib' args
