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

   0IFPAGE>&E00:GOTO32000
   10Q%=R%!R_TABLE_Q:S%=R%!R_TABLE_S:T%=R%!R_TABLE_T:U%=R%!R_TABLE_U:V%=R%!R_TABLE_V
   20VDU17,128,17,3,12,26,19,3,7;0;:B$=STRING$(3,CHR$8)+CHR$10:A$=CHR$232+CHR$233+CHR$234+B$+CHR$235+":"+CHR$236+B$+CHR$243+CHR$236+CHR$244+B$+CHR$235+CHR$234+CHR$236:PROCclear_room:VDU5:GCOL0,3:MOVE532,528:PRINTA$:PROCdelay(18000):VDU4
   30REM If we hit an error other than Escape, let's make it obvious so it can be fixed.
   35REM TODO: Are we at risk of the problem where SRAM utilities corrupts a byte of memory around ~&1700 if an error occurs on a B?!
   40ONERROR:VDU4:IFERR=17:uw%=1:GOTO100 ELSE REPORT:PRINT;ERL:END
   50won%=0:score%=13:uw%=0:energy_major%=10
   60PROCone_off_init
   70PROCnew_game_init:*FX15,0
   80*FX200,0
   90PROCtitle_screen:PROCdraw_current_room:PROCplay:*FX13,5
   95IFw%=1:PROCo
  100*FX13,5
  105PROCgame_over:GOTO70

  110DEFPROCstop_sound:SOUND&11,0,0,0:ENDPROC

  200DEFPROCchange_lee_sprite
  202W%=SLOT_LEE:X%=FNget8(R_TABLE_LEE_DIRECTION)+2*FNget8(R_TABLE_DAY_NIGHT):CALLU%
  203Y%=S_OP_MOVE
  208ENDPROC

  210DEFPROCdraw_current_room:PROCclear_room
  220colour1%=RND(7):colour2%=RND(7):colour3%=RND(7):IFcolour1%=colour2%ORcolour1%=colour3%ORcolour2%=colour3%:GOTO220 ELSEIFscore%=100:colour2%=0:colour3%=4:colour1%=6
  230VDU19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:IFlogical_room%=10:sound_and_light_show_chance%=4 ELSEsound_and_light_show_chance%=40
  240IFlogical_room%<1ORlogical_room%>14:logical_room%=1:phys_room%=1:C%=128:PROCset8(R_TABLE_ROOM_TYPE,0):PROCdraw_room(1):COLOUR3:PRINTTAB(7,26);:VDU245,234:ENDPROC
  250PROCdraw_room(logical_room%):ENDPROC

  256PROCpause:CALLR%!R_TABLE_PLAY_320:GOTOM%:REM TODO TEMP - MAYBE?
  257PROCchange_room:PROCreset_note_count:IFFNget8(R_TABLE_GAME_ENDED)=0:CALLR%!R_TABLE_PLAY_270:GOTOM% ELSE ENDPROC
  258ENDPROC:REM TODO TEMP - MAYBE?
  259ON JUNK GOTO 255,360,256,257,258:REM TODO TEMP - SO ABE PACK LEAVES THESE LINES ALONE

  260DEFPROCplay
  270CALLR%!R_TABLE_PLAY_270:GOTOM%
  360W%=SLOT_LEE:Y%=8:CALLQ%:IFX%<>0ORFNget8signed(R_TABLE_FALLING_TIME)>12:PROCupdate_energy_and_items
  370IFsun_moon_disabled%=0:m%=m%+1:IFm%=11:PROCadvance_sun_moon:m%=0 ELSEIFlogical_room%=1ORlogical_room%=13ORlogical_room%=5ORlogical_room%=10:PROCcheck_warps:CALLR%!R_TABLE_PLAY_270:GOTOM%
  380CALLR%!R_TABLE_PLAY_280:GOTOM%

  390DEFPROCsound_and_light_show:PROCstop_sound:VDU19,0,7;0;19,1,0;0;19,2,0;0;19,3,0;0;:SOUND&10,-13,5,6:SOUND0,-10,5,6:SOUND0,-7,6,10:PROCdelay(250):VDU19,0,0;0;19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:ENDPROC

  400DEFPROCshow_using_slot_misc(text_x%,text_y%,image%):M%=(text_x%*64)-4:N%=(1024-(32*text_y%))+28:X%=image%:W%=SLOT_MISC:IFimage%=20:M%=M%+4
  410CALLS%:CALLU%:ENDPROC

  510DEFPROCadvance_sun_moon:W%=SLOT_SUN_MOON:Z%=DELTA_STEP_RIGHT:CALLT%:IFK%=1016:PROCtoggle_day_night
  515REM TODO: Does the next line do anything useful?
  520IFlogical_room%=5:W%=8:Z%=DELTA_STEP_RIGHT:CALLT%
  530ENDPROC

  540DEFPROCtoggle_day_night:*FX13,5
  545RESTORE1450:FORn%=1TO140STEP5:READo%:SOUND1,3,n%,2:SOUND2,2,n%+10,3:VDU19,1,o%;0;19,2,o%-1;0;19,3,o%-2;0;:IFo%=0:RESTORE1450
  550NEXT:PROCreset_note_count:VDU19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:PROCstop_sound:W%=SLOT_SUN_MOON:Y%=S_OP_REMOVE:CALLS%:K%=192
  551IFFNget8(R_TABLE_DAY_NIGHT)=0:PROCset8(R_TABLE_DAY_NIGHT,1):PROCchange_lee_sprite:X%=IMAGE_MOON:W%=SLOT_SUN_MOON:CALLS%:CALLU%:W%=SLOT_LEE:PROCset8(R_TABLE_FULL_SPEED_JUMP_TIME_LIMIT,45):PROCset8(R_TABLE_MAX_JUMP_TIME,90):PROChide_fleece:ENDPROC
  560PROCset8(R_TABLE_FULL_SPEED_JUMP_TIME_LIMIT,20):PROCset8(R_TABLE_MAX_JUMP_TIME,40):PROCset8(R_TABLE_DAY_NIGHT,0):PROCchange_lee_sprite:X%=IMAGE_SUN:W%=SLOT_SUN_MOON:CALLS%:CALLU%:W%=SLOT_LEE:PROCrestore_fleece:ENDPROC

  570DEFPROCdelay(n1%):FORn%=1TOn1%:NEXT:ENDPROC

  579REM TODO: Bit misnamed as this also handles collecting the fleece
  580DEFPROCcheck_warps
  581REM If player is in room 1 (Ed's room D) and at the far left of the screen,
  582REM warp to room 9 (Ed's room A).
  583IFlogical_room%=1ANDC%<68:phys_room%=12:C%=1142:D%=316:Y%=S_OP_REMOVE:W%=SLOT_ENEMY:CALLS%:PROCremove_lee_sprite:logical_room%=8:PROCdraw_current_room:PROCwarp_effect:ENDPROC
  585REM If player is in room 10 (Ed's room J) and in the top half of the screen,
  586REM warp to room 9 (Ed's room N) - the fleece room.
  590IFlogical_room%=10ANDC%>=1152ANDD%>480:phys_room%=14:logical_room%=9:C%=68:D%=416:Y%=S_OP_REMOVE:W%=SLOT_ENEMY:CALLS%:PROCremove_lee_sprite:PROCdraw_current_room:PROCwarp_effect:PROCset8(R_TABLE_ROOM_TYPE,2):ENDPROC
  595REM If player is in room 13 at a specific point on the right edge, warp to
  596REM room 7 (Ed's room H).
  600IFlogical_room%=13ANDC%>1150AND(D%=288ORD%=284):phys_room%=9:C%=1148:D%=420:Y%=S_OP_REMOVE:W%=SLOT_ENEMY:CALLS%:PROCremove_lee_sprite:logical_room%=7:PROCdraw_current_room:PROCwarp_effect:ENDPROC
  605REM If player is in room 5 (Ed's room G), has a score of 90% and it's daytime,
  606REM show a lightning flash effect. If the player has collided with SLOT_MISC, it's the fleece; collect it.
  610IFlogical_room%=5ANDscore%=90ANDFNget8(R_TABLE_DAY_NIGHT)=0:VDU19,0,7;0;19,1,0;0;19,0,0;0;19,1,3;0;:IFX%=SLOT_MISC:PROCcollect_fleece
  620ENDPROC

  630DEFPROCcollect_fleece:*FX13,5
  635Y%=S_OP_REMOVE:W%=SLOT_SUN_MOON:CALLS%:W%=SLOT_MISC:CALLS%:RESTORE1450:score%=100:sun_moon_disabled%=1:PROCremove_lee_sprite:FORn%=10TO100STEP5:FORnm%=110TO200STEPn%:READok%:VDU19,1,ok%;0;19,2,ok%;0;19,3,ok%;0;:IFok%=0:RESTORE1450
  640SOUND1,4,n%+nm%,2:SOUND2,12,n%+nm%,3:NEXT,:PROCreset_note_count:VDU19,3,4;0;19,2,0;0;19,1,6;0;17,131,17,2:colour1%=6:colour2%=0:colour3%=4:PRINTTAB(9,14)STRING$(4,CHR$227):COLOUR128:CALLV%:ENDPROC

  700DEFPROCroom_type2:axm%=3:IFI%>C%:axm%=-3
  710aym%=2:IFJ%>D%:aym%=-4
  720I%=I%+axm%:J%=J%+aym%:CALLS%:ENDPROC

  799REM TODO: Moving this towards end of code would slightly speed up line number searching for GOTOs
  800DEFPROCnew_game_init:CALLV%:PROCclear_room:VDU28,4,30,15,28,17,128,12,26
  801FORn%=28TO30:FORwn%=0TO2:VDU31,wn%,n%,(229+wn%),31,(wn%+17),n%,(229+wn%):NEXT,:ENDPROC

  815REM TODO: Moving this towards end of code would slightly speed up line number searching for GOTOs
  820DEFPROCone_off_init:CALLV%:DIMad%(4),ed%(6),item_collected%(5):ad%(1)=3:ad%(2)=9:ad%(3)=7:ad%(4)=1:ed%(1)=3:ed%(2)=6:ed%(3)=9:ed%(4)=7:ed%(5)=4:ed%(6)=1:VDU17,3,17,128,28,0,30,19,28,12,26:ENDPROC

  840DEFPROCclear_room
  843Y%=S_OP_REMOVE:W%=SLOT_MISC:CALLS%:Y%=S_OP_MOVE
  847VDU28,0,26,19,9,17,128,12,26:ENDPROC

  850DEFPROCdraw_room(b1%):!&70=b1%*45:PRINTTAB(0,9);:CALLR%!R_TABLE_DRAW_ROOM
  880IFFNget8(R_TABLE_ROOM_TYPE)=2:I%=608:J%=672:W%=SLOT_ENEMY:Y%=S_OP_MOVE:CALLS%:GOTO900
  890PROCset8(R_TABLE_DB,6):IFFNget8(R_TABLE_ROOM_TYPE)>0:I%=291:J%=480:W%=SLOT_ENEMY:Y%=S_OP_MOVE:CALLS%:IFFNget8(R_TABLE_ROOM_TYPE)=1:X%=IMAGE_HARPY_RIGHT:CALLU%
  900IFlogical_room%=2ANDscore%=80:PROCset8(R_TABLE_ROOM_TYPE,3):X%=IMAGE_VEIL2:CALLU%:GOTO960
  910IFlogical_room%=5ANDscore%=90:PROCset8(R_TABLE_ROOM_TYPE,0):Y%=S_OP_REMOVE:CALLS%:Y%=S_OP_MOVE
  920IFFNget8(R_TABLE_ROOM_TYPE)=2:X%=IMAGE_WINGED_CREATURE:CALLU%
  930IFFNget8(R_TABLE_ROOM_TYPE)=3:X%=IMAGE_ROBOT:CALLU%
  940IFFNget8(R_TABLE_ROOM_TYPE)=4:X%=IMAGE_EYE:CALLU%
  950IFFNget8(R_TABLE_ROOM_TYPE)=5:Y%=S_OP_REMOVE:CALLS%:I%=640:J%=316:Y%=S_OP_MOVE:CALLS%:ed%=6:IFscore%>70ANDscore%<100:X%=IMAGE_VEIL:CALLU% ELSEIFFNget8(R_TABLE_ROOM_TYPE)=5ANDscore%=100:X%=IMAGE_FINAL_GUARDIAN:CALLU%
  960PROCset8(R_TABLE_AK,0):PROCset8(R_TABLE_AH,1):W%=2:Y%=S_OP_SHOW:IFlogical_room%=9:W%=SLOT_MISC:M%=1035:N%=692:CALLS%:X%=IMAGE_FLEECE_MACGUFFIN_PRISM:CALLU%:IFitem_collected%(5)=0:PROCshow_using_slot_misc(2,14,IMAGE_HEALTH)
  970IFlogical_room%=6:PROCshow_using_slot_misc(18,15,IMAGE_WALL_ENEMY_RIGHT):PROCshow_using_slot_misc(18,19,IMAGE_WALL_ENEMY_RIGHT)
  980IFlogical_room%=10ANDscore%>70:PRINTTAB(10,26)"  "
  990IFlogical_room%=5ANDscore%>80:PRINTTAB(9,14)"  "
 1000IFlogical_room%=13ANDscore%=60:PRINTTAB(19,17)STRING$(3," "+CHR$8+CHR$10)
 1010IFlogical_room%=1:PROCshow_using_slot_misc(9,12,IMAGE_STATUE):IFitem_collected%(1)=0:PROCshow_using_slot_misc(2,12,IMAGE_FLEECE_MACGUFFIN_PRISM)
 1020IFlogical_room%=7:PROCshow_using_slot_misc(6,21,IMAGE_STATUE):IFitem_collected%(2)=0:PROCshow_using_slot_misc(2,11,IMAGE_FLEECE_MACGUFFIN_PRISM)
 1030IFlogical_room%=2:PROCshow_using_slot_misc(1,23,IMAGE_WALL_ENEMY_LEFT)
 1040IFlogical_room%=8:PROCshow_using_slot_misc(11,23,IMAGE_STATUE):PROCshow_using_slot_misc(9,21,IMAGE_STATUE):PROCshow_using_slot_misc(13,24,IMAGE_STATUE)
 1050IFlogical_room%=14:PROCshow_using_slot_misc(8,20,IMAGE_WALL_ENEMY_RIGHT):PROCshow_using_slot_misc(11,20,IMAGE_WALL_ENEMY_LEFT):VDU17,131,17,2:PRINTTAB(0,26)STRING$(20,CHR$231):COLOUR128:IFitem_collected%(4)=0:PROCshow_using_slot_misc(12,25,IMAGE_FLEECE_MACGUFFIN_PRISM)
 1060IFlogical_room%=12:PROCshow_using_slot_misc(1,15,IMAGE_WALL_ENEMY_LEFT):PROCshow_using_slot_misc(1,18,IMAGE_WALL_ENEMY_LEFT):PROCshow_using_slot_misc(1,21,IMAGE_WALL_ENEMY_LEFT)
 1070IFlogical_room%=13:PROCshow_using_slot_misc(7,21,IMAGE_STATUE):PROCshow_using_slot_misc(12,21,IMAGE_STATUE)
 1080IFlogical_room%=5ANDscore%=90:M%=608:N%=512:W%=SLOT_MISC:CALLS%:X%=IMAGE_FLEECE_MACGUFFIN_PRISM:CALLU%:IFFNget8(R_TABLE_DAY_NIGHT)=1:Y%=S_OP_REMOVE:CALLS%
 1090IFlogical_room%=5ANDitem_collected%(3)=0:PROCshow_using_slot_misc(18,24,IMAGE_FLEECE_MACGUFFIN_PRISM)
 1100ENDPROC

 1110DEFPROCchange_room:IFlogical_room%=10ANDD%<228:PROCwin:PROCset8(R_TABLE_GAME_ENDED,1):ENDPROC
 1121IFD%>730:D%=224:phys_room%=phys_room%-5 ELSEIFD%<228:D%=728:phys_room%=phys_room%+5 ELSEIFC%>1194:C%=24:phys_room%=phys_room%+1 ELSEIFC%<24:C%=1194:phys_room%=phys_room%-1
 1122PROCchange_room2:ENDPROC
 1124DEFPROCchange_room2
 1127W%=SLOT_ENEMY:Y%=S_OP_REMOVE:CALLS%:W%=SLOT_LEE:CALLS%
 1130RESTORE1430:FORn%=1TOphys_room%:READlogical_room%:NEXT:RESTORE1440:FORn%=1TOlogical_room%:READroom_type_tmp%:NEXT:PROCset8(R_TABLE_ROOM_TYPE,room_type_tmp%):IFscore%=100:PROCset8(R_TABLE_ROOM_TYPE,2)
 1140IFlogical_room%=10ANDscore%>70:PROCset8(R_TABLE_ROOM_TYPE,5)
 1150PROCdraw_current_room:ENDPROC

 1160DEFPROCupdate_energy_and_items:IFX%=SLOT_ENEMY:GOTO1210 ELSEIFX%=SLOT_ENEMYOR(X%=SLOT_MISCANDlogical_room%<>1ANDlogical_room%<>5ANDlogical_room%<>9ANDlogical_room%<>14ANDlogical_room%<>7):GOTO1210
 1170IFFNget8signed(R_TABLE_FALLING_TIME)>1:GOTO1210 ELSEIFlogical_room%=1:this_item%=1 ELSEIFlogical_room%=7:this_item%=2 ELSEIFlogical_room%=5:this_item%=3 ELSEIFlogical_room%=14:this_item%=4 ELSEIFlogical_room%=9:this_item%=5
 1180IFitem_collected%(this_item%)=1:GOTO1220 ELSEitem_collected%(this_item%)=1:IFthis_item%<5:PROCshow_prisms
 1182W%=SLOT_MISC:Y%=S_OP_REMOVE:CALLS%:REM remove the collected object from the room
 1190PROCstop_sound:PROCdelay(100):SOUND1,6,20,4:VDU19,0,7;0;:score%=score%+20:energy_minor%=50:PROCdelay(150):VDU19,0,0;0;
 1191IFlogical_room%=9:score%=score%-10:COLOUR1:PRINTTAB(energy_major%,5)CHR$246:energy_major%=16:VDU17,0,17,131:PRINTTAB(16,5)CHR$224:VDU17,128
 1200ENDPROC
 1210IFFNget8signed(R_TABLE_FALLING_TIME)>1:A%=11:B%=energy_minor%:E%=2:CALLR%!R_TABLE_SOUND_NONBLOCKING:GOTO1230
 1220IFFNget8(R_TABLE_ROOM_TYPE)=2ANDFNget8(R_TABLE_DAY_NIGHT)=1ANDX%=SLOT_ENEMY:ENDPROC ELSEPROCstop_sound:IFFNget8(R_TABLE_ROOM_TYPE)=2:A%=9:B%=energy_minor%:E%=2:CALLR%!R_TABLE_SOUND_NONBLOCKING ELSEIFX%=SLOT_MISC:A%=8:B%=energy_minor%:E%=4:CALLR%!R_TABLE_SOUND_NONBLOCKING ELSEA%=12:B%=energy_minor%:E%=5:CALLR%!R_TABLE_SOUND_NONBLOCKING
 1230energy_minor%=energy_minor%-1
 1231IFenergy_minor%=0:energy_minor%=25:IF?&9FF<>1:energy_major%=energy_major%-1:VDU17,0,17,131:PRINTTAB(energy_major%,5)CHR$224:VDU17,128,17,1:PRINTTAB(energy_major%+1,5)CHR$246:IFenergy_major%=3:PROCset8(R_TABLE_GAME_ENDED,1)
 1240ENDPROC

 1250DEFPROChide_fleece:IFlogical_room%<>5:ENDPROC
 1260IFscore%<90:ENDPROC ELSEW%=SLOT_MISC:Y%=S_OP_REMOVE:CALLS%:ENDPROC

 1270DEFPROCrestore_fleece:IFlogical_room%<>5:ENDPROC
 1280IFscore%<90:ENDPROC ELSEW%=SLOT_MISC:X%=IMAGE_FLEECE_MACGUFFIN_PRISM:CALLS%:CALLU%:ENDPROC

 1290DEFPROCwarp_effect:*FX13,5
 1295VDU19,1,7;0;19,2,7;0;19,3,7;0;:SOUND1,6,60,4:PROCdelay(120):VDU19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:ENDPROC

 1320DEFPROCtitle_screen:colour1%=7:colour2%=6:colour3%=1:PROCreset_note_count
 1330PROCset8(R_TABLE_DAY_NIGHT,0):score%=0:PROCset8(R_TABLE_ROOM_TYPE,0):logical_room%=9:VDU19,3,1;0;19,2,6;0;19,1,7;0;:PROCdraw_room(9):VDU17,3,31,5,28,241,240,235,236,236,32,32,233,242,243,31,4,30,237,235,243,32,244,238,32,236,244,233,240,244
 1331REPEATnote_pitch%=note_count%?(R%!R_TABLE_PITCH):note_duration%=note_count%?(R%!R_TABLE_DURATION):note_count%=note_count%+1:IFnote_pitch%=0:PROCdelay(220):GOTO1350
 1340SOUND1,1,note_pitch%,note_duration%:SOUND2,1,note_pitch%,note_duration%:SOUND3,1,note_pitch%,note_duration%:s$=INKEY$(14):IFnote_count%=63:PROCreset_note_count
 1350GCOL0,RND(3):PLOT69,634,934:PLOT69,648,934:UNTILs$<>""ORINKEY-1
 1351energy_major%=16:energy_minor%=10:logical_room%=8:PROCset8(R_TABLE_DAY_NIGHT,0):w%=0:D%=576:C%=1120:K%=192:L%=108:PROCset8(R_TABLE_JUMPING,0):delta_x%=0:sd%=10:PROCset8(R_TABLE_LEE_DIRECTION,10):PROCset8(R_TABLE_FALLING_DELTA_X,0)
 1352VDU28,3,30,16,28,17,128,12,26:sound_and_light_show_chance%=40
 1360PROCreset_note_count:phys_room%=12:PROCset8(R_TABLE_GAME_ENDED,0):W%=SLOT_SUN_MOON:X%=IMAGE_SUN:CALLS%:CALLU%:PROCset8(R_TABLE_FULL_SPEED_JUMP_TIME_LIMIT,20):PROCset8(R_TABLE_MAX_JUMP_TIME,40):uw%=0:sun_moon_disabled%=0:m%=0:PROCset8(R_TABLE_ROOM_TYPE,3)
 1361VDU17,0,17,131:PRINTTAB(energy_major%,5)CHR$224:COLOUR128:FORn%=1TO5:item_collected%(n%)=0:NEXT:won%=0:*FX210,0
 1370PROCstop_sound:IFs$="Q"ORs$="q":*FX210,1
 1380ENDPROC

 1390DEFPROCreset_note_count:note_count%=0:?(R%!R_TABLE_CURRENT_NOTE)=0:ENDPROC:REM TODO: THIS R% UPDATE IS PROBABLY NOT "THREAD SAFE"

 1400DEFPROCpause:SOUND1,4,20,3:Y%=S_OP_REMOVE:W%=SLOT_SUN_MOON:CALLS%:VDU5:B$="WAITING":*FX15,1
 1401*FX13,5
 1402REPEAT:A$=INKEY$(0)
 1403IF ?&9FE<>0 AND (A$="W" OR A$="w"):PROCcheat_warp
 1405GCOL0,RND(3):FORmf%=92TO88STEP-4:MOVE416,mf%:PRINTB$:NEXT:UNTILA$="C"ORA$="c":FORmf%=92TO88STEP-4:MOVE416,mf%:GCOL0,0:PRINTB$:NEXT:VDU4:IFsun_moon_disabled%=0:Y%=S_OP_MOVE:CALLS%
 1410SOUND1,6,30,3:*FX15,1
 1420ENDPROC

 1429REM logical room number for each physical room
 1430DATA1,2,3,4,5,0,6,0,7,0,0,8,0,9,0,10,11,12,13,14
 1439REM room_type% values for each logical room
 1440DATA2,1,1,2,3,4,2,3,4,4,4,3,1,2
 1449REM colour sequence for day/night transition
 1450DATA7,6,3,5,1,2,4,0

 1460DEFPROCgame_over:W%=SLOT_SUN_MOON:Y%=S_OP_REMOVE:CALLS%:IFwon%=0:score%=score%-1:IFscore%=-1:score%=0
 1470PROCstop_sound:pw%=1000:on%=2:IFwon%=1ORuw%=1:GOTO1490
 1480FORmrx%=1TO30:SOUND&12,6,mrx%+50,5:PROCdelay(pw%):pw%=pw%-25:W%=SLOT_LEE:Y%=on%:rr%=on%:on%=0:CALLS%:IFrr%=0:on%=2:NEXT ELSENEXT
 1490VDU19,1,1;0;19,2,6;0;19,3,7;0;17,3:s$=STR$score%+"%":PROCclear_room:PRINTTAB(5,16);:VDU232,233,234,235,32,32,238,239,235,240,5
 1491GCOL0,2:FORn%=416TO412STEP-4:MOVE544,n%:PRINTs$:NEXT:VDU4:PROCdelay(14000):COLOUR1:PRINTTAB(energy_major%,5)CHR$246:ENDPROC

 1500DEFPROCwin:won%=1:PROCstop_sound:VDU19,1,1;0;19,2,3;0;19,3,6;0;:PROCclear_room:COLOUR2:PRINTTAB(6,16);:VDU232,233,234,235,32,235,242,245,5:GCOL0,1:a$=CHR$10+STRING$(12,CHR$8):FORn%=416TO412STEP-4:MOVE256,n%
 1510PRINT"INNER  WORLD"+a$+"COMING  SOON":NEXT:*FX15,1
 1520IFGET:VDU4:ENDPROC

 2000DEFPROCcheat_warp
 2002REM IF score%<80:score%=80:FORcheat%=1TO4:item_collected%(cheat%)=1:NEXT:REM TODO TEMP HACK
 2003VDU 4:COLOUR 3
 2005PRINTTAB(2,17);" Warp to? (A-N) ";
 2006REPEAT
 2010*FX15,1
 2020key$=GET$
 2030UNTIL (key$>="A" AND key$<="N") OR (key$>="a" AND key$<="n")
 2050RESTORE 2500
 2060FOR n%=1 TO ASC(key$)AND&9F:READ phys_room%,C%,D%:NEXT
 2070REM Logical room 14 (Ed's room N) has some tricky behaviour; to get it right, we pretend we're passing through the warp from logical room 10 as in real gameplay.
 2200IF phys_room%<>14:PROCchange_room2 ELSE logical_room%=10:PROCset8(R_TABLE_ROOM_TYPE,4-(score%>70)):C%=1152:D%=484:PROCcheck_warps
 2205W%=SLOT_LEE:W%=SLOT_LEE:Y%=S_OP_SHOW:CALLS%:REM show player sprite
 2210PROCreset_note_count:REM Must do this because we moved DATA pointer
 2218VDU5:Y%=S_OP_MOVE:IF sun_moon_disabled%=0:W%=SLOT_SUN_MOON
 2220ENDPROC
 2221REM FWIW lower part of room A would be 1142,316
 2500DATA 12,1120,576,7,392,256,2,72,244,1,1194,672,3,24,636,4,24,636,5,24,444,9,984,704,17,280,700,16,1194,252,18,24,668,19,24,444,20,84,412,14,68,416

 3000DEFPROCshow_prisms
 3005LOCAL W%,X%,Y%
 3007REMFORn%=1TO4:item_collected%(n%)=1:NEXT:REM TODO HACK
 3010q%=0:FOR n%=1 TO 4:q%=q%+item_collected%(n%):NEXT
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

 4000DEFFNjump_terminated_falling_time
 4010REM Credit the player with any unused "descending" time from this jump; this wouldn't count as time towards the falling damage threshold if they hadn't collided with something above them, so it seems fair to give them the same here.
 4020PROCset8(R_TABLE_JUMP_TIME,FNget8(R_TABLE_JUMP_TIME)+2):REM this would have happened in this game cycle before testing jump_time% if we hadn't collided with something
 4030IF FNget8(R_TABLE_JUMP_TIME)<FNget8(R_TABLE_FULL_SPEED_JUMP_TIME_LIMIT):PROCset8(R_TABLE_JUMP_TIME,FNget8(R_TABLE_FULL_SPEED_JUMP_TIME_LIMIT)):REM don't credit any remaining "ascending" jump time
 4040=(FNget8(R_TABLE_JUMP_TIME)-FNget8(R_TABLE_MAX_JUMP_TIME))DIV2:REM DIV 2 because jump_time% counts up by two every game cycle

 5000DEF PROCset8(slot%,value%):?(R%!slot%)=value%:ENDPROC
 5010DEF FNget8(slot%):=?(R%!slot%)
 5020DEF FNget8signed(slot%):LOCALv%:v%=FNget8(slot%):IF v%>=128:=v%-256 ELSE =v%

32000*TAPE
32010FORI%=PAGE TOTOP STEP4:!(I%-PAGE+&E00)=!I%:NEXT:*KEY0PAGE=&E00|MOLD|MDEL.0,0|MDEL.32000,32767|MRUN|F|M
32020VDU21:*FX15,1
32030*FX138,0,128
