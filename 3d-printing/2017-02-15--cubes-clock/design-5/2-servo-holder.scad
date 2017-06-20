use <1a-encoder.scad>

BASE_THICKNESS = 5;
ENCODER_RADIUS = 20;
ENCODER_ROTATION = -15*3 +15*5;
ENCODER_CAVITY_THICKNESS = 3;
ENCODER_ELEVATION = ENCODER_RADIUS + BASE_THICKNESS + 1;
ENCODER_SHIFT_X = -4; //-5;
ENCODER_SHIFT_Y = 5;

SERVO_HEIGHT = 8;

$fn = 90/3;

TOLERANCE = 0.2;

module top_wheel_tab(tab_height, external_radius, tab_radius) {
    intersection() {
        difference() {
            cylinder(h=tab_height, r=external_radius);
            translate([0, 0, -1]) cylinder(h=10, r=tab_radius);
        }
        translate([ENCODER_SHIFT_X + ENCODER_CAVITY_THICKNESS/2, 0, 0]) cube([5, 50, 20]);
    }
}

module top_wheel() {
    small_radius = 12.5;
    small_height = 51;
    external_radius = 28;
    intermediate_height = 36;

    tab_height = 1.5;
    tab_radius_1 = 21.2;
    tab_radius_2 = 19.2;
    tab_radius_2 = 19.2;
    tab_radius_3 = 17.2;
    tab_radius_4 = 15.2;
    tab_width = 2;

    wall_thickness = 1.5;
    crown_thickness = 4;
    dome_radius = external_radius - 2.5;
    dome_sink = 6.5;

    translate([0, 0, intermediate_height+TOLERANCE]) {

        // CROWN
        scale([1, 1, tab_height])
        difference() {
            cylinder(h=1, r=external_radius, true);
            cylinder(h=1, r=external_radius-crown_thickness, true);
        }

        // DOME
        difference() {
            // sphere
            translate([0, 0, -dome_sink])
            difference() {
                sphere(r=dome_radius);
                sphere(r=dome_radius - wall_thickness);
            }
            // bottom cut
            translate([0, 0, -100/2])
            cube(100, true);
            // top cut
            translate([0, 0, 100/2 + small_height-intermediate_height-TOLERANCE*2])
            cube(100, true);
            // peripheral holes
            for (a=[0:60:360]) {
                rotate([0, 0, a])
                translate([19.5, 0, 0])
                scale([1, 1.8, 100]) cylinder(h=1, r=4.5, true);
            }
            // axial hole
            scale([1, 1, 100])
            cylinder(h=1, r=small_radius+TOLERANCE, true);
        }
        

        // TABS
        th = tab_height; er = external_radius;
        rotate([0, 0, 90])  top_wheel_tab(th, er, tab_radius_1 - tab_width);
        rotate([0, 0, 180]) top_wheel_tab(th, er, tab_radius_2 - tab_width);
        rotate([0, 0, 270]) top_wheel_tab(th, er, tab_radius_3 - tab_width);
        rotate([0, 0, 0])   top_wheel_tab(th, er, tab_radius_4 - tab_width);
    }
}

module cylinders() {
    small_radius = 12.5;
    small_height = 51;
    external_radius = 28;
    intermediate_height = 36;
    
    // two cylinders
    cylinder(h=small_height, r=small_radius);
    cylinder(h=intermediate_height, r=external_radius);
    
    // lip (snap-in)
    radius = 0.25;
    thickness = 0.5;
    translate([0, 0, small_height+radius])
    minkowski() {
        cylinder(h=0.0001, r=small_radius);
        hull() {
            sphere(r=radius);
            translate([0, 0, +thickness]) sphere(r=radius);
        }
    }
}

module wheel_cavity() {
    height = 18;
    translate([0, 0, height/2])
    resize([100, 30, height])
    cube(1, true);
}


module encoder_cavity() {
    encoder_cavity_milling_size = 100;
    translate([-ENCODER_CAVITY_THICKNESS/2, -encoder_cavity_milling_size/2, BASE_THICKNESS])
    resize([ENCODER_CAVITY_THICKNESS, encoder_cavity_milling_size, encoder_cavity_milling_size])
    cube(1);
}

module servo_cavity() {
    height = SERVO_HEIGHT;
    axis_height = 4;
    axis_shift = 6;
    
    // body
    body_length = 22;
    body_width = 20;
    translate([-body_length/2 - axis_height,  axis_shift, 0])
    resize([body_length, body_width, height])
    cube(1, true);

    // axis
    axis_length = 10;
    axis_width = 12;
    translate([-axis_length/2, axis_width/2 - body_width/2 + axis_shift, 0])
    resize([axis_length, axis_width, height])
    cube(1, true);

    // connector
    connector_shift_y = -5;
    connector_shift_x = -15;
    connector_length = 11;
    connector_width = 20;
    translate([-connector_length/2 + connector_shift_x, axis_shift + connector_shift_y, 0])
    resize([connector_length, connector_width, height])
    cube(1, true);

    // plate
    plate_shift_x = -9;
    plate_thickness = 1;
    plate_length = 30;
    translate([-plate_thickness/2 + plate_shift_x, axis_shift, 0])
    resize([plate_thickness, plate_length, height])
    cube(1, true);
}

module all() {
    translate([ENCODER_SHIFT_X, ENCODER_SHIFT_Y, ENCODER_ELEVATION])
    rotate([ENCODER_ROTATION, 0, 0])
    rotate([0, 90, 90])
    rotate([90, -90, 0])
    encoder();

    difference() {
        cylinders();
        
        translate([ENCODER_SHIFT_X, 0, 0]){
            encoder_cavity();
            translate([-ENCODER_CAVITY_THICKNESS/2, ENCODER_SHIFT_Y, ENCODER_ELEVATION]) {
                for (i=[0:3]) {
                    translate([0, 0, i*SERVO_HEIGHT*0.99]) servo_cavity();
                }
            }
            wheel_cavity();
        }
    }

    // color("red") translate([0, 60, 0]) servo_cavity();

    color("yellow")
    top_wheel();
}

if (0) difference() { all(); cube(100); }
else all();