REPEAT
READ pitch%, duration%
pitch%=pitch%-1:REM TODO: hack to adjust the values from BBC user guide
duration%=duration%*3:REM TODO!?
vol%=-5:IF pitch%<=0 THEN vol%=0
SOUND 2,vol%,pitch%,duration%:SOUND 3,voL%,pitch%,duration%
UNTIL FALSE
END
DATA 137,1,129,1,137,1,0,1,129,1,121,1,113,1,109,1,105,2,0,1,109,4,0,4
REM Bar 4
REM DATA 61,2,69,2,57,2,61,2,69,2,53,2,61,2,69,2,53,2,61,2,69,2,73,2,81,2,69,2,73,2,81,2,69,2,73,2,81,2,69,2,73,2,81,2
