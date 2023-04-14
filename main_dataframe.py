#Este archivo a diferencia del mainv3 crea un dataframe con los datos del sujeto
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import scipy as scipy
from scipy.fft import fft, fftfreq
from scipy.signal import butter, lfilter, filtfilt
from scipy.integrate import cumulative_trapezoid, quad, trapz
import math

t=[]

for i in range(14999):
    t.append(i)

df = pd.DataFrame(columns = ['FFT1','FFT2','FFT3','FFT4','FFT5','FFT6','FFT7', 'target'])

#Leer archivo txt y convertir a csv

#cambiar el nombre del archivo que se leera
data = pd.read_csv(r'C:\Users\hugo1\OneDrive\Documentos\Estancia Silla\datos 15 seg\18-11-22\Karla_Fuera.txt')
#cambiar el nombre del archivo de como se guardara
# data.to_csv(r'C:\Users\hugo1\OneDrive\Documentos\Estancia Silla\datos 15 seg\18-11-22\Emma_Abajo.txt', index = None)

#Nombrar columnas de dataframe
data.columns = ["EMG"]

#Eliminar offset de la señal
zeros = (data["EMG"][data["EMG"] != 0])
N = np.size(zeros)
offset = zeros - np.mean(zeros)
offset_list = np.array(offset.values.tolist())

emgmax = max(offset_list)
emgst = []
for i in offset_list:
    emgst.append(i/emgmax)

#Aplicar filtro digital tipo notch (bandstop) para senal de 60
b,a = scipy.signal.butter(4,[62, 65],btype = 'bandstop', analog = False, output = 'ba', fs = 1000)
filtered60 = filtfilt(b,a,offset)

#Aplicar filtro digital tipo notch (bandstop) para senal de 120
b2,a2 = scipy.signal.butter(4, [125, 128], btype = 'bandstop', analog = False, output = 'ba', fs = 1000)
filtered120 = filtfilt(b2, a2, filtered60)

#Aplicar FFT
N = np.size(zeros)
fs = 1000
T = 1/fs
yf = fft(filtered120)
xf = fftfreq(N, T)[:N//2]

yf_list = list(np.abs(yf[0:N//2]))
xf_list = list(xf)

seplist = np.size(xf_list) // 7

sepfft = [0, seplist, seplist*2, seplist*3, seplist*4, seplist*5, seplist*6]
integralslist = []

for n in sepfft:
    integral = trapz(yf_list[n:n+seplist], xf_list[n:n+seplist])
    integralslist.append(integral)
    # plt.figure()
    # plt.plot(xf_list[n:n+seplist], yf_list[n:n+seplist])
    # plt.show()

df2 = pd.DataFrame([[integralslist[0], integralslist[1], integralslist[2], integralslist[3], integralslist[4], integralslist[5], integralslist[6], 'afuera']], columns = ['FFT1','FFT2','FFT3','FFT4','FFT5','FFT6','FFT7', 'target'])
df.append(df2)
