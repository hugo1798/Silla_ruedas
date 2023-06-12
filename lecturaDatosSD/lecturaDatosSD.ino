/*
  SD card file dump

  This example shows how to read a file from the SD card using the
  SD library and send it over the serial port.

  The circuit:
   SD card attached to SPI bus as follows:
 ** MOSI - pin 11
 ** MISO - pin 12
 ** CLK - pin 13
 ** CS - pin 10 (for arduino nano)

  created  22 December 2010
  by Limor Fried
  modified 9 Apr 2012
  by Tom Igoe

  This example code is in the public domain
  This example was modified to read several data in a txt file. 
*/

#include <SPI.h>
#include <SD.h>
#define M 5000

Sd2Card card;

const int chipSelect = 53;
char row1[M];
char uA[21];
int i = 0, k = 0, j = 0;
long data[8];
char flag=0;
int N1, N2;
void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  SPI.begin();
  Serial.println("Initializing SD card...");

    if (!card.init(SPI_FULL_SPEED, chipSelect)) {
    Serial.println("initialization failed. Things to check:");
    Serial.println("* is a card inserted?");
    Serial.println("* is your wiring correct?");
    Serial.println("* did you change the chipSelect pin to match your shield or module?");
    while (1);
  } else {
    Serial.println("Wiring is correct and a card is present.");
  }

  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    while (1);
  }
  Serial.println("card initialized.");

  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  File dataFile = SD.open("DATA1T.TXT");

  // if the file is available, read it:
  i=0;
    if (dataFile) {
    while (dataFile.available()) {
      row1[i]=dataFile.read();
      //Serial.write(row1[i]);
      i++;
      if (i==M)
        break;
     }
     
  }
  // if the file isn't open, pop up an error:
  else {
    Serial.println("error opening datalog.txt");
  }
  dataFile.close();
  j=0;
}
 
void loop()
{
  flag=0;
  // Comienza la conversion de los datos
  if(flag==0)
    {
      N1=0; 
      N2=0;
      for(j = 0; j < 3999; j++)
      {    
        data[N1]=0.0;
        if(row1[j] != 10)
        {  
          //Serial.write(row1[j]);  
          if(row1[j]== 44)
            {
              for(k=0;k<N2;k++)
              { //Serial.write(uA[k]); 
                data[N1] = ((uA[k]-48) * pow(10,N2-k-1)) + data[N1];
              }  
              Serial.write('C');
              Serial.println(data[N1]);
              //Serial.write(10); 
              N1++;
              N2=0;
              
            }
          else
          {
              uA[N2]=row1[j];
              N2++;
          } 
        }
        else
        {Serial.write(10); }
      }
    }
   // flag=1; 
}


          