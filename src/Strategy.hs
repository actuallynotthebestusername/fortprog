module Strategy where

import Pos
import Rule
import Term
import Prog

import Data.List(sortBy)

-- Alias type for evaluation strategies.
type Strategy = Prog -> Term -> [Pos]

loSort :: Pos -> Pos -> Ordering
loSort a b | a `above` b  = LT
           | a `leftOf` b = LT
           | otherwise    = GT

loStrategy :: Strategy
loStrategy prog term = sortBy loSort (reduciblePos prog term)

liSort :: Pos -> Pos -> Ordering
liSort a b | a `below` b  = LT
           | a `leftOf` b = LT
           | otherwise    = GT

liStrategy :: Strategy
liStrategy prog term = sortBy liSort (reduciblePos prog term)

roSort :: Pos -> Pos -> Ordering
roSort a b | a `above` b  = LT
           | a `rightOf` b = LT
           | otherwise    = GT

roStrategy :: Strategy
roStrategy prog term = sortBy roSort (reduciblePos prog term)

riSort :: Pos -> Pos -> Ordering
riSort a b | a `below` b  = LT
           | a `rightOf` b = LT
           | otherwise    = GT

riStrategy :: Strategy
riStrategy prog term = sortBy riSort (reduciblePos prog term)

-- poStrategy :: Strategy
-- piStrategy :: Strategy

-- reduces a given term with the given strategy
reduceWith :: Strategy -> Prog -> Term -> Maybe Term
reduceWith strat prog t = case strat prog t of
  [] -> Nothing
  xs -> iter xs (Just t)
    where
      iter _      Nothing   = error "Trying to reduce a reducible position"
      iter []     maybeTerm = maybeTerm
      iter (p:ps) (Just rt) = iter ps (reduceAt prog rt p)

-- evaluateWith :: Strategy -> Prog -> Term -> Term
-- evaluateWith strat prog t = strat prog t