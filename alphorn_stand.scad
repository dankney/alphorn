// ============================================================
//  ALPHORN BELL STAND — Alpine Peaks edition
//
//  Cradles section 19 of the 3D-printed F alphorn during play.
//
//  DESIGN: two stylized mountain-silhouette END PIECES connected
//  by two press-fit RAILS. Each end piece has a half-cup saddle
//  carved out of its top, sized to match the bell at that axial
//  position. Peaks on each side of the saddle act as lip stops.
//  Faceted angled feet raise the entire stand off the ground.
//
//  HOW IT PREVENTS SLIDING:
//  The two end pieces are sized for different parts of the
//  bell cone — back saddle R=89.65mm, front saddle R=100.9mm.
//  This matches the bell's natural taper, creating a self-
//  wedging fit:
//    - Forward sliding: bell mouth (R=110) is wider than the
//      front saddle opening (R=100.9). Cannot pass through.
//    - Backward sliding: gravity pulls the cone deeper into
//      the matched-taper saddle.
//    - Lifting/rolling: peaks on either side of each saddle
//      rise 45mm above the bell axis, blocking liftoff.
//
//  ASSEMBLY (no glue):
//  Each rail has a tenon at each end that press-fits into a
//  matching mortise in each end piece. Slight interference fit
//  (0.20mm clearance per side) makes the joints snug. Push
//  rails into end pieces by hand; if too tight, sand the tenon
//  faces; if too loose, wrap a turn of PTFE tape.
//
//  PIECES (4 total, all flat-printable):
//    - 2 end pieces (different — front has larger saddle)
//    - 2 rails (identical)
//
//  RENDER FLAGS BELOW: set RENDER to view individual pieces.
// ============================================================

// ------------------------------------------------------------
//  RENDER SELECTOR
// ------------------------------------------------------------
RENDER = "assembly";   // "assembly" | "front_end" | "back_end" | "rail"

// ------------------------------------------------------------
//  ALPHORN BELL DIMENSIONS (from alphorn.scad bore profile)
// ------------------------------------------------------------
//  Section 19 spans z=3675.8 to z=3880mm.
//  We cradle from z=3700 (back end) to z=3800 (front end).
//
//    z=3700: bell OD = 177.3mm   (small end of cradle)
//    z=3800: bell OD = 199.8mm   (large end of cradle)
//    Cone half-angle: 6.4°

CRADLE_LENGTH       = 100;    // mm  axial spacing between end pieces
CRADLE_OD_BACK      = 177.3;  // mm  bell OD at back of cradle
CRADLE_OD_FRONT     = 199.8;  // mm  bell OD at front of cradle
CRADLE_CLEARANCE    = 1.0;    // mm  radial slop for easy seating

NOTCH_R_BACK        = CRADLE_OD_BACK  / 2 + CRADLE_CLEARANCE;  // 89.65
NOTCH_R_FRONT       = CRADLE_OD_FRONT / 2 + CRADLE_CLEARANCE;  // 100.9

// ------------------------------------------------------------
//  HEIGHTS
// ------------------------------------------------------------
//  Bell axis sits 130mm above the floor (with feet, ~100mm
//  above feet bottom). The saddle top is at the bell axis so
//  the bell fits exactly into the half-cup carved by the
//  notch circle. Peaks rise 45mm above bell axis on each side
//  of the saddle to lock the bell from rolling out.

FOOT_HEIGHT         = 30;    // mm  height of feet (clearance from floor)
BELL_AXIS_Z         = 130;   // mm  bell axis height
SADDLE_TOP_Z        = BELL_AXIS_Z;
PEAK_Z              = BELL_AXIS_Z + 45;

// ------------------------------------------------------------
//  END PIECE WIDTHS
//  Defined as half-widths from the symmetric centerline.
// ------------------------------------------------------------
//  All half-widths must accommodate the larger (front) bell.
//  At Y = NOTCH_R_FRONT the bell touches the saddle wall, so
//  the polygon must extend at least to that Y.
PEAK_INNER_HALF     = NOTCH_R_FRONT + 5;       // 105.9 — inner edge of peak
PEAK_OUTER_HALF     = PEAK_INNER_HALF + 12;    // 117.9 — outer base of peak
SHOULDER_HALF       = PEAK_OUTER_HALF + 4;     // 121.9 — body shoulder
BASE_HALF           = SHOULDER_HALF + 5;       // 126.9 — base flare
                                                // Total width 253.8mm — within X1C 256

// Foot widths
FOOT_OUTER_HALF     = BASE_HALF;
FOOT_INNER_HALF     = BASE_HALF - 35;          // foot is 35mm wide

// ------------------------------------------------------------
//  PIECE THICKNESS (along horn axis)
// ------------------------------------------------------------
PIECE_THICK         = 14;    // mm

// ------------------------------------------------------------
//  RAIL DIMENSIONS
// ------------------------------------------------------------
//  Rails connect the two end pieces, running parallel to the
//  horn axis. They sit low on the end pieces, well below the
//  bell. Rails are external — they pass on the OUTSIDE of the
//  end pieces, with tenons going through them.

RAIL_LENGTH         = CRADLE_LENGTH;       // 100mm between end pieces
RAIL_TENON_LENGTH   = 12;                  // mm tenon depth into end piece
RAIL_WIDTH          = 18;                  // mm Y extent (cross-axis)
RAIL_HEIGHT         = 28;                  // mm Z extent

// Vertical position of the rails (centerline) - low on the end pieces
RAIL_Z_CENTER       = FOOT_HEIGHT + RAIL_HEIGHT/2 + 8;

// Lateral position - rails sit at Y = ±RAIL_Y, just outboard of where the
// bell hangs. Bell's lowest point at the back is at Y=0, Z=BELL_AXIS_Z-89.65=40.4
// so rails at Y=±95 with center Z=72 are well clear.
RAIL_Y_OFFSET       = 95;

// Tenon dimensions and clearance for press-fit
TENON_WIDTH         = 14;    // mm  Y extent of tenon
TENON_HEIGHT        = 24;    // mm  Z extent of tenon
TENON_CLEARANCE     = 0.20;  // mm  per-side gap (press-fit)

// ------------------------------------------------------------
//  AESTHETIC: alpine ridge cutouts
// ------------------------------------------------------------
//  Triangular windows in the body of each end piece, evoking
//  the layered ridges of an alpine mountain range.

RIDGE_COUNT         = 3;
RIDGE_WIDTH         = 50;
RIDGE_HEIGHT        = 32;

$fn = 96;

// ============================================================
//  END PIECE
//  notch_r:  saddle radius (different for front vs back)
// ============================================================

module end_piece(notch_r) {
    // Mountain silhouette polygon, traced clockwise from
    // the bottom-left foot tip.
    silhouette = [
        // Left foot — angled inner+outer edges
        [-FOOT_INNER_HALF,    0],                           // foot inner-bottom
        [-FOOT_OUTER_HALF,    FOOT_HEIGHT * 0.4],           // foot outer-lower
        [-FOOT_OUTER_HALF,    FOOT_HEIGHT],                 // foot outer-top
        // Body slopes UP and SLIGHTLY IN to shoulder
        [-SHOULDER_HALF,      SADDLE_TOP_Z - 25],           // shoulder
        // Outer base of left peak (slight outward bulge)
        [-PEAK_OUTER_HALF,    SADDLE_TOP_Z - 8],
        // Tip of left peak (asymmetric, leans outward)
        [-PEAK_OUTER_HALF + 4, PEAK_Z],
        // Inner base of left peak — drops down to saddle level
        [-PEAK_INNER_HALF,    SADDLE_TOP_Z],
        // Saddle region — flat across, will be notched out
        [-notch_r,            SADDLE_TOP_Z],
        [ notch_r,            SADDLE_TOP_Z],
        // Right peak (mirror)
        [ PEAK_INNER_HALF,    SADDLE_TOP_Z],
        [ PEAK_OUTER_HALF - 4, PEAK_Z],
        [ PEAK_OUTER_HALF,    SADDLE_TOP_Z - 8],
        // Body and right foot (mirror)
        [ SHOULDER_HALF,      SADDLE_TOP_Z - 25],
        [ FOOT_OUTER_HALF,    FOOT_HEIGHT],
        [ FOOT_OUTER_HALF,    FOOT_HEIGHT * 0.4],
        [ FOOT_INNER_HALF,    0],
        // Bottom edge — arch up between the two feet
        [ FOOT_INNER_HALF * 0.4,  FOOT_HEIGHT * 0.55],
        [ 0,                      FOOT_HEIGHT * 0.6],
        [-FOOT_INNER_HALF * 0.4,  FOOT_HEIGHT * 0.55]
    ];

    // Extrude the silhouette along the horn axis (X), then carve
    // out the saddle (a half-cylinder cut from above) and the
    // ridge windows (triangular through-holes).
    // Then drill the rail mortises.
    difference() {
        // Extrude along X. The silhouette is in the YZ plane;
        // rotate then linear-extrude to make a slab parallel to YZ
        // and thick along X.
        rotate([90, 0, 90])
        linear_extrude(height=PIECE_THICK, center=false)
        difference() {
            polygon(points=silhouette);

            // Saddle notch — circle centered at (0, BELL_AXIS_Z) carves
            // a half-cup from the polygon top. With saddle top at
            // SADDLE_TOP_Z = BELL_AXIS_Z, the circle is exactly tangent
            // to the polygon top; the LOWER half of the circle carves
            // into the polygon, leaving a half-circular cup.
            translate([0, BELL_AXIS_Z])
            circle(r=notch_r);

            // Ridge cutouts — triangles in the lower body
            for (i = [0 : RIDGE_COUNT - 1]) {
                x_offset = (i - (RIDGE_COUNT-1)/2) * (RIDGE_WIDTH + 18);
                translate([x_offset, FOOT_HEIGHT + 12])
                polygon(points=[
                    [-RIDGE_WIDTH/2, 0],
                    [ RIDGE_WIDTH/2, 0],
                    [ 0,             RIDGE_HEIGHT]
                ]);
            }
        }

        // Rail mortises — rectangular through-holes for the tenons.
        // Mortises pierce the entire piece thickness (X direction).
        for (y = [-RAIL_Y_OFFSET, RAIL_Y_OFFSET]) {
            translate([-1, y, RAIL_Z_CENTER])
            translate([0,
                       -(TENON_WIDTH/2 + TENON_CLEARANCE),
                       -(TENON_HEIGHT/2 + TENON_CLEARANCE)])
            cube([PIECE_THICK + 2,
                  TENON_WIDTH + 2*TENON_CLEARANCE,
                  TENON_HEIGHT + 2*TENON_CLEARANCE]);
        }
    }
}

// ============================================================
//  RAIL
//  A bar with a tenon at each end. Tenons pass THROUGH the end
//  pieces; the visible (between-end-pieces) portion of the rail
//  is RAIL_LENGTH long.
// ============================================================

module rail() {
    overall_length = RAIL_LENGTH + 2*RAIL_TENON_LENGTH;
    union() {
        // Main bar (visible between end pieces)
        translate([RAIL_TENON_LENGTH,
                   -RAIL_WIDTH/2,
                   -RAIL_HEIGHT/2])
        cube([RAIL_LENGTH, RAIL_WIDTH, RAIL_HEIGHT]);

        // Back tenon (x = 0 to RAIL_TENON_LENGTH)
        translate([0,
                   -TENON_WIDTH/2,
                   -TENON_HEIGHT/2])
        cube([RAIL_TENON_LENGTH, TENON_WIDTH, TENON_HEIGHT]);

        // Front tenon (x = RAIL_TENON_LENGTH+RAIL_LENGTH to overall_length)
        translate([RAIL_TENON_LENGTH + RAIL_LENGTH,
                   -TENON_WIDTH/2,
                   -TENON_HEIGHT/2])
        cube([RAIL_TENON_LENGTH, TENON_WIDTH, TENON_HEIGHT]);
    }
}

// ============================================================
//  ASSEMBLY VIEW
// ============================================================

module assembly() {
    // Back end piece at x=0 (smaller saddle)
    color("LightSteelBlue")
    end_piece(notch_r=NOTCH_R_BACK);

    // Front end piece at x=CRADLE_LENGTH+PIECE_THICK (larger saddle)
    color("LightSteelBlue")
    translate([CRADLE_LENGTH + PIECE_THICK, 0, 0])
    end_piece(notch_r=NOTCH_R_FRONT);

    // Two rails connecting them
    color("Tan")
    for (y = [-RAIL_Y_OFFSET, RAIL_Y_OFFSET]) {
        translate([-RAIL_TENON_LENGTH + PIECE_THICK,
                   y,
                   RAIL_Z_CENTER])
        rail();
    }
}

// ============================================================
//  RENDER DISPATCH
// ============================================================

if (RENDER == "assembly") {
    assembly();
} else if (RENDER == "front_end") {
    end_piece(notch_r=NOTCH_R_FRONT);
} else if (RENDER == "back_end") {
    end_piece(notch_r=NOTCH_R_BACK);
} else if (RENDER == "rail") {
    rail();
}
