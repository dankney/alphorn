# 3D-Printable F Alphorn

A fully parametric, 3D-printable F alphorn designed for the Bambu Lab X1C with PLA wood filament. The instrument is a true F alphorn matching Jason Talbot's reference dimensions, splittable into 19 sections that all fit within a 256mm cubed build volume and join via airtight bayonet couplings.

The design is acoustically correct: the second harmonic plays at F2 (87 Hz) — the practical low note of an F alphorn — with the natural harmonic series within ±13 cents of equal temperament.

## Specifications

| | |
|---|---|
| **Pitch** | F (2nd harmonic ≈ 87 Hz) |
| **Total length** | 3880mm (388cm) |
| **Bore profile** | 14mm at mouthpiece → 92mm at bell start → 204mm at bell mouth |
| **Sections** | 19 (15 straight trunk + 3 curve + 1 bell mouth) |
| **Section length** | 204.2mm (max print height 247.7mm) |
| **Curve** | 45° upward bend (3 × 15° at the last three joints) |
| **Joint type** | Rectangular 3-lug bayonet twist-lock with O-ring seal |
| **Wall thickness** | 7mm (trunk) → 8mm (bell), linearly interpolated |

## What's in this repository

| File | Purpose |
|---|---|
| `alphorn.scad` | Full parametric horn with assembly preview |
| `alphorn_print_layout.scad` | Self-contained file with all parts arranged flat for STL export |
| `alphorn_joint_test.scad` | Two-piece test print to validate the bayonet joint before printing all 19 sections |
| `alphorn_diagnostic.scad` | Single-section file with feature toggles for debugging mesh issues |

## Hardware required

- **Printer:** Bambu Lab X1C (or any FDM with ≥256mm build height)
- **Filament:** PLA wood (or any rigid PLA / PETG)
- **18 × O-rings, 2mm cross-section** — see [O-Ring Sizing](#o-ring-sizing) below
- **A mouthpiece** — not included in the print. Use either:
  - A commercial alphorn mouthpiece (Stocker, Eggerstorfer, etc.) with shank tip OD ≈ 12mm
  - The Talbot 20mm 3D-printed mouthpiece STL from [argobuilder.com](https://www.argobuilder.com/3d-printed-alphorn.html) — note: scale that STL to **10%** in the slicer

## How to print

### 1. Test the joint first

Before committing to printing all 19 sections, print `alphorn_joint_test.scad` to validate the bayonet joint mechanics with your printer/filament combination. The test produces two short stubs (~50mm tall each) that share one joint at section 8/9 dimensions.

Verify after printing:

1. Lugs slide cleanly through axial slots
2. Quarter-turn locks the joint with a tactile stop
3. Joint is snug, not loose
4. O-ring groove holds a 2mm O-ring
5. Joint is airtight when O-ring is fitted

If the lugs are too tight or too loose, adjust `BAYONET_CL` in the constants block.

### 2. Print orientation

All sections print **vertically**, small end (mouthpiece-side) **down**. This gives the cleanest bore surface, best layer adhesion along the air column, and requires no supports for sections 1-15. Sections 16-18 have an angled female face at the top — check your slicer's overhang preview; partial supports may be needed at the rim.

### 3. Suggested batching plan (X1C plates)

| Plate | Contents | Approx width |
|---|---|---|
| 1 | Sections 1 + 2 | 110mm |
| 2 | Sections 3 + 4 | 120mm |
| 3 | Sections 5 + 6 | 135mm |
| 4 | Sections 7 + 8 | 155mm |
| 5 | Sections 9 + 10 | 180mm |
| 6 | Sections 11 + 12 | 205mm |
| 7 | Sections 13 + 14 | 235mm |
| 8 | Section 15 only | 134mm |
| 9 | Section 16 only | 155mm |
| 10 | Section 17 only | 175mm |
| 11 | Section 18 only | 205mm |
| 12 | Section 19 only | 227mm |

### 4. Recommended print settings

| | |
|---|---|
| Layer height | 0.2mm |
| Wall loops | 4 minimum |
| Infill (sections 1-15) | 20% |
| Infill (sections 16-19, bell) | 15% |
| Supports | None for 1-15; partial for 16-18 angled rim |
| Bed adhesion | Brim recommended for tall sections |

### 5. Workflow

1. Open `alphorn.scad` in OpenSCAD
2. Set `RENDER_SECTION = true` and `SECTION_NUMBER = N` for the section you want
3. Render with F6 (this can take a few minutes for the larger sections)
4. Export STL
5. Slice in Bambu Studio / Orca with the settings above
6. Repeat for sections 1-19

Or open `alphorn_print_layout.scad` to see all 19 sections laid out at once for visualization.

## Assembly

Each joint between adjacent sections N and N+1 works as follows:

1. **Section N+1's male end** has 3 rectangular lugs at 120° spacing protruding radially, plus an O-ring groove just behind the lugs
2. **Section N's female end** has a collar with three L-shaped slots cut into the inner socket — an axial entry channel and a tangential locking groove
3. **To assemble:** seat an O-ring in the groove on N+1's male end. Align the lugs with the slots in N's female collar, push N+1 in until the lugs bottom out, then twist about 30° to lock the lugs into the tangential lock channels. The O-ring compresses between the male body and the female socket wall, sealing the joint airtight.

Section numbers are recessed into each female collar's inner wall — visible when looking down into the open collar before assembly, hidden by the male collar of the next section once joined.

### O-Ring Sizing

You'll need 18 O-rings, all with 2mm cross-section, sized to stretch snugly over the male shank groove of each section. Inner diameters:

| Joint | O-ring ID | Joint | O-ring ID |
|---|---|---|---|
| 1–2 | 24.07mm | 10–11 | 65.01mm |
| 2–3 | 26.64mm | 11–12 | 71.38mm |
| 3–4 | 29.89mm | 12–13 | 78.04mm |
| 4–5 | 33.69mm | 13–14 | 84.96mm |
| 5–6 | 37.96mm | 14–15 | 92.14mm |
| 6–7 | 42.65mm | 15–16 | 99.57mm |
| 7–8 | 47.73mm | 16–17 | 110.17mm |
| 8–9 | 53.17mm | 17–18 | 132.93mm |
| 9–10 | 58.93mm | 18–19 | 168.60mm |

These are sized 0.5mm undersized to stretch tightly around the shank.

## Mouthpiece

The horn body bore at section 1's small end is 14mm ID. Standard alphorn mouthpieces have a shank tip OD of about 12mm and seat by taper friction at roughly 9mm depth into the bore. No glue, no threaded receiver — the mouthpiece simply press-fits and stays in place during play.

Sources:

- **Commercial:** Any alphorn mouthpiece (Stocker, Eggerstorfer, Tornister, etc.)
- **3D printed:** Talbot's 20mm cup mouthpiece STL on [argobuilder.com](https://www.argobuilder.com/3d-printed-alphorn.html). Important: that STL was exported at 10× scale, so import it and **scale to 10%** in your slicer. Print at 100% infill in PETG.

## Acoustic design

The bore follows a two-part profile from Talbot's reference drawings:

- **Trunk (z=0 to 3140mm):** power law `r(z) = 0.000250 × (z+1)^1.4849 + 6.9997`
- **Bell (z=3140 to 3880mm):** quadratic `ID(s) = 0.00015474 s² + 0.036846 s + 92.0` where `s = z − 3140`, C¹-continuous with the trunk slope at the junction

Each section's bore is subtracted as 8 stepped frustums following this profile, with maximum approximation error of 0.028mm. The bore is preserved at its acoustic profile right up to each joint plane — no internal flaring, no abrupt steps. The joint's mechanical clearance happens entirely above z=len in the female socket region, which is filled by the next section's male collar when assembled.

At 25°C effective playing temperature with end correction of 0.061m at the bell:

| Harmonic | Frequency | Pitch | Cents from equal temperament |
|---|---|---|---|
| 1 | 43.9 Hz | F1 (pedal) | +11 |
| **2** | **87.9 Hz** | **F2 (low note)** | **+11** |
| 3 | 131.8 Hz | C3 | +13 |
| 4 | 175.7 Hz | F3 | +11 |
| 5 | 219.7 Hz | A3 | −3 |
| 6 | 263.6 Hz | C4 | +13 |
| 8 | 351.5 Hz | F4 | +11 |

The uniform +11 cent offset reflects the assumed playing temperature; the player adjusts pitch by lipping and by Talbot's "trim to tune" technique on section 1. The 5th harmonic's natural −3 cents from equal-tempered A3 is characteristic of the harmonic series and matches the historical alphorn sound.

## Customizing the design

`alphorn.scad` is fully parametric. Key constants near the top:

| Constant | Default | Effect |
|---|---|---|
| `TOTAL_LENGTH` | 3880 | Overall horn length in mm |
| `NUM_SECTIONS` | 19 | Number of sections (don't reduce — 18 sections exceed X1C build height) |
| `CURVE_TOTAL_DEG` | 45 | Total bend angle in the bell region |
| `CURVE_JOINTS` | 3 | Number of joints sharing the bend |
| `BAYONET_CL` | 0.25 | Print clearance on lugs (increase if too tight) |
| `WALL_TRUNK` | 7.0 | Wall thickness at the mouthpiece end |
| `WALL_BELL` | 8.0 | Wall thickness at the bell mouth |

Changing these will automatically update the section profile table, batching plan, and acoustic length. Re-print the joint test if you change `BAYONET_CL`.

## Credits and references

This design is built on the work of Jason Talbot at [Argo Builder](https://www.argobuilder.com/), whose detailed measured drawings of a traditional Swiss alphorn made parametric reproduction possible:

- [Making an alphorn (wooden) — full dimensional drawings](https://www.argobuilder.com/making-an-alphorn.html)
- [3D printed alphorn — build log and STL files](https://www.argobuilder.com/3d-printed-alphorn.html)

Additional references:

- Flyby.ch [alphorn manufacture notes](http://www.flyby.ch/alphorn/herst_e.htm)

## License

Specify your preferred license here — common choices:

- **CC-BY-SA 4.0** — share-alike, requires attribution
- **MIT** — permissive, requires attribution
- **CC0** — public domain dedication

## Contributing

Pull requests welcome. If you build one of these and want to share photos or audio, please open an issue!