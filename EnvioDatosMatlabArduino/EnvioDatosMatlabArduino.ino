int A;
int FFT[7]; // [6,5,4]
long FFT1 = 0;
int unidad = 1;
bool cond;
int FA = 0;
int flag=0;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available())
  {
      A=Serial.read();
//      Serial.println(A);
      if(A==65)
      {
        Serial.println("Data received");
        if(Serial.available()){
          FFT[0] = Serial.read() - 48;
          Serial.print(FFT[0]);
          FFT1 = FFT[0] * 100000000L;
          Serial.print(FFT1);
          if(Serial.available()){
            FFT[1] = Serial.read() - 48;
            Serial.print(FFT[1]);
            FFT1 = FFT1 + (FFT[1] * 10000000L);
            Serial.print(FFT1);
            if(Serial.available()){
              FFT[2] = Serial.read() - 48;
              Serial.print(FFT[2]);
              FFT1 = FFT1 + FFT[2] * 1000000L;
              Serial.print(FFT1);
              if(Serial.available()){
                FFT[3] = Serial.read() - 48;
                Serial.print(FFT[3]);
                FFT1 = FFT1 + FFT[3] * 100000L;
                Serial.print(FFT1);
                if(Serial.available()){
                  FFT[4] = Serial.read() - 48;
                  Serial.print(FFT[4]);
                  FFT1 = FFT1 + FFT[4] * 10000L;
                  Serial.print(FFT1);
                  if(Serial.available()){
                    FFT[5] = Serial.read() - 48;
                    Serial.print(FFT[5]);
                    FFT1 = FFT1 + FFT[5] * 1000L;
                    Serial.print(FFT1);
                    if(Serial.available()){
                      FFT[6] = Serial.read() - 48;
                      Serial.print(FFT[6]);
                      FFT1 = FFT1 + FFT[6] * 100L;
                      Serial.print(FFT1);
                      if(Serial.available()){
                        FFT[7] = Serial.read() - 48;
                        Serial.print(FFT[7]);
                        FFT1 = FFT1 + FFT[7] * 10L;
                        Serial.print(FFT1);
                        if(Serial.available()){
                          FFT[8] = Serial.read() - 48;
                          Serial.print(FFT[8]);
                          FFT1 = FFT1 + FFT[8] * 1L;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
  }
  
  Serial.println(FFT1);
  Serial.write(13);
  Serial.write(10);

}
