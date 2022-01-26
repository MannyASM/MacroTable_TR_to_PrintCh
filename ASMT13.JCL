//Z01427C JOB TESTASMF,'ASMT13',
//        MSGCLASS=H,
//        CLASS=H,
//        NOTIFY=&SYSUID
//********************************************** TESTING STUFF
//ASM     EXEC PROC=HLASMCLG,
//        PARM.C=(LIST,USING(MAP))
//C.SYSLIB DD DSN=SYS1.MACLIB,DISP=SHR
//         DD DSN=Z01427.JCL,DISP=SHR
//SYSIN   DD *
         TITLE '<MANNY-TEST> &SYSDATE / &SYSTIME'
         PRINT ON,NOGEN
ASMT13   START 0
         STM   R14,R12,12(R13)
         BASR  R12,R0
         USING *,R12
         ST    R13,SAVEA+4
         LR    R2,R13
         LA    R13,SAVEA
         ST    R13,8(R0,R2)
*------------------------------------------------------
* WORK STATEMENTS
*
*
*------------------------------------------------------
         WTO   '---> ASMT13:STARTING'
*        TR    STRING,TABLE
*        PRINTOUT STRING
*-----------------------------
TRNSLTXC L     R0,HEXLEN               LOAD LEN OF HEX STRING TO TRANSL
         LA    R14,HEXLIST             LOAD ADR OF HEX STRING TO TRANSL
         LA    R15,CHARLIST            LOAD ADR OF RCV AREA FOR TRANS

NEXTCHAR MVZ   BYTE1,0(R14)            ISOLATE HIGH ORDER HEX DIGIT
         MVN   BYTE2,0(R14)            ISOLATE LOW  ORDER HEX DIGIT

TRAN1    TR    BYTE1,HEXTBL            TRANSL HI ORDER HEX DIGIT TO CH
TRAN2    TR    BYTE2,HEXTBL            TRANSL LO ORDER HEX DIGIT TO CH

MOVE1    MVC   0(,R15),BYTE1           MOV 1ST TRANSL HEX CHAR INTO RCV
MOVE2    MVC   1(,R15),BYTE2           MOV 2ST TRANSL HEX CHAR INTO RCV

INCR1    LA    R14,1(,R14)             INCR TO NEXT HEX BYTE
INCR2    LA    R15,2(,R15)             INCR TO NEXT RCV AREA SLOT

         LR    R8,X'00'                FLUSH BYTE1 AND BYTE2
         ST    R8,BYTE1
         ST    R8,BYTE2

         BCT   R0,NEXTCHAR             TRANSL NEXT BYTE, DECR R0
*-----------------------------
         PRINTOUT R0
         PRINTOUT HEXLEN               HEXLEN IS 8 BYTES
         PRINTOUT HEXLIST
         PRINTOUT CHARLIST

         LA    R7,MSGLEN
         WTO   TEXT=(R7)
*------------------------------------------------------
EXITPGM  EQU *
         WTO '---> ASMT13:ENDING'
         L     R13,SAVEA+4             POINT AT OLD SAVE AREA
         LM    R14,R12,12(R13)         RESTORE THE REGISTERS
         XR    R15,R15                 RETURN CODE = 0
         BR    R14
*--------------------------------------------------------------
* STORAGE
*--------------------------------------------------------------

HEXLIST  DS    0CL8                    HEX BYTES TO CONVERT INTO CHAR
         DC    CL6'ABC123'
         DC    XL2'04AF'

HEXLEN   DC    A(*-HEXLIST)            LENGTH OF HEX STRING TO TRANS

MSGLEN   DC    H'16'
CHARLIST DS    CL(L'HEXLIST*2)         RECEIVE ARE FOR TRANS

BYTE1    DC    X'00'
BYTE2    DC    X'00'

STRING   DC    X'030201'
TABLE    DC    X'FF01AABB00'

HEXTBL   HEXTBL

REGSEQ   YREGS                         REG EQUATES
SAVEA    DS    18F                     SAVE AREA TO PRESERVE STATE
SAVEB    DS    16F

         LTORG *
         END   ASMT13
/*
//C.SYSPRINT DD SYSOUT=*                                                01510000
//C.WORKFILE DD SYSOUT=*                                                01510000
//C.SYSUT1   DD SYSOUT=*                                                01510000
//G.SYSPRINT DD SYSOUT=*                                                01510000
//G.SYSUDUMP DD SYSOUT=*                                                01510000
