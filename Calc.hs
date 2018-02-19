module Main where
import Grammar
import Tokens


-- eval :: Extern -> String
-- eval (Ext a b c) = "the function " ++ a ++ " returns " ++ b ++ " and has the param set " ++ c

main :: IO ()
main = do
    s <- getContents
    let ast = parseCalc (scanTokens s)
    print ast
    -- print (eval ast)
