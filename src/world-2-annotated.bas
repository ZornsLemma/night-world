constant S_OP_MOVE = 0
constant S_OP_SHOW = 1
constant S_OP_REMOVE = 2

constant SLOT_ENEMY = 5
constant SLOT_SUN_MOON = 6
constant SLOT_MISC = 7
constant SLOT_LEE = 10
constant SLOT_COLLECTED_PRISM = 19

constant IMAGE_HUMAN_RIGHT = 9
constant IMAGE_HUMAN_LEFT = 10
constant IMAGE_GARGOYLE_RIGHT = 11
constant IMAGE_GARGOLYLE_LEFT = 12
constant IMAGE_HARPY_RIGHT = 13
constant IMAGE_HARPY_LEFT = 14
constant IMAGE_WINGED_CREATURE = 15
constant IMAGE_ROBOT = 16
constant IMAGE_FLEECE_MACGUFFIN_PRISM = 17
constant IMAGE_HEALTH = 18
constant IMAGE_VEIL = 19
constant IMAGE_WALL_ENEMY_LEFT = 20
constant IMAGE_WALL_ENEMY_RIGHT = 21
constant IMAGE_EYE = 22
constant IMAGE_STATUE = 23
constant IMAGE_VEIL2 = 26
constant IMAGE_SUN = 24
constant IMAGE_MOON = 25
constant IMAGE_FINAL_GUARDIAN = 27

constant DELTA_STEP_LEFT_UP = 1
constant DELTA_STEP_RIGHT_UP = 3
constant DELTA_STEP_LEFT = 4
constant DELTA_STEP_RIGHT = 6
constant DELTA_STEP_LEFT_DOWN = 7
constant DELTA_STEP_RIGHT_DOWN = 9

constant R_TABLE_Q = 0
constant R_TABLE_S = 2
constant R_TABLE_T = 4
constant R_TABLE_U = 6
constant R_TABLE_V = 8
constant R_TABLE_DRAW_ROOM = 10
constant R_TABLE_PITCH = 12
constant R_TABLE_DURATION = 14
constant R_TABLE_CURRENT_NOTE = 16
constant R_TABLE_SOUND_NONBLOCKING = 18
constant R_TABLE_PLAY_270 = 20
constant R_TABLE_PLAY_280 = 22
constant R_TABLE_DELTA_X = 24
constant R_TABLE_JUMPING = 26
constant R_TABLE_FALLING_DELTA_X = 28
constant R_TABLE_FALLING_TIME = 30
constant R_TABLE_DAY_NIGHT = 32
constant R_TABLE_LEE_DIRECTION = 34
constant R_TABLE_JUMP_TIME = 36
constant R_TABLE_JUMP_DELTA_Y = 38
constant R_TABLE_PLAY_330 = 40
constant R_TABLE_PLAY_320 = 42
constant R_TABLE_FULL_SPEED_JUMP_TIME_LIMIT = 44
constant R_TABLE_MAX_JUMP_TIME = 46
constant R_TABLE_GAME_ENDED = 48
constant R_TABLE_ROOM_TYPE = 50
constant R_TABLE_AH = 52
constant R_TABLE_AK = 54
constant R_TABLE_DB = 56
constant R_TABLE_ROOM_TYPE_1_CONTINUE = 58
constant R_TABLE_LOGICAL_ROOM = 60
constant R_TABLE_THIS_ITEM = 62
constant R_TABLE_ITEM_COLLECTED = 64
constant R_TABLE_ENERGY_MINOR = 66
constant R_TABLE_ENERGY_MAJOR = 68
constant R_TABLE_PLAY_370 = 70
constant R_TABLE_SUN_MOON_DISABLED = 72
constant R_TABLE_M = 74
constant R_TABLE_CONTINUE_AFTER_ADVANCE_SUN_MOON = 76
constant R_TABLE_SCORE = 78
constant R_TABLE_ED_SCALAR = 80
constant R_TABLE_PLAY_290 = 82
constant R_TABLE_PENDING_SOUND_AND_LIGHT_SHOW_SECOND_PART = 84
constant R_TABLE_DOOR_SLAMMED = 86
constant R_TABLE_DOOR_SLAM_COUNTER = 88

constant TWEAK_STROBE=&9FD
constant TWEAK_FIXED_PALETTE=&9FC
constant FIXED_PALETTE1=2
constant FIXED_PALETTE2=5
constant FIXED_PALETTE3=7

   0IFPAGE>&E00:GOTO32000
   10Q%=R%!R_TABLE_Q:S%=R%!R_TABLE_S:T%=R%!R_TABLE_T:U%=R%!R_TABLE_U:V%=R%!R_TABLE_V
   20VDU17,128,17,3,12,26,19,3,7;0;:B$=STRING$(3,CHR$8)+CHR$10:A$=CHR$232+CHR$233+CHR$234+B$+CHR$235+":"+CHR$236+B$+CHR$243+CHR$236+CHR$244+B$+CHR$235+CHR$234+CHR$236:PROCclear_room:VDU5:GCOL0,3:MOVE532,528:PRINTA$:PROCdelay(18000):VDU4
   30REM If we hit an error other than Escape, let's make it obvious so it can be fixed.
   35REM TODO: Are we at risk of the problem where SRAM utilities corrupts a byte of memory around ~&1700 if an error occurs on a B?!
   40ONERROR:VDU4:IFERR=17:uw%=1:GOTO100 ELSE COLOUR3:COLOUR128:REPORT:PRINT;ERL:END
   50won%=0:PROCset8(R_TABLE_SCORE,13):uw%=0:PROCset8(R_TABLE_ENERGY_MAJOR,10)
   60PROCone_off_init
   70PROCnew_game_init:*FX15,0
   90PROCtitle_screen:PROCdraw_current_room:*FX200
   93PROCplay:*FX13,5
   95IFw%=1:PROCo:REM TODO: PROCo DOES NOT EXIST, AND DOESN'T SEEM TO EXIST IN THE ORIGINAL VERSION EITHER! HOWEVER, w% SEEMS TO BE PERMANENTLY 0 - DOUBLE CHECK, THEN GET RID OF IT AND THIS LINE
  100*FX13,5
  101*FX200,1
  105PROCgame_over:GOTO70

  110DEFPROCstop_sound:SOUND&11,0,0,0:ENDPROC

  200DEFPROCchange_lee_sprite
  202W%=SLOT_LEE:X%=FNget8(R_TABLE_LEE_DIRECTION)+2*FNget8(R_TABLE_DAY_NIGHT):CALLU%
  203Y%=S_OP_MOVE
  208ENDPROC

  209DEFPROCset_colours:VDU19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:ENDPROC

  210DEFPROCdraw_current_room:PROCclear_room
  211REM TODONOW NEXT LINE NEEDS TWEAKING FOR FIXED PALETTE?
  220IFFNget8(R_TABLE_SCORE)<100:RESTORE1452:IF?TWEAK_FIXED_PALETTE=0:FORn%=1TOFNget8(R_TABLE_LOGICAL_ROOM):READcolour1%,colour2%,colour3%:NEXT
  230PROCset_colours:IFFNget8(R_TABLE_LOGICAL_ROOM)=10:sound_and_light_show_chance%=4 ELSEsound_and_light_show_chance%=40
  240IFFNget8(R_TABLE_LOGICAL_ROOM)<1ORFNget8(R_TABLE_LOGICAL_ROOM)>14:PROCset8(R_TABLE_LOGICAL_ROOM,1):phys_room%=1:C%=128:PROCset8(R_TABLE_ROOM_TYPE,0):PROCdraw_room(1):COLOUR3:PRINTTAB(7,26);:VDU245,234:ENDPROC
  250PROCdraw_room(FNget8(R_TABLE_LOGICAL_ROOM)):ENDPROC

  251M%=RND(3):CALLR%!R_TABLE_ROOM_TYPE_1_CONTINUE:GOTOM%
  252IFRND(sound_and_light_show_chance%)=1:PROCset8(R_TABLE_PENDING_SOUND_AND_LIGHT_SHOW_SECOND_PART,1):PROCsound_and_light_show
  253CALLR%!R_TABLE_PLAY_290:GOTOM%
  254VDU19,0,0;0;:PROCset_colours:CALLR%!R_TABLE_PLAY_280:GOTOM%
  255CALLR%!R_TABLE_PLAY_280:GOTOM%
  256PROCpause:CALLR%!R_TABLE_PLAY_320:GOTOM%:REM TODO TEMP - MAYBE?
  257PROCchange_room:IFFNget8(R_TABLE_GAME_ENDED)=0:CALLR%!R_TABLE_PLAY_270:GOTOM% ELSE ENDPROC
  258VDU19,0,0;0;:PROCset_colours:ENDPROC:REM TODO TEMP - MAYBE?
  259ON JUNK GOTO 252,254,531,1181,381,251,255,256,257,258:REM TODO TEMP - SO ABE PACK LEAVES THESE LINES ALONE

  260DEFPROCplay
  270CALLR%!R_TABLE_PLAY_270:GOTOM%
  381PROCcheck_warps:CALLR%!R_TABLE_PLAY_270:GOTOM%

  390DEFPROCsound_and_light_show:PROCstop_sound
  391IF?TWEAK_STROBE=0:VDU19,0,7;0;19,1,0;0;19,2,0;0;19,3,0;0;
  392SOUND&10,-13,5,6:SOUND0,-10,5,6:SOUND0,-7,6,10:ENDPROC

  400DEFPROCshow_using_slot_misc(text_x%,text_y%,image%):M%=(text_x%*64)-4:N%=(1024-(32*text_y%))+28:X%=image%:W%=SLOT_MISC:IFimage%=20:M%=M%+4
  410CALLS%:CALLU%:ENDPROC

  531PROCtoggle_day_night:CALLR%!R_TABLE_CONTINUE_AFTER_ADVANCE_SUN_MOON:GOTOM%

  540DEFPROCtoggle_day_night:*FX13,5
  545RESTORE1450:FORn%=1TO140STEP5:READo%:SOUND1,3,n%,2:SOUND2,2,n%+10,3
  546IF?TWEAK_STROBE=0:VDU19,1,o%;0;19,2,o%-1;0;19,3,o%-2;0;
  547IFo%=0:RESTORE1450
  550NEXT:PROCset_colours:PROCstop_sound:W%=SLOT_SUN_MOON:Y%=S_OP_REMOVE:CALLS%:K%=192
  551IFFNget8(R_TABLE_DAY_NIGHT)=0:PROCset8(R_TABLE_DAY_NIGHT,1):PROCchange_lee_sprite:X%=IMAGE_MOON:W%=SLOT_SUN_MOON:CALLS%:CALLU%:W%=SLOT_LEE:PROCset8(R_TABLE_FULL_SPEED_JUMP_TIME_LIMIT,45):PROCset8(R_TABLE_MAX_JUMP_TIME,90):PROChide_fleece:ENDPROC
  560PROCset8(R_TABLE_FULL_SPEED_JUMP_TIME_LIMIT,20):PROCset8(R_TABLE_MAX_JUMP_TIME,40):PROCset8(R_TABLE_DAY_NIGHT,0):PROCchange_lee_sprite:X%=IMAGE_SUN:W%=SLOT_SUN_MOON:CALLS%:CALLU%:W%=SLOT_LEE:PROCrestore_fleece:ENDPROC

  570DEFPROCdelay(n1%):FORn%=1TOn1%:NEXT:ENDPROC

  579REM TODO: Bit misnamed as this also handles collecting the fleece
  580DEFPROCcheck_warps
  581REM If player is in room 1 (Ed's room D) and at the far left of the screen,
  582REM warp to room 9 (Ed's room A).
  583IFFNget8(R_TABLE_LOGICAL_ROOM)=1ANDC%<68:phys_room%=12:C%=1142:D%=316:Y%=S_OP_REMOVE:W%=SLOT_ENEMY:CALLS%:PROCremove_lee_sprite:PROCset8(R_TABLE_LOGICAL_ROOM,8):PROCdraw_current_room:PROCwarp_effect:ENDPROC
  585REM If player is in room 10 (Ed's room J) and in the top half of the screen,
  586REM warp to room 9 (Ed's room N) - the fleece room.
  590IFFNget8(R_TABLE_LOGICAL_ROOM)=10ANDC%>=1152ANDD%>480:phys_room%=14:PROCset8(R_TABLE_LOGICAL_ROOM,9):C%=68:D%=416:Y%=S_OP_REMOVE:W%=SLOT_ENEMY:CALLS%:PROCremove_lee_sprite:PROCdraw_current_room:PROCwarp_effect:PROCset8(R_TABLE_ROOM_TYPE,2):ENDPROC
  595REM If player is in room 13 at a specific point on the right edge, warp to
  596REM room 7 (Ed's room H).
  600IFFNget8(R_TABLE_LOGICAL_ROOM)=13ANDC%>1150AND(D%=288ORD%=284):phys_room%=9:C%=1148:D%=420:Y%=S_OP_REMOVE:W%=SLOT_ENEMY:CALLS%:PROCremove_lee_sprite:PROCset8(R_TABLE_LOGICAL_ROOM,7):PROCdraw_current_room:PROCwarp_effect:ENDPROC
  605REM If player is in room 5 (Ed's room G), has a score of 90% and it's daytime,
  606REM show a lightning flash effect. If the player has collided with SLOT_MISC, it's the fleece; collect it.
  607REM PROCdelay() in next line has been added to try to work round what I felt was an unwanted "regularity" in lightning effect now the main loop is in machine code and a bit tighter/more predictable.
  610IFFNget8(R_TABLE_LOGICAL_ROOM)=5ANDFNget8(R_TABLE_SCORE)=90ANDFNget8(R_TABLE_DAY_NIGHT)=0:PROCfleece_lightning:IFX%=SLOT_MISC:PROCcollect_fleece
  620ENDPROC

  621DEFPROCfleece_lightning
  622IFnext_flash%=0:IF?TWEAK_STROBE=0:PROCdelay(RND(40)):VDU19,0,7;0;19,1,0;0;19,0,0;0;19,1,3;0;:next_flash%=RND(2) ELSE next_flash%=next_flash%-1
  628ENDPROC

  630DEFPROCcollect_fleece:*FX13,5
  635Y%=S_OP_REMOVE:W%=SLOT_SUN_MOON:CALLS%:W%=SLOT_MISC:CALLS%:RESTORE1450:PROCset8(R_TABLE_SCORE,100):PROCset8(R_TABLE_SUN_MOON_DISABLED,1):PROCremove_lee_sprite:FORn%=10TO100STEP5:FORnm%=110TO200STEPn%:READok%
  637IF?TWEAK_STROBE=0:VDU19,1,ok%;0;19,2,ok%;0;19,3,ok%;0;
  638IFok%=0:RESTORE1450
  640SOUND1,4,n%+nm%,2:SOUND2,12,n%+nm%,3:NEXT,
  641IF?TWEAK_FIXED_PALETTE=0:colour1%=6:colour3%=4
  642colour2%=0:REM We do this even with a fixed palette, as it just makes colour 2 the same as colour 0
  643PROCset_colours
  645VDU17,131,17,2:PRINTTAB(9,14)STRING$(4,CHR$227):COLOUR128:CALLV%:ENDPROC

  799REM TODO: Moving this towards end of code would slightly speed up line number searching for GOTOs
  800DEFPROCnew_game_init:CALLV%:PROCclear_room:VDU28,4,30,15,28,17,128,12,26
  801PROCset8(R_TABLE_DOOR_SLAMMED,0)
  802next_flash%=0
  803FORn%=28TO30:FORwn%=0TO2:VDU31,wn%,n%,(229+wn%),31,(wn%+17),n%,(229+wn%):NEXT,:ENDPROC

  815REM TODO: Moving this towards end of code would slightly speed up line number searching for GOTOs
  820DEFPROCone_off_init:CALLV%:DIMad%(4),ed%(6):ad%(1)=3:ad%(2)=9:ad%(3)=7:ad%(4)=1:ed%(1)=3:ed%(2)=6:ed%(3)=9:ed%(4)=7:ed%(5)=4:ed%(6)=1:VDU17,3,17,128,28,0,30,19,28,12,26:ENDPROC

  840DEFPROCclear_room
  843Y%=S_OP_REMOVE:W%=SLOT_MISC:CALLS%:Y%=S_OP_MOVE
  847VDU28,0,26,19,9,17,128,12,26:ENDPROC

  850DEFPROCdraw_room(b1%):!&70=b1%*45:PRINTTAB(0,9);:CALLR%!R_TABLE_DRAW_ROOM
  851REM TODO: Experimental anti-stick hack - if this works, we might want to tidy up the drawing process so the user can't see this being removed, though it's probably not a huge deal.
  852IFb1%=12:GCOL0,0:MOVE312,224:DRAW312,288:MOVE384,224:DRAW384,288:REM widen the base of the chimney towards left of room K so player can "climb" it
  860PROCset8(R_TABLE_DOOR_SLAM_COUNTER,0)
  880IFFNget8(R_TABLE_ROOM_TYPE)=2:I%=608:J%=672:W%=SLOT_ENEMY:Y%=S_OP_MOVE:CALLS%:GOTO900
  890PROCset8(R_TABLE_DB,6):IFFNget8(R_TABLE_ROOM_TYPE)>0:I%=291:J%=480:W%=SLOT_ENEMY:Y%=S_OP_MOVE:CALLS%:IFFNget8(R_TABLE_ROOM_TYPE)=1:X%=IMAGE_HARPY_RIGHT:CALLU%
  900IFFNget8(R_TABLE_LOGICAL_ROOM)=2ANDFNget8(R_TABLE_SCORE)=80:PROCset8(R_TABLE_ROOM_TYPE,3):X%=IMAGE_VEIL2:CALLU%:GOTO960
  910IFFNget8(R_TABLE_LOGICAL_ROOM)=5ANDFNget8(R_TABLE_SCORE)=90:PROCset8(R_TABLE_ROOM_TYPE,0):Y%=S_OP_REMOVE:CALLS%:Y%=S_OP_MOVE
  920IFFNget8(R_TABLE_ROOM_TYPE)=2:X%=IMAGE_WINGED_CREATURE:CALLU%
  930IFFNget8(R_TABLE_ROOM_TYPE)=3:X%=IMAGE_ROBOT:CALLU%
  940IFFNget8(R_TABLE_ROOM_TYPE)=4:X%=IMAGE_EYE:CALLU%
  950IFFNget8(R_TABLE_ROOM_TYPE)=5:Y%=S_OP_REMOVE:CALLS%:I%=640:J%=316:Y%=S_OP_MOVE:CALLS%:PROCset8(R_TABLE_ED_SCALAR,6):IFFNget8(R_TABLE_SCORE)>70ANDFNget8(R_TABLE_SCORE)<100:X%=IMAGE_VEIL:CALLU% ELSEIFFNget8(R_TABLE_ROOM_TYPE)=5ANDFNget8(R_TABLE_SCORE)=100:X%=IMAGE_FINAL_GUARDIAN:CALLU%
  960PROCset8(R_TABLE_AK,0):PROCset8(R_TABLE_AH,1):W%=2:Y%=S_OP_SHOW:IFFNget8(R_TABLE_LOGICAL_ROOM)=9:W%=SLOT_MISC:M%=1035:N%=692:CALLS%:X%=IMAGE_FLEECE_MACGUFFIN_PRISM:CALLU%:IFFNitem_collected(5)=0:PROCshow_using_slot_misc(2,14,IMAGE_HEALTH)
  970IFFNget8(R_TABLE_LOGICAL_ROOM)=6:PROCshow_using_slot_misc(18,15,IMAGE_WALL_ENEMY_RIGHT):PROCshow_using_slot_misc(18,19,IMAGE_WALL_ENEMY_RIGHT)
  980IFFNget8(R_TABLE_LOGICAL_ROOM)=10ANDFNget8(R_TABLE_SCORE)>70:PRINTTAB(10,26)"  "
  990IFFNget8(R_TABLE_LOGICAL_ROOM)=5ANDFNget8(R_TABLE_SCORE)>80:PRINTTAB(9,14)"  "
 1000IFFNget8(R_TABLE_LOGICAL_ROOM)=13:PROCroom_13_tweaks
 1010IFFNget8(R_TABLE_LOGICAL_ROOM)=1:PROCshow_using_slot_misc(9,12,IMAGE_STATUE):IFFNitem_collected(1)=0:PROCshow_using_slot_misc(2,12,IMAGE_FLEECE_MACGUFFIN_PRISM)
 1020IFFNget8(R_TABLE_LOGICAL_ROOM)=7:PROCshow_using_slot_misc(6,21,IMAGE_STATUE):IFFNitem_collected(2)=0:PROCshow_using_slot_misc(2,11,IMAGE_FLEECE_MACGUFFIN_PRISM)
 1030IFFNget8(R_TABLE_LOGICAL_ROOM)=2:PROCshow_using_slot_misc(1,23,IMAGE_WALL_ENEMY_LEFT)
 1040IFFNget8(R_TABLE_LOGICAL_ROOM)=8:PROCshow_using_slot_misc(11,23,IMAGE_STATUE):PROCshow_using_slot_misc(9,21,IMAGE_STATUE):PROCshow_using_slot_misc(13,24,IMAGE_STATUE)
 1050IFFNget8(R_TABLE_LOGICAL_ROOM)=14:PROCshow_using_slot_misc(8,20,IMAGE_WALL_ENEMY_RIGHT):PROCshow_using_slot_misc(11,20,IMAGE_WALL_ENEMY_LEFT):VDU17,131,17,2:PRINTTAB(0,26)STRING$(20,CHR$231):COLOUR128:IFFNitem_collected(4)=0:PROCshow_using_slot_misc(12,25,IMAGE_FLEECE_MACGUFFIN_PRISM)
 1060IFFNget8(R_TABLE_LOGICAL_ROOM)=12:PROCshow_using_slot_misc(1,15,IMAGE_WALL_ENEMY_LEFT):PROCshow_using_slot_misc(1,18,IMAGE_WALL_ENEMY_LEFT):PROCshow_using_slot_misc(1,21,IMAGE_WALL_ENEMY_LEFT)
 1070IFFNget8(R_TABLE_LOGICAL_ROOM)=13:PROCshow_using_slot_misc(7,21,IMAGE_STATUE):PROCshow_using_slot_misc(12,21,IMAGE_STATUE)
 1080IFFNget8(R_TABLE_LOGICAL_ROOM)=5ANDFNget8(R_TABLE_SCORE)=90:M%=608:N%=512:W%=SLOT_MISC:CALLS%:X%=IMAGE_FLEECE_MACGUFFIN_PRISM:CALLU%:IFFNget8(R_TABLE_DAY_NIGHT)=1:Y%=S_OP_REMOVE:CALLS%
 1090IFFNget8(R_TABLE_LOGICAL_ROOM)=5ANDFNitem_collected(3)=0:PROCshow_using_slot_misc(18,24,IMAGE_FLEECE_MACGUFFIN_PRISM)
 1100ENDPROC

1101DEFPROCroom_13_tweaks:REM TODO: This probably doesn't actually needs its own procedure after all, but don't revert just yet while tinkering
1102REM This logic is now in draw_room_subroutine: IF FNget8(R_TABLE_SCORE)=60 OR (FNget8(R_TABLE_SCORE)>=80 AND FNget8(R_TABLE_DOOR_SLAMMED)=0):PRINTTAB(19,17)STRING$(3," "+CHR$8+CHR$10)
1103IF FNget8(R_TABLE_SCORE)=80 AND FNget8(R_TABLE_DOOR_SLAMMED)=0:PROCset8(R_TABLE_DOOR_SLAM_COUNTER,32)
1106ENDPROC

 1110DEFPROCchange_room:IFFNget8(R_TABLE_LOGICAL_ROOM)=10ANDD%<228:PROCwin:PROCset8(R_TABLE_GAME_ENDED,1):ENDPROC
 1121IFD%>730:D%=224:phys_room%=phys_room%-5 ELSEIFD%<228:D%=728:phys_room%=phys_room%+5 ELSEIFC%>1194:C%=24:phys_room%=phys_room%+1 ELSEIFC%<24:C%=1194:phys_room%=phys_room%-1
 1122PROCchange_room2:ENDPROC
 1124DEFPROCchange_room2
 1127W%=SLOT_ENEMY:Y%=S_OP_REMOVE:CALLS%:W%=SLOT_LEE:CALLS%
 1130RESTORE1430:FORn%=1TOphys_room%:READlogical_room_tmp%:NEXT:RESTORE1440:PROCset8(R_TABLE_LOGICAL_ROOM,logical_room_tmp%):FORn%=1TOFNget8(R_TABLE_LOGICAL_ROOM):READroom_type_tmp%:NEXT:PROCset8(R_TABLE_ROOM_TYPE,room_type_tmp%):IFFNget8(R_TABLE_SCORE)=100:PROCset8(R_TABLE_ROOM_TYPE,2)
 1140IFFNget8(R_TABLE_LOGICAL_ROOM)=10ANDFNget8(R_TABLE_SCORE)>70:PROCset8(R_TABLE_ROOM_TYPE,5)
 1150PROCdraw_current_room:ENDPROC

 1181IFFNget8(R_TABLE_THIS_ITEM)<5:PROCshow_prisms
 1182W%=SLOT_MISC:Y%=S_OP_REMOVE:CALLS%:REM remove the collected object from the room
 1190PROCstop_sound:PROCdelay(100):SOUND1,6,20,4
 1191IF?TWEAK_STROBE=0:VDU19,0,7;0;
 1192PROCset8(R_TABLE_SCORE,FNget8(R_TABLE_SCORE)+20):PROCset8(R_TABLE_ENERGY_MINOR,50):PROCdelay(150):VDU19,0,0;0;
 1193IFFNget8(R_TABLE_LOGICAL_ROOM)=9:PROCset8(R_TABLE_SCORE,FNget8(R_TABLE_SCORE)-10):COLOUR1:PRINTTAB(FNget8(R_TABLE_ENERGY_MAJOR),5)CHR$246:PROCset8(R_TABLE_ENERGY_MAJOR,16):VDU17,0,17,131:PRINTTAB(16,5)CHR$224:VDU17,128
 1200CALLR%!R_TABLE_PLAY_370:GOTOM%

 1250DEFPROChide_fleece:IFFNget8(R_TABLE_LOGICAL_ROOM)<>5:ENDPROC
 1260IFFNget8(R_TABLE_SCORE)<90:ENDPROC ELSEW%=SLOT_MISC:Y%=S_OP_REMOVE:CALLS%:ENDPROC

 1270DEFPROCrestore_fleece:IFFNget8(R_TABLE_LOGICAL_ROOM)<>5:ENDPROC
 1275M%=608:REM machine code conversion of PROCplay corrupts M%; just fix it up here for now TODO: neater fix?
 1280IFFNget8(R_TABLE_SCORE)<90:ENDPROC ELSEW%=SLOT_MISC:X%=IMAGE_FLEECE_MACGUFFIN_PRISM:CALLS%:CALLU%:ENDPROC

 1290DEFPROCwarp_effect:*FX13,5
 1295IF?TWEAK_STROBE=0:VDU19,1,7;0;19,2,7;0;19,3,7;0;
 1296SOUND1,6,60,4:PROCdelay(120):PROCset_colours:ENDPROC

 1320DEFPROCtitle_screen
 1321IF?TWEAK_FIXED_PALETTE=0:colour1%=7:colour2%=6:colour3%=1 ELSE colour1%=FIXED_PALETTE1:colour2%=FIXED_PALETTE2:colour3%=FIXED_PALETTE3
 1322PROCreset_note_count
 1325REM TODONOW: WHAT ABOUT FIXED PALETTE WRT NEXT LINE?
 1330PROCset8(R_TABLE_DAY_NIGHT,0):PROCset8(R_TABLE_SCORE,0):PROCset8(R_TABLE_ROOM_TYPE,0):PROCset8(R_TABLE_LOGICAL_ROOM,9):PROCset_colours:PROCdraw_room(9):VDU17,3,31,5,28,241,240,235,236,236,32,32,233,242,243,31,4,30,237,235,243,32,244,238,32,236,244,233,240,244
 1331REPEATnote_pitch%=note_count%?(R%!R_TABLE_PITCH):note_duration%=note_count%?(R%!R_TABLE_DURATION):note_count%=note_count%+1:IFnote_pitch%=0:PROCdelay(220):GOTO1350
 1340SOUND1,1,note_pitch%,note_duration%:SOUND2,1,note_pitch%,note_duration%:SOUND3,1,note_pitch%,note_duration%:s$=INKEY$(14):IFnote_count%=63:PROCreset_note_count
 1350GCOL0,RND(3):PLOT69,634,934:PLOT69,648,934:UNTILs$<>""ORINKEY-1
 1351PROCset8(R_TABLE_ENERGY_MAJOR,16):PROCset8(R_TABLE_ENERGY_MINOR,10):PROCset8(R_TABLE_LOGICAL_ROOM,8):PROCset8(R_TABLE_DAY_NIGHT,0):w%=0:D%=576:C%=1120:K%=192:L%=108:PROCset8(R_TABLE_JUMPING,0):PROCset8(R_TABLE_DELTA_X,0):PROCset8(R_TABLE_LEE_DIRECTION,10):PROCset8(R_TABLE_FALLING_DELTA_X,0)
 1352VDU28,3,30,16,28,17,128,12,26:sound_and_light_show_chance%=40
 1360PROCreset_note_count:phys_room%=12:PROCset8(R_TABLE_GAME_ENDED,0):W%=SLOT_SUN_MOON:X%=IMAGE_SUN:CALLS%:CALLU%:PROCset8(R_TABLE_FULL_SPEED_JUMP_TIME_LIMIT,20):PROCset8(R_TABLE_MAX_JUMP_TIME,40):uw%=0:PROCset8(R_TABLE_SUN_MOON_DISABLED,0):PROCset8(R_TABLE_M,0):PROCset8(R_TABLE_ROOM_TYPE,3)
 1361VDU17,0,17,131:PRINTTAB(FNget8(R_TABLE_ENERGY_MAJOR),5)CHR$224:COLOUR128:FORn%=1TO5:n%?(R%!R_TABLE_ITEM_COLLECTED)=0:NEXT:won%=0:*FX210,0
 1370PROCstop_sound:IFs$="Q"ORs$="q":*FX210,1
 1380ENDPROC

 1390DEFPROCreset_note_count:note_count%=0:?(R%!R_TABLE_CURRENT_NOTE)=0:ENDPROC:REM TODO: THIS R% UPDATE IS PROBABLY NOT "THREAD SAFE" - BUT IT'S PROBABLY FINE NOW AS WE ONLY DO THIS WHEN BG PLAYBACK NOT HAPPENING

 1400DEFPROCpause:SOUND1,4,20,3:Y%=S_OP_REMOVE:W%=SLOT_SUN_MOON:CALLS%:VDU5:B$="WAITING":*FX15,1
 1401*FX13,5
 1402REMPROCset8(R_TABLE_SCORE,90):REM TODO HACK
 1403REPEAT:A$=INKEY$(0)
 1404IF ?&9FE<>0 AND (A$="W" OR A$="w"):PROCcheat_warp
 1405IF A$="8":PROCset8(R_TABLE_SCORE,80):FORn%=1TO4:n%?(R%!R_TABLE_ITEM_COLLECTED)=1:NEXT:REM TODO: TEMPORARY CHEAT, SO NOT OPTIONAL
 1406GCOL0,RND(3):FORmf%=92TO88STEP-4:MOVE416,mf%:PRINTB$:NEXT:UNTILA$="C"ORA$="c":FORmf%=92TO88STEP-4:MOVE416,mf%:GCOL0,0:PRINTB$:NEXT:VDU4:IFFNget8(R_TABLE_SUN_MOON_DISABLED)=0:Y%=S_OP_MOVE:CALLS%
 1410SOUND1,6,30,3:*FX15,1
 1420ENDPROC

 1429REM logical room number for each physical room
 1430DATA1,2,3,4,5,0,6,0,7,0,0,8,0,9,0,10,11,12,13,14
 1439REM room_type% values for each logical room
 1440DATA2,1,1,2,3,4,2,3,4,4,4,3,1,2
 1449REM colour sequence for day/night transition
 1450DATA7,6,3,5,1,2,4,0
 1451REM colours for logical room numbers TODO: put on a single line to save space
 1452DATA 7,3,5:REM 1/D
     DATA 3,1,7:REM 2/C
     DATA 1,2,6:REM 3/E
     DATA 4,3,7:REM 4/F
     DATA 2,3,4:REM 5/G TODO experimentally changed colours (Lum gargoyle foot problem)
     DATA 3,5,4:REM 6/B
     DATA 6,2,3:REM 7/H
     DATA 4,2,6:REM 8/A
     DATA 2,1,5:REM 9/N
     DATA 2,5,1:REM 10/J
     DATA 2,3,1:REM 11/I
     DATA 3,6,1:REM 12/K
     DATA 4,1,7:REM 13/L
     DATA 3,2,4:REM 14/M

 1469DEFPROCgame_over:W%=SLOT_SUN_MOON:Y%=S_OP_REMOVE:CALLS%:IFwon%=0:PROCset8(R_TABLE_SCORE,FNget8(R_TABLE_SCORE)-1):IFFNget8(R_TABLE_SCORE)=255:PROCset8(R_TABLE_SCORE,0)
 1470PROCstop_sound:pw%=1000:on%=2:IFwon%=1ORuw%=1:GOTO1490
 1480FORmrx%=1TO30:SOUND&12,6,mrx%+50,5:PROCdelay(pw%):pw%=pw%-25:W%=SLOT_LEE:Y%=on%:rr%=on%:on%=0:CALLS%:IFrr%=0:on%=2:NEXT ELSENEXT
 1485VDU19,0,0;0;:REM don't allow a lightning flash to persist
 1490IF?TWEAK_FIXED_PALETTE=0:VDU19,1,1;0;19,2,6;0;19,3,7;0;17,3
 1492s$=STR$(FNget8(R_TABLE_SCORE))+"%":PROCclear_room:PRINTTAB(5,16);:VDU232,233,234,235,32,32,238,239,235,240,5
 1494GCOL0,2:FORn%=416TO412STEP-4:MOVE544,n%:PRINTs$:NEXT:VDU4:PROCdelay(14000):COLOUR1:PRINTTAB(FNget8(R_TABLE_ENERGY_MAJOR),5)CHR$246:ENDPROC

 1500DEFPROCwin:won%=1:PROCstop_sound
 1501VDU19,0,0;0;:REM don't allow a lightning flash to persist
 1502IF?TWEAK_FIXED_PALETTE=0:VDU19,1,1;0;19,2,3;0;19,3,6;0;
 1503PROCclear_room:COLOUR2:PRINTTAB(6,16);:VDU232,233,234,235,32,235,242,245,5:GCOL0,1:a$=CHR$10+STRING$(12,CHR$8):FORn%=416TO412STEP-4:MOVE256,n%
 1510PRINT"INNER  WORLD"+a$+"COMING  SOON":NEXT:*FX15,1
 1520IFGET:VDU4:ENDPROC

 2000DEFPROCcheat_warp
 2002REM IF score%<80:score%=80:FORcheat%=1TO4:item_collected%(cheat%)=1:NEXT:REM TODO TEMP HACK
 2003VDU 4:COLOUR 3
 2004REM TODO: Use the double-printed font as in PROCwin? Standard mode 5 font is a bit ugly.
 2005PRINTTAB(2,17);" Warp to? (A-N) ";
 2006REPEAT
 2010*FX15,1
 2020key$=GET$
 2030UNTIL (key$>="A" AND key$<="N") OR (key$>="a" AND key$<="n")
 2050RESTORE 2500
 2060FOR n%=1 TO ASC(key$)AND&9F:READ phys_room%,C%,D%:NEXT
 2070REM Logical room 14 (Ed's room N) has some tricky behaviour; to get it right, we pretend we're passing through the warp from logical room 10 as in real gameplay.
 2200IF phys_room%<>14:PROCchange_room2 ELSE PROCset8(R_TABLE_LOGICAL_ROOM,10):PROCset8(R_TABLE_ROOM_TYPE,4-(FNget8(R_TABLE_SCORE)>70)):C%=1152:D%=484:PROCcheck_warps
 2205W%=SLOT_LEE:W%=SLOT_LEE:Y%=S_OP_SHOW:CALLS%:REM show player sprite
 2218VDU5:Y%=S_OP_MOVE:IF FNget8(R_TABLE_SUN_MOON_DISABLED)=0:W%=SLOT_SUN_MOON
 2220ENDPROC
 2221REM FWIW lower part of room A would be 1142,316
 2500DATA 12,1120,576,7,392,256,2,72,244,1,1194,672,3,24,636,4,24,636,5,24,444,9,984,704,17,280,700,16,1194,252,18,24,668,19,24,444,20,84,412,14,68,416

 3000DEFPROCshow_prisms
 3005LOCAL W%,X%,Y%
 3007REMFORn%=1TO4:item_collected%(n%)=1:NEXT:REM TODO HACK
 3010q%=0:FOR n%=1 TO 4:q%=q%+FNitem_collected(n%):NEXT
 3025W%=SLOT_COLLECTED_PRISM:Y%=S_OP_SHOW:X%=IMAGE_FLEECE_MACGUFFIN_PRISM
 3030IF q%<=2 THEN F%=124:p%=q% ELSE F%=144:p%=4
 3040FOR n%=1 TO p%
 3045E%=1112-(n% MOD 2)*1024
 3048GCOL 0,0:MOVE E%-8,F%-24:MOVE E%+72,F%-24:PLOT 85,E%+72,F%-68:MOVE E%-8,F%-68:PLOT 85,E%-8,F%-24:REM TODO: PROCsquare()?
 3050IF n%<=q%:CALLS%:CALLU%
 3065IF n%=2:F%=F%-40
 3080NEXT
 3090ENDPROC

 3500DEFPROCremove_lee_sprite
 3510W%=SLOT_LEE:Y%=S_OP_REMOVE:CALLS%:Y%=S_OP_MOVE
 3520ENDPROC

 5000DEF PROCset8(slot%,value%):?(R%!slot%)=value%:ENDPROC
 5010DEF FNget8(slot%):=?(R%!slot%)
 5020DEF FNget8signed(slot%):LOCALv%:v%=FNget8(slot%):IF v%>=128:=v%-256 ELSE =v%
 5030DEF FNitem_collected(n%):=n%?(R%!R_TABLE_ITEM_COLLECTED)

32000*TAPE
32010FORI%=PAGE TOTOP STEP4:!(I%-PAGE+&E00)=!I%:NEXT:*KEY0PAGE=&E00|MOLD|MDEL.0,0|MDEL.32000,32767|MRUN|F|M
32020VDU21:*FX15,1
32030*FX138,0,128
32040REM TODO: We could probably include a machine-code downloader in World1c, getting the speed benefit without needing to have machine code bundled onto the end of this otherwise pure BASIC code.
