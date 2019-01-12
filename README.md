
#  G++ Language Lexer & Parser

G++ Lexer and Parser in common lisp.<br>
You can find the detailed explanations for lexer and parser below.<br>

##  Properties of G++ Language:
G++ is a Gebze Technical University programming language with:

 - Lisp like syntax
 - Imperative, non-object oriented
 - Static scope, static binding, strongly typed, …
 - **Keywords**:
	 -  `and, or, not, equal, append, concat, set, deffun, for, while, if, exit`
 - **Operators**:
	 -  `+, -, /, *, (, ), **`
 - **Terminals:**
	 - `Keywords`
	 - `Operators`
	 - `0-9`
	 - `BinaryValue  -> True | False`
	 - `IntegerValue -> [-]*[1-9]*[0-9]+`
	 - `Id 		  -> [a-zA-Z]+`
	


##  Grammer rules of G++ Language:


     - START -> INPUT
     
     - INPUT -> EXPI | EXPLISTI 
     
     - EXPI -> (set ID EXPI) 
     - EXPI -> (+ EXPI EXPI) 
     - EXPI -> (- EXPI EXPI) 
     - EXPI -> (* EXPI EXPI) 
     - EXPI -> (/ EXPI EXPI) 
     - EXPI -> ID | (ID EXPLISTI) | VALUES 
     - EXPI -> (deffun ID IDLIST EXPLISTI) 
     - EXPI -> (ID EXPLISTI) 
     - EXPI -> (defvar ID EXPI) 
     - EXPI -> (set ID EXPI) 
     - EXPI -> (if EXPB EXPLISTI) 
     - EXPI -> (if EXPB EXPLISTI EXPLISTI) 
     - EXPI -> (while (EXPB) EXPLISTI) 
     - EXPI -> (for (ID EXPI EXPI) EXPLISTI) 
      
     - EXPB -> (and EXPB EXPB) 
     - EXPB -> (or EXPB EXPB) 
     - EXPB -> (not EXPB) 
     - EXPB -> (equal EXPB EXPB) 
     - EXPB -> (equal EXPI EXPI) 
     - EXPB -> BinaryValue 
      
     - EXPLISTI -> EXPI | (concat EXPLISTI EXPLISTI) | (append EXPI EXPLISTI) | null | ‘( VALUES ) | ‘() 
      
     - VALUES -> VALUES IntegerValue | IntegerValue 
      
     - IDLIST -> ID | (IDLIST) | ID IDLIST


## Lexer

Lexer written in CommonLisp.

Given the description of the G++ language that is shown above the lexer implemented does tokenization of a given G++ program. The program is given in a file.

To test the code you need to call function lexer("filename.txt") which takes as a parameter a file that contains program with G++ syntax.

After the lexical analysis is performed the output is the tokens of the program.

**Token Names:**

 - INTEGER
 - BINARY
 - KEYWORD
 - OPERATOR

**Usage:**
```sh
$ lexer(filename.gpp)
```

**Sample Input:**

```sh
(deffun sumup (x)
    (if (equal x 0)
    1
    (+ x (sumup (- x 1))))
)
```
**Sample Output:**
```sh
("OPERATOR" "(") ("KEYWORD" "deffun") ("IDENTIFIER" "sumup") ("OPERATOR" "(") ("IDENTIFIER" "x")
("OPERATOR" ")") ("OPERATOR" "(") ("KEYWORD" "if") ("OPERATOR" "(") ("KEYWORD" "equal")("IDENTIFIER" "x")
("INTEGER" "0") ("OPERATOR" ")") ("INTEGER" "1") ("OPERATOR" "(") ("OPERATOR" "+") ("IDENTIFIER" "x")
("OPERATOR" "(") ("IDENTIFIER" "sumup") ("OPERATOR" "(") ("OPERATOR" "-") ("IDENTIFIER" "x") ("INTEGER" "1")
("OPERATOR" ")") ("OPERATOR" ")") ("OPERATOR" ")") ("OPERATOR" ")") ("OPERATOR" ")"))
```

## Parser
Parser written in CommonLisp.

All the functions implemented are recursive and obey the principles of Functional Programming.

For a given description/grammer of the G++ language the parser implemented parses a given tokenized G++ program.

To test the program you should invoke function parser("tokenized list") which takes tokenized G++ program. 

The output of the function is a parse tree of a given program. The output is also written to a file. 

The code includes detailed explanation. 

If an unexpected token is to be entered the error message is printed out as shown below.
 - *** - Unexpected token in in parseExplisti     

                       
For a graphical visualization of a parse tree  , please follow instruction below.	
 - Assign outputStyle 1	
 - Call parser function and copy the output then go to https://lautgesetz.com/latreex/
 
 <img  height="300" src="https://raw.githubusercontent.com/onurpolattimur/G-Language-Lexer-Parser/master/tree.png">


**Usage:**

To tokenize the program you wish to parse, you may use the lexer which is can be found in this repositories.
```sh
$ parser(tokenList)
```

**Sample Input:**

```sh
(setq tokenList '(
("OPERATOR" "(") ("KEYWORD" "deffun") ("IDENTIFIER" "sumup") ("OPERATOR" "(") ("IDENTIFIER" "x")
("OPERATOR" ")") ("OPERATOR" "(") ("KEYWORD" "if") ("OPERATOR" "(") ("KEYWORD" "equal")("IDENTIFIER" "x")
("INTEGER" "0") ("OPERATOR" ")") ("INTEGER" "1") ("OPERATOR" "(") ("OPERATOR" "+") ("IDENTIFIER" "x")
("OPERATOR" "(") ("IDENTIFIER" "sumup") ("OPERATOR" "(") ("OPERATOR" "-") ("IDENTIFIER" "x") ("INTEGER" "1")
("OPERATOR" ")") ("OPERATOR" ")") ("OPERATOR" ")") ("OPERATOR" ")") ("OPERATOR" ")"))
)
```
**Sample Output:**
```sh
|START
|_INPUT
|__EXPI
|___(
|___deffun
|___ID
|____sumup
|___IDLIST
|____(
|____IDLIST
|_____ID
|______x
|____)
|___EXPLISTI
|____EXPI
|_____(
|_____if
|_____EXPB
|______(
|______equal
|______EXPI
|_______ID
|________x
|______EXPI
|_______VALUES
|________IntegerValue
|_________0
|______)
|_____EXPLISTI
|______EXPI
|_______VALUES
|________IntegerValue
|_________1
|_____EXPLISTI
|______EXPI
|_______(
|_______+
|_______EXPI
|________ID
|_________x
|_______EXPI
|________(
|________ID
|_________sumup
|________EXPLISTI
|_________EXPI
|__________(
|__________-
|__________EXPI
|___________ID
|____________x
|__________EXPI
|___________VALUES
|____________IntegerValue
|_____________1
|__________)
|________)
|_______)
|_____)
|___)
```
