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
int i = 0, k = 0, j = 0, coma = 0;
// Aqui se almacenan las variables de la fft
long data[21];
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
  File dataFile = SD.open("DATAEM~1.TXT");

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
}
 
void loop(){
  //Contador que permite movernos en los datos dentro del array de data
  N1=0; 
  //Contador para determinar la posicion del valor, si es unidad, decena, centena
  N2=0;  
  //Bucle para iterar dentro de todo el array de row1 que contiene todos los datos del archivo
  for(j = 0; j < 6999; j++){  
    //Array que almacena los datos ya convertidos
    data[N1]=0.0;
    //Serial.print("La coma vale");
    //Serial.print(coma);
    //Determinar si existe un salto de linea
    if(row1[j] != 10){  
      // No existe un salto de linea
      // Determinar si existe una coma
      if(row1[j] == 44){
        // Bucle para realizar la conversion de los valores a unidades, decenas, centenas ...
        for(k=0;k<N2;k++){
          data[N1] = ((uA[k]-48) * pow(10,N2-k-1)) + data[N1];
        }  
        //Serial.write('C');
        //Serial.println(data[N1]);
        // El incremento en N1 permite que cambiemos al siguiente dato a guardar
        N1++;
        N2=0;
        // hay un total de 7 comas
        coma++;
        if(coma == 7){
          j = j + 3;
          coma = 0;
        }
      }
      else{
        // Se almacenan los valores para despues convertirse en la variable data
        // No es realmente uA, refiriendonos a la entrada de la red neuronal
        uA[N2]=row1[j];
        N2++;
      } 
    }
    else{
      // Si existe un salto de linea
      // Presente en 65
      //j = j + 1;
    }
    //Serial.println(j);
  }
}


          