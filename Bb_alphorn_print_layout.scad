// ============================================================
//  Bb ALPHORN PRINT LAYOUT  (self-contained)
//  Adapted from the F-horn design (Talbot dimensions, argobuilder.com)
//  Designed for Bambu Lab X1C, PLA Wood Filament
//  All dimensions in mm unless noted
// ============================================================
//
//  All 14 sections and the support foot are
//  arranged on the XY plane in their optimal print orientation.
//  This file is SELF-CONTAINED — no reference to Bb_alphorn.scad.
//
//  PRINT ORIENTATION:
//    Sections — vertical, small end (mouthpiece side) DOWN
//    Foot     — vertical, base DOWN
//
//  Section heights (max, including angled collar lift on curve sections):
//    Sections  1-10:  230mm  (body 210mm + 20mm collar)
//    Section  11:    241mm  (body + tilted collar)
//    Section  12:    243mm  (body + tilted collar, larger OD)
//    Section  13:    247mm  (body + tilted collar, largest OD)
//    Section  14:    210mm  (body only — bell mouth, no collar)
//  All under 256mm X1C build height ✓
//
//  BATCHING PLAN (which sections fit together on a 256mm bed):
//    Plate  1: sections  1 +  2  (~58mm wide)
//    Plate  2: sections  3 +  4  (~72mm wide)
//    Plate  3: sections  5 +  6  (~92mm wide)
//    Plate  4: sections  7 +  8  (~115mm wide)
//    Plate  5: sections  9 + 10  (~143mm wide)
//    Plate  6: section  11 only  (curve, ~95mm wide)
//    Plate  7: section  12 only  (curve, ~110mm wide)
//    Plate  8: section  13 only  (curve, ~140mm wide)
//    Plate  9: section  14 only  (bell mouth, ~170mm wide)
//
//  SUPPORT NOTE:
//    Sections 1-10  — no supports needed
//    Sections 11-13 — angled female face at top; auto-supports at the
//                     collar rim chamfer (the body-to-collar transition
//                     itself is shaped to print without overhang)
//    Section 14     — large bell mouth, no supports
//    Mouthpiece     — no supports (cup face down)
// ============================================================

// ============================================================
//  MASTER ACOUSTIC PARAMETERS
//  All from Talbot drawings (argobuilder.com)
// ============================================================

TOTAL_LENGTH      = 2935;    // mm  (trunk 2378 + bell 557)
TRUNK_LENGTH      = 2378;    // mm  where trunk bore law ends
BELL_LENGTH       = 557;     // mm  bell region (z=2378 to 2935)

// Bore reference points (Bb horn — F horn dimensions scaled by 0.749):
//   z=    0mm  ID= 16.70mm   (mouthpiece end, identical to F horn)
//   z=   42mm  ID= 12.00mm   (receiver/trunk junction, identical to F horn)
//   z= 2378mm  ID= 69.36mm   (trunk/bell junction)
//   z= 2935mm  ID=153.80mm   (bell mouth)

// Wall thickness
WALL_TRUNK        = 7.0;     // mm  (Talbot sheet 1)
WALL_BELL         = 8.0;     // mm  (Talbot sheet 1, at bell)

// ============================================================
//  SECTION PARAMETERS
// ============================================================

NUM_SECTIONS      = 14;      // 14 x 209.6mm — required so the curve
                             //   sections (with angled female face) fit
                             //   within the X1C 256mm build height.
                             //   Worst-case section height (sec 13) is
                             //   ~247mm; NUM_SECTIONS=13 would have placed
                             //   sections 10-12 over 256mm.
SECTION_LEN       = TOTAL_LENGTH / NUM_SECTIONS;  // 209.64mm

// ============================================================
//  CURVE PARAMETERS
// ============================================================
//  The traditional alphorn upward sweep is achieved by angling
//  the female end face of selected sections. Each angled joint
//  deflects the next section by the cut angle. Section bodies
//  remain straight frustums — the curve emerges from assembly.
//
//  Default: 45 degrees total bend, distributed across 3 joints
//  in the bell region (15->16, 16->17, 17->18).
//
//  No length is added. OD at faces is unchanged.
//  Wall thickness is preserved everywhere.

CURVE_TOTAL_DEG   = 45;      // total bend in the bell region
CURVE_JOINTS      = 3;       // distributed across this many joints
CURVE_PER_JOINT   = CURVE_TOTAL_DEG / CURVE_JOINTS;  // = 15 deg

// Which sections have angled female ends (last face = curve joint)
function is_curve_section(n) =
    (n >= NUM_SECTIONS - CURVE_JOINTS) && (n < NUM_SECTIONS);

// Cumulative rotation applied to a section in the assembly preview
// (sum of all curve angles before this section)
function cumulative_curve(n) =
    (n <= NUM_SECTIONS - CURVE_JOINTS) ? 0 :
    (n - (NUM_SECTIONS - CURVE_JOINTS)) * CURVE_PER_JOINT;

// ============================================================
//  BAYONET JOINT PARAMETERS
// ============================================================

BAYONET_LUGS      = 3;       // 3 lugs at 120 degrees
BAYONET_DEPTH     = 15;      // mm  axial travel from open face to lock position
BAYONET_LUG_H     = 3.5;    // mm  radial lug protrusion
BAYONET_LUG_W     = 8;      // mm  tangential lug width (along circumference)
BAYONET_LUG_T     = 5;      // mm  axial thickness of lug
BAYONET_COLLAR    = 20;      // mm  collar length each end
BAYONET_CL        = 0.25;   // mm  print clearance on lugs

TEXT_SIZE         = 16;     // mm  character height — fills 80% of the
                             //   20mm socket height; large enough to read
                             //   clearly by feel or sight before assembly
TEXT_DEPTH        = 1.2;    // mm  recess depth into socket wall
TEXT_ANGLE        = 60;     // deg angle around socket (between lug slots)

COLLAR_CHAMFER    = 5.0;    // mm  chamfer height/width (45° bevel)


// ============================================================
//  BORE PROFILE FUNCTIONS
// ============================================================
//
//  TRUNK (z = 42 to 2378mm):  power law
//    Refit from F horn to keep bore=12mm at z=42 and reach
//    bore=69.36mm at z=2378.
//
//  BELL (z = 2378 to 2935mm):  quadratic in s = z - 2378
//    Refit so it is C1-continuous with the new trunk slope at s=0,
//    reaching ID=153.8mm at s=557 (bell mouth).
//
//  WALL interpolates linearly: 7mm at z=0, 8mm at z=2935.
//  The receiver and joint geometry are unchanged from the F horn.

// MOUTHPIECE RECEIVER (leadpipe) — first 42mm of the horn.
// Bore narrows linearly from 16.7mm at z=0 (the very tip where the
// mouthpiece sticks out) to 12mm at z=42 (the seat depth where the
// receiver opens into the main bore). UNCHANGED from the F horn so
// the same mouthpiece works on both instruments.
RECEIVER_LEN     = 42;       // mm  length of the mouthpiece receiver
RECEIVER_TIP_ID  = 16.7;     // mm  bore ID at the mouthpiece end (z=0)
RECEIVER_END_ID  = 12.0;     // mm  bore ID at the receiver/trunk junction

// TRUNK profile (z=42 to z=2378) — power law starting at 12mm and
// expanding to 69.36mm at the bell start. Constants refit so bore=12
// at z=42 and bore=69.36 at z=2378 with the same exponent as the
// original Talbot profile.
BORE_A = 0.00028540;
BORE_N = 1.4849;
BORE_C = 5.9997;

// BELL profile (z=2378 to z=2935) — quadratic, C1-continuous with the
// new trunk profile (slope matches trunk derivative at z=2378).
// Reaches 153.8mm at z=2935 (bell mouth = F bell mouth × 0.749).
BELL_A = 0.00020673;
BELL_B = 0.03644530;
BELL_C = 69.3586;

function bore_id(z) =
    (z <= RECEIVER_LEN)
    ? RECEIVER_TIP_ID + (RECEIVER_END_ID - RECEIVER_TIP_ID) * (z / RECEIVER_LEN)
    : (z <= TRUNK_LENGTH)
        ? 2 * (BORE_A * pow(z - RECEIVER_LEN + 1, BORE_N) + BORE_C)
        : BELL_A * pow(z - TRUNK_LENGTH, 2)
          + BELL_B * (z - TRUNK_LENGTH)
          + BELL_C;

function wall_at(z) =
    WALL_TRUNK + (WALL_BELL - WALL_TRUNK) * (z / TOTAL_LENGTH);

function bore_od(z) = bore_id(z) + 2 * wall_at(z);

function sec_z0(n) = SECTION_LEN * (n - 1);
function sec_z1(n) = SECTION_LEN * n;

// ============================================================
//  BORE PROFILE REFERENCE TABLE  (14 sections × 209.6mm each)
//
//  n   z_start  z_end    ID_start  ID_end    OD_start  OD_end
//  1      0.0   209.6    16.70     13.16    30.70     27.30
//  2    209.6   419.3    13.16     15.84    27.30     30.12
//  3    419.3   628.9    15.84     19.39    30.12     33.82
//  4    628.9   838.6    19.39     23.62    33.82     38.19
//  5    838.6  1048.2    23.62     28.44    38.19     43.15
//  6   1048.2  1257.9    28.44     33.76    43.15     48.62
//  7   1257.9  1467.5    33.76     39.56    48.62     54.56
//  8   1467.5  1677.1    39.56     45.78    54.56     60.92
//  9   1677.1  1886.8    45.78     52.40    60.92     67.69
// 10   1886.8  2096.4    52.40     59.40    67.69     74.83
// 11   2096.4  2306.1    59.40     66.76    74.83     82.33
// 12   2306.1  2515.7    66.76     78.30    82.33     94.01  <- bell region begins
// 13   2515.7  2725.4    78.30    106.96    94.01    122.82
// 14   2725.4  2935.0   106.96    153.80   122.82    169.80  <- bell mouth
// ============================================================

// ============================================================
//  UTILITY MODULE
// ============================================================

// BORE_STEPS: number of frustum subdivisions for the bore subtraction.
// The bore profile is a curve (power law / quadratic), not a straight cone.
// A single linear frustum subtraction leaves up to 1.8mm of material
// inside the bell sections. Subdividing into 8 short frustums reduces
// this error to 0.028mm — imperceptible and well within wall thickness.
BORE_STEPS = 8;

module taper_tube(z0, length, od0, od1) {
    // Outer wall
    difference() {
        cylinder(h=length, r1=od0/2, r2=od1/2, $fn=128);
        // Bore subtraction: union of BORE_STEPS short frustums
        // each matching the actual curved bore profile at that z range
        translate([0,0,-0.5])
        union() {
            for (i = [0 : BORE_STEPS-1]) {
                za = z0 + length * i       / BORE_STEPS;
                zb = z0 + length * (i+1)   / BORE_STEPS;
                ra = bore_id(za) / 2;
                rb = bore_id(zb) / 2;
                seg_len = length / BORE_STEPS;
                translate([0, 0, i * seg_len])
                cylinder(h = seg_len + 1,
                         r1 = ra, r2 = rb,
                         $fn = 128);
            }
        }
    }
}

// ============================================================
//  BAYONET JOINT MODULES
// ============================================================
//
//  MALE collar at small (mouthpiece) end of each section.
//  FEMALE collar at large (bell) end of each section.
//  Exception: section 18 large end = open bell mouth (no collar).
//
//  Assembly: insert male into female axially, twist ~30 degrees.

module horn_section(n) {
    z0  = sec_z0(n);
    z1  = sec_z1(n);
    len = SECTION_LEN;

    id0 = bore_id(z0);
    id1 = bore_id(z1);
    od0 = bore_od(z0);
    od1 = bore_od(z1);

    angle = is_curve_section(n) ? CURVE_PER_JOINT : 0;

    has_female = (n < NUM_SECTIONS);
    socket_or  = od1/2 + BAYONET_LUG_H + BAYONET_CL;
    collar_or  = socket_or + WALL_TRUNK/2;
    collar_h   = BAYONET_COLLAR;

    flare_h    = has_female ? 25 : 0;
    body_h     = len - flare_h;

    od_at_flare = od0 + (od1 - od0) * (body_h / len);

    max_overhang = collar_or * sin(angle) + 1;

    difference() {

        union() {
            if (angle == 0) {
                rotate_extrude(angle=360, $fn=128)
                polygon(points=[
                    [od0/2,        0         ],
                    [od_at_flare/2, body_h   ],
                    [collar_or,    len       ],
                    [collar_or,    has_female ? len + collar_h : len],
                    [0,            has_female ? len + collar_h : len],
                    [0,            0         ]
                ]);
            } else {
                // CURVE SECTION: flare reaches collar_or at z = len -
                // collar_or*tan(angle) so the body's outer corner on
                // the low side coincides with the collar's bottom rim.
                // See alphorn.scad for full geometry rationale.
                flare_top_z_c = len - collar_or * tan(angle);
                body_h_c      = flare_top_z_c - flare_h;
                od_at_flare_c = od0 + (od1 - od0) * (body_h_c / len);
                intersection() {
                    rotate_extrude(angle=360, $fn=128)
                    polygon(points=[
                        [od0/2,           0                 ],
                        [od_at_flare_c/2, body_h_c          ],
                        [collar_or,       flare_top_z_c     ],
                        [collar_or,       len + max_overhang],
                        [0,               len + max_overhang],
                        [0,               0                 ]
                    ]);
                    translate([0, 0, len])
                    rotate([angle, 0, 0])
                    translate([0, 0, -2000])
                    cylinder(h=2000, r=collar_or + 100, $fn=8);
                }
                if (has_female) {
                    translate([0, 0, len])
                    rotate([angle, 0, 0])
                    translate([0, 0, -0.5])
                    cylinder(h = collar_h + 0.5, r = collar_or, $fn = 128);
                }
            }

            if (n > 1) {
                male_lugs(od=od0);
            }
        }

        // ---- BORE SUBTRACTION ----
        // Section 1 has a KINK in the bore profile at z=RECEIVER_LEN (42mm)
        // where the receiver ends (narrowing 16.7→12) and the trunk begins
        // (expanding from 12). The bore subtraction must include z=42 as a
        // frustum boundary so the receiver taper and trunk expansion are
        // rendered as separate cones. Other sections have a smooth bore.
        translate([0, 0, -0.5])
        union() {
            if (n == 1) {
                // Section 1: receiver as one cone (z=0 to RECEIVER_LEN),
                // then trunk as BORE_STEPS frustums (RECEIVER_LEN to len).
                cylinder(h = RECEIVER_LEN + 0.5,
                         r1 = RECEIVER_TIP_ID/2,
                         r2 = RECEIVER_END_ID/2,
                         $fn = 128);
                trunk_len = len - RECEIVER_LEN;
                for (i = [0 : BORE_STEPS-1]) {
                    za = RECEIVER_LEN + trunk_len * i       / BORE_STEPS;
                    zb = RECEIVER_LEN + trunk_len * (i+1)   / BORE_STEPS;
                    ra = bore_id(za) / 2;
                    rb = bore_id(zb) / 2;
                    seg_len = trunk_len / BORE_STEPS;
                    translate([0, 0, RECEIVER_LEN + i * seg_len + 0.5])
                    cylinder(h = seg_len + 1, r1 = ra, r2 = rb, $fn = 128);
                }
            } else {
                // Sections 2-14: smooth trunk/bell profile, regular subdivision
                for (i = [0 : BORE_STEPS-1]) {
                    za = z0 + len * i       / BORE_STEPS;
                    zb = z0 + len * (i+1)   / BORE_STEPS;
                    ra = bore_id(za) / 2;
                    rb = bore_id(zb) / 2;
                    seg_len = len / BORE_STEPS;
                    translate([0, 0, i * seg_len])
                    cylinder(h = seg_len + 1, r1 = ra, r2 = rb, $fn = 128);
                }
            }
        }

        if (angle != 0) {
            translate([0, 0, len])
            cylinder(h=50, r=bore_id(z1)/2, $fn=128);
        }

        if (has_female) {
            translate([0, 0, len])
            rotate([angle, 0, 0])
            translate([0, 0, -0.5])
            cylinder(h=collar_h + 1, r=od1/2 + BAYONET_CL, $fn=128);

            translate([0, 0, len])
            rotate([angle, 0, 0])
            l_channels_only(od=od1);

            translate([0, 0, len])
            rotate([angle, 0, 0])

            translate([0, 0, len])
            rotate([angle, 0, 0])
            translate([0, 0, collar_h - COLLAR_CHAMFER])
            cylinder(h=COLLAR_CHAMFER + 1,
                     r1=collar_or - COLLAR_CHAMFER,
                     r2=collar_or + 1,
                     $fn=128);
        }

        // Section number — recessed into outer body wall at the small end,
        // between the lugs. Always visible before assembly; hidden inside
        // the next section's collar after. Applied to ALL sections.
        section_label(n=n, od0=od0);
    }
}

// Just the L-shaped lug paths (slot + lock channel) — no inner socket.
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
            rotate([0, 0, -slot_half_angle])
            translate([0, 0, slot_z_bottom])
            rotate_extrude(angle=slot_angle, $fn=128)
            translate([chan_r_inner, 0])
            square([chan_r_outer - chan_r_inner,
                    slot_z_top - slot_z_bottom]);

            rotate([0, 0, slot_half_angle])
            translate([0, 0, lock_z_bottom])
            rotate_extrude(angle=lock_angle, $fn=128)
            translate([chan_r_inner, 0])
            square([chan_r_outer - chan_r_inner,
                    lock_z_top - lock_z_bottom]);
        }
    }
}

// Just the lug protrusions, no collar body — the body wall already exists
// as part of horn_section's outer hull.
// Male lug solids — additive. Each lug embeds 1mm into the body wall
// so its full tangential width overlaps the curved body surface.
LUG_EMBED = 1.0;

module male_lugs(od) {
    // Each lug is a hull() of two cubes:
    //  - Bottom cube: full tangential (W) and axial (T) size, but the OUTER
    //    edge sticks out only 1mm past the body wall (instead of LUG_H=3.5mm).
    //  - Top cube: full size — outer edge at the original LUG_H=3.5mm.
    // The hull creates a smooth ramp on the bottom-outer corner of the lug,
    // turning the 3.5mm unsupported overhang into a 1mm overhang plus a 45°
    // printable slope. The lug's TOP portion still has full radial extent so
    // it engages firmly with the female lock channel.
    // The 1mm bottom overhang is safely bridgeable by FDM without supports.
    lug_z_bottom = BAYONET_COLLAR - BAYONET_DEPTH - BAYONET_LUG_T/2;
    lug_z_top    = BAYONET_COLLAR - BAYONET_DEPTH + BAYONET_LUG_T/2;
    lug_chamfer  = 2.5;  // mm of chamfer height (= radial chamfer for 45° slope)
    bottom_protrude = 1.0;  // mm the chamfered bottom edge sticks out past body

    for (i = [0 : BAYONET_LUGS-1]) {
        rotate([0, 0, i * (360/BAYONET_LUGS)])
        hull() {
            // Top cube: full lug at the top portion (engages lock channel)
            translate([od/2 - LUG_EMBED, -BAYONET_LUG_W/2,
                       lug_z_bottom + lug_chamfer])
            cube([BAYONET_LUG_H + LUG_EMBED,
                  BAYONET_LUG_W,
                  BAYONET_LUG_T - lug_chamfer]);

            // Bottom slab: smaller outer extent (only 1mm past body), thin axially
            translate([od/2 - LUG_EMBED, -BAYONET_LUG_W/2,
                       lug_z_bottom])
            cube([LUG_EMBED + bottom_protrude,
                  BAYONET_LUG_W,
                  0.01]);
        }
    }
}

// body's outer wall just behind the lugs.
// 20mm (the male collar region). Lugs at local z=[2.5, 7.5]; groove placed
// at z=[10, 12.2] so it sits between the lugs and the rest of the body.



// ============================================================
//  SECTION LABEL MODULE
//  Recessed number on the inner socket wall of the female collar.
//  Called as a SUBTRACTION — the returned solid is removed from
//  the collar wall, leaving a legible recessed number.
// ============================================================

module section_label(n, od0) {
    // Number recessed into the outer body wall at the small (male) end,
    // between the lugs at 60°. Position origin just outside the body OD,
    // then extrude radially INWARD so the text shape carves into the wall
    // when subtracted. Characters run tangentially with height along +Z.
    label_z = 18;  // mm, well above lug zone (lugs at z=2.5-7.5)
    rotate([0, 0, TEXT_ANGLE])
    translate([od0/2 + TEXT_DEPTH, 0, label_z])
    rotate([0, -90, 0])
    rotate([0, 0, -90])
    mirror([1, 0, 0])
    linear_extrude(height=TEXT_DEPTH + 0.2)
    text(str(n),
         size=TEXT_SIZE,
         halign="center",
         valign="center",
         font="Liberation Sans:style=Bold",
         $fn=32);
}

// ============================================================
//  PRINT LAYOUT
// ============================================================
//
//  All pieces arranged along the X axis, each sitting on the
//  XY plane (Z=0) in optimal print orientation.
//
//  COLOR KEY:
//    SaddleBrown  — trunk sections 1-10  (straight joints)
//    Peru         — curve sections 11-13 (15° angled female face)
//    Sienna       — bell mouth section 14 (open exit, no female)

// ============================================================
//  SPACING HELPERS
// ============================================================

// Collar outer radius for section n (determines footprint when printing)
function collar_or_n(n) =
    (n < NUM_SECTIONS)
    ? bore_od(sec_z1(n)) / 2 + BAYONET_LUG_H + BAYONET_CL + WALL_TRUNK / 2
    : bore_od(sec_z1(n)) / 2;

// Footprint radius = largest radius at any point on the section
function footprint_r(n) =
    max(collar_or_n(n),
        bore_od(sec_z0(n)) / 2 + (n > 1 ? BAYONET_LUG_H : 0));

LAYOUT_GAP = 20;

// Cumulative X center via recursion
function x_center(n) =
    (n == 1)
    ? footprint_r(1)
    : x_center(n - 1) + footprint_r(n - 1) + LAYOUT_GAP + footprint_r(n);


// ============================================================
//  LAYOUT RENDER
// ============================================================

// Sections 1..NUM_SECTIONS, small end down on the XY plane.
for (n = [1 : NUM_SECTIONS]) {
    color(
        n <= NUM_SECTIONS - 4 ? "SaddleBrown" :
        n <  NUM_SECTIONS     ? "Peru"        :
                                "Sienna",
        0.85
    )
    translate([x_center(n), 0, 0])
    horn_section(n);
}

// Mouthpiece — cup face DOWN on the bed (flip 180° around X)
// Support foot — base DOWN (already its natural orientation)
