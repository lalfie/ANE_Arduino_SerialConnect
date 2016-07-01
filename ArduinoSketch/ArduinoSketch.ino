// include the library code:
#include <LiquidCrystal.h>
int count = 0;
// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

void setup() {
  // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("count:");
  Serial.begin(9600);
}

void loop() {
  
  count ++;
  
  lcd.setCursor(6, 0);
  lcd.print(count);
  
  // シリアル受信した文字列がある場合は
  // LCDの書き込み開始位置を二行目に指定します。
  if(Serial.available() > -1){
    lcd.setCursor(0, 1);
  }
  // シリアル受信した文字列がある間は繰り返し処理をします。
  while (Serial.available()) {
    // lcdに書き込みます。
    lcd.write(Serial.read());
  }
  //Serial.write("hello");
  Serial.println(count);
  
  delay(1000);
}


