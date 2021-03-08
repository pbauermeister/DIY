include <definitions.scad>

$fn = 60;

module cross(d, h) {
    rotate([0, 0, 90])
    translate([-HORN_CROSS_WIDTH/2-d/2, -HORN_ARM_THICKNESS/2-d/2, 0])
    cube([HORN_CROSS_WIDTH+d, HORN_ARM_THICKNESS+d, h]);

    translate([-HORN_CROSS_WIDTH/2-d/2, -HORN_ARM_THICKNESS/2-d/2, 0])
    cube([HORN_CROSS_WIDTH+d, HORN_ARM_THICKNESS+d, h]);
}

module calibrator() {
    difference() {
        cylinder(r=HORN_CROSS_WIDTH*1.5, h=2);
        for (i=[0:3]) {
            d = (i+2)/10;
            echo("d", d);
            
            translate([0, 0, i/2])
            cross(d, 0.5);
        }
    }
}

module test() {
    h = 4;
    difference() {
        translate([-HORN_CROSS_WIDTH, -HORN_CROSS_WIDTH*0, 0])
        cube([HORN_CROSS_WIDTH*2, HORN_CROSS_WIDTH*5, h]);
        
        cylinder(d=1.5, h=h);
        translate([0, HORN_CROSS_WIDTH*1, 0])
        cross(.3, h);
    
        translate([0, HORN_CROSS_WIDTH*2.5, 0])
        cross(.4, h);

        translate([0, HORN_CROSS_WIDTH*4, 0])
        cross(.5, h);
        
        translate([-.2/2, 0, h-.2])
        cube([.2, HORN_CROSS_WIDTH*5, h]);
    }
}


//calibrator();

test();