use <lib.scad>

k = get_k();

rotate([0, 180, 0])
scale([k, k, 1])
soap_piston();