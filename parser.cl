;################################################# CSE 341 Project 2 #######################################################
;## 																													  ##
;## Create by Onur Polattimur - 151044083																				  ##
;## Allowed Token Name List: KEYWORD, BINARY, IDENTIFIER, INTEGER, OPERATOR                                                  ##
;## The token and token value can be with uppercase or lowercase, it will not matter. The conversion is performed.	      ##
;## If an unexpected token is to be entered the error message is printed out as shown below.							  ##
;## 			*** - Unexpected token in in parseExplisti                                                                ##
;## If you want to see parse tree beautifly on a web site, please follow instruction below.								  ##
;## 	-> Assign outputStyle 1																							  ##
;## 	-> Call parser function and copy the output then go to https://lautgesetz.com/latreex/							  ##
;##																														  ##
;###########################################################################################################################

(setq outputStyle 0)
(setq parseTree nil)

;If an unexpected situation occurs this function is invoked which stops the program from running.
(defun error-case(str)
	(error (concatenate 'string "Unexpected token in " str)))

;Parser starter function that adds start and input to the tree. 
(defun parser(tokenList)

	(setq tokens tokenList)
	(setq parseTree nil)
	(addToTree "START" 0)
	(addToTree "INPUT" 1)
	(parserMain 1))


;Recursive main parser function that performs main tasks. 
;If the tokens are null the tree is printed to the console and the file. 
;If not it checks whether it is expi or expilisti and invokes the functions accordingly.
(defun parserMain (level)

  (cond 
     ((null  tokens)
      	(printTree (reverse parseTree))
      	(printToFile (reverse parseTree) (concatenate 'string "; DIRECTIVE: parse tree"  (string #\newline)))
      )
     ((not (equal nil (isInList '("'" "null") (getFirstLexeme))))
        (parseExplisti (+ 1 level))
        (parserMain level))
	 ((not (equal nil (isInList '("append" "concat") (getSecondLexeme))))
	 	(parseExplisti (+ 1 level))
	 	(parserMain level))
     (t (parseExpi (+ 1 level))
        (parserMain level))))
            	 

;Parse function for default keywords. 
;It calls the functions according to the keyword. Each keyword has it's own parsing function.
(defun parseKeyword(level)
  (cond
	((string= (getSecondLexeme) "deffun")
	(parseDeffun (+ 1 level)))

	((string= (getSecondLexeme) "defvar")
	(parseDefvar (+ 1 level)))

	((string= (getSecondLexeme) "set")
	(parseSet (+ 1 level)))

	((string= (getSecondLexeme) "if")
	(parseIf (+ 1 level)))

	((string= (getSecondLexeme) "while")
	(parseWhile (+ 1 level)))

	((string= (getSecondLexeme) "and")
	(parseAndOr (+ 1 level)))

	((string= (getSecondLexeme) "or")
	(parseAndOr (+ 1 level)))

	((string= (getSecondLexeme) "not")
	(parseNot (+ 1 level)))

	((string= (getSecondLexeme) "equal")
	(parseEqual (+ 1 level)))

	((string= (getSecondLexeme) "for")
	(parseFor (+ 1 level)))))
    


;Parses the equal keyword. 
;Firstly it checks the opening paranthesis.
;If the equal is followed by expi it calls expi parser function.
;If its expb it calls expb parser function.
;At the end it checks for the closing paranthesis.
;EXPB -> (equal EXPB EXPB) 
;EXPB -> (equal EXPI EXPI) 
(defun parseEqual(level)
	(openParanthesis level)
	(addToTree (getFirstLexeme) level)
	(removeFirst)
	(cond
		((not (equal nil (isInList '("and" "or" "not" "equal" "BINARY") (getFirstLexeme))))
            	 	 (parseEXPB level) 
			 		 (parseEXPB level))
		(t	(parseExpi  level)
			(parseExpi  level)))
	(closeParanthesis level)
)


;Parses not keyword. 
;Firstly it checks the opening paranthesis.
;Adds not keyword to the tree and invokes parse expb function.
;If the next expression is not expb it shows error.
;At the end it checks for the closing paranthesis.
;EXPB -> (not EXPB) 
(defun parseNot(level)

	(openParanthesis level)
	(addToTree (getFirstLexeme) level)
	(removeFirst)
	(parseEXPB level)
	(closeParanthesis level)
)


;Parses 'and' and 'or' keyword. Both of the keywords use same grammar type. 
;Firstly it checks the opening paranthesis.
;Adds 'and' or 'or' keyword to the tree and invokes parse expb function twice.
;If the next expression is not expb it shows error.
;At the end it checks for the closing paranthesis.
;EXPB -> (and EXPB EXPB)
;EXPB -> (or EXPB EXPB)
(defun parseAndOr(level)

	(openParanthesis level)
	(addToTree (getFirstLexeme) level)
	(removeFirst)
	(parseEXPB level)
	(parseEXPB level)
	(closeParanthesis level)
)


;Parses for keyword. 
;Firstly it checks the opening paranthesis.
;Adds for keyword to the tree. 
;Checks for the opening paranthesis.
;Invokes parse id function firstly.
;Moreover, parse expi is called twice.
;Checks for the closing paranthesis.
;Then it invokes the expilisti parser function.
;At the end it checks for the closing paranthesis.
;The functions are called because those keywords are expected according to the grammer rules.
;EXPI -> (for (ID EXPI EXPI) EXPLISTI) 
(defun parseFor(level)
	(openParanthesis level)
	(addToTree "for" level)
	(removeFirst)
	(openParanthesis level)
	(parseID level)
	(parseExpi level)
	(parseExpi level)
	(closeParanthesis level)
	(parseExplisti level)
	(closeParanthesis level))


;Parses while keyword. 
;Firstly it checks the opening paranthesis.
;Adds while keyword to the tree. 
;Checks for the opening paranthesis.
;Invokes parse expb function firstly.
;Checks for the closing paranthesis.
;Then it invokes the expilisti parser function.
;At the end it checks for the closing paranthesis.
;The functions are called because those keywords are expected according to the grammer rules.
;EXPI -> (while (EXPB) EXPLISTI) 
(defun parseWhile (level)
	(openParanthesis level)
	(addToTree "while" level)
	(removeFirst)
	(openParanthesis level)
	(parseEXPB level)
	(closeParanthesis level)
	(parseExplisti level)
	(closeParanthesis level))


;Parses defvar keyword. 
;Firstly it checks the opening paranthesis.
;Adds defvar keyword to the tree. 
;Invokes parse id function firstly.
;Then it invokes the expi parser function.
;At the end it checks for the closing paranthesis.
;The functions are called because those keywords are expected according to the grammer rules.
;EXPI -> (defvar ID EXPI) 
(defun parseDefvar (level)
	(openParanthesis level)
	(addToTree "defvar" level)
	(removeFirst)
	(parseID level)
	(parseExpi level)
	(closeParanthesis level))


;Parses deffun keyword. 
;Firstly it checks the opening paranthesis.
;Adds deffun keyword to the tree. 
;Invokes parse id function firstly.
;Then it invokes the id list parser function.
;Moreover, it invokes the explisti parser function.
;At the end it checks for the closing paranthesis.
;The functions are called because those keywords are expected according to the grammer rules.
;EXPI -> (deffun ID IDLIST EXPLISTI) 
(defun parseDeffun (level)
	(openParanthesis level)
	(addToTree "deffun" level)
	(removeFirst)
	(parseID level)
	(parseIdList level)
	(parseExplisti level)
	(closeParanthesis level))


;Parses set keyword. 
;Firstly it checks the opening paranthesis.
;Adds set keyword to the tree. 
;Invokes parse id function firstly.
;Then it invokes the expi parser function.
;At the end it checks for the closing paranthesis.
;The functions are called because those keywords are expected according to the grammer rules.
;EXPI -> (set ID EXPI) 
(defun parseSet(level)
	(openParanthesis level)
	(addToTree "set" level)
	(removeFirst)
	(parseID level)
	(parseExpi level)
	(closeParanthesis level))


;Parses concat keyword. 
;Firstly it checks the opening paranthesis.
;Adds concat keyword to the tree. 
;It invokes the expilisti parser function twice.
;At the end it checks for the closing paranthesis.
;The functions are called because those keywords are expected according to the grammer rules.
;EXPLISTI -> (concat EXPLISTI EXPLISTI) 
(defun parseConcat(level)
	(openParanthesis level)
	(addToTree (getFirstLexeme) level)
	(removeFirst)
	(parseExplisti level)
	(parseExplisti level)
	(closeParanthesis level)
)


;Parses append keyword. 
;Firstly it checks the opening paranthesis.
;Adds append keyword to the tree. 
;Invokes parse expi function firstly.
;Then it invokes the expilisti parser function.
;At the end it checks for the closing paranthesis.
;The functions are called because those keywords are expected according to the grammer rules.
;EXPLISTI ->  (append EXPI EXPLISTI)
(defun parseAppend(level)
	(openParanthesis level)
	(addToTree (getFirstLexeme) level)
	(removeFirst)
	(parseExpi level)
	(parseExplisti level)
	(closeParanthesis level)
)

;Parses operator keywords +,-,/,*
;For each operator the same function is used since they have the same grammar rule.
;Firstly it checks the opening paranthesis.
;Adds operator in token to the tree. 
;Invokes parse expi function twice.
;At the end it checks for the closing paranthesis.
;The functions are called because those keywords are expected according to the grammer rules.
;EXPI -> (+ EXPI EXPI) 
;EXPI -> (- EXPI EXPI) 
;EXPI -> (* EXPI EXPI) 
;EXPI -> (/ EXPI EXPI) 
(defun parseOperator (level)
  (cond
     ((or (string= "+" (getSecondLexeme)) (string= "-" (getSecondLexeme)) (string= "/" (getSecondLexeme)) (string= "*" (getSecondLexeme))) 
      (openParanthesis level)
      (addToTree (getFirstLexeme) level)
      (removeFirst)
      (parseExpi level)
      (parseExpi level)
      (closeParanthesis level))
     (t
      (error-case "parseOperator"))))



;Parses if keyword.
;Firstly it checks the opening paranthesis.
;Adds if keyword to the tree. 
;Invokes parse expb function firstly.
;Then it invokes explisti parser function. 
;Then it checks if the next token is closing paranthesis. If so it calls closing paranthesis function.
;Otherwise it invokes expilisti parser function again.
;At the end it checks for the closing paranthesis.
;The functions are called because those keywords are expected according to the grammer rules.
;EXPI -> (if EXPB EXPLISTI)
;EXPI -> (if EXPB EXPLISTI EXPLISTI) 
(defun parseIf(level)

	(openParanthesis level)
	(addToTree "if" level)
	(removeFirst)
	(parseEXPB level)
	(parseExplisti  level)
	(cond
	((string= (getFirstLexeme) ")")
		(closeParanthesis level))

	(t
		(parseExplisti level)
		(closeParanthesis level))))

;Parses expb.
;Adds expb to the list.
;Firstly it checks if the token is binary value, if so it adds binaryvalue and its value to the tree. 
;If it is not binaryvalue and it is a keyword it invokes the keyword parser function. 
;In other cases it prints out error message since the grammar rules are disobeyed. 
;EXPB -> (and EXPB EXPB)
;EXPB -> (or EXPB EXPB)
;EXPB -> (not EXPB)
;EXPB -> (equal EXPB EXPB)
;EXPB -> (equal EXPI EXPI)
;EXPB -> BinaryValue 
(defun parseEXPB(level)
	(addToTree "EXPB" level)
	(cond 
		((string= (getFirstToken) "BINARY")
			(addToTree "BINARYVALUE" (+ 1 level))
			(addToTree (getFirstLexeme) (+ 2 level))
			(removeFirst))
		((string= (getsecondToken) "KEYWORD")
			(parseKeyword level))
		(t (error-case "in parseEXPB"))))


;Parses id.
;Checks if the next token is id, if it is not id it prints the error message.
;If the next token is id adds it and its value to the tree.
;Get ID value from token's value.
(defun parseID (level)
	(cond 
		((not (string= (getFirstToken) "IDENTIFIER"))
			(error-case "in parseId"))
		(t	(addToTree "ID" level)
			(addToTree (getFirstLexeme) (+ level 1))
			(removeFirst))))

;Parses idlist.
;Adds idlist to the tree.
;It checks if the next token is opening paranthesis
;		-> calls open paranthesis function.
;		-> then it calls idlist parser function. 
;		-> then it calls the closing paranthesis function.
;		-> this situation is equivalent to (IDLIST).
;If the next token is id it invokes the parse id function. And if the next token is also id,
;then it calls parse idlist function. This situation is equivalent to ID IDLIST.
;Otherwise it prints out the error message.
;IDLIST -> ID | (IDLIST) | ID IDLIST 
(defun parseIDList (level)
	(addToTree "IDLIST" level)
	(cond 
		((string= (getFirstLexeme) "(")
			(openParanthesis (+ 1 level))
			(parseIDList  (+ 1 level))
			(closeParanthesis (+ 1 level)))
		((string= "IDENTIFIER" (getFirstToken))
			(parseID (+ 1 level))
			(cond	((string= "IDENTIFIER" (getFirstToken))
					(parseIDList (+ 1 level)))))
		(t
			(error-case "in parseIdList"))))


;Parses expi.
;Adds expi to the tree. 
;If the next token is id it invokes the id parser function. 
;If the next token is integer it invokes integer parser function. 
;If the token  after that is id:
;							 -> Checks for the paranthesis first.
;							 -> Then it invokes parser id function.
;						     -> Next it invokes parse explisti function. 
;							 -> Finally it invokes closing paranthesis function.
;							 -> This is equivalent to: (ID EXPLISTI) 
;If the token is keyword it invokes keyword parsing function.
;If the token is operator it invokes operator parsing function.
;Otherwise it prints out error message.
(defun parseExpi(level)
	(addToTree "EXPI" level)
	(cond 
		((null tokens) nil)
		((string= "IDENTIFIER" (getFirstToken)) ;ID
			(parseID (+ 1 level)))
		((string= "INTEGER" (getFirstToken) ) ;VALUES 
			(parseIntegerValue level))
		((string= "IDENTIFIER" (getsecondToken)) ;(ID EXPLISTI) 
			(openParanthesis (+ 1 level))
			(parseID (+ 1 level))
			(parseExplisti (+ 1 level))
			(closeParanthesis (+ 1 level)))
		((string= (getsecondToken) "KEYWORD")
			(parseKeyword level))
		((string= (getsecondToken) "OPERATOR")
			(parseOperator (+ 1 level)))
		(t
			(error-case "in parseExpi")
		)))
	

;Parses expilisti.
;Adds expilisti to the tree. 
;If the token is opening paranthesis: 
;								   -> if the token is operator it calls expi parser function.
;								   -> if the token is concat it calls concat parser function.
;								   -> if the token is append it calls append parser function.
;								   -> if the token is keyword it calls expi parser function.
;								   -> if the token is operator it calls expi parser function.
;If the token is not opening paranthesis:
;								   -> if the token is id it calls expi parser function.
;								   -> if the token is integer it calls expi parser function.
;								   -> if the token is null it adds null to the tree. 
;								   -> if the token is ' it adds ' to the tree then it checks for the opening paranthesis 
;									  and if it is not followed by closing paranthesis it calls values parser => ‘( VALUES ).
;                                     Lastly it invokes closing paranthesis function.						
;EXPLISTI -> (concat EXPLISTI EXPLISTI) | (append EXPI EXPLISTI) | null | ‘( VALUES ) | ‘()  | EXPI
(defun parseExplisti(level)
	(addToTree "EXPLISTI" level)
	(cond 
		((string= "(" (getFirstLexeme))
			(cond 
				((string= "OPERATOR" (getsecondToken))
					(parseExpi (+ 1 level)))
				((string= "concat" (getSecondLexeme))  
					(parseConcat (+ 1 level)))
				((string= "append" (getSecondLexeme))  
					(parseAppend (+ 1 level)))
				((string= "KEYWORD" (getsecondToken))
					(parseExpi (+ 1 level)))
				((string= "IDENTIFIER" (getsecondToken))
					(parseExpi (+ 1 level)))))
		((string= "IDENTIFIER" (getFirstToken))
			(parseExpi (+ 1 level))
		)
		((string= "INTEGER" (getFirstToken))
			(parseExpi (+ 1 level))
		)
		((string= "null" (getFirstLexeme))
			(addToTree "null" (+ 1 level))
			(removeFirst)
		)
		((string= "'" (getFirstLexeme))
			(addToTree "'" (+ 1 level))
			(removeFirst)
			(openParanthesis (+ 1 level))
			(cond
				((not (string= ")" (getFirstLexeme)))
					 (parseValues level)
				)
			)
			(closeParanthesis  (+ 1 level))
		)

	)
)

;Parses integer values.
;Adds values to the tree with their corresponding values.
(defun parseIntegerValue(level)
	(addToTree "VALUES" (+ 1 level))
	(addToTree "IntegerValue" (+ 2 level))
	(addToTree (getFirstLexeme) (+ 3 level))
	(removeFirst)
)

;Parses values.
;Adds values to the tree with their corresponding values.
;If next token is integer it calls parse values. 
;VALUES -> IntegerValue VALUES | IntegerValue 
(defun parseValues(level)
	(addToTree "VALUES" (+ 1 level))
	(addToTree "IntegerValue" (+ 2 level))
	(addToTree (getFirstLexeme) (+ 3 level))
	(removeFirst)
	(cond 
		((string= (getFirstToken) "INTEGER")
			(parseValues (+ 1 level))
		)
	)
)

;################# HELPER FUNCTIONS ####################

;Gets first token value in the token list.
(defun getFirstLexeme()
   (string-downcase (car (cdr (car tokens)))))

;Gets first token in the token list.
(defun getFirstToken()
  (string-upcase (car (car tokens))))

;Gets second token value in the token list.
(defun getSecondLexeme()
  (string-downcase (car (cdr (car (cdr tokens))))))

;Gets second token in the token list. 
(defun getsecondToken()
  (string-upcase (car (car (cdr tokens)))))


;Opening paranthesis function. 
;Checks if the token is opening paranthesis. If so it adds it to the tree.
;Otherwise it prints out error.
(defun openParanthesis(level)

  (cond
     ((string= (car (cdr (car tokens))) "(")
      (addToTree "(" level)
      (removeFirst))
    
     (t
      (error-case "in openParanthesis"))))

;Closing paranthesis function. 
;Checks if the token is closing paranthesis. If so it adds it to the tree.
;Otherwise it prints out error.
(defun closeParanthesis(level)
  (cond
     ((string= (car (cdr (car tokens))) ")")
      (addToTree ")" level)
      (removeFirst))
    
     (t
      (error-case "in closeParanthesis"))))
  
;Prints the tree.  
(defun printTree(parseTree)

  (cond 
     ((not (null  parseTree))
      ;(print (car parseTree))
      (format t (car parseTree))
      (terpri)
      (printTree (cdr parseTree)))))

;Prints the tree to the output file: 151044083.tree
(defun printToFile(parseTree str)
	(cond
		((null parseTree)
			(with-open-file (outfile "151044083.tree" :direction :output)
				 (format outfile str))
			(print "Parse tree has been saved to file 151044083.tree")
			nil
		)
		(t
			(printToFile (cdr parseTree) (concatenate 'string str (car parseTree) (string #\newline)))
		)
	))

;Helper function for print tree. It helps for node alignment. It adds underlines. 
(defun addUnderLine (str level)

  (cond 
     ((= level 0)
      str)
    
     (t 
     	(cond 
     		((= outputStyle 1)
     			(setq strRes (concatenate 'string str (string #\-)))
      			(addUnderLine (concatenate 'string str (string #\-)) (- level 1)))
     		(t
     			(setq strRes (concatenate 'string str (string #\tab)))
      			(addUnderLine (concatenate 'string str (string #\tab)) (- level 1)))
     	))))

;Removes the first token in the token list.    
(defun removeFirst ()

  (setq tokens (cdr tokens)))

;Adds element to the tree according to its level.
(defun addToTree (element level)
	(cond 
		((= outputStyle 1)
			(push (concatenate 'string (addUnderLine "" level) (string element)) parseTree))
		(t
			(push (concatenate 'string (addUnderLine "" level) (string element)) parseTree))))
	

;Checks if an key is in the list.
(defun isInList(elements key)
	(cond ((null elements) nil)
      ((equal (car elements) key) t)
      (t (isInList (cdr elements) key))))