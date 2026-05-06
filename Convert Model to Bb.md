# Converting the F Alphorn to Bb

This document describes the parameter changes needed to generate a Bb alphorn from this design, keeping the leadpipe and mouthpiece receiver unchanged so the same mouthpiece works on either instrument.

## Overview

The Bb alphorn is approximately 25% shorter than the F alphorn because Bb2 (116.54 Hz) is a perfect fourth above F2 (87.31 Hz). For an open conical/expanding pipe, the playing pitch is inversely proportional to the acoustic length, so a higher pitch requires a shorter horn.

The leadpipe and mouthpiece receiver (z=0 to z=42mm, bore narrows from 16.7mm to 12mm) stay identical. Only the trunk and bell are rescaled.

## Length scaling

| | F horn | Bb horn |
|---|---|---|
| Target 2nd harmonic | F2 = 87.31 Hz | Bb2 = 116.54 Hz |
| Length ratio (Bb/F) | — | 0.754 |
| Total physical length | 3880mm (388cm) | 2935mm (294cm) |
| Receiver (unchanged) | 0-42mm, 16.7→12 | 0-42mm, 16.7→12 |
| Trunk | 42-3140mm, 12→92 | 42-2378mm, 12→69.4 |
| Bell | 3140-3880mm, 92→204 | 2378-2935mm, 69.4→154 |

The acoustic length ratio scales the trunk and bell uniformly. The receiver doesn't scale because its purpose is mouthpiece fitment, not pitch — its acoustic contribution is small relative to the trunk.

## Parameter changes in `alphorn.scad`

Replace the existing constants with these values:

```scad
TOTAL_LENGTH      = 2935;       // mm (was 3880)
TRUNK_LENGTH      = 2378;       // mm (was 3140) — where bell starts
NUM_SECTIONS      = 13;         // (was 19) — fewer sections needed

// Receiver — UNCHANGED
RECEIVER_LEN      = 42;         // mm
RECEIVER_TIP_ID   = 16.7;       // mm
RECEIVER_END_ID   = 12.0;       // mm

// Trunk power-law constants — refit so bore=12mm at z=42 and 69.36mm at z=2378
BORE_A            = 0.00028540; // (was 0.00026179)
BORE_N            = 1.4849;     // (unchanged)
BORE_C            = 5.9997;     // (unchanged — equals 6 by construction)

// Bell quadratic constants — refit, C¹-continuous with new trunk slope at z=2378
BELL_A            = 0.00020673; // (was 0.00015273)
BELL_B            = 0.03644530; // (was 0.03833307)
BELL_C            = 69.3586;    // (was 92.0) — bore at start of bell
```

Other constants (wall thickness, bayonet dimensions, clearances) stay the same. The wall thickness function `wall_at(z) = WALL_TRUNK + (WALL_BELL - WALL_TRUNK) * (z / TOTAL_LENGTH)` interpolates by fraction of total length, so it automatically adjusts for the shorter horn.

## Sections

The Bb horn fits comfortably in 13 sections instead of 19. Each section is 225.8mm long, with the worst-case curve section reaching 238.6mm in print height — well within the X1C's 256mm build envelope.

| | F horn | Bb horn |
|---|---|---|
| Sections | 19 | 13 |
| Section length | 204.2mm | 225.8mm |
| Worst-case section height | 247.7mm | 238.6mm |
| Curve placement | Last 3 joints (15° each) | Last 3 joints (15° each) |
| Total bend | 45° | 45° |

The curve position (last 3 joints) and per-joint angle (15°) stay the same since these define the visual character of the alphorn rather than the pitch.

## Acoustic verification

| | F horn | Bb horn |
|---|---|---|
| Acoustic length (with bell end correction) | 3941mm | 2982mm |
| Predicted 2nd harmonic (at 25°C) | 87.87 Hz | 116.15 Hz |
| Target | F2 = 87.31 Hz | Bb2 = 116.54 Hz |
| Cents from equal-tempered | +11 | −6 |

Both horns are within typical "lip into tune" range for a brass instrument. The player adjusts pitch by lipping and by Talbot's "trim to tune" technique on the mouthpiece end of section 1.

## Mouthpiece compatibility

Because the receiver geometry is unchanged, **the same mouthpiece works on both horns**. A standard alphorn mouthpiece with a 12mm-OD shank tip seats by taper friction at ~14mm depth into the receiver, regardless of which horn it's on. The Talbot 20mm 3D-printed mouthpiece STL (scaled to 10% in the slicer) works on both.

## Joint hardware

Bayonet dimensions (`BAYONET_LUG_H`, `BAYONET_LUG_W`, `BAYONET_LUG_T`, `BAYONET_COLLAR`, `BAYONET_CL`) stay the same. The joint is sized for mechanical strength and printability, not pitch. PTFE plumbers' tape (if needed at all) works the same way on either horn.

## Implementation steps

1. Edit `alphorn.scad` with the parameter changes above
2. Re-render the assembly preview to verify the curve and overall proportions look right
3. Run the acoustic verification (Phase 9 prompt 23 in `RECREATE_WITH_CLAUDE.md`) — predicted 2nd harmonic should be ~116 Hz
4. Regenerate `alphorn_print_layout.scad` from scratch — the layout was generated for 19 sections and the section count, length, and OD profile all change for Bb
5. Print a fresh joint test piece. The joint geometry is unchanged so the existing test print should still validate, but the dimensions sample at mid-section (section 7/8 boundary in the 13-section design)
6. Print all 13 sections per the new batching plan

## Bore profile reference points (Bb horn)

For verification or comparison:

| z (mm) | Region | Bore ID (mm) |
|---|---|---|
| 0 | Receiver tip | 16.70 |
| 42 | Receiver / trunk junction | 12.00 |
| 500 | Trunk | 17.49 |
| 1000 | Trunk | 27.28 |
| 1500 | Trunk | 39.18 |
| 2000 | Trunk | 53.07 |
| 2378 | Trunk / bell junction | 69.36 |
| 2700 | Bell | 102.51 |
| 2935 | Bell mouth | 153.80 |

## Other pitches

The same approach works for any alphorn pitch. The length scaling factor is `f_F / f_target`, where `f_target` is the desired 2nd harmonic. Common alphorn pitches:

| Pitch | 2nd harmonic | Scale factor (vs F) | Approx. total length |
|---|---|---|---|
| Eb (concert pitch) | 77.78 Hz | 1.123 | 4357mm |
| E | 82.41 Hz | 1.060 | 4112mm |
| F | 87.31 Hz | 1.000 | 3880mm |
| F# | 92.50 Hz | 0.944 | 3661mm |
| G | 98.00 Hz | 0.891 | 3457mm |
| Ab | 103.83 Hz | 0.841 | 3262mm |
| A | 110.00 Hz | 0.794 | 3079mm |
| Bb | 116.54 Hz | 0.749 | 2935mm |
| B | 123.47 Hz | 0.707 | 2742mm |
| C | 130.81 Hz | 0.667 | 2589mm |

For each pitch, recompute `BORE_A`, `BORE_C`, `BELL_A`, and `BELL_B` to fit:
- Trunk: 12mm at z=42, scaled-92 at the new TRUNK_LENGTH
- Bell: scaled-92 at TRUNK_LENGTH, scaled-204 at TOTAL_LENGTH
- Bell slope at TRUNK_LENGTH must match the trunk slope (C¹ continuity)

The receiver and joint dimensions stay constant across all pitches — only TOTAL_LENGTH, TRUNK_LENGTH, NUM_SECTIONS, and the four bore/bell constants change.