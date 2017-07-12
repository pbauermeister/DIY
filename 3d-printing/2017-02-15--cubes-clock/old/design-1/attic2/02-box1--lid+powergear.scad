translate([0, 0, 0]) {
linear_extrude(height=1) scale([10,10,1])
import("02-box1--lid--layer1.dxf");

linear_extrude(height=3) scale([10,10,1])
import("02-box1--lid--layer2.dxf");
}

translate([130, 30, 0]) {
linear_extrude(height=2) scale([10,10,1])
    import("02-box1--powergear--all.dxf");
}