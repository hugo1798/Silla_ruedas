clear all
clc
%Se toman las transformadas
file = csvread("dataEMGtargetnum.csv");
 
FFT1 = file(2,1);
FFT2 = file(2,2);
FFT3 = file(2,3);
FFT4 = file(2,4);
FFT5 = file(2,5);
FFT6 = file(2,6);
FFT7 = file(2,7);
target = file(2,8);

s1=num2str(round(FFT1 + 1e8));
s2=num2str(round(FFT2 + 1e8));
s3=num2str(round(FFT3 + 1e8));
s4=num2str(round(FFT4 + 1e8));
s5=num2str(round(FFT5 + 1e8));
s6=num2str(round(FFT6 + 1e8));
s7=num2str(round(FFT7 + 1e8));

S=strcat('A',s1)%,'B',s2,'C',s3,'D',s4,'E',s5,'F',s6,'G',s7)
%Comunicacion del arduino
arduino = serialport("COM9", 115200);
fopen(arduino);
A = readline(arduino);

%para corroborar que si se convirtio todo
while(A ~= "1")
    %envio de informacion a arduino
    write(arduino, S, 'string');
    pause(0.01)
    %que llega del arduino a matlab
    A = readline(arduino)
    %para romper el while y corroborar que llego bien la informacion
    b = strfind(A, "174446160")
    if (b == 1)
        break
    end
end

fclose(arduino);



% 
% pause(5)
% A = readline(arduino)
% A = readline(arduino)
% A = readline(arduino)
% A = readline(arduino)
% A = readline(arduino)
% write(arduino, S, "string");
% pause(5);
% configureTerminator(arduino,"CR/LF");
% fopen(arduino);
% write(arduino,S,'uint16');
% pause(1)
% flush(arduino);
% write(arduino, S, "uint8")
% write(arduino, S, "uint8")
% % write(arduino, S, "string")
% % write(arduino, S, "string")
% % write(arduino, S, "string")
% % write(arduino, S, "string")
% % write(arduino, S, "string")
% % write(arduino, S, "string")
% % write(arduino, S, "string")
% % write(arduino, S, "string")
% % write(arduino, S, "string")
% arduino.UserData = struct("Data", [], "Count", 1);
% configureCallback(arduino, "terminator", @readData)
% 
% function data = readData(src, ~)
% 
% % Read the ASCII data from the serialport object.
%     data = readline(src)
% 
% % Convert the string data to numeric type and save it in the UserData
% % property of the serialport object.
%     src.UserData.Data(end+1) = str2double(data)
% 
% % Update the Count value of the serialport object.
%     src.UserData.Count = src.UserData.Count + 1;
% 
% % If 1001 data points have been collected from the Arduino, switch off the
% % callbacks and plot the data.
%     if src.UserData.Count > 1001
%         configureCallback(src, "off");
%     end
% end
% % % sprintf("%d", S);
% % fopen(arduino);
% % write(arduino, S, "uint32");
% % fprintf(arduino, S);
% % % arduino.Timeout = 15;
% % % A = read(arduino, 1, "uint8")
% % 
% % % fprintf(arduino, S);
% % % pause(1)
% % A=readline(arduino)
% % A=readline(arduino)
% % A=readline(arduino)
% % A=readline(arduino)
% % 
% % 
% % clear arduino