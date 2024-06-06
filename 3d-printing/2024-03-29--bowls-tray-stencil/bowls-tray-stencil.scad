LENGTH    = 345;
WIDTH     = 143;
DIAMETER  =  60;
SPACING   = 120;

RADIUS    =  15*0 + 5;
THICKNESS =   23;
DEPTH     =    6;

WIDTH2    = WIDTH - THICKNESS*1.5;
DEPTH2    =    10;


/*

1. - Saw ends flush
   - sand top+bottom

2. 19.0mm straight, from under, 10mm deep, preserve borders

3. Make jig: 56mm hole (bell saw)

4. 1cm spacing between piece and jig

5. 12.7mm combination bevel

6. Sand edges

7. Aquadecks

*/


module board() {
    dy = WIDTH/2 - RADIUS;
    dx = LENGTH/2 - RADIUS;
    hull()
    for (x=[-dx,dx])
      for (y=[-dy,dy])
          translate([x, y, 0])
          cylinder(r=RADIUS, h=THICKNESS);
}

module insets() {
    for(x=[-SPACING, 0, SPACING])
        translate([x, 0, THICKNESS-DEPTH])
            cylinder(d=DIAMETER, h= THICKNESS);
}

difference() {
    board();

    cube([LENGTH*2, WIDTH2, DEPTH2*2], center=true);

    insets();
}