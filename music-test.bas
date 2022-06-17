MODE 7
HIMEM=&2900:*LOAD World1c
CALL &3390:CALL R%!8
DIM plist% 1000, dlist% 1000
octave%=0
RESTORE 2000:REM TODO: Hack to temporarily just use Prestissimo section
I%=0
REPEAT
200READ note$,duration%
IF note$="Lento":note$="END":REM TODO: Hack to temporarily just use Prestissimo section
IF note$="Adagio":dmult%=6:GOTO 1000 ELSE IF note$="Prestissimo":dmult%=1:GOTO 1000 ELSE IF note$="Lento":dmult%=10:GOTO 1000
duration%=duration%*dmult%
IF note$="END":GOTO 1000
IF note$="":pitch%=0:GOTO 900
IF LEFT$(note$,1)="O":octave%=VAL(MID$(note$,2,1)):note$=MID$(note$,3)
IF LEFT$(note$,1)="+":octave%=octave%+1:note$=MID$(note$,2)
IF LEFT$(note$,1)="-":octave%=octave%-1:note$=MID$(note$,2)
adjust%=0
IF RIGHT$(note$,1)="#":adjust%=4:note$=LEFT$(note$,LEN(note$)-1) ELSE IF RIGHT$(note$,1)="_":adjust%=-4:note$=LEFT$(note$,LEN(note$)-1)
IF note$="c":pitch%=53 ELSE IF note$="d":pitch%=61 ELSE IF note$="e":pitch%=69 ELSE IF note$="f":pitch%=73 ELSE IF note$="g":pitch%=81 ELSE IF note$="a":pitch%=89 ELSE IF note$="b":pitch%=97 ELSE PRINT "Unknown note: ";note$:END
pitch%=pitch%+adjust%-1+octave%*48:REM -1 as BBC user guide values are 1 too high
900plist%?I%=pitch%:dlist%?I%=duration%
I%=I%+1
1000UNTIL note$="END"
toccata_length%=I%

PRINTTAB(0,20);"A - original music"'"B - Toccata and Fugue"

REPEAT
CALL R%!0
REPEAT
key$=INKEY$(0)
UNTIL key$="B"
*FX13,5

REM TODO: ADD SPEED-VARIABLE VERSION OF ORIGINAL MUSIC AS OPTION C, AND MAKE THE LIGHTNING CRASH NOISES DURING OPTIONS B/C
play%=0
REPEAT
pitch%=plist%?play%:duration%=dlist%?play%
REM PRINT pitch%,duration%
duration%=duration%*1.5:REM TODO!? 1.5 is experimental as part of prestissimo hack, it may sound better without this
vol%=-5:IF pitch%<=0 THEN vol%=0
SOUND 2,vol%,pitch%,duration%:SOUND 3,vol%,pitch%,duration%
play%=(play%+1) MOD toccata_length%
key$=INKEY$(0)
UNTIL key$="A"
*FX15
UNTIL FALSE
END

REM Bar 1
DATA "Adagio", 0
DATA "O2a", 1, "g", 1, "a", 1, "", 1, "g", 1, "f", 1, "e", 1, "d", 1, "c#", 2, "", 1, "d", 4, "", 4, "-a", 1, "g", 1, "a", 1, "", 1, "e", 1, "f", 1, "c#", 1, "d", 4, "", 4
DATA "-a", 1, "g", 1, "a", 1, "", 1, "g", 1, "f", 1, "e", 1, "d", 1, "c#", 2, "", 1, "d", 4, "", 4, "-b_", 2, "+c#", 2, "e", 2, "g", 2, "b_", 2, "+c#", 2, "e", 10
DATA "d", 8, "", 8, "", 4, "", 2, "c#", 2
REM Bar 4
2000DATA "Prestissimo", 0
REM TODO: Copy of "preceding" note from Adagio section, as part of hacks which would otherwise omit this
DATA "c#", 4
DATA "d", 2, "e", 2, "c#", 2, "d", 2, "e", 2, "c#", 2, "d", 2, "e", 2, "c#", 2, "d", 2, "e", 2, "f", 2, "g", 2, "e", 2, "f", 2, "g", 2, "e", 2, "f", 2, "g", 2, "e", 2, "f", 2, "g", 2
DATA "a", 2, "b_", 2, "g", 2, "a", 2, "b_", 2, "g", 2, "a", 2, "b_", 2, "g", 2, "a", 4, "", 8, "", 4, "", 2, "+c#", 2
REM Bar 6
DATA "d", 2, "e", 2, "c#", 2, "d", 2, "e", 2, "c#", 2, "d", 2, "e", 2, "c#", 2, "d", 2, "e", 2, "f", 2, "g", 2, "e", 2, "f", 2, "g", 2, "e", 2, "f", 2, "g", 2, "e", 2, "f", 2, "g", 2
DATA "a", 2, "b_", 2, "g", 2, "a", 2, "b_", 2, "g", 2, "a", 2, "b_", 2, "g", 2, "a", 2, "", 8, "", 4, "", 2, "a", 2
REM Bar 8
DATA "g", 2, "b_", 2, "e", 2, "g", 2, "b_", 2, "e", 2, "f", 2, "a", 2, "d", 2, "f", 2, "a", 2, "d", 2, "e", 2, "g", 2, "c", 2, "e", 2, "g", 2, "c", 2, "d", 2, "f", 2, "-b_", 2, "+d", 2, "f", 2, "-b_", 2
DATA "+c", 2, "e", 2, "-a", 2, "+c", 2, "e", 2, "-a", 2, "b_", 2, "+d", 2, "-g", 2, "b_", 2, "+d", 2, "-g", 2, "a", 2, "+c", 2, "-f", 2, "a", 2, "+c", 2, "-f", 2, "g", 2, "b_", 2, "e", 2, "g", 2, "b_", 2, "e_", 2
REM Bar 10
DATA "f", 2, "a", 2, "d", 2, "f", 2, "a", 2, "d", 2, "e", 2, "g", 2, "c#", 2, "e", 2, "g", 2, "c#", 2, "", 8
DATA "", 4, "", 2:REM TODO: add extra pause to match other "sub-passages" as part of Prestissimo-only hack
DATA "Lento", 0, "-c", 2, "e", 2, "g", 2, "b_", 2
REM TODO: Add the pair of grace notes in bar 11?
DATA "+c#", 2, "e", 2, "g", 2, "b_", 3, "a", 1, "g", 1, "f", 1, "e", 1, "d", 1, "c", 1, "-b", 1, "+c", 2, "-a", 2, "+c", 2, "e", 1, "g", 1, "f", 6, "e", 2
DATA "f", 10
DATA "END", 0

REM DATA 137,1,129,1,137,1,0,1,129,1,121,1,117,1,109,1,105,2,0,1,109,4,0,4,89,1,81,1,89,1,0,1,69,1,73,1,57,1,61,4,0,4
REM DATA 41,1,33,1,41,1,0,1,33,1,25,1,211,13,1,9,1,0,1,13,4,0,4,0,1,45,2,57,2,69,2,33,2,45,2,53,2,69,10
REM DATA 61,8,0,8,0,4,0,2,57,2
REM Bar 4
REM DATA 61,2,69,2,57,2,61,2,69,2,53,2,61,2,69,2,53,2,61,2,69,2,73,2,81,2,69,2,73,2,81,2,69,2,73,2,81,2,69,2,73,2,81,2
