use <1a-encoder.scad>

BASE_THICKNESS = 5;
ENCODER_RADIUS = 20;
ENCODER_ROTATION = -15*3;
ENCODER_CAVITY_THICKNESS = 3;
ENCODER_ELEVATION = ENCODER_RADIUS + BASE_THICKNESS + 1;
ENCODER_SHIFT_X = -5;
ENCODER_SHIFT_Y = 5;

$fn = 48;

module slit() {
    slit_milling_size = 100;
    translate([-ENCODER_CAVITY_THICKNESS/2, -slit_milling_size/2, BASE_THICKNESS])
    resize([ENCODER_CAVITY_THICKNESS, slit_milling_size, slit_milling_size])
    cube(1);
}

module servo_cavity() {
    height = 8;
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

translate([ENCODER_SHIFT_X, ENCODER_SHIFT_Y, ENCODER_ELEVATION])
rotate([ENCODER_ROTATION, 0, 0])
rotate([0, 90, 90])
rotate([90, -90, 0])
encoder();

%difference() {
    cylinder(h=36, r=28);
    
    translate([ENCODER_SHIFT_X, 0, 0]){
        slit();
        translate([-ENCODER_CAVITY_THICKNESS/2, ENCODER_SHIFT_Y, ENCODER_ELEVATION]) {
            servo_cavity();
            translate([0, 0, 7]) servo_cavity();
        }
    }
}

// color("red") translate([0, 60, 0]) servo_cavity();
