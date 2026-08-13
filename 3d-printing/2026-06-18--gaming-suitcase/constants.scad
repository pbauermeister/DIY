SCREEN_ATT_L = 227;
SCREEN_ATT_W = 158              +1;

SCREEN_LCD_L = 223;
SCREEN_LCD_W = 125;

CASE_WALL    = 10;

CASE_INNER_L = 280; // >= SCREEN_LCD_L + 50;
CASE_INNER_W = 180; // >= SCREEN_LCD_W + 50;

CASE_INNER_H_NES = 50;

CASE_OUTER_L = CASE_INNER_L + CASE_WALL*2;
CASE_OUTER_W = CASE_INNER_W + CASE_WALL*2;

echo(CASE_INNER_L);
echo(CASE_INNER_W);

echo(CASE_OUTER_L);
echo(CASE_OUTER_W);

LID_BEZEL_L0_L        = 319     +5;
LID_BEZEL_L0_W        = 223     +5;
LID_BEZEL_L0_TH       =   3;
LID_BEZEL_L0_TH0      =   .4;
LID_BEZEL_L0_PLAY     =   1;
LID_BEZEL_L0_HINGE_R  =  16;
LID_BEZEL_L0_PILLAR_H =   6.5  +4;
LID_BEZEL_L0_PILLAR_D =  13;

LID_BEZEL_L0_SIDE_CLR =  20;

SCREW_D               =   2.5;

CABLE_PASSAGE         = 65;

ATOM = 0.001;

CASE_LID_L            = 329;
CASE_LID_W            = 234;

/* TODO:
- lid hinge: move 3 mm to the outside
- rail: studs dimaeter 0.15 mm larger
- rail: more studs
- rail: longer to the back

*/