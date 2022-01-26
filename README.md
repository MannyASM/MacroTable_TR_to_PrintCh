# MacroTable_TR_to_PrintCh
A working HLASM model showing how to convert from hex into character for display purposes.
1. Uses HEXTBL macro to define a 256-byte table. 
2. MVZ and MVN instructions allow each input byte to be separated into hi order and low order bits.
3. The TR instruction uses the table defined by HEXTBL to obtain a char representation.

Source:  Carmine Cannatello - "Advanced Assembler Language and MVS Interfaces" ISBN 0-471-50435-1

Modules
ASMT13.JCL
----------
Uses IBM proc HLASMCLG to assemble, link and execute the source program.

HEXTBL.MACRO
------------
Contains a translation table used with the TR instruction.

PGM13_JOB_OUTPUT.TXT
--------------------
SDSF job output from ASMT13.  Job was executed in a z/OS 2.04 environment.

For display purposes, WTO was utilized to display contents of CHARLIST (as output string).
 
 The data to be converted is refered to by HEXLIST.
     HEXLIST  DS    0CL8                    HEX BYTES TO CONVERT INTO CHAR                       
              DC    CL6'ABC123'                                                                  
              DC    XL2'04AF'      
 
 The logic loop to translate the data start at location TRNSLTXC. 
  
 MSGLEN is a half word field preceding CHARLIST, which contains the translated characters.
 MSGLEN is used with WTO to display CHARLIST.
     
     LA    R7,MSGLEN                                                                    
     WTO   TEXT=(R7) 
 
      which displays
 
          10.13.15 JOB01141  +C1C2C3F1F2F304AF
 
 Also, PRINTOUT was used to further display some information. Thsi is a macro developed by John Ehrman (Assembler Language Programming for IBM System z™ Servers, Version 2.00)

PGM13_LIST.TXT
--------------
The assembled listing of source program.

