    0*LOAD World1c
    1MODE5:VDU23;8202;0;0;0;23,224,2,43,28,97,97,28,43,2,23,225,64,212,56,134,134,56,212,64,19,1,0;0;19,2,0;0;19,3,0;0;17,0,17,130:A$=CHR$224+CHR$225:PRINTTAB(0,8)STRING$(10,A$);TAB(0,27)STRING$(10,A$)
    3VDU17,130,17,0:PRINTTAB(0,31)STRING$(20," ");:COLOUR128:PRINTTAB(0,0)CHR$11:COLOUR130:PRINTTAB(6,31);:VDU17,128
    4GCOL0,1:MOVE0,0:DRAW1276,0:DRAW1276,30:DRAW0,30:DRAW0,0
    5VDU23,224,&3C00;&9942;&4299;&003C;23,225,255,255,255,255,255,255,255,255,23,226,119,255,221,255,119,254,255,187,23,227,119,221,127,221,119,222,247,187,23,228,86,221,119,205,119,222,119,170,23,229,38,217,55,204,115,158,117,170
    6VDU23,230,38,201,53,76,83,148,85,138,23,231,164,18,36,169,16,108,3,200,23,246,0,0,0,219,219,0,0,0,23,247,254,195,192,100,126,97,112,63,23,248,62,63,113,100,124,232,192,192
    7GCOL0,1:MOVE0,128:DRAW1276,128:DRAW1276,158:DRAW0,158:DRAW0,128:MOVE0,736:DRAW1276,736:DRAW1276,766:DRAW0,766:DRAW0,736:MOVE4,128:DRAW4,158:MOVE4,736:DRAW4,766:MOVE1272,128:DRAW1272,158:MOVE1272,736:DRAW1272,766
    8VDU17,129,17,3:A$=CHR$10+CHR$8:PRINTTAB(0,9)STRING$(18,(CHR$225+CHR$225+A$+CHR$8)):C%=226:X%=2:FORN%=1TO6:PRINTTAB(X%,9)STRING$(18,(CHR$C%+CHR$C%+CHR$C%+CHR$8+CHR$8+A$)):C%=C%+1:X%=X%+3:NEXT:COLOUR128
    9DATA10011011101111010010111000000,11001001001001010010010000000,10101001001000011110010000000,10101001001011010010010001000,10101001001001010010000001100,10101001001111000000011001010,10011011100000001110010001001
   10DATA10001000000000010001010001001,00000000001110010001010001001,01100101010001010001010001001,00100101010001011111010001001,00100101010001010110010001001,00100101010001010010010001010,00010101010001010001010101100     
   11DATA00001010001110010001011101000
   12VDU23,232,&321E;&C060;&C6CE;&F8FC;23,233,&361C;&F666;&CEDE;&C6C6;23,234,&3612;&DA76;&DADA;&C2C2;23,235,&321C;&F860;&C6E0;&F8FC;23,236,&321E;&FC60;&0CF6;&F0F8;23,237,&2412;&D048;&F8E0;&C6CC;23,245,&3C18;&C266;&C6C2;&F8EC;
   13VDU23,238,&361E;&C666;&CEC6;&F8FC;23,239,&3010;&C260;&DCC6;&F0F8;23,240,&361C;&CE66;&F0DC;&C6DC;23,241,&361C;&CE66;&E0FC;&C0C0;23,242,&3212;&FA72;&CEDA;&C2C6;23,243,&3616;&FE66;&0C3C;&F0FC;23,244,&3E1E;&D878;&1898;&1818;
   14GCOL0,0:VDU5,19,3,6;0;:X%=25:Y%=682:FORN%=1TO15:READA$:FORM%=1TOLENA$:IFMID$(A$,M%,1)="1":MOVEX%,Y%:VDU225
   15X%=X%+42:NEXT:Y%=Y%-32:X%=25:NEXT:GCOL0,3:VDU4,17,129,17,1,28,0,30,19,28,12,17,130,28,2,30,17,28,19,1,1;0;19,2,3;0;12
   16DATA3,-126,-16,102,19,4,1,1,-32,-3,-5,7,13,5,2,-23,-7,125,10,13,7,2,32,84,-126,9,16,7,1,74,-10,-12,2,11,8,3,127,127,-68,5,16,6,1,-66,-46,-59,18,11,4,1,-4,-70,127,17,15,12,1,56,5,-95,17,11,14,1,-13,-20,40,13,19,16
   17FORn%=2TO10:READP1,P2,P3,P4,P5,P6,P7:ENVELOPEn%,P1,P2,P3,P4,P5,P6,P7,127,0,0,255,128,1:ENVELOPEn%+9,P1,P2,P3,P4,P5,P6,P7,126,0,0,-126,126,126
   18COLOUR128:*FX4,0
   19NEXT:VDU19,1,2;0;19,2,3;0;17,3,12
   20CALL&3590:I=INKEY(300):*FX15,1
   21VDU19,3,4;0;19,1,6;0;17,2,12
   22VDU17,128,26,17,3:PRINTTAB(2,5)CHR$247;TAB(17,5)CHR$248:COLOUR1:PRINTTAB(3,5)STRING$(14,CHR$246):VDU17,130,17,0,28,0,30,19,28,12
   23VDU23,249,&F400;&9494;&94F4;&0096;23,250,&9D00;&8989;&8989;&00DD;23,251,&EE00;&0E2A;&2A6A;&00EA;23,252,&EE00;&4E4A;&4A4A;&004A;23,253,&1B00;&1A12;&0A0A;&001B;23,254,&BB00;&B1A1;&A1A1;&00A1;26,17,0,17,130:PRINTTAB(5,31);
   24VDU32,249,250,251,252,253,254:VDU23,249,&A200;&2222;&2A2A;&003E;23,250,&EE00;&EEAA;&AAAC;&00AA;23,251,&F000;&C080;&8080;&00E0;249,250,251,28,2,30,17,28,17,2,17,128,12,17,3:GCOL0,1:MOVE0,0:DRAW1276,0:DRAW1276,30:DRAW0,30:DRAW0,0
   25VDU23,249,0,0,0,0,0,0,255,255:ENVELOPE1,1,0,0,0,2,2,2,30,0,0,255,128,1
   26PROCassemble
   27I=INKEY300:VDU28,2,30,2,30:PAGE=&1100:CHAIN"WORLD-2"
 1520DEFPROCassemble:os%=&FFEE:FORn%=0TO2STEP2
 1530P%=&A00
 1540[OPTn%
 1550.s LDY#0:.l LDA(&70),Y:CMP#0:BEQ ze:CMP#1:BEQ on:CMP#2:BEQ tw:CMP#3:BEQ th:.ba:DEC&73:LDA&73:BEQ rr:.pe:INY:TYA:CMP#180:BNE l:RTS:.rr JMP rt
 1552.ze LDA#32:JSR os%:JSR os%:JMP ba
 1560.on LDA#32:JSR os%:LDA#17:JSR os%:LDA#131:JSR os%:LDA#17:JSR os%:LDA#2:JSR os%:LDA&72:JSR os%:LDA#17:JSR os%:LDA#128:JSR os%:JMP ba
 1570.tw LDA#17:JSR os%:LDA#131:JSR os%:LDA#17:JSR os%:LDA#2:JSR os%:LDA&72:JSR os%:LDA#17:JSR os%:LDA#128:JSR os%:LDA#32:JSR os%:JMP ba
 1580.th LDA#17:JSR os%:LDA#131:JSR os%:LDA#17:JSR os%:LDA#2:JSR os%:LDA&72:JSR os%:LDA&72:JSR os%:LDA#17:JSR os%:LDA#128:JSR os%:JMP ba
 1581\ Reset &73 and bump &72
 1590.rt LDA#30:STA&73:INC&72:JMP pe
 1600]NEXT:ENDPROC
