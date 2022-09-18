use <mandala-easel.scad>

MARGIN = .17;
THICKNESS = 2.5;
EXTRA = 3;

module easel2 () {
    translate([ MARGIN/4, 0, 0]) easel();
    translate([-MARGIN/4, 0, 0]) easel();
}


module pad1() {
    cube([8, 8, THICKNESS], center=true);

    translate([0, -2, EXTRA/2])
    cube([8, 4, EXTRA], center=true);
}


difference() {
    union() {
        translate([ 18, -2, 0]) pad1();
        translate([-18, -2, 0]) pad1();

        translate([0, 15, 0]) cube([8, 8, THICKNESS], center=true);
        translate([0, 25, 0]) cube([8, 8, THICKNESS], center=true);
    }
    easel2();
    if ($preview) %easel2();
}