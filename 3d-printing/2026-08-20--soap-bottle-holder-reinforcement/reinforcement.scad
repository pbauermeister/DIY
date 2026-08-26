use <../chamferer.scad>
H = 90;
W = 75;

WH = 34;
WW = 30 +2;
TH = 12;

ATOM = 0.01;

chamferer(TH*.9, "hemisphere-up", fn=16*2)
rotate([90, 0, 0])
difference() {
    translate([-W/2, 0, 0])
    cube([W, TH, H]);

    translate([-WW/2, -TH/2, -ATOM])
    cube([WW, TH*2, WH+ATOM]);
}
