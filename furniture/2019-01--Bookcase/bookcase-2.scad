
GAP = 1;
PLEN = 2500; // plank length
PTCK =   27; // plank thickness

PTCK2 =   18; // plank thickness

//XWID =  280; // extention width

DLEN = (PLEN) / 2 +20; // door length
DTCK = 5;

WID1 = 300; // width 1
WID2 = 400; // width 2

PHIG = 95; // plinth height

//SHIFT = PTCK*0; // front-shift intermediate vplancks

//////////////////////////////////////////////////
module _vplank(length, xpos, zpos, width, tck=PTCK) {
	color("peru")
	translate([xpos, 0, zpos + GAP])
	cube([tck, width, length - GAP*2]);
	echo("Plank " , width, length);
}
module vplank1(length, xpos, zpos=0)
       _vplank(length, xpos, zpos, WID1);
module vplank2(length, xpos, zpos=0)
       _vplank(length, xpos, zpos, WID2);
module vplank3(length, xpos, zpos=0)
       _vplank(length, xpos, zpos, WID1, PTCK2);
//////////////////////////////////////////////////
module _hplank(length, zpos, xpos, width, tck=PTCK) {
	color("peru")
	translate([xpos + GAP, 0, zpos])
	cube([length - GAP*2, width, tck]);
	echo("Plank " , width, length);
}
module hplank0(length, zpos, xpos=0)
       _hplank(length, zpos, xpos, WID0);
module hplank1(length, zpos, xpos=0)
       _hplank(length, zpos, xpos, WID1);
module hplank2(length, zpos, xpos=0)
       _hplank(length, zpos, xpos, WID2);

module hplank3(length, zpos, xpos=0)
       _hplank(length, zpos, xpos, WID1, PTCK2);

//////////////////////////////////////////////////
module _door(length, height, xpos, zpos, is_front) {
	DTCK = 5;
	depth = WID2-5 - DTCK * (is_front?1:2.5);
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
	// verticals
	
	// - rightmost
	vplank2(2450, -PTCK, 0);
	
	// - left
	vplank2(2450, PLEN, 0);

     // - mid
	vplank3(2000 - 0*PTCK, PLEN/2 - PTCK2/2, 0);
	
	// plinth
	color([.25, 0, 0])
	translate([0, WID2 - 40, 0])
	cube([PLEN, 20, PHIG]);

	// bottom trunk, height 42 cm
	echo("bdoor", 600-PTCK-PHIG -PTCK*2 -5);
	hplank2(PLEN, PHIG);
	hplank2(PLEN, 800 - 200 -PTCK*2 -5);
	door(DLEN, 600-PTCK-PHIG -PTCK*2 -5, PLEN-DLEN, PHIG+PTCK, true);
	door(DLEN, 600-PTCK-PHIG -PTCK*2 -5,         0, PHIG+PTCK, false);
	
	// dvds
	// - drawer
#		hplank3(PLEN, 800 - 200 -PTCK);	
	hplank2(PLEN, 800);

	// top trunk, height 37 cm
	hplank2(PLEN, 1400);	
	hplank2(PLEN, 1800);
	door(DLEN, 400-PTCK, PLEN-DLEN, 1400+PTCK, true);
	door(DLEN, 400-PTCK,         0, 1400+PTCK, false);
	
	// top showcase, height 20 cm
	hplank2(PLEN, 2000);
	glassdoor(DLEN, 200, PLEN-DLEN, 1800, true);
	glassdoor(DLEN, 200,         0, 1800, false);
	
	// mid right shelves: books
	vplank3(600 - PTCK, 300, 800 + PTCK);
	hplank3(PLEN/2-300 - PTCK2 - PTCK2/2, 800 + 270, 300+PTCK2);
	
	// mid left shelves: computer & hifi
	vplank3(600 - PTCK, PLEN - PTCK2 - 440, 800 + PTCK);	
	hplank3(440,  920, PLEN-440);
	hplank3(440, 1140, PLEN-440);
		
	// top bookcase
	hplank3(2000, 2245, (PLEN-2000)/2);
	vplank3(450, (PLEN-2000)/2 - PTCK2, 2000);
	vplank3(450, (PLEN-2000)/2 + 2000, 2000);
}

module dvds() {
	///////////////////////////////////////////////////////
	// DVDs: 20 sets, 338 DVDs
	
	// - 20 DVD sets
	translate([0, PTCK, 0])
	for (i = [0:9]) {
		object(45, 195, 140, i*45, 600, 200);
		object(45, 140, 195, i*45, 600);
	}
	
	// - 132 DVDs
	translate([10*45, PTCK, 0])
	for (i = [1:66]) {
		translate([(i-1)*12, 0, 0]) {
			object(12, 195, 140, 0, 600, 200);
			object(12, 140, 195, 0, 600);
		}
	}
	
	// 206 DVDs
	translate([PLEN/2 + PTCK/2, PTCK, 0])
	for (i = [0:102]) {
		object(12, 195, 140, i*12, 600, 200);
		object(12, 140, 195, i*12, 600);
	}
}

module books() {	
	///////////////////////////////////////////////////////
	// Books
	
	// 328 Pocket books 
	
	// - 160 books
	translate([(PLEN-2000)/2, PTCK, 0])
	for (i = [1:80]) {
		object(25, 180, 110, (i-1)*25, 2262, 0);
		object(25, 180, 110, (i-1)*25, 2262, 115);
	}

	// - 168 books
	translate([(PLEN-2000)/2, PTCK, 0])
	for (i = [1:80]) {
		object(25, 180, 110, (i-1)*25, 2000+PTCK, 0);
		object(25, 180, 110, (i-1)*25, 2000+PTCK, 115);
	}

	// 61 Cook books
	for (i = [1:61]) {
		object(15, 230, 180, (i-1)*15 + 300+PTCK2, 800+PTCK, 100);
	}
	
	// 40 albums
	for (i = [1:40]) {
		object(15, 300, 200, (i-1)*15 + 300+PTCK2, 1070+PTCK, 100);
	}
	
	// atlas, dicts
	for (i = [1:2]) {
		object(40, 400, 300, (i-1)*40, 800+PTCK);
	}
	for (i = [1:3]) {
		object(60, 250, 180, 2*40 + (i-1)*60, 800+PTCK);
	}
}

module speakers() {
	///////////////////////////////////////////////////////
	// Speakers
	
	color("black") {
		object(210, 370, 300,         0, 2000+PTCK, 100);
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

shelf();

{
	dvds();
	books();
	hifi();
	speakers();
	computer();
}