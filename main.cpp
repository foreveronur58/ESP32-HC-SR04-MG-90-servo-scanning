#include <Arduino.h>
#include <ESP32Servo.h>
#include <Wire.h>


Servo yatay_servo;  
Servo dikey_servo;  
const int servoPin = 12;  
const int servoPin2 = 13;
const int trigPin = 5;
const int echoPin = 18;
const float MAX_RANGE_CM = 20;


void dikey_servo_yukari() {

  for(int dikey_servo_aci=90; dikey_servo_aci<180; dikey_servo_aci+=10) {
    dikey_servo.write(dikey_servo_aci);              
    delay(1000);                       
  }

}

float olcMesafe() {
 digitalWrite(trigPin, LOW);
 delayMicroseconds(2);
 digitalWrite(trigPin, HIGH);
 delayMicroseconds(10);
 digitalWrite(trigPin, LOW);

  
  long duration = pulseIn(echoPin, HIGH, 30000);
  if (duration == 0) return -1;  // ölçüm alınamadı

  float mesafe = duration * 0.034 / 2.0;

  if (mesafe < MAX_RANGE_CM) return mesafe;
  else return -1;

  
}

float servoAci() {
  float angle = yatay_servo.read();
  return angle;
}


void setup() {

  pinMode(trigPin,OUTPUT);
  pinMode(echoPin,INPUT);

  Serial.begin(115200);           
  yatay_servo.attach(servoPin);  
  dikey_servo.attach(servoPin2);  
  dikey_servo.write(90);
  delay(5000);             
  dikey_servo_yukari();

}

void loop() {
  
  

  for(int i=180; i>0; i-=10) { 
    yatay_servo.write(i);
    Serial.print("Distance(cm):");
    delay(200);
    Serial.println(olcMesafe());
    Serial.print("Servo angle(*):");
    Serial.println(servoAci());  
    delay(200);                      
  }

  for(int i=0; i<=180; i+=10) { 
    yatay_servo.write(i);
    Serial.print("Distance(cm):");
    delay(200);
    Serial.println(olcMesafe());
    Serial.print("Servo angle(*):");
    Serial.println(servoAci());              
    delay(200);                      
  }


}