The game contains 19 sprites. Each sprite has four versions for different sub-byte X positions; in mode 5, each byte of screen memory contains four pixels and having these pre-defined versions saves doing bit shifting when plotting data to the screen. It also allows animation "for free" by automatically changing the sprite's appearance based on its X co-ordinate.

| physical | logical | frames | animation | notes |
| --------:| -------:| ------ | --------- | ----- |
| 0 &4000  |     1-8 | ![](img/sprite-00-0.png) ![](img/sprite-00-1.png) ![](img/sprite-00-2.png) ![](img/sprite-00-3.png) | ![](img/sprite-00-anim.gif) | Final Guardian/Demon Lord |
| 1 &40C0  |       9 | ![](img/sprite-01-0.png) ![](img/sprite-01-1.png) ![](img/sprite-01-2.png) ![](img/sprite-01-3.png) | ![](img/sprite-01-anim.gif) | Human, right |
| 2 &4180  |      10 | ![](img/sprite-02-0.png) ![](img/sprite-02-1.png) ![](img/sprite-02-2.png) ![](img/sprite-02-3.png) | ![](img/sprite-02-anim.gif) | Human, left |
| 3 &4240  |      11 | ![](img/sprite-03-0.png) ![](img/sprite-03-1.png) ![](img/sprite-03-2.png) ![](img/sprite-03-3.png) | ![](img/sprite-03-anim.gif) | Gargoyle, right |
| 4 &4300  |      12 | ![](img/sprite-04-0.png) ![](img/sprite-04-1.png) ![](img/sprite-04-2.png) ![](img/sprite-04-3.png) | ![](img/sprite-04-anim.gif) | Gargoyle, left |
| 5 &43C0  |      13 | ![](img/sprite-05-0.png) ![](img/sprite-05-1.png) ![](img/sprite-05-2.png) ![](img/sprite-05-3.png) | ![](img/sprite-05-anim.gif) | Harpy, right |
| 6 &4480  |      14 | ![](img/sprite-06-0.png) ![](img/sprite-06-1.png) ![](img/sprite-06-2.png) ![](img/sprite-06-3.png) | ![](img/sprite-06-anim.gif) | Harpy, left |
| 7 &4540  |      15 | ![](img/sprite-07-0.png) ![](img/sprite-07-1.png) ![](img/sprite-07-2.png) ![](img/sprite-07-3.png) | ![](img/sprite-07-anim.gif) | Winged creature |
| 8 &4600  |      16 | ![](img/sprite-08-0.png) ![](img/sprite-08-1.png) ![](img/sprite-08-2.png) ![](img/sprite-08-3.png) | ![](img/sprite-08-anim.gif) | Robot sentinel |
| 9 &46C0  |      17 | ![](img/sprite-09-0.png) ![](img/sprite-09-1.png) ![](img/sprite-09-2.png) ![](img/sprite-09-3.png) | ![](img/sprite-09-anim.gif) | Fleece/MacGuffin/unused/Prism |
| 10 &4780 |      18 | ![](img/sprite-10-0.png) ![](img/sprite-10-1.png) ![](img/sprite-10-2.png) ![](img/sprite-10-3.png) | ![](img/sprite-10-anim.gif) | Health pickup |
| 11 &4840 |      19 | ![](img/sprite-11-0.png) ![](img/sprite-11-1.png) ![](img/sprite-11-2.png) ![](img/sprite-11-3.png) | ![](img/sprite-11-anim.gif) | Veil of Ambiguity |
| 12 &4900 |      20 | ![](img/sprite-12-0.png) ![](img/sprite-12-1.png) ![](img/sprite-12-2.png) ![](img/sprite-12-3.png) | ![](img/sprite-12-anim.gif) | Wall enemy, left |
| 13 &49C0 |      21 | ![](img/sprite-13-0.png) ![](img/sprite-13-1.png) ![](img/sprite-13-2.png) ![](img/sprite-13-3.png) | ![](img/sprite-13-anim.gif) | Wall enemy, right |
| 14 &4A80 |      22 | ![](img/sprite-14-0.png) ![](img/sprite-14-1.png) ![](img/sprite-14-2.png) ![](img/sprite-14-3.png) | ![](img/sprite-14-anim.gif) | Eye enemy |
| 15 &4B40 |      23 | ![](img/sprite-15-0.png) ![](img/sprite-15-1.png) ![](img/sprite-15-2.png) ![](img/sprite-15-3.png) | ![](img/sprite-15-anim.gif) | Statue |
| 16 &4C00 |      24 | ![](img/sprite-16-0.png) ![](img/sprite-16-1.png) ![](img/sprite-16-2.png) ![](img/sprite-16-3.png) | ![](img/sprite-16-anim.gif) | Sun |
| 17 &4CC0 |      25 | ![](img/sprite-17-0.png) ![](img/sprite-17-1.png) ![](img/sprite-17-2.png) ![](img/sprite-17-3.png) | ![](img/sprite-17-anim.gif) | Moon |
| 18 &4D80 |      26 | ![](img/sprite-18-0.png) ![](img/sprite-18-1.png) ![](img/sprite-18-2.png) ![](img/sprite-18-3.png) | ![](img/sprite-18-anim.gif) | Veil of More Ambiguity |

| physical | frames |
| --------:| ------ |
|  0       | ![](img/sprite-00-0-large.png) ![](img/sprite-00-1-large.png) ![](img/sprite-00-2-large.png) ![](img/sprite-00-3-large.png) |
|  1       | ![](img/sprite-01-0-large.png) ![](img/sprite-01-1-large.png) ![](img/sprite-01-2-large.png) ![](img/sprite-01-3-large.png) |
|  2       | ![](img/sprite-02-0-large.png) ![](img/sprite-02-1-large.png) ![](img/sprite-02-2-large.png) ![](img/sprite-02-3-large.png) |
|  3       | ![](img/sprite-03-0-large.png) ![](img/sprite-03-1-large.png) ![](img/sprite-03-2-large.png) ![](img/sprite-03-3-large.png) |
|  4       | ![](img/sprite-04-0-large.png) ![](img/sprite-04-1-large.png) ![](img/sprite-04-2-large.png) ![](img/sprite-04-3-large.png) |
|  5       | ![](img/sprite-05-0-large.png) ![](img/sprite-05-1-large.png) ![](img/sprite-05-2-large.png) ![](img/sprite-05-3-large.png) |
|  6       | ![](img/sprite-06-0-large.png) ![](img/sprite-06-1-large.png) ![](img/sprite-06-2-large.png) ![](img/sprite-06-3-large.png) |
|  7       | ![](img/sprite-07-0-large.png) ![](img/sprite-07-1-large.png) ![](img/sprite-07-2-large.png) ![](img/sprite-07-3-large.png) |
|  8       | ![](img/sprite-08-0-large.png) ![](img/sprite-08-1-large.png) ![](img/sprite-08-2-large.png) ![](img/sprite-08-3-large.png) |
|  9       | ![](img/sprite-09-0-large.png) ![](img/sprite-09-1-large.png) ![](img/sprite-09-2-large.png) ![](img/sprite-09-3-large.png) |
| 10       | ![](img/sprite-10-0-large.png) ![](img/sprite-10-1-large.png) ![](img/sprite-10-2-large.png) ![](img/sprite-10-3-large.png) |
| 11       | ![](img/sprite-11-0-large.png) ![](img/sprite-11-1-large.png) ![](img/sprite-11-2-large.png) ![](img/sprite-11-3-large.png) |
| 12       | ![](img/sprite-12-0-large.png) ![](img/sprite-12-1-large.png) ![](img/sprite-12-2-large.png) ![](img/sprite-12-3-large.png) |
| 13       | ![](img/sprite-13-0-large.png) ![](img/sprite-13-1-large.png) ![](img/sprite-13-2-large.png) ![](img/sprite-13-3-large.png) |
| 14       | ![](img/sprite-14-0-large.png) ![](img/sprite-14-1-large.png) ![](img/sprite-14-2-large.png) ![](img/sprite-14-3-large.png) |
| 15       | ![](img/sprite-15-0-large.png) ![](img/sprite-15-1-large.png) ![](img/sprite-15-2-large.png) ![](img/sprite-15-3-large.png) |
| 16       | ![](img/sprite-16-0-large.png) ![](img/sprite-16-1-large.png) ![](img/sprite-16-2-large.png) ![](img/sprite-16-3-large.png) |
| 17       | ![](img/sprite-17-0-large.png) ![](img/sprite-17-1-large.png) ![](img/sprite-17-2-large.png) ![](img/sprite-17-3-large.png) |
| 18       | ![](img/sprite-18-0-large.png) ![](img/sprite-18-1-large.png) ![](img/sprite-18-2-large.png) ![](img/sprite-18-3-large.png) |

| physical | behaviour |
| --------:| --------- |
| 0 | Guards the exit only if the player has the fleece and is trying to escape for a 100% win. Appears to be the initials of the game developer. |
| 5/6 | Moves horizontally back and forth across the whole screen, but tracks the player's vertical position. |
| 7 | Slowly homes in on the player. Damages the player in human form, but the gargoyle appears to be (mostly) immune. |
| 8 | Moves in a fixed route around the screen. |
| 9 | TODO |
| 10 | Restores the player's health if touched. Can only be used once, disappears permanently once touched. |
| 11 | Guards the exit and secret room once the player has collected all four prisms. |
| 12/13 | Hurts the player if touched but doesn't do anything else. |
| 14 | Normally moves around the screen like the robot sentinel (physical sprite 8); homes in on the player in the screen room. |
| 15 | Hurts the player if touched when human but doesn't do anything else. |
| 16 | Used to show the progress of time while the player is a human. |
| 17 | Used to show the progress of time while the player is a gargoyle. |
| 18 | Replaces an enemy in one of the rooms after the player has collected all four prisms. |
