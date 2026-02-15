/*
  J401 Simple Mounting Tray (open top)
  - Open from above (no lid)
  - One side has a big opening for I/O cables
  - 4 standoffs with clearance holes for M3 screws
  - Optional heat-set insert pockets (for M3)

  Units: millimeters
*/

$fn = 64;

// -----------------------
// Key dimensions (edit)
// -----------------------

// Board envelope (J401 robotics reference is ~115x115)
board_x = 115;
board_y = 115;

// Extra space around board inside the tray
clearance = 6; // space between board edge and tray walls

// Tray base thickness + wall
base_thickness = 3;
wall_thickness = 3;
wall_height = 18; // height of the side walls (tray is open on top)

// Open side for I/O cables (cutout on one wall)
io_open_side = "left"; // "left" "right" "front" "back"
io_open_width = 90; // width of opening
io_open_height = 14; // height of opening from base
io_open_bottom_offset = 3; // how high above base the opening starts

// Standoffs (board mounting)
standoff_height = 8; // height of standoffs above base
standoff_od = 8; // outer diameter of standoff boss
standoff_hole_d = 3.2; // M3 clearance (NOT tapping into plastic)

// If you want heat-set inserts in the standoffs:
use_heatset_inserts = true;
insert_hole_d = 4.6; // typical for many M3 heat-set inserts (verify for yours!)
insert_hole_depth = 5.5;

// Board mounting hole positions (relative to board bottom-left corner)
// IMPORTANT: these are placeholders.
// Measure/confirm your J401 hole pattern and edit these.
hole_positions = [
  [8, 8],
  [107, 8],
  [107, 107],
  [8, 107],
];

// -----------------------
// Derived dimensions
// -----------------------
inner_x = board_x + 2 * clearance;
inner_y = board_y + 2 * clearance;

outer_x = inner_x + 2 * wall_thickness;
outer_y = inner_y + 2 * wall_thickness;
outer_z = base_thickness + wall_height;

// Board origin inside tray (bottom-left corner of board)
board_origin_x = wall_thickness + clearance;
board_origin_y = wall_thickness + clearance;

// -----------------------
// Helpers
// -----------------------
module rounded_cube(size = [10, 10, 10], r = 2) {
  // cheap rounded box via minkowski (ok for small prints)
  minkowski() {
    cube([size[0] - 2 * r, size[1] - 2 * r, size[2] - 2 * r], center=false);
    sphere(r=r);
  }
}

module io_cutout() {
  // Cutout centered on chosen wall
  w = io_open_width;
  h = io_open_height;
  z0 = base_thickness + io_open_bottom_offset;

  if (io_open_side == "left") {
    translate([0, (outer_y - w) / 2, z0])
      cube([wall_thickness + 0.5, w, h], center=false);
  } else if (io_open_side == "right") {
    translate([outer_x - (wall_thickness + 0.5), (outer_y - w) / 2, z0])
      cube([wall_thickness + 0.5, w, h], center=false);
  } else if (io_open_side == "front") {
    translate([(outer_x - w) / 2, 0, z0])
      cube([w, wall_thickness + 0.5, h], center=false);
  } else if (io_open_side == "back") {
    translate([(outer_x - w) / 2, outer_y - (wall_thickness + 0.5), z0])
      cube([w, wall_thickness + 0.5, h], center=false);
  }
}

module standoff_at(x, y) {
  // x,y are relative to board bottom-left corner
  sx = board_origin_x + x;
  sy = board_origin_y + y;

  difference() {
    // boss
    translate([sx, sy, base_thickness])
      cylinder(h=standoff_height, d=standoff_od);

    // through hole
    translate([sx, sy, 0])
      cylinder(h=base_thickness + standoff_height + 1, d=standoff_hole_d);

    // insert pocket from top of standoff (optional)
    if (use_heatset_inserts) {
      translate([sx, sy, base_thickness + standoff_height - insert_hole_depth])
        cylinder(h=insert_hole_depth + 0.2, d=insert_hole_d);
    }
  }
}

// -----------------------
// Main tray
// -----------------------
difference() {
  // Outer body: base + walls
  // Use a simple cube (faster) instead of rounded for first iteration
  cube([outer_x, outer_y, outer_z], center=false);

  // Hollow out the inside (leave base thickness)
  translate([wall_thickness, wall_thickness, base_thickness])
    cube([inner_x, inner_y, wall_height + 1], center=false);

  // I/O opening on one wall
  io_cutout();
}

// Add standoffs
for (p = hole_positions) {
  standoff_at(p[0], p[1]);
}
