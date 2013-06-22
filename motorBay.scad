
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

// lengts of the bay for the board
boardBayLenght = 30;
boardBayWidth = 35;
boardBayHeight = boardHeight;

// screw and support measurments
screwHoleR = 1.75;
hexaR = 5.6/2;
hexaHeight = 3;
supportSize = screwHoleR*4;
supportInTop = 1;
extraSizeinSupportHole = 1;


// motorbay measurments
width = 47;
lenght = 36;
bottomThickness = 5;
topTickness = 5;
motorSpacing = 5;
// motorbayHeight
height = 15;

wireHoleWidth = 12;
wireHoleLenght = 3;
wireHoleHeight = topTickness +1;
motorWireSpaceLenght = 4;




// code that shows all parts), and whit the printable arts transparent
// bottom
//motorbayOverview();


// modules whit only the printed parts AT RIGHT PLACE
//topMotorBay();
//bottomMotorBay();


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
	translate([lenght/2-2*screwHoleR,width/2-2*screwHoleR, 0]){
		screwHole();
		hexa();
	}
	translate([-(lenght/2-2*screwHoleR),width/2-2*screwHoleR, 0]){
		screwHole();
		hexa();
	}
	translate([lenght/2-2*screwHoleR,-(width/2-2*screwHoleR), 0]){
		screwHole();
		hexa();
	}
	translate([-(lenght/2-2*screwHoleR),-(width/2-2*screwHoleR), 0]){
		screwHole();
		hexa();
	}
}



module screwSupportAtPlace(extraSize = 0){
	translate([lenght/2-supportSize-extraSize/2 ,
					width/2-supportSize-extraSize/2, 
					bottomThickness]){
  		screwSupport(extraSize);
 	}
	translate([-lenght/2-extraSize/2,width/2-supportSize-extraSize/2, 
					bottomThickness]){
  		screwSupport(extraSize);
 	}
	translate([lenght/2-supportSize-extraSize/2,-width/2-extraSize/2, 
					bottomThickness]){
  		screwSupport(extraSize);
 	}
	translate([-lenght/2-extraSize/2, -width/2-extraSize/2, bottomThickness]){
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
 	translate([((lenght/2)-motorLenght-wireHoleLenght-motorFromFront),
				motorWidth/2+ motorSpacing/2-motorWidth/2,
				height-topTickness ]){
		cube([wireHoleLenght,wireHoleWidth,wireHoleHeight ]);
	}
	translate([((lenght/2)-motorLenght-wireHoleLenght-motorFromFront),
				-motorWidth/2- motorSpacing/2-motorWidth/2,
				height-topTickness ]){
		cube([wireHoleLenght,wireHoleWidth,wireHoleHeight ]);
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

