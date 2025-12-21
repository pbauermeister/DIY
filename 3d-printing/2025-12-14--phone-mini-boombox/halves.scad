use <phone-mini-boombox.scad>


dz = -11.656 -2;

module ucase() {
    difference() {
        case();
        
        translate([-150, -40-11.5, 24])
        cube([200, 40, 70]);

        translate([-60, -40-11.5, -10])
        cube([110, 40, 140]);
    }
}

module upcase() {
    translate([0, 0, dz])
    rotate([0, 90, 0]) ucase();
}

difference() {
    upcase();
    cylinder(d=1000, h=1000);
}


translate([0, 3, dz*2])
difference() {
    rotate([180, 0, 0])
    upcase();    
    cylinder(d=1000, h=1000);
}
