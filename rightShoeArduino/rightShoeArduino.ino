#include "Adafruit_FloraPixel.h" 

int distance;
int traveled;
float time;
float passed;
int pace;
//light
Adafruit_NeoPixel leftStrip = Adafruit_NeoPixel(20,A2, NEO_RGB + NEO_KHZ800);
//motor
int motorPin = 10;
boolean motorOn = false;

//buttons
int leftButPin = A2;
int upButPin = A1;
int midButPin = 9;
int downButPin = 6;
int rightButPin = 5;
int leftState, midState, upState, downState, rightState = 0;

//fsr
int rightFsrPin = 0;
int rightFsrRreading;
int rightTotal;

//adapter for led
int adapterPin = 11;

//ground contact time
int contactTime;

//cadence
int steps;
void setup() {
  // put your setup code here, to run once:
  strip.begin();
  strip.show();
  pinMode(motorPin, OUTPUT);
  pinMode(adapterPin,INPUT_PULLUP);
}

void loop() {
  //if values for goals are all inputted, then start
  if (inputValues == true){
    testProgress();
    motorOnOff();
    updatePace();  
    getRightCadence();
    getLeftCadence();
    //passed time increase by 1 sec, the total time is stored as minutes
    passed+=(1/60);
    delay(1000);
  }
}

//display information when user pressed a button after run
void GetInfo(){
  //pseudo code
  //per hour
  if (displayCadence){
    display.println("The average cadence: ");
    display.println(steps/time);
  }
  else if(displaySpeed){
    display.println("the average speed was: ");
    display.println(totalSpeed/time);
  }
  else if(displayContactTime){
    display.println(contactTime);  
  }
  else if(displaySymmetry){
    display.println("the total pressure for the right foot is");
    display.println(rightTotal/(rightTotal+leftTotal)*100);
    display.println("the total pressure for the left foot is");
    display.println(leftTotal/(rightTotal+leftTotal)*100);
  }  
}

//calculate pace
void getBalance(){
    //if the pressure is lower than 100, it is not registered as a proper step
    int standard = 100;
    rightFsrReading = analogRead(rightFsrPin);
    if (rightFsrReading > standard){
      rightTotal += rightFsrReading; 
      //increase step count
      steps++;
      //contact time with ground
      contactTime++; 
    }
    leftFsrReading = analogRead(leftFsrPin);
    if (leftFsrReading > standard){
      leftTotal += leftFsrReading;
      steps++;  
      contactTime++;
    }
}

//motor functions
void motorOnOff(){
    //when the traveled distance is less than 70% of the full distance
    if(traveled <= 7.10*distance){
      //set up pace range
      recommendedRangeMin = pace;
      recommendedRangeMax = pace + 0.45;
    }
    else{
      recommendedRangeMin = pace - 0.45;
      recommendedRangeMax = pace;  
    }
    //if the runner is running within the range then stops the motor from vibration
    if (pace > recommendedRangeMin && pace < recommendedRangeMax){
      if(motorOn == true){
        motorOn = false;
        timer = 0;  
      }  
    }
    else{
       //motor starts vibrate
       motorOn = true;
       //if the user is running under the recommended range, then he needs to speed up
       if(pace < recommendedRangeMin){
         if(timer<10){
           //turn on the motor
           analogWrite(motorPin, 100);
         }
         else{
           //if the user cannot speed up to the recommended range for 10 seconds, the vibration will increase
           analogWrite(motorPin, timer*1.5 + 100);
         }
       }
       // if the user is running faster than the recommended range
       else{
        //the motor will vibrate and decrease intensity gradualy
        analogWrite(motorPin, 150-timer);
      }  
    }
    timer++;
}

//input goals - distance and time
void inputValues(){
  leftState = analogRead(leftButPin);
  upState = analogRead(upButPin);
  midState = digitalRead(midButPin);
  downState = digitalRead(downButPin);
  rightState = digitalRead(rightButPin);
  inputDistance();
  inputTime();
  if (distance != 0 && time != 0){
    return true;  
  }
  return false;
}

void inputDistance(){
  //see the processing code, there are 5 zeros
  int[] value = {0,0,0,0,0}
  int currentNode = 0;
  if (leftState == HIGH){
    //control meter
    currentNode++;
    if (currentNode == value.length){
      currentNode=0;
    }
  }
  else if (rightState == HIGH){
    currentNode--;
    if (currentNode < 0){
      currentNode = value.length-1;
    }  
  }
  //control value
  if (upState == HIGH){
    value[currentNode]+=1;
    if (value[currentNode]>=10){
      value[currentNode]=0;
    }  
  }
  else if (downState == HIGH){
    value[currentNode]-=1;
    if (value[currentNode]<0){
      value[currentNode]=9;
    }  
  }
  //confirm
  if (midState == HIGH){
    String tempDistance;
    for(int i =0; i< value.length;i++){
      tempDistance+=String(value[i]);
    }
    distance = int(tempDistance); 
  }
}

void inputTime(){
  int[] value = {0,0,0,0}
  int currentNode = 0;
  if (leftState == HIGH){
    //control meter
    currentNode++;
    if (currentNode == value.length){
      currentNode=0;
    }
  }
  else if (rightState == HIGH){
    currentNode--;
    if (currentNode < 0){
      currentNode = value.length-1;
    }  
  }
  //control value
  if (upState == HIGH){
    value[currentNode]+=1;
    if (value[currentNode]>=10){
      value[currentNode]=0;
    }  
  }
  else if (downState == HIGH){
    value[currentNode]-=1;
    if (value[currentNode]<0){
      value[currentNode]=9;
    }  
  }
  //confirm
  if (midState == HIGH){
    String tempMin;
    String tempHour;
    for(int i =0; i< 2;i++){
      tempHour+=String(value[i]);
    }
    for(int i =2; j< value.length;j++){
      tempMin+=String(value[i]);
    }
    time = int(tempHour)*60+int(tempMin); 
  }
}

void testProgress(){
  if (traveled >= distance){
    exit(0);  
  }
  //show light progress
  distanceIndicator(int(traveled/distance*10));
  timeIndicator(int(passed/time*10));
}

void calculateDistance(){
  //transform knots to meter
    int currentSpeed = GPS.speed * 1852;
    totalSpeed += currentSpeed;
    //hour to second
    traveled+=currentSpeed/3600;
}

//the left light bulb light up one by another due to the progress of distance
void distanceIndicator(int current){
  for(uint16_t i = 0; i<current; i++){
    strip.setPixelColor(i,"green");
    strip.show();
    //delay(10);
  }
}
//for the progress of time
void timeIndicator(){
  for(uint16_t i = 10; i<current+10; i++){
    strip.setPixelColor(i,"red");
    strip.show();
    //delay(10)*
  }
}
