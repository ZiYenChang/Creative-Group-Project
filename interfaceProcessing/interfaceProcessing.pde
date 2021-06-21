PImage img;
Table table;
boolean on=false;
boolean balanceDisplay = false;
int screen = 0;
int rightBalance = #4e88ba;
int leftBalance = #4e88ba;
float rightBalanceAlpha=255;
float leftBalanceAlpha=255;
int left;
int right;
int newMin;
int newSec;
int feedback = 0;
int progressingDistance = 415;
int progressingTime = 430;
float speedDistance;
float speedTime;
int countDown = 5;
int distanceColour=#9183AE;
int timeColour=#97A5A8;
int progressingTimeColour = #4C7FAB;
int progressingDistanceColour = #7CB0CE;
int[] distance = new int[5];
int[] time = new int[6];
int[] balanceColours = {#781121,#67302F,#584A3C,#4D5E45,#43714E};
int currentInput = 654;
int distanceInput;
int timeInput;
int vibrationColour=#3A3347;
int [] distanceRecords ={5000,4000};
int [] timeRecords = {1620000, 1620000};
//int[][] distanceTime = { {5000, 1620000}, {4000, 1620000} };
Boolean newTime = false;
char newTimePerformance = ' ';
int contact;
int cadence;
float pace;


//3A3347 - dark purple

void setup() {
  size(900, 770);
  textAlign(CENTER);
  for(int i=0;i<5;i++)distance[i]=0;
  for(int i=0;i<6;i++)time[i]=0;
  img = loadImage("shoes3.png");
  right = int(random(80,180));
  left = 255-right;
}

void draw() {
  background(255);
  noStroke();
  drawBalance();
  drawInputBox();
  drawButtons();
  drawFeedback();
  if(on){
    if(screen>4){
      postTrainingFeedback();
    }
    if(screen==1){
      screen1();
    } else if(screen == 2) {
      screen2();
    } else if(screen == 3) {
      countDown();
    } else if(screen == 4) {
      distanceProgression();
      timeProgression();
    } else if(screen == 5){
      screen5();
    }
  }
  image(img, 0, -40, 900, 850);
  drawButtons();
  drawVibration();
}

//------------------------------------------------------------------------------
//This section focuses on drawing the main functional components.

void drawButtons(){
  stroke(#7966A0);
  strokeWeight(2);
  //save
  fill(255);
  rect(615,535,25,15,10);
  fill(#4e88ba);
  //up
  rect(615,557,25,15,10);
  //down
  rect(615,513,25,15,10);
  //right
  rect(647,535,25,15,10);
  //left
  rect(583,535,25,15,10);
}

void drawBalance(){
  fill(leftBalance,leftBalanceAlpha);
  rect(50,0,400,770);
  fill(rightBalance,rightBalanceAlpha);
  rect(400,0,400,770);
}

void drawInputBox(){
  fill(0);
  rect(559,85,144,50,10,10,0,0);
}

void drawFeedback(){
  noStroke();
  //distance
  fill(#9183AE);
  rect(538,135,92,280,10,0,0,150);
  //time
  fill(#9183AE);
  rect(630,135,92,290,0,0,0,150);
}

void drawVibration(){
  noStroke();
  fill(vibrationColour);
  ellipse(265,650,70,70);
  ellipse(635,650,70,70);
}

//------------------------------------------------------------------------------
//This section focuses on buttons' usage.

void mouseClicked() {
    controlButton();
    input();
    feedbackControl();
}

void controlButton(){
  if (mouseX>=615 && mouseX<=640) {
    if (mouseY>=535 && mouseY<=550) {
        if(!on){
          on=true;
          screen=1;
          currentInput= 584;
          println("Turned On");
        }
        else {
          if(screen==1){
            distanceInput = (distance[0]*10+distance[1])*1000+distance[2]*100+distance[3]*10+distance[4];
            if(distanceInput>0){
              distanceTime(distanceInput);
              screen = 2;
              currentInput = 594;
            }
          }
          else if(screen==2){
            vibrationColour=255;
            newMin = int(random(25*(time[0]*10 + time[1])/100));
            newSec = int(random(35*(time[2]*10 + time[3])/100));
            screen = 3;
            currentInput = 0;
            speedDistance = random(1, 4);
            speedTime = random(1, 4);
          }
          else if(screen == 5 && vibrationColour==255){
            vibrationColour = #3A3347;
            feedback = 1;
          }
          else reset();
        }
      }
    }
  }
  
  void input() {
  if (screen == 1 || screen == 2) {
    if (mouseY >= 535 && mouseY<=550) {
      if (mouseX>=583 && mouseX<=608)lineToLeft();
      else if (mouseX>=647 && mouseX<=672) lineToRight();
    } 
    else if (mouseX >= 615 && mouseX<=640){
      if (mouseY>=557 && mouseY<=572)decrease();
      if (mouseY>=513 && mouseY<=528)increase();
    }
  }
}

void reset(){
  on = false;
  screen = 0;
  countDown = 5;
  progressingDistance = 415;
  progressingTime = 430;
  for(int i=0;i<5;i++)distance[i]=0;
  for(int i=0;i<6;i++)time[i]=0;
  rightBalance = #4e88ba;
  leftBalance = #4e88ba;
  vibrationColour = #3A3347;
  left = int(random(30,100));
  right = 100-left;
  newTime=false;
  feedback = 0;
  progressingTimeColour = #4C7FAB;
  progressingDistanceColour = #7CB0CE;
}

void feedbackControl(){
  if (screen == 5) {
    if (mouseY >= 535 && mouseY<=550) {
      if (mouseX>=583 && mouseX<=608){
        if(feedback>1)feedback=feedback-1;
      }
      else if (mouseX>=647 && mouseX<=672){
        if(feedback<4)feedback=feedback+1;
      }
    }
  }
}
  
//------------------------------------------------------------------------------
//This section focuses on distance screen.

void screen1() {
  textSize(15);
  fill(255);
  text("DISTANCE", 630, 108);
  fill(255);
  text(distance[0], 585, 125);
  text(distance[1], 595, 125);
  fill(#97A5A8);
  text("km", 613, 125);
  fill(255);
  text(distance[2], 640, 125);
  text(distance[3], 650, 125);
  text(distance[4], 660, 125);
  fill(#97A5A8);
  text("m", 675, 125);
  stroke(255);
  strokeWeight(2);
  line(currentInput, 128, currentInput, 133);
}

//------------------------------------------------------------------------------
//This section focuses on time screen.

void screen2() {
  textSize(15);
  fill(255);
  text("TIME", 630, 108);
  fill(timeColour);
  text(time[0], 595, 125);
  text(time[1], 605, 125);
  fill(#97A5A8);
  text(":", 615, 125);
  fill(timeColour);
  text(time[2], 625, 125);
  text(time[3], 635, 125);
  fill(timeColour);
  text(".", 644, 125);
  text(time[4], 655, 125);
  text(time[5], 665, 125);
  stroke(255);
  strokeWeight(2);
  line(currentInput, 128, currentInput, 133);
}

//------------------------------------------------------------------------------
//This section focuses on countdown.

void countDown(){
  if(countDown%2==1)vibrationColour=255;
  else vibrationColour=#3A3347;
  delay(1000);
  println(countDown);
  if(countDown>0)countDown--;
  else {
    vibrationColour=#3A3347;
    screen = 4;
  }
}

//------------------------------------------------------------------------------
//This section focuses on distance-time progression during training

//void screen2() {
//  fill(#AEDBF0);
//  stroke(255);
//  rect(1, 1, screen1width/2 - 0.5, screen1height);
//  String timeFeedback = or + str(time);
//  rect(screen1width/2 + 1, 1, screen1width/2, screen1height);
//  screen2Distance();
//  screen2Time();
//  feedback();
//  textSize(25);
//  fill(255);
//  if(i<0)text(timeFeedback, 300, j+30);
//}

void distanceProgression() {
  fill(progressingDistanceColour);
  rect(540, progressingDistance, 91, 415 - progressingDistance);
  if (progressingDistance-speedDistance<135){ 
    progressingDistance = 135;
    progressingDistanceColour=#579C6B;
    if(progressingTime!=135){
      progressingTimeColour=#41744F;
      newTimePerformance = '-';
    }
    screen = 5;
    vibrationColour = 255;
    feedback = 1;
  }
  else progressingDistance-=speedDistance;
}

void timeProgression() {
  fill(progressingTimeColour);
  rect(631, progressingTime, 91, 430 - progressingTime);
  if (progressingTime-speedTime<135){ 
    progressingTime = 135;
    if(progressingDistance!=135){
      progressingTimeColour=#7E051B;
      newTimePerformance = '+';
    }
  }
  else {
    if(progressingDistance!=135)progressingTime-=speedTime;
  }
}
//void screen2Time() {
//  fill(#1F618D);
//  if (j-speedTime<speedTime && i-speedDistance>speedDistance*5)timeGB -= speedTime / 10;
//  fill(timeR, timeGB, timeGB);
//  if(i<=0 && j>0){
//    fill(#45771E);
//    or ='-';
//  }
//  rect(screen1width/2 + 1, j, screen1width/2 - 0.5, 398 - j);
//  if (i>speedDistance) {
//    if (j>0)j-=speedTime;
//    timeGB -= speedTime / 3;
//  }
//}

//------------------------------------------------------------------------------
//This section focuses of post-trainig feedback;

void screen5(){
  if(vibrationColour!=255){
    if(feedback == 1)feedback1();
    else if(feedback == 2)feedback2();
    else if(feedback == 3)feedback3();
    else if(feedback == 4)feedback4();
  }
}

void postTrainingFeedback(){
  if(!balanceDisplay){
    leftBalanceAlpha -=left;
    rightBalanceAlpha -=right;
    balanceDisplay = true;
  }
  fill(progressingTimeColour);
  rect(631, progressingTime, 91, 430 - progressingTime);
  fill(progressingDistanceColour);
  rect(540, progressingDistance, 91, 415 - progressingDistance);
}

void feedback1(){
  if(!newTime){
    int min = time[0]*10 + time[1];
    int sec = time[2]*10 + time[3];
    if(newTimePerformance=='+'){
      min = min + newMin;
      if(sec+newSec>=60){
        min++;
        sec=sec+newSec-60;
      }
      else sec = sec + newSec;
    } else if(newTimePerformance=='-') {
      min = min - newMin;
      sec = sec - newSec;
    }
    int mili = int(random(100));
    time[0]=min/10;
    time[1]=min%10;
    time[2]=sec/10;
    time[3]=sec%10;
    time[4]=mili/10;
    time[5]=mili%10;
    println(time[4]+ "and second" + time[5]);
    int newTimeValue = ((time[0]*10+time[1])*60+time[2]*10+time[3])*1000+time[4]*100+time[5]*10;
    pace = distanceInput/(newTimeValue/1000);
    contact = int(random(160,300));
    cadence = int(random(150,200));
    if(newTimePerformance=='-'||(timeRecords[timeRecords.length-1]==int(distanceInput/3.5)*1000)){
      updateRecords(newTimeValue);
      println(distanceRecords);
      println(timeRecords);
    }
    newTime=true;
  }
  screen2();
}

void feedback2(){
  textSize(15);
  fill(255);
  text("CADENCE", 630, 108);
  fill(#97A5A8);
  text(cadence + " SPM", 630, 125);
}

void feedback3(){
  textSize(15);
  fill(255);
  text("PACE", 630, 108);
  fill(#97A5A8);
  text(pace + " M/SEC", 630, 125);
}

void feedback4(){
  textSize(15);
  fill(255);
  text("CONTACT", 630, 108);
  fill(#97A5A8);
  text(contact + " MS", 630, 125);
}

//------------------------------------------------------------------------------
//This sectionfocuses on controlling the device's input set up buttons.


void lineToRight() {
  if (screen == 1) {
    if (currentInput == 584)currentInput = 594;
    else if (currentInput == 594)currentInput = 639;
    else if (currentInput == 639)currentInput = 649;
    else if (currentInput == 649)currentInput = 659;
  } 
  else if(screen == 2){
    if (currentInput == 594)currentInput = 604;
    else if (currentInput == 604)currentInput = 624;
    else if (currentInput == 624)currentInput = 634;
    else if (currentInput == 634)currentInput = 654;
    else if (currentInput == 654)currentInput = 664;
  }
  println(currentInput);
}

void lineToLeft() {
  if (screen == 1) {
    if (currentInput == 659)currentInput = 649;
    else if (currentInput == 649)currentInput = 639;
    else if (currentInput == 639)currentInput = 594;
    else if (currentInput == 594)currentInput = 584;
  } 
  else if(screen == 2){
    if (currentInput == 664)currentInput = 654;
    else if (currentInput == 654)currentInput = 634;
    else if (currentInput == 634)currentInput = 624;
    else if (currentInput == 624)currentInput = 604;
    else if (currentInput == 604)currentInput = 594;
  }
}

void increase() {
  if (screen == 1) {
    if (currentInput == 584) {
      if (distance[0] < 9) {
        distance[0]++;
      }
    } else if (currentInput == 594) {
      if (distance[1] < 9) {
        distance[1]++;
      }
    } else if (currentInput == 639) {
      if (distance[2] < 9) {
        distance[2]++;
      }
    } else if (currentInput == 649) {
      if (distance[3] < 9) {
        distance[3]++;
      }
    } else if (currentInput == 659) {
      if (distance[4] < 9) {
        distance[4]++;
      }
    }
  } 
  else if (screen == 2) {
    if (currentInput == 594) {
      if (time[0] < 9) {
        time[0]++;
      }
    } else if (currentInput == 604) {
      if (time[1] < 9) {
        time[1]++;
      }
    } else if (currentInput == 624) {
      if (time[2] < 9) {
        time[2]++;
      }
    } else if (currentInput == 634) {
      if (time[3] < 9) {
        time[3]++;
      }
    } else if (currentInput == 654) {
      if (time[4] < 9) {
        time[4]++;
      }
    } else if (currentInput == 664) {
      if (time[5] < 9) {
        time[5]++;
      }
    }
  } 
}

void decrease() {
  if (screen == 1) {
    if (currentInput == 584) {
      if (distance[0] > 0) {
        distance[0]--;
      }
    } else if (currentInput == 594) {
      if (distance[1] > 0) {
        distance[1]--;
      }
    } else if (currentInput == 639) {
      if (distance[2] > 0) {
        distance[2]--;
      }
    } else if (currentInput == 649) {
      if (distance[3] > 0) {
        distance[3]--;
      }
    } else if (currentInput == 659) {
      if (distance[4] > 0) {
        distance[4]--;
      }
    }
  } 
  else if (screen == 2) {
    if (currentInput == 594) {
      if (time[0] > 0) {
        time[0]--;
      }
    } else if (currentInput == 604) {
      if (time[1] > 0) {
        time[1]--;
      }
    } else if (currentInput == 624) {
      if (time[2] > 0) {
        time[2]--;
      }
    } else if (currentInput == 634) {
      if (time[3] > 0) {
        time[3]--;
      }
    } else if (currentInput == 654) {
      if (time[4] > 0) {
        time[4]--;
      }
    } else if (currentInput == 664) {
      if (time[5] > 0) {
        time[5]--;
      }
    }
  } 
}

//------------------------------------------------------------------------------
//Additional functions

void distanceTime(int x){
  Boolean newDistance = true;
  for(int i=0;i<distanceRecords.length;i++){
    if(x == distanceRecords[i]){
      println("in records");
      newDistance = false;
      timeColour = 255;
      int seconds = timeRecords[i]/1000;
      int minutes = seconds/60;
      seconds = seconds % 60;
      int mili = timeRecords[i]%1000;
      time[0]=minutes/10;
      time[1]=minutes%10;
      time[2]=seconds/10;
      time[3]=seconds%10;
      time[4]=mili/100;
      time[5]=mili%100/10;
    }
  }
  if(newDistance){
      println("new record");
      timeColour = #97A5A8;
      float recommended = x/3.5;
      int [] newRecord = append(timeRecords, int(recommended) * 1000);
      timeRecords = newRecord;
      int mili = int(recommended*1000);
      int seconds = mili/1000;
      int minutes = seconds/60;
      seconds = seconds % 60;
      mili = mili%1000;
      time[0]=minutes/10;
      time[1]=minutes%10;
      time[2]=seconds/10;
      time[3]=seconds%10;
      time[4]=mili/100;
      time[5]=mili%100/10;
      newRecord = append(distanceRecords, x);
      distanceRecords = newRecord;
  }
}

void updateRecords(int x){
  for(int i=distanceRecords.length-1;i>=0;i--){
    if(distanceInput == distanceRecords[i]){
      timeRecords[i]=x;
    }
  }
}
