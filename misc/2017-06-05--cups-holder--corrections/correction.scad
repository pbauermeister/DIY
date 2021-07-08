
LENGTH = 220;
HEIGHT = 83;
WIDTH = 81;
RECESS = 4.8;

module main() {
    rotate([90, 0, 0])
    scale([10, 10, RECESS/100])
    linear_extrude(h=1)
    import("correction.dxf");

}

scale(210/220)
rotate([90, 0, 0])
main();


