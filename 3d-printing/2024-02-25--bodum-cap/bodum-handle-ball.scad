
ROD_DIAMETER  =  4.7;
BALL_DIAMETER = 20.0;

$fn = 90;


module hollowing() {
    // rod
    h = BALL_DIAMETER;
    translate([0, 0, -h + BALL_DIAMETER/8])
    cylinder(d=ROD_DIAMETER, h=h);
    
    // cavity
    d = BALL_DIAMETER/3;
    dh = BALL_DIAMETER/8;
    translate([0, 0, dh])
    sphere(d=d);

    // cross
    th = .5;
    h2 = BALL_DIAMETER/2 + 1;

    n = 3;
    for (i=[1:n])
        rotate([0, 0, 360/n*i])
        translate([-th/2, -d/2, -h2+dh])
        cube([th, d, h2]);
}


module ball() {
    difference() {
        // body
        sphere(d=BALL_DIAMETER);

        // for rod
        hollowing();

        // shave base
        shaving = .125;
        translate([0, 0, -BALL_DIAMETER * (1.5 - shaving)])
        cylinder(d=BALL_DIAMETER*1.2, h=BALL_DIAMETER);        
    }
}


intersection() {
    ball();

    //translate([-BALL_DIAMETER/2, 0, -BALL_DIAMETER/2]) cube(BALL_DIAMETER);
}