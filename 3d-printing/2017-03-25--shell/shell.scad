
// http://www.thingiverse.com/thing:13829

hires = true;
has_shaft = !true;

$fn=36.0 * 4;
shell_scale = [0.4175, 0.4175, 0.4175]; // 30 mm opening, 72 mm full size
shell_thickness = 4.125;
shell_sphere_thickness = 4.125 -1.5;
shell_min = 720;
shell_max = 1800;
resolution = hires ? 2 : 0.5;
theta_step = 12 / resolution;
beta_step = 20 / resolution;
wall = true;
wall_step = 2 * resolution;
wall_fill_percent = 85;
half = true;
beta_max = half ? 180 : 360;
mirror = false;

e = 2.718281828;
pi = 3.1415926535898;

// Fibonacci spiral, good approximation of the nautilus spiral
function r(theta) = pow((1+sqrt(5))/2, 2 * theta / 360) + shell_thickness / 3;

module shell_outer_ring(theta, r11, r12, r21, r22, r23, r24) {
    beta_max = half ? 180 : 360;
    union()
    for(beta = [0 : beta_step : beta_max - beta_step]) {
        rb11 = r21 * cos(beta);
        rb12 = r22 * cos(beta);
        rb13 = r23 * cos(beta);
        rb14 = r24 * cos(beta);
        rb21 = r21 * cos(beta + beta_step);
        rb22 = r22 * cos(beta + beta_step);
        rb23 = r23 * cos(beta + beta_step);
        rb24 = r24 * cos(beta + beta_step);
        theta_mod = theta % 360;

        // These fudge factors are required to force the object to be simple
        xf = 0.001 * ((beta >= 0 && beta < 180) ? -1 : 1);
        yf = 0.001 * (((theta_mod >= 0 && theta_mod < 90) ||
                       (theta_mod >= 270 && theta_mod < 360)) ? 1 : -1);

        x1 = (r11 + rb11) * cos(theta);
        x2 = (r11 + rb21) * cos(theta) + xf;
        x3 = (r12 + rb23) * cos(theta + theta_step) + xf;
        x4 = (r12 + rb13) * cos(theta + theta_step);
        x5 = (r11 + rb12) * cos(theta);
        x6 = (r11 + rb22) * cos(theta) + xf;
        x7 = (r12 + rb24) * cos(theta + theta_step) + xf;
        x8 = (r12 + rb14) * cos(theta + theta_step);
        y1 = (r11 + rb11) * sin(theta);
        y2 = (r11 + rb21) * sin(theta);
        y3 = (r12 + rb23) * sin(theta + theta_step) + yf;
        y4 = (r12 + rb13) * sin(theta + theta_step) + yf;
        y5 = (r11 + rb12) * sin(theta);
        y6 = (r11 + rb22) * sin(theta);
        y7 = (r12 + rb24) * sin(theta + theta_step) + yf;
        y8 = (r12 + rb14) * sin(theta + theta_step) + yf;
        z1 = r21 * sin(beta);
        z2 = r21 * sin(beta + beta_step);
        z3 = r23 * sin(beta + beta_step);
        z4 = r23 * sin(beta);
        z5 = r22 * sin(beta);
        z6 = r22 * sin(beta + beta_step);
        z7 = r24 * sin(beta + beta_step);
        z8 = r24 * sin(beta);

        // octahedron
        polyhedron(
            points = [
                [x1, y1, z1], [x2, y2, z2], [x3, y3, z3], [x4, y4, z4],
                [x5, y5, z5], [x6, y6, z6], [x7, y7, z7], [x8, y8, z8]
            ],
            faces = [
                [3, 0, 1], [3, 1, 2],                // Bottom
                [0, 4, 5], [0, 5, 1],                // Front
                [1, 5, 6], [1, 6, 2],                // Right
                [3, 7, 4], [3, 4, 0],                // Left
                [4, 7, 6], [4, 6, 5],                // Top
                [7, 3, 2], [7, 2, 6]                 // Back
            ]
        );
    }
}

module shell_outer() {
    union() {
        for(theta = [shell_min : theta_step : shell_max - theta_step]) {
            r11 = (r(theta) + r(theta - 360)) / 2;
            r12 = (r(theta + theta_step) + r(theta + theta_step - 360)) / 2;
            r21 = (r(theta) - r(theta - 360)) / 2 - shell_thickness / 2;
            r22 = (r(theta) - r(theta - 360)) / 2 + shell_thickness / 2;
            r23 = (r(theta + theta_step) - r(theta + theta_step - 360)) / 2 - shell_thickness / 2;
            r24 = (r(theta + theta_step) - r(theta + theta_step - 360)) / 2 + shell_thickness / 2;

            shell_outer_ring(theta, r11, r12, r21, r22, r23, r24);
        }
    }
}

module shell_inner() {
    union() {
        for(theta = [shell_min : theta_step : shell_max - theta_step]) {
            r11 = (r(theta) + r(theta - 360)) / 2;
            r12 = (r(theta + theta_step) + r(theta + theta_step - 360)) / 2;
            r21 = (r(theta) - r(theta - 360)) / 2 - shell_thickness / 2;
            r22 = (r(theta) - r(theta - 360)) / 2 + shell_thickness / 2;
            r23 = (r(theta + theta_step) - r(theta + theta_step - 360)) / 2 - shell_thickness / 2;
            r24 = (r(theta + theta_step) - r(theta + theta_step - 360)) / 2 + shell_thickness / 2;

            // A bit of a mess, sorry
            if(wall && (theta - shell_min) < (wall_fill_percent / 100) * (shell_max - shell_min) && theta % (wall_step * theta_step) == 0) {
                rotate([90, 0, theta])
                    translate([r11, 0.000 * theta, -0.0045 * theta])
                    scale([1, 1, 0.75]) {
                    difference() {
                        sphere(r21 + shell_sphere_thickness, $fn = 360 / beta_step);
                        scale([1.07, 1.08, 1]) sphere(r21, $fn = 360 / beta_step);
                        translate([-r21 - 2 * shell_thickness,
                                   -r21 - 2 * shell_thickness,
                                   -r21 - 2 * shell_thickness - 2]) {
                            cube([2 * (r21 + 2 * shell_thickness),
                                  2 * (r21 + 2 * shell_thickness),
                                  r21 + 2 * shell_thickness + 2]);
                        }
                        if(half) {
                            translate([-r21 - 2 * shell_thickness,
                                       -2 * (r21 + 2 * shell_thickness),
                                       -1])
                                cube([2 * (r21 + 2 * shell_thickness),
                                      2 * (r21 + 2 * shell_thickness),
                                      r21 + 2 * shell_thickness + 2]);
                        }
                    }
                }
            }
        }
    }
}

module shell_half() {
    scale(shell_scale)
    union() {
        shell_outer();
        shell_inner();
    }
}

difference() {
    union() {
        mirror([0, has_shaft ? 180 : 0, 0])
        shell_half();
        cylinder(h=has_shaft? 2.20 : 6, r=3.5);
    }
    translate([0,0,-.1]) cylinder(h=has_shaft? 2 : 5.5, r=has_shaft ? 2.55 : 2.6);
}

if(has_shaft) {
    translate([30,-30,0]) cylinder(h=5.5+2-0.2, r=2.45);
}