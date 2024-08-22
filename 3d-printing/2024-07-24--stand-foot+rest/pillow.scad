MARGIN = 3;
$fn = $preview ? 120 : 180;

C_LENGTH = /*            */ 102;
C_HEIGHT = /*             */ 15;
C_WIDTH = /*              */ 99;
D = 60;

module cylinder0(factor = 0, height = 0, l = C_LENGTH, w = C_WIDTH, margin = 0) {
    h = factor ? C_HEIGHT * factor : height;
    resize([ w - margin, l - margin, h ]) cylinder(d = 10, h = 1);
}

module concrete() {
    translate([ 0, 0, C_HEIGHT ])
    difference() {
        cylinder0(height = 96);

        // slanted top
        translate([ 0, C_LENGTH / 2, 96 ])
        rotate([ 38, 0, 0 ])
        translate([ 0, -C_LENGTH / 2, 0 ])
        cylinder(d = C_LENGTH * 4, h = 100);
    }
}

rotate([0, 90, 0])
rotate([51.5, 0, 0])
difference() {
    rotate([0, 90, 0])
    minkowski() {
        cylinder(d=D, h=60, center=true);
        sphere(r=1.5);
    }

    translate([0, -55+5, -85-9])
    translate([0, 9-.3 , 9-2.2])   
    {
        concrete();
//%        concrete();
    }

    translate([0, 10-.62, 18-5])
    rotate([-51.5, 0, 0])
    translate([0, -20, -10])
    translate([0, 50, -111])
    rotate([.5, 0, 180])
    translate([0, 0, 11])
    {
        concrete();
//        %concrete();
    }
}
