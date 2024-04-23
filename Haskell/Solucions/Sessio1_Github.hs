
-- Ex 1
distance :: (Double,Double) -> (Double,Double) -> Double
distance (x1,y1) (x2,y2) = sqrt ( (distx*distx) + (disty*disty)) 
 where
  distx = x2-x1
  disty = y2-y1
  
  
-- Ex 2
nSum :: Num a => [a] -> a
nSum [] = 0
nSum (x:xs) = x + (nSum xs)



-- Ex 3
interpreter :: [String] -> [String]
interpreter l = interpreter_i l (0,0)


interpreter_i :: [String] -> (Integer,Integer) -> [String]
interpreter_i [] _ = []
interpreter_i (s:xs) (x,y)
 | s == "up" = interpreter_next (x,y+1)
 | s == "down" = interpreter_next (x,y-1)
 | s == "left" = interpreter_next (x-1,y)
 | s == "right" = interpreter_next (x+1,y)
 | s == "printX" = (show x):(interpreter_next (x,y))
 | s == "printY" = (show y):(interpreter_next (x,y))
 where interpreter_next point = interpreter_i xs point
