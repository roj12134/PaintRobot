
function varargout = GUI2(varargin)
% GUI2 MATLAB code for GUI2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI2

% Last Modified by GUIDE v2.5 17-Nov-2015 22:56:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI2 is made visible.
function GUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI2 (see VARARGIN)

% Choose default command line output for GUI2
handles.output = hObject;

%Load Camera view 
axes(handles.axes1);
global vid
vid=videoinput('macvideo');
hImage=image(zeros(720,720,3),'Parent',handles.axes1);
preview(vid,hImage);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI2 wait for user response (see UIRESUME)
% uiwait(handles.f);


% --- Outputs from this function are returned to the command line.
function varargout = GUI2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in takePhotoButton.
function takePhotoButton_Callback(hObject, eventdata, handles)
% hObject    handle to takePhotoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid; % Variable global
imageTake = getsnapshot(vid); % Save Photo
imwrite(imageTake, 'takedPhoto.tif');
I = imread('takedPhoto.tif');
I2 = imcrop(I,[0 0 720 720]);
imwrite(I2, 'takedPhoto.tif');

%Resize the image to fit in Draw con 2.5 mm de efector final
I4 = imread('takedPhoto.tif'); %Load photo
resizeImage = imresize(I4, [160 160]); %2.5 mm de efector final
imwrite(resizeImage, 'resizePhoto.tif');

%Load Preview
I3 = imread('resizePhoto.tif'); %Load photo
axes(handles.axes2);
image(I3);

%Load Draw Preview
I5 = iread('resizePhoto.tif','grey'); %Load photo
blackNwhite = istretch(I5); % Matrix
%Copy/paste matrix
mati = [];
for x=1:1:160
    for y=1:1:160
        mati(x,y) = blackNwhite(x,y);
    end
end

imwrite(mati, 'finalPhoto.tif'); % Save photo in file
axes(handles.axes3);
imshow(mati)

% 
% L1=Link([0 0 0 deg2rad(90) 0])
% L2=Link([0 0 0.35 deg2rad(0) 0])
% L3=Link([0 0.2 0.001 deg2rad(-90) 0])
% L4=Link([0 0.35 0 deg2rad(90) 0])
% L5=Link([0 0 0 deg2rad(-90) 0])
% L6=Link([0 0 0.05 0 0])
% L1.offset = deg2rad(180)
% L6.offset = deg2rad(0)
% % L2.offset = deg2rad(45)
% % L3.offset = deg2rad(-135)
% 
% figure
% Brazo = SerialLink([L1, L2, L3, L4, L5, L6]);
% % Brazo.plot([deg2rad(0) deg2rad(0) deg2rad(0) deg2rad(0) deg2rad(0) deg2rad(0)], 'workspace', [-0.5 0.5 -0.5 0.5 -0.1 0.5]);
% % 
% 
% trayectorias = [];
% 
% Home = Brazo.fkine([0 0 0 0 0 0]);
% inicio = ctraj(Home,transl(0,0.15,0.1)*trotz(deg2rad(-90)),[0:0.1:1]); 
% % trayectorias = [trayectorias;Brazo.ikine6s(inicio)];  
% Puntos = mati
% for t1=1:1:40
%     for t2=1:1:40
%         if(t2<30)
%             Puntos(t1,t2) = 1
%         else
%             Puntos(t1,t2) = 0
%         end
%     end
% end
% 
% resolucion = 160;
% largoLinea = 4;
% PInicio = [];
% PFinal = [];
% analizando = 0;
% contador = 0;
% [filas,columnas] = size(Puntos)
% primero = 1;
% for fila = 1:1:filas
%     for columna = 1:1:columnas
%         if (analizando == 0)
%             if (Puntos(fila,columna)==1)
%                 PInicio = [(columna-80)/400,(-(fila-80)/400)+0.2];
% %                 PInicio
% %                 fila
% %                 columna
%                 contador = contador +1;
%                 analizando = 1;
%             end
%         else
%             if (Puntos(fila,columna)==1)
%                 contador = contador + 1;
%             else
%                 if(contador>2)
%                     if(primero == 1)
%                         trayectoria = ctraj(Home,transl(PInicio(1,1),0.21,PInicio(1,2))*trotz(deg2rad(-90)),[0:0.1:1]); 
%                         trayectorias = [trayectorias;Brazo.ikine6s(trayectoria)]; 
%                         primero = 0;
%                     else
%                         trayectoria = ctraj(transl(PFinal(1,1),0.20,PFinal(1,2))*trotz(deg2rad(-90)),transl(PInicio(1,1),0.21,PInicio(1,2))*trotz(deg2rad(-90)),[0:0.1:1]); 
%                         trayectorias = [trayectorias;Brazo.ikine6s(trayectoria)]; 
%                     end
%                     PFinal = [(columna-80)/400,(-(fila-80)/400)+0.2];                   
% %                     PFinal
% %                     fila
% %                     columna     
%                     trayectoria = ctraj(transl(PInicio(1,1),0.21,PInicio(1,2))*trotz(deg2rad(-90)),transl(PFinal(1,1),0.21,PFinal(1,2))*trotz(deg2rad(-90)),[0:0.1:1]); 
%                     trayectorias = [trayectorias;Brazo.ikine6s(trayectoria)]; 
%                     trayectoria = ctraj(transl(PFinal(1,1),0.21,PFinal(1,2))*trotz(deg2rad(-90)),transl(PFinal(1,1),0.20,PFinal(1,2))*trotz(deg2rad(-90)),[0:0.1:1]); 
%                     trayectorias = [trayectorias;Brazo.ikine6s(trayectoria)]; 
%                     
%                     contador = 0;
%                     analizando = 0;
%                 else
%                     contador = 0;
%                     analizando = 0;
%                 end
%             end
%         end
%     end
% end
% 
% % Se visualizan la traslacion x-y-z del manipulador
% figure
% Brazo.plot(trayectorias,'workspace',[-0.5 0.5 -0 0.5 -0 0.8])

% just dialog that we are done capturing
% warndlg('Listo!');



% --- Executes on button press in drawButton.
function drawButton_Callback(hObject, eventdata, handles)
% hObject    handle to drawButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('GUI3.fig');



% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
