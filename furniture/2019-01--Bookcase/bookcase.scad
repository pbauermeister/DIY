
GAP = 1;
PLEN = 2400; // plank length
PTCK =   18; // plank thickness
XWID =  280; // extention width

DLEN = (PLEN+XWID) / 2 +20; // door length
DTCK = 5;

//////////////////////////////////////////////////
module vplank(length, xpos, zpos, width) {
	color("peru")
	translate([xpos, 0, zpos + GAP])
	cube([PTCK, width, length - GAP*2]);
}
module vplank1(length, xpos, zpos=0)
       vplank(length, xpos, zpos, 300);
module vplank2(length, xpos, zpos=0)
       vplank(length, xpos, zpos, 400);
//////////////////////////////////////////////////
module hplank(length, zpos, xpos, width) {
	color("peru")
	translate([xpos + GAP, 0, zpos])
	cube([length - GAP*2, width, PTCK]);
}
module hplank1(length, zpos, xpos=0)
       hplank(length, zpos, xpos, 300);
module hplank2(length, zpos, xpos=0)
       hplank(length, zpos, xpos, 400);
//////////////////////////////////////////////////
module door(length, height, xpos, zpos, is_front) {
	DTCK = 5;
	depth = 400-5 - DTCK * (is_front?1:2.5);
	color("white")
	translate([xpos, depth, zpos])
	cube([length, DTCK, height]);	
}
//////////////////////////////////////////////////

// vertical
vplank2(PLEN, -XWID -PTCK);
vplank1(PLEN, -PTCK);
vplank1(PLEN, PLEN/2 - PTCK/2); // intermediate
vplank2(PLEN, PLEN);

// bottom trunk
hplank2(PLEN, 100);
hplank2(XWID, 100, -XWID);

hplank2(PLEN, 800 - 200); // 200: DVD
hplank2(XWID, 800 - 200, -XWID);

door(DLEN, 500-PTCK, PLEN-DLEN, 100+PTCK, true);
door(DLEN, 500-PTCK,     -XWID, 100+PTCK, false);

// dvds
hplank2(PLEN, 800);
hplank2(XWID, 800, -XWID);

// computer & hifi
hplank1(PLEN/2 - PTCK/2, 900, PLEN/2 + PTCK/2);

// mid shelves
vplank1(600 - PTCK, PLEN/4, 800 + PTCK);
hplank1(PLEN/4, 800 + 300);

// top trunk
hplank2(PLEN, 1400);
hplank2(XWID, 1400, -XWID);

hplank2(PLEN, 1800);
hplank2(XWID, 1800, -XWID);

door(DLEN, 400-PTCK, PLEN-DLEN, 1400+PTCK, true);
door(DLEN, 400-PTCK,     -XWID, 1400+PTCK, false);

// top showcase
hplank2(PLEN, 2000);
hplank2(XWID, 2000, -XWID);

// top bookcase
hplank1(PLEN, 2250);
hplank1(XWID, 2250, -XWID);


