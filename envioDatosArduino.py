import pandas as pd
import serial

data = pd.read_csv(r'C:\Users\hugo1\Silla_ruedas\dataEMGtargetnum.csv')

columns_remove = ['7','Unnamed: 8','Unnamed: 9','Unnamed: 10','Unnamed: 11']
data_notrgt = data.drop(columns_remove, axis = 1)

u1 = list(data_notrgt.iloc[0])
u2 = list(data_notrgt.iloc[1])
u3 = list(data_notrgt.iloc[2])
target = list(data.iloc[0:24 , 7])

uA = u1 + u2 + u3

arduino = serial.Serial(port = 'COM3', baudrate = 115200, timeout = 0.1)

arduino.write(bytes(uA, 'utf-8'))

print(len(target))