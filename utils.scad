
Tau = 6.28318530717958647692;

BoltLengths = [[0, 12], [12, 12], 
               [12.0001, 16], [16, 16], 
               [16.0001, 20], [20, 20], 
               [20.0001, 25], [25, 25], 
               [25.0001, 30], [30, 30], 
               [30.0001, 35], [35, 35], 
               [35.0001, 40], [40, 40], 
               [40.0001, 45], [45, 45], 
               [45.0001, 50], [50, 50], 
               [50.0001, 55], [55, 55], 
               [55.0001, 60], [60, 60], 
               [60.0001, 70], [70, 70], 
               [70.0001, 80], [80, 80], 
               [80.0001, 100], [100, 100]
               ];
MaxBoltLen = 100;

// Metric bolt / nut data.  Contains thread diameter, nut outer diameter.
M_ThreadDiameter = 0;
M_NutDiameter = 1;
M_NutHeight = 2;
M_NutHeightNyloc = 3;
M3 = [3, 6.4, 2.4, 4];
M4 = [4, 8.1, 3.2, 5];
M5 = [5, 9.2, 4, 5];
M6 = [6, 11.5, 5, 6];
M8 = [8, 15, 6.5, 8];
M10 = [10, 19.6, 8, 10];
M12 = [12, 22.1, 10, 12];



function clamp(value, minValue, maxValue) = max(minValue, min(maxValue, value));
function mix(pos, start, end) = start + pos * (end -start);
function map(pos, srcStart, srcEnd, start, end) = start + ((pos-srcStart) / (srcEnd-srcStart)) * (end - start);

function smoothmix(pos, start, end) = start + (0.5-cos(pos*360/2) * 0.5 ) * (end - start);
function smoothmap(pos, srcStart, srcEnd, start, end) = start + smoothmix( (pos-srcStart) / (srcEnd - srcStart), 0, 1) * (end - start);

function vectorLength(vec) = sqrt(vec[0] * vec[0] + vec[1] * vec[1] + vec[2] * vec[2]) + 0.000001; // Add epsilon to avoid div by zeroes, as they are hard to check for in openscad.
function vectorNormal(vec) = vec / vectorLength(vec);

module horn(length = 50, angle = 45, r1 = 15, r2 = 5, aspect1 = 1, aspect2 = 1, ballStart = true, ballEnd = true, smoothness = 30, maxSegments = 30) {
    a = angle * 0.5;
    minSegments = 4;
    segments = clamp(length * 1, minSegments, maxSegments);
    segLen = 1.0*length / segments;
    segRot = a / segments;
    segLen = (length / segments) * map(a, 0, 90, 1.75, 2.5);

    for ( i = [0 : segments] ) {
        rotate([map(i, 0, segments, 0, a),0,0])
            translate([0,0,map(i, 0, segments, 0, length)])
                rotate([map(i, 0, segments, 0, a*map(a, 0, 90, 1, 0.65)),0,0])
                    scale([smoothmap(i, 0, segments, aspect1, aspect2), 1, 1])
                        cylinder(h = segLen, r1 = map(i, 0, segments+1, r1, r2), r2 = map(i + 2, 0, segments+1, r1, r2), $fn=smoothness);
    }

    if (ballStart) {
        scale([aspect1, 1, 1])
            sphere(r=r1, $fn=smoothness);
        
    }

    if (ballEnd) {
        rotate([a,0,0])
            translate([0,0,length])
                rotate([a*map(a, 0, 90, 1, 0.65),0,0])
                    scale([aspect2, 1, 1])
                        translate([0, 0, segLen])
                            sphere(r=map(segments + 2, 0, segments+1, r1, r2), $fn=smoothness);
        
    }
}

module doubleHorn(l1 = 50, l2 = 30, a1 = 30, a2 = 20, r1 = 5, r2 = 15, r3 = 10, aspect1 = 1, aspect2 = 1, aspect3 = 1, ballStart = true, ballEnd = true, smoothness = 30, , maxSegments = 30) {
    horn(l1, a1, r2, r1, aspect2, aspect1, true, ballStart, smoothness, maxSegments);
    rotate([0, 180, 0])
        horn(l2, a2, r2, r3, aspect2, aspect3, false, ballEnd, smoothness, maxSegments);
}

module cutPlane(size = 500) {
    translate([-size/2, -size/2, -size/2])
        cube([size, size, size/2]);
}

module roundedAngle(a = 90, r = 10, l = 40, h = 5, rot = 0, extraThickness = 0) {
    rotate([0,0,rot]) {
        cylinder(h, r = r, $fn=40);
        rotate([0,0,a/2]) {
            translate([-r + h/2, 0, 0]) {
                cube([r + extraThickness, l, h]);
                translate([0, 0, h/2])
                    rotate([-90,0,0])
                        cylinder(h=l, r = h/2, $fn=40);
            }
        }            
        rotate([0,0,-a/2]) {
            translate([-extraThickness - h/2, 0, 0]) {
                cube([r + extraThickness, l, h]);
                translate([r + extraThickness, 0, h/2])
                    rotate([-90,0,0])
                        cylinder(h=l, r = h/2, $fn=40);
            }
        }
    }
}


module splitAlongZ0(xOffset = 30, yOffset = 30, cutSize = 500, justSplit = false) {

    difference() {
        translate([-xOffset/2, -yOffset/2, 0])
            child(0);
        cutPlane(cutSize);
    }    

    if (!justSplit) {
        difference() {
            translate([xOffset/2, yOffset/2, 0])
                rotate([0, 180, 0])
                    child(0);
            cutPlane(cutSize);
        }       
    }
}

module splitAlongZ(splitHeight = 30, xOffset = 30, yOffset = 30, cutSize = 500, justSplit = false) {

    difference() {
        translate([-xOffset/2, -yOffset/2, -splitHeight])
            child(0);
        cutPlane(cutSize);
    }    

    if (!justSplit) {
        difference() {
            translate([xOffset/2, yOffset/2, 0])
                child(0);
            translate([0, 0, splitHeight])
                rotate([0, 180, 0])
                    cutPlane(cutSize);
        }       
    }
}


// Fastening knob holes - use pieces of filament to fasten
module knob(knobH = 8, knobD = 3, x = 0, y = 0, glap = 0.6) {
    translate([x, y, 0]) {
        translate([0,0,-knobH/2]) {
            cylinder(h = knobH+glap/2, r = knobD/2+glap/4, $fn=20);
        }
    }
}

module knobs(coordinates, knobH = 8, knobD = 3, xOffs = 0, yOffs = 0, glap = 0.6) {
    translate([xOffs, yOffs, 0]) {
        for (i = [0 : len(coordinates) - 1]) {
            translate(coordinates[i]) {
                knob(knobH, knobD, glap);
            }
        }
    }
}


module cylinderTorus(h, outerR, innerR, center = false, smoothness = 30) {
    difference() {
        cylinder(h = h, r = outerR, center = center, $fn=smoothness);
        translate([0,0,-1])
            cylinder(h = h+2, r = innerR, center = center, $fn=smoothness);
    }
}

// Draws a line from start to start + offset.
module lineRel(start, offset, startDiam = 5, endDiam = 5, aspect = 1, roundedStart = true, roundedEnd = true, smoothness = 30) {
    line(start, start + offset, startDiam, endDiam, aspect, roundedStart, roundedEnd, smoothness);
}

module multiLine(coordinates, startDiam = 5, endDiam = 5, aspect = 1, roundedStart = true, roundedEnd = true, smoothness = 30, dia = -1) {

    sDia = dia >= 0 ? dia : startDiam;
    eDia = dia >= 0 ? dia : endDiam;

    numCoords = len(coordinates);

    for (i = [0 : numCoords - 2]) {
        if (i == 0 && !roundedStart) {
            line(coordinates[i], coordinates[i + 1], map(i, 0, numCoords-1, sDia, eDia), map(i + 1, 0, numCoords-1, sDia, eDia), aspect, false, false, smoothness);
        }
        else {
            if (i == numCoords - 2 && roundedEnd) {
                line(coordinates[i], coordinates[i + 1], map(i, 0, numCoords-1, sDia, eDia), map(i + 1, 0, numCoords-1, sDia, eDia), aspect, true, true, smoothness);
            }
            else {
                line(coordinates[i], coordinates[i + 1], map(i, 0, numCoords-1, sDia, eDia), map(i + 1, 0, numCoords-1, sDia, eDia), aspect, true, false, smoothness);
            }
        }
    }

}

module wirePath(coordinates, startDiam = 2, endDiam = 2, aspect = 2, knobH = 6, knobDiam = 3, smoothness = 25, debugView = false) {
    // Wire channel
    multiLine(coordinates, startDiam, endDiam, aspect, true, true, smoothness);
    if (debugView)
        %#multiLine(coordinates, startDiam, endDiam, aspect, true, true, smoothness);

    // Knobs that wire slides around
    for (i = [1 : len(coordinates) - 2]) {
        translate(coordinates[i]) {
            // Move knob partially out of the path
            translate(vectorNormal(vectorNormal(coordinates[i-1] - coordinates[i]) + vectorNormal(coordinates[i+1] - coordinates[i])) * (0.45 * map(i, 0, len(coordinates), startDiam, endDiam) + 0.3*knobDiam )) {
                knob(knobH, knobD, glap);
                if (debugView)
                    %knob(knobH, knobD, glap);
            }
        }
    }
}


// Draws a line from start to end.
module line(start, end, startDiam = 5, endDiam = 5, aspect = 1, roundedStart = true, roundedEnd = true, smoothness = 30) {

    x = end[0] - start[0];
    y = end[1] - start[1];
    z = end[2] - start[2];
    
    len = sqrt(x*x + y*y + z*z);

    yRot = acos(z / (len + 0.000001)); // Add small value to avoid crash if length is zero
    zRot = atan2(y, x);

    if (len <= 0) {
        // In case we have zero length line, only render end blob if activated
        if (roundedEnd || roundedStart) {
            scale([1,1,aspect]) {
                sphere(r=max(startDiam/2,endDiam/2), $fn = smoothness);
            }
        }
    }    
    else {
        translate(start) {
            rotate([0, 0, zRot])
                rotate([0, yRot, 0]) {
                    // Aspect ratio scaling
                    scale([aspect,1,1]) { 
                        // Rounded start
                        if (roundedStart) {
                            sphere(r=startDiam/2, $fn = smoothness);
                        }
                        
                        // Line
                        cylinder(h=len, r1=startDiam/2, r2 = endDiam/2, $fn = smoothness);
                        
                        // Rounded end
                        if (roundedEnd) {
                            translate([0, 0, len])
                                sphere(r=endDiam/2, $fn = smoothness);
                        }
                    }                
                }
        }
    }


}


// Center of a hinge
module hingeCenter(len = 40, holeD = 4, casingD = 10, lipSize = 10, holeSpacing = 0.5, angle = 0) {
    rotate([90, angle, 0]) {
        difference() {
            union() {
                translate([-casingD/2 - lipSize, casingD/2, -len/2])
                    rotate([90,0,0])
                        cube([casingD/2 + lipSize, len, casingD]);
                cylinder(r = casingD/2, h = len, center = true, $fn=30);
                translate([-casingD/2-lipSize, 0, 0])
                    rotate([-90, 0, 0]) {
                        child(0);
                    }
            }
            cylinder(r = holeD/2 + holeSpacing, h = len + 2, center = true, $fn=30);
        }
    }
}

// Side supports for a hinge
module hingeSupport(len = 40, holeD = 4, casingD = 10, casingThickness = 10, casingXLeft = 0, casingZUp = 0, casingXRight = 10, casingZDown = 0, spacing = 1, holeSpacing = 0.5) {
    cubeOffsetX = -casingD/2 - casingXLeft;
    cubeOffsetZ = -casingD/2 - casingZDown;
    cubeSizeX = casingD + casingXLeft + casingXRight;
    cubeSizeZ = casingD + casingZUp + casingZDown;

    for (yPos = [-len/2 - spacing - casingThickness/2, len/2 + spacing + casingThickness/2]) {
        translate([0,yPos,0]) {
            difference() {                
                translate([cubeOffsetX, -casingThickness/2, cubeOffsetZ])
                    // TODO: Use rounded corners cube
                    cube([cubeSizeX, casingThickness, cubeSizeZ]);
                rotate([90, 0, 0])
                    cylinder(r = holeD/2 + holeSpacing, h = casingThickness + 2, center = true, $fn=30);
            }
        }      
    }
}


module pulley(pulleyDiam = 10, pulleyW = 10, pulleyWallH = 10, pulleyWallW = 2, pulleySlopeW = 3, axleDiam = 1.5, axleFlatDepth = 0, wireHoleDiam = 1.5, glap = 0.1, smoothness = 40, wireHolesInSides = true) {
    innerR = pulleyDiam/2;
    outerR = innerR + pulleyWallH;
    totalW = 2*pulleyWallH + 2*pulleySlopeW + pulleyW;
    
    axleR = axleDiam / 2 + glap;

    difference() {
        // Pulley body
        union() {
            translate([0,0,0])                                      
                cylinder(h = pulleyWallW, r = outerR, $fn = smoothness);
            translate([0,0,pulleyWallW])
                cylinder(h = pulleySlopeW, r1 = outerR, r2 = innerR, $fn = smoothness);
            translate([0,0,pulleyWallW + pulleySlopeW])
                cylinder(h = pulleyW, r = innerR, $fn = smoothness);
            translate([0,0,pulleyWallW + pulleySlopeW + pulleyW])
                cylinder(h = pulleySlopeW, r1 = innerR, r2 = outerR, $fn = smoothness);
            translate([0,0,pulleyWallW + pulleySlopeW + pulleyW + pulleySlopeW])
                cylinder(h = pulleyWallW, r = outerR, $fn = smoothness);
        }
        
        // Axle hole
        translate([0,0,-1]) {  
            intersection() {
                cylinder(h = totalW + 2, r = axleDiam / 2 + glap, $fn = smoothness);
                translate([-axleFlatDepth + glap/2, 0, totalW/2 + 1])
                    cube([axleR*2, axleR*2, totalW+2], center = true);
            }
        }
            
        // Hole for attaching wire
        if (wireHoleDiam > 0) {
            if (wireHolesInSides) {
                for (a = [-30, 30])
                    rotate([0,0,a])
                        translate([innerR + wireHoleDiam/2, 0, totalW/2 - 1]) {
                            cylinder(h = totalW + 2, r = wireHoleDiam/2, $fn = smoothness, center=true);
                        }
            }
            else {
                translate([axleDiam/2 + wireHoleDiam/2 + pulleyDiam/6,0,pulleyWallW + pulleySlopeW + wireHoleDiam/2])  
                    rotate([90,0,0])
                        cylinder(h = outerR + 2, r = wireHoleDiam/2, $fn = smoothness, center=true);
            }
        }
    }
}

module bomHederPrint(projectName) {
    echo (str("Bill of materials for ", projectName));
    echo ("Assembly Name; Part Type; Part Specs; Part Count");
}

module bomPrint(assemblyName, partName, partSpecs, count) {
    echo (str(assemblyName, "; ", partName, "; ", partSpecs, "; ", count));
}

module bolt(mSize = M4, len = 10, boltLen = -1, nut = true, nutDepth = 0, gap = 0.2, centerEnd = false, preview = true, smoothness = 30, assemblyName ="", nylocNut = true) {

    epsilon = 0.01;
    
    threadedRodExtraMargin = 5;

    dia = mSize[M_ThreadDiameter];
    nutHeight = mSize[nylocNut ? M_NutHeightNyloc : M_NutHeight];
    nutDia    = mSize[M_NutDiameter];

    // Look up next larger bolt length if none specified
    finalBoltLen = boltLen == -1 ? (len >= MaxBoltLen ? len : lookup(len, BoltLengths)) : boltLen; 
    useThreadedRod = len > MaxBoltLen && boltLen == -1;
    
    zOffset = centerEnd ? 0 : -len;    
    
    // Print selected bolt size
    if (!useThreadedRod) {
        bomPrint(assemblyName, "bolt", str("M", dia, " ", finalBoltLen, " mm"), 1);
        bomPrint(assemblyName, "nut", str("M", dia), 1);
    }
    else {
        // Implement long bolts as a piece of threaded rod with nuts
        bomPrint(assemblyName, "threaded rod", str("M", dia, " ", finalBoltLen + nutHeight + threadedRodExtraMargin, " mm"), 1);
        bomPrint(assemblyName, "nut", str("M", dia), 2);
    }

    // Bolt hole
    translate([0,0,zOffset])
        cylinder(r = dia/2 + gap, h = len + epsilon, $fn = smoothness);

    // Nut hole
    translate([0,0,-nutDepth-epsilon+zOffset])
        cylinder(r = nutDia/2 + gap, h = nutHeight + nutDepth + epsilon*2, $fn = 6);

    // Sloping roof for nut hole
    translate([0,0,nutHeight-epsilon+zOffset])
        cylinder(r1 = nutDia/2 + gap, r2 = dia/2, h = gap, $fn = 6);
        

    // Preview of nut
    %union() {
        if (preview) {            
            // Bolt head
            translate([0,0,len+zOffset+epsilon])
                if (useThreadedRod) {
                    cylinder(r = nutDia/2, h = nutHeight, $fn = 6);
                }
                else {
                    cylinder(r = 2*dia / 2, h = 0.8 * dia, $fn = smoothness);
                }

            // Bolt
            translate([0,0,-(finalBoltLen-len)+zOffset + (useThreadedRod ? - threadedRodExtraMargin/2: 0)])
                cylinder(r = dia/2, h = finalBoltLen + epsilon*2 + (useThreadedRod ? threadedRodExtraMargin + nutHeight : 0), $fn = smoothness);
            
            // Nut
            translate([0,0,zOffset])
                cylinder(r = nutDia/2, h = nutHeight, $fn = 6);
        }
    }  
}


function timeOscilate(speed = 1, offset = 0) = 0.5 + 0.5 * cos($t*360 * speed +90 + 180 * offset);


*for (l = [0 : 2 : 120])
    translate([l*5, 0,0]) bolt(4, l);

// Test area

//line([-20, -20, -30], [30, 20, 20], startDiam = 20, endDiam = 50, aspect=0.5, roundedEnd=false);
//roundedAngle();
// horn();
//doubleHorn();



