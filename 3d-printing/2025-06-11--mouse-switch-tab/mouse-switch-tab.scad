
// plate
difference() {
    cube([10, 5, 0.3]);

    translate([2, 1.5, -.5]) cube([3, 2, 1]);
}
translate([5, 0, 0]) cube([5, 5, .4]);
translate([8.5+1, 0, 0]) cube([1.5, 5, 1.5]);



// bump
translate([.7, 1.5, 0])
cube([.6, 2, .8]);


