
// TODO add screwsupport to motorbayTar and

use<motor.scad>;

motorWidth = 12;
motorHeight = 10;
motorLenght = 24;
motorFromFront =2;



boardLenght = 28;
boardWidth = 28;
boardHeight = 15;

boardBayLenght = 30;
boardBayWidth = 35;
boardBayHeight = boardHeight;

screwHoleR = 1.75;
hexaR = 5.6/2;
hexaHeight = 3;
supportSize = screwHoleR*4;

width = 50;
lenght = 35;
bottomThickness = 5;
topTickness = 5;
motorSpacing = 10;
// motorbayHeight
height = 15;

wireHoleWidth = 12;
wireHoleLenght = 5;
wireHoleHeight = topTickness +1;




// code that shows all parts), and whit the printable arts transparent
// bottom
motorbayOverview();


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
	%screwSupportAtPlace();
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



module screwSupportAtPlace(){
	translate([lenght/2-supportSize,width/2-supportSize, bottomThickness]){
  		screwSupport();
 	}
	translate([-lenght/2,width/2-supportSize, bottomThickness]){
  		screwSupport();
 	}
	translate([lenght/2-supportSize,-width/2, bottomThickness]){
  		screwSupport();
 	}
	translate([-lenght/2,-width/2, bottomThickness]){
  		screwSupport();
 	}
}

// sopport between screws
module screwSupport(){
   difference(){
		cube([supportSize,supportSize, height-bottomThickness-topTickness]);
		translate([supportSize/2, supportSize/2, 0]){
			screwHole();
		}		
	}
}


module hexa(){
	translate([0,0, -0.2]){
  		cylinder(hexaHeight ,hexaR ,hexaR , $fn = 6);
	}
}

module screwHole(){
	translate([0,0, -1]){
		cylinder(height+2 ,screwHoleR ,screwHoleR , $fn = 40);
	}
}



module motorPlace(){
	// motorplaces at the end of bottom plane while bottomplan is centered
	translate([((lenght/2)-motorLenght-motorFromFront),
				motorWidth/2+ motorSpacing/2,
				(height/2)]){
		motor();
		
	}
	translate([((lenght/2)-motorLenght-motorFromFront),
				-motorWidth/2- motorSpacing/2,
				(height/2)]){
		motor();
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

