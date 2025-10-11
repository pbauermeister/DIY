use <can-crusher-arm.scad>


difference() {
    plate(bottom=false);

    translate([0, 0, 30.5])
    cylinder(d=1.5, h=10, $fn=8);

    for (i=[0:4])
    translate([0, 0, 31.1 +i*.3])
    scale([1, 1, .02])
    rotate_extrude(convexity = 10)
        translate([28.5+i/3, 0, 0])
            square(6-i/3*2);

//    cube(1000);
}



translate([0, 0, 30.5])
difference() {
    cylinder(d=12+1.5, h=10, $fn=30);
    cylinder(d=12, h=10*2, $fn=30);
}