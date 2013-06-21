

use <utils.scad>;
include <motor.scad>;

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
//rotate([0,0,0]) {
//    splitAlongZ0(70, 0, justSplit=true) {
//      upperArm();
//    }
//}

//rotate([0,0,0]) {
//    splitAlongZ0(70, 0, justSplit=true) {
//        wingBase();
//    }
//}

wingBase();


WingTabDiam = 20;
WingTabHeight = 10;
WingTabHoleDiam = 3;
WingTabHoleDepth = 8;
WingWireHoleSize = 4;

// Tab that connects one wing to another
module wingTab(tabD = WingTabDiam, tabH = WingTabHeight, holeD = WingTabHoleDiam, tabLen = 10, angle = 0, offset = 0, holeSpacing = 0.5, wireHoleSize = WingWireHoleSize) {
    rotate([0,0,angle]) {
        translate([-tabLen - tabD/2 - offset, 0, 0]) {
            difference() {
                union() {
                    cylinder(r = tabD/2, h = tabH, center = true, $fn = 30);
                    translate([0, -tabD/2, -tabH/2]) {
                        cube([tabD/2 + tabLen, tabD, tabH]);
                    }
                }
                
                cylinder(r = holeD/2 + holeSpacing, h = tabH + 2, center = true, $fn = 30);
                
            }

        }       
    }   

    *%wingSocketCutout(tabD, tabH, holeD, angle=angle, offset  = offset + tabLen, holeSpacing = holeSpacing, wireHoleSize = wireHoleSize);
}

// Cutout to do wherever a wingTab is connected to a wing
module wingSocketCutout(tabD = WingTabDiam, tabH = WingTabHeight, holeD = WingTabHoleDepth, holeH = 20, cutoutLen = 40, sweepAngle = 120, angle = 0, offset = 0, spacing = 1, holeSpacing = 0.5, speewAngleStep = 20, wireHoleSize = WingWireHoleSize) {
    rotate([0,0,angle]) {
        translate([ - offset , 0, 0]) {
            union() {
                // Central tab hole
                cylinder(r = tabD/2 + spacing, h = tabH + spacing*2, center = true, $fn = 30);
                
                // Space for wires
                cylinder(r = tabD/2 + spacing + wireHoleSize, h = wireHoleSize + spacing*2, center = true, $fn = 30);
                
                // Cutout for tab movement
                for (a = [-sweepAngle/2 : speewAngleStep : sweepAngle/2]) {
                    rotate([0, 0, a]) {
                        translate([0, -tabD/2-spacing, -tabH/2-spacing]) {
                            cube([tabD/2 + cutoutLen, tabD + spacing*2, tabH + spacing*2]);
                        }
                    }
                }
            }
            
            // Hole for rotating tab
            cylinder(r = holeD/2 + holeSpacing, h = tabH + 2*holeD + spacing*2, center = true, $fn = 30);

        }
    }
}

module wingStart(len = 60, sweeperLen = 10, w = 10, h = 10, baseH = 10, spacing = 3, angle = 0, blockDiam = WingTabDiam + 20) {

    holeLen = len - sweeperLen;

    totalH = h*2 + baseH + spacing*2;

    rotate([0,0,angle]) {
        difference() {
            translate([0, -w/2, -h -baseH/2 - spacing]) {
                // Sweeper
                cube([len, w, totalH]);
                
                // Base block
                translate([0, w/2, 0])
                    cylinder(h = totalH, r = blockDiam/2, center = false, $fn=30);
            }
            
            // Cutout tab
            wingSocketCutout(cutoutLen = holeLen-WingTabDiam, tabH = baseH);
            
            // Cutout some extra spacing
            translate([WingTabDiam,-w/2-1,-baseH/2-spacing])
                cube([holeLen+1-WingTabDiam, w+2, baseH+spacing*2]);
        }

        // Support
        translate([len, 0, -totalH/2])        
            cylinder(r = w/2, h = totalH);
        translate([holeLen, 0, -totalH/2])        
            cylinder(r = w/2, h = totalH);
    }
}

module wingBase(baseLen = 100, h = 12, w = 15, maxSweepAngle = 60, tray = false, testLocation = 0.7) {

    motorW = N20MotorWidth;
    motorH = N20MotorHeight;
    motorLen = N20MotorLength;
    motorSpacing = 4;
    motorFrontSpacing = 1;
    
    armW = motorW + 2 * motorSpacing;    

    axleD = 4;
    axleTubeD = h;
    axleL = 30;
    baseH = h;
    holeOffset = 5;
    holeDist = axleTubeD + holeOffset + WingTabDiam/2;
    sweeperW = 15;
    sweeperLen = 1/cos(maxSweepAngle/2) * motorLen;
    sweepRadius = w + holeDist + sweeperW/2;
    swingLen = 1/cos(maxSweepAngle/2) * sweepRadius + sweeperLen;
    swingTabSize = 12;
    len = sweeperW + 2 * (sin(maxSweepAngle/2) * (1/cos(maxSweepAngle/2) * sweepRadius)) + armW*0.75;
    
    

    armLen = N20MotorLength + motorSpacing + motorFrontSpacing + N20MotorWireSpaceLen - armW/4;

    motorOffs = len/2 - 10;
    motorXOffs = -14;
    motorZOffs = -2;
    pulleyLen = 12;
    pulleySpacing = 1;
    
    contractorArmExtraLen = sweeperW;
    contractorStringDepth = 0.4;
    stringHoleDiam = 4;

    module armPos(lenOffs = 0, wOffs = 0, hOffs = 0, left = true) {
        translate([holeDist, 0, 0]) {
            rotate([0,0,90+maxSweepAngle/2 * (left ? 1 : -1)])
                translate([(sweeperW/2 + armW/2) * (left ? -1 : 1) - wOffs, swingLen - lenOffs, baseH + hOffs]) {
                    child(0);
                }
        }
    }

    module basePulley() {
        pulley(pulleyDiam = 10, pulleyW = 5, pulleyWallH = 5, axleDiam = N20MotorShaftDiameter, axleFlatDepth = N20MotorShaftFlatDepth, wireHoleDiam = 2);
    }

    module baseStructure() {
        // Axle to turn wing up and down about
        translate([axleTubeD, 0, axleTubeD/2]) {
            hingeCenter(casingD = axleTubeD) {
                wingTab(angle = 180, offset = 0, tabLen = holeOffset, tabH = h);
            }
            
            // Support preview
            if (!tray) 
                %hingeSupport(casingD = axleTubeD, casingZUp = 10, casingXRight = 5, casingZDown = 10);
        }

        difference() {
            union() {
                // Base
                translate([-w, -len/2, 0]) {
                    cube([w, len, baseH]);
                }
                for (y = [-len/2, len/2]) {
                    translate([-w/2, y, 0]) {
                        cylinder(r = w/2, h = baseH);
                    }
                }
                
                // Motor hold
                armPos(pulleyLen/2 + armLen, armW/2, -baseH) {
                    union() {
                       cube([armW, armLen, baseH]);
                       *translate([armW/2, 0, 0])
                           cylinder(r = armW/2, h = baseH);
                    }
                }

                // Elastic wire fastening place
                armPos(pulleyLen/2 + armLen , armW/2, -baseH, left = false) {
                    union() {
                       cube([armW, armLen + contractorArmExtraLen, baseH]);
                       *translate([armW/2, armLen + contractorArmExtraLen, 0])
                           cylinder(r = armW/2, h = baseH);
                    }
                }
            }

            // Motor cutout
            armPos(pulleyLen/2, 0, 0) 
                rotate([0,0,90])
                    motor(centerAtAxis = true, shaftCutout = true);

            // Cutout for elastic wire
            armPos(pulleyLen/2 + armLen , 0, -baseH*contractorStringDepth, left = false) {                
                wirePath([
                [-armW, 0, 0], 
                [0,0,0], 
                [0, armLen + contractorArmExtraLen/2, 0], 
                [-armW, armLen + contractorArmExtraLen/2+stringHoleDiam*1, 0], 
                [-armW, armLen+ contractorArmExtraLen/2-stringHoleDiam*2, 0], 
                [0, armLen + contractorArmExtraLen/2-stringHoleDiam, 0] ], stringHoleDiam, stringHoleDiam, aspect = 1, knobH = baseH*contractorStringDepth*2, debugView = false);
            }
            translate([-w/2,0,baseH*(1-contractorStringDepth)])
                wirePath([[0, baseLen, 0], [0,0,0], [-w,0,0], [-w,-w,0], [0,0,0]], stringHoleDiam, stringHoleDiam, aspect = 1, knobH = baseH*contractorStringDepth*2, debugView = false);

            // For swing arm moving
            //translate([holeDist, 0, -1]) {
            //    cylinderTorus(baseH+2, swingLen + swingTabSize/2, swingLen - swingTabSize/2, smoothness = 50);
            //}
            
        }
    }

    // Show preview or print tray, as requested
    if (tray) {
        // Tray arrangement for printing
        
        translate([-40, 0, 0])  basePulley();
        
        baseStructure();
    }
    else {
        // Preview of assembly

        // Base
        baseStructure();

        // Pulley
        armPos(pulleyLen/2 - pulleySpacing, 0, 0) {
            rotate([-90, 0, 0])
                basePulley();
        }
        
        // Wing preview
        translate([axleTubeD + holeOffset + WingTabDiam/2,0,baseH/2])
            %wingStart(angle=180 - maxSweepAngle/2 + maxSweepAngle * testLocation, len = swingLen, sweeperLen = sweeperLen, w = sweeperW, baseH = baseH);    
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


