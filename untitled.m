
% Universidad del valle de Guatemala 
% Geovanni Rojas Mazariegos 12134 
% Proyecto Final
% Paint Robot
% 17 Noviembre 2015

%Previo a iniciar limpiaremos la pantalla y 
% el valor de las variables. 
clc 
clear

scrsz = get(groot,'ScreenSize');
f = figure('Visible','off','Name','Paint Robot','NumberTitle','off','Position',[1 1 scrsz(3) scrsz(4)],'MenuBar', 'none');
   
btn = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
        'Position', [20 20 50 20],...
        'Callback', @);      
    
    
f.Visible = 'on';

