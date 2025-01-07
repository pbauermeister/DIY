use <hinge3.scad>

PART_LENGTH = 10;
H = 20;
TH = 5;
L = 20;
W = 16;
TH2 = 2;

MAG_D = 5;
MAG_H = 5;


//translate([0, 2, 0]) %cube([42, 2, 16]);

module wedge() {
    d = sqrt(2) + 1/sqrt(2)/2;
    translate([d, d, 0])
    difference() {
        d0 = TH / sqrt(2);
        cube([d0, d0, H]);

        rotate([0, 0, 45])
        translate([-TH/2, -TH/2, -H/2])
        cube([TH, TH, H*2]);
    }
}

module basis() {
    rotate([0, 0, -45])
    hinge_new(nb_layers=4, layer_height=2.5, thickness=TH,
                  width1=PART_LENGTH/2, width2=PART_LENGTH/2, angle2=90);

    d0 = TH / sqrt(2);

    // left branch
    rotate([0, 0, 90]) wedge();
    translate([-L*2-d0 -1/sqrt(2)/2, 1/sqrt(2)/2, 0])
    cube([L*2, TH, H]);

    translate([-L*2-d0 -1/sqrt(2)/2, TH/2 + 1/sqrt(2)/2, 0])
    cylinder(d=TH, h=H, $fn=100);

    // right branch
    wedge();
    translate([d0 +1/sqrt(2)/2, 1/sqrt(2)/2, 0])
    cube([L, TH, H]);

    translate([L+d0 +1/sqrt(2)/2, TH/2 + 1/sqrt(2)/2, 0])
    cylinder(d=TH, h=H, $fn=100);
}

difference() {
    basis();

    d = TH/3;
    translate([0, TH*.8, 0])
    cylinder(d=TH/4, h=H*3, center=true, $fn=100);
//    cube([d, d, H*3], center=true);

    // left channel
    translate([-L*1.6, TH*.85, 0])
    rotate([0, 0, 11])
    translate([-L*2, -TH2/2, (H-W)/2])
    cube([L*4, TH2, W]);

    translate([-L*3 - TH/2, 0 , (H-W)/2])
    cube([L, TH2, W]);
        
    // right channel
    translate([L, TH*.85, 0])
    rotate([0, 0, -37])
    translate([-L + TH/2, -TH2/2, (H-W)/2])
    cube([L*2, TH2, W]);

    translate([L+TH/2, 0 , (H-W)/2])
    cube([L, TH2, W]);

    margin = .42;
    
    // left mag
    translate([L*.75, 0, H/2])
    translate([-MAG_D/2, .2 + margin, -MAG_D/2])
    cube([MAG_D, MAG_H, MAG_D]);

    // right mag
    translate([-L*.75, 0, H/2])
    translate([-MAG_D/2, .2 + margin, -MAG_D/2])
    cube([MAG_D, MAG_H, MAG_D]);

}