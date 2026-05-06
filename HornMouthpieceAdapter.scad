fillet = 1;

module rounded_cyl(h, r, f=fillet) {
    rotate_extrude($fn=12)
        offset(r=f, $fn=32)
            offset(r=-f)
                square([r, h]);
}

difference() {
    union() {
        translate([0,0,9])
            cylinder($fn=360, 5, 8.5, 8.35);
        translate([0,0,14])
            cylinder($fn=360, 42, 8.35, 6);
        rounded_cyl(9, 12.5);
    }
    union(){
        cylinder($fn=360, 28, 4.5, 3.9);
        translate([0,0, 26])
            cylinder(30.8, 3.9, 4.74);
     }
}