
include<motorBay.scad>;


rotate([90])translate([5,10, 30]){
		cylinder(10, 3, 3);
	}

// esimerkki langaspidikkeistä
difference(){
	translate([10, -35,5]){
		cube([8,8,8]);
	}
	rotate([0,90,0])translate([-9,-34, 9]){
		cylinder(10, 3, 3);
	}
}


// kiinnitetäään motorbay poikittain vähän irti levystä/palasta johon kaula/niskapalat tulee kiinni
translate([-10,0, 0]){
	motorbayOverview();
}


// pala joka sopii niihin siipi/häntäpaloihin eli toinen puoli on yhteensopiva niihin tämä osa ei kuitenkan lliiku vaan on paikallaan koiinni ruumiissa
//palassa on langoille reiät

difference(){
	translate([0,0, 25]){
		cylinder(10, r = 35);
	}
   translate([35,0, 20]){
		cylinder(20, 3, 3);
	}
	translate([-35,0, 20]){
		cylinder(20, 3, 3);
	}
	translate([0,35, 20]){
		cylinder(20, 3, 3);
	}
	translate([0,-35, 20]){
		cylinder(20, 3, 3);
	}
}
