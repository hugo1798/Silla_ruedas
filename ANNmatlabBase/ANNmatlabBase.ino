
//Parametros para ajuste de los pesos
float alfa1[] = {0.0000125};
float alfa2[] = {0.0001};
float alfa3[] = {0.000008};

//Estructura de la red
int N1 = 21;  //capa de entrada
int N2 = 52;  //primer capa oculta
int N3 = 24;  //segunda capa oculta
int N4 = 1;   //capa de salida

//volatile permite que se aloje en espacios de memoria que este libre
float W1[21][52];
float W1aux[21][52];
float W2[52][24];
float W2aux[52][24];
float W3[24][1];
float W3aux[24][1];

float W1T[52][21];
float W2T[24][52];
float W3T[1][24];

float e[1][24];

float m4[] = {3};
float vc[] = {-2};

float uA[1][21];
float uB[52];
float uC[24];
float target[1][24];

//Funciones de activacion sigmoide

float sig1[21][1];
float sig2[52][1];
float sig3[24][1];

float Mov_NN[1][24];

//Derivada de funcion de activacion sigmoide
float dSig1[21];
float dSig2[52];
float dSig3[24];

//diagonales de la derivada de la funcion de activacion
float diagDSig1[21][21];
float diagDSig2[52][52];
float diagDSig3[24][24];

//Parametros para la funcion sigmoide 1
float a1[21];
float b1[21];
float c1[21]; 
float d1[21];

//Parametros para la funcion sigmoide 2
float a2[52];
float b2[52];
float c2[52]; 
float d2[52];

//Parametros para la funcion sigmoide 3
float a3[24];
float b3[24];
float c3[24]; 
float d3[24];

//gradientes
float grad1[21][52];
float grad1aux[24][52];
float grad2[52][24];
float grad3[24][1];

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.print("Hola mundo");
  //CREANDO MATRICES PARA PESOS, TRANSPUESTA DE LOS PESOS, GRADIENTES Y PARAMETROS DE LA FUNCION SIGMOIDE
  //i realiza el movimiento en filas
  for (int i1 = 0; i1 = N1; i1++){
    //j realiza el movimiento en columnas
    for (int j1 = 0; j1 = N2; j1 ++){
      W1[i1][j1] = random(-5,5);
      grad1[i1][j1] = 0.0;
    }
    a1[i1] = 1.0;
    b1[i1] = 1.0;
    c1[i1] = 1.0;
    d1[i1] = 1.0;
  }
  
  for (int i2 = 0; i2 = N2; i2 ++){
    //j realiza el movimiento en columnas
    for (int j2 = 0; j2 = N3; j2 ++){
      W2[i2][j2] = random(-5,5);
      grad2[i2][j2] = 0.0;
    }
    a2[i2] = 1.0;
    b2[i2] = 1.0;
    c2[i2] = 1.0;
    d2[i2] = 1.0;
  }
  for (int i3 = 0; i3 = N3; i3++){
    //j realiza el movimiento en columnas
    for (int j3 = 0; j3 = N4; j3 ++){
      W3[i3][j3] = random(-5,5);
    }
    grad3[i3][1] = 0.0;
    a3[i3] = 1.0;
    b3[i3] = 1.0;
    c3[i3] = 1.0;
    d3[i3] = 1.0;
  }

  //Para la transposicion de los pesos
  for (int itf = 0; itf = 21; itf++){
    for (int itc = 0; itc = 52; itc++){
      W1T[itc][itf] = W2[itf][itc];
    }
  }
  
  for (int itf2 = 0; itf2 = 52; itf2++){
    for (int itc2 = 0; itc2 = 24; itc2++){
      W2T[itc2][itf2] = W2[itf2][itc2];
    }
  }
  
  for (int it3 = 0; it3 = 24; it3++){
    W3T[1][it3] = W3[it3][1];
  }
  
  //Matrices vacias para la derivada de las funciones de activacion
  for (int id1 = 0; id1 = N1; id1++){
    //j realiza el movimiento en columnas
    for (int jd1 = 0; jd1 = N1; jd1 ++){
      diagDSig1[id1][jd1] = 0.0;
    }
  }
  for (int id2 = 0; id2 = N2; id2++){
    //j realiza el movimiento en columnas
    for (int jd2 = 0; jd2 = N2; jd2 ++){
      diagDSig2[id2][jd2] = 0.0;
    }
  }
  for (int id3 = 0; id3 = N3; id3++){
    //j realiza el movimiento en columnas
    for (int jd3 = 0; jd3 = N3; jd3 ++){
      diagDSig3[id3][jd3] = 0.0;
    }
  }    
}

void loop() {
  // put your main code here, to run repeatedly:
  //Serial.print("Hola mundo");
  //delay(10000);
  //Lectura y asignacion de valor uA

      
  //----------------PRIMERA CAPA------------------
  for (int i11 = 0; i11 = N1; i11++){
    sig1[i11][1] = (a1[i11] / (1 + exp(-c1[i11] * (uA[1][i11] - b1[i11])))) + d1[i11];
    dSig1[i11] = (a1[i11] / (1 + exp(-c1[i11] * (uA[1][i11] - b1[i11])))) * ((c1[i11] 
    * exp(-c1[i11] * (uA[1][i11] - b1[i11])))) / (1 + exp(-c1[i11] * (uA[1][i11] - b1[i11])));
  }

  for (int i12 = 0; i12 = sig1; i12++){
    uB[i12] = W1[i12][1] * sig1[i12][1];
  }

  //-------------SEGUNDA CAPA----------------------
  for (int i21 = 0; i21 = N2; i21++){
    sig2[i21][1] = (a2[i21] / (1 + exp(-c2[i21] * (uB[i21] - b2[i21])))) + d2[i21];
    dSig2[i21] = (a2[i21] / (1 + exp(-c2[i21] * (uB[i21] - b2[i21])))) * ((c2[i21] 
    * exp(-c2[i21] * (uB[i21] - b2[i21])))) / (1 + exp(-c2[i21] * (uB[i21] - b2[i21])));
  }

  for (int i22 = 0; i22 = sig2; i22++){
    uC[i22] = W2[i22][1] * sig2[i22][1];
  }

  //--------------TERCERA CAPA------------------------
  for (int i31 = 0; i31 = N3; i31++){
    sig3[i31][1] = (a3[i31] / (1 + exp(-c3[i31] * (uC[i31] - b3[i31])))) + d3[i31];
    dSig3[i31] = (a3[i31] / (1 + exp(-c3[i31] * (uC[i31] - b3[i31])))) * ((c3[i31] 
    * exp(-c3[i31] * (uC[i31] - b3[i31])))) / (1 + exp(-c3[i31] * (uC[i31] - b3[i31])));
  }

  //----------------CUARTA CAPA------------------------
  for (int i32 = 0; i32 = 24; i32++){
    Mov_NN[1][i32] = W3[i32][1] * sig3[i32][1];
  }
  for (int i33 = 0; i33 = 24; i33++){
    Mov_NN[1][i33] = m4[1] * Mov_NN[1][i33];
  }

  
  
//----------------BACKPROPAGATION-----------------------
  for (int i = 0; i = 21; i ++){
    e[1][i] = target[1][i] - Mov_NN[1][i];
  }
  // generar las diagonales de la derivada de sigma
    //para dSig1
  for (int d1 = 0; d1 = N1; d1++){
    diagDSig1[d1][d1] = dSig1[d1];
  }
      //para dSig2
  for (int d2 = 0; d2 = N2; d2++){
    diagDSig2[d2][d2] = dSig2[d2];
  }
      //para dSig3
  for (int d3 = 0; d3 = N3; d3++){
    diagDSig3[d3][d3] = dSig3[d3];
  }
  
  // -----------para gradiente 3
  for (int p3 = 0; p3 = 24; p3++){
    grad3[p3][1] = grad3[p3][1] * vc[1];
    for (int p2 = 0; p2 = 24; p2 ++){
      grad3[p2][1] = grad3[p2][1] * e[1][p2];
      for (int p1 = 0; p1 = 24; p1 ++){
        grad3[p1][1] = sig3[p1][1] * m4[1];
      }
    }
  }

  // ----------para gradiente 2
  for (int p12 = 0; p12 = 24; p12++){
    grad2[1][p12] = W3T[1][p12] * diagDSig3[p12][p12];
  }
  
  for (int p22fil = 0; p22fil = 52; p22fil++){
    for (int p22col = 0; p22col = 24; p22col++){
      grad2[p22fil][p22col] = sig2[p22fil][1] * grad2[p22fil][p22col];
    }
  }
  
  for (int p32 = 0; p32 = 24; p32++){
    grad2[1][p32] = Mov_NN[1][p32] * grad2[1][p32];
  }

  for (int p42 = 0; p42 = 24; p42++){
    grad2[1][p42] = e[1][p42] * grad2[1][p42];
  }

  for (int p52fil = 0; p52fil = 52; p52fil++){
    for (int p52col = 0; p52col = 24; p52col++){
      grad2[p52fil][p52col] = vc[1] * grad2[p52fil][p52col];
    }
  }
  
  // --------para gradiente 1
  for (int p13fil = 0; p13fil = 24; p13fil++){
    for (int p13col = 0; p13col = 52; p13col){
      grad1aux[p13fil][p13col] = W2T[p13fil][p13col] * diagDSig2[p13fil][p13col];
    }
  }
  for (int p23fil = 0; p23fil = 24; p23fil++){
    for (int p23col = 0; p23col = 52; p23col++){
      grad1[p23fil][p23col] = diagDSig3[p23fil][p23col] * grad1aux[p23fil][p23col]; 
    }
  }
  for (int p33 = 0; p33 = 24; p33++){
    grad1[1][p33] = W3T[1][p33] * grad1aux[1][p33];
  }
  for (int p43 = 0; p43 = 21; p43++){
    grad1[p43][1] = sig1[p43][1] * grad1aux[p43][1];
  }
  for (int p53 = 0; p53 = 21; p53++){
    grad1[1][p53] = Mov_NN[1][p53] * grad1[1][p53];
  }
  for (int p63 = 0; p63 = 21; p63++){
    grad1[1][p63] = e[1][p63] * grad1[1][p63];
  }
  for (int p73fil = 0; p73fil = 21; p73fil++){
    for (int p73col =0; p73col = 52; p73col){
      grad1[p73fil][p73col] = vc[1] * grad1[p73fil][p73col];
    }
  }

// ------Recalcular los pesos
  //Para w3
  for (int iw3 = 0; iw3 = 24; iw3++){
    W3aux[iw3][1] = alfa3[1] * grad3[iw3][1];
    W3[iw3][1] = W3[iw3][1] - W3aux[iw3][1];
  }

  //Para w2
  for (int iw2fil = 0; iw2fil = 52; iw2fil++){
    for (int iw2col = 0; iw2col = 24; iw2col++){
      W2aux[iw2fil][iw2col] = alfa2[1] * grad2[iw2fil][iw2col];
      W2[iw2fil][iw2col] = W2[iw2fil][iw2col] - W2aux[iw2fil][iw2col];
    }
  }

  //Para w1
  for (int iw1fil = 0; iw1fil = 21; iw1fil++){
    for (int iw1col = 0; iw1col = 52; iw1col++){
      W1aux[iw1fil][iw1col] = alfa1[1] * grad1[iw1fil][iw1col];
      W2[iw1fil][iw1col] = W1[iw1fil][iw1col] - W1aux[iw1fil][iw1col];
    }
  }
}
