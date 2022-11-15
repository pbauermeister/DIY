
module segment() {
    cube([100, 1, 1], center=true);
}


for (i=[0,22, 45]) {
    step = 5;
    rotate([0, 0, i])
    for (a=[0:step:89]) {
        hull() {
            translate([0, 0, a])      rotate([0, 0, a])      segment();
            translate([0, 0, a+step]) rotate([0, 0, a+step]) segment();
//        }
//        hull() {
//            translate([0, 0, a])      rotate([0, 0, -a])      segment();
//            translate([0, 0, a+step]) rotate([0, 0, -a-step]) segment();
        }
    }
}