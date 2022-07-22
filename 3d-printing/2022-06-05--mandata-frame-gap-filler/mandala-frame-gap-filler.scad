module part() {
    cube([207 / 2, 5, 5]);
    cube([5, 207 / 2, 5]);
}

d = 7;

translate([d*0, d*0, 0]) part();
translate([d*1, d*1, 0]) part();
translate([d*2, d*2, 0]) part();
translate([d*3, d*3, 0]) part();