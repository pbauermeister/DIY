D = 25;
R = D/2;
$fn = 360;

translate([0, 0, R*1.618])
sphere(r=R);

difference() {
    cylinder(r=R, h=R*.87);

    translate([0, 0, R/2])
    rotate_extrude(convexity = 10)
    translate([R, 0, 0])
    circle(r=R/2);
}

H = 2.5;
translate([0, 0, -H])
cylinder(r=R, h=H);