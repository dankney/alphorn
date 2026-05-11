# 3D Printable F Alphorn — Project Snapshot
**Date:** April 28, 2026
**Status:** OpenSCAD v7 — 19 sections, all parts fit X1C 256mm build height, print layout file complete

---

## Project Goal
Design a fully functional, playable F alphorn that can be 3D printed on a Bambu Lab X1C using PLA wood filament (via AMS), and assembled as simply as possible.

---

## Hardware & Materials
- **Printer:** Bambu Lab X1C
- **Build volume:** 256 × 256 × 256mm
- **Filament:** PLA wood filament via AMS
- **Slicer:** Bambu Studio

---

## Fundamental Geometry
The alphorn is a **single continuous hollow tapered tube** from mouthpiece to bell mouth. There is no separate bell attachment. The bell is simply where the taper flares more rapidly in the final 740mm. Each printed section is a plain hollow frustum with a rectangular bayonet joint integrated as part of the same connected mesh.

The instrument has a gentle **45° upward curve** in the bell region, distributed across the last three section joints (15°/joint × 3 joints).

---

## Files
| File | Purpose |
|---|---|
| `alphorn.scad` | Full parametric horn — 19 sections + mouthpiece + foot + assembly preview |
| `alphorn_print_layout.scad` | Self-contained file showing all parts arranged flat for printing reference |
| `alphorn_joint_test.scad` | Self-contained two-piece test print to validate the bayonet joint |

---

## Design Decisions Made
- **Tuning:** Standard F (388cm total)
- **Style:** Traditional sweeping curve (45° bend in bell region)
- **Joints:** Rectangular bayonet twist-lock with O-ring groove
- **Sections:** 19 identical-construction sections covering the full 3880mm bore
- **Bell:** NOT a separate piece — sections 17–19 are the bell region
- **Mouthpiece:** 20mm cup diameter (Talbot design), printed separately at 100% infill, shank tip seats directly in the section 1 bore by taper friction
- **Curve:** Angled female faces on sections 16, 17, 18 (15° each = 45° total)
- **Support foot:** Designed but excluded from assembly preview

---

## Section Count Rationale
The instrument was originally 18 sections × 215.6mm. Section 17 measured **258.7mm** in print orientation due to the angled female collar lifting one side ~24mm above the body — exceeding the X1C's 256mm build height. Increasing to 19 sections × 204.2mm brings worst-case section height to 247.7mm, comfortably within the build envelope while preserving the same total horn length (3880mm) and acoustic profile.

---

## Authoritative Dimension Source
Jason Talbot's alphorn drawings:
**https://www.argobuilder.com/making-an-alphorn.html**

His 3D printed alphorn build log:
**https://www.argobuilder.com/3d-printed-alphorn.html**

---

## Confirmed Dimensions

### Overall
| Parameter | Value |
|---|---|
| F horn trunk length | 314cm |
| Bell region length | 74cm |
| **Total horn length** | **388cm (3880mm)** |
| Wall thickness (trunk) | 7mm |
| Wall thickness (bell) | 8mm |

### Bore Reference Points
| Station | Inner Diameter | Outer Diameter |
|---|---|---|
| z=0mm (mouthpiece) | 14.0mm | 28.0mm |
| z=2200mm | 60.0mm | 74.0mm |
| z=3140mm (bell start) | 92.0mm | 106.0mm |
| z=3880mm (bell mouth) | 204.0mm | 220.0mm |

### Mouthpiece (Talbot 20mm)
| Parameter | Value |
|---|---|
| Total length | 105.17mm |
| Cup ID | 20.0mm |
| Cup OD | 31.84mm |
| Backbore D | 4.76mm |
| Shank length | 78.94mm |
| Shank tip OD / ID | 12.03 / 8.97mm |

The narrow shank tip inserts into the horn bore at z=0 and seats by taper friction at ~9mm depth.

---

## Bore Profile

### Trunk (z=0 to 3140mm) — Power Law
```
r(z) = 0.000250 × (z+1)^1.4849 + 6.9997
```

### Bell (z=3140 to 3880mm) — Quadratic
```
s = z - 3140
ID(s) = 0.00015474×s² + 0.036846×s + 92.0
```
C1-continuous with trunk slope at s=0. Reaches 204mm at s=740.

### Wall Thickness
Linear interpolation: 7.0mm at z=0 → 8.0mm at z=3880.

### Bore Subtraction
8-step subdivided frustum subtraction follows the curved profile. Max error 0.028mm. Bore is uninterrupted from z=0 to z=len within each section — **no internal flare** at joints. The bore preserves its acoustic profile right up to each joint plane. For curve sections (16–18), an additional bore extension above z=len prevents any solid-material plug from the angled-cut overhang.

### Full Section Profile Table (19 sections × 204.2mm)
| n | z_start | z_end | ID_start | ID_end | OD_start | OD_end | Curve? | Print Height |
|---|---|---|---|---|---|---|---|---|
| 1 | 0.0 | 204.2 | 14.00 | 15.39 | 28.00 | 29.54 | | 224.2mm |
| 2 | 204.2 | 408.4 | 15.39 | 17.86 | 29.54 | 32.13 | | 224.2mm |
| 3 | 408.4 | 612.6 | 17.86 | 21.04 | 32.13 | 35.45 | | 224.2mm |
| 4 | 612.6 | 816.8 | 21.04 | 24.79 | 35.45 | 39.36 | | 224.2mm |
| 5 | 816.8 | 1021.1 | 24.79 | 29.04 | 39.36 | 43.78 | | 224.2mm |
| 6 | 1021.1 | 1225.3 | 29.04 | 33.71 | 43.78 | 48.62 | | 224.2mm |
| 7 | 1225.3 | 1429.5 | 33.71 | 38.78 | 48.62 | 53.85 | | 224.2mm |
| 8 | 1429.5 | 1633.7 | 38.78 | 44.20 | 53.85 | 59.43 | | 224.2mm |
| 9 | 1633.7 | 1837.9 | 44.20 | 49.95 | 59.43 | 65.34 | | 224.2mm |
| 10 | 1837.9 | 2042.1 | 49.95 | 56.01 | 65.34 | 71.55 | | 224.2mm |
| 11 | 2042.1 | 2246.3 | 56.01 | 62.36 | 71.55 | 78.06 | | 224.2mm |
| 12 | 2246.3 | 2450.5 | 62.36 | 69.00 | 78.06 | 84.86 | | 224.2mm |
| 13 | 2450.5 | 2654.7 | 69.00 | 75.91 | 84.86 | 91.93 | | 224.2mm |
| 14 | 2654.7 | 2858.9 | 75.91 | 83.10 | 91.93 | 99.27 | | 224.2mm |
| 15 | 2858.9 | 3063.2 | 83.10 | 90.55 | 99.27 | 106.87 | | 224.2mm |
| 16 | 3063.2 | 3267.4 | 90.55 | 105.51 | 106.87 | 121.91 | **female 15°** ← bell | 240.3mm |
| 17 | 3267.4 | 3471.6 | 105.51 | 127.87 | 121.91 | 144.34 | **female 15°** | 243.1mm |
| 18 | 3471.6 | 3675.8 | 127.87 | 160.17 | 144.34 | 176.71 | **female 15°** | 247.7mm |
| 19 | 3675.8 | 3880.0 | 160.17 | 204.00 | 176.71 | 220.00 | (open mouth) | 204.2mm |

All sections fit within X1C 256 × 256 × 256mm build volume.

---

## Bayonet Joint Specification

Rectangular lugs and L-shaped slots in the female collar:

| Parameter | Value | Purpose |
|---|---|---|
| Lug count | 3 (at 120°) | Symmetric lock |
| Engagement depth | 15mm | Travel from open face to lock |
| Lug — radial (BAYONET_LUG_H) | 3.5mm | Protrusion outward |
| Lug — tangential (BAYONET_LUG_W) | 8mm | Width along circumference |
| Lug — axial (BAYONET_LUG_T) | 5mm | Thickness in slide direction |
| Lug embed (LUG_EMBED) | 1.0mm | Cube extends inward into body wall |
| Collar length | 20mm | At each end |
| Print clearance | 0.25mm | On lugs |
| O-ring groove | 2.5mm × 2.2mm | Fits 2mm cross-section O-ring |
| O-ring Z position (ORING_Z) | 10mm | Body-local z, just above lugs |
| Lock rotation | ~30° | Quarter-twist sweep |

---

## Unified Joint Methodology

**Every section uses one `difference()` block:**

**Outer hull (union):**
1. Body frustum (`od0` → `od_at_flare`)
2. External flare to collar OD (only if female end exists)
3. Female collar block on appropriate plane (only if female end exists)
4. Male lugs embedded 1mm into body wall (only if n > 1)

For curve sections, the body+flare are intersected with a tilted half-space below the collar plane.

**Subtractions:**
1. Bore profile (8-step curved frustum, z=0 to z=len)
2. Bore extension above z=len (curve sections only)
3. Inner socket (collar region, on tilted plane for curve sections)
4. L-channels (lug paths)
5. O-ring groove (cuts circumferential channel into outer body wall at ORING_Z=10)

### Per-Section Pieces
| Section | Female end | Male end | Notes |
|---|---|---|---|
| 1 | ✓ collar | — | Mouthpiece end (no male side) |
| 2–15 | ✓ collar | ✓ lugs + O-ring | Standard sections |
| **16** | ✓ collar (**15° angled**) | ✓ lugs + O-ring | First curve joint (bell start) |
| **17** | ✓ collar (**15° angled**) | ✓ lugs + O-ring | Curve joint |
| **18** | ✓ collar (**15° angled**) | ✓ lugs + O-ring | Curve joint |
| 19 | — (open bell mouth) | ✓ lugs + O-ring | Bell mouth section |

The test file (`alphorn_joint_test.scad`) uses identical joint methodology to a generic interior section.

---

## Curve Implementation
Sections 16, 17, 18 have their female end face cut at 15° instead of perpendicular. The female collar sits on the tilted face plane. Mating section's perpendicular male collar rotates that section's body axis by 15°.

- 45° total bend in bell region
- No length added — curves at existing joints
- OD unchanged at faces; wall thickness preserved
- Bore stays open with 15° kink at each joint (acoustically negligible at wide bell end)

Assembly preview uses recursive forward kinematics (`place_section_chain`) — walks up the horn, applying 15° rotation at each curve joint.

---

## OpenSCAD Module Inventory (`alphorn.scad`)
| Module / Function | Purpose |
|---|---|
| `bore_id(z)` | Inner diameter at any z (power law trunk + quadratic bell) |
| `wall_at(z)` | Wall thickness, linear 7→8mm |
| `bore_od(z)` | Outer diameter at z |
| `is_curve_section(n)` | True for sections 16, 17, 18 |
| `cumulative_curve(n)` | Total bend angle accumulated through section n |
| `taper_tube()` | Standalone hollow frustum |
| `horn_section(n)` | Single difference() that produces a complete connected section |
| `l_channels_only(od)` | L-shaped lug paths |
| `male_lugs(od)` | Three rectangular lugs embedded 1mm into body wall |
| `oring_groove(od, id)` | Circumferential channel cut into outer wall at ORING_Z=10 |
| `mouthpiece()` | 20mm cup mouthpiece, shank tip at z=0 |
| `support_foot()` | Ground peg with saddle clamp |
| `place_section_chain(n)` | Recursive forward kinematics for assembly preview |
| `full_assembly()` | Complete preview render |

### Render Control
```openscad
RENDER_ASSEMBLY   = true;   // full preview
RENDER_MOUTHPIECE = false;
RENDER_SECTION    = false;  // set SECTION_NUMBER = 1–19
RENDER_FOOT       = false;
```

---

## Print Layout File (`alphorn_print_layout.scad`)
Self-contained, no external dependencies. Renders all 19 sections + mouthpiece + foot arranged flat on the XY plane in optimal print orientation. Useful for visualizing the parts list.

### Batching Plan (X1C plates)
| Plate | Contents | Width |
|---|---|---|
| 1 | Sections 1 + 2 | ~110mm |
| 2 | Sections 3 + 4 | ~120mm |
| 3 | Sections 5 + 6 | ~135mm |
| 4 | Sections 7 + 8 | ~155mm |
| 5 | Sections 9 + 10 | ~180mm |
| 6 | Sections 11 + 12 | ~205mm |
| 7 | Sections 13 + 14 | ~235mm |
| 8 | Section 15 only | |
| 9 | Section 16 only | |
| 10 | Section 17 only | |
| 11 | Section 18 only | |
| 12 | Section 19 only | |
| 13 | Mouthpiece + foot | |

---

## Parts List
| Part | Qty | Notes |
|---|---|---|
| Horn sections 1–15 | 15 | Standard sections, perpendicular female face |
| Horn sections 16–18 | 3 | Angled (15°) female face for curve |
| Horn section 19 | 1 | Bell mouth, no female collar |
| Mouthpiece (20mm) | 1 | 100% infill |
| Support foot | 1 | Optional |
| O-rings (2mm cross-section) | 18 | One per joint |

---

## Open Issues / Next Steps

### Priority — next to do:
1. **Print the test file** (`alphorn_joint_test.scad`) — validate joint mechanics with PLA wood on X1C.
2. **Tune clearance if needed** — adjust `BAYONET_CL` based on test print fit.
3. **Visual verification of curve** — render the assembly preview and confirm the curve matches the photos.
4. **Bell mouth ring** — decorative/structural ring at section 19 exit.
5. **Tuning allowance** — Section 1 could be printed +160mm oversize for trim-to-tune.

### Nice-to-haves:
- AMS color accent rings at bayonet collars
- Edelweiss / Swiss cross relief on bell exterior
- Assembly jig for angled curve joints

---

## Print Settings (recommended)
| Setting | Value |
|---|---|
| Layer height | 0.2mm |
| Wall loops | 4 minimum |
| Infill — sections 1–15 | 20% |
| Infill — sections 16–19 (bell) | 15% |
| Infill — mouthpiece | 100% |
| Supports | None for sections 1–15, possibly partial for 16–18 angled overhang |
| Print orientation | Vertical, small end up |

---

## Known Issues Resolved
| Issue | Resolution |
|---|---|
| Wrong bore dimensions (11mm mouthpiece end) | Corrected to 14mm |
| Piecewise linear bore kink at 220cm | Smooth power law + quadratic |
| Bell modelled as separate piece | Removed — bell is sections 17–19 of same continuous tube |
| Internal geometry inside tube | Removed — sections are plain hollow frustums |
| Linear bore subtraction left 1.8mm ring inside bell | Fixed with 8-step subdivided bore subtraction |
| Support foot appearing inside bell in assembly | Removed from assembly preview |
| Mouthpiece receiver (wider pipe at mouthpiece end) | Removed — shank seats directly in bore |
| Stale no-op difference block in section 1 | Removed |
| Straight stick instead of curved alphorn | Added 45° bell curve via angled female faces on curve sections |
| Round slots / round lugs (geometry mismatch) | Rectangular lugs + L-shaped (rotate_extrude) slots |
| Cartesian cube slots left 0.293mm material slivers at edges | Slots and lock channels use rotate_extrude |
| Female collar floating disconnected from body | Body and collar unioned into single outer hull |
| Internal flare changed bore acoustics | External flare only — bore stays on profile to joint plane |
| Lugs only tangent-line-attached to curved body wall | Lugs embedded 1mm radially into body wall, unioned into outer hull |
| Curve sections had bore plug from angled-cut overhang | Bore extension cylinder added above z=len for curve sections |
| Lugs and O-ring groove placed below z=0 (outside body) | Removed bogus translate; ORING_Z=10 placed inside body |
| Curve section body construction inconsistent with straight | Unified outer hull construction; tilted half-space intersection only |
| **Section 17 was 258.7mm tall — exceeded 256mm build height** | **Increased section count from 18 to 19; max height now 247.7mm** |

---

## Reference Links
- Talbot wooden alphorn drawings: https://www.argobuilder.com/making-an-alphorn.html
- Talbot 3D printed alphorn + Fusion 360 files: https://www.argobuilder.com/3d-printed-alphorn.html
- Flyby.ch manufacture notes: http://www.flyby.ch/alphorn/herst_e.htm
