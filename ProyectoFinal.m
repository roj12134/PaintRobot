
% Universidad del valle de Guatemala 
% Geovanni Rojas Mazariegos 12134 
% Proyecto Final
% Paint Robot
% 17 Noviembre 2015

%Previo a iniciar limpiaremos la pantalla y 
% el valor de las variables. 

function main
    clc 
    clear
    %Create the form and GUI
    scrsz = get(groot,'ScreenSize');
    f = figure('Visible','off','Name','Paint Robot','NumberTitle','off','Position',[1 1 scrsz(3) scrsz(4)],'MenuBar', 'none');

    btn = uicontrol('Style', 'pushbutton', 'String', 'Take Photo',...
            'Position', [20 20 80 20],...
            'Callback', @takePhoto);      


    txt = uicontrol('Style','text',...
        'Position',[1100 20 120 20],...
        'String','Prueba');
    
    
    %Load Video 
    
    
        
    f.Visible = 'on';
    
    %**********************
    % Function of buttons 
    %**********************
    
    function takePhoto (source, callbackdata)
        txt.set('String','Hola')
    end 

end




