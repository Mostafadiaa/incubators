#include <ESP8266WiFi.h>
#define BLYNK_PRINT Serial
#include <SPI.h>
#include <FirebaseArduino.h>
#include <DHT.h>
#include <SoftwareSerial.h>
SoftwareSerial NodeSerial(D2, D3);
#define DHT_PIN D0
#define DHT_TYPE DHT11
DHT dht(DHT_PIN, DHT_TYPE);
// Set these to run example.
#define FIREBASE_HOST "dhtdemo.firebaseio.com"
#define FIREBASE_AUTH "I5bOwp9y5YKLMCnV67bMjuvcRBVYLuDwwCNEwFws"
#define WIFI_SSID "abcd"
#define WIFI_PASSWORD "12345678"
float X, T;

void setup() {
  Serial.begin(9600);
  NodeSerial.begin(4800);
  pinMode(D2, INPUT);
  pinMode(D3, OUTPUT);
  dht.begin();
  // connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

}

int n = 0;

void loop() {
  delay(2000);
  //   Humidity
  float h = dht.readHumidity();

  // set value
  Firebase.setFloat("Humidity", h);
  // handle error
  if (isnan(h)) {
    Serial.println("Failed to read Humidity from DHT sensor!");
    return;
  }
  if (Firebase.failed()) {
    Serial.print("setting /number failed:");
    Serial.println(Firebase.error());
    return;
  }
  //  Temperature
  float t = dht.readTemperature();
  // set value
  Firebase.setFloat("Temperature", t);
  // handle error
  if (isnan(t)) {
    Serial.println("Failed to read Temperature from DHT sensor!");
    return;
  }
  if (Firebase.failed()) {
    Serial.print("setting /number failed:");
    Serial.println(Firebase.error());
    return;
  }
  //  body_temp
  X = analogRead(A0);
  T = ((X * 2.5) / 1024) * 100;
  float body_temp = T;
  // update value
  Firebase.setFloat("body_temp", body_temp);
  // handle error
  if (isnan(body_temp)) {
    //    change
    Serial.println("Failed to read body_temp from Temperature sensor!");
    return;
  }
  if (Firebase.failed()) {
    Serial.print("setting /number failed:");
    Serial.println(Firebase.error());
    return;
  }
  //  pulse
  NodeSerial.print(0xA0);
  NodeSerial.print("\n");
  while (NodeSerial.available() > 0) {
    float val = NodeSerial.parseFloat();
    if (NodeSerial.read() == '\n') {
      Serial.println(val);
      Firebase.setFloat("BBM", val);
    }

    // handle error
    if (isnan(val)) {
      Serial.println("Failed to read BBM from sensor!");
      return;
    }
    if (Firebase.failed()) {
      Serial.print("setting /number failed:");
      Serial.println(Firebase.error());
      return;
    }

  }

  // get value
  Serial.print("Humidity: ");
  Serial.println(Firebase.getFloat("Humidity"));
  Serial.print("Temperature: ");
  Serial.println(Firebase.getFloat("Temperature"));
  Serial.print("body temp: ");
  Serial.println(Firebase.getFloat("body_temp"));
  Serial.print("BBM: ");
  Serial.println(Firebase.getFloat("val"));

  delay(1000);
}
