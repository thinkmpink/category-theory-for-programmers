{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_category_theory_for_programmers (
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
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/michaelpinkham/cs/haskell/category-theory-for-programmers/.stack-work/install/x86_64-osx/3a517f3b616c45bc8ebe984ce9940872e2d11a954eef97cf0532a2ec19eacfde/8.6.5/bin"
libdir     = "/Users/michaelpinkham/cs/haskell/category-theory-for-programmers/.stack-work/install/x86_64-osx/3a517f3b616c45bc8ebe984ce9940872e2d11a954eef97cf0532a2ec19eacfde/8.6.5/lib/x86_64-osx-ghc-8.6.5/category-theory-for-programmers-0.1.0.0-CkRFxjocNRxA7KKB5mtIOA-category-theory-for-programmers"
dynlibdir  = "/Users/michaelpinkham/cs/haskell/category-theory-for-programmers/.stack-work/install/x86_64-osx/3a517f3b616c45bc8ebe984ce9940872e2d11a954eef97cf0532a2ec19eacfde/8.6.5/lib/x86_64-osx-ghc-8.6.5"
datadir    = "/Users/michaelpinkham/cs/haskell/category-theory-for-programmers/.stack-work/install/x86_64-osx/3a517f3b616c45bc8ebe984ce9940872e2d11a954eef97cf0532a2ec19eacfde/8.6.5/share/x86_64-osx-ghc-8.6.5/category-theory-for-programmers-0.1.0.0"
libexecdir = "/Users/michaelpinkham/cs/haskell/category-theory-for-programmers/.stack-work/install/x86_64-osx/3a517f3b616c45bc8ebe984ce9940872e2d11a954eef97cf0532a2ec19eacfde/8.6.5/libexec/x86_64-osx-ghc-8.6.5/category-theory-for-programmers-0.1.0.0"
sysconfdir = "/Users/michaelpinkham/cs/haskell/category-theory-for-programmers/.stack-work/install/x86_64-osx/3a517f3b616c45bc8ebe984ce9940872e2d11a954eef97cf0532a2ec19eacfde/8.6.5/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "category_theory_for_programmers_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "category_theory_for_programmers_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "category_theory_for_programmers_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "category_theory_for_programmers_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "category_theory_for_programmers_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "category_theory_for_programmers_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
