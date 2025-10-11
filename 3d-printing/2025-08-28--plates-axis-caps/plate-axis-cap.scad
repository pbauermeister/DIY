use <../chamferer.scad>

DIAMETER_1 = 27;
DIAMETER_2 = 57;
DIAMETER_3 = DIAMETER_2 + 3;
WALL       =  1.6;
DEPTH      =  5;
$fn = $preview ? 30 : 200;

//rotate([180, 0, 0])
difference() {
    chamferer(2, "cone-down")
    cylinder(d=DIAMETER_3, h=DEPTH+WALL);

    // cross
    intersection() {
        translate([0, 0, WALL])
        cylinder(d=DIAMETER_2, h=DEPTH+WALL);

        l = DIAMETER_3;
        w = DIAMETER_1 / sqrt(2) *.48;
        d = .5;
        union() for (a=[0 , 90, 180, 270])
            rotate([0, 0, a])
            translate([d, d, WALL])
            cube(DIAMETER_3);
    }

    // central hole
    translate([0, 0, WALL])
    cylinder(d1=DIAMETER_1, d2=DIAMETER_1+1.5, h=DEPTH*2);

    // cross-cut
    if ($preview && 0)
        translate([0, -500, -500])
        cube(1000);

    %cylinder(d=DIAMETER_1, h=DEPTH*10);
}