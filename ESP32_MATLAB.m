clc; clear; close all;

instrfind
delete(instrfind)
clear all

% Seri port ayarlarý - COM3'ü kendi portunla deðiþtir
s = serial("COM3", "BaudRate", 115200);
fopen(s);

numReadings = 200;
angle = nan(1, numReadings);
mesafe = nan(1, numReadings);

% Canlý çizim için figure ve polarplot'u önceden oluþtur
figure;
set(gcf, 'WindowState', 'maximized');
h = polarplot(NaN, NaN, 'o');
title('Radar tracks');
hold on;

count = 0;
while count < numReadings
    line1 = fgetl(s);
    line2 = fgetl(s);
    line3 = fgetl(s);
    line4 = fgetl(s);

    % --- 1. okuma: line1 + line2 ---
    ang = NaN;
    dist = NaN;

    parts = strsplit(line1, ':');
    if length(parts) >= 2
        if contains(parts{1}, "angle")
            ang = str2double(parts{2});
        else
            dist = str2double(parts{2});
        end
    end

    parts = strsplit(line2, ':');
    if length(parts) >= 2
        if contains(parts{1}, "angle")
            ang = str2double(parts{2});
        else
            dist = str2double(parts{2});
        end
    end

    if ~isnan(dist) && ~isnan(ang) && dist > 0 && count < numReadings
        count = count + 1;
        mesafe(count) = dist;
        angle(count) = ang;

        % Canlý güncelleme
        h.ThetaData = deg2rad(angle(1:count));
        h.RData = mesafe(1:count);
        drawnow;
    end

    % --- 2. okuma: line3 + line4 ---
    ang = NaN;
    dist = NaN;

    parts = strsplit(line3, ':');
    if length(parts) >= 2
        if contains(parts{1}, "angle")
            ang = str2double(parts{2});
        else
            dist = str2double(parts{2});
        end
    end

    parts = strsplit(line4, ':');
    if length(parts) >= 2
        if contains(parts{1}, "angle")
            ang = str2double(parts{2});
        else
            dist = str2double(parts{2});
        end
    end

    if ~isnan(dist) && ~isnan(ang) && dist > 0 && count < numReadings
        count = count + 1;
        mesafe(count) = dist;
        angle(count) = ang;

        % Canlý güncelleme
        h.ThetaData = deg2rad(angle(1:count));
        h.RData = mesafe(1:count);
        drawnow;
    end
end

fclose(s);
delete(s);
clear s;