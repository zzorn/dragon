
include <utils.scad>;
use <dragonutils.scad>;


motorcontroller();

// Cutout for uMoto motor controller board
module motorcontroller(double = false, ledPipeLen = 10, 
                        inputWireAngle = 0, inputWireLen = 10, inputOffset = 0.5,
                        outputWireAngle = 0, outputWireLen = 10, outputOffset = 0.5, 
                        motorWireAngle = 0, motorWireLen = 10, motorOffset = 0.5,
                        useScrews = true, screwLengthTop = 5, screwLengthBot = 5) {
    
    epsilon = 0.01;
    
    pinW = 0.1 * 25.4;
    
    margin = 0.75;
    extraPcbSpace = 0.5;
    ledPipeDia = 4;
    topMaxH = 8;
    botMaxH = 5;
    
    dataLedPos = [10, 22];
    dataLed2Pos = [36, 22];
    powerLedPos = [7, 4];
    powerLed2Pos = [33, 4];
    ledPositions = !double ? [dataLedPos, powerLedPos] : [dataLedPos, powerLedPos, dataLed2Pos, powerLed2Pos];
    screwPositions = !double ? [[2.5, 2.5], [21.5, 2.5]] : [[2.5, 2.5], [21.5, 2.5], [28.5, 2.5], [48.5, 2.5]];
    
    pcbH = 1.2;
    pcbW = double ? 50 : 24;
    pcbL = 24;
    
    wireHoleH = 4;
    
    totalH = topMaxH + botMaxH + pcbH;

    module wireChannel(xPos, yPos, numPins, zAngle, len, angle, offset) {
        translate([xPos, yPos, pcbH/2 + (pcbH/2+wireHoleH/2) * offset])
            rotate([0,0,zAngle])
                rotate([angle + 90, 0, 0])
                    translate([0, 0, len/2-wireHoleH/2])
                        roundedBox([pinW*numPins, wireHoleH, len+wireHoleH], wireHoleH/2, false, $fn = 30);
    }
    
    // Rotate to get more logial inputs on left and outputs on right configuration during modeling
    translate([pcbW/2, pcbL/2, -pcbH/2])
        rotate([0,0,180]) {
            // Pcb
            translate([-extraPcbSpace, -extraPcbSpace, 0])
                cube([pcbW+extraPcbSpace*2, pcbL+extraPcbSpace*2, pcbH]);

            // Components
            translate([margin, margin, pcbH-epsilon])
                cube([pcbW-margin*2, pcbL-margin*2, topMaxH+epsilon]);
            translate([margin, margin, -botMaxH])
                cube([pcbW-margin*2, pcbL-margin*2, botMaxH+epsilon]);
            
            // Led light pipes
            for (pos = ledPositions) {
                translate([pos[0], pos[1], -epsilon]) 
                    cylinder(r = ledPipeDia/2, h = topMaxH+ledPipeLen+pcbH+epsilon*2, $fn=30);
            }

            // Channels for wires  
            wireChannel(double ? 48 : 22, 14, 7, 90, inputWireLen, inputWireAngle, inputOffset);
            wireChannel(2, 14, 7, -90, outputWireLen, outputWireAngle, outputOffset);
            wireChannel(12, 1.5, 5, 0, motorWireLen, motorWireAngle, motorOffset);
            if (double) {
                wireChannel(38, 1.5, 5, 0, motorWireLen, motorWireAngle, motorOffset);
            }
            
            // Screws
            if (useScrews && (screwLengthTop > 0 || screwLengthBot > 0)) {
                for (pos = screwPositions)
                    translate([pos[0], pos[1], topMaxH + pcbH + screwLengthTop])
                        bolt(M3, screwLengthTop + totalH + screwLengthBot ); //+ M3[M_NutHeightNyloc]
            }
        }

    
}




