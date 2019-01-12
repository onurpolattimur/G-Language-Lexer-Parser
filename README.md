
#  G++ Language Lexer & Parser

G++ Lexer and Parser in common lisp.

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
(("operator" "(") ("keyword" "deffun") ("identifier" "sumup") ("operator" "(") ("identifier" "x")
("operator" ")") ("operator" "(") ("keyword" "if") ("operator" "(")("keyword" "equal") ("identifier" "x") 
("integer" "0") ("operator" ")") ("integer" "1") ("operator" "(") ("operator" "+") ("identifier" "x") 
("operator" "(")("identifier" "sumup") ("operator" "(") ("operator" "-") ("identifier" "x") ("integer" "1") 
("operator" ")") ("operator" ")") ("operator" ")") ("operator" ")") ("operator" ")"))
```

	
