use <hinge3.scad>

PART_LENGTH = 9;

//translate([0, 2, 0]) %cube([42, 2, 16]);

for (i=[0:4]) {
    translate([PART_LENGTH/2 + PART_LENGTH*i, 0, 0])
    rotate([0, 0, i%2==0 ? 0 : 180]) {
        hinge_new(nb_layers=4, layer_height=2.5, thickness=5,
                      width1=PART_LENGTH/2, width2=PART_LENGTH/2, angle2=0);
    }
}

