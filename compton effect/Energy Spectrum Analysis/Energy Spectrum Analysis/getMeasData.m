function [calib, params, data] = getMeasData(filePath)
format long
calib = []; %Array with the calibration data
params = []; %Array with the coefficients A, B and C for scale conversion
data = []; %Array with the scattering spectrum data
fid = fopen(filePath, 'r');

for i = 1:9
    fgetl(fid);
end

for i = 1:3
    line = fgetl(fid);
    line = erase(line, '\par');
    line = strsplit(line, '\\tab ');
    line = str2double(line);
    calib = [calib; line];
end

fgetl(fid);
line = fgetl(fid);
line = erase(line, '\par');
line = strsplit(line, '\\tab ');
line = str2double(line);
params = [params; line];

for i = 1:3
    fgetl(fid);
end

line = fgetl(fid);

while(line ~= '}')
    line = erase(line, '\par');
    line = strsplit(line, '\\tab ');
    line = str2double(line);
    data = [data; line];
    line = fgetl(fid);
end

fclose(fid);
end