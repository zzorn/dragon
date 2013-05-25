

use <utils.scad>;

// Outer wings
rotate([0,0,45]) {
    splitAlongZ0(-70, 0) {
        rotate([0,0,7])
            wingArm(len=230);
    }
}

//// Fastening knobs - Use pieces of filament instead
//for (i = [1 : 4])
//    translate([8, -20 -i * 10, 0]) knob();

module knob(knobD = 3, knobH = 8, hole = false) {
    glap = 0.6;

    if (hole) {
        translate([0,0,-knobH/2]) cylinder(h = knobH+glap/2, r = knobD/2+glap/4, $fn=20);
        //cube([knobD, knobD, knobH], center = true);
    }
    else {
        cylinder(h = knobH - glap/2, r = knobD/2 - glap/4, $fn=20);
        //cube([knobD - glap, knobH - glap, knobD - glap]);
    }
}

module wingArm(len = 150, hingeInnerD = 3, hingeOuterD = 12, hingeH = 8, hingeAngleMovement = 120) {
    r = len / 25;
    hingeAxleH = 15;
    hingeAxleMembrane = 0.2;
    hingeAxleD = (hingeAxleH - hingeH) / 2 - hingeAxleMembrane;
    
    difference() {
        rotate([90, 90, 0]) {
            doubleHorn(len*0.75, len*0.25, 30, 45, r * 0.3, r, r * 0.3, aspect1 = 1.4, aspect2 = 1.1, aspect3 = 0.9, smoothness = 30, maxSegments = 60);
        }

        // Channel for capacitive sensing wire, and wing seam
        translate([r*0.5, 0, 0])
            rotate([90, 90, 0]) {
               doubleHorn(len*0.68, len*0.23, 30, 48, r * 0.13, r * 0.17, r * 0.13, aspect1 = 2, aspect2 = 2, aspect3 = 2, smoothness = 10);
            }
        
        // Hinge slot
        translate([-r*0.3, 0, 0]) {
            translate([0, 0, -hingeH/2]) {
                roundedAngle(a = hingeAngleMovement, r = hingeOuterD/2+0.25, l = len*0.15, h = hingeH, rot = 90, extraThickness = hingeOuterD);
                
            }

            // Area for connection wire
            cube([hingeOuterD + 4, hingeOuterD + 8, hingeH], center=true);
            //cylinder(h=hingeH, r = hingeOuterD/2 + 3, $fn=30);

            // Hingle axle slots. Leave a thin membrane covering the hinge hole so that printing the part is easier.  
            translate([0, 0, hingeH/2 + hingeAxleMembrane]) {     
                cylinder(h=hingeAxleD, r = hingeInnerD/2 + 0.1, $fn=30);
            }        
            translate([0, 0, -hingeH/2 - hingeAxleMembrane - hingeAxleD]) {     
                cylinder(h=hingeAxleD, r = hingeInnerD/2 + 0.1, $fn=30);
            }        
        }

        
        // Fastening knobs
        translate([-len*0.18,  -len*0.7,  0]) knob(hole=true, knobH=6);
        translate([-len*0.13,  -len*0.6,  0]) knob(hole=true, knobH=7);
        translate([-len*0.09,  -len*0.5,  0]) knob(hole=true);
        translate([-len*0.055, -len*0.4,  0]) knob(hole=true);
        translate([-len*0.032, -len*0.3,  0]) knob(hole=true);
        translate([-len*0.016, -len*0.21, 0]) knob(hole=true);
        translate([-len*0.005, -len*0.12, 0]) knob(hole=true);
        translate([-len*0.022,  len*0.12, 0]) knob(hole=true, knobH=7);
                    
    }

}


