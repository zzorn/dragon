

use <utils.scad>;

// Outer wings
//rotate([0,0,45]) {
//    splitAlongZ0(-70, 0) {
//        rotate([0,0,7])
//            outerWing();
//    }
//}

//// Wing arms
//rotate([0,0,0]) {
//    splitAlongZ0(70, 0) {
//            wingArm();
//    }
//}

// Upper arms
rotate([0,0,0]) {
    splitAlongZ0(70, 0, justSplit=true) {
      upperArm();
    }
}



module upperArm(len = 120, hingeInnerD = 3, hingeOuterD = 12, hingeH = 8, hingeAngleMovement = 120) {
    r = len / 15;
    hingeAxleH = 15;
    hingeAxleMembrane = 0.2;
    hingeAxleD = (hingeAxleH - hingeH) / 2 - hingeAxleMembrane;
    hingeWall = 1;
    
    farHingeX = -len * 0.15;
    farHingeY = len * 0.8;
    
    p1 = [0, 0.1, 0];
    p2 = [0, 0.3, 0];
    p3 = [0.1, 0.5, 0];
    p4 = [-0.1, 0.7, 0];
    p5 = [-0.2, 0.7, 0];
    wirerRoute = [p1, p2, p3, p4, p5] * len;
    
    difference() {
        union() {
            rotate([90, 90, 0]) {
                doubleHorn(len*0.3, len*0.75, 20, 20, r * 0.2, r*1.4, r * 0.7, aspect1 = 1, aspect2 = 0.8, aspect3 = 0.5, smoothness = 30, maxSegments = 30);
            }
            // Hinge disc
            translate([farHingeX, farHingeY, 0]) 
                difference() {
                    cylinderTorus(hingeH-2, hingeOuterD/2 - 1, hingeInnerD/2 + 0.1, center = true, smoothness=40);
                    translate([0,+hingeOuterD/2-hingeH/6,0])
                        rotate([0,90,0])
                        cylinder(h = hingeOuterD, r = hingeH/6, center=true, $fn=30);
                }

        }

        // Channel for capacitive sensing wire, and wing seam
        // Wing mover channel
        wirePath(wirerRoute, debugView = true);
        
        // Sensing wire
        //translate([10, 0.2, 0]) 
        //        #multiLine(wirePath, 2, 2, aspect=2);

        
        // Slot for far hinge
        translate([farHingeX, farHingeY, 0])
            cylinder(h=r*2, r = hingeInnerD/2 + 0.1, $fn=30, center=true);
        
        
        // Hinge slot
        translate([-r*0.3, 0, 0]) {
            translate([0, 0, -hingeH/2]) {
                roundedAngle(a = hingeAngleMovement, r = hingeOuterD/2+0.25, l = len/2, h = hingeH, rot = 90, extraThickness = hingeOuterD);
                
            }

            // Area for connection wire
            cube([hingeOuterD + 5, hingeOuterD + 6, hingeH], center=true);
            //cylinder(h=hingeH, r = hingeOuterD/2 + 3, $fn=30);

            // Hingle axle slots. Leave a thin membrane covering the hinge hole so that printing the part is easier.  
            translate([0, 0, hingeH/2 + hingeAxleMembrane]) {     
                cylinder(h=hingeAxleD, r = hingeInnerD/2 + 0.1, $fn=30);
            }        
            translate([0, 0, -hingeH/2 - hingeAxleMembrane - hingeAxleD]) {     
                cylinder(h=hingeAxleD, r = hingeInnerD/2 + 0.1, $fn=30);
            }        
        }
        
        // Fastening knob holes
//        knobs(wirerRoute, xOffs = -2);
        
        //knob(4, x = -len*0.13, y = len*0.75);
        //translate([-len*0.08,   len*0.6,  0]) knob(6);
        //translate([-len*0.07,   len*0.45,  0]) knob(6);
        //translate([-len*0.03,   len*0.3,  0]) knob();
        //translate([-len*0.0,   len*0.15,  0]) knob();
        //translate([-len*0.01,   -len*0.15,  0]) knob();
    }
}


module wingArm(len = 120, hingeInnerD = 3, hingeOuterD = 12, hingeH = 8, hingeAngleMovement = 120) {
    r = len / 15;
    hingeAxleH = 15;
    hingeAxleMembrane = 0.2;
    hingeAxleD = (hingeAxleH - hingeH) / 2 - hingeAxleMembrane;
    hingeWall = 1;
    
    farHingeX = -len * 0.15;
    farHingeY = len * 0.8;
    
    difference() {
        union() {
            rotate([90, 90, 0]) {
                doubleHorn(len*0.3, len*0.75, 20, 20, r * 0.2, r*1.4, r * 0.7, aspect1 = 1, aspect2 = 0.8, aspect3 = 0.5, smoothness = 30, maxSegments = 60);
            }
            // Hinge disc
            translate([farHingeX, farHingeY, 0]) 
                difference() {
                    cylinderTorus(hingeH-2, hingeOuterD/2 - 1, hingeInnerD/2 + 0.1, center = true, smoothness=40);
                    translate([0,+hingeOuterD/2-hingeH/6,0])
                        rotate([0,90,0])
                        cylinder(h = hingeOuterD, r = hingeH/6, center=true, $fn=30);
                }

        }

        // Channel for capacitive sensing wire, and wing seam
        rotate([90, 90, 0]) {
            // Wire channel
            translate([0, r*0.8, 0])
                doubleHorn(len*0.3, len*0.85, 82, 26, 1, 1, 1, aspect1 = 1.2, aspect2 = 2, aspect3 = 1.3, smoothness = 20);
                
            // Line channel    
            translate([0, -r*2.9, -len*0.7]) {
                rotate([-40,0,0])
                    horn(len*0.7, 40, 1, 1, aspect1 = 1.5, aspect2 = 2, smoothness = 30, maxSegments = 30);
            }
        }
        
        // Slot for far hinge
        translate([farHingeX, farHingeY, 0])
            cylinder(h=r*2, r = hingeInnerD/2 + 0.1, $fn=30, center=true);
        
        
        // Hinge slot
        translate([-r*0.3, 0, 0]) {
            translate([0, 0, -hingeH/2]) {
                roundedAngle(a = hingeAngleMovement, r = hingeOuterD/2+0.25, l = len/2, h = hingeH, rot = 90, extraThickness = hingeOuterD);
                
            }

            // Area for connection wire
            cube([hingeOuterD + 5, hingeOuterD + 6, hingeH], center=true);
            //cylinder(h=hingeH, r = hingeOuterD/2 + 3, $fn=30);

            // Hingle axle slots. Leave a thin membrane covering the hinge hole so that printing the part is easier.  
            translate([0, 0, hingeH/2 + hingeAxleMembrane]) {     
                cylinder(h=hingeAxleD, r = hingeInnerD/2 + 0.1, $fn=30);
            }        
            translate([0, 0, -hingeH/2 - hingeAxleMembrane - hingeAxleD]) {     
                cylinder(h=hingeAxleD, r = hingeInnerD/2 + 0.1, $fn=30);
            }        
        }
        
        // Fastening knob holes
        knob(4, x = -len*0.13, y = len*0.75);
        knob(6, x = -len*0.08, y = len*0.6);
        translate([-len*0.07,   len*0.45,  0]) knob(6);
        translate([-len*0.03,   len*0.3,  0]) knob();
        translate([-len*0.0,   len*0.15,  0]) knob();
        //translate([-len*0.01,   -len*0.15,  0]) knob();
    }
}


module outerWing(len = 230, hingeInnerD = 3, hingeOuterD = 12, hingeH = 8, hingeAngleMovement = 120) {
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
        
        // Fastening knob holes
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


