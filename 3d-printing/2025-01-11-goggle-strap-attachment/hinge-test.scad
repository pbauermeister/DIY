use <hinge3.scad>


STRAP_WIDTH = 38;
//CHAIN_WIDTH = STRAP_WIDTH

NB_LAYERS = 3;
THICKNESS = 8;
NB_RINGS = 4;
LENGTH = 70;
KX = 1.3;

PART_LENGTH = LENGTH/NB_RINGS;

for (i=[0:NB_RINGS-1]) {
    translate([PART_LENGTH/2 + PART_LENGTH*i, 0, 0])
    rotate([0, 0, i%2==0 ? 0 : 180]) {
        scale([KX, 1, 1])
        hinge_new(nb_layers=NB_LAYERS, layer_height=STRAP_WIDTH/NB_LAYERS/2, thickness=THICKNESS,
                      width1=PART_LENGTH/2/KX, width2=PART_LENGTH/2/KX, angle2=0);
    }
}

if(0) translate([0, -THICKNESS/2, 0])
%cube([LENGTH, THICKNESS, STRAP_WIDTH]);