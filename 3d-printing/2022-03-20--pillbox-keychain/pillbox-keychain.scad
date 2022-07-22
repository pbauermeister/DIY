// https://www.thingiverse.com/thing:29156/files

// Low large box

scale([1.25, 2.25, 1.0])
translate([80, 0, 0])
import("micropac_plate_v2.STL");
//import("micropac_lid_v2.STL");

// Thin high box

scale([.9, .9, .9])
{
    translate([0, 5, 0])
    import("medpac_box_v2.STL");

    translate([0, 0, 7])
    rotate([180, 0, 0])
    import("medpac_lid_v2.STL");
}

// Pills

% color("grey") {
    translate([3, 0, 3])
    cube([17*2, 5, 17]);

    translate([80+5, -17, 3])
    cube([17*2, 17*2, 5]);
}