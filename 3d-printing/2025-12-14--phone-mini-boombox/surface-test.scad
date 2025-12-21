
difference() {
    h = 10;
    d = 1;
    m = 1;

    cube([20, 5, h]);
    
    for (x=[2:4:20-2])
        translate([x, 0, m])

        scale([1, .5, 1])
        rotate([0, 0, 45])
        translate([-d/2, -d/2, 0])
        cube([d, d, h - m*2]);
}