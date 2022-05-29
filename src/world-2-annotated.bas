   10VDU23,249,0,0,0,0,0,0,255,255:REM TODO: Could be moved into earlier file
   20VDU17,128,17,3,12,26,19,3,7;0;:B$=STRING$(3,CHR$8)+CHR$10:A$=CHR$232+CHR$233+CHR$234+B$+CHR$235+":"+CHR$236+B$+CHR$243+CHR$236+CHR$244+B$+CHR$235+CHR$234+CHR$236:PROCclear_room:VDU5:GCOL0,3:MOVE532,528:PRINTA$:PROCdelay(18000):VDU4
   30ENVELOPE1,1,0,0,0,2,2,2,30,0,0,255,128,1:REM TODO: Could be moved into earlier file
   40ONERROR:VDU4:uw%=1:GOTO100
   50es%=0:score%=13:uw%=0:energy_major%=10
   60PROCone_off_init
   70PROCnew_game_init:*FX15,0
   80*FX200,2
   90PROCtitle_screen:PROCdraw_current_room:PROCplay:IFw%=1:PROCo
  100PROCgame_over:GOTO70

  110DEFPROCstop_sound:SOUND&11,0,0,0:ENDPROC

  112REM TODO: As with g4/g5 below, PROC4/PROC5 are the only users of A%/B%/C%/D% and
  113REM use them to save/restore some values. Ahah(-ish), note that this logic does
  114REM kind of tie up with the code at &511C in world-1.asm where each sprite number
  115REM accesses a different adjacent pair of resident integer variables - and in
  116REM particular sprite 9 uses A%/B%, 10 uses C%/D%, similarly for 11 and 12.

  120DEFPROC4:IFday_night%=1:PROCg4:ENDPROC ELSEIFlee_direction%=9:A%=lee_x_os%:B%=lee_y_os%:lee_sprite_num%=9:ENDPROC
  130C%=lee_x_os%:D%=lee_y_os%:lee_sprite_num%=10:ENDPROC

  140DEFPROC5:IFday_night%=1:PROCg5:ENDPROC ELSEIFlee_direction%=9:lee_x_os%=A%:lee_y_os%=B%:lee_sprite_num%=9:ENDPROC
  150lee_x_os%=C%:lee_y_os%=D%:lee_sprite_num%=10:ENDPROC

  152REM TODO: Not sure what's going on yet, but note that PROCg4 and PROCg5 are the
  153REM only users of E%/F%/G%/H% and one stores things in those and the other
  154REM retrieves the old values.

  160DEFPROCg4:IFlee_direction%=9:E%=lee_x_os%:F%=lee_y_os%:lee_sprite_num%=11:ENDPROC
  170G%=lee_x_os%:H%=lee_y_os%:lee_sprite_num%=12:ENDPROC

  180DEFPROCg5:IFlee_direction%=9:lee_x_os%=E%:lee_y_os%=F%:lee_sprite_num%=11:ENDPROC
  190lee_x_os%=G%:lee_y_os%=H%:lee_sprite_num%=12:ENDPROC

  198REM TODO: The name is a guess here; this is doing some sort of sprite plot operation on the
  199REM four player sprites (human/gargoyle, left/right) but I don't know what Y%=2 means yet.
  200DEFPROClee_sprite_reset:Y%=2:FORn%=9TO12:W%=n%:CALLS%:NEXT:Y%=0:ENDPROC

  210DEFPROCdraw_current_room:PROCclear_room
  220colour1%=RND(7):colour2%=RND(7):colour3%=RND(7):IFcolour1%=colour2%ORcolour1%=colour3%ORcolour2%=colour3%:GOTO220 ELSEIFscore%=100:colour2%=0:colour3%=4:colour1%=6
  230VDU19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:IFlogical_room%=10:sound_and_light_show_chance%=4 ELSEsound_and_light_show_chance%=40
  240IFlogical_room%<1ORlogical_room%>14:logical_room%=1:phys_room%=1:lee_x_os%=128:room_type%=0:PROCdraw_room(1):COLOUR3:PRINTTAB(7,26);:VDU245,234:ENDPROC
  250PROCdraw_room(logical_room%):ENDPROC

  260DEFPROCplay
  270GCOL0,0:Y%=0:PROC4
  280IFscore%=100ANDRND(sound_and_light_show_chance%)=1:PROCsound_and_light_show
  281REM TODO: I *think* that falling_delta_x% is used to give Lee a left/right drift
  282REM when he's falling *after* a jump has finished in mid-air, and that all other
  283REM falls are straight down.
  290PROC5:W%=lee_sprite_num%
  291IFjumping%=1:PROCjump:GOTO330 ELSEdelta_x%=0:IFPOINT(lee_x_os%+4,lee_y_os%-66)=0ANDPOINT(lee_x_os%+60,lee_y_os%-66)=0:lee_x_os%=lee_x_os%+falling_delta_x%:lee_y_os%=lee_y_os%-8:falling_time%=falling_time%+1:GOTO330
  300falling_delta_x%=0:IFINKEY-98PROCmove_left ELSEIFINKEY-67PROCmove_right
  310falling_time%=0:IFINKEY-1jumping%=1:jump_time%=0:jump_delta_y%=8:falling_delta_x%=delta_x%:SOUND1,11,lee_y_os%,12 ELSEIFINKEY-56PROCpause
  320sf%=lee_y_os%-66:IFscore%=100ANDPOINT(lee_x_os%,sf%)=3ANDlee_y_os%>260:MOVElee_x_os%,sf%+26:VDU5,249,4
  330PROC4:CALLS%:IFlee_x_os%<24ORlee_x_os%>1194ORlee_y_os%>730ORlee_y_os%<228PROCchange_room:PROCreset_note_count:IFgame_ended%=0GOTO270 ELSEIFgame_ended%=1:ENDPROC
  340W%=5:IFroom_type%=1:PROCroom_type1 ELSEIFroom_type%=2:PROCroom_type2 ELSEIFroom_type%=3:PROCroom_type3 ELSEIFroom_type%=4:PROCroom_type4 ELSEIFroom_type%=5:PROCroom_type5
  350cr%=cr%+1:IFcr%=4:cr%=0:READnote_pitch%,note_duration%:SOUND2,-5,note_pitch%,note_duration%:SOUND3,-5,note_pitch%,note_duration%:note_count%=note_count%+1:IFnote_count%=70:PROCreset_note_count
  360W%=lee_sprite_num%:Y%=8:CALLQ%:IFX%<>0ORfalling_time%>12:PROCupdate_energy
  370IFng%=0:m%=m%+1:IFm%=11:PROCm:m%=0 ELSEIFlogical_room%=1ORlogical_room%=13ORlogical_room%=5ORlogical_room%=10:PROCcheck_warps:GOTO270
  380GOTO280

  390DEFPROCsound_and_light_show:PROCstop_sound:VDU19,0,7;0;19,1,0;0;19,2,0;0;19,3,0;0;:SOUND&10,-13,5,6:SOUND0,-10,5,6:SOUND0,-7,6,10:PROCdelay(250):VDU19,0,0;0;19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:ENDPROC

  394REM TODO: This seems to plot sprite 7 via CALL S%, but then it does something I don't
  395REM currently know via CALL U% as well, hence "maxplutz". Sprite 7 is an instance of
  396REM the data at sprite_00 which seems to be a kind of "Dm"-ish shape. (I am suspecting
  397REM sprites have four frames of animation; this has "Dm" moving one pixel to right
  398REM in three different colours with a fourth frame blank, if so.) I half wonder if
  399REM sprite_00 gets patched at runtime depending on room!?
  400DEFPROCplot_and_maxplutz_sprite_7(text_x%,text_y%,ch%):M%=(text_x%*64)-4:N%=(1024-(32*text_y%))+28:X%=ch%:W%=7:IFch%=20:M%=M%+4
  410CALLS%:CALLU%:ENDPROC

  420DEFPROCmove_left:IFPOINT(lee_x_os%-4,lee_y_os%-8)<>0:ENDPROC
  430IFlee_direction%=9:lee_direction%=10:PROClee_sprite_reset:W%=10:IFday_night%=1:W%=12
  440delta_x%=-8:lee_x_os%=lee_x_os%-8:ENDPROC

  450DEFPROCmove_right:IFPOINT(lee_x_os%+64,lee_y_os%-8)<>0:ENDPROC
  460IFlee_direction%=10:lee_direction%=9:PROClee_sprite_reset:W%=9:IFday_night%=1:W%=11
  470delta_x%=8:lee_x_os%=lee_x_os%+8:ENDPROC

  480DEFPROCjump:IFPOINT(lee_x_os%+8,lee_y_os%+4)<>0ORPOINT(lee_x_os%+56,lee_y_os%+4)<>0:jumping%=0:PROCstop_sound:ENDPROC
  490jump_time%=jump_time%+1:lee_y_os%=lee_y_os%+jump_delta_y%:lee_x_os%=lee_x_os%+delta_x%:jump_time%=jump_time%+1
  491IFjump_time%>full_speed_jump_time_limit%:jump_delta_y%=-4:IFjump_time%=max_jump_time%ORPOINT(lee_x_os%+32,lee_y_os%-66)<>0:jumping%=0:PROCstop_sound:ENDPROC
  500ENDPROC

  510DEFPROCm:W%=6:Z%=6:CALLT%:IFK%=1016:PROCtoggle_day_night
  520IFlogical_room%=5:W%=8:Z%=6:CALLT%
  530ENDPROC

  540DEFPROCtoggle_day_night:RESTORE1450:FORn%=1TO140STEP5:READo%:SOUND1,3,n%,2:SOUND2,2,n%+10,3:VDU19,1,o%;0;19,2,o%-1;0;19,3,o%-2;0;:IFo%=0:RESTORE1450
  550NEXT:PROCreset_note_count:VDU19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:PROCstop_sound:W%=6:Y%=2:CALLS%:PROClee_sprite_reset:K%=192
  551IFday_night%=0:day_night%=1:X%=25:W%=6:CALLS%:CALLU%:PROCg4:full_speed_jump_time_limit%=45:max_jump_time%=90:PROCmu:ENDPROC
  560full_speed_jump_time_limit%=20:max_jump_time%=40:day_night%=0:X%=24:W%=6:CALLS%:CALLU%:PROC4:PROCvx:ENDPROC

  570DEFPROCdelay(n1%):FORn%=1TOn1%:NEXT:ENDPROC

  580DEFPROCcheck_warps
  581REM If player is in room 1 (Ed's room D) and at the far left of the screen,
  582REM warp to room 9 (Ed's room A).
  583IFlogical_room%=1ANDlee_x_os%<68:phys_room%=12:lee_x_os%=1142:lee_y_os%=316:Y%=2:W%=5:CALLS%:PROClee_sprite_reset:logical_room%=8:PROCdraw_current_room:PROCwarp_effect:ENDPROC
  585REM If player is in room 10 (Ed's room J) and in the top half of the screen,
  586REM warp to room 9 (Ed's room N) - the fleece room.
  590IFlogical_room%=10ANDlee_x_os%>=1152ANDlee_y_os%>480:phys_room%=14:logical_room%=9:lee_x_os%=68:lee_y_os%=416:Y%=2:W%=5:CALLS%:PROClee_sprite_reset:PROCdraw_current_room:PROCwarp_effect:room_type%=2:ENDPROC
  595REM If player is in room 13 at a specific point on the right edge, warp to
  596REM room 7 (Ed's room H).
  600IFlogical_room%=13ANDlee_x_os%>1150AND(lee_y_os%=288ORlee_y_os%=284):phys_room%=9:lee_x_os%=1148:lee_y_os%=420:Y%=2:W%=5:CALLS%:PROClee_sprite_reset:logical_room%=7:PROCdraw_current_room:PROCwarp_effect:ENDPROC
  605REM If player is in room 5 (Ed's room G), has a score of 90% and it's daytime,
  606REM force specific colours and if (TODO: what does this mean?) X%=7, show the fleece.
  607REM TODO: I think this shows the fleece anyway.
  610IFlogical_room%=5ANDscore%=90ANDday_night%=0:VDU19,0,7;0;19,1,0;0;19,0,0;0;19,1,3;0;:IFX%=7:PROCshow_fleece
  620ENDPROC

  630DEFPROCshow_fleece:Y%=2:W%=6:CALLS%:W%=7:CALLS%:RESTORE1450:score%=100:ng%=1:PROClee_sprite_reset:FORn%=10TO100STEP5:FORnm%=110TO200STEPn%:READok%:VDU19,1,ok%;0;19,2,ok%;0;19,3,ok%;0;:IFok%=0:RESTORE1450
  640SOUND1,4,n%+nm%,2:SOUND2,12,n%+nm%,3:NEXT,:PROCreset_note_count:VDU19,3,4;0;19,2,0;0;19,1,6;0;17,131,17,2:colour1%=6:colour2%=0:colour3%=4:PRINTTAB(9,14)STRING$(4,CHR$227):COLOUR128:CALLV%:ENDPROC

  650DEFPROCroom_type1:Z%=db%:IFRND(3)<>1:GOTO680
  660IFdb%=6ANDJ%>lee_y_os%:Z%=9 ELSEIFdb%=6ANDJ%<lee_y_os%:Z%=3
  670IFdb%=4ANDJ%>lee_y_os%:Z%=7 ELSEIFdb%=4ANDJ%<lee_y_os%:Z%=1
  680IFI%=1152:db%=4:X%=14:CALLU% ELSEIFI%=64:db%=6:X%=13:CALLU%
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

  800DEFPROCnew_game_init:CALLV%:PROCclear_room:VDU28,4,30,15,28,17,128,12,26:ENDPROC
  805REM TODO: The next line appears to be unreachable.
  810COLOUR3:FORn%=28TO30:PRINTTAB(1,n%)STRING$(2,CHR$(259-n%));TAB(17,n%)STRING$(2,CHR$(259-n%)):NEXT:ENDPROC

  820DEFPROCone_off_init:CALLV%:os%=&FFEE:PROCassemble:DIMad%(4),ed%(6),item_collected%(5):ad%(1)=3:ad%(2)=9:ad%(3)=7:ad%(4)=1:ed%(1)=3:ed%(2)=6:ed%(3)=9:ed%(4)=7:ed%(5)=4:ed%(6)=1:VDU17,3,17,128,28,0,30,19,28,12,26
  830FORn%=28TO30:FORwn%=0TO2:VDU31,wn%,n%,(229+wn%),31,(wn%+17),n%,(229+wn%):NEXT,:ENDPROC

  840DEFPROCclear_room:VDU28,0,26,19,9,17,128,12,26:ENDPROC

  850DEFPROCdraw_room(b1%):fb%=&3508+(180*b1%):fb$=STR$~fb%:b1$="&"+MID$(fb$,3,4):b2$="&"+MID$(fb$,1,2):aa%=EVAL(b1$):bb%=EVAL(b2$):PRINTTAB(0,9);
  851REM TODO: The following implies &70-&73 contain valuable persistent state.
  852REM TODO: We could preserve them more efficiently using foo%=!&70:!&70=foo%
  860s0%=?&70:s1%=?&71:s2%=?&72:s3%=?&73:?&70=aa%:?&71=bb%:?&72=226:?&73=30
  870CALLs:?&70=s0%:?&71=s1%:?&72=s2%:?&73=s3%
  880IFroom_type%=2:I%=608:J%=672:W%=5:Y%=0:CALLS%:GOTO900
  890db%=6:IFroom_type%>0:I%=291:J%=480:W%=5:Y%=0:CALLS%:IFroom_type%=1:X%=13:CALLU%
  900IFlogical_room%=2ANDscore%=80:room_type%=3:X%=26:CALLU%:GOTO960
  910IFlogical_room%=5ANDscore%=90:room_type%=0:Y%=2:CALLS%:Y%=0
  920IFroom_type%=2:X%=15:CALLU%
  930IFroom_type%=3:X%=16:CALLU%
  940IFroom_type%=4:X%=22:CALLU%
  950IFroom_type%=5:Y%=2:CALLS%:I%=640:J%=316:Y%=0:CALLS%:ed%=6:IFscore%>70ANDscore%<100:X%=19:CALLU% ELSEIFroom_type%=5ANDscore%=100:X%=27:CALLU%
  960ak%=0:ah%=1:W%=2:Y%=1:IFlogical_room%=9:W%=7:M%=1035:N%=692:CALLS%:X%=17:CALLU%:IFitem_collected%(5)=0:PROCplot_and_maxplutz_sprite_7(2,14,18)
  970IFlogical_room%=6:PROCplot_and_maxplutz_sprite_7(18,15,21):PROCplot_and_maxplutz_sprite_7(18,19,21)
  980IFlogical_room%=10ANDscore%>70:PRINTTAB(10,26)"  "
  990IFlogical_room%=5ANDscore%>80:PRINTTAB(9,14)"  "
 1000IFlogical_room%=13ANDscore%=60:PRINTTAB(19,17)STRING$(3," "+CHR$8+CHR$10)
 1010IFlogical_room%=1:PROCplot_and_maxplutz_sprite_7(9,12,23):IFitem_collected%(1)=0:PROCplot_and_maxplutz_sprite_7(2,12,17)
 1020IFlogical_room%=7:PROCplot_and_maxplutz_sprite_7(6,21,23):IFitem_collected%(2)=0:PROCplot_and_maxplutz_sprite_7(2,11,17)
 1030IFlogical_room%=2:PROCplot_and_maxplutz_sprite_7(1,23,20)
 1040IFlogical_room%=8:PROCplot_and_maxplutz_sprite_7(11,23,23):PROCplot_and_maxplutz_sprite_7(9,21,23):PROCplot_and_maxplutz_sprite_7(13,24,23)
 1050IFlogical_room%=14:PROCplot_and_maxplutz_sprite_7(8,20,21):PROCplot_and_maxplutz_sprite_7(11,20,20):VDU17,131,17,2:PRINTTAB(0,26)STRING$(20,CHR$231):COLOUR128:IFitem_collected%(4)=0:PROCplot_and_maxplutz_sprite_7(12,25,17)
 1060IFlogical_room%=12:PROCplot_and_maxplutz_sprite_7(1,15,20):PROCplot_and_maxplutz_sprite_7(1,18,20):PROCplot_and_maxplutz_sprite_7(1,21,20)
 1070IFlogical_room%=13:PROCplot_and_maxplutz_sprite_7(7,21,23):PROCplot_and_maxplutz_sprite_7(12,21,23)
 1080IFlogical_room%=5ANDscore%=90:M%=608:N%=512:W%=7:CALLS%:X%=17:CALLU%:IFday_night%=1:Y%=2:CALLS%
 1090IFlogical_room%=5ANDitem_collected%(3)=0:PROCplot_and_maxplutz_sprite_7(18,24,17)
 1100ENDPROC

 1110DEFPROCchange_room:IFlogical_room%=10ANDlee_y_os%<228:PROCwin:game_ended%=1:ENDPROC
 1120W%=5:Y%=2:CALLS%:FORn%=9TO12:W%=n%:CALLS%:NEXT
 1121IFlee_y_os%>730:lee_y_os%=224:phys_room%=phys_room%-5 ELSEIFlee_y_os%<228:lee_y_os%=728:phys_room%=phys_room%+5 ELSEIFlee_x_os%>1194:lee_x_os%=24:phys_room%=phys_room%+1 ELSEIFlee_x_os%<24:lee_x_os%=1194:phys_room%=phys_room%-1
 1130RESTORE1430:FORn%=1TOphys_room%:READlogical_room%:NEXT:RESTORE1440:FORn%=1TOlogical_room%:READroom_type%:NEXT:IFscore%=100:room_type%=2
 1140IFlogical_room%=10ANDscore%>70:room_type%=5
 1150PROCdraw_current_room:ENDPROC

 1160DEFPROCupdate_energy:IFX%=5:GOTO1210 ELSEIFX%=5OR(X%=7ANDlogical_room%<>1ANDlogical_room%<>5ANDlogical_room%<>9ANDlogical_room%<>14ANDlogical_room%<>7):GOTO1210
 1170IFfalling_time%>1:GOTO1210 ELSEIFlogical_room%=1:tt%=1 ELSEIFlogical_room%=7:tt%=2 ELSEIFlogical_room%=5:tt%=3 ELSEIFlogical_room%=14:tt%=4 ELSEIFlogical_room%=9:tt%=5
 1180IFitem_collected%(tt%)=1:GOTO1220 ELSEitem_collected%(tt%)=1
 1190PROCstop_sound:PROCdelay(100):SOUND1,6,20,4:VDU19,0,7;0;:score%=score%+20:energy_minor%=50:PROCdelay(150):VDU19,0,0;0;
 1191IFlogical_room%=9:score%=score%-10:COLOUR1:PRINTTAB(energy_major%,5)CHR$246:energy_major%=16:VDU17,0,17,131:PRINTTAB(16,5)CHR$224:VDU17,128
 1200ENDPROC
 1210IFfalling_time%>1:SOUND1,11,energy_minor%,2:GOTO1230
 1220IFroom_type%=2ANDday_night%=1ANDX%=5:ENDPROC ELSEPROCstop_sound:IFroom_type%=2SOUND1,9,energy_minor%,2 ELSEIFX%=7:SOUND1,8,energy_minor%,4 ELSESOUND1,12,energy_minor%,5
 1230energy_minor%=energy_minor%-1:IFenergy_minor%=0:energy_minor%=25:energy_major%=energy_major%-1:VDU17,0,17,131:PRINTTAB(energy_major%,5)CHR$224:VDU17,128,17,1:PRINTTAB(energy_major%+1,5)CHR$246:IFenergy_major%=3:game_ended%=1
 1240ENDPROC

 1250DEFPROCmu:IFlogical_room%<>5:ENDPROC
 1260IFscore%<90:ENDPROC ELSEW%=7:Y%=2:CALLS%:ENDPROC

 1270DEFPROCvx:IFlogical_room%<>5:ENDPROC
 1280IFscore%<90:ENDPROC ELSEW%=7:X%=17:CALLS%:CALLU%:ENDPROC

 1290DEFPROCwarp_effect:VDU19,1,7;0;19,2,7;0;19,3,7;0;:SOUND1,6,60,4:PROCdelay(120):VDU19,1,colour1%;0;19,2,colour2%;0;19,3,colour3%;0;:ENDPROC

 1299REM Background music data: (pitch, duration) pairs
 1300DATA116,3,88,3,116,2,0,0,116,3,120,3,116,3,0,0,116,2,88,2,116,2,116,2,116,2,120,2,116,2,0,0,116,3,72,3,100,3,0,0,100,3,108,3,100,3,0,0,100,2,72,2,100,2,100,2,100,2,108,2,100,2,0,0
 1310DATA52,3,32,3,80,3,0,0,80,3,88,3,80,3,0,0,52,2,32,2,80,2,80,2,80,2,88,2,80,2,0,0,32,3,32,3,60,3,0,0,60,3,68,3,60,3,0,0,60,2,32,2,60,2,60,2,60,2,68,2,60,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

 1320DEFPROCtitle_screen:colour1%=7:colour2%=6:colour3%=1:PROCreset_note_count
 1330day_night%=0:score%=0:room_type%=0:logical_room%=9:VDU19,3,1;0;19,2,6;0;19,1,7;0;:PROCdraw_room(9):VDU17,3,31,5,28,241,240,235,236,236,32,32,233,242,243,31,4,30,237,235,243,32,244,238,32,236,244,233,240,244
 1331REPEATREADnote_pitch%,note_duration%:IFnote_pitch%=0:PROCdelay(220):GOTO1350
 1340SOUND1,1,note_pitch%,note_duration%:SOUND2,1,note_pitch%,note_duration%:SOUND3,1,note_pitch%,note_duration%:s$=INKEY$(14):note_count%=note_count%+1:IFnote_count%=52:PROCreset_note_count
 1350GCOL0,RND(3):PLOT69,634,934:PLOT69,648,934:UNTILs$<>""ORINKEY-1
 1351energy_major%=16:energy_minor%=10:logical_room%=8:i%=0:day_night%=0:w%=0:lee_y_os%=576:lee_x_os%=1120:K%=192:L%=108:jumping%=0:delta_x%=0:sd%=10:lee_direction%=10:falling_delta_x%=0
 1352VDU28,3,30,16,28,17,128,12,26:sound_and_light_show_chance%=40:cr%=0
 1360PROCreset_note_count:phys_room%=12:game_ended%=0:W%=6:X%=24:CALLS%:CALLU%:full_speed_jump_time_limit%=20:max_jump_time%=40:uw%=0:ng%=0:m%=0:room_type%=3
 1361VDU17,0,17,131:PRINTTAB(energy_major%,5)CHR$224:COLOUR128:FORn%=1TO5:item_collected%(n%)=0:NEXT:es%=0:*FX210,0
 1370PROCstop_sound:IFs$="Q":*FX210,1
 1380ENDPROC

 1390DEFPROCreset_note_count:RESTORE1300:note_count%=0:ENDPROC

 1400DEFPROCpause:SOUND1,4,20,3:Y%=2:W%=6:CALLS%:VDU5:B$="WAITING":REPEATA$=INKEY$(0):GCOL0,RND(3):FORmf%=92TO88STEP-4:MOVE416,mf%:PRINTB$:NEXT:UNTILA$="C":FORmf%=92TO88STEP-4:MOVE416,mf%:GCOL0,0:PRINTB$:NEXT:VDU4:IFng%=0:Y%=0:CALLS%
 1410SOUND1,6,30,3:*FX15,1
 1420ENDPROC

 1429REM logical room number for each physical room
 1430DATA1,2,3,4,5,0,6,0,7,0,0,8,0,9,0,10,11,12,13,14
 1439REM room_type% values for each logical room
 1440DATA2,1,1,2,3,4,2,3,4,4,4,3,1,2
 1449REM colour sequence for day/night transition
 1450DATA7,6,3,5,1,2,4,0

 1460DEFPROCgame_over:W%=6:Y%=2:CALLS%:IFes%=0:score%=score%-1:IFscore%=-1:score%=0
 1470PROCstop_sound:pw%=1000:on%=2:IFes%=1ORuw%=1:GOTO1490
 1480FORmrx%=1TO30:SOUND&12,6,mrx%+50,5:PROCdelay(pw%):pw%=pw%-25:W%=lee_sprite_num%:Y%=on%:rr%=on%:on%=0:CALLS%:IFrr%=0:on%=2:NEXT ELSENEXT
 1490VDU19,1,1;0;19,2,6;0;19,3,7;0;17,3:s$=STR$score%+"%":PROCclear_room:PRINTTAB(5,16);:VDU232,233,234,235,32,32,238,239,235,240,5
 1491GCOL0,2:FORn%=416TO412STEP-4:MOVE544,n%:PRINTs$:NEXT:VDU4:PROCdelay(14000):COLOUR1:PRINTTAB(energy_major%,5)CHR$246:ENDPROC

 1500DEFPROCwin:es%=1:PROCstop_sound:VDU19,1,1;0;19,2,3;0;19,3,6;0;:PROCclear_room:COLOUR2:PRINTTAB(6,16);:VDU232,233,234,235,32,235,242,245,5:GCOL0,1:a$=CHR$10+STRING$(12,CHR$8):FORn%=416TO412STEP-4:MOVE256,n%
 1510PRINT"INNER  WORLD"+a$+"COMMING SOON":NEXT:PROCdelay(13000):VDU4:ENDPROC

 1520DEFPROCassemble:S1%=&70:S2%=&71:S3%=&72:S4%=&74:DIM cc% 200:FORn%=0TO2STEP2
 1530P%=cc%
 1531REM ABE's pack won't always correctly rename variables which follow an assembler
 1532REM mnemonic without an intervening space, so spaces have been added here.
 1533REM TODO: Could be assembled in a separate file
 1540[OPTn%
 1541\ The UDG used for level "walls" changes every 30*2 OS characters, i.e. every three 20-character
 1542\ screen lines. &73 tracks the number of double characters left with the current UDG. There are
 1543\ 180 double characters per level, giving 2*180/20=18 lines, so levels are on a 20x18 grid.
 1550.s LDY#0:.l LDA(&70),Y:CMP#0:BEQ ze:CMP#1:BEQ on:CMP#2:BEQ tw:CMP#3:BEQ th:.ba:DEC&73:LDA&73:BEQ rr:.pe:INY:TYA:CMP#180:BNE l:RTS:.rr JMP rt
 1551\ The following routines output two OS characters (a combination of spaces and ?&72)
 1552.ze LDA#32:JSR os%:JSR os%:JMP ba
 1560.on LDA#32:JSR os%:LDA#17:JSR os%:LDA#131:JSR os%:LDA#17:JSR os%:LDA#2:JSR os%:LDA&72:JSR os%:LDA#17:JSR os%:LDA#128:JSR os%:JMP ba
 1570.tw LDA#17:JSR os%:LDA#131:JSR os%:LDA#17:JSR os%:LDA#2:JSR os%:LDA&72:JSR os%:LDA#17:JSR os%:LDA#128:JSR os%:LDA#32:JSR os%:JMP ba
 1580.th LDA#17:JSR os%:LDA#131:JSR os%:LDA#17:JSR os%:LDA#2:JSR os%:LDA&72:JSR os%:LDA&72:JSR os%:LDA#17:JSR os%:LDA#128:JSR os%:JMP ba
 1581\ Reset &73 and bump &72
 1590.rt LDA#30:STA&73:INC&72:JMP pe
 1600]NEXT:ENDPROC
