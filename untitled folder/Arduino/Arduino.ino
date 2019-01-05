#define USE_ARDUINO_INTERRUPTS true    // Set-up low-level interrupts for most acurate BPM math.
#include <PulseSensorPlayground.h> 
#include <LiquidCrystal.h>
#include <SoftwareSerial.h>
SoftwareSerial ArduinoSerial(3,2);//RX TX

// Includes the PulseSensorPlayground Library.   

//  Variables
const int PulseWire = A0;       // PulseSensor PURPLE WIRE connected to ANALOG PIN 0
const int LED13 = 13; 
const int  buzzer = 4;         // The on-board Arduino LED, close to PIN 13.
int Threshold = 550;           // Determine which Signal to "count as a beat" and which to ignore.
                               // Use the "Gettting Started Project" to fine-tune Threshold Value beyond default setting.
                               // Otherwise leave the default "550" value. 
unsigned int sub_beats,myBPM2;
LiquidCrystal lcd(8,9,10,11,12,13);                               
PulseSensorPlayground pulseSensor;  // Creates an instance of the PulseSensorPlayground object called "pulseSensor"


void setup() {   

  Serial.begin(9600);          // For Serial Monitor
  lcd.begin(20, 4);
  ArduinoSerial.begin(4800);
  // Configure the PulseSensor object, by assigning our variables to it. 
  pulseSensor.analogInput(PulseWire);   
  pulseSensor.blinkOnPulse(LED13);       //auto-magically blink Arduino's LED with heartbeat.
  pulseSensor.setThreshold(Threshold);   

  // Double-check the "pulseSensor" object was created and "began" seeing a signal. 
}



void loop() {
pulseSensor.begin();
 unsigned int myBPM = pulseSensor.getBeatsPerMinute();  // Calls function on our pulseSensor object that returns BPM as an "int".
                                               // "myBPM" hold this BPM value now. 

 Serial.print(" BPM1: ");
 Serial.print(myBPM);

if (pulseSensor.sawStartOfBeat()) {            // Constantly test to see if "a beat happened".         // If test is "true", print a message "a heartbeat happened".
check(myBPM);
}
else
{
    Serial.println("We created a pulseSensor Object !");  //This prints one time at Arduino power-up,  or on Arduino reset.  
    lcd.clear();
    lcd.print("put ur finger ");
    delay(500);
}
delay(20);                    // considered best practice in a simple sketch.
if (myBPM >120 || myBPM<160)
  noTone(buzzer);
else
tone(buzzer,10);

}
void check (int k)//=mybpm1
{
  delay(1000);
 myBPM2 = pulseSensor.getBeatsPerMinute();
 Serial.print(" BPM2: ");
 Serial.print(myBPM2);
 sub_beats=myBPM2-k;
 Serial.print(" sub: ");
 Serial.println(sub_beats);
  if(sub_beats<3&&myBPM2<=180)
  {
    lcd.clear();
    Serial.print(" lcd_Result: ");
    Serial.println(myBPM2);
    lcd.print("BPM:");
    lcd.print(myBPM2);
   while( ArduinoSerial.available()>0){
    float val = ArduinoSerial.parseFloat();
    if(ArduinoSerial.read()=='\n'){
    if(val==0xA0)
    { 
    ArduinoSerial.print(myBPM2);
    ArduinoSerial.print("\n");
    }
    }
    }
    }
} 



  
