include <utils.scad>
include <motor.scad>
include <dragonutils.scad>


pulleyDiam = 15;
pulleyInnerDiam = 8;

spineBase(tray = true);

module spineBase(diam = 100, endDiam = 90, tray = false, mirrorPiece = false) {
    wallThickness = 5;
    pulleyLen = 15;
    motorSpacing = 3;
    pulleySpacing = 1;
    len = N20MotorHeight + motorSpacing * 2 + wallThickness * 2;
    motorLen = N20MotorLength + motorSpacing;
    motorOffs = N20MotorHeight/2 + motorSpacing;
    motorZOffs = diam/2 - max(pulleyDiam/2, N20MotorHeight/2) - motorSpacing - 5;
    mediumH = ((diam + endDiam) / 2) * DragonAspect;
    spacing = 5;
    chordTubeDia = SpinalCableDia + spacing;
    chordTubeZ = chordTubeDia/2 + 3;
    stringTubeDia = 6;    
    stringTubeZ = len - stringTubeDia / 2 - 3;
    motorWireDia = 6;
    motorWireZ = len/2+1;
    spineExitY = DragonAspect * diam/2 - spacing - chordTubeDia/2;
    
    stringHoleDistanceX = 80;
    stringHoleDistanceY = 60;
    sx1 = -stringHoleDistanceX/2;
    sx2 =  stringHoleDistanceX/2;
    sy1 = -stringHoleDistanceY/2;
    sy2 =  stringHoleDistanceY/2;

    module stringMotor(cutout = false) {
        rotate([0, 0, 0]) 
            translate([0, 0, 0]) {
                // Motor block
                rotate([0, 0, 0]) 
                    motorCapsule(motorSpacing = motorSpacing, cutout = cutout);    

                // Pulley
                translate([pulleySpacing, 0, 0])
                    rotate([0, 90, 0]) 
                        motorPulley(outerDiam = pulleyDiam, innerDiam = pulleyInnerDiam, cutout = cutout);
            }
    }

    module content() {
        difference() {
            union() {
                // Wall
                dragonCrossSection(w1 = diam, w2 = endDiam, l = len, smoothness = tray ? FinalDragonSmoothness : 40);
            }

            // DEBUG; remove
            *#dragonCrossSection(w1 = diam, w2 = endDiam, l = 1);
            
            // Cut space out for motors
            translate([-23, 5, wallThickness + motorOffs]) {
                rotate([0, 0, 90])
                    stringMotor(cutout = true);
            }

            translate([15, -10, wallThickness + motorOffs]) {
                rotate([0, 0, 20])
                    stringMotor(cutout = true);
            }
            
            // Hole for spinal chord
            translate([0,0,len/2])
                cylinder(r = SpinalCableDia/2, h = len/2+1);
                
            // Bring wiring to top of backside
            multiLine([
                [0,0,chordTubeZ+4], 
                [0,5,chordTubeZ], 
                [0, spineExitY - 5, chordTubeZ],
                [0, spineExitY, chordTubeZ-5],
                [0, spineExitY, -0.1],
                ], dia = chordTubeDia);    

            // String tubing x axis       
            multiLine([
                [sx1,0,len], 
                [sx1,0,stringTubeZ+3], 
                [sx1+1,3,stringTubeZ], 
                [sx1+5,12,stringTubeZ], 
                [-23, 12, stringTubeZ-7],
                [-10, 12, stringTubeZ],
                [10, 16, stringTubeZ],
                [25, 16, stringTubeZ-7],
                [sx2-5, 10, stringTubeZ-6],
                [sx2-2, 3, stringTubeZ-3],
                [sx2, 0, stringTubeZ+1],
                [sx2, 0, len]
                ], dia = stringTubeDia);

            // String tubing y axis
            multiLine([
                [0, sy1, len], 
                [0, sy1, stringTubeZ+3], 
                [3, sy1, stringTubeZ], 
                [22, -24, stringTubeZ],
                [25, -20, stringTubeZ],
                [23, -8, stringTubeZ-7],
                [18, 4, stringTubeZ],
                [18.5, 8, stringTubeZ],
                [26, 14, stringTubeZ],
                [26, 20, stringTubeZ],
                [20, 30, stringTubeZ],
                [3, sy2, stringTubeZ],
                [0, sy2, stringTubeZ+3],
                [0, sy2, len]
                ], dia = stringTubeDia);

            // Tubing for motor wires
            multiLine([
                [-22, -23, motorWireZ], 
                [-13, -23, motorWireZ], 
                [-13, -10, motorWireZ], 
                [-1, 3, motorWireZ]
                ], dia = motorWireDia);
                
            // Bolt holes
            for (pos = [[-35, -12], [37, -9], [14, 23], [-15, 27]])
                translate([pos[0], pos[1], 0])
                    rotate([180, 0,0])
                        bolt(M4, len - 2, nutDepth = 10);
        }
    }

    if (!tray) {
        content();
    }
    else {
        // Pulleys
        for (pos = [[40, 0, 0], [-40, 0, 0]])
            translate(pos)
                motorPulley(outerDiam = pulleyDiam, innerDiam = pulleyInnerDiam, cutout = false);
        
        // Split spine base in two
        splitAlongZ(len/2, xOffset = 0, yOffset = 80) content();
    }


        
}

