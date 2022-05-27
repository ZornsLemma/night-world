osbyte_tape = &8c
osbyte_insert_buffer = &8a

l0018 = &0018
l0080 = &0080
l0081 = &0081
l0082 = &0082
l0083 = &0083
osbyte = &fff4

    org &1100

.pydis_start
    equb &0d,   0,   4, &1f, &ef                                      ; 1100: 0d 00 04... ...
    equs "23,249,0,0,0,0,0,0,255,255"                                 ; 1105: 32 33 2c... 23,
    equb &0d,   0,   5, &9a, &ef                                      ; 111f: 0d 00 05... ...
    equs "17,128,17,3,12,26,19,3,7;0;:B$="                            ; 1124: 31 37 2c... 17,
    equb &c4, &33, &2c, &bd                                           ; 1143: c4 33 2c... .3,
    equs "8)+"                                                        ; 1147: 38 29 2b    8)+
    equb &bd                                                          ; 114a: bd          .
    equs "10:A$="                                                     ; 114b: 31 30 3a... 10:
    equb &bd                                                          ; 1151: bd          .
    equs "232+"                                                       ; 1152: 32 33 32... 232
    equb &bd                                                          ; 1156: bd          .
    equs "233+"                                                       ; 1157: 32 33 33... 233
    equb &bd                                                          ; 115b: bd          .
    equs "234+B$+"                                                    ; 115c: 32 33 34... 234
    equb &bd                                                          ; 1163: bd          .
    equs "235+", '"', ":", '"', "+"                                   ; 1164: 32 33 35... 235
    equb &bd                                                          ; 116c: bd          .
    equs "236+B$+"                                                    ; 116d: 32 33 36... 236
    equb &bd                                                          ; 1174: bd          .
    equs "243+"                                                       ; 1175: 32 34 33... 243
    equb &bd                                                          ; 1179: bd          .
    equs "236+"                                                       ; 117a: 32 33 36... 236
    equb &bd                                                          ; 117e: bd          .
    equs "244+B$+"                                                    ; 117f: 32 34 34... 244
    equb &bd                                                          ; 1186: bd          .
    equs "235+"                                                       ; 1187: 32 33 35... 235
    equb &bd                                                          ; 118b: bd          .
    equs "234+"                                                       ; 118c: 32 33 34... 234
    equb &bd                                                          ; 1190: bd          .
    equs "236:"                                                       ; 1191: 32 33 36... 236
    equb &f2, &66, &3a, &ef, &35, &3a, &e6                            ; 1195: f2 66 3a... .f:
    equs "0,3:"                                                       ; 119c: 30 2c 33... 0,3
    equb &ec                                                          ; 11a0: ec          .
    equs "532,528:"                                                   ; 11a1: 35 33 32... 532
    equb &f1                                                          ; 11a9: f1          .
    equs "A$:"                                                        ; 11aa: 41 24 3a    A$:
    equb &f2                                                          ; 11ad: f2          .
    equs "w(18000):"                                                  ; 11ae: 77 28 31... w(1
    equb &ef, &34, &0d,   0,   6, &25, &e2                            ; 11b7: ef 34 0d... .4.
    equs "1,1,0,0,0,2,2,2,30,0,0,255,128,1"                           ; 11be: 31 2c 31... 1,1
    equb &0d,   0,   7, &15, &ee, &85, &3a, &ef                       ; 11de: 0d 00 07... ...
    equs "4:uw%=1:"                                                   ; 11e6: 34 3a 75... 4:u
    equb &e5, &8d                                                     ; 11ee: e5 8d       ..
    equs "TM@"                                                        ; 11f0: 54 4d 40    TM@
    equb &0d,   0,   8, &1c                                           ; 11f3: 0d 00 08... ...
    equs "es%=0:s%=13:uw%=0:ex%=10"                                   ; 11f7: 65 73 25... es%
    equb &0d,   0,   9,   9, &f2                                      ; 120f: 0d 00 09... ...
    equs "uvii"                                                       ; 1214: 75 76 69... uvi
    equb &0d,   0, &0a, &0e, &f2                                      ; 1218: 0d 00 0a... ...
    equs "s:*FX15,0"                                                  ; 121d: 73 3a 2a... s:*
    equb &0d,   0, &0b, &0c                                           ; 1226: 0d 00 0b... ...
    equs "*FX200,2"                                                   ; 122a: 2a 46 58... *FX
    equb &0d,   0, &0c, &15, &f2, &74, &3a, &f2, &72, &3a, &f2, &70   ; 1232: 0d 00 0c... ...
    equb &3a, &e7                                                     ; 123e: 3a e7       :.
    equs "w%=1:"                                                      ; 1240: 77 25 3d... w%=
    equb &f2, &6f, &0d,   0, &0d, &0c, &f2, &67, &3a, &e5, &8d        ; 1245: f2 6f 0d... .o.
    equs "TJ@"                                                        ; 1250: 54 4a 40    TJ@
    equb &0d,   0, &0e, &15, &dd, &f2                                 ; 1253: 0d 00 0e... ...
    equs "so:"                                                        ; 1259: 73 6f 3a    so:
    equb &d4                                                          ; 125c: d4          .
    equs "&11,0,0,0:"                                                 ; 125d: 26 31 31... &11
    equb &e1, &0d,   0, &0f, &2f, &dd, &f2, &34, &3a, &e7             ; 1267: e1 0d 00... ...
    equs "g%=1:"                                                      ; 1271: 67 25 3d... g%=
    equb &f2                                                          ; 1276: f2          .
    equs "g4:"                                                        ; 1277: 67 34 3a    g4:
    equb &e1, &20, &8b, &e7                                           ; 127a: e1 20 8b... . .
    equs "di%=9:A%=x%:B%=y%:ww%=9:"                                   ; 127e: 64 69 25... di%
    equb &e1, &0d,   0, &10, &18                                      ; 1296: e1 0d 00... ...
    equs "C%=x%:D%=y%:ww%=10:"                                        ; 129b: 43 25 3d... C%=
    equb &e1, &0d,   0, &11, &2f, &dd, &f2, &35, &3a, &e7             ; 12ae: e1 0d 00... ...
    equs "g%=1:"                                                      ; 12b8: 67 25 3d... g%=
    equb &f2                                                          ; 12bd: f2          .
    equs "g5:"                                                        ; 12be: 67 35 3a    g5:
    equb &e1, &20, &8b, &e7                                           ; 12c1: e1 20 8b... . .
    equs "di%=9:x%=A%:y%=B%:ww%=9:"                                   ; 12c5: 64 69 25... di%
    equb &e1, &0d,   0, &12, &18                                      ; 12dd: e1 0d 00... ...
    equs "x%=C%:y%=D%:ww%=10:"                                        ; 12e2: 78 25 3d... x%=
    equb &e1, &0d,   0, &13, &24, &dd, &f2                            ; 12f5: e1 0d 00... ...
    equs "g4:"                                                        ; 12fc: 67 34 3a    g4:
    equb &e7                                                          ; 12ff: e7          .
    equs "di%=9:E%=x%:F%=y%:ww%=11:"                                  ; 1300: 64 69 25... di%
    equb &e1, &0d,   0, &14, &18                                      ; 1319: e1 0d 00... ...
    equs "G%=x%:H%=y%:ww%=12:"                                        ; 131e: 47 25 3d... G%=
    equb &e1, &0d,   0, &15, &24, &dd, &f2                            ; 1331: e1 0d 00... ...
    equs "g5:"                                                        ; 1338: 67 35 3a    g5:
    equb &e7                                                          ; 133b: e7          .
    equs "di%=9:x%=E%:y%=F%:ww%=11:"                                  ; 133c: 64 69 25... di%
    equb &e1, &0d,   0, &16, &18                                      ; 1355: e1 0d 00... ...
    equs "x%=G%:y%=H%:ww%=12:"                                        ; 135a: 78 25 3d... x%=
    equb &e1, &0d,   0, &17, &29, &dd, &f2                            ; 136d: e1 0d 00... ...
    equs "sr:Y%=2:"                                                   ; 1374: 73 72 3a... sr:
    equb &e3                                                          ; 137c: e3          .
    equs "n%=9"                                                       ; 137d: 6e 25 3d... n%=
    equb &b8                                                          ; 1381: b8          .
    equs "12:W%=n%:"                                                  ; 1382: 31 32 3a... 12:
    equb &d6                                                          ; 138b: d6          .
    equs "S%:"                                                        ; 138c: 53 25 3a    S%:
    equb &ed                                                          ; 138f: ed          .
    equs ":Y%=0:"                                                     ; 1390: 3a 59 25... :Y%
    equb &e1, &0d,   0, &18, &0a, &dd, &f2, &72, &3a, &f2, &66, &0d   ; 1396: e1 0d 00... ...
    equb   0, &19                                                     ; 13a2: 00 19       ..
    equs "Xc1%="                                                      ; 13a4: 58 63 31... Xc1
    equb &b3                                                          ; 13a9: b3          .
    equs "(7):c2%="                                                   ; 13aa: 28 37 29... (7)
    equb &b3                                                          ; 13b2: b3          .
    equs "(7):c3%="                                                   ; 13b3: 28 37 29... (7)
    equb &b3                                                          ; 13bb: b3          .
    equs "(7):"                                                       ; 13bc: 28 37 29... (7)
    equb &e7                                                          ; 13c0: e7          .
    equs "c1%=c2%"                                                    ; 13c1: 63 31 25... c1%
    equb &84                                                          ; 13c8: 84          .
    equs "c1%=c3%"                                                    ; 13c9: 63 31 25... c1%
    equb &84                                                          ; 13d0: 84          .
    equs "c2%=c3%:"                                                   ; 13d1: 63 32 25... c2%
    equb &e5, &8d                                                     ; 13d9: e5 8d       ..
    equs "TY@ "                                                       ; 13db: 54 59 40... TY@
    equb &8b, &e7                                                     ; 13df: 8b e7       ..
    equs "s%=100:c2%=0:c3%=4:c1%=6"                                   ; 13e1: 73 25 3d... s%=
    equb &0d,   0, &1a, &3c, &ef                                      ; 13f9: 0d 00 1a... ...
    equs "19,1,c1%;0;19,2,c2%;0;19,3,c3%;0;:"                         ; 13fe: 31 39 2c... 19,
    equb &e7                                                          ; 1420: e7          .
    equs "sc%=10:dc%=4 "                                              ; 1421: 73 63 25... sc%
    equb &8b                                                          ; 142e: 8b          .
    equs "dc%=40"                                                     ; 142f: 64 63 25... dc%
    equb &0d,   0, &1b, &46, &e7                                      ; 1435: 0d 00 1b... ...
    equs "sc%<1"                                                      ; 143a: 73 63 25... sc%
    equb &84                                                          ; 143f: 84          .
    equs "sc%>14:sc%=1:sh%=1:x%=128:a%=0:"                            ; 1440: 73 63 25... sc%
    equb &f2                                                          ; 145f: f2          .
    equs "q(1):"                                                      ; 1460: 71 28 31... q(1
    equb &fb, &33, &3a, &f1, &8a                                      ; 1465: fb 33 3a... .3:
    equs "7,26);:"                                                    ; 146a: 37 2c 32... 7,2
    equb &ef                                                          ; 1471: ef          .
    equs "245,234:"                                                   ; 1472: 32 34 35... 245
    equb &e1, &0d,   0, &1c, &0d, &f2                                 ; 147a: e1 0d 00... ...
    equs "q(sc%):"                                                    ; 1480: 71 28 73... q(s
    equb &e1, &0d,   0, &1d,   7, &dd, &f2, &70, &0d,   0, &1e, &10   ; 1487: e1 0d 00... ...
    equb &e6                                                          ; 1493: e6          .
    equs "0,0:Y%=0:"                                                  ; 1494: 30 2c 30... 0,0
    equb &f2, &34, &0d,   0, &1f, &18, &e7                            ; 149d: f2 34 0d... .4.
    equs "s%=100"                                                     ; 14a4: 73 25 3d... s%=
    equb &80, &b3                                                     ; 14aa: 80 b3       ..
    equs "(dc%)=1:"                                                   ; 14ac: 28 64 63... (dc
    equb &f2, &6a, &67, &0d,   0, &20, &65, &f2                       ; 14b4: f2 6a 67... .jg
    equs "5:W%=ww%:"                                                  ; 14bc: 35 3a 57... 5:W
    equb &e7                                                          ; 14c5: e7          .
    equs "j%=1:"                                                      ; 14c6: 6a 25 3d... j%=
    equb &f2, &33, &3a, &e5, &8d                                      ; 14cb: f2 33 3a... .3:
    equs "Td@ "                                                       ; 14d0: 54 64 40... Td@
    equb &8b                                                          ; 14d4: 8b          .
    equs "xm%=0:"                                                     ; 14d5: 78 6d 25... xm%
    equb &e7, &b0                                                     ; 14db: e7 b0       ..
    equs "x%+4,y%-66)=0"                                              ; 14dd: 78 25 2b... x%+
    equb &80, &b0                                                     ; 14ea: 80 b0       ..
    equs "x%+60,y%-66)=0:x%=x%+mx%:y%=y%-8:df%=df%+1:"                ; 14ec: 78 25 2b... x%+
    equb &e5, &8d                                                     ; 1517: e5 8d       ..
    equs "Td@"                                                        ; 1519: 54 64 40    Td@
    equb &0d,   0, &21, &1a                                           ; 151c: 0d 00 21... ..!
    equs "mx%=0:"                                                     ; 1520: 6d 78 25... mx%
    equb &e7, &a6                                                     ; 1526: e7 a6       ..
    equs "-98"                                                        ; 1528: 2d 39 38    -98
    equb &f2, &31, &20, &8b, &e7, &a6                                 ; 152b: f2 31 20... .1
    equs "-67"                                                        ; 1531: 2d 36 37    -67
    equb &f2, &32, &0d,   0                                           ; 1534: f2 32 0d... .2.
    equs '"', "=df%=0:"                                               ; 1538: 22 3d 64... "=d
    equb &e7, &a6                                                     ; 1540: e7 a6       ..
    equs "-1j%=1:jc%=0:jm%=8:mx%=xm%:"                                ; 1542: 2d 31 6a... -1j
    equb &d4                                                          ; 155d: d4          .
    equs "1,11,y%,12 "                                                ; 155e: 31 2c 31... 1,1
    equb &8b, &e7, &a6                                                ; 1569: 8b e7 a6    ...
    equs "-56"                                                        ; 156c: 2d 35 36    -56
    equb &f2                                                          ; 156f: f2          .
    equs "ure"                                                        ; 1570: 75 72 65    ure
    equb &0d,   0                                                     ; 1573: 0d 00       ..
    equs "#;sf%=y%-66:"                                               ; 1575: 23 3b 73... #;s
    equb &e7                                                          ; 1581: e7          .
    equs "s%=100"                                                     ; 1582: 73 25 3d... s%=
    equb &80, &b0                                                     ; 1588: 80 b0       ..
    equs "x%,sf%)=3"                                                  ; 158a: 78 25 2c... x%,
    equb &80                                                          ; 1593: 80          .
    equs "y%>260:"                                                    ; 1594: 79 25 3e... y%>
    equb &ec                                                          ; 159b: ec          .
    equs "x%,sf%+26:"                                                 ; 159c: 78 25 2c... x%,
    equb &ef                                                          ; 15a6: ef          .
    equs "5,249,4"                                                    ; 15a7: 35 2c 32... 5,2
    equb &0d,   0, &24, &43, &f2, &34, &3a, &d6                       ; 15ae: 0d 00 24... ..$
    equs "S%:"                                                        ; 15b6: 53 25 3a    S%:
    equb &e7                                                          ; 15b9: e7          .
    equs "x%<24"                                                      ; 15ba: 78 25 3c... x%<
    equb &84                                                          ; 15bf: 84          .
    equs "x%>1194"                                                    ; 15c0: 78 25 3e... x%>
    equb &84                                                          ; 15c7: 84          .
    equs "y%>730"                                                     ; 15c8: 79 25 3e... y%>
    equb &84                                                          ; 15ce: 84          .
    equs "y%<228"                                                     ; 15cf: 79 25 3c... y%<
    equb &f2, &6b, &3a, &f2                                           ; 15d5: f2 6b 3a... .k:
    equs "er:"                                                        ; 15d9: 65 72 3a    er:
    equb &e7                                                          ; 15dc: e7          .
    equs "ge%=0"                                                      ; 15dd: 67 65 25... ge%
    equb &e5, &8d                                                     ; 15e2: e5 8d       ..
    equs "T^@ "                                                       ; 15e4: 54 5e 40... T^@
    equb &8b, &e7                                                     ; 15e8: 8b e7       ..
    equs "ge%=1:"                                                     ; 15ea: 67 65 25... ge%
    equb &e1, &0d,   0                                                ; 15f0: e1 0d 00    ...
    equs "%>W%=5:"                                                    ; 15f3: 25 3e 57... %>W
    equb &e7                                                          ; 15fa: e7          .
    equs "a%=1:"                                                      ; 15fb: 61 25 3d... a%=
    equb &f2                                                          ; 1600: f2          .
    equs "a1 "                                                        ; 1601: 61 31 20    a1
    equb &8b, &e7                                                     ; 1604: 8b e7       ..
    equs "a%=2:"                                                      ; 1606: 61 25 3d... a%=
    equb &f2                                                          ; 160b: f2          .
    equs "a2 "                                                        ; 160c: 61 32 20    a2
    equb &8b, &e7                                                     ; 160f: 8b e7       ..
    equs "a%=3:"                                                      ; 1611: 61 25 3d... a%=
    equb &f2                                                          ; 1616: f2          .
    equs "a3 "                                                        ; 1617: 61 33 20    a3
    equb &8b, &e7                                                     ; 161a: 8b e7       ..
    equs "a%=4:"                                                      ; 161c: 61 25 3d... a%=
    equb &f2                                                          ; 1621: f2          .
    equs "a4 "                                                        ; 1622: 61 34 20    a4
    equb &8b, &e7                                                     ; 1625: 8b e7       ..
    equs "a%=5:"                                                      ; 1627: 61 25 3d... a%=
    equb &f2, &61, &35, &0d,   0                                      ; 162c: f2 61 35... .a5
    equs "&Ucr%=cr%+1:"                                               ; 1631: 26 55 63... &Uc
    equb &e7                                                          ; 163d: e7          .
    equs "cr%=4:cr%=0:"                                               ; 163e: 63 72 25... cr%
    equb &f3                                                          ; 164a: f3          .
    equs "be%,du%:"                                                   ; 164b: 62 65 25... be%
    equb &d4                                                          ; 1653: d4          .
    equs "2,-5,be%,du%:"                                              ; 1654: 32 2c 2d... 2,-
    equb &d4                                                          ; 1661: d4          .
    equs "3,-5,be%,du%:nc%=nc%+1:"                                    ; 1662: 33 2c 2d... 3,-
    equb &e7                                                          ; 1679: e7          .
    equs "nc%=70:"                                                    ; 167a: 6e 63 25... nc%
    equb &f2, &65, &72, &0d,   0                                      ; 1681: f2 65 72... .er
    equs "'%W%=ww%:Y%=8:"                                             ; 1686: 27 25 57... '%W
    equb &d6                                                          ; 1694: d6          .
    equs "Q%:"                                                        ; 1695: 51 25 3a    Q%:
    equb &e7                                                          ; 1698: e7          .
    equs "X%<>0"                                                      ; 1699: 58 25 3c... X%<
    equb &84                                                          ; 169e: 84          .
    equs "df%>12:"                                                    ; 169f: 64 66 25... df%
    equb &f2, &75, &76, &0d,   0, &28, &47, &e7                       ; 16a6: f2 75 76... .uv
    equs "ng%=0:m%=m%+1:"                                             ; 16ae: 6e 67 25... ng%
    equb &e7                                                          ; 16bc: e7          .
    equs "m%=11:"                                                     ; 16bd: 6d 25 3d... m%=
    equb &f2                                                          ; 16c3: f2          .
    equs "m:m%=0 "                                                    ; 16c4: 6d 3a 6d... m:m
    equb &8b, &e7                                                     ; 16cb: 8b e7       ..
    equs "sc%=1"                                                      ; 16cd: 73 63 25... sc%
    equb &84                                                          ; 16d2: 84          .
    equs "sc%=13"                                                     ; 16d3: 73 63 25... sc%
    equb &84                                                          ; 16d9: 84          .
    equs "sc%=5"                                                      ; 16da: 73 63 25... sc%
    equb &84                                                          ; 16df: 84          .
    equs "sc%=10:"                                                    ; 16e0: 73 63 25... sc%
    equb &f2                                                          ; 16e7: f2          .
    equs "sp:"                                                        ; 16e8: 73 70 3a    sp:
    equb &e5, &8d                                                     ; 16eb: e5 8d       ..
    equs "T^@"                                                        ; 16ed: 54 5e 40    T^@
    equb &0d,   0, &29,   9, &e5, &8d                                 ; 16f0: 0d 00 29... ..)
    equs "T_@"                                                        ; 16f6: 54 5f 40    T_@
    equb &0d,   0, &2a, &8b, &dd, &f2                                 ; 16f9: 0d 00 2a... ..*
    equs "jg:"                                                        ; 16ff: 6a 67 3a    jg:
    equb &f2                                                          ; 1702: f2          .
    equs "so:"                                                        ; 1703: 73 6f 3a    so:
    equb &ef                                                          ; 1706: ef          .
    equs "19,0,7;0;19,1,0;0;19,2,0;0;19,3,0;0;:"                      ; 1707: 31 39 2c... 19,
    equb &d4                                                          ; 172c: d4          .
    equs "&10,-13,5,6:"                                               ; 172d: 26 31 30... &10
    equb &d4                                                          ; 1739: d4          .
    equs "0,-10,5,6:"                                                 ; 173a: 30 2c 2d... 0,-
    equb &d4                                                          ; 1744: d4          .
    equs "0,-7,6,10:"                                                 ; 1745: 30 2c 2d... 0,-
    equb &f2                                                          ; 174f: f2          .
    equs "w(250):"                                                    ; 1750: 77 28 32... w(2
    equb &ef                                                          ; 1757: ef          .
    equs "19,0,0;0;19,1,c1%;0;19,2,c2%;0;19,3,c3%;0;:"                ; 1758: 31 39 2c... 19,
    equb &e1, &0d,   0, &2b, &54, &dd, &f2                            ; 1783: e1 0d 00... ...
    equs "z(xx%,yy%,ch%):M%=(xx%*64)-4:N%=(1024-(32*yy%))+28:X%=ch"   ; 178a: 7a 28 78... z(x
    equs "%:W%=7:"                                                    ; 17c2: 25 3a 57... %:W
    equb &e7                                                          ; 17c9: e7          .
    equs "ch%=20:M%=M%+4"                                             ; 17ca: 63 68 25... ch%
    equb &0d,   0, &2c, &0d, &d6                                      ; 17d8: 0d 00 2c... ..,
    equs "S%:"                                                        ; 17dd: 53 25 3a    S%:
    equb &d6                                                          ; 17e0: d6          .
    equs "U%:"                                                        ; 17e1: 55 25 3a    U%:
    equb &e1, &0d,   0, &2d, &19, &dd, &f2, &31, &3a, &e7, &b0        ; 17e4: e1 0d 00... ...
    equs "x%-4,y%-8)<>0:"                                             ; 17ef: 78 25 2d... x%-
    equb &e1, &0d,   0, &2e, &27, &e7                                 ; 17fd: e1 0d 00... ...
    equs "di%=9:di%=10:"                                              ; 1803: 64 69 25... di%
    equb &f2                                                          ; 1810: f2          .
    equs "sr:W%=10:"                                                  ; 1811: 73 72 3a... sr:
    equb &e7                                                          ; 181a: e7          .
    equs "g%=1:W%=12"                                                 ; 181b: 67 25 3d... g%=
    equb &0d,   0, &2f, &14                                           ; 1825: 0d 00 2f... ../
    equs "xm%=-8:x%=x%-8:"                                            ; 1829: 78 6d 25... xm%
    equb &e1, &0d,   0, &30, &1a, &dd, &f2, &32, &3a, &e7, &b0        ; 1838: e1 0d 00... ...
    equs "x%+64,y%-8)<>0:"                                            ; 1843: 78 25 2b... x%+
    equb &e1, &0d,   0, &31, &26, &e7                                 ; 1852: e1 0d 00... ...
    equs "di%=10:di%=9:"                                              ; 1858: 64 69 25... di%
    equb &f2                                                          ; 1865: f2          .
    equs "sr:W%=9:"                                                   ; 1866: 73 72 3a... sr:
    equb &e7                                                          ; 186e: e7          .
    equs "g%=1:W%=11"                                                 ; 186f: 67 25 3d... g%=
    equb &0d,   0, &32, &13                                           ; 1879: 0d 00 32... ..2
    equs "xm%=8:x%=x%+8:"                                             ; 187d: 78 6d 25... xm%
    equb &e1, &0d,   0, &33, &32, &dd, &f2, &33, &3a, &e7, &b0        ; 188b: e1 0d 00... ...
    equs "x%+8,y%+4)<>0"                                              ; 1896: 78 25 2b... x%+
    equb &84, &b0                                                     ; 18a3: 84 b0       ..
    equs "x%+56,y%+4)<>0:j%=0:"                                       ; 18a5: 78 25 2b... x%+
    equb &f2                                                          ; 18b9: f2          .
    equs "so:"                                                        ; 18ba: 73 6f 3a    so:
    equb &e1, &0d,   0                                                ; 18bd: e1 0d 00    ...
    equs "4`jc%=jc%+1:y%=y%+jm%:x%=x%+xm%:jc%=jc%+1:"                 ; 18c0: 34 60 6a... 4`j
    equb &e7                                                          ; 18ea: e7          .
    equs "jc%>js%:jm%=-4:"                                            ; 18eb: 6a 63 25... jc%
    equb &e7                                                          ; 18fa: e7          .
    equs "jc%=jt%"                                                    ; 18fb: 6a 63 25... jc%
    equb &84, &b0                                                     ; 1902: 84 b0       ..
    equs "x%+32,y%-66)<>0:j%=0:"                                      ; 1904: 78 25 2b... x%+
    equb &f2                                                          ; 1919: f2          .
    equs "so:"                                                        ; 191a: 73 6f 3a    so:
    equb &e1, &0d,   0, &35,   5, &e1, &0d,   0, &36, &22, &dd, &f2   ; 191d: e1 0d 00... ...
    equs "m:W%=6:Z%=6:"                                               ; 1929: 6d 3a 57... m:W
    equb &d6                                                          ; 1935: d6          .
    equs "T%:"                                                        ; 1936: 54 25 3a    T%:
    equb &e7                                                          ; 1939: e7          .
    equs "K%=1016:"                                                   ; 193a: 4b 25 3d... K%=
    equb &f2, &6d, &73, &0d,   0, &37, &18, &e7                       ; 1942: f2 6d 73... .ms
    equs "sc%=5:W%=8:Z%=6:"                                           ; 194a: 73 63 25... sc%
    equb &d6, &54, &25, &0d,   0, &38,   5, &e1, &0d,   0, &39, &65   ; 195a: d6 54 25... .T%
    equb &dd, &f2                                                     ; 1966: dd f2       ..
    equs "ms:"                                                        ; 1968: 6d 73 3a    ms:
    equb &f7, &8d                                                     ; 196b: f7 8d       ..
    equs "tT@:"                                                       ; 196d: 74 54 40... tT@
    equb &e3                                                          ; 1971: e3          .
    equs "n%=1"                                                       ; 1972: 6e 25 3d... n%=
    equb &b8                                                          ; 1976: b8          .
    equs "140"                                                        ; 1977: 31 34 30    140
    equb &88, &35, &3a, &f3                                           ; 197a: 88 35 3a... .5:
    equs "o%:"                                                        ; 197e: 6f 25 3a    o%:
    equb &d4                                                          ; 1981: d4          .
    equs "1,3,n%,2:"                                                  ; 1982: 31 2c 33... 1,3
    equb &d4                                                          ; 198b: d4          .
    equs "2,2,n%+10,3:"                                               ; 198c: 32 2c 32... 2,2
    equb &ef                                                          ; 1998: ef          .
    equs "19,1,o%;0;19,2,o%-1;0;19,3,o%-2;0;:"                        ; 1999: 31 39 2c... 19,
    equb &e7                                                          ; 19bc: e7          .
    equs "o%=0:"                                                      ; 19bd: 6f 25 3d... o%=
    equb &f7, &8d                                                     ; 19c2: f7 8d       ..
    equs "tT@"                                                        ; 19c4: 74 54 40    tT@
    equb &0d,   0, &3a, &7f, &ed, &3a, &f2                            ; 19c7: 0d 00 3a... ..:
    equs "er:"                                                        ; 19ce: 65 72 3a    er:
    equb &ef                                                          ; 19d1: ef          .
    equs "19,1,c1%;0;19,2,c2%;0;19,3,c3%;0;:"                         ; 19d2: 31 39 2c... 19,
    equb &f2                                                          ; 19f4: f2          .
    equs "so:W%=6:Y%=2:"                                              ; 19f5: 73 6f 3a... so:
    equb &d6                                                          ; 1a02: d6          .
    equs "S%:"                                                        ; 1a03: 53 25 3a    S%:
    equb &f2                                                          ; 1a06: f2          .
    equs "sr:K%=192:"                                                 ; 1a07: 73 72 3a... sr:
    equb &e7                                                          ; 1a11: e7          .
    equs "g%=0:g%=1:X%=25:W%=6:"                                      ; 1a12: 67 25 3d... g%=
    equb &d6                                                          ; 1a27: d6          .
    equs "S%:"                                                        ; 1a28: 53 25 3a    S%:
    equb &d6                                                          ; 1a2b: d6          .
    equs "U%:"                                                        ; 1a2c: 55 25 3a    U%:
    equb &f2                                                          ; 1a2f: f2          .
    equs "g4:js%=45:jt%=90:"                                          ; 1a30: 67 34 3a... g4:
    equb &f2                                                          ; 1a41: f2          .
    equs "mu:"                                                        ; 1a42: 6d 75 3a    mu:
    equb &e1, &0d,   0                                                ; 1a45: e1 0d 00    ...
    equs ";2js%=20:jt%=40:g%=0:X%=24:W%=6:"                           ; 1a48: 3b 32 6a... ;2j
    equb &d6                                                          ; 1a68: d6          .
    equs "S%:"                                                        ; 1a69: 53 25 3a    S%:
    equb &d6                                                          ; 1a6c: d6          .
    equs "U%:"                                                        ; 1a6d: 55 25 3a    U%:
    equb &f2, &34, &3a, &f2                                           ; 1a70: f2 34 3a... .4:
    equs "vx:"                                                        ; 1a74: 76 78 3a    vx:
    equb &e1, &0d,   0, &3c, &1a, &dd, &f2                            ; 1a77: e1 0d 00... ...
    equs "w(n1%):"                                                    ; 1a7e: 77 28 6e... w(n
    equb &e3                                                          ; 1a85: e3          .
    equs "n%=1"                                                       ; 1a86: 6e 25 3d... n%=
    equb &b8                                                          ; 1a8a: b8          .
    equs "n1%:"                                                       ; 1a8b: 6e 31 25... n1%
    equb &ed, &3a, &e1, &0d,   0, &3d, &4c, &dd, &f2                  ; 1a8f: ed 3a e1... .:.
    equs "sp:"                                                        ; 1a98: 73 70 3a    sp:
    equb &e7                                                          ; 1a9b: e7          .
    equs "sc%=1"                                                      ; 1a9c: 73 63 25... sc%
    equb &80                                                          ; 1aa1: 80          .
    equs "x%<68:sh%=12:x%=1142:y%=316:Y%=2:W%=5:"                     ; 1aa2: 78 25 3c... x%<
    equb &d6                                                          ; 1ac8: d6          .
    equs "S%:"                                                        ; 1ac9: 53 25 3a    S%:
    equb &f2                                                          ; 1acc: f2          .
    equs "sr:sc%=8:"                                                  ; 1acd: 73 72 3a... sr:
    equb &f2, &72, &3a, &f2                                           ; 1ad6: f2 72 3a... .r:
    equs "sf:"                                                        ; 1ada: 73 66 3a    sf:
    equb &e1, &0d,   0, &3e, &55, &e7                                 ; 1add: e1 0d 00... ...
    equs "sc%=10"                                                     ; 1ae3: 73 63 25... sc%
    equb &80                                                          ; 1ae9: 80          .
    equs "x%>=1152"                                                   ; 1aea: 78 25 3e... x%>
    equb &80                                                          ; 1af2: 80          .
    equs "y%>480:sh%=14:sc%=9:x%=68:y%=416:Y%=2:W%=5:"                ; 1af3: 79 25 3e... y%>
    equb &d6                                                          ; 1b1e: d6          .
    equs "S%:"                                                        ; 1b1f: 53 25 3a    S%:
    equb &f2                                                          ; 1b22: f2          .
    equs "sr:"                                                        ; 1b23: 73 72 3a    sr:
    equb &f2, &72, &3a, &f2                                           ; 1b26: f2 72 3a... .r:
    equs "sf:a%=2:"                                                   ; 1b2a: 73 66 3a... sf:
    equb &e1, &0d,   0, &3f, &59, &e7                                 ; 1b32: e1 0d 00... ...
    equs "sc%=13"                                                     ; 1b38: 73 63 25... sc%
    equb &80                                                          ; 1b3e: 80          .
    equs "x%>1150"                                                    ; 1b3f: 78 25 3e... x%>
    equb &80                                                          ; 1b46: 80          .
    equs "(y%=288"                                                    ; 1b47: 28 79 25... (y%
    equb &84                                                          ; 1b4e: 84          .
    equs "y%=284):sh%=9:x%=1148:y%=420:Y%=2:W%=5:"                    ; 1b4f: 79 25 3d... y%=
    equb &d6                                                          ; 1b76: d6          .
    equs "S%:"                                                        ; 1b77: 53 25 3a    S%:
    equb &f2                                                          ; 1b7a: f2          .
    equs "sr:sc%=7:"                                                  ; 1b7b: 73 72 3a... sr:
    equb &f2, &72, &3a, &f2                                           ; 1b84: f2 72 3a... .r:
    equs "sf:"                                                        ; 1b88: 73 66 3a    sf:
    equb &e1, &0d,   0, &40, &45, &e7                                 ; 1b8b: e1 0d 00... ...
    equs "sc%=5"                                                      ; 1b91: 73 63 25... sc%
    equb &80                                                          ; 1b96: 80          .
    equs "s%=90"                                                      ; 1b97: 73 25 3d... s%=
    equb &80                                                          ; 1b9c: 80          .
    equs "g%=0:"                                                      ; 1b9d: 67 25 3d... g%=
    equb &ef                                                          ; 1ba2: ef          .
    equs "19,0,7;0;19,1,0;0;19,0,0;0;19,1,3;0;:"                      ; 1ba3: 31 39 2c... 19,
    equb &e7                                                          ; 1bc8: e7          .
    equs "X%=7:"                                                      ; 1bc9: 58 25 3d... X%=
    equb &f2, &76, &69, &0d,   0, &41,   5, &e1, &0d,   0, &42, &88   ; 1bce: f2 76 69... .vi
    equb &dd, &f2                                                     ; 1bda: dd f2       ..
    equs "vi:Y%=2:W%=6:"                                              ; 1bdc: 76 69 3a... vi:
    equb &d6                                                          ; 1be9: d6          .
    equs "S%:W%=7:"                                                   ; 1bea: 53 25 3a... S%:
    equb &d6                                                          ; 1bf2: d6          .
    equs "S%:"                                                        ; 1bf3: 53 25 3a    S%:
    equb &f7, &8d                                                     ; 1bf6: f7 8d       ..
    equs "tT@:s%=100:ng%=1:"                                          ; 1bf8: 74 54 40... tT@
    equb &f2                                                          ; 1c09: f2          .
    equs "sr:"                                                        ; 1c0a: 73 72 3a    sr:
    equb &e3                                                          ; 1c0d: e3          .
    equs "n%=10"                                                      ; 1c0e: 6e 25 3d... n%=
    equb &b8                                                          ; 1c13: b8          .
    equs "100"                                                        ; 1c14: 31 30 30    100
    equb &88, &35, &3a, &e3                                           ; 1c17: 88 35 3a... .5:
    equs "nm%=110"                                                    ; 1c1b: 6e 6d 25... nm%
    equb &b8                                                          ; 1c22: b8          .
    equs "200"                                                        ; 1c23: 32 30 30    200
    equb &88                                                          ; 1c26: 88          .
    equs "n%:"                                                        ; 1c27: 6e 25 3a    n%:
    equb &f3                                                          ; 1c2a: f3          .
    equs "ok%:"                                                       ; 1c2b: 6f 6b 25... ok%
    equb &ef                                                          ; 1c2f: ef          .
    equs "19,1,ok%;0;19,2,ok%;0;19,3,ok%;0;:"                         ; 1c30: 31 39 2c... 19,
    equb &e7                                                          ; 1c52: e7          .
    equs "ok%=0:"                                                     ; 1c53: 6f 6b 25... ok%
    equb &f7, &8d                                                     ; 1c59: f7 8d       ..
    equs "tT@"                                                        ; 1c5b: 74 54 40    tT@
    equb &0d,   0, &43, &7c, &d4                                      ; 1c5e: 0d 00 43... ..C
    equs "1,4,n%+nm%,2:"                                              ; 1c63: 31 2c 34... 1,4
    equb &d4                                                          ; 1c70: d4          .
    equs "2,12,n%+nm%,3:"                                             ; 1c71: 32 2c 31... 2,1
    equb &ed, &2c, &3a, &f2                                           ; 1c7f: ed 2c 3a... .,:
    equs "er:"                                                        ; 1c83: 65 72 3a    er:
    equb &ef                                                          ; 1c86: ef          .
    equs "19,3,4;0;19,2,0;0;19,1,6;0;17,131,17,2:c1%=6:c2%=0:c3%=4"   ; 1c87: 31 39 2c... 19,
    equs ":"                                                          ; 1cbf: 3a          :
    equb &f1, &8a                                                     ; 1cc0: f1 8a       ..
    equs "9,14)"                                                      ; 1cc2: 39 2c 31... 9,1
    equb &c4, &34, &2c, &bd                                           ; 1cc7: c4 34 2c... .4,
    equs "227):"                                                      ; 1ccb: 32 32 37... 227
    equb &fb                                                          ; 1cd0: fb          .
    equs "128:"                                                       ; 1cd1: 31 32 38... 128
    equb &d6                                                          ; 1cd5: d6          .
    equs "V%:"                                                        ; 1cd6: 56 25 3a    V%:
    equb &e1, &0d,   0, &44, &1e, &dd, &f2                            ; 1cd9: e1 0d 00... ...
    equs "a1:Z%=db%:"                                                 ; 1ce0: 61 31 3a... a1:
    equb &e7, &b3                                                     ; 1cea: e7 b3       ..
    equs "(3)<>1:"                                                    ; 1cec: 28 33 29... (3)
    equb &e5, &8d                                                     ; 1cf3: e5 8d       ..
    equs "DG@"                                                        ; 1cf5: 44 47 40    DG@
    equb &0d,   0, &45, &28, &e7                                      ; 1cf8: 0d 00 45... ..E
    equs "db%=6"                                                      ; 1cfd: 64 62 25... db%
    equb &80                                                          ; 1d02: 80          .
    equs "J%>y%:Z%=9 "                                                ; 1d03: 4a 25 3e... J%>
    equb &8b, &e7                                                     ; 1d0e: 8b e7       ..
    equs "db%=6"                                                      ; 1d10: 64 62 25... db%
    equb &80                                                          ; 1d15: 80          .
    equs "J%<y%:Z%=3"                                                 ; 1d16: 4a 25 3c... J%<
    equb &0d,   0, &46, &28, &e7                                      ; 1d20: 0d 00 46... ..F
    equs "db%=4"                                                      ; 1d25: 64 62 25... db%
    equb &80                                                          ; 1d2a: 80          .
    equs "J%>y%:Z%=7 "                                                ; 1d2b: 4a 25 3e... J%>
    equb &8b, &e7                                                     ; 1d36: 8b e7       ..
    equs "db%=4"                                                      ; 1d38: 64 62 25... db%
    equb &80                                                          ; 1d3d: 80          .
    equs "J%<y%:Z%=1"                                                 ; 1d3e: 4a 25 3c... J%<
    equb &0d,   0, &47, &34, &e7                                      ; 1d48: 0d 00 47... ..G
    equs "I%=1152:db%=4:X%=14:"                                       ; 1d4d: 49 25 3d... I%=
    equb &d6                                                          ; 1d61: d6          .
    equs "U% "                                                        ; 1d62: 55 25 20    U%
    equb &8b, &e7                                                     ; 1d65: 8b e7       ..
    equs "I%=64:db%=6:X%=13:"                                         ; 1d67: 49 25 3d... I%=
    equb &d6, &55, &25, &0d,   0, &48,   9, &d6                       ; 1d79: d6 55 25... .U%
    equs "T%:"                                                        ; 1d81: 54 25 3a    T%:
    equb &e1, &0d,   0, &49, &1e, &dd, &f2                            ; 1d84: e1 0d 00... ...
    equs "a2:axm%=3:"                                                 ; 1d8b: 61 32 3a... a2:
    equb &e7                                                          ; 1d95: e7          .
    equs "I%>x%:axm%=-3"                                              ; 1d96: 49 25 3e... I%>
    equb &0d,   0, &4a, &19                                           ; 1da3: 0d 00 4a... ..J
    equs "aym%=2:"                                                    ; 1da7: 61 79 6d... aym
    equb &e7                                                          ; 1dae: e7          .
    equs "J%>y%:aym%=-4"                                              ; 1daf: 4a 25 3e... J%>
    equb &0d,   0, &4b, &1f                                           ; 1dbc: 0d 00 4b... ..K
    equs "I%=I%+axm%:J%=J%+aym%:"                                     ; 1dc0: 49 25 3d... I%=
    equb &d6                                                          ; 1dd6: d6          .
    equs "S%:"                                                        ; 1dd7: 53 25 3a    S%:
    equb &e1, &0d,   0, &4c, &43, &dd, &f2                            ; 1dda: e1 0d 00... ...
    equs "a4:Z%=ad%(ah%):ak%=ak%+1:"                                  ; 1de1: 61 34 3a... a4:
    equb &e7                                                          ; 1dfa: e7          .
    equs "ak%=40:ak%=0:ah%=ah%+1:"                                    ; 1dfb: 61 6b 25... ak%
    equb &e7                                                          ; 1e12: e7          .
    equs "ah%=5:ah%=1"                                                ; 1e13: 61 68 25... ah%
    equb &0d,   0, &4d,   9, &d6                                      ; 1e1e: 0d 00 4d... ..M
    equs "T%:"                                                        ; 1e23: 54 25 3a    T%:
    equb &e1, &0d,   0, &4e, &43, &dd, &f2                            ; 1e26: e1 0d 00... ...
    equs "a3:Z%=ed%(ah%):ak%=ak%+1:"                                  ; 1e2d: 61 33 3a... a3:
    equb &e7                                                          ; 1e46: e7          .
    equs "ak%=30:ak%=0:ah%=ah%+1:"                                    ; 1e47: 61 6b 25... ak%
    equb &e7                                                          ; 1e5e: e7          .
    equs "ah%=7:ah%=1"                                                ; 1e5f: 61 68 25... ah%
    equb &0d,   0, &4f,   9, &d6                                      ; 1e6a: 0d 00 4f... ..O
    equs "T%:"                                                        ; 1e6f: 54 25 3a    T%:
    equb &e1, &0d,   0, &50, &23, &dd, &f2                            ; 1e72: e1 0d 00... ...
    equs "a5:Z%=ed%:"                                                 ; 1e79: 61 35 3a... a5:
    equb &e7                                                          ; 1e83: e7          .
    equs "ed%=6"                                                      ; 1e84: 65 64 25... ed%
    equb &80                                                          ; 1e89: 80          .
    equs "I%>688:ed%=4"                                               ; 1e8a: 49 25 3e... I%>
    equb &0d,   0, &51, &17, &e7                                      ; 1e96: 0d 00 51... ..Q
    equs "ed%=4"                                                      ; 1e9b: 65 64 25... ed%
    equb &80                                                          ; 1ea0: 80          .
    equs "I%<644:ed%=6"                                               ; 1ea1: 49 25 3c... I%<
    equb &0d,   0, &52,   9, &d6                                      ; 1ead: 0d 00 52... ..R
    equs "T%:"                                                        ; 1eb2: 54 25 3a    T%:
    equb &e1, &0d,   0, &53, &2c, &dd, &f2, &73, &3a, &d6             ; 1eb5: e1 0d 00... ...
    equs "V%:"                                                        ; 1ebf: 56 25 3a    V%:
    equb &f2, &66, &3a, &ef                                           ; 1ec2: f2 66 3a... .f:
    equs "28,4,30,15,28,17,128,12,26:"                                ; 1ec6: 32 38 2c... 28,
    equb &e1, &0d,   0, &54, &3e, &fb, &33, &3a, &e3                  ; 1ee1: e1 0d 00... ...
    equs "n%=28"                                                      ; 1eea: 6e 25 3d... n%=
    equb &b8                                                          ; 1eef: b8          .
    equs "30:"                                                        ; 1ef0: 33 30 3a    30:
    equb &f1, &8a                                                     ; 1ef3: f1 8a       ..
    equs "1,n%)"                                                      ; 1ef5: 31 2c 6e... 1,n
    equb &c4, &32, &2c, &bd                                           ; 1efa: c4 32 2c... .2,
    equs "(259-n%));"                                                 ; 1efe: 28 32 35... (25
    equb &8a                                                          ; 1f08: 8a          .
    equs "17,n%)"                                                     ; 1f09: 31 37 2c... 17,
    equb &c4, &32, &2c, &bd                                           ; 1f0f: c4 32 2c... .2,
    equs "(259-n%)):"                                                 ; 1f13: 28 32 35... (25
    equb &ed, &3a, &e1, &0d,   0, &55, &ad, &dd, &f2                  ; 1f1d: ed 3a e1... .:.
    equs "uvii:"                                                      ; 1f26: 75 76 69... uvi
    equb &d6                                                          ; 1f2b: d6          .
    equs "V%:os%=&FFEE:"                                              ; 1f2c: 56 25 3a... V%:
    equb &f2                                                          ; 1f39: f2          .
    equs "cc:"                                                        ; 1f3a: 63 63 3a    cc:
    equb &de                                                          ; 1f3d: de          .
    equs "ad%(4),ed%(6),tc%(5):ad%(1)=3:ad%(2)=9:ad%(3)=7:ad%(4)=1"   ; 1f3e: 61 64 25... ad%
    equs ":ed%(1)=3:ed%(2)=6:ed%(3)=9:ed%(4)=7:ed%(5)=4:ed%(6)=1:"    ; 1f76: 3a 65 64... :ed
    equb &ef                                                          ; 1fad: ef          .
    equs "17,3,17,128,28,0,30,19,28,12,26"                            ; 1fae: 31 37 2c... 17,
    equb &0d,   0, &56, &49, &e3                                      ; 1fcd: 0d 00 56... ..V
    equs "n%=28"                                                      ; 1fd2: 6e 25 3d... n%=
    equb &b8                                                          ; 1fd7: b8          .
    equs "30:"                                                        ; 1fd8: 33 30 3a    30:
    equb &e3                                                          ; 1fdb: e3          .
    equs "wn%=0"                                                      ; 1fdc: 77 6e 25... wn%
    equb &b8, &32, &3a, &ef                                           ; 1fe1: b8 32 3a... .2:
    equs "31,wn%,n%,(229+wn%),31,(wn%+17),n%,(229+wn%):"              ; 1fe5: 33 31 2c... 31,
    equb &ed, &2c, &3a, &e1, &0d,   0, &57, &24, &dd, &f2, &66, &3a   ; 2012: ed 2c 3a... .,:
    equb &ef                                                          ; 201e: ef          .
    equs "28,0,26,19,9,17,128,12,26:"                                 ; 201f: 32 38 2c... 28,
    equb &e1, &0d,   0, &58, &6c, &dd, &f2                            ; 2039: e1 0d 00... ...
    equs "q(b1%):fb%=&3508+(180*b1%):fb$="                            ; 2040: 71 28 62... q(b
    equb &c3                                                          ; 205f: c3          .
    equs "~fb%:b1$=", '"', "&", '"', "+"                              ; 2060: 7e 66 62... ~fb
    equb &c1                                                          ; 206d: c1          .
    equs "fb$,3,4):b2$=", '"', "&", '"', "+"                          ; 206e: 66 62 24... fb$
    equb &c1                                                          ; 207f: c1          .
    equs "fb$,1,2):aa%="                                              ; 2080: 66 62 24... fb$
    equb &a0                                                          ; 208d: a0          .
    equs "(b1$):bb%="                                                 ; 208e: 28 62 31... (b1
    equb &a0                                                          ; 2098: a0          .
    equs "(b2$):"                                                     ; 2099: 28 62 32... (b2
    equb &f1, &8a                                                     ; 209f: f1 8a       ..
    equs "0,9);"                                                      ; 20a1: 30 2c 39... 0,9
    equb &0d,   0                                                     ; 20a6: 0d 00       ..
    equs "YJs0%=?&70:s1%=?&71:s2%=?&72:s3%=?&73:?&70=aa%:?&71=bb%:"   ; 20a8: 59 4a 73... YJs
    equs "?&72=226:?&73=30"                                           ; 20e0: 3f 26 37... ?&7
    equb &0d,   0, &5a, &2a, &d6                                      ; 20f0: 0d 00 5a... ..Z
    equs "s:?&70=s0%:?&71=s1%:?&72=s2%:?&73=s3%"                      ; 20f5: 73 3a 3f... s:?
    equb &0d,   0, &5b, &2b, &e7                                      ; 211a: 0d 00 5b... ..[
    equs "a%=2:I%=608:J%=672:W%=5:Y%=0:"                              ; 211f: 61 25 3d... a%=
    equb &d6                                                          ; 213c: d6          .
    equs "S%:"                                                        ; 213d: 53 25 3a    S%:
    equb &e5, &8d                                                     ; 2140: e5 8d       ..
    equs "D]@"                                                        ; 2142: 44 5d 40    D]@
    equb &0d,   0                                                     ; 2145: 0d 00       ..
    equs "\;db%=6:"                                                   ; 2147: 5c 3b 64... \;d
    equb &e7                                                          ; 214f: e7          .
    equs "a%>0:I%=291:J%=480:W%=5:Y%=0:"                              ; 2150: 61 25 3e... a%>
    equb &d6                                                          ; 216d: d6          .
    equs "S%:"                                                        ; 216e: 53 25 3a    S%:
    equb &e7                                                          ; 2171: e7          .
    equs "a%=1:X%=13:"                                                ; 2172: 61 25 3d... a%=
    equb &d6, &55, &25, &0d,   0, &5d, &25, &e7                       ; 217d: d6 55 25... .U%
    equs "sc%=2"                                                      ; 2185: 73 63 25... sc%
    equb &80                                                          ; 218a: 80          .
    equs "s%=80:a%=3:X%=26:"                                          ; 218b: 73 25 3d... s%=
    equb &d6                                                          ; 219c: d6          .
    equs "U%:"                                                        ; 219d: 55 25 3a    U%:
    equb &e5, &8d                                                     ; 21a0: e5 8d       ..
    equs "Dc@"                                                        ; 21a2: 44 63 40    Dc@
    equb &0d,   0, &5e, &23, &e7                                      ; 21a5: 0d 00 5e... ..^
    equs "sc%=5"                                                      ; 21aa: 73 63 25... sc%
    equb &80                                                          ; 21af: 80          .
    equs "s%=90:a%=0:Y%=2:"                                           ; 21b0: 73 25 3d... s%=
    equb &d6                                                          ; 21c0: d6          .
    equs "S%:Y%=0"                                                    ; 21c1: 53 25 3a... S%:
    equb &0d,   0, &5f, &13, &e7                                      ; 21c8: 0d 00 5f... .._
    equs "a%=2:X%=15:"                                                ; 21cd: 61 25 3d... a%=
    equb &d6, &55, &25, &0d,   0, &60, &13, &e7                       ; 21d8: d6 55 25... .U%
    equs "a%=3:X%=16:"                                                ; 21e0: 61 25 3d... a%=
    equb &d6, &55, &25, &0d,   0, &61, &13, &e7                       ; 21eb: d6 55 25... .U%
    equs "a%=4:X%=22:"                                                ; 21f3: 61 25 3d... a%=
    equb &d6, &55, &25, &0d,   0, &62, &5f, &e7                       ; 21fe: d6 55 25... .U%
    equs "a%=5:Y%=2:"                                                 ; 2206: 61 25 3d... a%=
    equb &d6                                                          ; 2210: d6          .
    equs "S%:I%=640:J%=316:Y%=0:"                                     ; 2211: 53 25 3a... S%:
    equb &d6                                                          ; 2227: d6          .
    equs "S%:ed%=6:"                                                  ; 2228: 53 25 3a... S%:
    equb &e7                                                          ; 2231: e7          .
    equs "s%>70"                                                      ; 2232: 73 25 3e... s%>
    equb &80                                                          ; 2237: 80          .
    equs "s%<100:X%=19:"                                              ; 2238: 73 25 3c... s%<
    equb &d6                                                          ; 2245: d6          .
    equs "U% "                                                        ; 2246: 55 25 20    U%
    equb &8b, &e7                                                     ; 2249: 8b e7       ..
    equs "a%=5"                                                       ; 224b: 61 25 3d... a%=
    equb &80                                                          ; 224f: 80          .
    equs "s%=100:X%=27:"                                              ; 2250: 73 25 3d... s%=
    equb &d6, &55, &25, &0d,   0                                      ; 225d: d6 55 25... .U%
    equs "cXak%=0:ah%=1:W%=2:Y%=1:"                                   ; 2262: 63 58 61... cXa
    equb &e7                                                          ; 227a: e7          .
    equs "sc%=9:W%=7:M%=1035:N%=692:"                                 ; 227b: 73 63 25... sc%
    equb &d6                                                          ; 2295: d6          .
    equs "S%:X%=17:"                                                  ; 2296: 53 25 3a... S%:
    equb &d6                                                          ; 229f: d6          .
    equs "U%:"                                                        ; 22a0: 55 25 3a    U%:
    equb &e7                                                          ; 22a3: e7          .
    equs "tc%(5)=0:"                                                  ; 22a4: 74 63 25... tc%
    equb &f2                                                          ; 22ad: f2          .
    equs "z(2,14,18)"                                                 ; 22ae: 7a 28 32... z(2
    equb &0d,   0, &64, &24, &e7                                      ; 22b8: 0d 00 64... ..d
    equs "sc%=6:"                                                     ; 22bd: 73 63 25... sc%
    equb &f2                                                          ; 22c3: f2          .
    equs "z(18,15,21):"                                               ; 22c4: 7a 28 31... z(1
    equb &f2                                                          ; 22d0: f2          .
    equs "z(18,19,21)"                                                ; 22d1: 7a 28 31... z(1
    equb &0d,   0, &65, &1e, &e7                                      ; 22dc: 0d 00 65... ..e
    equs "sc%=10"                                                     ; 22e1: 73 63 25... sc%
    equb &80                                                          ; 22e7: 80          .
    equs "s%>70:"                                                     ; 22e8: 73 25 3e... s%>
    equb &f1, &8a                                                     ; 22ee: f1 8a       ..
    equs "10,26)", '"', "  ", '"'                                     ; 22f0: 31 30 2c... 10,
    equb &0d,   0, &66, &1c, &e7                                      ; 22fa: 0d 00 66... ..f
    equs "sc%=5"                                                      ; 22ff: 73 63 25... sc%
    equb &80                                                          ; 2304: 80          .
    equs "s%>80:"                                                     ; 2305: 73 25 3e... s%>
    equb &f1, &8a                                                     ; 230b: f1 8a       ..
    equs "9,14)", '"', "  ", '"'                                      ; 230d: 39 2c 31... 9,1
    equb &0d,   0, &67, &28, &e7                                      ; 2316: 0d 00 67... ..g
    equs "sc%=13"                                                     ; 231b: 73 63 25... sc%
    equb &80                                                          ; 2321: 80          .
    equs "s%=60:"                                                     ; 2322: 73 25 3d... s%=
    equb &f1, &8a                                                     ; 2328: f1 8a       ..
    equs "19,17)"                                                     ; 232a: 31 39 2c... 19,
    equb &c4                                                          ; 2330: c4          .
    equs "3,", '"', " ", '"', "+"                                     ; 2331: 33 2c 22... 3,"
    equb &bd, &38, &2b, &bd                                           ; 2337: bd 38 2b... .8+
    equs "10)"                                                        ; 233b: 31 30 29    10)
    equb &0d,   0, &68, &2c, &e7                                      ; 233e: 0d 00 68... ..h
    equs "sc%=1:"                                                     ; 2343: 73 63 25... sc%
    equb &f2                                                          ; 2349: f2          .
    equs "z(9,12,23):"                                                ; 234a: 7a 28 39... z(9
    equb &e7                                                          ; 2355: e7          .
    equs "tc%(1)=0:"                                                  ; 2356: 74 63 25... tc%
    equb &f2                                                          ; 235f: f2          .
    equs "z(2,12,17)"                                                 ; 2360: 7a 28 32... z(2
    equb &0d,   0, &69, &2c, &e7                                      ; 236a: 0d 00 69... ..i
    equs "sc%=7:"                                                     ; 236f: 73 63 25... sc%
    equb &f2                                                          ; 2375: f2          .
    equs "z(6,21,23):"                                                ; 2376: 7a 28 36... z(6
    equb &e7                                                          ; 2381: e7          .
    equs "tc%(2)=0:"                                                  ; 2382: 74 63 25... tc%
    equb &f2                                                          ; 238b: f2          .
    equs "z(2,11,17)"                                                 ; 238c: 7a 28 32... z(2
    equb &0d,   0, &6a, &16, &e7                                      ; 2396: 0d 00 6a... ..j
    equs "sc%=2:"                                                     ; 239b: 73 63 25... sc%
    equb &f2                                                          ; 23a1: f2          .
    equs "z(1,23,20)"                                                 ; 23a2: 7a 28 31... z(1
    equb &0d,   0, &6b, &30, &e7                                      ; 23ac: 0d 00 6b... ..k
    equs "sc%=8:"                                                     ; 23b1: 73 63 25... sc%
    equb &f2                                                          ; 23b7: f2          .
    equs "z(11,23,23):"                                               ; 23b8: 7a 28 31... z(1
    equb &f2                                                          ; 23c4: f2          .
    equs "z(9,21,23):"                                                ; 23c5: 7a 28 39... z(9
    equb &f2                                                          ; 23d0: f2          .
    equs "z(13,24,23)"                                                ; 23d1: 7a 28 31... z(1
    equb &0d,   0, &6c, &5e, &e7                                      ; 23dc: 0d 00 6c... ..l
    equs "sc%=14:"                                                    ; 23e1: 73 63 25... sc%
    equb &f2                                                          ; 23e8: f2          .
    equs "z(8,20,21):"                                                ; 23e9: 7a 28 38... z(8
    equb &f2                                                          ; 23f4: f2          .
    equs "z(11,20,20):"                                               ; 23f5: 7a 28 31... z(1
    equb &ef                                                          ; 2401: ef          .
    equs "17,131,17,2:"                                               ; 2402: 31 37 2c... 17,
    equb &f1, &8a                                                     ; 240e: f1 8a       ..
    equs "0,26)"                                                      ; 2410: 30 2c 32... 0,2
    equb &c4                                                          ; 2415: c4          .
    equs "20,"                                                        ; 2416: 32 30 2c    20,
    equb &bd                                                          ; 2419: bd          .
    equs "231):"                                                      ; 241a: 32 33 31... 231
    equb &fb                                                          ; 241f: fb          .
    equs "128:"                                                       ; 2420: 31 32 38... 128
    equb &e7                                                          ; 2424: e7          .
    equs "tc%(4)=0:"                                                  ; 2425: 74 63 25... tc%
    equb &f2                                                          ; 242e: f2          .
    equs "z(12,25,17)"                                                ; 242f: 7a 28 31... z(1
    equb &0d,   0, &6d, &2f, &e7                                      ; 243a: 0d 00 6d... ..m
    equs "sc%=12:"                                                    ; 243f: 73 63 25... sc%
    equb &f2                                                          ; 2446: f2          .
    equs "z(1,15,20):"                                                ; 2447: 7a 28 31... z(1
    equb &f2                                                          ; 2452: f2          .
    equs "z(1,18,20):"                                                ; 2453: 7a 28 31... z(1
    equb &f2                                                          ; 245e: f2          .
    equs "z(1,21,20)"                                                 ; 245f: 7a 28 31... z(1
    equb &0d,   0, &6e, &24, &e7                                      ; 2469: 0d 00 6e... ..n
    equs "sc%=13:"                                                    ; 246e: 73 63 25... sc%
    equb &f2                                                          ; 2475: f2          .
    equs "z(7,21,23):"                                                ; 2476: 7a 28 37... z(7
    equb &f2                                                          ; 2481: f2          .
    equs "z(12,21,23)"                                                ; 2482: 7a 28 31... z(1
    equb &0d,   0, &6f, &40, &e7                                      ; 248d: 0d 00 6f... ..o
    equs "sc%=5"                                                      ; 2492: 73 63 25... sc%
    equb &80                                                          ; 2497: 80          .
    equs "s%=90:M%=608:N%=512:W%=7:"                                  ; 2498: 73 25 3d... s%=
    equb &d6                                                          ; 24b1: d6          .
    equs "S%:X%=17:"                                                  ; 24b2: 53 25 3a... S%:
    equb &d6                                                          ; 24bb: d6          .
    equs "U%:"                                                        ; 24bc: 55 25 3a    U%:
    equb &e7                                                          ; 24bf: e7          .
    equs "g%=1:Y%=2:"                                                 ; 24c0: 67 25 3d... g%=
    equb &d6, &53, &25, &0d,   0, &70, &20, &e7                       ; 24ca: d6 53 25... .S%
    equs "sc%=5"                                                      ; 24d2: 73 63 25... sc%
    equb &80                                                          ; 24d7: 80          .
    equs "tc%(3)=0:"                                                  ; 24d8: 74 63 25... tc%
    equb &f2                                                          ; 24e1: f2          .
    equs "z(18,24,17)"                                                ; 24e2: 7a 28 31... z(1
    equb &0d,   0, &71,   5, &e1, &0d,   0, &72, &22, &dd, &f2, &6b   ; 24ed: 0d 00 71... ..q
    equb &3a, &e7                                                     ; 24f9: 3a e7       :.
    equs "sc%=10"                                                     ; 24fb: 73 63 25... sc%
    equb &80                                                          ; 2501: 80          .
    equs "y%<228:"                                                    ; 2502: 79 25 3c... y%<
    equb &f2                                                          ; 2509: f2          .
    equs "es:ge%=1:"                                                  ; 250a: 65 73 3a... es:
    equb &e1, &0d,   0, &73, &8d                                      ; 2513: e1 0d 00... ...
    equs "W%=5:Y%=2:"                                                 ; 2518: 57 25 3d... W%=
    equb &d6                                                          ; 2522: d6          .
    equs "S%:"                                                        ; 2523: 53 25 3a    S%:
    equb &e3                                                          ; 2526: e3          .
    equs "n%=9"                                                       ; 2527: 6e 25 3d... n%=
    equb &b8                                                          ; 252b: b8          .
    equs "12:W%=n%:"                                                  ; 252c: 31 32 3a... 12:
    equb &d6                                                          ; 2535: d6          .
    equs "S%:"                                                        ; 2536: 53 25 3a    S%:
    equb &ed, &3a, &e7                                                ; 2539: ed 3a e7    .:.
    equs "y%>730:y%=224:sh%=sh%-5 "                                   ; 253c: 79 25 3e... y%>
    equb &8b, &e7                                                     ; 2554: 8b e7       ..
    equs "y%<228:y%=728:sh%=sh%+5 "                                   ; 2556: 79 25 3c... y%<
    equb &8b, &e7                                                     ; 256e: 8b e7       ..
    equs "x%>1194:x%=24:sh%=sh%+1 "                                   ; 2570: 78 25 3e... x%>
    equb &8b, &e7                                                     ; 2588: 8b e7       ..
    equs "x%<24:x%=1194:sh%=sh%-1"                                    ; 258a: 78 25 3c... x%<
    equb &0d,   0, &74, &3d, &f7, &8d                                 ; 25a1: 0d 00 74... ..t
    equs "tR@:"                                                       ; 25a7: 74 52 40... tR@
    equb &e3                                                          ; 25ab: e3          .
    equs "n%=1"                                                       ; 25ac: 6e 25 3d... n%=
    equb &b8                                                          ; 25b0: b8          .
    equs "sh%:"                                                       ; 25b1: 73 68 25... sh%
    equb &f3                                                          ; 25b5: f3          .
    equs "sc%:"                                                       ; 25b6: 73 63 25... sc%
    equb &ed, &3a, &f7, &8d                                           ; 25ba: ed 3a f7... .:.
    equs "tS@:"                                                       ; 25be: 74 53 40... tS@
    equb &e3                                                          ; 25c2: e3          .
    equs "n%=1"                                                       ; 25c3: 6e 25 3d... n%=
    equb &b8                                                          ; 25c7: b8          .
    equs "sc%:"                                                       ; 25c8: 73 63 25... sc%
    equb &f3                                                          ; 25cc: f3          .
    equs "a%:"                                                        ; 25cd: 61 25 3a    a%:
    equb &ed, &3a, &e7                                                ; 25d0: ed 3a e7    .:.
    equs "s%=100:a%=2"                                                ; 25d3: 73 25 3d... s%=
    equb &0d,   0, &75, &16, &e7                                      ; 25de: 0d 00 75... ..u
    equs "sc%=10"                                                     ; 25e3: 73 63 25... sc%
    equb &80                                                          ; 25e9: 80          .
    equs "s%>70:a%=5"                                                 ; 25ea: 73 25 3e... s%>
    equb &0d,   0, &76,   8, &f2, &72, &3a, &e1, &0d,   0, &77, &4c   ; 25f4: 0d 00 76... ..v
    equb &dd, &f2                                                     ; 2600: dd f2       ..
    equs "uv:"                                                        ; 2602: 75 76 3a    uv:
    equb &e7                                                          ; 2605: e7          .
    equs "X%=5:"                                                      ; 2606: 58 25 3d... X%=
    equb &e5, &8d                                                     ; 260b: e5 8d       ..
    equs "D|@ "                                                       ; 260d: 44 7c 40... D|@
    equb &8b, &e7                                                     ; 2611: 8b e7       ..
    equs "X%=5"                                                       ; 2613: 58 25 3d... X%=
    equb &84                                                          ; 2617: 84          .
    equs "(X%=7"                                                      ; 2618: 28 58 25... (X%
    equb &80                                                          ; 261d: 80          .
    equs "sc%<>1"                                                     ; 261e: 73 63 25... sc%
    equb &80                                                          ; 2624: 80          .
    equs "sc%<>5"                                                     ; 2625: 73 63 25... sc%
    equb &80                                                          ; 262b: 80          .
    equs "sc%<>9"                                                     ; 262c: 73 63 25... sc%
    equb &80                                                          ; 2632: 80          .
    equs "sc%<>14"                                                    ; 2633: 73 63 25... sc%
    equb &80                                                          ; 263a: 80          .
    equs "sc%<>7):"                                                   ; 263b: 73 63 25... sc%
    equb &e5, &8d                                                     ; 2643: e5 8d       ..
    equs "D|@"                                                        ; 2645: 44 7c 40    D|@
    equb &0d,   0, &78, &57, &e7                                      ; 2648: 0d 00 78... ..x
    equs "df%>1:"                                                     ; 264d: 64 66 25... df%
    equb &e5, &8d                                                     ; 2653: e5 8d       ..
    equs "D|@ "                                                       ; 2655: 44 7c 40... D|@
    equb &8b, &e7                                                     ; 2659: 8b e7       ..
    equs "sc%=1:tt%=1 "                                               ; 265b: 73 63 25... sc%
    equb &8b, &e7                                                     ; 2667: 8b e7       ..
    equs "sc%=7:tt%=2 "                                               ; 2669: 73 63 25... sc%
    equb &8b, &e7                                                     ; 2675: 8b e7       ..
    equs "sc%=5:tt%=3 "                                               ; 2677: 73 63 25... sc%
    equb &8b, &e7                                                     ; 2683: 8b e7       ..
    equs "sc%=14:tt%=4 "                                              ; 2685: 73 63 25... sc%
    equb &8b, &e7                                                     ; 2692: 8b e7       ..
    equs "sc%=9:tt%=5"                                                ; 2694: 73 63 25... sc%
    equb &0d,   0, &79, &21, &e7                                      ; 269f: 0d 00 79... ..y
    equs "tc%(tt%)=1:"                                                ; 26a4: 74 63 25... tc%
    equb &e5, &8d                                                     ; 26af: e5 8d       ..
    equs "D}@ "                                                       ; 26b1: 44 7d 40... D}@
    equb &8b                                                          ; 26b5: 8b          .
    equs "tc%(tt%)=1"                                                 ; 26b6: 74 63 25... tc%
    equb &0d,   0, &7a, &8f, &f2                                      ; 26c0: 0d 00 7a... ..z
    equs "so:"                                                        ; 26c5: 73 6f 3a    so:
    equb &f2                                                          ; 26c8: f2          .
    equs "w(100):"                                                    ; 26c9: 77 28 31... w(1
    equb &d4                                                          ; 26d0: d4          .
    equs "1,6,20,4:"                                                  ; 26d1: 31 2c 36... 1,6
    equb &ef                                                          ; 26da: ef          .
    equs "19,0,7;0;:s%=s%+20:ec%=50:"                                 ; 26db: 31 39 2c... 19,
    equb &f2                                                          ; 26f5: f2          .
    equs "w(150):"                                                    ; 26f6: 77 28 31... w(1
    equb &ef                                                          ; 26fd: ef          .
    equs "19,0,0;0;:"                                                 ; 26fe: 31 39 2c... 19,
    equb &e7                                                          ; 2708: e7          .
    equs "sc%=9:s%=s%-10:"                                            ; 2709: 73 63 25... sc%
    equb &fb, &31, &3a, &f1, &8a                                      ; 2718: fb 31 3a... .1:
    equs "ex%,5)"                                                     ; 271d: 65 78 25... ex%
    equb &bd                                                          ; 2723: bd          .
    equs "246:ex%=16:"                                                ; 2724: 32 34 36... 246
    equb &ef                                                          ; 272f: ef          .
    equs "17,0,17,131:"                                               ; 2730: 31 37 2c... 17,
    equb &f1, &8a                                                     ; 273c: f1 8a       ..
    equs "16,5)"                                                      ; 273e: 31 36 2c... 16,
    equb &bd                                                          ; 2743: bd          .
    equs "224:"                                                       ; 2744: 32 32 34... 224
    equb &ef                                                          ; 2748: ef          .
    equs "17,128"                                                     ; 2749: 31 37 2c... 17,
    equb &0d,   0, &7b,   5, &e1, &0d,   0, &7c, &1c, &e7             ; 274f: 0d 00 7b... ..{
    equs "df%>1:"                                                     ; 2759: 64 66 25... df%
    equb &d4                                                          ; 275f: d4          .
    equs "1,11,ec%,2:"                                                ; 2760: 31 2c 31... 1,1
    equb &e5, &8d                                                     ; 276b: e5 8d       ..
    equs "D~@"                                                        ; 276d: 44 7e 40    D~@
    equb &0d,   0, &7d, &49, &e7                                      ; 2770: 0d 00 7d... ..}
    equs "a%=2"                                                       ; 2775: 61 25 3d... a%=
    equb &80                                                          ; 2779: 80          .
    equs "g%=1"                                                       ; 277a: 67 25 3d... g%=
    equb &80                                                          ; 277e: 80          .
    equs "X%=5:"                                                      ; 277f: 58 25 3d... X%=
    equb &e1, &20, &8b, &f2                                           ; 2784: e1 20 8b... . .
    equs "so:"                                                        ; 2788: 73 6f 3a    so:
    equb &e7                                                          ; 278b: e7          .
    equs "a%=2"                                                       ; 278c: 61 25 3d... a%=
    equb &d4                                                          ; 2790: d4          .
    equs "1,9,ec%,2 "                                                 ; 2791: 31 2c 39... 1,9
    equb &8b, &e7                                                     ; 279b: 8b e7       ..
    equs "X%=7:"                                                      ; 279d: 58 25 3d... X%=
    equb &d4                                                          ; 27a2: d4          .
    equs "1,8,ec%,4 "                                                 ; 27a3: 31 2c 38... 1,8
    equb &8b, &d4                                                     ; 27ad: 8b d4       ..
    equs "1,12,ec%,5"                                                 ; 27af: 31 2c 31... 1,1
    equb &0d,   0                                                     ; 27b9: 0d 00       ..
    equs "~hec%=ec%-1:"                                               ; 27bb: 7e 68 65... ~he
    equb &e7                                                          ; 27c7: e7          .
    equs "ec%=0:ec%=25:ex%=ex%-1:"                                    ; 27c8: 65 63 25... ec%
    equb &ef                                                          ; 27df: ef          .
    equs "17,0,17,131:"                                               ; 27e0: 31 37 2c... 17,
    equb &f1, &8a                                                     ; 27ec: f1 8a       ..
    equs "ex%,5)"                                                     ; 27ee: 65 78 25... ex%
    equb &bd                                                          ; 27f4: bd          .
    equs "224:"                                                       ; 27f5: 32 32 34... 224
    equb &ef                                                          ; 27f9: ef          .
    equs "17,128,17,1:"                                               ; 27fa: 31 37 2c... 17,
    equb &f1, &8a                                                     ; 2806: f1 8a       ..
    equs "ex%+1,5)"                                                   ; 2808: 65 78 25... ex%
    equb &bd                                                          ; 2810: bd          .
    equs "246:"                                                       ; 2811: 32 34 36... 246
    equb &e7                                                          ; 2815: e7          .
    equs "ex%=3:ge%=1"                                                ; 2816: 65 78 25... ex%
    equb &0d,   0, &7f,   5, &e1, &0d,   0, &80, &12, &dd, &f2        ; 2821: 0d 00 7f... ...
    equs "mu:"                                                        ; 282c: 6d 75 3a    mu:
    equb &e7                                                          ; 282f: e7          .
    equs "sc%<>5:"                                                    ; 2830: 73 63 25... sc%
    equb &e1, &0d,   0, &81, &1d, &e7                                 ; 2837: e1 0d 00... ...
    equs "s%<90:"                                                     ; 283d: 73 25 3c... s%<
    equb &e1, &20, &8b                                                ; 2843: e1 20 8b    . .
    equs "W%=7:Y%=2:"                                                 ; 2846: 57 25 3d... W%=
    equb &d6                                                          ; 2850: d6          .
    equs "S%:"                                                        ; 2851: 53 25 3a    S%:
    equb &e1, &0d,   0, &82, &12, &dd, &f2                            ; 2854: e1 0d 00... ...
    equs "vx:"                                                        ; 285b: 76 78 3a    vx:
    equb &e7                                                          ; 285e: e7          .
    equs "sc%<>5:"                                                    ; 285f: 73 63 25... sc%
    equb &e1, &0d,   0, &83, &22, &e7                                 ; 2866: e1 0d 00... ...
    equs "s%<90:"                                                     ; 286c: 73 25 3c... s%<
    equb &e1, &20, &8b                                                ; 2872: e1 20 8b    . .
    equs "W%=7:X%=17:"                                                ; 2875: 57 25 3d... W%=
    equb &d6                                                          ; 2880: d6          .
    equs "S%:"                                                        ; 2881: 53 25 3a    S%:
    equb &d6                                                          ; 2884: d6          .
    equs "U%:"                                                        ; 2885: 55 25 3a    U%:
    equb &e1, &0d,   0, &84, &5c, &dd, &f2                            ; 2888: e1 0d 00... ...
    equs "sf:"                                                        ; 288f: 73 66 3a    sf:
    equb &ef                                                          ; 2892: ef          .
    equs "19,1,7;0;19,2,7;0;19,3,7;0;:"                               ; 2893: 31 39 2c... 19,
    equb &d4                                                          ; 28af: d4          .
    equs "1,6,60,4:"                                                  ; 28b0: 31 2c 36... 1,6
    equb &f2                                                          ; 28b9: f2          .
    equs "w(120):"                                                    ; 28ba: 77 28 31... w(1
    equb &ef                                                          ; 28c1: ef          .
    equs "19,1,c1%;0;19,2,c2%;0;19,3,c3%;0;:"                         ; 28c2: 31 39 2c... 19,
    equb &e1, &0d,   0, &85, &b4, &dc                                 ; 28e4: e1 0d 00... ...
    equs "116,3,88,3,116,2,0,0,116,3,120,3,116,3,0,0,116,2,88,2,11"   ; 28ea: 31 31 36... 116
    equs "6,2,116,2,116,2,120,2,116,2,0,0,116,3,72,3,100,3,0,0,100"   ; 2922: 36 2c 32... 6,2
    equs ",3,108,3,100,3,0,0,100,2,72,2,100,2,100,2,100,2,108,2,10"   ; 295a: 2c 33 2c... ,3,
    equs "0,2,0,0"                                                    ; 2992: 30 2c 32... 0,2
    equb &0d,   0, &86, &c2, &dc                                      ; 2999: 0d 00 86... ...
    equs "52,3,32,3,80,3,0,0,80,3,88,3,80,3,0,0,52,2,32,2,80,2,80,"   ; 299e: 35 32 2c... 52,
    equs "2,80,2,88,2,80,2,0,0,32,3,32,3,60,3,0,0,60,3,68,3,60,3,0"   ; 29d6: 32 2c 38... 2,8
    equs ",0,60,2,32,2,60,2,60,2,60,2,68,2,60,2,0,0,0,0,0,0,0,0,0,"   ; 2a0e: 2c 30 2c... ,0,
    equs "0,0,0,0,0,0,0,0,0,0,0"                                      ; 2a46: 30 2c 30... 0,0
    equb &0d,   0, &87, &1d, &dd, &f2                                 ; 2a5b: 0d 00 87... ...
    equs "t:c1%=7:c2%=6:c3%=1:"                                       ; 2a61: 74 3a 63... t:c
    equb &f2, &65, &72, &0d,   0, &88, &c4                            ; 2a75: f2 65 72... .er
    equs "g%=0:s%=0:a%=0:sc%=9:"                                      ; 2a7c: 67 25 3d... g%=
    equb &ef                                                          ; 2a91: ef          .
    equs "19,3,1;0;19,2,6;0;19,1,7;0;:"                               ; 2a92: 31 39 2c... 19,
    equb &f2                                                          ; 2aae: f2          .
    equs "q(9):"                                                      ; 2aaf: 71 28 39... q(9
    equb &ef                                                          ; 2ab4: ef          .
    equs "17,3,31,5,28,241,240,235,236,236,32,32,233,242,243,31,4,"   ; 2ab5: 31 37 2c... 17,
    equs "30,237,235,243,32,244,238,32,236,244,233,240,244:"          ; 2aed: 33 30 2c... 30,
    equb &f5, &f3                                                     ; 2b1e: f5 f3       ..
    equs "n1%,n2%:"                                                   ; 2b20: 6e 31 25... n1%
    equb &e7                                                          ; 2b28: e7          .
    equs "n1%=0:"                                                     ; 2b29: 6e 31 25... n1%
    equb &f2                                                          ; 2b2f: f2          .
    equs "w(220):"                                                    ; 2b30: 77 28 32... w(2
    equb &e5, &8d                                                     ; 2b37: e5 8d       ..
    equs "tJ@"                                                        ; 2b39: 74 4a 40    tJ@
    equb &0d,   0, &89, &49, &d4                                      ; 2b3c: 0d 00 89... ...
    equs "1,1,n1%,n2%:"                                               ; 2b41: 31 2c 31... 1,1
    equb &d4                                                          ; 2b4d: d4          .
    equs "2,1,n1%,n2%:"                                               ; 2b4e: 32 2c 31... 2,1
    equb &d4                                                          ; 2b5a: d4          .
    equs "3,1,n1%,n2%:s$="                                            ; 2b5b: 33 2c 31... 3,1
    equb &bf                                                          ; 2b6a: bf          .
    equs "(14):nc%=nc%+1:"                                            ; 2b6b: 28 31 34... (14
    equb &e7                                                          ; 2b7a: e7          .
    equs "nc%=52:"                                                    ; 2b7b: 6e 63 25... nc%
    equb &f2, &65, &72, &0d,   0, &8a, &b7, &e6, &30, &2c, &b3        ; 2b82: f2 65 72... .er
    equs "(3):"                                                       ; 2b8d: 28 33 29... (3)
    equb &f0                                                          ; 2b91: f0          .
    equs "69,634,934:"                                                ; 2b92: 36 39 2c... 69,
    equb &f0                                                          ; 2b9d: f0          .
    equs "69,648,934:"                                                ; 2b9e: 36 39 2c... 69,
    equb &fd                                                          ; 2ba9: fd          .
    equs "s$<>", '"', '"'                                             ; 2baa: 73 24 3c... s$<
    equb &84, &a6                                                     ; 2bb0: 84 a6       ..
    equs "-1:ex%=16:ec%=10:sc%=8:i%=0:g%=0:w%=0:y%=576:x%=1120:K%="   ; 2bb2: 2d 31 3a... -1:
    equs "192:L%=108:j%=0:xm%=0:sd%=10:di%=10:mx%=0:"                 ; 2bea: 31 39 32... 192
    equb &ef                                                          ; 2c14: ef          .
    equs "28,3,30,16,28,17,128,12,26:dc%=40:cr%=0"                    ; 2c15: 32 38 2c... 28,
    equb &0d,   0, &8b, &8d, &f2                                      ; 2c3c: 0d 00 8b... ...
    equs "er:sh%=12:ge%=0:W%=6:X%=24:"                                ; 2c41: 65 72 3a... er:
    equb &d6                                                          ; 2c5c: d6          .
    equs "S%:"                                                        ; 2c5d: 53 25 3a    S%:
    equb &d6                                                          ; 2c60: d6          .
    equs "U%:js%=20:jt%=40:uw%=0:ng%=0:m%=0:a%=3:"                    ; 2c61: 55 25 3a... U%:
    equb &ef                                                          ; 2c88: ef          .
    equs "17,0,17,131:"                                               ; 2c89: 31 37 2c... 17,
    equb &f1, &8a                                                     ; 2c95: f1 8a       ..
    equs "ex%,5)"                                                     ; 2c97: 65 78 25... ex%
    equb &bd                                                          ; 2c9d: bd          .
    equs "224:"                                                       ; 2c9e: 32 32 34... 224
    equb &fb                                                          ; 2ca2: fb          .
    equs "128:"                                                       ; 2ca3: 31 32 38... 128
    equb &e3                                                          ; 2ca7: e3          .
    equs "n%=1"                                                       ; 2ca8: 6e 25 3d... n%=
    equb &b8                                                          ; 2cac: b8          .
    equs "5:tc%(n%)=0:"                                               ; 2cad: 35 3a 74... 5:t
    equb &ed                                                          ; 2cb9: ed          .
    equs ":es%=0:*FX210,0"                                            ; 2cba: 3a 65 73... :es
    equb &0d,   0, &8c, &18, &f2                                      ; 2cc9: 0d 00 8c... ...
    equs "so:"                                                        ; 2cce: 73 6f 3a    so:
    equb &e7                                                          ; 2cd1: e7          .
    equs "s$=", '"', "Q", '"', ":*FX210,1"                            ; 2cd2: 73 24 3d... s$=
    equb &0d,   0, &8d,   5, &e1, &0d,   0, &8e, &16, &dd, &f2        ; 2ce1: 0d 00 8d... ...
    equs "er:"                                                        ; 2cec: 65 72 3a    er:
    equb &f7, &8d                                                     ; 2cef: f7 8d       ..
    equs "tE@:nc%=0:"                                                 ; 2cf1: 74 45 40... tE@
    equb &e1, &0d,   0, &8f, &9c, &dd, &f2                            ; 2cfb: e1 0d 00... ...
    equs "ure:"                                                       ; 2d02: 75 72 65... ure
    equb &d4                                                          ; 2d06: d4          .
    equs "1,4,20,3:Y%=2:W%=6:"                                        ; 2d07: 31 2c 34... 1,4
    equb &d6                                                          ; 2d1a: d6          .
    equs "S%:"                                                        ; 2d1b: 53 25 3a    S%:
    equb &ef                                                          ; 2d1e: ef          .
    equs "5:B$=", '"', "WAITING", '"', ":"                            ; 2d1f: 35 3a 42... 5:B
    equb &f5                                                          ; 2d2e: f5          .
    equs "A$="                                                        ; 2d2f: 41 24 3d    A$=
    equb &bf                                                          ; 2d32: bf          .
    equs "(0):"                                                       ; 2d33: 28 30 29... (0)
    equb &e6, &30, &2c, &b3                                           ; 2d37: e6 30 2c... .0,
    equs "(3):"                                                       ; 2d3b: 28 33 29... (3)
    equb &e3                                                          ; 2d3f: e3          .
    equs "mf%=92"                                                     ; 2d40: 6d 66 25... mf%
    equb &b8, &38, &38, &88                                           ; 2d46: b8 38 38... .88
    equs "-4:"                                                        ; 2d4a: 2d 34 3a    -4:
    equb &ec                                                          ; 2d4d: ec          .
    equs "416,mf%:"                                                   ; 2d4e: 34 31 36... 416
    equb &f1                                                          ; 2d56: f1          .
    equs "B$:"                                                        ; 2d57: 42 24 3a    B$:
    equb &ed, &3a, &fd                                                ; 2d5a: ed 3a fd    .:.
    equs "A$=", '"', "C", '"', ":"                                    ; 2d5d: 41 24 3d... A$=
    equb &e3                                                          ; 2d64: e3          .
    equs "mf%=92"                                                     ; 2d65: 6d 66 25... mf%
    equb &b8, &38, &38, &88                                           ; 2d6b: b8 38 38... .88
    equs "-4:"                                                        ; 2d6f: 2d 34 3a    -4:
    equb &ec                                                          ; 2d72: ec          .
    equs "416,mf%:"                                                   ; 2d73: 34 31 36... 416
    equb &e6                                                          ; 2d7b: e6          .
    equs "0,0:"                                                       ; 2d7c: 30 2c 30... 0,0
    equb &f1                                                          ; 2d80: f1          .
    equs "B$:"                                                        ; 2d81: 42 24 3a    B$:
    equb &ed, &3a, &ef, &34, &3a, &e7                                 ; 2d84: ed 3a ef... .:.
    equs "ng%=0:Y%=0:"                                                ; 2d8a: 6e 67 25... ng%
    equb &d6, &53, &25, &0d,   0, &90, &15, &d4                       ; 2d95: d6 53 25... .S%
    equs "1,6,30,3:*FX15,1"                                           ; 2d9d: 31 2c 36... 1,6
    equb &0d,   0, &91,   5, &e1, &0d,   0, &92, &31, &dc             ; 2dad: 0d 00 91... ...
    equs "1,2,3,4,5,0,6,0,7,0,0,8,0,9,0,10,11,12,13,14"               ; 2db7: 31 2c 32... 1,2
    equb &0d,   0, &93, &20, &dc                                      ; 2de3: 0d 00 93... ...
    equs "2,1,1,2,3,4,2,3,4,4,4,3,1,2"                                ; 2de8: 32 2c 31... 2,1
    equb &0d,   0, &94, &14, &dc                                      ; 2e03: 0d 00 94... ...
    equs "7,6,3,5,1,2,4,0"                                            ; 2e08: 37 2c 36... 7,6
    equb &0d,   0, &95, &30, &dd, &f2                                 ; 2e17: 0d 00 95... ...
    equs "g:W%=6:Y%=2:"                                               ; 2e1d: 67 3a 57... g:W
    equb &d6                                                          ; 2e29: d6          .
    equs "S%:"                                                        ; 2e2a: 53 25 3a    S%:
    equb &e7                                                          ; 2e2d: e7          .
    equs "es%=0:s%=s%-1:"                                             ; 2e2e: 65 73 25... es%
    equb &e7                                                          ; 2e3c: e7          .
    equs "s%=-1:s%=0"                                                 ; 2e3d: 73 25 3d... s%=
    equb &0d,   0, &96, &29, &f2                                      ; 2e47: 0d 00 96... ...
    equs "so:pw%=1000:on%=2:"                                         ; 2e4c: 73 6f 3a... so:
    equb &e7                                                          ; 2e5e: e7          .
    equs "es%=1"                                                      ; 2e5f: 65 73 25... es%
    equb &84                                                          ; 2e64: 84          .
    equs "uw%=1:"                                                     ; 2e65: 75 77 25... uw%
    equb &e5, &8d                                                     ; 2e6b: e5 8d       ..
    equs "tX@"                                                        ; 2e6d: 74 58 40    tX@
    equb &0d,   0, &97, &64, &e3                                      ; 2e70: 0d 00 97... ...
    equs "mrx%=1"                                                     ; 2e75: 6d 72 78... mrx
    equb &b8                                                          ; 2e7b: b8          .
    equs "30:"                                                        ; 2e7c: 33 30 3a    30:
    equb &d4                                                          ; 2e7f: d4          .
    equs "&12,6,mrx%+50,5:"                                           ; 2e80: 26 31 32... &12
    equb &f2                                                          ; 2e90: f2          .
    equs "w(pw%):pw%=pw%-25:W%=ww%:Y%=on%:rr%=on%:on%=0:"             ; 2e91: 77 28 70... w(p
    equb &d6                                                          ; 2ebf: d6          .
    equs "S%:"                                                        ; 2ec0: 53 25 3a    S%:
    equb &e7                                                          ; 2ec3: e7          .
    equs "rr%=0:on%=2:"                                               ; 2ec4: 72 72 25... rr%
    equb &ed, &20, &8b, &ed, &0d,   0, &98, &a5, &ef                  ; 2ed0: ed 20 8b... . .
    equs "19,1,1;0;19,2,6;0;19,3,7;0;17,3:s$="                        ; 2ed9: 31 39 2c... 19,
    equb &c3                                                          ; 2efc: c3          .
    equs "s%+", '"', "%", '"', ":"                                    ; 2efd: 73 25 2b... s%+
    equb &f2, &66, &3a, &f1, &8a                                      ; 2f04: f2 66 3a... .f:
    equs "5,16);:"                                                    ; 2f09: 35 2c 31... 5,1
    equb &ef                                                          ; 2f10: ef          .
    equs "232,233,234,235,32,32,238,239,235,240,5:"                   ; 2f11: 32 33 32... 232
    equb &e6                                                          ; 2f39: e6          .
    equs "0,2:"                                                       ; 2f3a: 30 2c 32... 0,2
    equb &e3                                                          ; 2f3e: e3          .
    equs "n%=416"                                                     ; 2f3f: 6e 25 3d... n%=
    equb &b8                                                          ; 2f45: b8          .
    equs "412"                                                        ; 2f46: 34 31 32    412
    equb &88                                                          ; 2f49: 88          .
    equs "-4:"                                                        ; 2f4a: 2d 34 3a    -4:
    equb &ec                                                          ; 2f4d: ec          .
    equs "544,n%:"                                                    ; 2f4e: 35 34 34... 544
    equb &f1                                                          ; 2f55: f1          .
    equs "s$:"                                                        ; 2f56: 73 24 3a    s$:
    equb &ed, &3a, &ef, &34, &3a, &f2                                 ; 2f59: ed 3a ef... .:.
    equs "w(14000):"                                                  ; 2f5f: 77 28 31... w(1
    equb &fb, &31, &3a, &f1, &8a                                      ; 2f68: fb 31 3a... .1:
    equs "ex%,5)"                                                     ; 2f6d: 65 78 25... ex%
    equb &bd                                                          ; 2f73: bd          .
    equs "246:"                                                       ; 2f74: 32 34 36... 246
    equb &e1, &0d,   0, &99, &8b, &dd, &f2                            ; 2f78: e1 0d 00... ...
    equs "es:es%=1:"                                                  ; 2f7f: 65 73 3a... es:
    equb &f2                                                          ; 2f88: f2          .
    equs "so:"                                                        ; 2f89: 73 6f 3a    so:
    equb &ef                                                          ; 2f8c: ef          .
    equs "19,1,1;0;19,2,3;0;19,3,6;0;:"                               ; 2f8d: 31 39 2c... 19,
    equb &f2, &66, &3a, &fb, &32, &3a, &f1, &8a                       ; 2fa9: f2 66 3a... .f:
    equs "6,16);:"                                                    ; 2fb1: 36 2c 31... 6,1
    equb &ef                                                          ; 2fb8: ef          .
    equs "232,233,234,235,32,235,242,245,5:"                          ; 2fb9: 32 33 32... 232
    equb &e6                                                          ; 2fda: e6          .
    equs "0,1:a$="                                                    ; 2fdb: 30 2c 31... 0,1
    equb &bd                                                          ; 2fe2: bd          .
    equs "10+"                                                        ; 2fe3: 31 30 2b    10+
    equb &c4                                                          ; 2fe6: c4          .
    equs "12,"                                                        ; 2fe7: 31 32 2c    12,
    equb &bd                                                          ; 2fea: bd          .
    equs "8):"                                                        ; 2feb: 38 29 3a    8):
    equb &e3                                                          ; 2fee: e3          .
    equs "n%=416"                                                     ; 2fef: 6e 25 3d... n%=
    equb &b8                                                          ; 2ff5: b8          .
    equs "412"                                                        ; 2ff6: 34 31 32    412
    equb &88                                                          ; 2ff9: 88          .
    equs "-4:"                                                        ; 2ffa: 2d 34 3a    -4:
    equb &ec                                                          ; 2ffd: ec          .
    equs "256,n%"                                                     ; 2ffe: 32 35 36... 256
    equb &0d,   0, &9a, &36, &f1                                      ; 3004: 0d 00 9a... ...
    equs '"', "INNER  WORLD", '"', "+a$+", '"', "COMMING SOON", '"'   ; 3009: 22 49 4e... "IN
    equs ":"                                                          ; 3029: 3a          :
    equb &ed, &3a, &f2                                                ; 302a: ed 3a f2    .:.
    equs "w(13000):"                                                  ; 302d: 77 28 31... w(1
    equb &ef, &34, &3a, &e1, &0d,   0, &9b, &3c, &dd, &f2             ; 3036: ef 34 3a... .4:
    equs "cc:S1%=&70:S2%=&71:S3%=&72:S4%=&74:"                        ; 3040: 63 63 3a... cc:
    equb &de                                                          ; 3063: de          .
    equs " cc% 200:"                                                  ; 3064: 20 63 63...  cc
    equb &e3                                                          ; 306d: e3          .
    equs "n%=0"                                                       ; 306e: 6e 25 3d... n%=
    equb &b8, &32, &88, &32, &0d,   0, &9c, &0a                       ; 3072: b8 32 88... .2.
    equs "P%=cc%"                                                     ; 307a: 50 25 3d... P%=
    equb &0d,   0, &9d, &0a                                           ; 3080: 0d 00 9d... ...
    equs "[OPTn%"                                                     ; 3084: 5b 4f 50... [OP
    equb &0d,   0, &9e, &a8                                           ; 308a: 0d 00 9e... ...
    equs ".s LDY#0:.l LDA(&70),Y:CMP#0:BEQze:CMP#1:BEQon:CMP#2:BEQ"   ; 308e: 2e 73 20... .s
    equs "tw:CMP#3:BEQth:.ba:DEC&73:LDA&73:BEQrr:.pe:INY:TYA:CMP#1"   ; 30c6: 74 77 3a... tw:
    equs "80:BNEl:RTS:.rr JMPrt:.ze LDA#32:JSRos%:JSRos%:JMPba"       ; 30fe: 38 30 3a... 80:
    equb &0d,   0, &9f                                                ; 3132: 0d 00 9f    ...
    equs "~.on LDA#32:JSRos%:LDA#17:JSRos%:LDA#131:JSRos%:LDA#17:J"   ; 3135: 7e 2e 6f... ~.o
    equs "SRos%:LDA#2:JSRos%:LDA&72:JSRos%:LDA#17:JSRos%:LDA#128:J"   ; 316d: 53 52 6f... SRo
    equs "SRos%:JMPba"                                                ; 31a5: 53 52 6f... SRo
    equb &0d,   0, &a0                                                ; 31b0: 0d 00 a0    ...
    equs "~.tw LDA#17:JSRos%:LDA#131:JSRos%:LDA#17:JSRos%:LDA#2:JS"   ; 31b3: 7e 2e 74... ~.t
    equs "Ros%:LDA&72:JSRos%:LDA#17:JSRos%:LDA#128:JSRos%:LDA#32:J"   ; 31eb: 52 6f 73... Ros
    equs "SRos%:JMPba"                                                ; 3223: 53 52 6f... SRo
    equb &0d,   0, &a1                                                ; 322e: 0d 00 a1    ...
    equs "~.th LDA#17:JSRos%:LDA#131:JSRos%:LDA#17:JSRos%:LDA#2:JS"   ; 3231: 7e 2e 74... ~.t
    equs "Ros%:LDA&72:JSRos%:LDA&72:JSRos%:LDA#17:JSRos%:LDA#128:J"   ; 3269: 52 6f 73... Ros
    equs "SRos%:JMPba"                                                ; 32a1: 53 52 6f... SRo
    equb &0d,   0, &a2                                                ; 32ac: 0d 00 a2    ...
    equs '"', ".rt LDA#30:STA&73:INC&72:JMPpe"                        ; 32af: 22 2e 72... ".r
    equb &0d,   0, &a3,   8, &5d, &ed, &3a, &e1, &0d, &ff             ; 32ce: 0d 00 a3... ...
.start
    lda #osbyte_tape                                                  ; 32d8: a9 8c       ..
    ldx #0                                                            ; 32da: a2 00       ..
    jsr osbyte                                                        ; 32dc: 20 f4 ff     ..
    lda #0                                                            ; 32df: a9 00       ..
    sta l0080                                                         ; 32e1: 85 80       ..
    lda #&11                                                          ; 32e3: a9 11       ..
    sta l0081                                                         ; 32e5: 85 81       ..
    lda #0                                                            ; 32e7: a9 00       ..
    sta l0082                                                         ; 32e9: 85 82       ..
    lda #&0d                                                          ; 32eb: a9 0d       ..
    sta l0083                                                         ; 32ed: 85 83       ..
    ldx #&22 ; '"'                                                    ; 32ef: a2 22       ."
    ldy #0                                                            ; 32f1: a0 00       ..
; &32f3 referenced 2 times by &32f8, &32ff
.c32f3
    lda (l0080),y                                                     ; 32f3: b1 80       ..
    sta (l0082),y                                                     ; 32f5: 91 82       ..
    iny                                                               ; 32f7: c8          .
    bne c32f3                                                         ; 32f8: d0 f9       ..
    inc l0081                                                         ; 32fa: e6 81       ..
    inc l0083                                                         ; 32fc: e6 83       ..
    dex                                                               ; 32fe: ca          .
    bne c32f3                                                         ; 32ff: d0 f2       ..
    lda #&0d                                                          ; 3301: a9 0d       ..
    sta l0018                                                         ; 3303: 85 18       ..
    lda #osbyte_insert_buffer                                         ; 3305: a9 8a       ..
    ldy #&4f ; 'O'                                                    ; 3307: a0 4f       .O
    jsr osbyte                                                        ; 3309: 20 f4 ff     ..
    ldy #&2e ; '.'                                                    ; 330c: a0 2e       ..
    jsr osbyte                                                        ; 330e: 20 f4 ff     ..
    ldy #&0d                                                          ; 3311: a0 0d       ..
    jsr osbyte                                                        ; 3313: 20 f4 ff     ..
    ldy #&f9                                                          ; 3316: a0 f9       ..
    jsr osbyte                                                        ; 3318: 20 f4 ff     ..
    ldy #&0d                                                          ; 331b: a0 0d       ..
    jsr osbyte                                                        ; 331d: 20 f4 ff     ..
    brk                                                               ; 3320: 00          .
.pydis_end

; Label references by decreasing frequency:
;     osbyte:   6
;     l0080:    2
;     l0081:    2
;     l0082:    2
;     l0083:    2
;     c32f3:    2
;     l0018:    1

; Automatically generated labels:
;     c32f3
;     l0018
;     l0080
;     l0081
;     l0082
;     l0083
    assert osbyte_insert_buffer == &8a
    assert osbyte_tape == &8c

save pydis_start, pydis_end
