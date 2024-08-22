SPEC = [
  [ "INNER_DIAMETER", /*                  */ 40 ],
  [ "INNER_HEIGHT", /*                   */ 143/5 ],
  [ "WALL_THICKNESS", /*                   */ 4 ],
  [ "SCREW_STEP", /*                       */ 3 ],
  [ "SCREW_HEAD_HEIGHT", /*               */ 15 ],
  [ "SCREW_HEAD_WIDTH", /*                */ 50 ],
  [ "CHAMFER", /*                          */ 2 ],
];

FN = $preview ? 180 / 18 : 180 / 2;
PLAY = 0.35;
$fn = FN;

function get(spec, item) = (                                                
    item == "TURNS" ? get(spec, "INNER_HEIGHT") / get(spec, "SCREW_STEP") : 
        item == "ANGLE_STEP" ? 360 / FN
                             : 
        item == "ANGLE_MAX" ? 360 * get(spec, "TURNS")
                            : 
        spec[search([item], spec)[0]][1]);


module screw_el(spec, angle, extra = 0) {
  z = get(spec, "INNER_HEIGHT") / get(spec, "ANGLE_MAX") * angle;
  // echo(angle, z);
  translate([ 0, 0, z ]) rotate([ 0, 0, angle ])
      translate([ get(spec, "INNER_DIAMETER") / 2, 0, 0 ]) rotate([ 0, 45, 0 ])
          cube(get(spec, "WALL_THICKNESS") + extra * 2, center = true);
}

module screw_envelope(spec) {
  r = get(spec, "WALL_THICKNESS");
  diameter = get(spec, "INNER_DIAMETER") + get(spec, "WALL_THICKNESS") * 2;
  translate([ 0, 0, get(spec, "INNER_HEIGHT") - r ])
      rotate_extrude(convexity = 10) translate([ diameter / 2 - r, 0, 0 ])
          circle(r = r, $fn = 100);

  cylinder(d = diameter, h = get(spec, "INNER_HEIGHT") - r);
}

module head_0(spec) {
  screw_head_d =
      sqrt(5 / 4) * get(spec, "SCREW_HEAD_WIDTH") - get(spec, "CHAMFER");
  translate([ 0, 0, -get(spec, "WALL_THICKNESS") + get(spec, "CHAMFER") ])
      minkowski() {
    cylinder(d = screw_head_d,
             h = get(spec, "SCREW_HEAD_HEIGHT") - 2 * get(spec, "CHAMFER"),
             $fn = 6);
    sphere(get(spec, "CHAMFER"), $fn = 6 * 2);
  }
}

module screw_0(spec, hh = 0, extra = 0) {
  h = hh ? hh : get(spec, "INNER_HEIGHT");

  turns = h / get(spec, "SCREW_STEP");
  angle_max = turns * 360;
  for (angle = [-180:get(spec, "ANGLE_STEP"):angle_max + 360]) {
    hull() {
      screw_el(spec, angle, extra = extra);
      screw_el(spec, angle + get(spec, "ANGLE_STEP"), extra = extra);
    }
  }
}

module screw(spec) {
  intersection() {
    screw_0(spec);
    screw_envelope(spec);
  }
  head_0(spec);
}

module inner_cut(spec) {
  cylinder(d = get(spec, "INNER_DIAMETER"), h = get(spec, "INNER_HEIGHT") * 1.5,
           $fn = 90);
}

module top_cut(spec) {
  translate([ 0, 0, get(spec, "INNER_HEIGHT") + get(spec, "INNER_DIAMETER") ])
      cube(get(spec, "INNER_DIAMETER") * 2, center = true);
}

module bottom_cut(spec) {
  translate([ 0, 0, -get(spec, "INNER_DIAMETER") ])
      cube(get(spec, "INNER_DIAMETER") * 2, center = true);
}

module main(spec) {
  difference() {
    screw(spec);
    inner_cut(spec);
    top_cut(spec);
  }
}

module screw_cut(spec) {
  difference() {
    union() {
      screw_0(spec, h = SCREW_HEAD_HEIGHT, extra = PLAY);
      inner_cut(spec);
    }
    bottom_cut(spec);
  }
}

module cap(spec) {
  difference() {
    head_0(spec);
    screw_cut(spec);

    r = get(spec, "WALL_THICKNESS");
    diameter = get(spec, "INNER_DIAMETER") + get(spec, "WALL_THICKNESS") * 2;
    translate([
      0, 0,
      get(spec, "SCREW_HEAD_HEIGHT") - r + get(spec, "WALL_THICKNESS") * .4
    ]) rotate_extrude(convexity = 10) translate([ diameter / 2 - r, 0, 0 ])
        circle(r = r, $fn = 100);
  }
}

main(SPEC);