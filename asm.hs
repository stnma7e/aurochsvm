-- file: haskell/main.hs
-- copies from one file to another

import System.Environment (getArgs)
import Numeric
import Data.Char

interactWith function inputFile outputFile = do
	input <- readFile inputFile
	writeFile outputFile (function input)
	
main = mainWith myFunction
	where mainWith function = do
			args <- getArgs
			case args of
				[input, output] -> interactWith function input output
				_ -> putStrLn "USAGE: <source file> <output file>"
				
-- replace "id" with the name of our function below
-- myFunction = id -- copies from first arg to second
myFunction = getAsm -- changes line endings from file to native
 
fixLines :: String -> String
fixLines input = unlines (splitLines input)
 
splitLines [] = []
splitLines cs =
		let (pre, suf) = break isLineTerminator cs
		in pre : case suf of
				('\r':'\n':rest) -> splitLines rest
				('\r':rest)		 -> splitLines rest
				('\n':rest)		 -> splitLines rest
				_				 -> []
isLineTerminator c = c == '\r' || c == '\n'

comBody xs = ((tail (head xs)) ++ (showHex (read (tail(head (tail xs)))::Int) ""))
dubReg xs = ((comBody xs) ++ (showHex (read ((tail (head (tail (init (tail xs))))))::Int) ""))

getAsm :: String -> String
getAsm input = parseAsm input []
parseAsm input total = 
        let (x:xs) = words (unlines (splitLines input))
		in case (map toLower x) of
			"loadi"		-> parseAsm (unwords xs) (total ++ ("1" ++ comBody xs) ++ "\n")
			"loadr"		-> parseAsm (unwords xs) (total ++ ("2" ++ comBody xs) ++ "0\n")
			"add"		-> parseAsm (unwords xs) (total ++ ("3" ++ dubReg xs) ++ "\n")
			"sub"		-> parseAsm (unwords xs) (total ++ ("4" ++ dubReg xs) ++ "\n")
			"mul"		-> parseAsm (unwords xs) (total ++ ("5" ++ dubReg xs) ++ "\n")
			"div"		-> parseAsm (unwords xs) (total ++ ("6" ++ dubReg xs) ++ "\n")
			"halt"		-> total ++ "0000\n"
			_			-> parseAsm (unwords xs) total