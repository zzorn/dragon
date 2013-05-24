// Openscad, animatronic dragon, work in progress, see http://github.com/zzorn/dragon

use <utils.scad>;

$fn = 20;


holeMargin = 1;


testSpine(xNum=1, yNum=1);

//dragon();

//neckSegment();

//dragonScaleSection();



// Test setup for spines
module testSpine(xNum = 3, yNum = 3, step = 10, startSize = 20) {    
    spacing = max(xNum,yNum)*step*1.8+startSize+10;
    w = xNum*spacing;
    h = yNum*spacing;
    
    for (x = [0 : xNum-1], y = [0 : yNum-1])
        translate([(x-(xNum-1)/2)*spacing, (y-(yNum-1)/2) * spacing, 0]) {
            neckSegment(x*step + startSize, 
                        y*step + startSize, 
                        (x+y) * 0.5 *step + startSize, 
                        10.3, 
                        3);
                        
                        /*
            translate([0,0,(x+y) * 0.5 *step + startSize])
                neckSegment(x*step + startSize, 
                            y*step + startSize, 
                            (x+y) * 0.5 *step + startSize, 
                            10.3, 
                            3);
                            */
        }
}


module dragon(width = 100, length = 700, wingspan = 500, tubeDiam = 8, tendonDiam = 3) {
    
    spacing = 0;
    
    
    // Head
    headWidth = width * 0.6;
    headLength = length * 0.125;
    translate([-headWidth/2, bodyLength/2 + spacing + neckLength + spacing*neckSegments, 0]) {
        head(headWidth, headWidth*0.7, headLength);
    }
    
    // Neck
    neckWidth = width * 0.3;
    neckLength = length * 0.22;
    neckSegments = 5;
    translate([0, bodyLength/2 + spacing, 0]) {
        spine(neckWidth*1.1, neckWidth, neckLength, 1.2, 0.8, tubeDiam, tendonDiam, neckSegments, spacing, startSpikeSize=1, startSpikeAngle=28, endSpikeSize=0.9, endSpikeAngle=26);
    }
    
    // Body
    bodyWidth = width*1;
    bodyLength = length * 0.175;        
    translate([0,-bodyLength/2,0]) {
        body(bodyWidth, bodyLength, wingspan);
    } 
    
    // Tail
    tailWidth = width * 0.25;
    tailLength = length * 0.48;
    tailSegments = 10;
    translate([0, -tailLength - spacing*tailSegments-bodyLength/2, 0]) {
        spine(tailWidth*1.2, tailWidth, tailLength, 0.6, 1.2, tubeDiam, tendonDiam, tailSegments, spacing, startSpikeSize=0.5, startSpikeAngle=30);
    }
}


module body(width, length, wingspan) {
    
    height = width * 0.5;
    
    wingBoneSize = 10;

    translate([-width/2,0,0])    
        cube([width,length,height]);
    
    translate([width/2, 0, height/2])
        wing((wingspan-width)/2, length, wingBoneSize);    
    translate([-width/2, 0, height/2])
        scale([-1, 1, 1])
            wing((wingspan-width)/2, length, wingBoneSize);    
    
}

module wing(span, width, wingBoneSize) {
    cube([span,width,wingBoneSize]);
}

module spine(width, height, length, startSize, endSize, tubeDiam, tendonDiam, neckSegments, spacing, startSpikeSize=1, endSpikeSize=1, startSpikeAngle=28, endSpikeAngle=28) {
    segmentLength = length / neckSegments;
    for (segment = [1 : neckSegments]) {
        translate([0, segmentLength + (segment - 1) * (segmentLength+spacing), width/2]) {
            rotate([90, 0,0])
                neckSegment(width * mix(segment/neckSegments, startSize, endSize), 
                            height * mix(segment/neckSegments, startSize, endSize), 
                            segmentLength, 
                            tubeDiam, 
                            tendonDiam,
                            spikeSize=mix(segment/neckSegments, startSpikeSize, endSpikeSize),
                            spikeAngle=mix(segment/neckSegments, startSpikeAngle, endSpikeAngle));
        }
    }
}



module neckSegment(sizeX, sizeY, length, tubeDiam, tendonDiam, spikeSize = 1, spikeAngle = 40, bendAmount = 0.3, supportSpacing = 0.75) {
    tendonX = (sizeX/2 - tendonDiam/2) - holeMargin;    
    tendonY = (sizeY/2 - tendonDiam/2) - holeMargin;    
    sliceCount = spineProfileLen; 
    sliceH = length / sliceCount;

    
    depressionRelativePos = 0.5;
    depressionDepth = length * depressionRelativePos;
    bumpHeight = 0.5 * max(sizeX, sizeY) * bendAmount;

    connectorLength = depressionDepth*0.5;
    
    //bumpWidth = tubeDiam;// + 2 * holeMargin*2;
    //bumpLen = (width - bumpWidth) * bendAmount;    
    difference() {
        union() {
        
            // Basic body
            difference() {
                translate([0,0,connectorLength])
                    carvedSegment(sizeX, sizeY, length, spikeSize, spikeAngle = spikeAngle);

                // Depression for connecting to the previous segment
                translate([0,0,length - bumpHeight])
                    scale([sizeX, sizeY, 1])
                        cylinder(r1=0.5, r2= 0.6 + bendAmount * depressionRelativePos, h=depressionDepth+bumpHeight);       
            }
        
            // Bump to pivot previous segment on
            translate([0,0,length - bumpHeight])
                scale([sizeX, sizeY, 1])
                    cylinder(r1=0.5, r2=0, h=bumpHeight);       

            // Socket to connect to next segment
            translate([0,0,0])
                scale([sizeX, sizeY, length - bumpHeight])
                    cylinder(r=0.5, h=1);       
        }

        

        // Hole for central tube carrying electronic wires
        translate([0,0,-1])
            cylinder(r=tubeDiam/2, h=length+connectorLength + 2);       
        
        // Holes for tendons along each edge    
        cylinderCircle(tendonDiam, length+connectorLength, tendonX, angleNum=2, startAngle=0);
        cylinderCircle(tendonDiam, length+connectorLength, tendonY, angleNum=2, startAngle=90);
                
    }
}


function polarR(a, x, y) = sqrt(pow(sin(a) * y * 0.5, 2) + pow(cos(a) * x * 0.5, 2));

module carvedSegment(origX, 
                     origY, 
                     sizeZ, 
                     spikeSize = 1,
                     spikeAngle = 28,
                     padding = 1.7, 
                     bottomCarveDepth = 0.4, 
                     bumpCount = 1) {

    extraSideCarveAngle = 15;
    carveAreaAngle = 180.0+extraSideCarveAngle*2;
                     
    carvePadding = padding * 5;
    carveDepth = 1.0 - 1.0 / carvePadding;
    

    maxSizeX = origX * padding;
    maxSizeY = origY * padding;
    
    cutSharpness = 5;
    cutLength = 7;
    cutOffset = -6;

    spikeRootSize = 0.4;

    
    bottomCutAspect = 0.9;
    bottomCutRadius = 1;
    bottomCutDist = sizeZ * 1.545;

    scale([origX, origY, sizeZ]) {
        // Back scales
        translate([0,0,0.0])
            dragonScaleSection(radius=0.75, scaleSize = 0.5, scalePointiness=1, scaleThickness = 1.2, rowPeriodAmplitude = 0.2);
    }

    difference() {
        union() {       
            scale([origX, origY, sizeZ]) {
                // Add basic shape
                translate([0,0,-0.2])
                    cylinder(r1=0.5, r2=padding/2*0.65, h=0.25);
                translate([0,0,-0.1])
                    cylinder(r1=0.5, r2=padding/2*0.74, h=0.25);
                translate([0,0,1])
                    scale([1,1,1.5])
                        sphere(r=padding/2);



                // Spike
                translate([0,0.5,0.6])
                    scale([spikeSize, spikeSize, spikeSize])
                        rotate([270+spikeAngle,0,0])
                            cylinder(r1 = spikeRootSize, r2 = 0.05, h=1);
            }

        }

 //       scale([origX, origY, sizeZ]) {
/*        
            // Cut behind spike
            translate([0,0.5,1.2])
                scale([spikeSize, spikeSize, spikeSize])
                    rotate([270,0,0])
                        cylinder(r1 = spikeRootSize, r2 = 0.05, h=1);
*/
/*
            // Carve sides
            sideCarver(padding-0.35, 
                       cutRadiusFactor = 0.85, 
                       cutRootScale = 0.05,
                       cutAngle=25,
                       carveStartAngle = -extraSideCarveAngle, 
                       carvingCount=4,
                       carveAreaAngle = carveAreaAngle);

            sideCarver(padding-0.04, 
                       cutRadiusFactor = 1.20, 
                       cutAngle=24,
                       cutSharpness = 1,
                       cutRootScale=0.75, 
                       carveStartAngle = -extraSideCarveAngle, 
                       carvingCount=2,
                       carveAreaAngle = carveAreaAngle);
*/                       
  //      }
        
        // Carve bottom
        translate([0,0,bottomCutDist])
            scale([origX*bottomCutAspect, origY/bottomCutAspect, sizeZ])
                sphere(r=bottomCutRadius, $fn=50);
        translate([0,0,bottomCutDist*1.35])
            scale([origX*bottomCutAspect*1.4, origY/bottomCutAspect*1.4, sizeZ])
                rotate([0,90,0])
                    cylinder(r=1, h=2, center=true, $fn=50);
    }

}


module sideCarver(cutDistanceFactor, 
                  cutRadiusFactor = 0.9, 
                  cutAngle = 25, 
                  cutRootScale = 0.1, 
                  cutSharpness = 1.5,
                  carveStartAngle = 90,
                  carveAreaAngle = 360.0,
                  carvingCount = 8) {
                  
    carveStep = carveAreaAngle / carvingCount;
    
    for (ca = [carveStep*0.5 : carveStep : carveAreaAngle + 0.01 - carveStep*0.5]) {
        rotate([0,0,ca + carveStartAngle]) {
            translate([cutDistanceFactor, 0, 0]) {
                rotate([0, cutAngle, 0])
                    scale([cutSharpness, 1/cutSharpness, 1]) 
                        cylinder(r1=cutRootScale*cutRadiusFactor, r2=cutRadiusFactor, h=2, center=true, $fn=50);                    
            }
        }
    }
}

module cylinderCircle(diameter, length, centerDistance, angleNum=4, startAngle = 0, extend = 1) {
    angleStep = 360.0 / angleNum;
    for (ai = [0 : angleNum - 1]) {
        rotate([0,0,startAngle + angleStep * ai])
            translate([centerDistance, 0, -extend])
                cylinder(r = diameter/2, h = length + extend*2);
    }
}

module neckEnd(radius, thickness) {
    cylinder(r=radius, h=thickness);
}

module rib(radius, thickness) {
    cylinder(r=radius, h=thickness);
}

module head(headWidth, headHeight, headLength) {
    cube([headWidth, headLength, headHeight]);
}

// A box rounded along the ground plane only, with rounding equal to the size of the smallest side
module stretchedCylinder(width, depth, height, centerHeight=false) {
    heightOffset = centerHeight ? -height/2 : 0;
    if (depth > width) {
        union() {
            translate([0, -0.5*(depth-width), heightOffset])
                cylinder(r=width/2, h = height);
            translate([0,  0.5*(depth-width), heightOffset])
                cylinder(r=width/2, h = height);
            translate([0, 0, height/2 + heightOffset])
                cube([width, depth-width, height], center=true);
        }        
    }
    else if (width == depth) {
        translate([0,0, heightOffset])
            cylinder(r=width/2, h = height);
    }
    else {
        union() {
            translate([-0.5*(width-depth), 0, heightOffset])
                cylinder(r=depth/2, h = height);
            translate([ 0.5*(width-depth), 0, heightOffset])
                cylinder(r=depth/2, h = height);
            translate([0, 0, height/2 + heightOffset])
                cube([width-depth, depth, height], center=true);
        }        
    }
    
}


// Creates an arched section with rows of overlapping scales
module dragonScaleSection(radius = 0.5,  // Radius, in mm.
                          height = 1, // Height, in mm.
                          scaledArc = 180, // How large part of the full circle to cover in scales
                          arcStart = 270,  // Start angle for scaled part of circle
                          tiltStart = 35, // Tilt angle of scales at base
                          tiltEnd = 10,   // Tilt angle of scales at top
                          scaleSize = 0.5, // Base size of scales, roughly in mm.
                          scalePointiness = 1,  // 1 = normal, 2 = long and pointy, 0.5 = short and stubby
                          scaleThickness = 1, // 1 = normal, 2 = thick, 0.5 = slender
                          seed = 23142, 
                          offsetAmount=0.15, 
                          offsetPeriod = 1, 
                          rowPeriodStart = -90, 
                          rowPeriodEnd = 140, 
                          rowPeriodAmplitude=0.15) {
    
    // Determine scale dimensions
    scaleW = scaleSize;
    scaleL = scaleSize * scalePointiness; 
    scaleH = 0.3 * scaleSize * scaleThickness; 

    rowPackingDensity = 1.5;
    
    rowCount = floor((height / scaleL) * rowPackingDensity);
    rowHeight = height / rowCount;
    
    
    for (i = [0 : rowCount-1]) {
        translate([0,0,i * rowHeight])
            dragonScaleArc(radius + radius*rowPeriodAmplitude*sin(map(i, 0, rowCount-1, rowPeriodStart, rowPeriodEnd)), 
                           scaledArc, 
                           arcStart, 
                           map(i, 0, rowCount-1, tiltStart, tiltEnd), 
                           scaleW, 
                           scaleL, 
                           scaleH, 
                           i == rowCount-1, 
                           1253 + seed + i * 13, 
                           (i % 2) == 0, 
                           height * offsetAmount, 
                           offsetPeriod) ;
    }

}

// Creates an arched row of overlapping scales
module dragonScaleArc(radius = 25, scaledArc = 180, arcStart = 0, tilt = 10, scaleW = 20, scaleL = 20, scaleH = 10, carvedScale=true, seed = 23142, offsetRow = false, offsetAmount=0.2, offsetPeriod = 2) {
    // Length in millimeter of the arc that should be covered in scales
    arcLen = radius * Tau * (scaledArc/360);

    // This is a fudge factor, needs to be adjusted depending on relation between scaleW and scaleH.
    approxScaleW = scaleW * 0.5;

    // How much the scales should overlap, 1 = no overlap (if approxScaleW is tuned correctly), 1.5 = 50% overlap.
    packDensity = 1.2;

    // Calculate number of scales to place
    scaleNum = floor((arcLen / approxScaleW) * packDensity - (offsetRow ? 1 : 0));
    
    // An offset in scale placement, so that we can have the next row of scales between the previous scales.  Used if offsetRow is true.
    offsetArcAdjust = (scaledArc / (scaleNum + 1)) / 2;

    // How much to scale each scale randomly (1 = 100% differences)
    randomScalingAmount = 0.4;
    
    // How many degrees that scales can be tilted randomly
    randomTiltAmount = 7;
    
    // How much the scales can be offset forward or back (1 = scale length amount)
    randomOffsetAmount = 0.1;

    // Calculate random numbers    
    randomScaling = rands(1-randomScalingAmount/2,1+randomScalingAmount/2,scaleNum,seed);
    randomTilt = rands(-randomTiltAmount/2,randomTiltAmount/2,scaleNum,seed+1);
    randomOffset = rands(0,randomOffsetAmount,scaleNum,seed+2);
    
    // Place scales
    for (i = [0 : scaleNum-1] ) {
        // Rotate to the correct angle from center to place this scale
        rotate([0,0,map(i, 0, scaleNum-1, arcStart + (offsetRow ? offsetArcAdjust : 0), arcStart + scaledArc - (offsetRow ? offsetArcAdjust : 0))]) {
            // Offset outwards from center for the scale, and up/down
            translate([0, radius, scaleL * randomOffset[i] + sin(90+offsetPeriod * 360 * i / (scaleNum-1)) * offsetAmount])
                // Tilt scale inwards or outwards
                rotate([-tilt + randomTilt[i], 0, 0])
                    // Create the scale with some calculated size
                    dragonScale(scaleW, 
                                scaleH * randomScaling[i], 
                                scaleL * randomScaling[i], 
                                carvedScale);
        }
    }

}

module dragonScale(w = 2, h = 0.8, l = 2, carved=true, ridgeAngle=30) {
    if (carved) {
        // If the scale is carved, we make the inside concave. 
        difference() {
            // Create a sharper ridge in the middle of the scale and on the sides by intersecting two tilted scales
            intersection() {
                rotate([0,0,ridgeAngle/2])
                    scale([w, h, l])
                        scalePart();
                rotate([0,0,-ridgeAngle/2])
                    scale([w, h, l])
                        scalePart();
            }
            
            // Carve out the inside with a scale, which is slightly tilted to carve evenly from the tip as well
            translate([0, -h/2, 0])
                scale([w, h, l])
                    rotate([-20, 0,0])
                        scalePart();
        }
    }
    else {
        // If the scale is not carved, we just leave the inside round as well
        intersection() {
            // Same as the basic scale shape above
            rotate([0,0,ridgeAngle/2])
                scale([w, h, l])
                    scalePart();
            rotate([0,0,-ridgeAngle/2])
                scale([w, h, l])
                    scalePart();
        }
    }

}

// A simple basic shape used for the scale, consisting of a large sphere at the bottom and a small at the tip, connected by a cone.
module scalePart() {
    union() {
        translate([0,0,0.25])
            sphere(r=0.5);
        translate([0,0,0.5])
            cylinder(r1=0.432, r2 = 0.08, h=0.6);
        translate([0,0,0.81+0.25])
            sphere(r=0.09);
    }
}



