use <phone-mini-boombox-v3.scad>

rotate([0, 180, 0])
segment(2, !true);

if (0)
scale([-1, 1, 1])
translate([-80+.15, -55, 0]) {
    l = 12;
    rotate([0, 0, -45])
    cube([.3, l*2, 40]);

    rotate([0, 0, 45])
    translate([l/2, -l, 0])
    cube([.3, l*2, 40]);
}