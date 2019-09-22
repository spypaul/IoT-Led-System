
const int onoff = 7;
const int LED = 10;
int temp = 0;
int pwm = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(38400);
  Serial1.begin(38400);
  Serial3.begin(38400);
  pinMode(onoff, INPUT);
  pinMode(LED, OUTPUT);
  
}

bool onoffcont = 0; 

void loop() {
  // put your main code here, to run repeatedly:
    onoffcont = digitalRead(onoff);
      Serial1.write(B00000001);
      while(Serial1.available()<=0){}
      temp = Serial1.read();
      Serial.println(temp);
      delay(100);
      Serial1.write(0);// evertime after read
      delay(100);
      Serial1.write(B00000011);
      while(Serial1.available()<=0){}
      pwm = Serial1.read();
      Serial.println(pwm);
      delay(100);
      Serial1.write(0);// evertime after read
      delay(100);
      while(Serial3.available()<=0){};
      Serial3.write(temp);
    if(onoffcont)
    {

      analogWrite(LED, pwm);
      
    }
    else
    {
      analogWrite(LED, 0);
    }

}
