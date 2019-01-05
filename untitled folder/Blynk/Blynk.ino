/**************************************************************
   Blynk is a platform with iOS and Android apps to control
   Arduino, Raspberry Pi and the likes over the Internet.
   You can easily build graphic interfaces for all your
   projects by simply dragging and dropping widgets.

     Downloads, docs, tutorials: http://www.blynk.cc
     Blynk community:            http://community.blynk.cc
     Social networks:            http://www.fb.com/blynkapp
                                 http://twitter.com/blynk_app

   Blynk library is licensed under MIT license
   This example code is in public domain.

 **************************************************************
   This example shows how value can be pushed from Arduino to
   the Blynk App.

   WARNING :
   For this example you'll need SimpleTimer library:
     https://github.com/jfturcot/SimpleTimer
   and Adafruit DHT sensor library:
     https://github.com/adafruit/DHT-sensor-library

   App project setup:
     Value Display widget attached to V5
     Value Display widget attached to V6

 **************************************************************/

#define BLYNK_PRINT Serial    // Comment this out to disable prints and save space
#include <SPI.h>
#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>
#include <SoftwareSerial.h>
SoftwareSerial NodeSerial(D2, D3);
#include <DHT.h>
float X, T;
// You should get Auth Token in the Blynk App.
// Go to the Project Settings (nut icon).
char auth[] = "2e9ef7f91ffc42309c4c23b1dacc4625";

// Your WiFi credentials.
// Set password to "" for open networks.
char ssid[] = "abcd";
char pass[] = "12345678";

#define DHTPIN D0          // What digital pin we're connected to

// Uncomment whatever type you're using!
#define DHTTYPE DHT11     // DHT 11

DHT dht(DHTPIN, DHTTYPE);
BlynkTimer timer;

void setup()
{
  Serial.begin(9600); // See the connection status in Serial Monitor
  NodeSerial.begin(4800);
  Blynk.begin(auth, ssid, pass);
  pinMode(D2, INPUT);
  pinMode(D3, OUTPUT);

  dht.begin();

  // Setup a function to be called every second
  timer.setInterval(1000L, sendSensor);
}

void loop()
{
  Blynk.run(); // Initiates Blynk
  timer.run(); // Initiates SimpleTimer
  X = analogRead(A0);
  T = ((X * 2.5) / 1024) * 100;
  Serial.println(T);
  Serial.println("TemperatureBody");
  Blynk.virtualWrite(V5, T);

  NodeSerial.print(0xA0);
  NodeSerial.print("\n");
  while (NodeSerial.available() > 0) {
    float val = NodeSerial.parseFloat();
    if (NodeSerial.read() == '\n') {
      Serial.println(val);
      Serial.println("BBM");
      Blynk.virtualWrite(V3, val);
    }
  }
  delay(1000);
}

// This function sends Arduino's up time every second to Virtual Pin (5).
// In the app, Widget's reading frequency should be set to PUSH. This means
// that you define how often to send data to Blynk App.
void sendSensor()
{
  float h = dht.readHumidity();
  float t = dht.readTemperature(); // or dht.readTemperature(true) for Fahrenheit
  Serial.println("Humidity");
  Serial.println(h);
  
  Serial.println("Temperature");
  Serial.println(t);
  
  if (isnan(h) || isnan(t)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  // You can send any value at any time.
  // Please don't send more that 10 values per second.
  Blynk.virtualWrite(V4, h);
  Blynk.virtualWrite(V6, t);
}
