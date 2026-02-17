/*
  J401 Open-Top Mounting Tray (Centered Hole Pattern) — OPEN ONE SIDE COMPLETELY
  - Open from above (no lid)
  - One entire side wall removed for I/O cable access
  - Uses mounting-hole spacing:
      X (left-right) = 103.00 mm
      Y (top-bottom) = 102.00 mm
  - Tray has M3 clearance holes (3.2 mm) for screws from bottom into your standoffs

  Units: millimeters
*/

$fn = 64;

// -----------------------
// Core parameters
// -----------------------

// Approx board envelope (keep clearance generous)
board_x = 115;
board_y = 115;

// Mounting-hole rectangle (center-to-center)
mount_dx = 103;   // X spacing
mount_dy = 102;   // Y spacing

// Tray geometry
clearance_xy   = 8;   // space between board edge and tray walls
base_thickness = 3;
wall_thickness = 3;
wall_height    = 18;  // open-top tray wall height

// Mounting holes in tray (for screws from bottom into standoffs)
tray_hole_d = 3.2;    // M3 clearance
hole_relief_d = 6.5;  // optional screw head relief from bottom (set 0 to disable)
hole_relief_depth = 1.5;

// Remove an entire wall for I/O access
open_side = "front";  // "front" "back" "left" "right"

// Optional: feet holes
add_feet_holes = false;
feet_hole_d = 4.0;     // M4 clearance
feet_offset = 10;      // offset from outer corners

// -----------------------
// Derived dimensions
// -----------------------
inner_x = board_x + 2*clearance_xy;
inner_y = board_y + 2*clearance_xy;

outer_x = inner_x + 2*wall_thickness;
outer_y = inner_y + 2*wall_thickness;
outer_z = base_thickness + wall_height;

// Center of tray (origin for centered mounting)
cx = outer_x/2;
cy = outer_y/2;

// -----------------------
// Helpers
// -----------------------
module mounting_hole_at(x, y) {
  // Through-hole
  translate([x, y, 0])
    cylinder(h=outer_z + 1, d=tray_hole_d);

  // Optional screw head relief (counterbore) from bottom
  if (hole_relief_d > 0) {
    translate([x, y, 0])
      cylinder(h=hole_relief_depth, d=hole_relief_d);
  }
}

module feet_hole_at(x, y) {
  translate([x, y, 0])
    cylinder(h=base_thickness + 1, d=feet_hole_d);
}

// Removes the entire wall on the chosen side
module remove_entire_wall() {
  // We remove a rectangular slab that covers that wall region completely.
  // Add a small epsilon so subtraction always fully cuts.
  eps = 0.6;

  if (open_side == "front") { // y = 0 wall
    translate([-eps, -eps, base_thickness])
      cube([outer_x + 2*eps, wall_thickness + 2*eps, wall_height + 2*eps], center=false);

  } else if (open_side == "back") { // y = outer_y wall
    translate([-eps, outer_y - wall_thickness - eps, base_thickness])
      cube([outer_x + 2*eps, wall_thickness + 2*eps, wall_height + 2*eps], center=false);

  } else if (open_side == "left") { // x = 0 wall
    translate([-eps, -eps, base_thickness])
      cube([wall_thickness + 2*eps, outer_y + 2*eps, wall_height + 2*eps], center=false);

  } else if (open_side == "right") { // x = outer_x wall
    translate([outer_x - wall_thickness - eps, -eps, base_thickness])
      cube([wall_thickness + 2*eps, outer_y + 2*eps, wall_height + 2*eps], center=false);
  }
}

// -----------------------
// Hole positions (CENTERED rectangle)
// -----------------------
hole_positions = [
  [cx - mount_dx/2, cy - mount_dy/2],
  [cx + mount_dx/2, cy - mount_dy/2],
  [cx + mount_dx/2, cy + mount_dy/2],
  [cx - mount_dx/2, cy + mount_dy/2]
];

// -----------------------
// Main solid: tray (base + walls), open top, ONE SIDE WALL REMOVED
// -----------------------
difference() {
  // Outer block
  cube([outer_x, outer_y, outer_z], center=false);

  // Hollow interior (leaves base_thickness + walls)
  translate([wall_thickness, wall_thickness, base_thickness])
    cube([inner_x, inner_y, wall_height + 2], center=false);

  // Remove the entire chosen wall
  remove_entire_wall();

  // Mounting holes (for screws into your standoffs)
  for (p = hole_positions) {
    mounting_hole_at(p[0], p[1]);
  }

  // Optional feet holes near corners
  if (add_feet_holes && feet_hole_d > 0) {
    feet_hole_at(feet_offset, feet_offset);
    feet_hole_at(outer_x - feet_offset, feet_offset);
    feet_hole_at(outer_x - feet_offset, outer_y - feet_offset);
    feet_hole_at(feet_offset, outer_y - feet_offset);
  }
}
