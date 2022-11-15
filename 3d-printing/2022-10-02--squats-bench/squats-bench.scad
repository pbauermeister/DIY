W  =  250;
L2 =  800;
L1 = 1200;
T  =   18;
W2 = W - T * 2;

SP = 1;

module bench1() {
    L = L1 - W*2;
    echo(L);
    translate([0, 0, W+SP]) cube([L, W, T]);

    translate([0, T, 0]) rotate([90, 0, 0]) cube([L, W, T]);
    translate([0, W, 0]) rotate([90, 0, 0]) cube([L, W, T]);

    translate([0, T+SP, 0]) cube([T, W2 - SP*2, W]);
    translate([L-T, T+SP, 0]) cube([T, W2 - SP*2, W]);
}

module bench2() {
    L = L2;
    echo(L);
    translate([0, 0, W+SP]) cube([L, W, T]);

    translate([0, T, 0]) rotate([90, 0, 0]) cube([L, W, T]);
    translate([0, W, 0]) rotate([90, 0, 0]) cube([L, W, T]);

    p = .75;
    q = 1-p;
    d = 10;
    H2p = (L1-L)/2*p;
    H2q = (L1-L)/2*q;
    echo(H2p, H2q);
    translate([0+d, T+SP, 0])   cube([T, W2 - SP*2, H2p]);
    translate([L-T-d, T+SP, 0]) cube([T, W2 - SP*2, H2p]);

    translate([0+d, T+SP, W-H2q])   cube([T, W2 - SP*2, H2q]);
    translate([L-T-d, T+SP, W-H2q]) cube([T, W2 - SP*2, H2q]);
}

module bench3() {
    L = L2;
    echo(L);
    translate([0, 0, W+SP]) cube([L, W, T]);

    translate([0, T, 0]) rotate([90, 0, 0]) cube([L, W, T]);
    translate([0, W, 0]) rotate([90, 0, 0]) cube([L, W, T]);

    d = 5;
    H2 = (L1-L)/2;
    echo(H2);
    translate([0+d,   T+SP, 0]) cube([T, W2 - SP*2, H2]);
    translate([L-T-d, T+SP, 0]) cube([T, W2 - SP*2, H2]);

    H3 = T*2 - 4;
    W3 = H2;
    echo(W2-W3);
    translate([0+d,   T+SP, W-H3]) cube([T, W3 - SP*2, H3]);
    translate([L-T-d, T+SP, W-H3]) cube([T, W3 - SP*2, H3]);
}

color("orange")

bench2();