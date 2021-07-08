WALL = .6*2;
INF = 1000;


MODULE_WIDTH = 25;
MODULE_LENGTH = 35;
MODULE_HEIGHT = 95;

module skin() {
    thickness = WALL;
    intersection() {
        minkowski() {
            difference() {
                cube(INF, center=true);
                children();
            }
            sphere(d=thickness, $fn=6);
        }
        minkowski() {
            children();
            sphere(d=thickness, $fn=6);
        }
    }
}

module shave_top(h) {
    difference() {
        children();
        translate([0, 0, INF/2 + h])
        cube(INF, center=true);
    }
}


module any(k, m) {
    d = MODULE_WIDTH * sqrt(4/3) *k;
    d2 = MODULE_WIDTH * cos(30)/2 *k;
    shift = (MODULE_LENGTH-MODULE_WIDTH)*k + (MODULE_WIDTH/2-d2)*m;
    translate([d2, 0, 0])
    difference() {
        shave_top(MODULE_HEIGHT-WALL/2) skin() 
        union() {
            cylinder(d=d, h=MODULE_HEIGHT, $fn=6);
            translate([shift, 0, 0])
            cylinder(d=d, h=MODULE_HEIGHT, $fn=6);
        }

        margin = 2;
        d3 = d/k-margin*2;
        d4 = d3 + margin*2;
        for (i=[0:floor(MODULE_HEIGHT/d4)]) {
            translate([shift/2, MODULE_WIDTH, d3/2 + margin + i*d4])
            scale([k, 1, 1])
            rotate([90, 0, 0])
            rotate([0, 0, 90])
            cylinder(d=d3, h=MODULE_WIDTH*2, $fn=6);
        }
    }
}

module big() {
    any(1, 1);
}

module small() {
    any(1/2, 0);
}

module compound() {
    big();

    translate([MODULE_LENGTH, MODULE_WIDTH/4, 0]) small();
    translate([MODULE_LENGTH, -MODULE_WIDTH/4, 0]) small();
}

N = 2;

module u(inv=false) {
    difference() {
        cube([MODULE_LENGTH*1.5*N + WALL/2, WALL*4, WALL*6]);
        translate([0, WALL, inv ? WALL : 0])
        cube([MODULE_LENGTH*1.5*N + WALL/2, WALL*2, WALL*5]);
    }
}

module all() {
    rotate([0, 90, 0]) {
        difference() {
            union() {
                for (i=[0:N-1]) {
                    translate([MODULE_LENGTH*1.5*i, 0, 0])
                    compound();
                }
            }
            
            r = MODULE_WIDTH/4;
            translate([-MODULE_LENGTH/2, 0, MODULE_HEIGHT+r/2])
            rotate([0, 90, 0])
            rotate([0, 0, 90])
            cylinder(r=r, h=MODULE_LENGTH*1.5*N*2, $fn=6);
        }
        translate([0, MODULE_WIDTH/2 -WALL/2, MODULE_HEIGHT-WALL*6]) u();
        translate([0, MODULE_WIDTH/2 -WALL/2, MODULE_HEIGHT-WALL*6 - 63]) u(true);
    }
}

/*
intersection() {
    rotate([0, -90, 0]) 
    all();

    translate([0, 0, 29])
cube([MODULE_HEIGHT*10, 30, 2.2], center=true);
}
*/
all();
