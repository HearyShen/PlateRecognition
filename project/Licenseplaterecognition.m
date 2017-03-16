function varargout = Licenseplaterecognition(varargin)
% LICENSEPLATERECOGNITION M-file for Licenseplaterecognition.fig
%      LICENSEPLATERECOGNITION, by itself, creates a new LICENSEPLATERECOGNITION or raises the existing
%      singleton*.
%
%      H = LICENSEPLATERECOGNITION returns the handle to a new LICENSEPLATERECOGNITION or the handle to
%      the existing singleton*.
%
%      LICENSEPLATERECOGNITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LICENSEPLATERECOGNITION.M with the given input arguments.
%
%      LICENSEPLATERECOGNITION('Property','Value',...) creates a new LICENSEPLATERECOGNITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Licenseplaterecognition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Licenseplaterecognition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Licenseplaterecognition

% Last Modified by GUIDE v2.5 30-Dec-2016 20:54:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Licenseplaterecognition_OpeningFcn, ...
                   'gui_OutputFcn',  @Licenseplaterecognition_OutputFcn, ...
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


% --- Executes just before Licenseplaterecognition is made visible.
function Licenseplaterecognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Licenseplaterecognition (see VARARGIN)

% Choose default command line output for Licenseplaterecognition
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Licenseplaterecognition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Licenseplaterecognition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btn_load.
function btn_load_Callback(hObject, eventdata, handles)
% hObject    handle to btn_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global in;                  %定义一个全局变量in
[filename, filepath] = uigetfile('*.jpg','选择图片');
url_Img = strcat(filepath, filename);
in=imread(url_Img);             %读取图像
axes(handles.axes1);        %使用第一个axes
cla(handles.axes1,'reset');
cla(handles.axes2,'reset');
cla(handles.axes3,'reset');
cla(handles.axes4,'reset');
cla(handles.axes5,'reset');
cla(handles.axes6,'reset');
cla(handles.axes7,'reset');
cla(handles.axes8,'reset');
cla(handles.axes9,'reset');
cla(handles.axes10,'reset');
cla(handles.axes11,'reset');
cla(handles.text4,'reset');
cla(handles.text5,'reset');
cla(handles.text6,'reset');
cla(handles.text7,'reset');
cla(handles.text8,'reset');
cla(handles.text9,'reset');
cla(handles.text10,'reset');
imshow(in);                 %显示图像

% --- Executes on button press in btn_recognize.
function btn_recognize_Callback(hObject, eventdata, handles)
% hObject    handle to btn_recognize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global in;                  %定义一个全局变量in
I_raw = in;
%%
%%%%%%%%%%%%%% 原始图像预处理 %%%%%%%%%%%%%%%%

I_Proced = preProcRawImg(I_raw);

%%
%%%%%%%%%%%%%% 定位裁剪车牌图像 %%%%%%%%%%%%%%%%

I_plateRaw = getPlateImg(I_Proced, I_raw);

%%
%%%%%%%%%%%%%% 车牌图像预处理 %%%%%%%%%%%%%%%%

I_plateProced = preProcPlateImg(I_plateRaw);

%%
%%%%%%%%%%%%%% 车牌文字裁切 %%%%%%%%%%%%%%%%
% 寻找连续有文字的块，若长度大于某阈值，则认为该块有两个字符组成，需要分割

[word1, word2, word3, word4, word5, word6, word7] = partitionWords( I_plateProced );

%%
%%%%%%%%%%%%%% 文字识别 %%%%%%%%%%%%%%%%

Code = recognizeWords( word1, word2, word3, word4, word5, word6, word7 );

%%
axes(handles.axes2);        %使用第二个axes
imshow(I_Proced);
axes(handles.axes3);        %使用第三个axes 
imshow(I_plateRaw);
axes(handles.axes4);        %使用第四个axes 
imshow(I_plateProced);

axes(handles.axes5);        %使用第五个axes 
imshow(word1);
axes(handles.axes6);        %使用第六个axes 
imshow(word2);
axes(handles.axes7);        %使用第七个axes 
imshow(word3);
axes(handles.axes8);        %使用第八个axes 
imshow(word4);
axes(handles.axes9);        %使用第九个axes 
imshow(word5);
axes(handles.axes10);        %使用第十个axes 
imshow(word6);
axes(handles.axes11);        %使用第十一个axes
imshow(word7);

set(handles.text4,'string',Code(1));
set(handles.text5,'string',Code(3));
set(handles.text6,'string',Code(5));
set(handles.text7,'string',Code(7));
set(handles.text8,'string',Code(9));
set(handles.text9,'string',Code(11));
set(handles.text10,'string',Code(13));
