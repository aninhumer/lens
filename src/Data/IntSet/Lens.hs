-----------------------------------------------------------------------------
-- |
-- Module      :  Data.IntSet.Lens
-- Copyright   :  (C) 2012 Edward Kmett
-- License     :  BSD-style (see the file LICENSE)
-- Maintainer  :  Edward Kmett <ekmett@gmail.com>
-- Stability   :  provisional
-- Portability :  portable
--
----------------------------------------------------------------------------
module Data.IntSet.Lens
  ( contains
  , members
  ) where

import Control.Lens
import Data.Functor
import Data.IntSet as IntSet

-- | This 'Lens' can be used to read, write or delete a member of an 'IntSet'
--
-- > ghci> contains 3 +~ False $ fromList [1,2,3,4]
-- > fromList [1,2,4]
--
-- > contains :: Int -> (Bool -> f Bool) -> IntSet -> f IntSet
contains :: Int -> Simple Lens IntSet Bool
contains k f s = go <$> f (IntSet.member k s) where
  go False = IntSet.delete k s
  go True  = IntSet.insert k s
{-# INLINE contains #-}

-- | This 'Setter' can be used to change the contents of an 'IntSet' by mapping
-- the elements to new values.
--
-- Sadly, you can't create a valid 'Traversal' for a 'Set', because the number of
-- elements might change but you can manipulate it by reading using 'folded' and
-- reindexing it via 'setmap'.
--
-- > ghci> adjust members (+1) (fromList [1,2,3,4]
-- > fromList [2,3,4,5]
members :: Setter IntSet IntSet Int Int
members = sets IntSet.map