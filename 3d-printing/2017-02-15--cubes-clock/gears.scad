// ============================================================================
// NOTES:
// Library file. To be imported via the use <> statement.
// You can render it for test, but do not export to STL.
//
// ============================================================================

include <lib/wheel-lib.scad>
include <definitions.scad>

module _wheel(modul, zahnzahl, hoehe, bohrung, eingriffswinkel, schraegungswinkel) {
    pfeilrad(modul, zahnzahl, hoehe, bohrung, eingriffswinkel, schraegungswinkel);
}

module gears_check_distance() {
    if (gears_distance()!=GEARS_DISTANCE)
        echo(str("### WARNING: GEARS_DISTANCE should be equal to ", gears_distance(), " but is ", GEARS_DISTANCE));
    else
        echo(str("GEARS_DISTANCE is ", GEARS_DISTANCE, " -- OK"));
}

module gears_wheel() {
    gears_check_distance() {}
    rotate([0, 0, 360/30/2])
    _wheel(modul=GEARS_MODULE, zahnzahl=30, hoehe=GEARS_THICKNESS, bohrung=WHEEL_HOLE_DIAMETER, eingriffswinkel=20, schraegungswinkel=20);
}

function gears_wheel_radius(inner=false, median=false) =
    gear_radius(inner=inner, median=median,
                modul=GEARS_MODULE, zahnzahl=30,
                eingriffswinkel=20, schraegungswinkel=20);

module gears_pinion() {
    gears_check_distance() {}
    _wheel(modul=GEARS_MODULE, zahnzahl=14, hoehe=GEARS_THICKNESS, bohrung=SCREW2_DIAMETER + TOLERANCE*2, eingriffswinkel=20, schraegungswinkel=-20);
}

function gears_pinion_radius(inner=false, median=false) =
    gear_radius(inner=inner, median=median,
                modul=GEARS_MODULE, zahnzahl=14,
                eingriffswinkel=20, schraegungswinkel=-20);

function gears_distance() = gears_wheel_radius(median=true) +
                            gears_pinion_radius(median=true) + TOLERANCE*0;

module gears_test() {
    gears_wheel();

    translate([GEARS_DISTANCE + 3*0, 0, 0])
    gears_pinion();

    translate([0, 20, 0])
    cylinder(h=4, r=2/2 - TOLERANCE*1.5);

    translate([GEARS_DISTANCE, 20, 0])
    cylinder(h=4, r=2/2 - TOLERANCE*1.5);

    translate([-GEARS_DISTANCE/2, 20 - 2.5, 0])
    cube([GEARS_DISTANCE*2, 5, 1]);
}

gears_test();
echo("GEARS_DISTANCE", GEARS_DISTANCE);
echo("Sum radii", gears_wheel_radius() + gears_pinion_radius() + TOLERANCE);

function gear_radius(inner=false, median=false,
    modul, zahnzahl, eingriffswinkel, schraegungswinkel) =
	// Dimensions-Berechnungen	
	let(d = modul * zahnzahl)								// Teilkreisdurchmesser
	let(r = d / 2)											// Teilkreisradius
	let(alpha_stirn = atan(tan(eingriffswinkel)/cos(schraegungswinkel)))	// Schrägungswinkel im Stirnschnitt
	let(db = d * cos(alpha_stirn))							// Grundkreisdurchmesser
	let(rb = db / 2)										// Grundkreisradius
	let(da = (modul <1)? d + modul * 2.2 : d + modul * 2)	// Kopfkreisdurchmesser nach DIN 58400 bzw. DIN 867
	let(ra = da / 2)										// Kopfkreisradius
    (median ? r : (inner ? rb : ra));