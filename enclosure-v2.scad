/*
  J401 V2 Enclosure (Closed) — Open I/O side + Bottom fan cutout (RECTANGULAR)

  Your constraints:
  - I/O side: fully open (no wall)
  - Fan side (bottom): opening present (not closed)
  - Closed everywhere else
  - Mounting hole pattern unchanged: 103 x 102 mm center-to-center
  - Outside-to-outside dimensions are derived from your measured outside margins
  - No extra tolerances added (you already accounted for them)

  Fan opening (as provided):
  - Y direction (front/back): 58 mm
  - X direction (left/right): 40 mm

  Units: millimeters
*/

$fn = 64;

// -----------------------
// INPUTS (edit only if needed)
// -----------------------

// Outside height (outside wall to outside wall)
outer_h = 55;  // mm

// Wall thickness (side walls)
wall_t = 3;    // mm

// Bottom + Top thickness
bottom_t = 3;  // mm
top_t    = 2;  // mm  -> inner height becomes 50 mm

// Fan opening size (NO extra tolerance)
fan_open_x = 40;  // mm (left-right)
fan_open_y = 58;  // mm (front-back)

// Fan opening margins from OUTSIDE walls (outside-to-outside reference)
fan_margin_front = 45; // mm from I/O/front outer wall to fan opening edge
fan_margin_back  = 44; // mm from back/top outer wall to fan opening edge
fan_margin_left  = 37; // mm from left outer wall to fan opening edge
fan_margin_right = 41; // mm from right outer wall to fan opening edge

// I/O side open (fully remove this wall)
open_side = "front"; // "front" "back" "left" "right"

// Mounting holes (for screws from bottom into your existing standoffs)
mount_dx = 103;     // mm
mount_dy = 102;     // mm
mount_hole_d = 3.2; // mm (M3 clearance)

// Optional screw head relief from bottom (set to 0 to disable)
screw_relief_d = 6.5;
screw_relief_depth = 1.5;

// -----------------------
// DERIVED OUTSIDE FOOTPRINT
// -----------------------
outer_x = fan_margin_left + fan_open_x + fan_margin_right;
outer_y = fan_margin_front + fan_open_y + fan_margin_back;

// Inner cavity size
inner_x = outer_x - 2*wall_t;
inner_y = outer_y - 2*wall_t;
inner_h = outer_h - bottom_t - top_t;

echo("V2 Outer size (X,Y,Z): ", outer_x, outer_y, outer_h);
echo("V2 Inner size (X,Y,Z): ", inner_x, inner_y, inner_h);

// -----------------------
// HELPERS
// -----------------------
module remove_open_wall() {
  eps = 0.6;

  // Remove the entire selected wall (full height)
  if (open_side == "front") { // y = 0 wall
    translate([-eps, -eps, 0])
      cube([outer_x + 2*eps, wall_t + 2*eps, outer_h + 2*eps], center=false);

  } else if (open_side == "back") { // y = outer_y wall
    translate([-eps, outer_y - wall_t - eps, 0])
      cube([outer_x + 2*eps, wall_t + 2*eps, outer_h + 2*eps], center=false);

  } else if (open_side == "left") { // x = 0 wall
    translate([-eps, -eps, 0])
      cube([wall_t + 2*eps, outer_y + 2*eps, outer_h + 2*eps], center=false);

  } else if (open_side == "right") { // x = outer_x wall
    translate([outer_x - wall_t - eps, -eps, 0])
      cube([wall_t + 2*eps, outer_y + 2*eps, outer_h + 2*eps], center=false);
  }
}

module fan_cutout_bottom() {
  // Cut through bottom thickness only
  eps = 0.6;

  x0 = fan_margin_left;
  y0 = fan_margin_front;

  translate([x0, y0, -eps])
    cube([fan_open_x, fan_open_y, bottom_t + 2*eps], center=false);
}

module mounting_hole_at(x, y) {
  // Through-hole (goes through entire enclosure height)
  translate([x, y, -0.5])
    cylinder(h=outer_h + 1, d=mount_hole_d);

  // Optional screw-head relief from bottom
  if (screw_relief_d > 0) {
    translate([x, y, 0])
      cylinder(h=screw_relief_depth, d=screw_relief_d);
  }
}

// -----------------------
// MOUNT HOLE POSITIONS (CENTERED)
// -----------------------
cx = outer_x/2;
cy = outer_y/2;

hole_positions = [
  [cx - mount_dx/2, cy - mount_dy/2],
  [cx + mount_dx/2, cy - mount_dy/2],
  [cx + mount_dx/2, cy + mount_dy/2],
  [cx - mount_dx/2, cy + mount_dy/2]
];

// -----------------------
// MAIN: CLOSED SHELL, OPEN ONE SIDE, FAN OPENING, MOUNT HOLES
// -----------------------
difference() {
  // Outer closed block
  cube([outer_x, outer_y, outer_h], center=false);

  // Hollow cavity (leaves walls + bottom + top)
  translate([wall_t, wall_t, bottom_t])
    cube([inner_x, inner_y, inner_h], center=false);

  // Open I/O side fully
  remove_open_wall();

  // Fan opening on bottom
  fan_cutout_bottom();

  // 4 mounting holes for screws into standoffs
  for (p = hole_positions)
    mounting_hole_at(p[0], p[1]);
}
