L = 100 + 4;
W =  74 + 4;
H =   8 + 2;

TH = 1.5;
L1 = .4;
STEP = 100/15;

module plate() {
    if(0)
    translate([0, 0, L1])
    cube([L, W, TH-L1-L1/2]);

    w = .8;
    intersection() {
        union() for (x=[0:STEP:L+W]) {
            translate([x, 0, 0])
            rotate([0, 0, 45])
            translate([-w/2, -w/2, 0])
            cube([w, W*sqrt(2)+W, TH]);

            translate([x-W, 0, 0])
            rotate([0, 0, -45])
            translate([-w/2, -w/2, 0])
            cube([w, W*sqrt(2)+w, TH + L1]);
        }

        cube([L, W, TH*3]);
    }
}

module side(l) {
    l2 = l + TH;
    intersection() {
        translate([-TH/2, -TH/2, 0])
        cube([l2, TH, H]);

        th = TH * 1.25;
        union() for (y = [0:th:H]) {
            translate([0, 0, y])
            rotate([45, 0, 0])
            translate([-TH, -th/2, -th/2])
            cube([l2, th, th]);
        }
    }
    translate([-TH/2, -TH/2, 0])
    cube([TH, TH, H]);

    translate([l-TH/2, -TH/2, 0])
    cube([TH, TH, H]);

}

module crate() {
    side(L);
    translate([0, W, 0]) side(L);
    rotate([0, 0, 90]) side(W);
    translate([L, 0, 0]) rotate([0, 0, 90]) side(W);

    plate();
}

color("grey") crate();