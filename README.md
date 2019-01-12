# G-Language-Lexer-Parser
G++ Lexer and Parser in common lisp.

LEXER

Lexer written in CommonLisp. 
Given the description of the G++ language that is shown below the lexer implemented does tokenization of a given G++ program. The program is given in a file. 
To test the code you need to call function lexer("filename.txt") which takes as a parameter a file that contains program with G++ syntax.
After the lexical analysis is performed the output is the tokens of the program. 

Usage: lexer("filename.txt")


Properties of G++ Language:

G++ is a Gebze Technical University programming language with:
• Lisp like syntax
• Imperative, non-object oriented
• Static scope, static binding, strongly typed, …
• Keywords: and, or, not, equal, append, concat, set, deffun, for, while, if, exit
• Operators: +, -, /, *, (, ), **
• Terminals:
• Keywords, operators, 0-9
• BinaryValue -> true | false
• IntegerValue -> [-]*[1-9]*[0-9]+
• Id – [a-zA-z]+
• Non-terminals: START, INPUT, EXPLISTI, EXPI, EXPB, …
