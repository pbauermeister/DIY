
INFINITY = 10000;
ATOM = .01;

module chamfer_tool(r, fn, tool,
                    ax, ay, az,
                    ax2, ay2, az2,
                    ax3, ay3, az3) {
    rotate([ax3, ay3, az3])
    rotate([ax2, ay2, az2])
    rotate([ax, ay, az]) {
        if (tool=="sphere") {
            sphere(r, $fn=fn);
        }
        else if (tool=="hemisphere-up") {
            intersection() {
                sphere(r, $fn=fn);
                cylinder(r=r*2, h=r*2);
            }
        }
        else if (tool=="hemisphere-down") {
            difference() {
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
        else if (tool=="cylinder-z" || tool=="cylinder") {
            cylinder(r=r, h=ATOM, $fn=fn, center=true);
        }
        else if (tool=="cylinder-x") {
            rotate([0, 90, 0])
            cylinder(r=r, h=ATOM, $fn=fn, center=true);
        }
        else if (tool=="cylinder-y") {
            rotate([90, 0, 0])
            cylinder(r=r, h=ATOM, $fn=fn, center=true);
        }
        else if (tool=="cube") {
            cube(r*2, center=true);
        }
        else if (tool=="plate-y") {
            cube([r*2, ATOM, r*2], center=true);
        }
        else {
            assert(false, str("Unknown tool: ", tool));
        }
    }
}

module shrinker(r, tool, fn,
                ax, ay, az,
                ax2, ay2, az2,
                ax3, ay3, az3) {
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
                chamfer_tool(r, fn, tool,
                             ax, ay, az,
                             ax2, ay2, az2,
                             ax3, ay3, az3);
            }
        }
    }
}

module chamferer(r, tool="sphere", fn=8, shrink=true, grow=true,
                 ax=0, ay=0, az=0,
                 ax2=0, ay2=0, az2=0,
                 ax3=0, ay3=0, az3=0,
) {
    if (!r) {
        children();
    }
    else {
        minkowski() {
            if (shrink)
                shrinker(r, tool, fn,
                         ax, ay, az,
                         ax2, ay2, az2,
                         ax3, ay3, az3) children();
            else
                children();
            
            if (grow)
                chamfer_tool(r, fn, tool,
                             ax, ay, az,
                             ax2, ay2, az2,
                             ax3, ay3, az3);
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