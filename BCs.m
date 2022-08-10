clc; clear; close all;
format compact; 
%Uinf = 34.6221019004;
Uinf = 1;
Re = 936000;
nu = Uinf/Re;
L = 1;
% nu = 3.698942e-5;
% Re_check = Uinf/nu;

omegaFarLow = Uinf*L
omegaFarHigh = 10*omegaFarLow

omegaFarAverage = mean([omegaFarLow, omegaFarHigh]);


kFarLow = 1e-5 * Uinf^2 / Re
kFarHigh = 0.1 * Uinf^2 / Re
kFarAverag = mean([kFarLow, kFarHigh]);

omegaWallHill = 10 * 6 * nu / (0.075 * (8e-6)^2)
omegaWallTop = 10 * 6 * nu / (0.075 * (0.90905-0.871885)^2)