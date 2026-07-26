use <../chamferer.scad>

//D   = 100;

DX  =  55;
DY  =  75;
DZ  =  45;

SL  =  30;
SD  =   6.2;
//K   =   0.6;
D1  =  28;

D2  =  10.5;
Z   =  D2;
SKIN = 5;

$fn = $preview? 50 : 100;

module handle0(shrink=false) {
    dr = shrink? SKIN : 0;
    translate([0, 0, DZ/2+Z]) {
        resize([DX-dr, DY-dr, DZ])
        sphere();

        translate([0, 0, -Z])
        cylinder(d=D1-dr, h=DZ, center=true);
    }
}

module screws(grow=false) {
    xd = grow ? SKIN*2 : 0;
    cylinder(d=SD+xd, h=DZ);

    translate([0, 0, Z+SL])
    cylinder(d=25+xd, h=DZ);
}
    
module handle() {
    difference() {
        handle0();
     
        hull() {
            translate([0, 0, D2/2])
            rotate([90, 0, 0])
            cylinder(d=D2, h=DY, center=true);

            rotate([90, 0, 0]) 
            cylinder(d=D2, h=DY, center=true);
        }
        
        screws();

        //cube(1000);
    }
}


difference() {
    handle();

    difference() {
        intersection() {
            handle0(shrink=true);
            for (a=[0:45:180]) {
                rotate([0, 0, a])
                cube([DY*2, .1, DZ*2], center=true);
            }
        }
        screws(grow=true);
    }

    //cube(1000);
}
