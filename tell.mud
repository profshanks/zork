<NEWTYPE PSTRING WORD>
<SETG RUBOUT? <>>
<SETG RUVEC <IUVECTOR 4>>
<SETG NO-TELL 0>
<SETG IN-TELL 0>
<SETG TELL-VEC <IUVECTOR 7>>

;"Print some strings to ,OUTCHAN"
<TITLE	TELL>
	<DECLARE ("VALUE" ATOM <PRIMTYPE STRING> "OPTIONAL" FIX
		  <OR STRING FALSE> <OR STRING FALSE>)>
	<MOVE	A* AB>
LOOP	<PUSH	TP* (AB)>
	<PUSH	TP* 1(AB)>
	<ADD	AB* [<(2) 2>]>
	<JUMPL	AB* LOOP>
	<HLRES	A>
	<ASH	A* -1>
	<ADDI	A* TABEND>
	<PUSHJ	P* @ (A) 1>
	<JRST	FINIS>
	<TELL4>
	<TELL3>
	<TELL2>
TABEND	<TELL1>

	<INTERNAL-ENTRY TELL1 1>		; "push 1"
	<PUSH	TP* <TYPE-WORD FIX>>
	<PUSH	TP* [1]>
	<INTERNAL-ENTRY TELL2 2>
	<PUSH	TP* <TYPE-WORD FALSE>>
	<PUSH	TP* [0]>
	<INTERNAL-ENTRY TELL3 3>
	<PUSH	TP* <TYPE-WORD FALSE>>
	<PUSH	TP* [0]>
	<INTERNAL-ENTRY TELL4 4>
	<SUBM	M* (P)>
	<INTGO>
	<PUSHJ	P* SETUP>		; "SETUP FOR INTERRUPTS"
	 <JRST	[<PUSH	TP* <TYPE-WORD FALSE>>
		 <PUSH	TP* [0]>
		 <DPUSH	TP* <PQUOTE <STRING <ASCII 13> <ASCII 10>>>>
		 <MOVE	C* <MQUOTE <RGLOC OUTCHAN T>>>
		 <ADD	C* GLOTOP 1>
		 <MOVE	C* 1(C)>
		 <PUSH	P* 1(C)>
		 <MOVEI	C* 0>
		 <PUSHJ	P* DOSIOT>	; "PRINT CRLF"
		 <SUB	TP* [<(2) 2>]>
		 <JRST	INTLV>]>
INTLV	 <JRST	[<SUB	P* [<(1) 1>]>
		 <JRST	RLDONE1>]>	; "RETURN FROM NON-PRINT"
	<MOVE	C* <MQUOTE <RGLOC OUTCHAN T>>>
	<ADD	C* GLOTOP 1>
	<MOVE	C* 1(C)>
	<MOVE	C* 1(C)>		; "CHANNEL NUMBER IN C"
	<PUSH	P* C>			; "SAVE ON STACK"
	<MOVE	E* <MQUOTE <RGLOC SCRIPT-CHANNEL T>>>
	<ADD	E* GLOTOP 1>
	<PUSH	TP* (E)>
	<PUSH	TP* 1(E)>
	<MOVE	O* -6(TP)>		; "FIX SPECIFYING WHEN TO DO CR'S"
	<TRNN	O* 2>			; "SKIP IF PRINT CR BEFORE"
	 <JRST	PTFST>
	<PUSH	TP* <PQUOTE <STRING <ASCII 13> <ASCII 10>>>>
	<PUSH	TP* <MQUOTE <STRING <ASCII 13> <ASCII 10>>>>
	<MOVEI	C* 0>
	<PUSHJ	P* DOSIOT>
PTFST	<LDB	C* [<(*220913*) -6>]>	; "MAYBE THE GUY GAVE A LENGTH FOR THIS?"
	<PUSH	TP* -9(TP)>		; "PUSH ARGS FOR DOSIOT"
	<PUSH	TP* -9(TP)>
	<PUSHJ	P* DOSIOT>
	<INTGO>
	<GETYP	O* -5(TP)>
	<CAIN	O* <TYPE-CODE FALSE>>	; "IS IT FALSE?"
	<JRST	DONE>
	<PUSH	TP* -5(TP)>
	<PUSH	TP* -5(TP)>		; "ARGS"
	<MOVEI	C* 0>
	<PUSHJ	P* DOSIOT>		; "DO PRINT"
	<GETYP	O* -3(TP)>
	<CAIN	O* <TYPE-CODE FALSE>>
	<JRST	DONE>
	<PUSH	TP* -3(TP)>
	<PUSH	TP* -3(TP)>
	<MOVEI	C* 0>
	<PUSHJ	P* DOSIOT>
DONE	<MOVE	O* -6(TP)>
	<TRNN	O* 1>			; "CR AFTER?"
	 <JRST	RLDONE>
	<PUSH	TP* <PQUOTE <STRING <ASCII 13> <ASCII 10>>>>
	<PUSH	TP* <MQUOTE <STRING <ASCII 13> <ASCII 10>>>>
	<MOVEI	C* 0>
	<PUSHJ	P* DOSIOT>		; "PRINT CRLF"
RLDONE	<MOVE	A* <MQUOTE <RGLOC IN-TELL T>>>
	<ADD	A* GLOTOP 1>
	<SETZM	1(A)>			; "NO LONGER IN TELL"
	<SUB	P* [<(2) 2>]>		; "CLEAN UP P"
	<SUB	TP* [<(2) 2>]>
RLDONE1	<SUB	TP* [<(8) 8>]>
	<MOVE	C* <MQUOTE <RGLOC TELL-FLAG T>>>	;"SETG TELL-FLAG"
	<ADD	C* GLOTOP 1>
	<MOVE	A* <TYPE-WORD ATOM>>
	<MOVEM	A* (C)>
	<MOVE	B* <MQUOTE T>>
	<MOVEM	B* 1(C)>
	<JRST	MPOPJ>
; "SET UP FOR INTERRUPTS"
SETUP	<SUBM	M* (P)>
	<PUSH	P* (P)>
	<MOVE	A* <MQUOTE <RGLOC NO-TELL T>>>
	<ADD	A* GLOTOP 1>
	<SKIPGE	1(A)>		; "IF ALREADY TURNED OFF, JUST LEAVE"
	 <JRST	SPOPJ>
	<SKIPL	-4(TP)>		; "DO THIS ONLY IF TOLD TO"
	 <JRST	SETUPO>
	<MOVE	A* <MQUOTE <RGLOC TELL-VEC T>>>
	<ADD	A* GLOTOP 1>
	<MOVE	A* 1(A)>
	<HLRE	B* A>
	<ADDI	B* 1>
	<MOVNS	B>
	<ADDI	B* (A)>
	<HRLI	A* AB>
	<SUB	P* [<(1) 1>]>
	<BLT	A* (B)>
	<ADD	P* [<(1) 1>]>
	<MOVE	A* <MQUOTE <RGLOC IN-TELL T>>>
	<ADD	A* GLOTOP 1>
	<SETOM	1(A)>		; "NOW IN TELL"
SETUPO	<SOS	(P)>
SPOPJ	<SOS	(P)>		; "SKIP TWICE NORMALLY, ONCE IF NOT PRINTING"
	<JRST	MPOPJ>		; "SKIP RETURN"
;"SYSTEM DEPENDENT"
;"PUSHJ DOSIOT WITH ARGS ON TOP OF TP STACK; CHANNEL/JFN IS -1(P); SCRIPT CHANNEL
IS NEXT FROB ON TP.  FORTUNATELY, NO AC'S ARE SACRED.  C HAS # CHARS TO PRINT
IF NON-ZERO."
DOSIOT	<SUBM	M* (P)>
	<SKIPG	C>			; "IF C>0, THEN ITS THE # OF CHARS TO PRINT"
	 <HRRZ	C* -1(TP)>		; "GET STRING LENGTH"
	<PUSH	P* C>
	<MOVE	B* (TP)>		; "GET STRING"
	<SKIPL	-8(TP)>
	 <JRST	DOSIOT1>		; "ONLY ENABLE IF TOLD TO"
	<AOSN	INTFLG>
	 <JSR	LCKINT>			; "ENABLE INTERRUPTS"
DOSIOT1	<IFOPSYS (TENEX
		  <MOVNS C>		; "GET -LENGTH"
		 <JUMPE	C* DODONE>	; "0 LENGTH STRING"
		 <MOVE	A* -2(P)>		; "GET JFN"
		 <SOUT>			; "DO IT")
		(ITS
		 <*CALL	SIOT>
		  <JFCL>)>
	<SKIPGE	-6(TP)>
	 <SETZM	INTFLG>			; "DISABLE INTERRUPTS"
	<SKIPL	-2(TP)>			; "SCRIPTING?"
	 <JRST	DODONE>
	<MOVSI	A* <TYPE-CODE STRING>>
	<HRR	A* -1(TP)>
	<PUSH	TP* A>			; "PUSH STRING"
	<PUSH	TP* -1(TP)>
	<PUSH	TP* -5(TP)>		; "PUSH CHANNEL"
	<PUSH	TP* -5(TP)>
	<PUSH	TP* <TYPE-WORD FIX>>
	<PUSH	TP* (P)>
	<MCALL	3 PRINTSTRING>		; "DO PRINTSTRING"
DODONE	<SUB	TP* [<(2) 2>]>		; "GET RID OF ARGS"
	<SUB	P* [<(1) 1>]>
	<JRST	MPOPJ>
<IFOPSYS (ITS
	 SIOT	<SETZ>
		<SIXBIT	"SIOT">
		<-2(P)>
		<MOVE	B>
		<SETZ	C>)>


<TITLE	CTRL-S>
	<DECLARE ("VALUE" <OR ATOM DISMISS> CHARACTER CHANNEL)>
	<DPUSH	TP* (AB)>
	<DPUSH	TP* 2(AB)>
	<PUSHJ	P* ICTRL>
	<JRST	FINIS>

<INTERNAL-ENTRY ICTRL 2>
	<SUBM	M* (P)>
	<MOVE	B* -2(TP)>
	<CAIN	B* 7>			; "CTRL-G?"
	 <JRST	GACK>
	<IFOPSYS
	 (TENEX
	  <CAIE	B* %<ASCII !\>>)
	 (ITS
	  <CAIE	B* %<ASCII !\>>)>
	 <JRST	[<MOVSI A* <TYPE-CODE ATOM>>
		 <JRST	ICTRL1>]>	; "NOT CTRL-S, SO FLUSH"
	<SETZM	INTFLG>
	<MOVE	A* <MQUOTE <RGLOC INCHAN T>>>
	<ADD	A* GLOTOP 1>
	<DPUSH	TP* (A)>
	<MCALL	1 RESET>
	<PUSH	TP* <TYPE-WORD FALSE>>
	<PUSH	TP* [0]>
	<MCALL	1 TTY-INIT>
	<MOVE	A* <MQUOTE <RGLOC NO-TELL T>>>
	<ADD	A* GLOTOP 1>
	<SKIPGE	1(A)>		; "ALREADY TRUE?"
	 <JRST	ICTRLO>		; "YES, SO FLUSH"
	<SETOM	1(A)>		; "NO, SO MAKE IT TRUE"
	<MOVE	A* <MQUOTE <RGLOC IN-TELL T>>>
	<ADD	A* GLOTOP 1>
	<SKIPL	1(A)>		; "IN TELL?"
	 <JRST	ICTRLO>		; "NO, FLUSH"
	<SETZM	1(A)>		; "NOT ANY MORE"
	<PUSH	TP* <TYPE-WORD FIX>>
	<PUSH	TP* [0]>
	<MCALL	1 INT-LEVEL>	; "FIX UP INTERRUPTS"
	<MOVE	A* <MQUOTE <RGLOC TELL-VEC T>>>
	<ADD	A* GLOTOP 1>	; "GET POINTER TO SAVED AC'S (N OF THEM)"
	<MOVE	A* 1(A)>	; "PICK UP POINTER"
	<HLRE	B* A>		; "# OF AC'S IS IN B"
	<ADDI	B* P 1>		; "FIRST ONE"
	<HRLS	A>
	<HRR	A* B>		; "BLT POINTER IN A"
	<BLT	A* P>		; "BLT THE AC'S BACK"
	<JRST	MPOPJ>		; "AND LEAVE"
ICTRLO	<MOVSI	A* <TYPE-CODE DISMISS>>
ICTRL1	<MOVEI	B* <MQUOTE 'T>>
	<SUB	TP* [<(4) 4>]>
	<JRST	MPOPJ>
GACK	<MOVE	A* <MQUOTE <RGLOC INCHAN T>>>
	<ADD	A* GLOTOP 1>
	<DPUSH	TP* (A)>
	<MCALL	1 RESET>
	<PUSH	TP* <TYPE-WORD FALSE>>
	<PUSH	TP* [0]>
	<MCALL	1 TTY-INIT>
	<PUSH	TP* <TYPE-WORD FALSE>>
	<PUSH	TP* [0]>
	<PUSH	TP* <TYPE-WORD ATOM>>
	<PUSH	TP* <MQUOTE CONTROL-G?!-ERRORS>>
	<MCALL	2 HANDLE>
	<JRST	ICTRLO>

;"Get current time in disk format"
;"SYSTEM DEPENDENT (GROSSLY)"
<TITLE DSKDATE>
	<DECLARE ("VALUE" WORD)>
	<PUSHJ	P* IDSKDATE>
	<JRST	FINIS>

<INTERNAL-ENTRY IDSKDATE 0>
	<SUBM	M* (P)>
	<IFOPSYS (TENEX
		  <HRROI	B* -1>	; "-1 TO SAY CURRENT TIME"
		 <MOVEI	D* 0>		; "NOTHING FANCY"
		 <ODCNV>		; "GET IT: B HAS YEAR,,MONTH; C DAY,,; D ,,TIME"
		 <TLZ	D* -1>		; "CLEAN OUT LH OF D"
		 <ASH	D* 1>		; "TIME IN HALF-SECONDS"
		 <HLRZS	C>		; "GET DAY OF MONTH -1"
		 <ADDI	C* 1>		; "DO THE RIGHT THING"
		 <DPB	C* [<(*220500*) D>]>	; "STUFF DAY INTO D"
		 <IDIV	B* [(1)]>	; "SPLIT B IN HALF"
		 <ADDI	C* 1>		; "GET REAL MONTH"
		 <DPB	C* [<(*270400*) D>]>	; "STUFF IN MONTH"
		 <IDIVI	B* 100>		; "GET YEAR OF CENTURY IN C"
		 <DPB	C* [<(*330700*) D>]>	; "STUFF IN YEAR"
		 <MOVE	B* D>
		 <MOVE	A* <TYPE-WORD WORD>>
		 <JRST	MPOPJ>)
		(ITS
		 <*CALL	RQDATE>
		  <SETO	B*>
		 <MOVE	A* <TYPE-WORD WORD>>
		 <JRST	MPOPJ>
		 RQDATE	<SETZ>
		 <SIXBIT "RQDATE">
		 <SETZM	B>)>

;"GET STRING OF USER NAME (OR SOMETHING LIKE THAT)"
<TITLE	GXUNAME>
	<DECLARE ("VALUE" STRING)>
	<PUSHJ	P* IXUNAME>
	<JRST	FINIS>

<INTERNAL-ENTRY IXUNAME 0>
	<SUBM	M* (P)>
	<IFOPSYS (TENEX
		  <GJINF>		; "GET DIRECTORY NUMBER IN B"
		 <MOVE	B* A>
		 <MOVE	C* <MQUOTE <RGLOC SCRATCH-STR T>>>
		 <ADD	C* GLOTOP 1>
		 <MOVE	A* 1(C)>
		 <DIRST>
		 <JFCL>
		 <MOVE	B* 1(C)>
		 <MOVE	A* (C)>
		 <JRST	MPOPJ>)
		(ITS
		 <*SUSET	[<(*74*) A>]>
		 <PUSH	TP* <TYPE-WORD WORD>>
		 <PUSH	TP* A>
		 <PUSHJ	P* ISIXTO>
		 <JRST	MPOPJ>
		 ;"TAKES WORD ON TOP OF TP, RETURNS STRING"
	ISIXTO	 <SUBM	M* (P)>
		 <LDB	O* [<(*000613*) 0>]>	; "LAST BYTE IN WORD"
		 <MOVEI	C* 1>
		 <JUMPE	O* CONTIN>
		 <MOVEI	C* 2>			; "NUMBER OF WORDS REQUIRED"
	CONTIN	 <PUSH	P* C>			; "SAVE #WORDS"
		 <MOVE	A* C>
		 <MOVEI	O* IBLOCK>
		 <PUSHJ	P* RCALL>		; "GET UVECTOR (IN A AND B)"
		 <MOVE	A* <TYPE-WORD STRING>>
		 <POP	P* C>
		 <MOVEI	O* 4(C)>		; "LENGTH IS FIVE OR SIX"
		 <HRR	A* O>			; "LENGTH OF STRING"
		 <ADD	C* B>
		 <MOVEI	O* <TYPE-CODE CHARACTER>>
		 <DPB	O* [<(*221503*) 0>]>	; "CLOBBER TYPE SLOT IN DOPE WORDS"
		 <HRLI	B* *440700*>		; "GET STRING POINTER TO UV"
; "AT THIS POINT, IN A AND B WE HAVE THE TYPE-VALUE WORD, ALMOST READY TO
RETURN.  ON TOP OF TP, THE WORD TO BE HACKED."
	START	 <PUSH	P* B>			; "SAVE BP TO RETURN"
		 <MOVE	C* (TP)>		; "GET WORD TO HACK IN C"
		 <MOVE	D* [<(*440600*) C>]>	; "AND SIXBIT POINTER IN D"
		 <HRRZ	E* A>			; "LENGTH OF STRING"
		 <JUMPE	E* DONE>		; "CAN'T HACK EMPTY STRING"
		 <CAILE	E* 6>
		 <MOVEI	E* 6>			; "MAX # CHARS"
	STRLOP	 <ILDB	O* D>			; "GET CHAR IN O"
		 <ADDI	O* *40*>
		 <IDPB	O* B>			; "STUFF CHAR INTO STRING"
		 <SOJG	E* STRLOP>
	DONE	 <POP	P* B>			; "GET OLD BP BACK"
		 <SUB	TP* [<(2) 2>]>
		 <JRST	MPOPJ>)>

;"Takes channel open to name file, returns string of name"
<IFOPSYS (TENEX
   <TITLE	GET-NAME>
	<DECLARE ("VALUE" <OR FALSE STRING>)>
	<PUSHJ	P* IGETNAME>
	<JRST	FINIS>
<INTERNAL-ENTRY IGETNAME 1>
	<SUBM	M* (P)>
;"FIRST, WE NEED A JFN TO THE CRETIN FILE WITH THE RIGHT CRETIN BITS."
	<MOVSI	A* *100001*>		; "I HOPE THIS MEANS GET
					EXISTING FILE, SHORT FORM"
	<MOVE	B* <MQUOTE "DSK:<IMSSS>DATSYS.PMAP ">>
					; "FILE NAME, ASCIZ"
	<GTJFN>
	 <JRST	OPLOST>			; "LOSE, LOSE"
	<TLZ	A* -1>
	<MOVE	B* [<(*440000*) *202200*>]>
					; "36 BYTE SIZE, THAWED MODE, DON'T HANG"
	<OPENF>
	 <JRST	OPLOST>
	<PUSH	P* A>			; "SAVE JFN"
	<MOVEI	A* 4>
	<PUSHJ	P* PGFIND>		; "GET FOUR  PAGES FROM INTERPRETER"
	<JUMPL	B* [<ERRUUO* <MQUOTE CANT-GET-PAGES>>]>
	<ASH	B* 1>			; "CRETIN TENEX"
	<PUSH	P* B>			; "SAVE PAGE NUMBER"
	<TLO	B* *400000*>		; "TURN ON 'ME' BIT"
	<HRLZ	A* -1(P)>		; "GET JFN"
	<HRRI	A* *60*>		; "PAGE IN FILE"
	<HRLI	C* *100000*>
	<MOVEI	D* *10*>
MLOP	<PMAP>				; "DO MAP"
	<ADDI	A* 1>
	<ADDI	B* 1>
	<SOJG	D* MLOP>		; "WORK ON 10X/20X"
	<GJINF>				; "DIRNUM IS IN A; B AND C HAVE GONE AWAY"
	<IMULI	A* 4>			; "OFFSET INTO BLOCK"
	<MOVE	B* (P)>			; "PAGE #, TENEX STYLE"
	<ASH	B* *11*>		; "MAKE IT AN ADDRESS"
	<ADDI	B* (A)>			; "ADDRESS OF BEGINNING OF STRING"
	<PUSH	P* B>			; "SAVE FOR EVENTUAL BLT"
	<HRLI	B* *440700*>		; "BYTE POINTER"
	<MOVEI	A* 0>			; "# OF CHARS"
LENLP	<ILDB	O* B>			; "GET CHAR"
	<JUMPE	O* ENDSTR>		; "DONE?"
	<AOJA	A* LENLP>		; "NO, INCREASE COUNT AND TRY AGAIN"
ENDSTR	<PUSH	P* A>			; "SAVE LENGTH"
	<IDIVI	A* 5>			; "# OF WORDS"
	<CAIE	B* 0>			; "REMAINDER 0?"
	 <ADDI	A* 1>			; "NOPE"
	<PUSH	P* A>			; "SAVE # WORDS"
	<MOVEI	O* IBLOCK>
	<PUSHJ	P* RCALL>		; "GET UV"
; "# OF WORDS IN STRING IS (P); LENGTH OF STRING IS -1(P); ADDRESS OF SOURCE IS -2(P);
   PAGE # OF MAPPED AREA IS -3(P)"
	<MOVE	D* B>
	<HRL	D* -2(P)>		; "SOURCE POINTER"
	<MOVEI	C* -1(D)>		; "DEST POINTER -1"
	<ADD	C* (P)>			; "END OF DESTINATION"
	<BLT	D* (C)>			; "GET STRING"
	<MOVEI	O* <TYPE-CODE STRING>>
	<DPB	O* [<(*221503*) 1>]>	; "CLOBBER DOPE WORDS"
	<HRLI	B* *440700*>
	<MOVSI	A* <TYPE-CODE STRING>>
	<HRR	A* -1(P)>		; "FINISH STRING POINTER"
	<PUSH	TP* A>			; "PUSH STRING"
	<PUSH	TP* B>
	<HRROI	A* -1>			; "A IS -1 FOR UNMAPPING"
	<MOVE	B* -3(P)>		; "PAGE #"
	<TLO	B* *400000*>
	<MOVE	C* [<(*400000*) *10*>]>	; "# PAGES"
	<PMAP>				; "UNMAP"
	<MOVE	A* -4(P)>		; "JFN"
	<CLOSF>				; "CLOSE, RELEASE JFN"
	<JFCL>
	<MOVE	B* -3(P)>
	<ASH	B* -1>
	<MOVEI	A* *4*>
	<PUSHJ	P* PGGIVE>		; "GIVE BACK PAGES"
	<POP	TP* B>
	<POP	TP* A>			; "GET STRING BACK"
	<SUB	P* [<(5) 5>]>		; "CLEAN UP P"
	<JRST	MPOPJ>			; "DONE"
OPLOST	<MOVE	A* <TYPE-WORD FALSE>>	; "RETURN FALSE"
	<MOVEI	B* 0>
	<JRST	MPOPJ>)>

<TITLE STARTER>
	<DECLARE ("VALUE" <OR FIX STRING>)>
	<PUSHJ	P* ISTART>
	<JRST	FINIS>

<INTERNAL-ENTRY ISTART 0>
	<SUBM	M* (P)>
<IFOPSYS (TENEX
; "NOW FIGURE OUT WHAT'S GOING ON WITH DIRECTORIES"
GETDIR	<MOVEI	A* *2500*>		; "ALMOST GUARANTEED--SHARING WITH SAVE FILE"
	<LSH	A* -9>			; "10X PAGE #"
	<HRLI	A* *400000*>		; "THIS PROCESS"
	<RMAP>				; "GET JFN IN LH OF B"
	<SKIPGE	A>
	 <JRST	D*>
	<HLRZ	B* A>			; "JFN TO THE RIGHT"
	<MOVE	D* <MQUOTE <RGLOC SCRATCH-STR T>>>
	<ADD	D* GLOTOP 1>
	<MOVE	A* 1(D)>		; "DESTINATION"
	<MOVSI	C* *010000*>		; "DIRECTORY FIELD ONLY"
	<JFNS>
	<MOVE	B* 1(D)>
	<MOVE	A* (D)>
	<JRST	MPOPJ>			; "RETURN THE STRING"
OUT	<MOVSI	A* <TYPE-CODE FIX>>
	<MOVEI	B*>
	<JRST	MPOPJ>)
	(ITS
	 <*CALL	TTYGET>
	<JFCL>
	<TLO	B* *300*>
	<*CALL	TTYSET>
	<JFCL>
	<*IOPUS>
	<*CALL	[<SETZ>
		 <SIXBIT "OPEN">
		 [<(0) 0>]
		 [<SIXBIT "DSK">]
		 [<SIXBIT "TRIVIA">]
		 [<SIXBIT "CURFEW">]
		 <SETZ [<SIXBIT "_MSGS_">]>]>
	 <JRST	[<*IOPOP>
		 <JRST CORCHK>]>
	<*SUSET	[<(*74*) A>]>
	<CAMN	A* [<SIXBIT "GUEST">]>
	 <JRST	FLUSHO>
	<*CALL	[<SETZ>
		 <SIXBIT "OPEN">
		 [<(0) 0>]
		 [<SIXBIT "DSK">]
		 [<SIXBIT ".FILE.">]
		 [<SIXBIT "(DIR)">]
		 <SETZ A>]>
	 <JRST	FLUSHO>
	<*CALL	[<SETZ>
		 <SIXBIT "OPEN">
		 [<(*20*) 0>]		; "DON'T CHASE LINKS"
		 [<SIXBIT "DSK">]
		 [<SIXBIT "_MSGS_">]
		 <MOVE A>
		 <SETZ A>]>
	 <JRST	FLUSHO>
	<*IOPOP>
	<JRST	CORCHK>
FLUSHO	<*IOPOP>
	<MOVEI	B* 5>
	<JRST	LEAVE>
CORCHK	<MOVNI	A* 1>
	<*SUSET	[<(*400021*) A>]>	; "FUNNY HACK"
	<*CALL	[<SETZ>			; "#SHARERS OF 200. INTO B"
		 <SIXBIT "CORTYP">
		 <MOVEI	201.>
		 <MOVEM C>
		 <MOVEM 0>
		 <MOVEM 0>
		 <SETZM	B>]>
	 <*VALUE>
	<JUMPL	C* NOTPUR>
	<TLZ	B* -1>			; "CLEAR LH"
LEAVE	<MOVSI	A* <TYPE-CODE FIX>>
	<JRST	MPOPJ>
NOTPUR	<MOVEI	B* 5>
	<JRST	LEAVE>
TTYGET	<SETZ>
	<SIXBIT	"TTYGET">
	<MOVEI	2>
	<MOVEM	A>
	<MOVEM	B>
	<MOVEM	C>
	<MOVEM	D>
	<SETZM	E>
TTYSET	<SETZ>
	<SIXBIT	"TTYSET">
	<MOVEI	2>
	<MOVE	A>
	<MOVE	B>
	<MOVE	C>
	<SETZ	D>)
	>



<IFOPSYS (TENEX
	  <TITLE GETSYS>		; "RETURN T IF 10X"
	<DECLARE ("VALUE" <OR ATOM FALSE>)>
	<PUSHJ	P* IGETSYS>
	<JRST	FINIS>

<INTERNAL-ENTRY IGETSYS 0>
	<SUBM	M* (P)>
	<HRROI	A* 3>
	<HRLOI	B* *600015*>		; "NUL/NIL DEVICE"
	<MOVEI	C* 0>
	<DEVST>
	<JFCL>
	<CAMN	C* [<(*472531*) *400000*>]>
	 <JRST	TOPS20>
	<MOVSI	A* <TYPE-CODE ATOM>>
	<MOVE	B* <MQUOTE T>>
	<JRST	MPOPJ>
TOPS20	<MOVSI	A* <TYPE-CODE FALSE>>
	<MOVEI	B*>
	<JRST	MPOPJ>)>

; "ATMFIX takes an ATOM and returns a word which is the PNAME of the
   atom appropriately XORed."

<TITLE ATMFIX>
	<DECLARE ("VALUE" FIX <OR ATOM PSTRING>)>
  	<DPUSH	TP* (AB)>
	<PUSHJ	P* ATMFIX1>
	<JRST	FINIS>

<INTERNAL-ENTRY ATMFIX1 1>
	<SUBM	M* (P)>
	<MOVE	A* <TYPE-WORD FIX>>
	<MOVE	B* (TP)>
	<GETYP	O* -1(TP)>
	<CAIN	O* <TYPE-CODE ATOM>>
	 <MOVE	B* 3(B)>
	<MOVE	D* [<(*402010*) *040200*>]>
	<AND	D* B>
	<LSH	D* -1>
	<TDO	B* D>
	<MOVE	C* <MQUOTE <RGLOC SRUNM T>>>
	<ADD	C* GLOTOP 1>
	<MOVE	C* 1(C)>
	<MOVE	C* 1(C)>
	<XOR	B* C>
	<SUB	TP* [<2 (2)>]>
	<JRST	MPOPJ>

; "FIXSTR is the inverse of ATMFIX.  It takes a FIX and returns a STRING
   which is the PNAME of the ATOM which was previously given to ATMFIX."

<TITLE FIXSTR>
	<DECLARE ("VALUE" STRING FIX)>
	<DPUSH	TP* (AB)>
	<PUSHJ	P* FIXSTR1>
	<JRST	FINIS>

<INTERNAL-ENTRY FIXSTR1 1>
	<SUBM	M* (P)>
	<MOVE	B* <MQUOTE <RGLOC SAVSTR T>>>
	<ADD	B* GLOTOP 1>
	<MOVE	A* (B)>
	<MOVE	B* 1(B)>
	<SKIPN	C* (TP)>
	<JRST	FIXFLS>
	<MOVE	D* <MQUOTE <RGLOC SRUNM T>>>
	<ADD	D* GLOTOP 1>
	<MOVE	D* 1(D)>
	<XOR	C* 1(D)>
	<MOVE	D* [<(*402010*) *040200*>]>
	<AND	D* C>
	<LSH	D* -1>
	<TDZ	C* D>
	<MOVEM	C* 1(B)>
FIXOUT	<SUB	TP* [<2 (2)>]>
	<JRST	MPOPJ>

FIXFLS	<MOVE	A* <TYPE-WORD FALSE>>
	<SETZ	B*>
	<JRST	FIXOUT>

<TITLE DISPATCH>
	<DECLARE ("VALUE" ANY NOFFSET "OPTIONAL" ANY)>
	<MOVE	A* AB>
LOOP	<DPUSH	TP* (AB)>
	<ADD	AB* [<(2) 2>]>
	<JUMPL	AB* LOOP>
	<HLRES	A>
	<ASH	A* -1>
	<ADDI	A* TABEND>
	<PUSHJ	P* @ (A) 1>
	<JRST	FINIS>
	<DISP2>
TABEND	<DISP1>

	<INTERNAL-ENTRY DISP1 1>
	<PUSH	TP* <TYPE-WORD FALSE>>
	<PUSH	TP* [0]>
	<INTERNAL-ENTRY DISP2 2>
	<SUBM	M* (P)>
	<MOVE	A* <MQUOTE <RGLOC DISPATCH-TABLE T>>>
	<ADD	A* GLOTOP 1>
	<MOVE	A* 1(A)>			; "get dispatch table"
	<GETYP	C* -1(TP)>
	<SKIPG	B* -2(TP)>			; "pick up offset"
	 <JRST	DOOPT>
	<ADDI	A* -1(B)>			; "point to instruction"
	<CAIE	C* <TYPE-CODE FALSE>>
	 <JRST	ONEARG>
NOARG	<XCT	(A)>
	<SUB	TP* [<(4) 4>]>
	<JRST	MPOPJ>
ONEARG	<XCT	(A)>
	<SUB	TP* [<(2) 2>]>
	<JRST	MPOPJ>
DOOPT	<MOVNS	B>
	<CAIE	C* <TYPE-CODE FALSE>>
	 <JRST	[<ADDI A* (B)>			; "point to next"
		 <JRST ONEARG>]>
	<ADDI	A* -1(B)>
	<JRST	NOARG>



;"READER FOR ZORK:  TAKES INPUT BUFFER AND PROMPT, RETURNS NUMBER OF
CHARACTERS IN BUFFER.
AC USAGE:
O: RANDOM, MAINLY FOR SIOTING
A: ON ITS, .IOT <INCHAN>,B; ON 10X, PRIMARY INPUT JFN
B: USUALLY CHARACTER LAST READ, BUT CLOBBERED FOR SIOTS AND SOUTS
C: USUALLY COUNT OF CHARACTERS READ; MAY BE FROBBED TEMPORARILY WHEN SOUTING
D: ILDB POINTER TO NEXT CHAR IN BUFFER
E: <0 --> RUBOUT SHOULD FLUSH A CHAR
   =0 --> RUBOUT SHOULD ECHO \<RUBBED OUT>
   >0 --> RUBOUT SHOULD ECHO <RUBBED OUT>--USED BY WDFLS
PVP: OUTCHAN
P: # CHARS IN BUFFER

ARGS:  INPUT BUFFER   PROMPT  ALTMODE ONLY TERMINATOR?"

<TITLE READST>
	<DECLARE ("VALUE" FIX STRING STRING <OR ATOM FALSE>)>
	<DPUSH	TP* (AB)>
	<DPUSH	TP* 2(AB)>
	<DPUSH	TP* 4(AB)>
	<PUSHJ	P* IREADST>
	<JRST	FINIS>

<INTERNAL-ENTRY IREADST 3>
	<SUBM	M* (P)>
	<IFOPSYS
	 (TENEX
	  <MOVEI E* 0>
	  <MOVEI A* *400000*>
	  <MOVEI B* 0>
	  <STIW>			; "NO INTERRUPTS IN HERE")
	 (ITS
	  <MOVE A* <MQUOTE <RGLOC RUBOUT? T>>>
	  <ADD	A* GLOTOP 1>
	  <MOVEI E* 0>
	  <SKIPGE 1(A)>
	   <MOVNI E* 1>)>
	<MOVE	A* <MQUOTE <RGLOC OUTCHAN T>>>
	<ADD	A* GLOTOP 1>
	<MOVE	A* 1(A)>
	<MOVE	PVP* 1(A)>		; "OUTPUT CHANNEL/JFN"
	<MOVE	A* <MQUOTE <RGLOC INCHAN T>>>
	<ADD	A* GLOTOP 1>
	<MOVE	A* 1(A)>
	<MOVE	A* 1(A)>		; "GET CHANNEL #"
	<IFOPSYS
	 (ITS
	  <LSH	A* *27*>
	  <IOR	A* [<*IOT B>]>)>	; "JFN FOR 10X, I/O INS FOR ITS"
	<PUSHJ	P* PPRMPT>
	<HRRZ	C* -5(TP)>
	<PUSH	P* C>			; "# CHARS IN STRING"
	<MOVEI	C* 0>
	<MOVE	D* -4(TP)>		; "BUFFER POINTER"
CHRLOP	<IFOPSYS
	 (TENEX
	  <BIN>)
	 (ITS
	  <XCT	A>)>			; "GET CHAR IN B"
	<SKIPGE	INTFLG>
	 <JRST	INTHAK>			; "INTERRUPTS?"
INTBCK	<CAIGE	B* *40*>		; "NOT SPECIAL?"
	 <JRST	SPCCHR>
	<CAIN	B* *177*>		; "RUBOUT?"
	 <JRST	RUBOUT>
PUTCHR	<PUSHJ	P* PUTCHR1>
	 <JRST	CHRLOP>
	<MOVEI	B* *33*>		; "PUTCHR1 SKIPS IF BUFFER FULL"
SPCCHR	<CAIE	B* *15*>
	 <CAIN	B* *37*>		; "EOL"
	  <JRST	CRHACK>
	<CAIN	B* *33*>		; "ALTMODE"
	 <JRST	[<PUSHJ P* PCRLF>
		 <JRST	RDDONE>]>
	<JUMPE	B* BUFFLS>
	<CAIE	B* %<ASCII !\>>
	 <CAIN	B* %<ASCII !\>>
	  <JRST	BUFFLS>			; "KILL BUFFER"
	<CAIN	B* %<ASCII !\>>
	 <JRST	WDFLS>
	<CAIN	B* *10*>
	 <JRST	RUBOUT>			; "BS=RUBOUT"
	<CAIE	B* %<ASCII !\>>
	 <CAIN	B* %<ASCII !\>>
	  <JRST	REBUF>
	<CAIN	B* *14*>
	 <JRST	CREBUF>			; "BUFFER REDISPLAY"
	<CAIN	B* 7>
	 <JRST	FAKINT>			; "CTRL-G SHOULD BE PROCESSED"
	<CAIN	B* *12*>		; "IGNORE CTRL-J, SINCE ^M ADDS IT"
	 <JRST	CHRLOP>
	<JRST	PUTCHR>
	
PUTCHR1	<IDPB	B* D>			; "STUFF IT OUT"
	<ADDI	C* 1>
	<CAML	C* -1(P)>		; "BUFFER FULL?"
	 <AOS	(P)>			; "YES, SKIP"
	<POPJ	P*>

FAKINT	<PUSH	P* A>
	<PUSH	P* E>
	<PUSH	P* PVP>
	<EXCH	C* -3(P)>
	<SUB	C* -3(P)>
	<HRLI	C* <TYPE-CODE STRING>>
	<PUSH	TP* C>
	<PUSH	TP* D>			; "MAKE RESTED STRING TO PUSH"
	<PUSH	TP* <PQUOTE "CHAR">>
	<PUSH	TP* <MQUOTE "CHAR">>
	<PUSH	TP* <TYPE-WORD CHARACTER>>
	<PUSH	TP* B>
	<PUSH	TP* <TYPE-WORD CHANNEL>>
	<MOVE	B* <MQUOTE <RGLOC INCHAN T>>>
	<ADD	B* GLOTOP 1>
	<PUSH	TP* 1(B)>
	<IFOPSYS
	 (TENEX
	  <MOVEI A* *400000*>
	  <MOVE	 B* [<(*002000*) *200000*>]>
	  <STIW>)>
	<MCALL	3 INTERRUPT>
	<IFOPSYS
	 (TENEX
	  <MOVEI A* *400000*>
	  <MOVEI B* 0>
	  <STIW>)>
	<POP	TP* D>
	<POP	TP* C>
	<ADD	C* -3(P)>
	<EXCH	C* -3(P)>
	<POP	P* PVP>
	<POP	P* E>
	<POP	P* A>
	<PUSHJ	P* PPRMPT>		; "REDISPLAY PROMPT TO SHOW THAT BACK FROM INT"
	<JRST	CHRLOP>

INTHAK	<PUSH	P* PVP>			; "SAVE OUTCHAN"
	<EXCH	C* -1(P)>
	<SUB	C* -1(P)>
	<HRLI	C* <TYPE-CODE STRING>>	; "MAKE C HAVE A VALID TYPE WORD FOR STRING"
	<#OPCODE!-OP!-PACKAGE *5000000000* [<(*001111*) *000311*>]>
	<POP	P* PVP>
	<HRRZS	C>
	<ADD	C* (P)>
	<EXCH	C* (P)>
	<JRST	INTBCK>			; "RESTORE EVERYTHING, AND BACK"

CRHACK	<IFOPSYS
	 (TENEX
	  <CAIE	B* *37*>		; "TURN EOL INTO CRLF"
	   <JRST CRHACK1>
	  <MOVEI B* *15*>
	  <PUSHJ P* CHROUT>
	  <MOVEI B* *12*>
	  <PUSHJ P* CHROUT>
	  <MOVEI B* *15*>)>
CRHACK1	<SKIPL	(TP)>			; "CAN CR TERMINATE?"
	 <JRST	RDDONE>			; "YES!"
	<PUSHJ P* PUTCHR1>
	  <CAIA>
	   <JRST RDDONE>
	<MOVEI B* *12*>			; "FOLLOW WITH LF"
	<JRST	PUTCHR>

<IFOPSYS
	(ITS
SIOT	<SETZ>
	<SIXBIT	"SIOT">
	<MOVE	PVP>
	<MOVE	B>
	<SETZ	O>
DSIOT	<SETZ>
	<SIXBIT	"SIOT">
	<MOVSI	*4000*>			; "TURN ON DISPLAY BIT"
	<MOVE	PVP>
	<MOVE	B>
	<SETZ	O>)>

CHROUT	<IFOPSYS
	 (TENEX
	  <PUSH	P* A>
	  <MOVE	A* PVP>
	  <BOUT>
	  <POP	P* A>)
	 (ITS
	  <*CALL [<SETZ>
		  <SIXBIT "IOT">
		  <MOVE PVP>
		  <SETZ	B>]>
	   <*LOSE *1000*>)>
	<POPJ	P*>

RDDONE	<MOVE	A* <MQUOTE <RGLOC SCRIPT-CHANNEL T>>>
	<ADD	A* GLOTOP 1>
	<SKIPL	1(A)>			; "SKIPS IF SCRIPTING ON"
	 <JRST	RDDONE1>
	<PUSH	P* C>			; "SAVE CHARACTER COUNT"
	<PUSH	TP* (A)>
	<PUSH	TP* 1(A)>
	<PUSH	TP* -5(TP)>		; "PROMPT"
	<PUSH	TP* -5(TP)>
	<PUSH	TP* (A)>
	<PUSH	TP* 1(A)>
	<MCALL	2 PRINTSTRING>
	<PUSH	TP* -7(TP)>
	<PUSH	TP* -7(TP)>		; "BUFFER"
	<PUSH	TP* -3(TP)>
	<PUSH	TP* -3(TP)>		; "SCRIPT CHANNEL"
	<PUSH	TP* <TYPE-WORD FIX>>
	<PUSH	TP* (P)>		; "# CHARACTERS"
	<MCALL	3 PRINTSTRING>
	<DPUSH	TP* <PQUOTE <STRING <ASCII 13> <ASCII 10>>>>
	<PUSH	TP* -3(TP)>
	<PUSH	TP* -3(TP)>
	<PUSH	TP* <TYPE-WORD FIX>>
	<PUSH	TP* [2]>
	<MCALL	3 PRINTSTRING>
	<SUB	TP* [<(2) 2>]>
	<POP	P* C>
RDDONE1	<IFOPSYS
	 (TENEX
	  <MOVEI A* *400000*>
	  <MOVE B* [<(*002004*) *000000*>]>
	  <STIW>)>
	<MOVSI	A* <TYPE-CODE FIX>>
	<MOVE	B* C>
	<SUB	P* [<(1) 1>]>
	<SUB	TP* [<(6) 6>]>
	<JRST	MPOPJ>

CREBUF	<IFOPSYS
	 (TENEX
	  <JRST	REBUF>)
	 (ITS
	  <MOVEI O* 2>
	  <MOVE	B* <MQUOTE "C">>
	  <*CALL DSIOT>	; "THIS HAS DISPLAY BIT ON"
	   <*LOSE *1000*>
	  <JRST	REBUF1>)>

REBUF	<IFOPSYS
	 (TENEX
	  <PUSH	P* C>
	  <PUSHJ P* PCRLF>	; "CR"
	  <PUSHJ P* PPRMPT>
	  <MOVE	B* -4(TP)>
	  <MOVN	C* (P)>
	  <SKIPE C>
	   <SOUT>		; "BUFFER"
	  <POP	P* C>)
	 (ITS
	  <PUSHJ P* PCRLF>
REBUF1	  <PUSHJ P* PPRMPT>	; "COMMON CODE FOR CTRL-D AND CTRL-L"
	  <MOVE	B* -4(TP)>
	  <MOVE	O* C>
	  <*CALL SIOT>
	   <*LOSE *1000*>)>
	<JRST	CHRLOP>		; "GO BACK FOR NEXT CHAR"

PCRLF	<IFOPSYS
	 (TENEX
	  <MOVE	B* <MQUOTE %<STRING <ASCII 13> <ASCII 10>>>>
	  <PUSH	P* C>
	  <MOVNI C* 2>
	  <SOUT>
	  <POP	P* C>)
	 (ITS
	  <MOVE B* <MQUOTE %<STRING <ASCII 13> <ASCII 10>>>>
	  <MOVEI O* 2>
	  <*CALL SIOT>
	   <*LOSE *1000*>)>
	<POPJ	P*>

PPRMPT	<IFOPSYS
	 (TENEX
	  <MOVE	B* -2(TP)>
	  <PUSH	P* C>
	  <HRRZ	C* -3(TP)>
	  <MOVNS C>
	  <SKIPE C>
	   <SOUT>
	  <POP	P* C>)
	 (ITS
	  <MOVE	B* -2(TP)>
	  <HRRZ	O* -3(TP)>
	  <*CALL SIOT>
	   <*LOSE *1000*>)>
	<POPJ	P*>

BUFFLS	<MOVEI	C* 0>		; "THROW EVERYTHING AWAY"
	<MOVE	D* -4(TP)>
	<PUSHJ	P* PCRLF>
	<PUSHJ	P* PPRMPT>
	<JRST	CHRLOP>

RUBOUT	<PUSHJ	P* RRUBOUT>
	<JRST	CHRLOP>
RRUBOUT	<JUMPE	C* [<SUB P* [<(1) 1>]>
		    <JRST REBUF>]> ; "IF RUBBING OUT PAST BEG OF LINE, REDO PROMPT &C"
	<IFOPSYS
	 (ITS
	  <JUMPL E* RUBFLS>	; "IF E IS 0, HAVE TO PRINT \ FIRST")>
	<JUMPG	E* RUBOUT1>
	<MOVEI	B* 92>
	<PUSHJ	P* CHROUT>
RUBOUT1	<LDB	B* D>		; "GET CHAR BEING FLUSHED"
	<PUSHJ	P* CHROUT>
RUBOUT2	<ADD	D* [<(*70000*) 0>]>
	<TLNE	D* *400000*>
	 <ADD	D* [<(*347777*) *777777*>]>
	<SUBI	C* 1>
	<POPJ	P*>
<IFOPSYS
(ITS
RUBFLS	<LDB	B* D>		; "GET CHAR"
	<CAIN	B* *12*>
	 <JRST	[<MOVE	B* <MQUOTE <STRING "U">>>	; "LINE STARVE"
		 <JRST	RUBFLO>]>
	<CAIN	B* *15*>
	 <JRST	RUBFCR>
	<MOVE	B* <MQUOTE <STRING "X">>>
RUBFLO	<MOVEI	O* 2>
	<*CALL	DSIOT>
	 <*LOSE	*1000*>
	<JRST	RUBOUT2>
RUBFCR	<PUSH	P* C>
	<PUSH	P* D>
	<PUSH	P* E>
	<MOVE	D* -4(TP)>	; "POINTER TO BUFFER"
	<HRRZ	E* -3(TP)>	; "CURRENT HORIZONTAL POSITION--PROMPT"
	<SOJLE	C* RUBCRE1>	; "FLUSH CR FROM END"
RUBCRL	<ILDB	B* D>
	<CAIN	B* *15*>
	 <JRST	[<MOVEI	E* 0>
		 <JRST	RUBCRE>]>
	<CAIN	B* *12*>
	 <JRST	RUBCRE>
	<ADDI	E* 1>
RUBCRE	<SOJG	C* RUBCRL>
RUBCRE1	<ADDI	E* 8>
	<MOVEI	O* 2>
	<MOVE	B* <MQUOTE "H">>
	<*CALL	DSIOT>
	 <*LOSE	*1000*>
	<*CALL	[<SETZ>
		 <SIXBIT "IOT">
		 <MOVSI	*4000*>
		 <MOVE	PVP>
		 <SETZ	E>]>	; "SET HORIZONTAL POSITION"
	 <*LOSE	*1000*>
	<POP	P* E>
	<POP	P* D>
	<POP	P* C>
	<JRST	RUBOUT2>)>

WDFLS	<JUMPE	C* REBUF>	; "NOTHING TO FLUSH"
	<JUMPL	E* WDFLS1>	; "CAN RUBOUTS HAPPEN?"
	<MOVEI	B* 92>
	<PUSHJ	P* CHROUT>
	<ADDI	E* 1>		; "INHIBIT \ WHEN DOING RUBOUTS"
WDFLS1	<LDB	B* D>		; "GET CHAR BEING FLUSHED"
	<CAIE	B* *40*>	; "SPACE?"
	 <CAIN	B* *15*>	; "CR?"
	  <JRST	WDFLS11>
	<CAIE	B* *12*>
	 <CAIN	B* *11*>
	  <JRST	WDFLS11>
	<CAIE	B* *54*>	; "COMMA"
	 <CAIN	B* *56*>	; "PERIOD"
	  <JRST	WDFLS11>
	<JRST	WDFLS2>		; "REAL STUFF"
WDFLS11	<PUSHJ	P* RRUBOUT>	; "RUB IT OUT"
	<JUMPE	C* WDFLSO>	; "EMPTY BUFFER"
	<JRST	WDFLS1>
WDFLS2	<LDB	B* D>
	<CAIE	B* *40*>
	 <CAIN	B* *15*>
	  <JRST	WDFLSO>
	<CAIE	B* *12*>
	 <CAIN	B* *11*>
	  <JRST	WDFLSO>
	<CAIE	B* *54*>
	 <CAIN	B* *56*>
	  <JRST	WDFLSO>
	<PUSHJ	P* RRUBOUT>
	<JUMPG	C* WDFLS2>
WDFLSO	<JUMPLE	E* CHRLOP>
	<MOVEI	B* 92>
	<PUSHJ	P* CHROUT>
	<MOVEI	E* 0>
	<JRST	CHRLOP>

<TITLE TTY-INIT>
	<DECLARE ("VALUE" ATOM <OR ATOM FALSE>)>
	<DPUSH	TP* (AB)>
	<PUSHJ	P* IINIT>
	<JRST	FINIS>

<INTERNAL-ENTRY IINIT 1>
	<SUBM	M* (P)>
	<MOVE	A* <MQUOTE <RGLOC OUTCHAN T>>>
	<ADD	A* GLOTOP 1>
	<MOVE	A* 1(A)>		; "OUTCHAN"
	<IFOPSYS
	 (TENEX
	  <MOVEI B* 70>
	  <SKIPN 25(A)>
	   <MOVEM B* 25(A)>		; "MAKE CHANNEL WIDTH NON-ZERO")>
	<MOVE	A* 1(A)>
	<IFOPSYS
	 (TENEX
	  <SKIPL (TP)>			; "SAVE CURRENT STATE?"
	   <JRST STMODE>
	  <MOVE E* <MQUOTE <RGLOC RUVEC T>>>
	  <ADD	E* GLOTOP 1>
	  <MOVE	E* 1(E)>
STMODE	  <RFMOD>
	  <SKIPGE (TP)>
	   <MOVEM B* (E)>		; "MODE WORD"
	  <TRO	B* *140100*>
	  <TRZ	B* *030200*>
	  <SFMOD>
	  <SKIPL (TP)>
	   <JRST SCMODE>
	  <RFCOC>			; "CONTROL CHARACTER FORMATTING"
	  <MOVEM B* 1(E)>
	  <MOVEM C* 2(E)>
SCMODE	  <MOVE	B* <MQUOTE #2 {0 1 1 1 0 1 1 2 0 3 3 1 0 3 1 1 1 1}>>
	  <MOVE	B* 1(B)>
	  <MOVE C* <MQUOTE #2 {1 1 1 1 1 0 0 1 1 1 1 1 1 0}>>
	  <MOVE	C* 1(C)>
	  <SFCOC>			; "THIS DOES ECHOING FOR CTRL-CHARS"
	  <MOVEI A* *400000*>
	  <SKIPL (TP)>
	   <JRST SIMODE>
	  <RTIW>
	  <MOVEM B* 3(E)>
SIMODE	  <MOVE	B* [<(*2004*) 0>]>
	  <STIW>
	  <SKIPL (TP)>
	   <JRST INTSET>
	  <MCALL 0 ACTIVATE-CHARS>
	  <MOVE	C* <MQUOTE <RGLOC ACT-STRING T>>>
	  <ADD	C* GLOTOP 1>
	  <MOVEM A* (C)>
	  <MOVEM B* 1(C)>
INTSET	  <DPUSH TP* <PQUOTE "">>
	  <MCALL 1 ACTIVATE-CHARS>)
	 (ITS
	  <*CALL [<SETZ>
		  <SIXBIT "CNSGET">
		  <MOVE	A>
		  <MOVEM B>
		  <MOVEM B>
		  <MOVEM B>
		  <MOVEM B>
		  <SETZM B>]>
	   <*LOSE *1000*>
	  <TLNN	B* *40000*>		; "TEST %TOERS"
	   <JRST INIT1>
	  <MOVE	B* <MQUOTE <RGLOC RUBOUT? T>>>
	  <ADD	B* GLOTOP 1>
	  <MOVE	C* <MQUOTE T>>
	  <MOVEM C* 1(B)>
	  <MOVSI C* <TYPE-CODE ATOM>>
	  <MOVEM C* (B)>		; "SETG RUBOUT? TO T"
INIT1	  <SKIPL (TP)>
	   <JRST DTTYST>
	  <MOVE B* <MQUOTE <RGLOC RUVEC T>>>
	  <ADD	B* GLOTOP 1>
	  <MOVE	B* 1(B)>
	  <*CALL [<SETZ>
		  <SIXBIT "TTYGET">
		  <MOVE	A>
		  <MOVEM (B)>
		  <SETZM 1(B)>]>
	   <*LOSE *1000*>
DTTYST	  <*CALL [<SETZ>
		  <SIXBIT "TTYSET">
		  <MOVE	A>
		  <MOVE [<(*022020*) *202020*>]>
		  <SETZ [<(*032022*) *220222*>]>]>
	   <*LOSE *1000*>)>
TTYIDN	<SUB	TP* [<(2) 2>]>
	<MOVSI	A* <TYPE-CODE ATOM>>
	<MOVE	B* <MQUOTE T>>
	<JRST	MPOPJ>

<TITLE TTY-UNINIT>
	<DECLARE ("VALUE" ATOM)>
	<PUSHJ	P* IUNINIT>
	<JRST	FINIS>

<INTERNAL-ENTRY IUNINIT 0>
	<SUBM	M* (P)>
	<MOVE	A* <MQUOTE <RGLOC OUTCHAN T>>>
	<ADD	A* GLOTOP 1>
	<MOVE	A* 1(A)>
	<MOVE	A* 1(A)>
	<IFOPSYS
	 (TENEX
	  <MOVE	D* <MQUOTE <RGLOC RUVEC T>>>
	  <ADD	D* GLOTOP 1>
	  <MOVE	D* 1(D)>
	  <MOVE	B* (D)>
	  <SFMOD>		; "RESTORE MODES"
	  <MOVE	B* 1(D)>
	  <MOVE	C* 2(D)>
	  <SFCOC>
	  <MOVEI A* *400000*>
	  <MOVE B* 3(D)>
	  <STIW>
	  <MOVE	D* <MQUOTE <RGLOC ACT-STRING T>>>
	  <ADD	D* GLOTOP 1>
	  <PUSH	TP* (D)>
	  <PUSH	TP* 1(D)>
	  <MCALL 1 ACTIVATE-CHARS>	; "RESTORE INTERRUPTS")
	 (ITS
	  <MOVE	B* <MQUOTE <RGLOC RUVEC T>>>
	  <ADD	B* GLOTOP 1>
	  <MOVE	B* 1(B)>
	  <*CALL [<SETZ>
		  <SIXBIT "TTYSET">
		  <MOVE	A>
		  <(B)>
		  <SETZ 1(B)>]>
	   <*LOSE *1000*>)>
	<MOVE	B* <MQUOTE T>>
	<MOVSI	A* <TYPE-CODE ATOM>>
	<JRST	MPOPJ>



<TITLE EXCRUCIATINGLY-UNTASTEFUL-CODE>
	<DECLARE ("VALUE" ATOM)>
	<PUSHJ	P* IEUC>
	<JRST	FINIS>

	<INTERNAL-ENTRY IEUC 0>
	<SUBM	M* (P)>
	<MOVE	A* <MQUOTE <RGLOC PRSVEC T>>>
	<ADD	A* GLOTOP 1>
	<HRRZ	A* 1 (A)>
	<ADDI	A* 1>
	<MOVEM	A* *60*>
	<ADDI	A* 2>
	<MOVEM	A* *61*>
	<ADDI	A* 2>
	<MOVEM	A* *62*>
	<MOVE	A* <TYPE-WORD ATOM>>
	<MOVE	B* <MQUOTE T>>
	<JRST	MPOPJ>


; "POBLIST HACKS"

<TITLE STRINGP>
	<DECLARE ("VALUE" STRING <PRIMTYPE WORD>)>
	<DPUSH	TP* (AB)>
	<PUSHJ	P* ISTRP>
	<JRST	FINIS>

<INTERNAL-ENTRY ISTRP 1>
	<SUBM	M* (P)>
	<MOVE	A* <TYPE-WORD STRING>>
	<MOVE	B* <MQUOTE <RGLOC PPSTRING T>>>
	<ADD	B* GLOTOP 1>
	<MOVE	B* 1(B)>
	<MOVE	C* (TP)>
	<MOVE	D* [<(*440700*) C>]>
	<SETZ	E*>
STRPLP	<ILDB	D>
	<JUMPE	STRPGO>
	<CAIN	E* 5>
	 <JRST	STRPGO>
	<AOJA	E* STRPLP>

STRPGO	<HRR	A* E>
	<MOVEM	C* 1(B)>
	<SUB	TP* [<(2) 2>]>
	<JRST	MPOPJ>


<TITLE PSTRING>
	<DECLARE ("VALUE" PSTRING STRING)>
	<DPUSH	TP* (AB)>
	<PUSHJ	P* IPSTR>
	<JRST	FINIS>

<INTERNAL-ENTRY IPSTR 1>
	<SUBM	M* (P)>
	<MOVE	A* (TP)>
	<HLRZ	C* A>
	<CAIN	C* *10700*>
	 <JRST	PSTR1>
	<MOVE	B* (A)>
	<HRRZ	C* -1(TP)>
	<SUBI	C* 5>
	<MOVNS	C>
	<IMULI	C* 7>
	<LSH	B* (C)>
	<CAIA>
PSTR1	 <MOVE	B* 1(A)>
	<MOVE	A* <TYPE-WORD PSTRING>>
	<SUB	TP* [<(2) 2>]>
	<JRST	MPOPJ>

