
GAP = 20*0;
PLEN = 2400; // plank length
PTCK =   18; // plank thickness
XWID =  280; // extention width

DLEN = (PLEN+XWID) / 2 +20; // door length
DTCK = 5;

WID0 = 200; // width 1
WID1 = 300; // width 1
WID2 = 400; // width 2

PHIG = 50; // plinth height

SHIFT = PTCK*0; // front-shift intermediate vplancks

//////////////////////////////////////////////////
module _vplank(length, xpos, zpos, width) {
	color("peru")
	translate([xpos, 0, zpos + GAP])
	cube([PTCK, width, length - GAP*2]);
	echo("Plank " , width, length);
}
module vplank1(length, xpos, zpos=0)
       _vplank(length, xpos, zpos, WID1);
module vplank2(length, xpos, zpos=0)
       _vplank(length, xpos, zpos, WID2);
//////////////////////////////////////////////////
module _hplank(length, zpos, xpos, width) {
	color("peru")
	translate([xpos + GAP, 0, zpos])
	cube([length - GAP*2, width, PTCK]);
	echo("Plank " , width, length);
}
module hplank0(length, zpos, xpos=0)
       _hplank(length, zpos, xpos, WID0);
module hplank1(length, zpos, xpos=0)
       _hplank(length, zpos, xpos, WID1);
module hplank2(length, zpos, xpos=0)
       _hplank(length, zpos, xpos, WID2);
//////////////////////////////////////////////////
module _door(length, height, xpos, zpos, is_front) {
	DTCK = 5;
	depth = WID2-5 - DTCK * (is_front?1:2.5);
if(0)
	translate([xpos, depth, zpos])
	cube([length, DTCK, height]);	
}

module door(length, height, xpos, zpos, is_front)
	color("white")
	_door(length, height, xpos, zpos, is_front);

module glassdoor(length, height, xpos, zpos, is_front)
	%_door(length, height, xpos, zpos, is_front);

//////////////////////////////////////////////////
module object(w, h, d, x, y, f=0) {
	color(rands(0, 1, 3))
	translate([x+GAP, f+GAP, y+GAP])
	cube([w-GAP*2, d-GAP*2, h-GAP*2]);
}
//////////////////////////////////////////////////

module shelf()
{
	// vertical
	
	// - rightmost
//	vplank2(PLEN - 185, -XWID -PTCK, 50);
//	vplank2(50, -XWID -PTCK, 0);

	vplank2(PLEN - 185 + 50, -XWID -PTCK, 50 -50);
	
	// - right
	translate([0, SHIFT, 0]) {
		vplank1(PLEN, -PTCK, 50);
		vplank1(50, -PTCK, 0);
	}
	
	// - intermediate
	translate([0, SHIFT, 0]) {
		vplank1(PLEN - PTCK - 450, PLEN/2 - PTCK/2, 50 + PTCK);
		vplank1(50, PLEN/2 - PTCK/2, 0);
	}
	
	// - left
	vplank2(PLEN, PLEN, 50);
	vplank2(50, PLEN, 0);
	
	// plinth
%//	color([.25, 0, 0])
	translate([-XWID, WID2 - 40, 0])
	cube([PLEN + XWID, 20, PHIG]);
	
	// bottom trunk
	hplank2(PLEN, PHIG);
	hplank2(XWID, PHIG, -XWID);
	
	hplank2(PLEN, 800 - 200 -PTCK*2 -5);
	hplank2(XWID, 800 - 200 -PTCK*2 -5, -XWID);
	
	door(DLEN, 600-PTCK-PHIG -PTCK*2 -5, PLEN-DLEN, PHIG+PTCK, true);
	door(DLEN, 600-PTCK-PHIG -PTCK*2 -5,     -XWID, PHIG+PTCK, false);
	
	// spare plank
if(0)
	translate([0, PTCK, PHIG+PTCK])
	rotate([90, 0, 0])
	#hplank2(PLEN, 0);
	
	// dvds
	// - drawer
#	translate([0, PTCK*3, 0]) {
		hplank1(PLEN, 800 - 200 -PTCK);
		hplank1(XWID, 800 - 200 -PTCK, -XWID);
	}
	
	hplank2(PLEN, 800);
	hplank2(XWID, 800, -XWID);
	
	// mid right shelves
	translate([0, SHIFT, 0])
	vplank1(600 - PTCK, PLEN/4, 800 + PTCK);
	hplank1(PLEN/2, 800 + 270);
	
	// mid left shelves: computer & hifi
	translate([0, SHIFT, 0])
	vplank1(600 - PTCK, PLEN - PTCK - 440, 800 + PTCK);
	//hplank0(PLEN/2 - PTCK*1.5 - 440, 900, PLEN/2 + PTCK/2);
	
	hplank1(440,  920, PLEN-440);
	hplank1(440, 1140, PLEN-440);
	
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
	
	glassdoor(DLEN, 200, PLEN-DLEN, 1800, true);
	glassdoor(DLEN, 200,     -XWID, 1800, false);
	
	// top bookcase
	hplank1(PLEN - XWID, 2245);
	
	translate([0, -SHIFT, 0])
	vplank1(450-PTCK, PLEN - XWID, 2000 + PTCK);
	
	//hplank1(XWID - PTCK, 2245, -XWID);
}

module dvds() {
	///////////////////////////////////////////////////////
	// DVDs: 20 sets, 360 DVDs
	
	// - 42 DVDs
	translate([-XWID, PTCK, 0])
	for (i = [0:20]) {
		object(12, 195, 140, i*12, 600, 200);
		object(12, 140, 195, i*12, 600);
	}
	
	// - 20 DVD sets
	translate([0, PTCK, 0])
	for (i = [0:9]) {
		object(45, 195, 140, i*45, 600, 200);
		object(45, 140, 195, i*45, 600);
	}
	
	// - 122 DVDs
	translate([10*45, PTCK, 0])
	for (i = [1:61]) {
		translate([(i-1)*12, 0, 0]) {
			object(12, 195, 140, 0, 600, 200);
			object(12, 140, 195, 0, 600);
		}
	}
	
	// 196 DVDs
	translate([PLEN/2 + PTCK/2, PTCK, 0])
	for (i = [0:97]) {
		object(12, 195, 140, i*12, 600, 200);
		object(12, 140, 195, i*12, 600);
	}
}

module books() {	
	///////////////////////////////////////////////////////
	// Books
	
	// 336 Pocket books
	
	// - 168 books
	translate([0, PTCK, 0])
	for (i = [0:83]) {
		object(25, 180, 110, i*25, 2262, 0);
		object(25, 180, 110, i*25, 2262, 115);
	}
	
	// - 168 books
	translate([0, PTCK, 0])
	for (i = [0:83]) {
		object(25, 180, 110, i*25, 2000+PTCK, 0);
		object(25, 180, 110, i*25, 2000+PTCK, 115);
	}
	
	// 40 Cook books
	for (i = [0:39]) {
		object(15, 230, 180, i*15, 800+PTCK, 100);
	}
	
	// 40 albums
	for (i = [0:39]) {
		object(15, 300, 200, i*15 + PLEN/4, 1070+PTCK, 100);
	}
	
	// atlas, dicts
	for (i = [1:2]) {
		object(40, 400, 300, -PTCK - i*40, 800+PTCK);
	}
	for (i = [1:3]) {
		object(60, 250, 180, -PTCK - 2*40 - i * 60, 800+PTCK);
	}	
}

module speakers() {
	///////////////////////////////////////////////////////
	// Speakers
	
	color("black") {
		object(210, 370, 300, -PTCK-210, 2000+PTCK, 100);
		object(210, 370, 300,  PLEN-210, 2000+PTCK, 100);
	}
}

module computer() {
	//////////////////////////////////////////////////
	// Computer
	
	// - screen
	translate([80, 0, 0])
	color("silver") {
		object(600, 380, 50, PLEN/2, 800 + PTCK + 90, 50);
		object(40, 200, 50, PLEN/2 + 300-20, 800 + PTCK, 0);
		object(200, 20, 100, PLEN/2 + 300-100, 800 + PTCK, 0);
	}
	
	// keyboard+mouse
	color("silver")
	object(460, 20, 130, PLEN/2 + 250, 800 + PTCK, 250);

	color("silver")
	object(55, 30, 90, PLEN/2 + 90, 800 + PTCK, 270);

	// - macmini + DVD
	color("silver")
	object(196, 36, 196, PLEN-440 + 5, 800 + PTCK, 150);
	color("white")
	object(196, 36, 196, PLEN-440 + 5, 800 + PTCK + 37, 150);
}

module hifi() {	
	//////////////////////////////////////////////////
	// Hifi
	
	// - receiver
	color([.25, .25, .25])
	object(435, 150-10, 300, PLEN-435, 920+PTCK+10, 50);
	
	// - DVD player
	color("black")
	object(435, 40-3, 250, PLEN-435, 920+PTCK+150+3, 100);
	
	// - squeezebox
	color([.25, .25, .25])
	object(150, 100, 80, PLEN-150, 800+PTCK, 270);
}

if (1)
{
	shelf();
	dvds();	
	books();
	hifi();
	speakers();
	computer();
}