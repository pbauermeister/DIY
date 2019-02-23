include <Getriebe.scad>

GEAR_BEVEL_PAIR_TOGETHER = 0;
GEAR_BEVEL_PAIR_SEPARATE_FLAT = 1;
GEAR_BEVEL_PAIR_ONLY_WHEEL = 2;
GEAR_BEVEL_PAIR_ONLY_PINION = 3;
GEAR_BEVEL_PAIR_ONLY_PINION_FLAT = 4;

module gear_bevel_pair(
    gears_module,
    wheel_teeth_nb,
    wheel_hole_diameter,
    pinion_teeth_nb,
    pinion_hole_diameter,
    teeth_width,
    axis_angle=90,
    pressure_angle=20, // DIN 867
    helix_angle=0,    
    generate_what=GEAR_BEVEL_PAIR_TOGETHER
){
    //
    // Dimensions-Berechnungen
    //

    // Teilkegelradius des Rads
    r_rad = gears_module*wheel_teeth_nb/2;


    // Kegelwinkel des Rads
    delta_rad =
      atan(sin(axis_angle) / (pinion_teeth_nb/wheel_teeth_nb+cos(axis_angle)));

    // Kegelwingel des Ritzels
    delta_ritzel =
      atan(sin(axis_angle)/(wheel_teeth_nb/pinion_teeth_nb+cos(axis_angle)));

    // Radius der Großkugel
    rg = r_rad/sin(delta_rad);

    // Kopfspiel
    c = gears_module / 6;

    // Fußkegeldurchmesser auf der Großkugel
    df_ritzel = 4*pi*rg*delta_ritzel/360 - 2 * (gears_module + c);

    // Fußkegelradius auf der Großkugel
    rf_ritzel = df_ritzel / 2;

    // Kopfkegelwinkel
    delta_f_ritzel = rf_ritzel/(2*pi*rg) * 360;

    // Radius des Kegelfußes
    rkf_ritzel = rg*sin(delta_f_ritzel);

    // Höhe des Kegels vom Fußkegel
    hoehe_f_ritzel = rg*cos(delta_f_ritzel);
	
    echo("Kegelwinkel Rad = ", delta_rad);
    echo("Kegelwinkel Ritzel = ", delta_ritzel);

    // Fußkegeldurchmesser auf der Großkugel
    df_rad = 4*pi*rg*delta_rad/360 - 2 * (gears_module + c);

    // Fußkegelradius auf der Großkugel
    rf_rad = df_rad / 2;

    // Kopfkegelwinkel
    delta_f_rad = rf_rad/(2*pi*rg) * 360;

    // Radius des Kegelfußes
    rkf_rad = rg*sin(delta_f_rad);

    // Höhe des Kegels vom Fußkegel
    hoehe_f_rad = rg*cos(delta_f_rad);

    echo("Höhe Rad = ", hoehe_f_rad);
    echo("Höhe Ritzel = ", hoehe_f_ritzel);
	
    drehen = istgerade(pinion_teeth_nb);

    //
    // Zeichnung
    //

    // Rad
    if (generate_what != GEAR_BEVEL_PAIR_ONLY_PINION &&
        generate_what != GEAR_BEVEL_PAIR_ONLY_PINION_FLAT)
	rotate([0,0,180*(1-spiel)/wheel_teeth_nb*drehen])
	    kegelrad(gears_module, wheel_teeth_nb, delta_rad, teeth_width,
		     wheel_hole_diameter, pressure_angle, helix_angle);
	
    // Ritzel
    if (generate_what != GEAR_BEVEL_PAIR_ONLY_WHEEL) {
        if (generate_what == GEAR_BEVEL_PAIR_TOGETHER || 
            generate_what == GEAR_BEVEL_PAIR_ONLY_PINION)
            translate([-hoehe_f_ritzel*cos(90-axis_angle),0,
                       hoehe_f_rad-hoehe_f_ritzel*sin(90-axis_angle)])
		rotate([0,axis_angle,0])
		kegelrad(gears_module, pinion_teeth_nb, delta_ritzel, teeth_width,
			 pinion_hole_diameter, pressure_angle, -helix_angle);
        else if (generate_what == GEAR_BEVEL_PAIR_SEPARATE_FLAT)
            translate([rkf_ritzel*2+gears_module+rkf_rad,0,0])
		kegelrad(gears_module, pinion_teeth_nb, delta_ritzel, teeth_width,
			 pinion_hole_diameter, pressure_angle, -helix_angle);
        else if (generate_what == GEAR_BEVEL_PAIR_ONLY_PINION_FLAT)
            kegelrad(gears_module, pinion_teeth_nb, delta_ritzel, teeth_width,
                     pinion_hole_diameter, pressure_angle, -helix_angle);
    }
}

