WIDTH                  =  75.4  + 2.5      +0.15;
LENGTH                 = 164.45 + 1.2  -.4 -0.7;
WALL_THICKNESS             =   2.0 +.2;
THICKNESS              =  10.0  + 0.5;

module pad(r) {
    cylinder(r=r+1.5, h=.2, $fn=20);
}

module pads() {
    // adhesion pads

    r = 15;
    r2 = r/sqrt(2);

    for(x=[-WIDTH-r*2+r2/2+.5, WIDTH+r-r2/2-2-.5])
    for(y=[-r+r2/2+.5, LENGTH+WALL_THICKNESS*2+r2/2-.5])
        translate([x, y, -THICKNESS-WALL_THICKNESS+.5])
        pad(r); //cylinder(r=r, h=.6, $fn=20);


    for(x=[-THICKNESS+2.2])
    for(y=[-r-1, LENGTH++WALL_THICKNESS*2+r2+1])
        translate([x, y, -THICKNESS-WALL_THICKNESS+.5])
        //scale([.5, 1, 1])
        pad(r); //cylinder(r=r, h=.6, $fn=20);
}

pads();
