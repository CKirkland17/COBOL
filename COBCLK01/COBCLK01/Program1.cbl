	   IDENTIFICATION DIVISION.
	   PROGRAM-ID. COBCLK01.
	   DATE-WRITTEN. 12/05/19.
	   AUTHOR. CADE KIRKLAND.
	   DATE-COMPILED.
      **********************************************
	  ** THIS PROGRAM READS A FILE AND CREATES A **
	  ** A PAINT ESTIMATE REPORT. **
	  **********************************************

	   ENVIRONMENT DIVISION.
	   INPUT-OUTPUT SECTION.
	   	   FILE-CONTROL.

	   	   	SELECT PAINT-EST
	   	   		ASSIGN TO "C:\School\COBOL\COBCLK01\PAINTEST.DAT"
	   	   		ORGANIZATION IS LINE SEQUENTIAL.

	   	   	SELECT PAINTOUT
	   	   		ASSIGN TO "C:\School\COBOL\COBCLK01\PAINTRPT.PRT"
	   	   		ORGANIZATION IS RECORD SEQUENTIAL.

	   DATA DIVISION.
	   FILE SECTION.

	   	    FD	PAINT-EST
	   	   	LABEL RECORD IS STANDARD
	   	   	DATA RECORD IS I-REC
	   	   	RECORD CONTAINS 49 CHARACTERS.

	   	   01	I-REC.
	   	   	05	I-ID			PIC X(7).
	   	   	05	I-NAME.
	   	   		10	I-LNAME 	PIC X(15).
	   	   		10	I-FNAME		PIC	X(15).
	   	   		10	I-INIT		PIC	X.
	   	   	05 I-GPA			PIC 9V99.
	   	   	05 I-START-SALARY	PIC 9(6)V99.

	   	   FD PAINTOUT
	   		  LABEL RECORD IS OMITTED
	   		  RECORD CONTAINS 132 CHARACTERS
	   		  DATA RECORD IS PRTLINE
	   		  LINAGE IS 60 WITH FOOTING AT 56.

	   	   01 PRTLINE				 PIC X(132).

	   WORKING-STORAGE SECTION.
	   	   01 WORK-AREA.
	   		  05  C-SCTR		     PIC 999   VALUE 0.
	   		  05  C-PCTR			 PIC 99	   VALUE ZERO.
	   		  05  MORE-RECS			 PIC XXX   VALUE 'YES'.

	   	   01 CURRENT-DATE-AND-TIME.
	   		  05  I-DATE.
	   	   	   10 I-YY				PIC 9(4).
	   	   	   10 I-MM				PIC 99.
	   	   	   10 I-DD				PIC 99.
	   		  05  I-TIME			PIC X(11).

	   	   01 COMPANY-TITLE.
	   		  05  FILLER			PIC X(6)   VALUE 'DATE:'.
	   		  05  O-MM				PIC 99.
	   		  05  FILLER			PIC X	   VALUE '/'.
	   		  05  O-DD				PIC 99.
	   		  05  FILLER 			PIC X	   VALUE '/'.
	   		  05  O-YY				PIC 9(4).
	   		  05  FILLER			PIC X(34)  VALUE SPACES.
	   		  05  FILLER			PIC X(31)
	   								VALUE
									'KIRKLAND''S COBOL STUDENT ROSTER'
		   .
	   		  05  FILLER			PIC X(43)  VALUE SPACES.
	   		  05  FILLER			PIC X(6)   VALUE 'PAGE: '.
	   		  05  O-PCTR			PIC X9.

	   	   01 ANTICIPATED-LINE.
	   		  05  FILLER			PIC X(119) VALUE SPACES.
	   		  05  FILLER			PIC X(13)  VALUE 'ANTICIPATED'.
	   	   01 GPA-LINE.
	   		  05  FILLER			PIC X(4)   VALUE 'ID'.
	   		  05  FILLER			PIC X(23)  VALUE SPACES.
	   		  05  FILLER			PIC X(9)   VALUE 'LAST NAME'.
	   		  05  FILLER			PIC X(26)  VALUE SPACES.
	   		  05  FILLER			PIC X(10)  VALUE 'FIRST NAME'.
	   		  05  FILLER			PIC X(26)  VALUE SPACES.
	   		  05  FILLER			PIC X(3)   VALUE 'GPA'.
	   		  05  FILLER			PIC X(16)  VALUE SPACES.
	   		  05  FILLER			PIC X(15)  VALUE 'STARTING SALARY'.
	   	   01 REPORT-LINE.
	   		  05  O-ID				PIC X(7).
	   		  05  FILLER			PIC X(20)  VALUE SPACES.
	   		  05  O-LNAME			PIC X(15).
	   		  05  FILLER			PIC X(20)  VALUE SPACES.
	   		  05  O-FNAME			PIC X(15).
	   		  05  FILLER			PIC X(20)  VALUE SPACES.
	   		  05  O-GPA				PIC Z.99.
	   		  05  FILLER			PIC X(18)  VALUE SPACES.
	   		  05  O-START-SALARY	PIC $ZZZ,ZZZ.99.
	   		  05  FILLER			PIC XX	   VALUE SPACES.
	   	   01 TOTAL-LINE.
	   		  05  FILLER			PIC X(54)  VALUE SPACES.
	   		  05  FILLER			PIC X(15)  VALUE 'STUDENT COUNT:'.
	   		  05  O-SCTR			PIC ZZ9.
	   		  05  FILLER			PIC X(60)  VALUE SPACES.

	   PROCEDURE DIVISION.
	   0000-MAIN.
		   PERFORM 1000-INIT.
		   PERFORM 2000-MAINLINE
			 UNTIL MORE-RECS = 'NO'.
		   PERFORM 3000-CLOSING.
		   STOP RUN.

	   1000-INIT.
		   OPEN INPUT PAINT-EST.
		   OPEN OUTPUT PAINTOUT.
		   MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-AND-TIME.
		   MOVE I-YY TO O-YY.
		   MOVE I-DD TO O-DD.
		   MOVE I-MM TO O-MM.

		   PERFORM 9000-READ.
		   PERFORM 9100-HDGS.

	   2000-MAINLINE.
		   PERFORM 2100-CALCS.
		   PERFORM 2200-OUTPUT.
		   PERFORM 9000-READ.

	   2100-CALCS.
		   ADD 1 TO C-SCTR.

	   2200-OUTPUT.
		   MOVE I-ID TO O-ID.
		   MOVE I-LNAME TO O-LNAME.
		   MOVE I-FNAME TO O-FNAME.
		   MOVE I-GPA TO O-GPA.
		   MOVE I-START-SALARY TO O-START-SALARY.

		   WRITE PRTLINE FROM REPORT-LINE
			 AFTER ADVANCING 2 LINES
			   AT EOP
				   PERFORM 9100-HDGS.

	   3000-CLOSING.
		   MOVE C-SCTR TO O-SCTR.
		   WRITE PRTLINE FROM TOTAL-LINE
			 AFTER ADVANCING 3 LINES.

		   CLOSE PAINT-EST.
		   CLOSE PAINTOUT.

	   9000-READ.
		   READ PAINT-EST
			   AT END
				   MOVE 'NO' TO MORE-RECS.

	   9100-HDGS.
		   ADD 1 TO C-PCTR.
		   MOVE C-PCTR TO O-PCTR.
		   WRITE PRTLINE FROM COMPANY-TITLE
			 AFTER ADVANCING PAGE
		   WRITE PRTLINE FROM ANTICIPATED-LINE
			 AFTER ADVANCING 2 LINES.
		   WRITE PRTLINE FROM GPA-LINE
			 AFTER ADVANCING 1 LINE.










