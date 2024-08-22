use <lib.scad>

function mk_spec(body) = [
  [ "INNER_DIAMETER", /*                  */ 60 ],
  [ "INNER_HEIGHT", /*                    */ 25 ],
  [ "WALL_THICKNESS", /*                   */ 4 ],
  [ "SCREW_STEP", /*                       */ 3 ],
  [ "SCREW_HEAD_HEIGHT", /*                */ body ? 9 : 18 ],
  [ "SCREW_HEAD_WIDTH", /*                */ 70 ],
  [ "CHAMFER", /*                          */ 2 ],
];

module pillbox_cap() {
    cap(mk_spec(false));
}

module pillbox_main() {
    main(mk_spec(true));
}

pillbox_main();
