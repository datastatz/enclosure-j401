# J401 Open-Top Mounting Tray (OpenSCAD) — WIP

This repo contains a simple **OpenSCAD** design for an **open-top tray** to mount a **Seeed reComputer Robotics J401** carrier board (with Jetson module) so it:

- stays stable on a desk / bench
- can’t slide or fall easily
- doesn’t require constantly touching/repositioning the board
- keeps the top open for airflow / quick access
- has one side open (or cut out) so cables can be plugged in

> **Status:** Work in progress (WIP). Dimensions and mounting pattern still need to be verified.

---

## Goal

The end goal is a **practical enclosure/tray** where we can mount the J401 securely, with minimal handling during development (PoC v1). This is not meant to be a finished “product enclosure” yet—just a sturdy, printable mounting solution.

---

## Current state (WIP notes)

The design includes:
- a bottom base plate
- walls on the sides (open from above)
- an I/O opening on one side for cable access
- 4 standoff/boss locations (currently placeholder coordinates)
- optional pockets for heat-set inserts

**Still to verify / decide:**
- Which **standoffs/inserts** we will actually use (heat-set inserts vs nuts vs direct plastic)
- The exact **mounting hole pattern** (montagegaten) of our J401 configuration
- Correct **hole diameters**, standoff **outer diameter**, and standoff **height**
- Clearance around I/O and cable bend radius for our actual setup

---

## How to render / preview in VS Code

I use the **Leathong OpenSCAD extension** in VS Code.

- Press **F5** to render/preview.

(If F5 doesn’t work, check VS Code keybindings and ensure the Leathong extension is enabled.)

---

## How to export STL

In OpenSCAD:

1. Open the `.scad` file.
2. Press **F6** (Render).
3. `File → Export → Export as STL`.

That `.stl` is what you send to your slicer / printer.

---

## Next steps

- [ ] Confirm the J401 **mounting hole coordinates** (from DXF or physical measurement)
- [ ] Decide on fastener strategy:
  - heat-set inserts (recommended for repeatable assembly)
  - captive nuts
  - self-tapping screws (not preferred)
- [ ] Tune standoff dimensions + tolerances for printing
- [ ] Print test version and validate fit (ports + height + stability)

---

## Disclaimer

This design is a prototype helper for development use. Always validate mechanical fit, tolerances, and thermal behavior before relying on it for long runtime use.
