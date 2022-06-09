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

   0IFPAGE>&E00:GOTO32000
   20VDU17,128,17,3,12,26,19,3,7;0;:B$=STRING$(3,CHR$8)+CHR$10:A$=CHR$232+CHR$233+CHR$234+B$+CHR$235+":"+CHR$236+B$+CHR$243+CHR$236+CHR$244+B$+CHR$235+CHR$234+CHR$236:PROCclear_room:VDU5:GCOL0,3:MOVE532,528:PRINTA$:PROCdelay(18000):VDU4
   30REM If we hit an error other than Escape, let's make it obvious so it can be fixed.
   35REM TODO: Are we at risk of the problem where SRAM utilities corrupts a byte of memory around ~&1700 if an error occurs on a B?!
   40ONERROR:VDU4:IFERR=17:uw%=1:GOTO100 ELSE REPORT:PRINT;ERL:END
   50won%=0:score%=13:uw%=0:energy_major%=10
   60PROCone_off_init
   70PROCnew_game_init:*FX15,0
   80*FX200,0
   90PROCtitle_screen:PROCdraw_current_room:PROCplay:IFw%=1:PROCo
  100PROCgame_over:GOTO70

  110DEFPROCstop_sound:SOUND&11,0,0,0:ENDPROC

  115REM Note for the following procedures that different sprite numbers have their position
  116REM managed via different resident integer variables pairs.

  119REM TODO: Following is WIP simplification and does some "redundant" stuff for now
  120DEFPROCset_lee_sprite_from_lee_xy_os
  122lee_sprite_num%=10:C%=lee_x_os%:D%=lee_y_os%:W%=lee_sprite_num%
  123ENDPROC

  140DEFPROCset_lee_xy_os_from_lee_sprite
  150lee_x_os%=C%:lee_y_os%=D%:lee_sprite_num%=10:ENDPROC

  200DEFPROClee_sprite_reset
  202W%=SLOT_LEE:X%=lee_direction%+2*day_night%:CALLU%
  203Y%=S_OP_MOVE
  208ENDPROC

  210DEFPROCdraw_current_room:PROCclear_room
  220colour1%=RND(7):colour2%=RND(7):colour3%=RND(7):IFcolour1%=colour2%ORcolour1%=colour3%ORcolour2%=colour3%:GOTO220 ELSEIFscore%=100:colour2%=0:colour3%=4:colour1%=6
  230VDU19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:IFlogical_room%=10:sound_and_light_show_chance%=4 ELSEsound_and_light_show_chance%=40
  240IFlogical_room%<1ORlogical_room%>14:logical_room%=1:phys_room%=1:lee_x_os%=128:room_type%=0:PROCdraw_room(1):COLOUR3:PRINTTAB(7,26);:VDU245,234:ENDPROC
  250PROCdraw_room(logical_room%):ENDPROC

  260DEFPROCplay
  270GCOL0,0:Y%=S_OP_MOVE:PROCset_lee_sprite_from_lee_xy_os
  280IFscore%=100ANDRND(sound_and_light_show_chance%)=1:PROCsound_and_light_show
  281REM TODO: I *think* that falling_delta_x% is used to give Lee a left/right drift
  282REM when he's falling *after* a jump has finished in mid-air, and that all other
  283REM falls are straight down.
  290PROCset_lee_xy_os_from_lee_sprite:W%=lee_sprite_num%
  291IFjumping%=1:PROCjump:GOTO330 ELSEdelta_x%=0:IFPOINT(lee_x_os%+4,lee_y_os%-66)=0ANDPOINT(lee_x_os%+60,lee_y_os%-66)=0:lee_x_os%=lee_x_os%+falling_delta_x%:lee_y_os%=lee_y_os%-8:falling_time%=falling_time%+1:GOTO330
  300falling_delta_x%=0:IFINKEY-98PROCmove_left ELSEIFINKEY-67PROCmove_right
  310falling_time%=0:IFINKEY-1jumping%=1:jump_time%=0:jump_delta_y%=8:falling_delta_x%=delta_x%:SOUND1,11,lee_y_os%,12 ELSEIFINKEY-56PROCpause
  320sf%=lee_y_os%-66:IFscore%=100ANDPOINT(lee_x_os%,sf%)=3ANDlee_y_os%>260:MOVElee_x_os%,sf%+26:VDU5,249,4
  330PROCset_lee_sprite_from_lee_xy_os:CALLS%
  335IFlee_x_os%<24ORlee_x_os%>1194ORlee_y_os%>730ORlee_y_os%<228PROCchange_room:PROCreset_note_count:IFgame_ended%=0GOTO270 ELSEIFgame_ended%=1:ENDPROC
  340W%=SLOT_ENEMY:IFroom_type%=1:PROCroom_type1 ELSEIFroom_type%=2:PROCroom_type2 ELSEIFroom_type%=3:PROCroom_type3 ELSEIFroom_type%=4:PROCroom_type4 ELSEIFroom_type%=5:PROCroom_type5
  350cr%=cr%+1:IFcr%=4:cr%=0:READnote_pitch%,note_duration%:SOUND2,-5,note_pitch%,note_duration%:SOUND3,-5,note_pitch%,note_duration%:note_count%=note_count%+1:IFnote_count%=70:PROCreset_note_count
  360W%=lee_sprite_num%:Y%=8:CALLQ%:IFX%<>0ORfalling_time%>12:PROCupdate_energy_and_items
  370IFsun_moon_disabled%=0:m%=m%+1:IFm%=11:PROCadvance_sun_moon:m%=0 ELSEIFlogical_room%=1ORlogical_room%=13ORlogical_room%=5ORlogical_room%=10:PROCcheck_warps:GOTO270
  380GOTO280

  390DEFPROCsound_and_light_show:PROCstop_sound:VDU19,0,7;0;19,1,0;0;19,2,0;0;19,3,0;0;:SOUND&10,-13,5,6:SOUND0,-10,5,6:SOUND0,-7,6,10:PROCdelay(250):VDU19,0,0;0;19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:ENDPROC

  400DEFPROCupdate_sprite_slot_7_and_show(text_x%,text_y%,ch%):M%=(text_x%*64)-4:N%=(1024-(32*text_y%))+28:X%=ch%:W%=SLOT_MISC:IFch%=20:M%=M%+4
  410CALLS%:CALLU%:ENDPROC

  420DEFPROCmove_left:IFPOINT(lee_x_os%-4,lee_y_os%-8)<>0:ENDPROC
  430IFlee_direction%=IMAGE_HUMAN_RIGHT:lee_direction%=IMAGE_HUMAN_LEFT:PROClee_sprite_reset:W%=SLOT_LEE
  440delta_x%=-8:lee_x_os%=lee_x_os%-8:ENDPROC

  450DEFPROCmove_right:IFPOINT(lee_x_os%+64,lee_y_os%-8)<>0:ENDPROC
  460IFlee_direction%=IMAGE_HUMAN_LEFT:lee_direction%=IMAGE_HUMAN_RIGHT:PROClee_sprite_reset:W%=SLOT_LEE
  470delta_x%=8:lee_x_os%=lee_x_os%+8:ENDPROC

  480DEFPROCjump:IFPOINT(lee_x_os%+8,lee_y_os%+4)<>0ORPOINT(lee_x_os%+56,lee_y_os%+4)<>0:jumping%=0:PROCstop_sound:ENDPROC
  490jump_time%=jump_time%+1:lee_y_os%=lee_y_os%+jump_delta_y%:lee_x_os%=lee_x_os%+delta_x%:jump_time%=jump_time%+1
  491IFjump_time%>full_speed_jump_time_limit%:jump_delta_y%=-4:IFjump_time%=max_jump_time%ORPOINT(lee_x_os%+32,lee_y_os%-66)<>0:jumping%=0:PROCstop_sound:ENDPROC
  500ENDPROC

  510DEFPROCadvance_sun_moon:W%=SLOT_SUN_MOON:Z%=DELTA_STEP_RIGHT:CALLT%:IFK%=1016:PROCtoggle_day_night
  515REM TODO: Does the next line do anything useful?
  520IFlogical_room%=5:W%=8:Z%=DELTA_STEP_RIGHT:CALLT%
  530ENDPROC

  540DEFPROCtoggle_day_night:RESTORE1450:FORn%=1TO140STEP5:READo%:SOUND1,3,n%,2:SOUND2,2,n%+10,3:VDU19,1,o%;0;19,2,o%-1;0;19,3,o%-2;0;:IFo%=0:RESTORE1450
  550NEXT:PROCreset_note_count:VDU19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:PROCstop_sound:W%=SLOT_SUN_MOON:Y%=S_OP_REMOVE:CALLS%:K%=192
  551IFday_night%=0:day_night%=1:PROClee_sprite_reset:X%=IMAGE_MOON:W%=SLOT_SUN_MOON:CALLS%:CALLU%:PROCset_lee_sprite_from_lee_xy_os:full_speed_jump_time_limit%=45:max_jump_time%=90:PROChide_fleece:ENDPROC
  560full_speed_jump_time_limit%=20:max_jump_time%=40:day_night%=0:PROClee_sprite_reset:X%=IMAGE_SUN:W%=SLOT_SUN_MOON:CALLS%:CALLU%:PROCset_lee_sprite_from_lee_xy_os:PROCrestore_fleece:ENDPROC

  570DEFPROCdelay(n1%):FORn%=1TOn1%:NEXT:ENDPROC

  580DEFPROCcheck_warps
  581REM If player is in room 1 (Ed's room D) and at the far left of the screen,
  582REM warp to room 9 (Ed's room A).
  583IFlogical_room%=1ANDlee_x_os%<68:phys_room%=12:lee_x_os%=1142:lee_y_os%=316:Y%=S_OP_REMOVE:W%=SLOT_ENEMY:CALLS%:PROClee_sprite_reset:logical_room%=8:PROCdraw_current_room:PROCwarp_effect:ENDPROC
  585REM If player is in room 10 (Ed's room J) and in the top half of the screen,
  586REM warp to room 9 (Ed's room N) - the fleece room.
  590IFlogical_room%=10ANDlee_x_os%>=1152ANDlee_y_os%>480:phys_room%=14:logical_room%=9:lee_x_os%=68:lee_y_os%=416:Y%=S_OP_REMOVE:W%=SLOT_ENEMY:CALLS%:PROClee_sprite_reset:PROCdraw_current_room:PROCwarp_effect:room_type%=2:ENDPROC
  595REM If player is in room 13 at a specific point on the right edge, warp to
  596REM room 7 (Ed's room H).
  600IFlogical_room%=13ANDlee_x_os%>1150AND(lee_y_os%=288ORlee_y_os%=284):phys_room%=9:lee_x_os%=1148:lee_y_os%=420:Y%=S_OP_REMOVE:W%=SLOT_ENEMY:CALLS%:PROClee_sprite_reset:logical_room%=7:PROCdraw_current_room:PROCwarp_effect:ENDPROC
  605REM If player is in room 5 (Ed's room G), has a score of 90% and it's daytime,
  606REM force specific colours and if (TODO: what does this mean?) X%=7, show the fleece (TODO: MacGuffin?).
  607REM TODO: I think this shows the fleece anyway.
  610IFlogical_room%=5ANDscore%=90ANDday_night%=0:VDU19,0,7;0;19,1,0;0;19,0,0;0;19,1,3;0;:IFX%=7:PROCshow_fleece
  620ENDPROC

  630DEFPROCshow_fleece:Y%=S_OP_REMOVE:W%=SLOT_SUN_MOON:CALLS%:W%=SLOT_MISC:CALLS%:RESTORE1450:score%=100:sun_moon_disabled%=1:PROClee_sprite_reset:FORn%=10TO100STEP5:FORnm%=110TO200STEPn%:READok%:VDU19,1,ok%;0;19,2,ok%;0;19,3,ok%;0;:IFok%=0:RESTORE1450
  635REM TODO: CALLV% in next line will reset all resident integer variables to 0 except the "subroutine" ones. This will be a problem if we try to persist things in them to speed the code up.
  640SOUND1,4,n%+nm%,2:SOUND2,12,n%+nm%,3:NEXT,:PROCreset_note_count:VDU19,3,4;0;19,2,0;0;19,1,6;0;17,131,17,2:colour1%=6:colour2%=0:colour3%=4:PRINTTAB(9,14)STRING$(4,CHR$227):COLOUR128:CALLV%:ENDPROC

  650DEFPROCroom_type1:Z%=db%:IFRND(3)<>1:GOTO680
  660IFdb%=DELTA_STEP_RIGHTANDJ%>lee_y_os%:Z%=DELTA_STEP_RIGHT_DOWN ELSEIFdb%=6ANDJ%<lee_y_os%:Z%=DELTA_STEP_RIGHT_UP
  670IFdb%=DELTA_STEP_LEFTANDJ%>lee_y_os%:Z%=DELTA_STEP_LEFT_DOWN ELSEIFdb%=4ANDJ%<lee_y_os%:Z%=DELTA_STEP_LEFT_UP
  680IFI%=1152:db%=DELTA_STEP_LEFT:X%=IMAGE_HARPY_LEFT:CALLU% ELSEIFI%=64:db%=DELTA_STEP_RIGHT:X%=IMAGE_HARPY_RIGHT:CALLU%
  690CALLT%:ENDPROC

  700DEFPROCroom_type2:axm%=3:IFI%>lee_x_os%:axm%=-3
  710aym%=2:IFJ%>lee_y_os%:aym%=-4
  720I%=I%+axm%:J%=J%+aym%:CALLS%:ENDPROC

  730DEFPROCroom_type4:Z%=ad%(ah%):ak%=ak%+1:IFak%=40:ak%=0:ah%=ah%+1:IFah%=5:ah%=1
  740CALLT%:ENDPROC

  750DEFPROCroom_type3:Z%=ed%(ah%):ak%=ak%+1:IFak%=30:ak%=0:ah%=ah%+1:IFah%=7:ah%=1
  760CALLT%:ENDPROC

  770DEFPROCroom_type5:Z%=ed%:IFed%=6ANDI%>688:ed%=4
  780IFed%=4ANDI%<644:ed%=6
  790CALLT%:ENDPROC

  799REM TODO: Moving this towards end of code would slightly speed up line number searching for GOTOs
  800DEFPROCnew_game_init:CALLV%:PROCclear_room:VDU28,4,30,15,28,17,128,12,26
  801FORn%=28TO30:FORwn%=0TO2:VDU31,wn%,n%,(229+wn%),31,(wn%+17),n%,(229+wn%):NEXT,:ENDPROC

  815REM TODO: Moving this towards end of code would slightly speed up line number searching for GOTOs
  820DEFPROCone_off_init:CALLV%:DIMad%(4),ed%(6),item_collected%(5):ad%(1)=3:ad%(2)=9:ad%(3)=7:ad%(4)=1:ed%(1)=3:ed%(2)=6:ed%(3)=9:ed%(4)=7:ed%(5)=4:ed%(6)=1:VDU17,3,17,128,28,0,30,19,28,12,26:ENDPROC

  840DEFPROCclear_room
  841REM Fix the "phantom wall enemy" bug by ensuring slot 7 (the general enemy slot) isn't left active from a previous room. TODO: NO, SLOT 7 IS NOT GENERAL *ENEMY*, IT'S MISC STUFF SLOT
  843Y%=S_OP_REMOVE:W%=SLOT_MISC:CALLS%:Y%=S_OP_MOVE:REM TODO: this probably isn't necessary with current code, but with suitable tweaks to the machine code it's probably the right fix instead of following line
  844?(&5760+(7-1)*2+1)=230:REM TODO: hack to work around fact that collision detection doesn't ignore invisible sprites!?
  847VDU28,0,26,19,9,17,128,12,26:ENDPROC

  850DEFPROCdraw_room(b1%):fb%=&3508+(180*b1%):fb$=STR$~fb%:b1$="&"+MID$(fb$,3,4):b2$="&"+MID$(fb$,1,2):aa%=EVAL(b1$):bb%=EVAL(b2$):PRINTTAB(0,9);
  851REM TODO: The following implies &70-&73 contain valuable persistent state.
  852REM TODO: We could preserve them more efficiently using foo%=!&70:!&70=foo%
  853REM TODO: That said, I'm not convinced they do need preserving - double-check machine code!
  860s0%=?&70:s1%=?&71:s2%=?&72:s3%=?&73:?&70=aa%:?&71=bb%:?&72=226:?&73=30
  870CALL&A00:?&70=s0%:?&71=s1%:?&72=s2%:?&73=s3%
  880IFroom_type%=2:I%=608:J%=672:W%=SLOT_ENEMY:Y%=S_OP_MOVE:CALLS%:GOTO900
  890db%=6:IFroom_type%>0:I%=291:J%=480:W%=SLOT_ENEMY:Y%=S_OP_MOVE:CALLS%:IFroom_type%=1:X%=IMAGE_HARPY_RIGHT:CALLU%
  900IFlogical_room%=2ANDscore%=80:room_type%=3:X%=IMAGE_VEIL2:CALLU%:GOTO960
  910IFlogical_room%=5ANDscore%=90:room_type%=0:Y%=S_OP_REMOVE:CALLS%:Y%=S_OP_MOVE
  920IFroom_type%=2:X%=IMAGE_WINGED_CREATURE:CALLU%
  930IFroom_type%=3:X%=IMAGE_ROBOT:CALLU%
  940IFroom_type%=4:X%=IMAGE_EYE:CALLU%
  950IFroom_type%=5:Y%=S_OP_REMOVE:CALLS%:I%=640:J%=316:Y%=S_OP_MOVE:CALLS%:ed%=6:IFscore%>70ANDscore%<100:X%=IMAGE_VEIL:CALLU% ELSEIFroom_type%=5ANDscore%=100:X%=IMAGE_FINAL_GUARDIAN:CALLU%
  960ak%=0:ah%=1:W%=2:Y%=S_OP_SHOW:IFlogical_room%=9:W%=SLOT_MISC:M%=1035:N%=692:CALLS%:X%=IMAGE_FLEECE_MACGUFFIN_PRISM:CALLU%:IFitem_collected%(5)=0:PROCupdate_sprite_slot_7_and_show(2,14,IMAGE_HEALTH)
  970IFlogical_room%=6:PROCupdate_sprite_slot_7_and_show(18,15,IMAGE_WALL_ENEMY_RIGHT):PROCupdate_sprite_slot_7_and_show(18,19,IMAGE_WALL_ENEMY_RIGHT)
  980IFlogical_room%=10ANDscore%>70:PRINTTAB(10,26)"  "
  990IFlogical_room%=5ANDscore%>80:PRINTTAB(9,14)"  "
  995REM TODO: Use constants for the image argument to PROCupdate_sprite_slot_7...
 1000IFlogical_room%=13ANDscore%=60:PRINTTAB(19,17)STRING$(3," "+CHR$8+CHR$10)
 1010IFlogical_room%=1:PROCupdate_sprite_slot_7_and_show(9,12,IMAGE_STATUE):IFitem_collected%(1)=0:PROCupdate_sprite_slot_7_and_show(2,12,IMAGE_FLEECE_MACGUFFIN_PRISM)
 1020IFlogical_room%=7:PROCupdate_sprite_slot_7_and_show(6,21,IMAGE_STATUE):IFitem_collected%(2)=0:PROCupdate_sprite_slot_7_and_show(2,11,IMAGE_FLEECE_MACGUFFIN_PRISM)
 1030IFlogical_room%=2:PROCupdate_sprite_slot_7_and_show(1,23,IMAGE_WALL_ENEMY_LEFT)
 1040IFlogical_room%=8:PROCupdate_sprite_slot_7_and_show(11,23,IMAGE_STATUE):PROCupdate_sprite_slot_7_and_show(9,21,IMAGE_STATUE):PROCupdate_sprite_slot_7_and_show(13,24,IMAGE_STATUE)
 1050IFlogical_room%=14:PROCupdate_sprite_slot_7_and_show(8,20,IMAGE_WALL_ENEMY_RIGHT):PROCupdate_sprite_slot_7_and_show(11,20,IMAGE_WALL_ENEMY_LEFT):VDU17,131,17,2:PRINTTAB(0,26)STRING$(20,CHR$231):COLOUR128:IFitem_collected%(4)=0:PROCupdate_sprite_slot_7_and_show(12,25,IMAGE_FLEECE_MACGUFFIN_PRISM)
 1060IFlogical_room%=12:PROCupdate_sprite_slot_7_and_show(1,15,IMAGE_WALL_ENEMY_LEFT):PROCupdate_sprite_slot_7_and_show(1,18,IMAGE_WALL_ENEMY_LEFT):PROCupdate_sprite_slot_7_and_show(1,21,IMAGE_WALL_ENEMY_LEFT)
 1070IFlogical_room%=13:PROCupdate_sprite_slot_7_and_show(7,21,23):PROCupdate_sprite_slot_7_and_show(12,21,23)
 1080IFlogical_room%=5ANDscore%=90:M%=608:N%=512:W%=SLOT_MISC:CALLS%:X%=IMAGE_FLEECE_MACGUFFIN_PRISM:CALLU%:IFday_night%=1:Y%=S_OP_REMOVE:CALLS%
 1090IFlogical_room%=5ANDitem_collected%(3)=0:PROCupdate_sprite_slot_7_and_show(18,24,17)
 1100ENDPROC

 1110DEFPROCchange_room:IFlogical_room%=10ANDlee_y_os%<228:PROCwin:game_ended%=1:ENDPROC
 1121IFlee_y_os%>730:lee_y_os%=224:phys_room%=phys_room%-5 ELSEIFlee_y_os%<228:lee_y_os%=728:phys_room%=phys_room%+5 ELSEIFlee_x_os%>1194:lee_x_os%=24:phys_room%=phys_room%+1 ELSEIFlee_x_os%<24:lee_x_os%=1194:phys_room%=phys_room%-1
 1122PROCchange_room2:ENDPROC
 1124DEFPROCchange_room2
 1125REM TODO: Do we still need the following FOR loop?
 1127W%=SLOT_ENEMY:Y%=S_OP_REMOVE:CALLS%:FORn%=9TO12:W%=n%:CALLS%:NEXT
 1130RESTORE1430:FORn%=1TOphys_room%:READlogical_room%:NEXT:RESTORE1440:FORn%=1TOlogical_room%:READroom_type%:NEXT:IFscore%=100:room_type%=2
 1140IFlogical_room%=10ANDscore%>70:room_type%=5
 1150PROCdraw_current_room:ENDPROC

 1160DEFPROCupdate_energy_and_items:IFX%=SLOT_ENEMY:GOTO1210 ELSEIFX%=SLOT_ENEMYOR(X%=SLOT_MISCANDlogical_room%<>1ANDlogical_room%<>5ANDlogical_room%<>9ANDlogical_room%<>14ANDlogical_room%<>7):GOTO1210
 1170IFfalling_time%>1:GOTO1210 ELSEIFlogical_room%=1:this_item%=1 ELSEIFlogical_room%=7:this_item%=2 ELSEIFlogical_room%=5:this_item%=3 ELSEIFlogical_room%=14:this_item%=4 ELSEIFlogical_room%=9:this_item%=5
 1180IFitem_collected%(this_item%)=1:GOTO1220 ELSEitem_collected%(this_item%)=1:IFthis_item%<5:PROCshow_prisms
 1181REMfix%=&5600+(SLOT_MISC-1)*4+2:PRINTTAB(0,0);~!fix%;:fix2%=(256*?fix%)+(fix%?1)-&C0:?fix%=fix2% DIV 256:fix%?1=fix2% MOD 256:PRINTTAB(0,1);~!fix%:REM TODO: work around off-by-one bug in u_subroutine
 1182W%=SLOT_MISC:Y%=S_OP_REMOVE:CALLS%:REM remove the collected object from the room
 1190PROCstop_sound:PROCdelay(100):SOUND1,6,20,4:VDU19,0,7;0;:score%=score%+20:energy_minor%=50:PROCdelay(150):VDU19,0,0;0;
 1191IFlogical_room%=9:score%=score%-10:COLOUR1:PRINTTAB(energy_major%,5)CHR$246:energy_major%=16:VDU17,0,17,131:PRINTTAB(16,5)CHR$224:VDU17,128
 1200ENDPROC
 1210IFfalling_time%>1:SOUND1,11,energy_minor%,2:GOTO1230
 1220IFroom_type%=2ANDday_night%=1ANDX%=SLOT_ENEMY:ENDPROC ELSEPROCstop_sound:IFroom_type%=2SOUND1,9,energy_minor%,2 ELSEIFX%=SLOT_MISC:SOUND1,8,energy_minor%,4 ELSESOUND1,12,energy_minor%,5
 1230energy_minor%=energy_minor%-1
 1231IFenergy_minor%=0:energy_minor%=25:IF?&9FF<>1:energy_major%=energy_major%-1:VDU17,0,17,131:PRINTTAB(energy_major%,5)CHR$224:VDU17,128,17,1:PRINTTAB(energy_major%+1,5)CHR$246:IFenergy_major%=3:game_ended%=1
 1240ENDPROC

 1250DEFPROChide_fleece:IFlogical_room%<>5:ENDPROC
 1260IFscore%<90:ENDPROC ELSEW%=SLOT_MISC:Y%=S_OP_REMOVE:CALLS%:ENDPROC

 1270DEFPROCrestore_fleece:IFlogical_room%<>5:ENDPROC
 1280IFscore%<90:ENDPROC ELSEW%=SLOT_MISC:X%=IMAGE_FLEECE_MACGUFFIN_PRISM:CALLS%:CALLU%:ENDPROC

 1290DEFPROCwarp_effect:VDU19,1,7;0;19,2,7;0;19,3,7;0;:SOUND1,6,60,4:PROCdelay(120):VDU19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:ENDPROC

 1299REM Background music data: (pitch, duration) pairs
 1300DATA116,3,88,3,116,2,0,0,116,3,120,3,116,3,0,0,116,2,88,2,116,2,116,2,116,2,120,2,116,2,0,0,116,3,72,3,100,3,0,0,100,3,108,3,100,3,0,0,100,2,72,2,100,2,100,2,100,2,108,2,100,2,0,0
 1310DATA52,3,32,3,80,3,0,0,80,3,88,3,80,3,0,0,52,2,32,2,80,2,80,2,80,2,88,2,80,2,0,0,32,3,32,3,60,3,0,0,60,3,68,3,60,3,0,0,60,2,32,2,60,2,60,2,60,2,68,2,60,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

 1320DEFPROCtitle_screen:colour1%=7:colour2%=6:colour3%=1:PROCreset_note_count
 1330day_night%=0:score%=0:room_type%=0:logical_room%=9:VDU19,3,1;0;19,2,6;0;19,1,7;0;:PROCdraw_room(9):VDU17,3,31,5,28,241,240,235,236,236,32,32,233,242,243,31,4,30,237,235,243,32,244,238,32,236,244,233,240,244
 1331REPEATREADnote_pitch%,note_duration%:IFnote_pitch%=0:PROCdelay(220):GOTO1350
 1340SOUND1,1,note_pitch%,note_duration%:SOUND2,1,note_pitch%,note_duration%:SOUND3,1,note_pitch%,note_duration%:s$=INKEY$(14):note_count%=note_count%+1:IFnote_count%=52:PROCreset_note_count
 1350GCOL0,RND(3):PLOT69,634,934:PLOT69,648,934:UNTILs$<>""ORINKEY-1
 1351energy_major%=16:energy_minor%=10:logical_room%=8:day_night%=0:w%=0:lee_y_os%=576:lee_x_os%=1120:K%=192:L%=108:jumping%=0:delta_x%=0:sd%=10:lee_direction%=10:falling_delta_x%=0
 1352VDU28,3,30,16,28,17,128,12,26:sound_and_light_show_chance%=40:cr%=0
 1360PROCreset_note_count:phys_room%=12:game_ended%=0:W%=SLOT_SUN_MOON:X%=IMAGE_SUN:CALLS%:CALLU%:full_speed_jump_time_limit%=20:max_jump_time%=40:uw%=0:sun_moon_disabled%=0:m%=0:room_type%=3
 1361VDU17,0,17,131:PRINTTAB(energy_major%,5)CHR$224:COLOUR128:FORn%=1TO5:item_collected%(n%)=0:NEXT:won%=0:*FX210,0
 1370PROCstop_sound:IFs$="Q"ORs$="q":*FX210,1
 1380ENDPROC

 1390DEFPROCreset_note_count:RESTORE1300:note_count%=0:ENDPROC

 1400DEFPROCpause:SOUND1,4,20,3:Y%=S_OP_REMOVE:W%=SLOT_SUN_MOON:CALLS%:VDU5:B$="WAITING":*FX15,1
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
 1480FORmrx%=1TO30:SOUND&12,6,mrx%+50,5:PROCdelay(pw%):pw%=pw%-25:W%=lee_sprite_num%:Y%=on%:rr%=on%:on%=0:CALLS%:IFrr%=0:on%=2:NEXT ELSENEXT
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
 2060FOR n%=1 TO ASC(key$)AND&9F:READ phys_room%,lee_x_os%,lee_y_os%:NEXT
 2070REM Logical room 14 (Ed's room N) has some tricky behaviour; to get it right, we pretend we're passing through the warp from logical room 10 as in real gameplay.
 2200IF phys_room%<>14:PROCchange_room2 ELSE logical_room%=10:room_type%=4-(score%>70):lee_x_os%=1152:lee_y_os%=484:PROCcheck_warps
 2205PROCset_lee_sprite_from_lee_xy_os:W%=lee_sprite_num%:Y%=S_OP_SHOW:CALLS%:REM show player sprite
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
 3026REMENDPROC:REM TEMP
 3030IF q%<=2 THEN F%=124:p%=q% ELSE F%=144:p%=4:REM TODO NUMBERS MADE UP
 3040FOR n%=1 TO p%
 3045E%=1112-(n% MOD 2)*1024
 3048GCOL 0,0:MOVE E%-8,F%-24:MOVE E%+72,F%-24:PLOT 85,E%+72,F%-68:MOVE E%-8,F%-68:PLOT 85,E%-8,F%-24:REM TODO: PROCsquare()?
 3050IF n%<=q%:CALLS%:CALLU%
 3065IF n%=2:F%=F%-40
 3080NEXT
 3090ENDPROC

32000*TAPE
32010FORI%=PAGE TOTOP STEP4:!(I%-PAGE+&E00)=!I%:NEXT:*KEY0PAGE=&E00|MOLD|MDEL.0,0|MDEL.32000,32767|MRUN|F|M
32020VDU21:*FX15,1
32030*FX138,0,128
