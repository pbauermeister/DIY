module s1() {
    translate([8, 0, 0])
    sphere(10, $fn=9);
}

module s2() {
    sphere(10, $fn=90);
}

difference() {
    s2();
    s1();
}

translate([.1, 0, 0])
s1();