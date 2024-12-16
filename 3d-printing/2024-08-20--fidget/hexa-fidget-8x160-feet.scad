use <hexa-fidget-8x160.scad>

HEIGHT             = get_height();
DIAMETER           = get_diameter();
FOOT_HEIGHT        = 30;
FOOT_WIDTH         = 30;
FOOT_THICKNESS     = 2;
FOOT_TAB_THICKNESS = FOOT_THICKNESS * 1.5; //.75;
TOLERANCE          = .3;
$fn                = 90;

module _foot() {
    for (a = [ 30, 180 - 30 ])
        rotate([ 0, 0, a ])
    {
        k = .1;
        hull() {
            translate([ 0, FOOT_WIDTH / 2, FOOT_HEIGHT * (1 - k) ])
            cylinder(d = FOOT_THICKNESS, h = max(FOOT_HEIGHT * k, 1));

            cylinder(d = FOOT_THICKNESS, h = FOOT_HEIGHT);
        }

        translate([ -FOOT_TAB_THICKNESS / 2, FOOT_WIDTH / 4, FOOT_HEIGHT ])
        cube([ FOOT_TAB_THICKNESS, FOOT_WIDTH / 4, HEIGHT - 1 ]);
    }
}

module foot() {
    difference() {
        _foot();

        translate([ -5 + TOLERANCE / 2, 0, FOOT_HEIGHT / 2 ])
        rotate([ 0, 0, 180 ])
        {
            _foot();
            //%_foot();
        }

        translate([ -5 - TOLERANCE / 2, 0, FOOT_HEIGHT / 2 ])
        rotate([ 0, 0, 180 ])
        {
            _foot();
            //%_foot();
        }
    }
}

if (0) {
    % make_fidget();
    translate([ DIAMETER / 2, 0, -FOOT_HEIGHT ])
    foot();

} else {
    for (i = [0:3 - 1]) {
        translate([ 0, 30 * i, 0 ])
        rotate([ 0, 90, 0 ])
        rotate([ 0, 0, 30 ])
        foot();
    }
}
