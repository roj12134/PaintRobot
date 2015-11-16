
opengl('save','software')
mdl_puma560
L1=Link([0 0 0 deg2rad(90) 0])
L2=Link([0 0 0.35 deg2rad(0) 0])
L3=Link([0 0.2 0.001 deg2rad(-90) 0])
L4=Link([0 0.35 0 deg2rad(90) 0])
L5=Link([0 0 0 deg2rad(-90) 0])
L6=Link([0 0 0.05 0 0])
L1.offset = deg2rad(180)
L6.offset = deg2rad(0)
% L2.offset = deg2rad(45)
% L3.offset = deg2rad(-135)

figure
Brazo = SerialLink([L1, L2, L3, L4, L5, L6]);
Brazo.plot([deg2rad(0) deg2rad(0) deg2rad(0) deg2rad(0) deg2rad(0) deg2rad(0)], 'workspace', [-0.5 0.5 -0.5 0.5 -0.1 0.5]);


T = Brazo.ikine6s(transl([-0.2, 0.2, 0.0]));
for t = 1:1:6
    T(t) = rad2deg(T(t));
end
T

trayectorias = [];

Home = Brazo.fkine([0 0 0 0 0 0]);
inicio = ctraj(Home,transl(0,0.15,0.1)*trotz(deg2rad(-90)),[0:0.1:1]); 
% trayectorias = [trayectorias;Brazo.ikine6s(inicio)];  
Puntos = []
for t1=1:1:40
    for t2=1:1:40
        if(t2<30)
            Puntos(t1,t2) = 1
        else
            Puntos(t1,t2) = 0
        end
    end
end

resolucion = 160;
largoLinea = 4;
PInicio = [];
PFinal = [];
analizando = 0;
contador = 0;
[filas,columnas] = size(Puntos)
primero = 1;
for fila = 1:1:filas
    for columna = 1:1:columnas
        if (analizando == 0)
            if (Puntos(fila,columna)==1)
                PInicio = [(columna-80)/400,(-(fila-80)/400)+0.2];
                PInicio
                fila
                columna
                contador = contador +1;
                analizando = 1;
            end
        else
            if (Puntos(fila,columna)==1)
                contador = contador + 1;
            else
                if(contador>4)
                    if(primero == 1)
                        trayectoria = ctraj(Home,transl(PInicio(1,1),0.21,PInicio(1,2))*trotz(deg2rad(-90)),[0:0.1:1]); 
                        trayectorias = [trayectorias;Brazo.ikine6s(trayectoria)]; 
                        primero = 0;
                    else
                        trayectoria = ctraj(transl(PFinal(1,1),0.20,PFinal(1,2))*trotz(deg2rad(-90)),transl(PInicio(1,1),0.21,PInicio(1,2))*trotz(deg2rad(-90)),[0:0.1:1]); 
                        trayectorias = [trayectorias;Brazo.ikine6s(trayectoria)]; 
                    end
                    PFinal = [(columna-80)/400,(-(fila-80)/400)+0.2];                   
                    PFinal
                    fila
                    columna     
                    trayectoria = ctraj(transl(PInicio(1,1),0.21,PInicio(1,2))*trotz(deg2rad(-90)),transl(PFinal(1,1),0.21,PFinal(1,2))*trotz(deg2rad(-90)),[0:0.1:1]); 
                    trayectorias = [trayectorias;Brazo.ikine6s(trayectoria)]; 
                    trayectoria = ctraj(transl(PFinal(1,1),0.21,PFinal(1,2))*trotz(deg2rad(-90)),transl(PFinal(1,1),0.20,PFinal(1,2))*trotz(deg2rad(-90)),[0:0.1:1]); 
                    trayectorias = [trayectorias;Brazo.ikine6s(trayectoria)]; 
                    
                    contador = 0;
                    analizando = 0;
                else
                    contador = 0;
                    analizando = 0;
                end
            end
        end
    end
end

% Se visualizan la traslacion x-y-z del manipulador
Brazo.plot(trayectorias,'workspace',[-0.5 0.5 -0 0.5 -0 0.8])
