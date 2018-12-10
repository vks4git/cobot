{-# LANGUAGE RankNTypes #-}
module Bio.Protein.Metric where

import           Control.Lens
import           Linear.V3
import           Linear.Metric                 ( dot, normalize )
import qualified Linear.Metric                 as L
                                                ( distance )
import           Bio.Internal.Structure

distance :: Getting V3R a V3R -> Getting V3R a V3R -> Getting R a R
distance x y _ aa = Const $ L.distance (aa ^. x) (aa ^. y)

angle :: Getting V3R a V3R -> Getting V3R a V3R -> Getting V3R a V3R -> Getting R a R
angle x y z _ aa = Const $ angleBetween (aa ^. x - aa ^. y) (aa ^. z - aa ^. y)

dihedral :: Getting V3R a V3R -> Getting V3R a V3R -> Getting V3R a V3R -> Getting V3R a V3R -> Getting R a R
dihedral x y z w _ aa = let b1 = (aa ^. y - aa ^. x)
                            b2 = (aa ^. z - aa ^. y)
                            b3 = (aa ^. w - aa ^. z)
                            n1 = normalize $ b1 `cross` b2
                            n2 = normalize $ b2 `cross` b3
                            m1 = n1 `cross` normalize b2
                        in  Const $ atan2 (m1 `dot` n2) (n1 `dot` n2)