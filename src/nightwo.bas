   20MODE7:VDU23;8202;0;0;0;
   30PRINTTAB(0,0);:VDU130,157,141,133:PRINTTAB(15,0)"NIGHTWORLD":PRINTTAB(0,1);:VDU129,157,141,132:PRINTTAB(15,1)"NIGHTWORLD"
   32R$="2022 re-mastered edition 0.01"
   35PRINTTAB(5);CHR$131;R$
   40PRINTTAB(3,4)"You are Lee Lance the explorer."'" Find your way through the many vaults   of this cavernous underworld collecting the objects that will lead to the final escape route and the magical golden     fleece."
   50PRINT'" Beware the flying harpies as they drain your energy level."
   60PRINT" It can be replenished. How? That's for  you to work out."
   70PRINT'" As the day passes to night your body    transforms from human to creature and   you take on the mysterious powers of    a mutant gargoyle."
   80PRINT'" A percentage of how far you've gone is  shown when your energy runs out.":*FX15,0
   90PRINT'TAB(7);:VDU136:PRINT"PRESS ANY KEY TO CONTINUE";
  100A=GET:*FX15,0
  110CLS:PRINTTAB(0,0);:VDU130,157,141,133:PRINTTAB(15,0)"NIGHTWORLD":PRINTTAB(0,1);:VDU129,157,141,132:PRINTTAB(15,1)"NIGHTWORLD"
  115PRINTTAB(5);CHR$131;R$
  120PRINT'" FEATURES"
  130PRINT" Time Clock: Sun - Lee Lance the human.  Moon - Lee Lance the gargoyle."
  140PRINT" Energy Level. Secret Passages.          Secret Rooms. Flying Harpies.           Mysterious Objects. Deadly Nasties.     Wall Climbing Abilities."
  150PRINT'TAB(16)"CONTROLS"''TAB(10)"LEFT           <Z>"TAB(10)"RIGHT          <X>"TAB(10)"JUMP         <SHIFT>"TAB(10)"RERUN        <ESCAPE>"
  160PRINTTAB(10)"PAUSE          <P>"TAB(10)"CONTINUE       <C>"TAB(10)"QUIET GAME     <Q>"
  170PRINT'TAB(2)"Created by Game Systems. (C) ALLIGATA"''TAB(13)"�PRESS ANY KEY";:A=GET
  180MODE4:VDU23;8202;0;0;0;19,1,0;0;23,255,60,66,153,145,153,66,60,0:D$=CHR$10+STRING$(12,CHR$8):W$="NIGHT  WORLD"+D$+" "+CHR$255+" ALLIGATA "+D$+" CREATED BY "+D$+"    D.M.    "+D$+"GAME SYSTEMS"
  190DATA1,252,177,476,217,380,385,444,433,400,553,524,633,524,641,596,601,580,609,548,569,580,553,652,585,748,641,772,625,748,641,708,657,708,641,756
  200DATA665,740,697,756,681,708,697,708,713,748,705,772,753,740,777,652,761,580,721,548,729,580,689,596,697,524,769,524,825,452,873,460,969,284,1081,380,1177,284,1217,332,1280,252,0,0
  210FORn%=1TO40:x%=RND(1280):y%=RND(1024-550)+550:PLOT69,x%,y%:NEXT:VDU28,15,15,24,7,12,26
  220Y%=3:REPEATMOVE0,Y%:DRAW1280,Y%:Y%=Y%+(Y%/3):UNTILY%>252:READx%,y%:MOVEx%,y%:REPEATREADx%,y%:IFx%<>0:DRAWx%,y%
  230UNTILx%=0:GCOL0,0:COLOUR129:COLOUR0:VDU28,13,30,27,20:CLS:VDU5,26:FORN%=464TO468STEP4:MOVEN%,352:PRINTW$:NEXT:VDU4,28,14,30,27,27:VDU19,1,6;0;:*fx15,1
  240I=INKEY(300):CHAIN "WORLD-1"
