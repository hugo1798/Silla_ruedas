
import pandas as pd
import numpy as np
import scipy as scipy
from scipy.fft import fft, fftfreq
from scipy.signal import butter, lfilter, filtfilt
from scipy.integrate import cumulative_trapezoid, quad, trapz
import os
import re

#generamos nuestro vector de tiempo
t=[]

for i in range(14999):
    t.append(i)

#generamos nuestra base del df
df = pd.DataFrame(columns = ['FFT1','FFT2','FFT3','FFT4','FFT5','FFT6','FFT7', 'target'])

#establecemos la direccion de donde se tomaran los archivos
directory_path = r'C:\Users\hugo1\OneDrive\Documentos\Estancia Silla\data'

#se genera el bucle para iterar sobre todos los arhivos de captura
for filename in os.listdir(directory_path):
    f = os.path.join(directory_path, filename)
    # Leer archivo txt
    data = pd.read_csv(f)

    # Nombrar columnas de dataframe
    data.columns = ["EMG"]

    #Inicializamos todas nuestras variables
    zeros = 0
    N = 0
    offset = 0
    offset_list = []
    b = 0
    a = 0
    b2 = 0
    a2 = 0
    filtered60 = 0
    filtered120 = 0
    yf = 0
    xf = 0
    yf_list = []
    xf_list = []
    trgt = ''

    #Buscamos palabras clave para establecer nuestro target en el df
    #Dividimos el nombre del archivo quitando signos de puntacion
    res = re.findall(r'\w+', filename)
    #Dividimos el nombre del archivo eliminando los underscores
    nous = res[0].split('_')
    #Colocamos una etiqueta segun el elemento encontrado dentro del nombre del archivo
    if 'Abajo' in nous:
        trgt = 3
    elif 'Arriba' in nous:
        trgt = 1
    if 'Adentro' in nous:
        trgt = 4
    if 'Afuera' in nous:
        trgt = 2

    # Eliminar offset de la señal
    zeros = (data["EMG"][data["EMG"] != 0])
    N = np.size(zeros)
    offset = zeros - np.mean(zeros)
    offset_list = np.array(offset.values.tolist())

    # Aplicar filtro digital tipo notch (bandstop) para senal de 60
    b, a = scipy.signal.butter(4, [62, 65], btype='bandstop', analog=False, output='ba', fs=1000)
    filtered60 = filtfilt(b, a, offset)

    # Aplicar filtro digital tipo notch (bandstop) para senal de 120
    b2, a2 = scipy.signal.butter(4, [125, 128], btype='bandstop', analog=False, output='ba', fs=1000)
    filtered120 = filtfilt(b2, a2, filtered60)

    # Aplicar FFT
    N = np.size(zeros)
    fs = 1000
    T = 1 / fs
    yf = fft(filtered120)
    xf = fftfreq(N, T)[:N // 2]

    #Hacemos una lista con los resultados de fft
    yf_list = list(np.abs(yf[0:N // 2]))
    xf_list = list(xf)

    #Establecemos la separacion de la fft
    seplist = np.size(xf_list) // 7

    sepfft = [0, seplist, seplist * 2, seplist * 3, seplist * 4, seplist * 5, seplist * 6]
    integralslist = []

    #Aplicamos la integral a cada uno de los segmentos de la fft
    for n in sepfft:
        integral = trapz(yf_list[n:n + seplist], xf_list[n:n + seplist])
        integralslist.append(integral)

    #Generamos un df auxiliar
    df2 = pd.DataFrame([[integralslist[0], integralslist[1], integralslist[2], integralslist[3], integralslist[4],
                         integralslist[5], integralslist[6], trgt]],
                       columns=['FFT1', 'FFT2', 'FFT3', 'FFT4', 'FFT5', 'FFT6', 'FFT7', 'target'])
    #Agregamos el df auxiliar al df base
    df = df.append(df2)

df.to_csv(r'C:\Users\hugo1\OneDrive\Documentos\dataEMG.csv', index = False)
