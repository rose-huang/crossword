{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_parallel (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [3,2,2,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/biqing/Desktop/pfp_final/crossword/.stack-work/install/x86_64-osx/d3bb903f501b07f44d248d165d486493f685bece662d49a7dbd753a0723d6bc6/8.6.5/bin"
libdir     = "/Users/biqing/Desktop/pfp_final/crossword/.stack-work/install/x86_64-osx/d3bb903f501b07f44d248d165d486493f685bece662d49a7dbd753a0723d6bc6/8.6.5/lib/x86_64-osx-ghc-8.6.5/parallel-3.2.2.0-EGl5SOk48TWHAD161C93aQ"
dynlibdir  = "/Users/biqing/Desktop/pfp_final/crossword/.stack-work/install/x86_64-osx/d3bb903f501b07f44d248d165d486493f685bece662d49a7dbd753a0723d6bc6/8.6.5/lib/x86_64-osx-ghc-8.6.5"
datadir    = "/Users/biqing/Desktop/pfp_final/crossword/.stack-work/install/x86_64-osx/d3bb903f501b07f44d248d165d486493f685bece662d49a7dbd753a0723d6bc6/8.6.5/share/x86_64-osx-ghc-8.6.5/parallel-3.2.2.0"
libexecdir = "/Users/biqing/Desktop/pfp_final/crossword/.stack-work/install/x86_64-osx/d3bb903f501b07f44d248d165d486493f685bece662d49a7dbd753a0723d6bc6/8.6.5/libexec/x86_64-osx-ghc-8.6.5/parallel-3.2.2.0"
sysconfdir = "/Users/biqing/Desktop/pfp_final/crossword/.stack-work/install/x86_64-osx/d3bb903f501b07f44d248d165d486493f685bece662d49a7dbd753a0723d6bc6/8.6.5/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "parallel_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "parallel_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "parallel_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "parallel_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "parallel_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "parallel_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
