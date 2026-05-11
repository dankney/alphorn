// ============================================================
//  ALPHORN DIAGNOSTIC: isolate which feature creates rings
//
//  USAGE:
//  Set each FEATURE_* flag to true/false and re-export STL.
//  Open the STL in Orca Slicer and use "split into objects" or
//  "auto-arrange". Count the disconnected pieces.
//
//  Start with everything OFF, then turn features ON one at a time
//  to identify which feature introduces the rings.
// ============================================================

FEATURE_FLARE          = true;   // The body→collar flare zone
FEATURE_FEMALE_COLLAR  = true;   // Outer collar wall above z=len
FEATURE_INNER_SOCKET   = true;   // The hollow inside the collar
FEATURE_L_CHANNELS     = true;   // Bayonet slot cuts in collar
FEATURE_SECTION_LABEL  = true;   // Recessed number text
FEATURE_COLLAR_CHAMFER = true;   // 45° bevel at collar top edge
FEATURE_MALE_LUGS      = true;   // 3 lugs at small end
FEATURE_ORING_GROOVE   = true;   // Annular groove at z=10
FEATURE_BORE           = true;   // Inner bore subtraction

// ---- SECTION GEOMETRY (use a mid-size straight section: section 8) ----
LEN          = 204.21;
OD0          = 52.98;     // small end OD
OD1          = 59.43;     // large end OD
ID0          = 38.78;
ID1          = 44.20;

// ---- BAYONET CONSTANTS ----
BAYONET_LUGS    = 3;
BAYONET_DEPTH   = 15;
BAYONET_LUG_H   = 3.5;
BAYONET_LUG_W   = 8;
BAYONET_LUG_T   = 5;
BAYONET_COLLAR  = 20;
BAYONET_CL      = 0.25;
ORING_DEPTH     = 2.5;
ORING_WIDTH     = 2.2;
ORING_Z         = 10;
WALL_TRUNK      = 7.0;
LUG_EMBED       = 1.0;
TEXT_SIZE       = 16;
TEXT_DEPTH      = 1.2;
TEXT_ANGLE      = 60;
COLLAR_CHAMFER  = 5.0;

// ---- DERIVED ----
flare_h    = FEATURE_FLARE ? 25 : 0;
body_h     = LEN - flare_h;
od_at_flare = OD0 + (OD1 - OD0) * (body_h / LEN);
socket_or  = OD1/2 + BAYONET_LUG_H + BAYONET_CL;
collar_or  = socket_or + WALL_TRUNK/2;
collar_h   = BAYONET_COLLAR;

difference() {
    // ---- OUTER HULL ----
    union() {
        // Body + flare + collar as one rotate_extrude polygon
        rotate_extrude(angle=360, $fn=128)
        polygon(points=[
            [OD0/2,        0],
            [od_at_flare/2, body_h],
            [collar_or,    LEN],
            [collar_or,    FEATURE_FEMALE_COLLAR ? LEN + collar_h : LEN],
            [0,            FEATURE_FEMALE_COLLAR ? LEN + collar_h : LEN],
            [0,            0]
        ]);

        // Male lugs
        if (FEATURE_MALE_LUGS) {
            lug_z_center = BAYONET_COLLAR - BAYONET_DEPTH;
            for (i = [0 : BAYONET_LUGS-1]) {
                rotate([0, 0, i * (360/BAYONET_LUGS)])
                translate([OD0/2 - LUG_EMBED, -BAYONET_LUG_W/2,
                           lug_z_center - BAYONET_LUG_T/2])
                cube([BAYONET_LUG_H + LUG_EMBED, BAYONET_LUG_W, BAYONET_LUG_T]);
            }
        }
    }

    // ---- BORE ----
    if (FEATURE_BORE) {
        translate([0, 0, -0.5])
        cylinder(h=LEN+1, r1=ID0/2, r2=ID1/2, $fn=128);
    }

    // ---- INNER SOCKET ----
    if (FEATURE_FEMALE_COLLAR && FEATURE_INNER_SOCKET) {
        translate([0, 0, LEN - 0.5])
        cylinder(h=collar_h + 1, r=OD1/2 + BAYONET_CL, $fn=128);
    }

    // ---- L-CHANNELS ----
    if (FEATURE_FEMALE_COLLAR && FEATURE_L_CHANNELS) {
        translate([0, 0, LEN]) {
            slot_half_angle = atan2(BAYONET_LUG_W/2 + BAYONET_CL, OD1/2 + BAYONET_CL);
            for (i = [0 : BAYONET_LUGS-1]) {
                rotate([0, 0, i * (360/BAYONET_LUGS)]) {
                    rotate([0, 0, -slot_half_angle])
                    translate([0, 0, BAYONET_COLLAR - BAYONET_DEPTH - BAYONET_LUG_T/2 - BAYONET_CL])
                    rotate_extrude(angle=2*slot_half_angle, $fn=128)
                    translate([OD1/2 + BAYONET_CL, 0])
                    square([BAYONET_LUG_H + 2*BAYONET_CL, BAYONET_COLLAR + 1]);

                    rotate([0, 0, slot_half_angle])
                    translate([0, 0, BAYONET_COLLAR - BAYONET_DEPTH - BAYONET_LUG_T/2 - BAYONET_CL])
                    rotate_extrude(angle=30, $fn=128)
                    translate([OD1/2 + BAYONET_CL, 0])
                    square([BAYONET_LUG_H + 2*BAYONET_CL, BAYONET_LUG_T + 2*BAYONET_CL]);
                }
            }
        }
    }

    // ---- SECTION LABEL ----
    if (FEATURE_FEMALE_COLLAR && FEATURE_SECTION_LABEL) {
        translate([0, 0, LEN])
        rotate([0, 0, TEXT_ANGLE])
        translate([OD1/2 + BAYONET_CL, 0, BAYONET_COLLAR / 2])
        rotate([0, 90, 0])
        mirror([1, 0, 0])
        linear_extrude(height=TEXT_DEPTH)
        text("8", size=TEXT_SIZE, halign="center", valign="center",
             font="Liberation Sans:style=Bold", $fn=32);
    }

    // ---- COLLAR CHAMFER ----
    if (FEATURE_FEMALE_COLLAR && FEATURE_COLLAR_CHAMFER) {
        translate([0, 0, LEN + collar_h - COLLAR_CHAMFER])
        cylinder(h=COLLAR_CHAMFER + 1,
                 r1=collar_or - COLLAR_CHAMFER,
                 r2=collar_or + 1,
                 $fn=128);
    }

    // ---- ORING GROOVE ----
    if (FEATURE_ORING_GROOVE) {
        translate([0, 0, ORING_Z])
        rotate_extrude(angle=360, $fn=128)
        translate([OD0/2 - ORING_DEPTH, 0])
        square([ORING_DEPTH + 5, ORING_WIDTH]);
    }
}
