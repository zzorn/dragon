
// TODO add screwsupport to motorbayTar and

include<motor.scad>;

motorWidth = N20MotorWidth ;
motorHeight = N20MotorHeight;
motorLenght = N20MotorPartLenght+ N20GearPartLenght;
motorFromFront =2;


// measurments of the motorboard
boardLenght = 28;
boardWidth = 28;
boardHeight = 15;



// screw and support measurments
screwHoleR = 1.75;
hexaR = 5.6/2;
hexaHeight = 3;
supportSize = screwHoleR*4;
supportInTop = 1;
extraSizeinSupportHole = 1;
screwFromS = 2*screwHoleR;

// lengts of the bay for the board
boardBayLenght = 30;
boardBayWidth = 35;
boardBayHeight = boardHeight;
boardBayScrewSpacing = 19;


// motorbay measurments
width = 47;
lenght = 38;
bottomThickness = 5;
topTickness = 5;
motorSpacing = 5;
// motorbayHeight
height = 15;

wireHoleWidth = 13;
wireHoleLenght = 13;
wireHoleHeight = topTickness +1;
wireSpringWidth = 2;
motorWireSpaceLenght = 4;




// code that shows all parts), and whit the printable arts transparent
// bottom
//motorbayOverview();


// modules whit only the printed parts AT RIGHT PLACE
topMotorBay();
bottomMotorBay();


// printable code
//motorbayTray();


module motorbayOverview(){
	translate([-lenght/2, -width/2, 0]){
		%cube([lenght, width, bottomThickness]);
	}
	// top
	translate([-lenght/2, -width/2, height-topTickness]){
		%cube([lenght, width, topTickness]);
	}
	motorPlace();
	screwHoles();
	%screwSupportAtPlace(0);
}


module motorbayTray(){
	translate([width/2,0, height])rotate([180,0,0]){
		topMotorBay();
	}
	translate([-width/2,0,0]){
		bottomMotorBay();
	}
}



module topMotorBay(){
	difference(){
		translate([-lenght/2, -width/2, height-topTickness]){
			cube([lenght, width, topTickness]);
		}
      motorPlace();
      screwHoles();	
	screwSupportAtPlace(extraSizeinSupportHole);	
	
	}

}

module bottomMotorBay(){
	difference(){
		translate([-lenght/2, -width/2, 0]){
			cube([lenght, width, bottomThickness]);
		}
      motorPlace();
      screwHoles();		
	}
   screwSupportAtPlace();
}





// screwholes for motorbay
module screwHoles(){
	translate([lenght/2-screwFromS ,width/2-screwFromS , 0]){
		screwHole();
		hexa();
	}
	translate([lenght/2-screwFromS ,-(width/2-screwFromS ), 0]){
		screwHole();
		hexa();
	}
      boardplaceScrevs();

}



module screwSupportAtPlace(extraSize = 0){
	translate([lenght/2-supportSize-extraSize/2 ,
					width/2-supportSize-extraSize/2, 
					bottomThickness]){
  		screwSupport(extraSize);
 	}
	translate([-lenght/2-extraSize/2, (+boardBayScrewSpacing - supportSize -extraSize)/2, 
					bottomThickness]){
  		screwSupport(extraSize);
 	}
	translate([lenght/2-supportSize-extraSize/2,-width/2-extraSize/2, 
					bottomThickness]){
  		screwSupport(extraSize);
 	}
	translate([-lenght/2-extraSize/2, (-boardBayScrewSpacing - supportSize -extraSize)/2,
 bottomThickness]){
  		screwSupport(extraSize);
 	}
}

// sopport between screws
module screwSupport(extraSize = 0){
   difference(){
		cube([supportSize+extraSize,supportSize+extraSize,
				 height-bottomThickness-topTickness+supportInTop]);
		translate([(supportSize+extraSize)/2, (supportSize+extraSize)/2, 0]){
			screwHole(extraSize/2);
		}		
	}
}


module hexa(){
	wallRemover = 0.05;
	translate([0,0, -wallRemover]){
  		cylinder(hexaHeight ,hexaR ,hexaR , $fn = 6);
		// pyramid ontop of hexa
		translate([0,0, hexaHeight-2*wallRemover]){
			cylinder(hexaHeight ,hexaR ,0 , $fn = 6);
		}
	}
}

module screwHole(smallerHole = 0){
	translate([0,0, -1]){
		cylinder(height+2 ,screwHoleR-smallerHole  ,screwHoleR-smallerHole  , $fn = 40);
	}
}



module motorPlace(){
	// motorplaces at the end of bottom plane while bottomplan is centered
	translate([((lenght/2)-motorLenght-motorFromFront),
				motorWidth/2+ motorSpacing/2,
				(height/2)]){
		motor(wireSpaceLenght = motorWireSpaceLenght);
		
	}
	translate([((lenght/2)-motorLenght-motorFromFront),
				-motorWidth/2- motorSpacing/2,
				(height/2)]){
		motor(wireSpaceLenght = motorWireSpaceLenght);
	}
      // wireholes
 	translate([((lenght/2)-motorLenght-wireHoleLenght-motorFromFront),
				- wireHoleWidth/2,
				height-topTickness-0.5 ]){
		cube([wireHoleLenght,wireHoleWidth,wireHoleHeight ]);
	}
	translate([((lenght/2)-motorLenght-wireSpringWidth-motorFromFront),
				- (2*motorWidth + motorSpacing)/2,
				height-topTickness-0.5 ]){
		cube([wireSpringWidth, 2*motorWidth + motorSpacing,wireHoleHeight ]);
	}
	

}

//screwholes for board
module boardplaceScrevs(){
	translate([-lenght/2+screwFromS , boardBayScrewSpacing /2, 0]){
		screwHole(smallerHole = 0);
		hexa();
	}
	translate([-lenght/2+screwFromS , -boardBayScrewSpacing /2, 0]){
		screwHole(smallerHole = 0);
		hexa();
	}
}


// boardplace
//translate([-lenght/2, -boardWidth/2, height]){
//   board();  
//}
//translate([-lenght/2, -boardBayWidth/2, height]){
//   %cube([boardBayLenght, boardBayWidth, boardBayHeight]);     
//}

module board(){
	cube([boardLenght, boardWidth, boardHeight]);
}

