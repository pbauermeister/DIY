
LENGTH = 220;
HEIGHT = 83;
WIDTH = 1.5;
RECESS = 5;

module main() {
    scale([10, 10, WIDTH/100])
    linear_extrude(h=1)
    import("wl1.dxf");

    scale([10, 10, WIDTH/100/2])
    linear_extrude(h=1)
    import("wl2.dxf");
}


scale(205/220)
//rotate([180, 0, 0])
main();