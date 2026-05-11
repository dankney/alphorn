// ============================================================
//  ALPHORN BAYONET JOINT TEST PRINT  (self-contained)
// ============================================================
//
//  Two short stubs that share a single bayonet joint, used to
//  validate the locking mechanism before printing full sections.
//
//  Self-contained — no external dependencies.
//
//  Test joint: between sections 8 and 9 of the main horn.
//  Bore ID at joint: 46.02mm
//  Body OD at joint: 61.37mm
//
//  HOW THE JOINT WORKS:
//  - Test piece A (female): body wall thickens at the top to form a
//    collar containing 3 L-shaped slots cut into its inner socket.
//    The collar is a single connected piece of material with the body.
//  - Test piece B (male): body wall has 3 rectangular lugs protruding
//    radially outward near the bottom, with an O-ring groove just below.
//
//  Assembly: align lugs with axial slots, push male in until lugs
//  bottom out, then twist ~30° to lock.
//
//  PRINT SETTINGS:
//    - Layer height: 0.2mm
//    - Wall loops:   4
//    - Infill:       20%
//    - Supports:     None
//    - Orientation:  As laid out
// ============================================================

// ============================================================
//  CONSTANTS  (must match alphorn.scad)
// ============================================================

BAYONET_LUGS    = 3;
BAYONET_DEPTH   = 15;
BAYONET_LUG_H   = 3.5;
BAYONET_LUG_W   = 8;
BAYONET_LUG_T   = 5;
BAYONET_COLLAR  = 20;
BAYONET_CL      = 0.25;
ORING_DEPTH     = 2.5;
ORING_WIDTH     = 2.2;
WALL_TRUNK      = 7.0;

// ============================================================
//  TEST PIECE DIMENSIONS  (section 8/9 boundary in main horn)
// ============================================================

JOINT_ID  = 46.02;     // bore ID at the joint plane
JOINT_OD  = 61.37;     // body OD at the joint plane

TEST_BODY_LEN = 50;
TEST_GAP      = 30;

TEST_OD_SMALL = 58.0;
TEST_ID_SMALL = 43.0;
TEST_OD_LARGE = 64.5;
TEST_ID_LARGE = 49.0;

// ============================================================
//  HELPER MODULES
// ============================================================

// Male lug solids — additive geometry.
// Each lug embeds 1mm into the body wall so its full tangential width
// overlaps with the curved body surface (the inner face of the cube
// would otherwise float just outside the curved wall at the lug's edges).
LUG_EMBED = 1.0;

module male_lugs(od) {
    lug_z_center = BAYONET_COLLAR - BAYONET_DEPTH;
    for (i = [0 : BAYONET_LUGS-1]) {
        rotate([0, 0, i * (360/BAYONET_LUGS)])
        translate([od/2 - LUG_EMBED, -BAYONET_LUG_W/2,
                   lug_z_center - BAYONET_LUG_T/2])
        cube([BAYONET_LUG_H + LUG_EMBED, BAYONET_LUG_W, BAYONET_LUG_T]);
    }
}

// O-ring groove — subtractive geometry (cuts a circumferential channel
// into the body's outer wall just behind the lugs).
// O-ring groove position: just above the lugs, within the body's first
// 20mm (the male collar region). Lugs at local z=[2.5, 7.5]; groove at
// z=[10, 12.2].
ORING_Z = 10;

module oring_groove(od, id) {
    translate([0, 0, ORING_Z])
    difference() {
        cylinder(h=ORING_WIDTH, r=od/2 + 0.1, $fn=128);
        translate([0, 0, -0.5])
        cylinder(h=ORING_WIDTH+1, r=od/2 - ORING_DEPTH, $fn=128);
    }
}

// ============================================================
//  TEST PIECE A — female end
//  Body + collar are a single unioned solid, then bored and
//  channeled in one difference().
// ============================================================

module test_piece_A() {
    socket_or = JOINT_OD/2 + BAYONET_LUG_H + BAYONET_CL;
    collar_or = socket_or + WALL_TRUNK/2;

    // EXTERNAL flare only: outer wall flares from body OD up to collar OD
    // over `flare_h` mm. The internal bore stays at JOINT_ID right up to
    // z=TEST_BODY_LEN (the joint plane). This keeps the acoustic bore
    // unaltered — no internal widening before the joint.
    //
    // At the joint plane (z=TEST_BODY_LEN), the bore steps abruptly from
    // JOINT_ID to the inner socket diameter. This step is BEHIND the male
    // collar when assembled — the male collar's outer wall covers it, and
    // the male collar's bore is JOINT_ID, so the assembled-bore continues
    // smoothly through the joint with no acoustic discontinuity.
    flare_h = 8;
    body_h  = TEST_BODY_LEN - flare_h;

    difference() {
        // Outer hull: body + external flare + collar (all unioned)
        union() {
            // Main body taper
            cylinder(h=body_h,
                     r1=TEST_OD_SMALL/2, r2=JOINT_OD/2, $fn=128);
            // External flare ONLY (outer wall thickens)
            translate([0, 0, body_h])
            cylinder(h=flare_h,
                     r1=JOINT_OD/2, r2=collar_or, $fn=128);
            // Female collar block
            translate([0, 0, TEST_BODY_LEN])
            cylinder(h=BAYONET_COLLAR, r=collar_or, $fn=128);
        }

        // Bore: continuous taper from base all the way to the joint plane.
        // No internal widening — the bore stays on its original profile
        // right up to z=TEST_BODY_LEN.
        translate([0, 0, -0.5])
        cylinder(h=TEST_BODY_LEN + 0.5,
                 r1=TEST_ID_SMALL/2, r2=JOINT_ID/2, $fn=128);

        // Inner socket: only above the joint plane (inside the collar).
        // The step from bore to socket happens AT z=TEST_BODY_LEN, not before.
        translate([0, 0, TEST_BODY_LEN])
        cylinder(h=BAYONET_COLLAR + 0.5,
                 r=JOINT_OD/2 + BAYONET_CL, $fn=128);

        // L-channels in the collar
        translate([0, 0, TEST_BODY_LEN])
        l_channels_only(od=JOINT_OD);
    }
}

// Just the L-shaped lug paths, no inner socket or bore
// (those are handled by the smooth transition above)
module l_channels_only(od) {
    slot_half_angle = atan2(BAYONET_LUG_W/2 + BAYONET_CL,
                            od/2 + BAYONET_CL);
    slot_angle      = 2 * slot_half_angle;
    lock_angle      = 30;

    slot_z_bottom = BAYONET_COLLAR - BAYONET_DEPTH - BAYONET_LUG_T/2 - BAYONET_CL;
    slot_z_top    = BAYONET_COLLAR + 1;
    lock_z_bottom = slot_z_bottom;
    lock_z_top    = BAYONET_COLLAR - BAYONET_DEPTH + BAYONET_LUG_T/2 + BAYONET_CL;

    chan_r_inner = od/2 + BAYONET_CL;
    chan_r_outer = od/2 + BAYONET_CL + BAYONET_LUG_H + BAYONET_CL;

    for (i = [0 : BAYONET_LUGS-1]) {
        rotate([0, 0, i * (360/BAYONET_LUGS)]) {
            // Axial entry slot
            rotate([0, 0, -slot_half_angle])
            translate([0, 0, slot_z_bottom])
            rotate_extrude(angle=slot_angle, $fn=128)
            translate([chan_r_inner, 0])
            square([chan_r_outer - chan_r_inner,
                    slot_z_top - slot_z_bottom]);

            // Tangential lock channel
            rotate([0, 0, slot_half_angle])
            translate([0, 0, lock_z_bottom])
            rotate_extrude(angle=lock_angle, $fn=128)
            translate([chan_r_inner, 0])
            square([chan_r_outer - chan_r_inner,
                    lock_z_top - lock_z_bottom]);
        }
    }
}

// ============================================================
//  TEST PIECE B — male end
//  Body wall continues uninterrupted; lugs and O-ring are
//  additions/cuts on the existing body wall.
// ============================================================

module test_piece_B() {
    // Single difference() — outer hull (body + lugs unioned) minus
    // bore and O-ring groove. Result is one connected mesh.
    difference() {
        union() {
            // Collar region (constant OD)
            cylinder(h=BAYONET_COLLAR, r=JOINT_OD/2, $fn=128);
            // Body stub above the collar (taper)
            translate([0, 0, BAYONET_COLLAR])
            cylinder(h=TEST_BODY_LEN,
                     r1=JOINT_OD/2, r2=TEST_OD_LARGE/2, $fn=128);
            // Lugs — unioned into the same hull (embedded 1mm into wall)
            male_lugs(od=JOINT_OD);
        }
        // Bore through the whole piece
        translate([0, 0, -0.5])
        union() {
            cylinder(h=BAYONET_COLLAR + 1, r=JOINT_ID/2, $fn=128);
            translate([0, 0, BAYONET_COLLAR])
            cylinder(h=TEST_BODY_LEN + 1,
                     r1=JOINT_ID/2, r2=TEST_ID_LARGE/2, $fn=128);
        }
        // O-ring groove cut into outer wall
        oring_groove(od=JOINT_OD, id=JOINT_ID);
    }
}

// ============================================================
//  BED LAYOUT
// ============================================================

socket_or  = JOINT_OD/2 + BAYONET_LUG_H + BAYONET_CL;
collar_or  = socket_or + WALL_TRUNK/2;
spacing    = 2*collar_or + TEST_GAP;

translate([-spacing/2, 0, 0])
color("SaddleBrown")
test_piece_A();

translate([spacing/2, 0, 0])
color("Peru")
test_piece_B();
