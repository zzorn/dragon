#include <CapacitiveSensor.h>



CapacitiveSensor  cs_7_13 = CapacitiveSensor(7,13);        
CapacitiveSensor  cs_7_9 = CapacitiveSensor(7,9);        
CapacitiveSensor  cs_7_8 = CapacitiveSensor(7,8); 
CapacitiveSensor  cs_7_6 = CapacitiveSensor(7,6);        
CapacitiveSensor  cs_7_5 = CapacitiveSensor(7,5); 
const int vib1  = 3; 



void setup()                    
{
   pinMode(vib1, OUTPUT); 
   Serial.begin(9600);

}

void loop()                    
{
    long start = millis();
    long nose =  cs_7_13.capacitiveSensor(30);
    long head =  cs_7_9.capacitiveSensor(30);
    long back =  cs_7_8.capacitiveSensor(30);
    long left =  cs_7_6.capacitiveSensor(30);
    long right =  cs_7_5.capacitiveSensor(30);
    // if nothing happes counder grows... bored at 60000;
    int booring = 0;
    // minutes until bored
    int minutes = 15;
    // if cap value going over this, it sences
    int sensing = 60;


  /* // old code if serial monitor
    Serial.print(millis() - start);        // check on performance in milliseconds
    Serial.print("\t");                    // tab character for debug windown spacing
    Serial.print(total1);                  // print sensor output 1
    Serial.print("\t");
    Serial.println(total2);                  // print sensor output 2
    Serial.print("\t");
    Serial.println(total3);       // print sensor output 3
    */
    if (head >= sensing) {        
       digitalWrite(vib1,  HIGH);
       delay(5000);
       booring = 0;
       digitalWrite(vib1,  LOW); 
    }  
    if (left >= sensing) {        
       digitalWrite(vib1,  HIGH);
       delay(5000);
       booring = 0;
       digitalWrite(vib1,  LOW); 
    }  
    if (right >= sensing) {        
       digitalWrite(vib1,  HIGH);
       delay(5000);
       booring = 0;
       digitalWrite(vib1,  LOW); 
    } 
    else if (booring >60000){
       for (int i = 0; i > 5; i++){
         digitalWrite(vib1,  HIGH);
         delay(1000);
         digitalWrite(vib1, LOW);
         delay(1000);
       }  
    }  
    else {
        booring ++;
    }  
    delay (minutes);
        
        // arbitrary delay to limit data to serial port 
}

