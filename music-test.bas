REPEAT
READ pitch%, duration%
IF pitch%<>0 THEN pitch%=pitch%-1+48:REM TODO: hack to adjust the values from BBC user guide and move up an octave
duration%=duration%*3:REM TODO!?
vol%=-5:IF pitch%<=0 THEN vol%=0
SOUND 2,vol%,pitch%,duration%:SOUND 3,vol%,pitch%,duration%
UNTIL FALSE
END
DATA 137,1,129,1,137,1,0,1,129,1,121,1,117,1,109,1,105,2,0,1,109,4,0,4,89,1,81,1,89,1,0,1,69,1,73,1,57,1,61,4,0,4
DATA 121,1,117,1,121,1,0,1,117,1,109,1,101,1,93 ,1,93,1,0,1,93 ,4,0,4,0,1,-3 ,2,9,2,21,2,33,2,45,2,53,2,69,10
DATA 61,8,0,8,0,4,0,2,57,2
REM Bar 4
DATA 61,2,69,2,57,2,61,2,69,2,53,2,61,2,69,2,53,2,61,2,69,2,73,2,81,2,69,2,73,2,81,2,69,2,73,2,81,2,69,2,73,2,81,2
