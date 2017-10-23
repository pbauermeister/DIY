K = 0.85;
WIDTH = 100 * K;
HEIGHT = 15 * K;
DISPLACE_H = -0.22;
DISPLACE_X = 0.1;
SCALE_Y = 1.05;
SCALE_X = 0.95;

module atari() {
    linear_extrude(height=.1)
    scale([10, 12, 1])
    import("atari.dxf");
}

module scene() {
    scale([SCALE_X, SCALE_Y, 1])
    translate([-WIDTH/2 + WIDTH*DISPLACE_X, 0, -HEIGHT/2 + HEIGHT*DISPLACE_H])
    resize([WIDTH, 0, HEIGHT], true)
    {
        atari();

        translate([1305, 0, 240])
        rotate([0, 180, 0])
        atari();
    }
}

s = 1.1;
scale([s, s, s])
rotate([0, 0, 180+35+1])
rotate([39-1, 0, 0])
rotate([0, -1, 0])
scene();

