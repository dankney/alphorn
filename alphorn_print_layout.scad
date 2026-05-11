// ============================================================
//  ALPHORN PRINT LAYOUT  (self-contained)
//  Based on Jason Talbot dimensions (argobuilder.com)
//  Designed for Bambu Lab X1C, PLA Wood Filament
//  All dimensions in mm unless noted
// ============================================================
//
//  All 19 sections and the support foot are
//  arranged on the XY plane in their optimal print orientation.
//  This file is SELF-CONTAINED — no reference to alphorn.scad.
//
//  PRINT ORIENTATION:
//    Sections — vertical, small end (mouthpiece side) DOWN
//    Foot     — vertical, base DOWN
//
//  Section heights (max, including angled collar lift on curve sections):
//    Sections  1-15:  224mm  (body 204mm + 20mm collar)
//    Section  16:    240mm  (body + tilted collar)
//    Section  17:    243mm  (body + tilted collar, larger OD)
//    Section  18:    248mm  (body + tilted collar, larger OD)
//    Section  19:    204mm  (body only — bell mouth, no collar)
//  All under 256mm X1C build height ✓
//
//  BATCHING PLAN (which sections fit together on a 256mm bed):
//    Plate  1: sections  1 +  2  (~110mm wide)
//    Plate  2: sections  3 +  4  (~120mm wide)
//    Plate  3: sections  5 +  6  (~135mm wide)
//    Plate  4: sections  7 +  8  (~155mm wide)
//    Plate  5: sections  9 + 10  (~180mm wide)
//    Plate  6: sections 11 + 12  (~205mm wide)
//    Plate  7: sections 13 + 14  (~235mm wide)
//    Plate  8: section  15 only
//    Plate  9: section  16 only
//    Plate 10: section  17 only
//    Plate 11: section  18 only
//    Plate 12: section  19 only
//
//  SUPPORT NOTE:
//    Sections 1-15  — no supports needed
//    Sections 16-18 — angled female face at top; check slicer
//                     for overhang, may need partial supports
//    Section 19     — large bell mouth, no supports
//    Mouthpiece     — no supports (cup face down)
// ============================================================

// ============================================================
//  MASTER ACOUSTIC PARAMETERS
//  All from Talbot drawings (argobuilder.com)
// ============================================================

TOTAL_LENGTH      = 3880;    // mm  (trunk 3140 + bell 740)
TRUNK_LENGTH      = 3140;    // mm  where trunk bore law ends
BELL_LENGTH       = 740;     // mm  bell region (z=3140 to 3880)

// Bore confirmed reference points (Talbot drawings):
//   z=    0mm  ID= 14.00mm   (mouthpiece end)
//   z= 2200mm  ID= 60.00mm   (Talbot sheet 2, at 220cm)
//   z= 3140mm  ID= 92.00mm   (Talbot sheet 2, at 294cm)
//   z= 3880mm  ID=204.00mm   (Talbot sheet 3, bell mouth)

// Wall thickness — increased from 7/8 to 9/10 mm after structural failure
// testing showed the original walls were insufficient for the assembly
// bending loads at the collar-exit stress concentration.
WALL_TRUNK        = 9.0;     // mm  (was 7.0 — increased for structural strength)
WALL_BELL         = 10.0;    // mm  (was 8.0 — increased for structural strength)

// ============================================================
//  SECTION PARAMETERS
// ============================================================

NUM_SECTIONS      = 19;      // 19 x 204.2mm — required so the curve
                             //   sections (with angled female face) fit
                             //   within the X1C 256mm build height.
                             //   Section 18 was 258.7mm tall at 18-section
                             //   layout; reducing per-section length brings
                             //   the worst case down to ~248mm.
SECTION_LEN       = TOTAL_LENGTH / NUM_SECTIONS;  // 204.2mm

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

// Collar-exit structural reinforcement (see alphorn.scad for full rationale)
COLLAR_REINF_T    = 5.0;    // mm  extra radius at z=BAYONET_COLLAR
COLLAR_REINF_H    = 30.0;   // mm  taper length back to natural OD

// ============================================================
//  PER-JOINT BOLT REINFORCEMENT  (iteration 6 - body anchor below joint)
//  Three M4 x 30mm cap screws per joint, oriented PARALLEL to the
//  pipe axis. CRITICAL CHANGE vs iter-5: the heat-set insert now
//  anchors in the FEMALE SECTION'S BODY (below the joint plane),
//  NOT in the collar.
//
//  In iter-5 the insert was in the collar boss. The collar is a
//  cantilevered tube extending up from the female body; its only
//  structural connection to the body is the collar-body junction
//  at z=len. If that junction cracks (which is exactly the failure
//  mode we are reinforcing against), the insert detaches from the
//  body. The screw would only effectively attach at one side of
//  the joint - it would not reinforce the failure.
//
//  Iter-6 fix: extend the boss DOWN by BOSS_DROP=5mm below z=len,
//  into the female section's body proper. The insert pocket spans
//  z=len-5 to z=len+1.4, so 5mm of the insert is anchored in the
//  body wall (deep in the flared body material) and only 1.4mm is
//  in the collar. The load path now goes: screw threads -> insert
//  -> body wall (DIRECT), bypassing the collar-body junction
//  entirely on the lower side.
//
//  Geometry (axially, in section-relative z, with len = SECTION_LEN):
//    z=len-5..len  : body extension boss (5mm of body anchor)
//    z=len..len+1.4: collar portion of boss above body anchor
//    z=len-5..len+1.4: heat-set insert pocket (6.4mm tall, 5.3 OD)
//    z=len+1.4..len+20: M4 clearance hole (4.5 dia, 18.6mm long)
//    z=len+20..len+25: upper section's tab (M4 clearance, 4.5 dia)
//    z>len+25      : screw head sits on top of tab
//    Total screw under-head length: 5 + 18.6 + 6.4 = 30mm
//
//  Geometry (radially):
//   Collar boss portion (z = len..len+collar_h):
//     inner r = collar_or - BOSS_EMBED (2.5mm embed into collar wall)
//     outer r = collar_or + COLLAR_BOSS_RAD_H
//   Body extension portion (z = len-BOSS_DROP..len):
//     inner r = bore_od(z0+len)/2 - BOSS_EMBED
//     outer r = collar_or + COLLAR_BOSS_RAD_H  (same outer as collar boss)
//     In the flare zone (z = len-25..len), the section's actual outer
//     surface flares from bore_od(z0+body_h)/2 up to collar_or, so
//     the body extension's inner face is DEEPLY embedded in section
//     material (~8-9mm radial overlap for section 1, growing for
//     larger sections). The boss does NOT enter the bore: at all
//     joints inner-face-r exceeds bore_id(z0+len)/2 + ~6.5mm.
//   Tab (upper section, z = BAYONET_COLLAR..BAYONET_COLLAR+TAB_THICKNESS):
//     inner r = od0/2 + COLLAR_REINF_T - BOSS_EMBED  (embed into buttress)
//     outer r = prev_collar_or + COLLAR_BOSS_RAD_H + 0.5
//   Bolt clearance hole at r = collar_or + COLLAR_BOSS_RAD_H/2 (mid-boss).
//
//  Angular alignment:
//   Lower section's boss at lower's BOLT_PHASE_DEG = 75/195/315.
//   Upper section's tab at upper's BOLT_PHASE_DEG - BAYONET_LOCK_ANGLE
//   = 45/165/285 (in upper's frame, before lock).
//   After the +30 deg CCW bayonet lock twist, the upper's tab lands
//   at lower's 75/195/315 - directly above the lower's boss.
//
//  Loading at the joint:
//   Joint bending creates axial separation on the convex side. The
//   3 screws are in pure TENSION (parallel to pipe). Worst-bolt
//   tension under M = 234,000 N*mm at joint 1 with r = 28mm:
//     T = 2M/(3R) = 2*234000/(3*28) = 5571 N
//   M4 grade-10.9 tensile capacity ~ 12 kN -> SF = 2.15.
//   Load path on lower side (NEW): insert -> body wall (direct,
//   bypassing collar-body junction). Insert is bonded into body
//   PLA over its full 5mm body-side length plus 1.4mm collar-side.
//
//  Hardware per joint:
//   - M4 x 30mm grade-10.9 socket-head cap screw   x3
//   - M4 heat-set brass insert (5.3 OD x 6.4 long) x3
//   Totals for 19-section horn (18 joints): 54 bolts + 54 inserts
//
//  Assembly:
//   1. BEFORE assembly: heat-press an M4 insert into each of the 3
//      pockets on every section's collar boss (sections 1-18; the
//      bell section has no collar). The insert top sits at 1.4mm
//      above the collar base (mostly recessed into the body). Use
//      a soldering iron with M4 insert tip at ~200 C; the M4
//      clearance hole above the pocket acts as a depth stop
//      (the 4.5/5.3 step prevents the insert from going too far).
//   2. Insert section N+1's male end into section N's collar.
//   3. Twist 30 deg CCW to engage the bayonet lock. The 3 tabs on
//      N+1 land directly above the 3 collar bosses on N.
//   4. Drive an M4 x 30mm cap screw down through each tab clearance
//      hole; it threads into the insert below. ~2 N*m.
// ============================================================
BOLT_REINFORCE     = true;     // set false to disable all bolt features
BOLT_COUNT         = 3;        // 3 screws per joint (between bayonet lugs)
BOLT_PHASE_DEG     = 75;       // screw angle in female frame (symmetric)
BAYONET_LOCK_ANGLE = 30;       // mirrors lock_angle in l_channels_only
BOLT_CL_D          = 4.5;      // mm  M4 clearance hole
HEAT_INSERT_D      = 5.3;      // mm  M4 heat-set insert OD
HEAT_INSERT_L      = 6.4;      // mm  M4 heat-set insert length
COLLAR_BOSS_RAD_H  = 8.3;      // mm  boss radial extent outward from collar_or
COLLAR_BOSS_TANG_W = 10;       // mm  boss tangential width
TAB_THICKNESS      = 5;        // mm  tab axial thickness
TAB_TANG_W         = 10;       // mm  tab tangential width
BOSS_EMBED         = 2.5;      // mm  embed into existing wall (boss & tab)
BOSS_DROP          = 5;        // mm  body extension below z=len into body wall.
                               //     HEAT_INSERT_L - BOSS_DROP = 1.4mm of
                               //     insert sits above joint plane in collar;
                               //     BOSS_DROP = 5mm sits below in body.

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
//  TRUNK (z = 0 to 3140mm):  power law
//    r(z) = 0.000250 x (z+1)^1.4849 + 6.9997
//    Fitted exactly to three Talbot reference points.
//
//  BELL (z = 3140 to 3880mm):  quadratic in s = z - 3140
//    ID(s) = 0.00015474*s^2 + 0.036846*s + 92.0
//    C1-continuous with trunk at s=0 (matching slope).
//    Reaches ID=204mm exactly at s=740 (bell mouth).
//
//  WALL interpolates linearly: 7mm at z=0, 8mm at z=3880

// MOUTHPIECE RECEIVER (leadpipe) — first 42mm of the horn.
// Bore narrows linearly from 16.7mm at z=0 (the very tip where the
// mouthpiece sticks out) to 12mm at z=42 (the seat depth where the
// receiver opens into the main bore). This is the only section of
// the horn where the bore narrows — it provides the cup-like
// constriction needed to seat a mouthpiece by taper friction.
RECEIVER_LEN     = 42;       // mm  length of the mouthpiece receiver
RECEIVER_TIP_ID  = 16.7;     // mm  bore ID at the mouthpiece end (z=0)
RECEIVER_END_ID  = 12.0;     // mm  bore ID at the receiver/trunk junction

// TRUNK profile (z=42 to z=3140) — power law starting at 12mm and
// expanding to 92mm at the bell start. Constants fitted so bore=12 at
// z=42 and bore=92 at z=3140 with the same exponent as the original
// Talbot profile.
BORE_A = 0.00026179;
BORE_N = 1.4849;
BORE_C = 5.9997;

// BELL profile (z=3140 to z=3880) — quadratic, C1-continuous with the
// new trunk profile (slope matches trunk derivative at z=3140).
// Reaches 204mm at z=3880 (bell mouth).
BELL_A = 0.00015273;
BELL_B = 0.03833307;
BELL_C = 92.0;

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
//  BORE PROFILE REFERENCE TABLE  (19 sections × 204.2mm each)
//
//  n   z_start  z_end    ID_start  ID_end    OD_start  OD_end
//  1      0.0   204.2    14.00     15.39     28.00     29.54
//  2    204.2   408.4    15.39     17.86     29.54     32.13
//  3    408.4   612.6    17.86     21.04     32.13     35.45
//  4    612.6   816.8    21.04     24.79     35.45     39.36
//  5    816.8  1021.1    24.79     29.04     39.36     43.78
//  6   1021.1  1225.3    29.04     33.71     43.78     48.62
//  7   1225.3  1429.5    33.71     38.78     48.62     53.85
//  8   1429.5  1633.7    38.78     44.20     53.85     59.43
//  9   1633.7  1837.9    44.20     49.95     59.43     65.34
// 10   1837.9  2042.1    49.95     56.01     65.34     71.55
// 11   2042.1  2246.3    56.01     62.36     71.55     78.06
// 12   2246.3  2450.5    62.36     69.00     78.06     84.86
// 13   2450.5  2654.7    69.00     75.91     84.86     91.93
// 14   2654.7  2858.9    75.91     83.10     91.93     99.27
// 15   2858.9  3063.2    83.10     90.55     99.27    106.87
// 16   3063.2  3267.4    90.55    105.51    106.87    121.91  <- bell region
// 17   3267.4  3471.6   105.51    127.87    121.91    144.34
// 18   3471.6  3675.8   127.87    160.17    144.34    176.71
// 19   3675.8  3880.0   160.17    204.00    176.71    220.00
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

            // Collar-exit structural buttress (see alphorn.scad for rationale)
            if (n > 1) {
                reinf_z0 = BAYONET_COLLAR;
                reinf_z1 = BAYONET_COLLAR + COLLAR_REINF_H;
                translate([0, 0, reinf_z0])
                cylinder(h  = COLLAR_REINF_H,
                         r1 = bore_od(z0 + reinf_z0) / 2 + COLLAR_REINF_T,
                         r2 = bore_od(z0 + reinf_z1) / 2,
                         $fn = 128);
            }

        // ---- COLLAR-SIDE BOLT BOSS (additive) ----
        // Longitudinal boss on the OUTSIDE of the female collar
        // at 3 angles (75/195/315). The boss has TWO regions:
        //   1. Collar portion: z = len..len+collar_h, embedded
        //      BOSS_EMBED into the collar wall.
        //   2. Body extension: z = len-BOSS_DROP..len, embedded
        //      DEEPLY into the section's flared body material
        //      (inner face at bore_od(z0+len)/2 - BOSS_EMBED).
        //      This is the KEY iter-6 feature - it puts the
        //      insert pocket (and thus the screw's threaded
        //      anchor) into the body wall BELOW the joint plane,
        //      so the load path does not depend on the collar-body
        //      junction surviving.
        // Both regions share the same outer face at
        // r = collar_or + COLLAR_BOSS_RAD_H.
        if (BOLT_REINFORCE && has_female && angle == 0) {
            body_inner_r = bore_od(z0 + len)/2 - BOSS_EMBED;
            outer_r = collar_or + COLLAR_BOSS_RAD_H;
            for (bi = [0 : BOLT_COUNT-1]) {
                rotate([0, 0, BOLT_PHASE_DEG + bi * (360/BOLT_COUNT)]) {
                    // Collar portion
                    translate([collar_or - BOSS_EMBED,
                               -COLLAR_BOSS_TANG_W/2,
                               len])
                    cube([COLLAR_BOSS_RAD_H + BOSS_EMBED,
                          COLLAR_BOSS_TANG_W,
                          collar_h]);
                    // Body extension (the iter-6 anchor)
                    translate([body_inner_r,
                               -COLLAR_BOSS_TANG_W/2,
                               len - BOSS_DROP])
                    cube([outer_r - body_inner_r,
                          COLLAR_BOSS_TANG_W,
                          BOSS_DROP]);
                }
            }
        }

        // ---- MALE-SIDE TAB (additive) ----
        // Radial tab on the upper section's body, at z = BAYONET_COLLAR
        // (just above the male zone). Tab is at upper's
        // BOLT_PHASE_DEG - BAYONET_LOCK_ANGLE = 45/165/285; after the
        // +30 deg bayonet lock it lands at 75/195/315 in the lower
        // frame, directly above the lower's collar boss. Tab inner
        // face embeds BOSS_EMBED into the buttress (>=1.7mm overlap
        // across its full 5mm axial span). The tab has a vertical
        // clearance hole for the screw, drilled in the subtraction
        // block below.
        if (BOLT_REINFORCE && n > 1 && angle == 0) {
            prev_collar_or = od0/2 + BAYONET_LUG_H + BAYONET_CL + WALL_TRUNK/2;
            tab_inner_r = od0/2 + COLLAR_REINF_T - BOSS_EMBED;
            tab_outer_r = prev_collar_or + COLLAR_BOSS_RAD_H + 0.5;
            for (bi = [0 : BOLT_COUNT-1]) {
                rotate([0, 0, BOLT_PHASE_DEG - BAYONET_LOCK_ANGLE
                              + bi * (360/BOLT_COUNT)])
                translate([tab_inner_r,
                           -TAB_TANG_W/2,
                           BAYONET_COLLAR])
                cube([tab_outer_r - tab_inner_r,
                      TAB_TANG_W,
                      TAB_THICKNESS]);
            }
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
                // Sections 2-19: smooth trunk/bell profile, regular subdivision
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

        // ---- PER-JOINT BOLT HOLES (subtractive) ----
        // Two vertical (parallel-to-pipe) hole sets:
        //   1. In the FEMALE COLLAR BOSS: a stepped hole - 4.5mm
        //      clearance in the upper 8.6mm (from boss top down),
        //      then 5.3mm insert pocket in the lower 6.4mm. The
        //      4.5/5.3 step acts as a depth stop when heat-pressing
        //      the insert. 5mm of solid PLA remains below.
        //   2. In the MALE BODY TAB: a 4.5mm clearance hole vertically
        //      through the tab's 5mm axial thickness.
        // The bolt enters from above the tab, passes through the tab
        // clearance hole, drops through the boss clearance portion,
        // and threads into the insert at the bottom of the boss.

        // Female collar+body boss: vertical screw clearance (upper)
        // + heat-set insert pocket spanning body+collar (lower).
        // The insert pocket is positioned so that BOSS_DROP=5mm of
        // it sits in the body wall (z = len-5..len) and the
        // remaining HEAT_INSERT_L - BOSS_DROP = 1.4mm sits in the
        // collar above the joint plane.
        if (BOLT_REINFORCE && has_female && angle == 0) {
            bolt_r = collar_or + COLLAR_BOSS_RAD_H / 2;
            insert_top_z = HEAT_INSERT_L - BOSS_DROP;  //  1.4mm above z=len
            insert_bot_z = insert_top_z - HEAT_INSERT_L;  // -5.0mm (in body)
            for (bi = [0 : BOLT_COUNT-1]) {
                rotate([0, 0, BOLT_PHASE_DEG + bi * (360/BOLT_COUNT)]) {
                    // Upper clearance hole (4.5mm, from insert top to boss top)
                    translate([bolt_r, 0, len + insert_top_z])
                    cylinder(h = collar_h - insert_top_z + 0.5,
                             r = BOLT_CL_D/2, $fn = 32);
                    // Insert pocket (5.3mm, spans body+collar)
                    translate([bolt_r, 0, len + insert_bot_z - 0.5])
                    cylinder(h = HEAT_INSERT_L + 0.5,
                             r = HEAT_INSERT_D/2, $fn = 32);
                }
            }
        }

        // Male body tab: vertical screw clearance through the tab.
        if (BOLT_REINFORCE && n > 1 && angle == 0) {
            prev_collar_or = od0/2 + BAYONET_LUG_H + BAYONET_CL + WALL_TRUNK/2;
            bolt_r = prev_collar_or + COLLAR_BOSS_RAD_H / 2;
            for (bi = [0 : BOLT_COUNT-1]) {
                rotate([0, 0, BOLT_PHASE_DEG - BAYONET_LOCK_ANGLE
                              + bi * (360/BOLT_COUNT)])
                translate([bolt_r, 0, BAYONET_COLLAR - 0.5])
                cylinder(h = TAB_THICKNESS + 1,
                         r = BOLT_CL_D/2, $fn = 32);
            }
        }
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
//    SaddleBrown  — trunk sections 1-15  (straight joints)
//    Peru         — curve sections 16-18 (15° angled female face)
//    Sienna       — bell mouth section 19 (open exit, no female)

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
