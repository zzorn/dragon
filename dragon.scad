
holeMargin = 1;


dragon();

module dragon(width = 50, length = 300, wingspan = 300, tubeDiam = 8, tendonDiam = 3) {
    
    spacing = 10;
    
    
    // Body
    bodyLength = length * 0.3;        
    translate([-width/2,0,0]) {
        body(width, bodyLength);
    } 

    // Neck
    neckWidth = width * 0.5;
    neckLength = length * 0.4;
    neckSegments = 4;
    translate([0, bodyLength + spacing, 0]) {
        neck(neckWidth, neckLength, tubeDiam, tendonDiam, neckSegments, spacing);
    }

    // Head
    headWidth = width * 0.5;
    headLength = length * 0.15;
    translate([-headWidth/2, bodyLength + spacing + neckLength + spacing*neckSegments, 0]) {
        head(headWidth, headLength);
    }
}



module body(width, length) {
    
    height = width * 0.5;

    cube([width,length,height]);
    
    
}

module neck(width, length, tubeDiam, tendonDiam, neckSegments, spacing) {
    segmentLength = length / neckSegments;
    for (segment = [1 : neckSegments]) {
        translate([0, (segment - 1) * (segmentLength+spacing), width/2]) {
            rotate([270, 0,0])
                neckSegment(width, segmentLength, tubeDiam, tendonDiam);
        }
    }
}

module neckSegment(width, length, tubeDiam, tendonDiam, bendAmount = 0.25) {
    ribSpacing = width * 0.75;
    ribCount = max(1, floor(length / ribSpacing));
    height = width * 0.8;   
    radius = width / 2;
    //endL = length * 0.1;
    tr = (radius - tendonDiam/2) - holeMargin;    
    ribThickness = width * 0.1;
    ribIntervall = (length-ribThickness*2) / ribCount;
    ribHoleSize = 0.5;
    bumpWidth = tubeDiam + 2 * holeMargin;
    bumpLen = (width - bumpWidth) * bendAmount;    

    difference() {
        union() {
            /*
            // Ribs
            for (ribZ = [0 : ((length - ribThickness) / ribCount) : (length - ribThickness+1)])
                translate([0,0,ribZ])
                    rib(radius, ribThickness);
                    
            // Columns
            for (pos = [[-tr,   0, 0], 
                        [ tr,   0, 0], 
                        [  0, -tr, 0], 
                        [  0,  tr, 0]]) {
                translate(pos)
                    cylinder(r=tendonDiam/2 + holeMargin, h=length);       
            }
            */
            
            // Solid body
            cylinder(r=width/2, h=length);                   
            
            // Bump
            translate([0,0,length])
                cylinder(r=bumpWidth/2, h=bumpLen);       
        }

        // Hole for central tube carrying electronic wires
        translate([0,0,-1])
            cylinder(r=tubeDiam/2, h=length + bumpLen + 2);       
        
        // Holes for tendons along each edge    
        for (pos = [[-tr,   0, -1], 
                    [ tr,   0, -1], 
                    [  0, -tr, -1], 
                    [  0,  tr, -1]])
            translate(pos)
                cylinder(r=tendonDiam/2, h=length+2);       
                
        // Remove some excess material
        for (ribZ = [ribThickness+ribIntervall/2 : ribIntervall : length - ribThickness - ribIntervall/2 + 0.1], zAngle=[45, 45+90])
            translate([0,0,ribZ]) {
                rotate([0,270,zAngle])
                    stretchedCylinder(ribIntervall - ribThickness, width * ribHoleSize, width*2, true); 
            }

                
    }
}

module neckEnd(radius, thickness) {
    cylinder(r=radius, h=thickness);
}

module rib(radius, thickness) {
    cylinder(r=radius, h=thickness);
}



module head(headWidth, headLength) {
    headHeight = headWidth * 0.5;
    cube([headWidth,headLength,headHeight]);
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



