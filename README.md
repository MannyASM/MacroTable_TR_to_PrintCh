# MacroTable_TR_to_PrintCh
A working HLASM model showing how to convert hex data into character format for display purposes.
1. Uses HEXTBL macro to define a 256-byte table (fixed content, no conditional assembler). 
2. MVZ and MVN instructions allow each input byte to be separated into hi order and low order bits.
3. The TR instruction uses the table defined by HEXTBL to obtain a char representation.

Source:  Carmine Cannatello - "Advanced Assembler Language and MVS Interfaces" ISBN 0-471-50435-1

MODULES
-------

ASMT13.JCL
----------
Uses IBM proc HLASMCLG to assemble, link and execute the source program.

HEXTBL.MACRO
------------
Contains the translation table used with the TR instruction.

PGM13_JOB_OUTPUT.TXT
--------------------
SDSF job output from ASMT13. Job was executed in a z/OS 2.04 environment.

The hex-char translate loop starts at location labeled TRNSLTXC. 
CHARLIST stores the translated data.

For display purposes, WTO was utilized to show the contents of CHARLIST.
MSGLEN is a half word field preceding CHARLIST, and it specifies how many CHARLIST bytes to display.

The data to be converted is refered to by HEXLIST.
 
     HEXLIST  DS    0CL8                    HEX BYTES TO CONVERT INTO CHAR                       
              DC    CL6'ABC123'                                                                  
              DC    XL2'04AF'      
 
 The WTO code is setup and executed as follows:
 
     LA    R7,MSGLEN                                                                    
     WTO   TEXT=(R7) 
 
     which displays
 
          10.13.15 JOB01141  +C1C2C3F1F2F304AF
 
 Also, PRINTOUT was used to further display some information. 
 This is a macro developed by John Ehrman (Assembler Language Programming for IBM System z™ Servers, Version 2.00)

PGM13_LIST.TXT
--------------
The assembled listing of source program.
