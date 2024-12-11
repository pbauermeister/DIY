use <lib.scad>

k = get_k();

scale([k, k, 1])
main();

translate([80, 0, 0]) 
scale([k, k, 1])
cap();

translate([0, 70, 0]) 
rotate([0, 180, 0])
scale([k, k, 1])
soap_piston();