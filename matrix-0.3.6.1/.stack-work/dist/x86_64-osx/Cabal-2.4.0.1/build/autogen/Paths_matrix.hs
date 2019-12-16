{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_matrix (
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
version = Version [0,3,6,1] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/rosehuang/Desktop/Fall 2019/Parallel Functional Programming/Homework/crossword/.stack-work/install/x86_64-osx/cc5c7e67708144eb581442fad18335215cc502ddb88697e24f267aee3daf9576/8.6.5/bin"
libdir     = "/Users/rosehuang/Desktop/Fall 2019/Parallel Functional Programming/Homework/crossword/.stack-work/install/x86_64-osx/cc5c7e67708144eb581442fad18335215cc502ddb88697e24f267aee3daf9576/8.6.5/lib/x86_64-osx-ghc-8.6.5/matrix-0.3.6.1-Bl3ePzCM2FT6cOlSrFomIM"
dynlibdir  = "/Users/rosehuang/Desktop/Fall 2019/Parallel Functional Programming/Homework/crossword/.stack-work/install/x86_64-osx/cc5c7e67708144eb581442fad18335215cc502ddb88697e24f267aee3daf9576/8.6.5/lib/x86_64-osx-ghc-8.6.5"
datadir    = "/Users/rosehuang/Desktop/Fall 2019/Parallel Functional Programming/Homework/crossword/.stack-work/install/x86_64-osx/cc5c7e67708144eb581442fad18335215cc502ddb88697e24f267aee3daf9576/8.6.5/share/x86_64-osx-ghc-8.6.5/matrix-0.3.6.1"
libexecdir = "/Users/rosehuang/Desktop/Fall 2019/Parallel Functional Programming/Homework/crossword/.stack-work/install/x86_64-osx/cc5c7e67708144eb581442fad18335215cc502ddb88697e24f267aee3daf9576/8.6.5/libexec/x86_64-osx-ghc-8.6.5/matrix-0.3.6.1"
sysconfdir = "/Users/rosehuang/Desktop/Fall 2019/Parallel Functional Programming/Homework/crossword/.stack-work/install/x86_64-osx/cc5c7e67708144eb581442fad18335215cc502ddb88697e24f267aee3daf9576/8.6.5/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "matrix_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "matrix_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "matrix_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "matrix_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "matrix_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "matrix_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
