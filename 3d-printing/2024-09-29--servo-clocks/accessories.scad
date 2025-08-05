use <all.scad>

w = get_cube_width();

printing_cube_upper_fixture();

translate([w/2, -w/3, 0]) printing_cube_lower_fixture();

//translate([w/2+15, w/4, 0]) servo_shaft_wrench();
