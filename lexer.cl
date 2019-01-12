(setq charClass  nil)
(setq readedChar nil)
(setq currentToken 	nil)

(defconstant keywordList '("AND" "OR" "NOT" "EQUAL" "APPEND" "CONCAT" "SET" "DEFFUN" "FOR" "WHILE" "IF" "EXIT"))
(defconstant operatorList '("+" "-" "*" "/" "(" ")"))
(defconstant EOF  0)
(defconstant LETTER  1)
(defconstant DIGIT   2)
(defconstant UNKNOWN 3)

(defconstant KEYWORD "KEYWORD")
(defconstant BINARY "BINARY")
(defconstant IDENT "IDENTIFIER")
(defconstant INTEGER "INTEGER")
(defconstant OPERATOR "OPERATOR")

;Get next character from the opened file.
;If readed characted is nil(EOF) then close the file.
(defun readChar()
	
	(setq c (read-char inputFile nil 'End-File))
	(cond 
		((eq 'End-File c)
				(close inputFile)		
		)
		
	)
	;Determine character class LETTER, DIGIT, UNKWOWN.
	(setq readedChar c)
	(setq charClass (determineCharClass c))
	c
)
;Determine character class from the parameter.
(defun determineCharClass(C)
	(cond 
		((eq 'End-File C)
			EOF
		)
		;Check, character C is [a-z, A-Z]
		((alpha-char-p C)
			LETTER
		)
		;Check, character C is [0-9]
		((not (null (digit-char-p C)))
			DIGIT
		)
		;Else UNKNOWN, may be operator.
		(t
			UNKNOWN
		)
	)
)

;The main function, takes fileName as parameter.
;Read first character and call the recursive function lex.
;resultList keep tokens and tokens values.
;At the end, return resultList.
(defun lexer(fileName)
	(setq resultList nil)
	;Dosyayı aç.
	(setq inputFile (open fileName)) 
	(readChar)
	(setq lexStr (string ""))

	(lex readedChar readedChar charClass lexStr)
	(setq resultList (reverse resultList))
	resultList

)
;lex is a recursive function.
;The algorithm is based on DFA.
(defun lex(previousCharacter currentChar currentClass lexemeString)
	(cond
		;If currentChar is EOF then, set the token. 
		((eq 'End-File currentChar)
			(setToken (getTokenType (determineCharClass previousCharacter) previousCharacter) lexemeString)
			nil
		)
		;If the previous class is not equal current class then set token value with lexemeString.
		((not (equal (determineCharClass previousCharacter) currentClass))
			(cond
					((equal t (isSpaceChar currentChar))
							(getNotSpaceChar)
							(setq currentChar readedChar)
							(setq currentClass charClass)
					)
			)
			(setToken (getTokenType (determineCharClass previousCharacter) previousCharacter) lexemeString)
			(lex currentChar currentChar currentClass lexStr)
		)
		;If currentClass is digit
		((eq currentClass DIGIT)
			(readChar)
			(cond
				((AND (equal currentChar #\0) (= 0 (length lexemeString)))
					(setToken INTEGER (string #\0))
					(lex currentChar readedChar charClass (string ""))	
				)
				(t
					(lex currentChar readedChar charClass (concatenate 'string lexemeString (string currentChar)))	
				)
			)
				
		)
		;If currentClass is letter
		((eq currentClass LETTER)

			(readChar)
			(lex currentChar readedChar charClass (concatenate 'string lexemeString (string currentChar)))		
		)
		;If currentClass is UNKNOWN, may be operator or negative integer. 
		((eq currentClass UNKNOWN)
			(readChar)
			(getNotSpaceChar)
			(cond
				((AND (eq currentChar #\-) (eq charClass DIGIT) (not (eq readedChar #\0)))
					(lex readedChar readedChar charClass (concatenate 'string lexemeString (string currentChar)))
				)
				((AND (eq currentChar #\*) (eq charClass UNKNOWN) (eq readedChar #\*))
					(setToken OPERATOR (string "**"))
					(readChar)
					(getNotSpaceChar)
					(lex readedChar readedChar charClass lexemeString)		
				)
				(t
					(setToken (getTokenType (determineCharClass previousCharacter) previousCharacter) (concatenate 'string lexemeString (string currentChar)))
					(lex readedChar readedChar charClass lexemeString)		
				)
			)	
		)
	)
)
;Read while readed character is space character.
(defun getNotSpaceChar()
	(loop 
		while (and (not (eq readedChar 'End-File)) (eq t (isSpaceChar readedChar)))
		  
		  do (readChar)
	)
)
;Return t if readeChar is space, newLine or tab.
(defun isSpaceChar(c)
		(if(or (eq readedChar #\tab) (eq readedChar #\Space) (eq readedChar #\newline))
			t
			nil
		)
)
;Return token type. If classChar is UNKNOWN, then check it is valid operator. If it is not a valid operator, then write "Invalid Token" as token name.
(defun getTokenType(classChar characterReaded)

	(cond 
		((eq classChar LETTER)
			IDENT
		)
		((eq classChar DIGIT)
			INTEGER
		)
		((eq classChar UNKNOWN)
			(if (eq t (isOperator characterReaded))
				OPERATOR
				"Invalid Token"
			)
		)
	)
)

;Check whether the character is a operator.
(defun isOperator(characterReaded)
	(loop for key in operatorList
		do

		(cond 

			((equal  (string characterReaded) key)
				(return-from isOperator t)
			)
		)
			
	)
	(return-from isOperator nil)
)
;Check whether token value is in keywordList.
(defun isInKeywordList(lexemeString)
	(loop for key in keywordList
		do
		(cond 

			((equal  (string-upcase lexemeString) key)
				(return-from isInKeywordList t)
			)
		)
			
	)
	(return-from isInKeywordList nil)
)
;Create a token and add to result list.
(defun setToken(tokenName lexemeString)
	(cond
		((> (length lexemeString) 0)
				(cond 
					((or (equal (string-upcase lexemeString) "TRUE") (equal (string-upcase lexemeString) "FALSE"))
						(setq tokenName BINARY)
					)
					((eq t (isInKeywordList lexemeString))
						(setq tokenName KEYWORD)

					)
				)
				(setq token '())
				(push  (append lexemeString) token)
				(push  tokenName token)
				(push token resultList)
		)		
	)
)
