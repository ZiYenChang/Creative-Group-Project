//sync pin
#define syncInPin A0;

int leftFsrPin = A0;
int leftFsrReading;
int leftTotal;

//gps
#define GPSSerial Serial1

void setup() {
  // put your setup code here, to run once:
  GPSSerial.begin(9600);
}

void loop(){
  //pseudo
  //sync the left board to the right one
  syncToRightShoe();
}
