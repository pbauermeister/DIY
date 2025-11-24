
INFINITY = 10000;
ATOM = .01;

module chamfer_tool(r, fn, tool) {
    if (tool=="sphere") {
        sphere(r, $fn=fn);
    }
    else if (tool=="hemisphere-up") {
        intersection() {
            sphere(r, $fn=fn);
            cylinder(r=r*2, h=r*2);
        }
    }
    else if (tool=="cone") {
        cylinder(r, r, 0, $fn=fn);
        scale([1, 1, -1])
        cylinder(r, r, 0, $fn=fn);
    }
    else if (tool=="cone-up") {
        cylinder(r, r, 0, $fn=fn, center=true);
    }
    else if (tool=="cone-down") {
        scale([1, 1, -1])
        cylinder(r, r, 0, $fn=fn, center=true);
    }
    else if (tool=="octahedron") {
        resize([r*2, r*2, r*2]) {
            cylinder(r, r, 0, $fn=4);
            scale([1, 1, -1])
            cylinder(r, r, 0, $fn=4);
        }
    }
    else if (tool=="pyramid") {
        resize([r*2, r*2, r*2]) {
            cylinder(r, r, 0, center=true, $fn=4);
        }
    }
    else if (tool=="rpyramid") {
        resize([r*2, r*2, r*2]) {
            cylinder(r, 0, r, center=true, $fn=4);
        }
    }
    else if (tool=="cylinder") {
        cylinder(r=r, h=ATOM, $fn=fn);
    }
    else if (tool=="cube") {
        cube(r*2, center=true);
    }
    else {
        assert(false, str("Unknown tool: ", tool));
    }
}

module shrinker(r, tool="sphere", fn=8) {
    if (!r) {
        children();
    }
    else {
        // re-invert+grow = fillet
        difference() {
            cube(INFINITY/2, center=true);

            // invert+grow = carve
            minkowski() {
                difference() {
                    cube(INFINITY, center=true);
                    children();
                }
                //cube(r, center=true);
                chamfer_tool(r, fn=fn, tool=tool);
            }
        }
    }
}

module chamferer(r, tool="sphere", fn=8, shrink=true, grow=true) {
    if (!r) {
        children();
    }
    else {
        minkowski() {
            if (shrink)
                shrinker(r, tool, fn) children();
            else
                children();
            
            if (grow)
                chamfer_tool(r, fn=fn, tool=tool);
        }
    }
}



cube(50);

translate([70, 0, 0])
chamferer(5, "hemisphere-up", $preview? 6*4 : 30)
//shrinker(5, "sphere", $preview? 6*4 : 30)
cube(50);

translate([70*2, 0, 0])
chamferer(5, "octahedron", grow=false)
cube(50);