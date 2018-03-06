% Update Feb. 28, 2018
% GUI to compute the real velocity

function varargout = proof_reading_v2(varargin)

% Several inputs:
% 1. img_stack=varargin{1};
% 2. transformation_array=varargin{2};
% 3. filename=varargin{3};
% 4. istart=varargin{4};
% 5. iend=varargin{5};
% 6. neuron_number=varargin{6};
% 7. on_the_left=varargin{7};


% PROOF_READING_V2 MATLAB code for proof_reading_v2.fig
%      PROOF_READING_V2, by itself, creates a new PROOF_READING_V2 or raises the existing
%      singleton*.
%
%      H = PROOF_READING_V2 returns the handle to a new PROOF_READING_V2 or the handle to
%      the existing singleton*.
%
%      PROOF_READING_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROOF_READING_V2.M with the given input arguments.
%
%      PROOF_READING_V2('Property','Value,...) creates a new PROOF_READING_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before proof_reading_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to proof_reading_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help proof_reading_v2

% Last Modified by GUIDE v2.5 28-Feb-2016 15:47:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @proof_reading_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @proof_reading_v2_OutputFcn, ...
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

% --- Executes just before proof_reading_v2 is made visible.
function proof_reading_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to proof_reading_v2 (see VARARGIN)

% Choose default command line output for proof_reading_v2

handles.img_stack=varargin{1};
handles.transformation_array=varargin{2};
handles.filename=varargin{3};
handles.istart=varargin{4};
handles.iend=varargin{5};


[height,width]=size(handles.img_stack{1,1});
sections=length(handles.img_stack);
handles.image_width=width;
handles.image_height=height;
handles.image_depth=handles.iend-handles.istart+1;
handles.sections=sections;
% width=round(width*1.25);
% height=round(height*1.25);

set(hObject,'Units','pixels');
% set(handles.figure1, 'Position', [400 400 width height+45]);
% set(handles.slider1, 'Position', [0 2 width 18]);
% axes(handles.Image_axes);
handles.low=0;
handles.high=2000;
handles.tracking_threshold=100;

img=imagesc(handles.img_stack{handles.istart,1});
colormap(gray);

set(handles.Image_axes, 'Visible', 'off', 'Units', 'pixels', 'DataAspectRatio', [1 1 1]); % Aspect ratio as in real object
%'Position', [0 22 width height]);

set(handles.text1, 'Units','pixels'); % Title for figure
% set(handles.text1, 'Position',[0 22+height+2 width 18]);
% set(handles.text1, 'HorizontalAlignment','center');
set(handles.text1, 'String', strcat(num2str(handles.istart),'/',num2str(sections),'(',handles.filename,')'));

set(img,'ButtonDownFcn', 'proof_reading(''ButtonDown_Callback'',gcbo,[],guidata(gcbo))');

handles.neuron_number=varargin{6};
handles.colorset=hsv(handles.neuron_number);
handles.on_the_left = varargin{7}; % If signal for tracking is on the left side, assign on_the_left as 1, so that the signal for calculation on the right side is used; else, 0

% Overlap neuron position in RFP and GFP

if length(varargin)==8
    
    handles.neuronal_position=varargin{8};
    handles.isproofread=ones(handles.image_depth,1);
    
else
    
    handles.isproofread=zeros(handles.image_depth,1);
    handles.neuronal_position=cell(handles.iend-handles.istart+1,handles.neuron_number);

end

handles.F_thresh=[];
handles.F_sorted=[];
handles.neuronal_position_left=handles.neuronal_position;
% handles.signal=[];
% handles.signal_mirror=[];
handles.normalized_signal=[];
handles.ratio=[];

min_step=1/(handles.image_depth-1);
max_step=5*min_step;
set(handles.slider1, ...
    'Enable','on', ...
    'Min',1, ...
    'Max',handles.image_depth, ...
    'Value',1, ...
    'SliderStep', [min_step max_step]);

handles.frame_number=1;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes proof_reading_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = proof_reading_v2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PlotMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PlotMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.frame_number=round(get(hObject,'Value'));
set(handles.text1, 'String',strcat(num2str(handles.frame_number+handles.istart-1),'/',num2str(handles.sections),'(',handles.filename,')'));
axes(handles.Image_axes);
cla;
img=imagesc(handles.img_stack{handles.frame_number+handles.istart-1,1});
colormap(gray);

set(img,'ButtonDownFcn', 'proof_reading(''ButtonDown_Callback'',gcbo,[],guidata(gcbo))');

for j=1:handles.neuron_number
    if ~isempty(handles.neuronal_position{handles.frame_number,j})
        
        x=handles.neuronal_position{handles.frame_number,j}(1);
        y=handles.neuronal_position{handles.frame_number,j}(2);
        
        hold on;  
%         handles.points{j}=rectangle('Curvature',[1,1],'Position',[x-handles.r(j), y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor', 'g');
%         set(handles.points{j},'ButtonDownFcn', 'proof_reading_v2(''ButtonDownPoint_Callback'',gcbo,[],guidata(gcbo))');
%         
%         hold on; % Draw an ellipse for the mirror of ROI in RFP screen
%         rectangle('Curvature',[1,1],'Position',[x-handles.r(j)-handles.image_width/2, y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor', 'r');

        
        if handles.on_the_left == 0
            
            % Draw ROI in GCaMP screen on the right
            handles.points{j}=rectangle('Curvature',[1,1],'Position',[x-handles.r(j), y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor', 'g');
            set(handles.points{j},'ButtonDownFcn', 'proof_reading(''ButtonDownPoint_Callback'',gcbo,[],guidata(gcbo))');

            % Draw ROI in RFP screen on the left
            handles.points{j}=rectangle('Curvature',[1,1],'Position',[x-handles.r(j)-handles.image_width/2, y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor', 'r');
        
        else
            
            % Draw ROI in GCaMP screen on the right
            handles.points{j}=rectangle('Curvature',[1,1],'Position',[x-handles.r(j)+handles.image_width/2, y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor', 'g');            
            set(handles.points{j},'ButtonDownFcn', 'proof_reading(''ButtonDownPoint_Callback'',gcbo,[],guidata(gcbo))');

            % Draw ROI in RFP screen on the left
            handles.points{j}=rectangle('Curvature',[1,1],'Position',[x-handles.r(j), y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor', 'r');

        end
        
    else
        break;
    end
end

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% ----click on the axes to identify neuronal positions and update neuronal
% position in rest of the frames ------------------

function ButtonDown_Callback(hObject, eventdata, handles)

handles.isproofread(handles.frame_number)=1;
[x,y]=getcurpt(handles.Image_axes);

d_min=handles.image_height;

for k=1:handles.neuron_number
    distance=norm(handles.neuronal_position{handles.frame_number,k}-[x y]);
    if distance<d_min
        d_min=distance;
        idx=k;
    end
end

handles.neuronal_position{handles.frame_number,idx}(1)=x;
handles.neuronal_position{handles.frame_number,idx}(2)=y;

if ~isempty(handles.points{idx})
    delete(handles.points{idx});
end

axes(handles.Image_axes);

hold on;  

if handles.on_the_left == 0

    handles.points{idx}=rectangle('Curvature', [1 1],'Position',[x-handles.r(idx), y-handles.r(idx), 2*handles.r(idx), 2*handles.r(idx)],'EdgeColor', 'g');
    set(handles.points{idx},'ButtonDownFcn', 'proof_reading(''ButtonDownPoint_Callback'',gcbo,[],guidata(gcbo))');
    
    % Draw a circle for the mirror of ROI in RFP screen
    rectangle('Curvature',[1,1],'Position',[x-handles.r(idx)-handles.image_width/2, y-handles.r(idx), 2*handles.r(idx), 2*handles.r(idx)],'EdgeColor', 'r');

else
    
    handles.points{idx} = rectangle('Curvature',[1,1],'Position',[x-handles.r(idx), y-handles.r(idx), 2*handles.r(idx), 2*handles.r(idx)],'EdgeColor', 'r');
    set(handles.points{idx},'ButtonDownFcn', 'proof_reading(''ButtonDownPoint_Callback'',gcbo,[],guidata(gcbo))');
    rectangle('Curvature', [1 1],'Position',[x-handles.r(idx)+handles.image_width/2, y-handles.r(idx), 2*handles.r(idx), 2*handles.r(idx)],'EdgeColor', 'g');

end

guidata(hObject,handles);



% ----click on the axes to identify neuronal positions and update neuronal
% position in rest of the frames ------------------

function ButtonDownPoint_Callback(hObject, eventdata, handles)

handles.isproofread(handles.frame_number)=1;
[x,y]=getcurpt(handles.Image_axes);

d_min=handles.image_height;

for k=1:handles.neuron_number
    distance=norm(handles.neuronal_position{handles.frame_number,k}-[x y]);
    if distance<d_min
        d_min=distance;
        idx=k;
    end
end

handles.neuronal_position{handles.frame_number,idx}(1)=x;
handles.neuronal_position{handles.frame_number,idx}(2)=y;

delete(hObject);

axes(handles.Image_axes);
hold on;  

if handles.on_the_left == 0
    
    handles.points{idx}=rectangle('Curvature', [1 1],'Position',[x-handles.r(idx), y-handles.r(idx), 2*handles.r(idx), 2*handles.r(idx)],'EdgeColor', 'g');
    set(handles.points{idx},'ButtonDownFcn', 'proof_reading(''ButtonDownPoint_Callback'',gcbo,[],guidata(gcbo))');

    hObject=handles.points{idx};

    % Draw a circle for the mirror of ROI in RFP screen
    rectangle('Curvature',[1,1],'Position',[x-handles.r(idx)-handles.image_width/2, y-handles.r(idx), 2*handles.r(idx), 2*handles.r(idx)],'EdgeColor', 'r');
    
else
    
    handles.points{idx}= rectangle('Curvature',[1,1],'Position',[x-handles.r(idx), y-handles.r(idx), 2*handles.r(idx), 2*handles.r(idx)],'EdgeColor', 'r');
    set(handles.points{idx},'ButtonDownFcn', 'proof_reading(''ButtonDownPoint_Callback'',gcbo,[],guidata(gcbo))');
    hObject=handles.points{idx};

    % Draw a circle for the mirror of ROI in RFP screen
    rectangle('Curvature', [1 1],'Position',[x-handles.r(idx)+handles.image_width/2, y-handles.r(idx), 2*handles.r(idx), 2*handles.r(idx)],'EdgeColor', 'g');
    
end

guidata(hObject,handles);


% --------------------------------------------------------------------
function SaveMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn, savepathname]= uiputfile('*.mat', 'choose file to save', strcat(handles.filename, '_',num2str(handles.istart),'-',num2str(handles.iend),'.mat'));
if length(fn) > 1
    fnamemat = strcat(savepathname,fn);
    save(fnamemat);
end
    


% --------------------------------------------------------------------
function ImportMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to ImportMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ExportMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to ExportMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','signal',handles.signal);
assignin('base','signal_mirror',handles.signal_mirror);
assignin('base','normalized_signal',handles.normalized_signal);
assignin('base','dual_position_data',handles.neuronal_position);
assignin('base','ratio',handles.signal_GFPoverRFP);
assignin('base','points',handles.points);

neuron_position_data=zeros(handles.frame_number,2);
for i=1:length(neuron_position_data)
    neuron_position_data(i,:)=handles.neuronal_position{i,1};
end
assignin('base','neuron_position_data',neuron_position_data);
    


% --------------------------------------------------------------------
function ImageMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to ImageMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LUTMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to LUTMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer = inputdlg({'low','high'}, 'Cancel to clear previous', 1, ...
            {num2str(handles.low),num2str(handles.high)});
handles.low=str2double(answer{1});
handles.high=str2double(answer{2});
axes(handles.Image_axes);
cla;
img=imagesc(handles.img_stack{handles.frame_number+handles.istart-1,1});
colormap(gray);
set(img,'ButtonDownFcn', 'proof_reading(''ButtonDown_Callback'',gcbo,[],guidata(gcbo))');

guidata(hObject,handles);



% --------------------------------------------------------------------
function TrackingMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to TrackingMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.neuronal_position{1,1})||(handles.frame_number==1)
    
    axes(handles.Image_axes);
    text(10,10,'identify neuronal position','Color','r');
    j=1;

    while j<=handles.neuron_number
        
        rect=getrect; % Selects the rectangle in the axes; [xmin ymin width height]
        rect=round(rect);
        
        l=rect(3);
        w=rect(4);
        x=rect(1)+l/2;
        y=rect(2)+w/2;
        
        handles.neuronal_position{1,j}=[x y]; % Center of the rectangle ROI
        handles.r(j)=max(l,w)/2;
        
        hold on; % Draw an ellipse for the ROI in RFP screen
        handles.points{j}=rectangle('Curvature',[1,1],'Position',[x-handles.r(j), y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor',handles.colorset(j,:));
        set(handles.points{j},'ButtonDownFcn', 'proof_reading(''ButtonDownPoint_Callback'',gcbo,[],guidata(gcbo))');
        
        hold on; % Draw an ellipse for the mirror of ROI in GFP screen
        handles.points{j}=rectangle('Curvature',[1,1],'Position',[x-handles.r(j)-handles.image_width/2, y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor',handles.colorset(j,:));

        j=j+1;
        
    end
   
end

iend=max(handles.image_depth,handles.frame_number);

% Tracking algorithm

for j=handles.frame_number+1:iend

    if ~handles.isproofread(j)
        for k=1:handles.neuron_number
            radius = 4*handles.r(k);
            if isempty(handles.transformation_array)
                handles.neuronal_position{j,k}=update_neuron_position(handles.img_stack{j+handles.istart-1,1},...
                                                                  handles.neuronal_position{j-1,k},radius,handles.tracking_threshold);
                shift_update = pdist([handles.neuronal_position{j,k}; handles.neuronal_position{j-1,k}]);
                radius = min(shift_update, 4*handles.r(k));
                disp(['radius ' num2str(radius) '\n']);
                disp(['shift ' num2str(shift_update) '\n']);
            else
                shift=handles.transformation_array{j-1+handles.istart-1,2};
                u=handles.neuronal_position{j-1,k}(1)-shift(1);
                v=handles.neuronal_position{j-1,k}(2)-shift(2);
                T=handles.transformation_array{j+handles.istart-1,1};
                [xm,ym] = tformfwd(T,u,v);
                handles.neuronal_position{j,k}(1)=xm;
                handles.neuronal_position{j,k}(2)=ym;
                shift_new=handles.transformation_array{j,2};
                handles.neuronal_position{j,k}=handles.neuronal_position{j,k}+shift_new(1:2);
            end
        end
            
    end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function Tracking_thresholdItemMenu_Callback(hObject, eventdata, handles)
% hObject    handle to Tracking_thresholdItemMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer = inputdlg({'tracking threshold'}, 'Cancel to clear previous', 1, ...
            {num2str(handles.tracking_threshold)});
        
handles.tracking_threshold=str2double(answer{1});
guidata(hObject,handles);
        


% --------------------------------------------------------------------
function PlotSignalMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PlotSignalMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if ~isempty(handles.neuronal_position{handles.frame_number,1})
% 
%     for k=1:handles.neuron_number
% 
%         GC=zeros(handles.frame_number,1);
%         GC_GoR=zeros(handles.frame_number,1);
% 
%         for j=1:handles.frame_number
% 
%             img=handles.img_stack{j+handles.istart-1,1};
% 
%             x=handles.neuronal_position{j,k}(1);
%             y=handles.neuronal_position{j,k}(2);
%             c_mask=circle_mask(handles.image_width,handles.image_height,x,y,handles.r(k));
%             img_bw=img(c_mask);
%             [GC(j), handles.F_sorted, handles.F_thresh]=calculate_intensity(img_bw);
% 
%             x_m=handles.neuronal_position{j,k}(1)+handles.image_width/2;
%             y_m=handles.neuronal_position{j,k}(2);
%             c_mask_m=circle_mask(handles.image_width,handles.image_height,x_m,y_m,handles.r(k)); 
%             img_bw_m=img(c_mask_m);
%             GC_m(j)=calculate_intensity(img_bw_m);
% 
%             GC_GoR(j)=GC_m(j)/GC(j);
% 
%         end
% 
%         handles.signal{k}=GC; % RFP signal
%         handles.signal_mirror{k}=GC_m; % GFP signal
%         handles.signal_GFPoverRFP{k}=GC_GoR; % GFP/RFP signal
% 
%         figure (1);
%         subplot(handles.neuron_number,1,k); 
%         plot(((1:handles.frame_number)+handles.istart-1),smooth(handles.signal_GFPoverRFP{k},1),'Color',handles.colorset(k,:));
%         xlabel('Frame number'); ylabel('GFP/RFP');
% 
%     end
% 
% guidata(hObject, handles);
% 
% end
if ~isempty(handles.neuronal_position{handles.frame_number, 1})

    background_percent = 1;
    subtract_logical = 1;
    GC = zeros(handles.frame_number, handles.neuron_number);
    GC_m=zeros(handles.frame_number, handles.neuron_number);
    GC_GoR=zeros(handles.frame_number, handles.neuron_number);
    GC_GoR_mean=zeros(handles.frame_number, handles.neuron_number);
    
    for k = 1:handles.neuron_number

    %     GC = zeros(handles.frame_number, 1); % GCaMP on the right screen
    %     GC_m = zeros(handles.frame_number, 1); % wCherry on the left screen
    %     GC_GoR=zeros(handles.frame_number, 1); % GCaMP/wCherry

        for j = 1:handles.frame_number

            % Get the image pixels and background on the signal screen,
            % which is on the right side as default
            img = handles.img_stack{j + handles.istart - 1, 1}; % Data format: uint16
            background = background_percent * median(median(img(:, handles.image_width/2+1:end))); % Median is less sensitive to deviation
    
            % Signal that is used for tracking
            x = handles.neuronal_position{j, k}(1) + handles.on_the_left * handles.image_width/2;
            y = handles.neuronal_position{j, k}(2);
            c_mask = uint16(circle_pixels(handles.image_width, handles.image_height, x, y, handles.r(k)))'; % ROI on the signal side
            c_shape = uint16(circle_pixels(handles.image_width, handles.image_height, x - handles.image_width/2, y, handles.r(k)))'; % Cell body shape defined by reference fluorescence
            
            % Extract ROI and subtract background
            img_bw = double(img .* c_mask - subtract_logical * background); % Negative values are all zero; Raise to double format so that the ratio can be more accurate
            img_shape = double(img .* c_shape - subtract_logical * background);
            img_shape_positive = img_shape > 0;
            
            % Normalize the signal with corresponding pixels
            ratio = img_bw(:, handles.image_width/2+1:end) ./ double(img(:, 1:handles.image_width/2));

    %         [GC(j), handles.F_sorted, handles.F_thresh] = calculate_intensity(img_bw);
            handles.neuronal_position_left{j, k}(1) = x - handles.on_the_left * handles.image_width/2;
            handles.neuronal_position_left{j, k}(2) = y;
    %         c_mask_m = circle_mask(handles.image_width,handles.image_height,x_m,y_m,handles.r(k)); 
    %         img_bw_m = img(c_mask_m);
    %         GC_m(j) = calculate_intensity(img_bw_m);

            % Ratio of GFP over RFP
            GC(j, k) = mean(mean(img_bw(img_bw>0)));
            GC_m(j, k) = mean(mean(img_shape(img_shape>0)));
            GC_GoR(j, k) = median(median(ratio(ratio>0)));
            GC_GoR_mean(j, k) = sum(sum(ratio))/sum(sum(img_shape_positive)); % Total positive ratio values on the signal side normalized by number of positive ratio values on the reference side

        end

        handles.signal{k}=GC; % GFP signal
        handles.signal_mirror{k}=GC_m; % RFP signal
        handles.signal_GFPoverRFP{k}=GC_GoR; % GFP/RFP signal

        figure (1);
        
        subplot(handles.neuron_number * 2, 1, 2 * k - 1); 
        plot(((1:handles.frame_number)+handles.istart-1), handles.signal{k}, 'g'); hold on;
        plot(((1:handles.frame_number)+handles.istart-1), handles.signal_mirror{k}, 'r');
        
        subplot(handles.neuron_number * 2, 1, 2 * k); 
        plot(((1:handles.frame_number)+handles.istart-1), handles.signal_GFPoverRFP{k}, 'k'); hold on;
        plot(((1:handles.frame_number)+handles.istart-1), GC_GoR_mean(:, k), 'k:');
        
        xlabel('Frame number'); ylabel('GFP/RFP');

    end

guidata(hObject, handles);

end

% --------------------------------------------------------------------
function PlotNSignalMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PlotNSignalMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.signal)
    for k=1:handles.neuron_number
        handles.normalized_signal{k}=(handles.signal{k}-min(handles.signal{k}))/min(handles.signal{k});
        figure (2);
        subplot(handles.neuron_number,1,k); 
        plot(((1:handles.frame_number)+handles.istart-1),smooth(handles.normalized_signal{k},30),'Color',handles.colorset(k,:));
        xlabel('frame'); ylabel('\delta F/F');
    end
end

guidata(hObject,handles);



% --------------------------------------------------------------------
function PlotRatioMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PlotRatioMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.neuron_number==2)&&(~isempty(handles.signal))
    handles.ratio=handles.signal{1}./(handles.signal{2}-0.18*handles.signal{1});
    normalized_ratio=(handles.ratio-min(handles.ratio))/min(handles.ratio);
    figure (3);  plot((1:handles.frame_number)+handles.istart-1,smoothts(normalized_ratio','e',30));
    xlabel('frame number'); ylabel('\delta R/R');
end

guidata(hObject,handles);


% --- Executes on button press in Track_neurons.
function Track_neurons_Callback(hObject, eventdata, handles)
% hObject    handle to Track_neurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.neuronal_position{1,1})||(handles.frame_number==1)
    
    axes(handles.Image_axes);
    text(10,10,'Identify neuron position','Color','w');
    j=1;

    while j<=handles.neuron_number
        
        rect=getrect; % Selects the rectangle in the axes; [xmin ymin width height]
        rect=round(rect);
        
        l=rect(3);
        w=rect(4);
        x=rect(1)+l/2;
        y=rect(2)+w/2;
        
        handles.neuronal_position{1,j}=[x y]; % Center of the rectangle ROI
        handles.r(j)=max(l,w)/2;
        
        hold on;
        
        if handles.on_the_left == 0
            
            % Draw ROI in GCaMP screen on the right
            handles.points{j}=rectangle('Curvature',[1,1],'Position',[x-handles.r(j), y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor', 'g');
            set(handles.points{j},'ButtonDownFcn', 'proof_reading(''ButtonDownPoint_Callback'',gcbo,[],guidata(gcbo))');

            % Draw ROI in RFP screen on the left
            handles.points{j}=rectangle('Curvature',[1,1],'Position',[x-handles.r(j)-handles.image_width/2, y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor', 'r');
        
        else
            
            % Draw ROI in GCaMP screen on the right
            handles.points{j}=rectangle('Curvature',[1,1],'Position',[x-handles.r(j)+handles.image_width/2, y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor', 'g');            
            set(handles.points{j},'ButtonDownFcn', 'proof_reading(''ButtonDownPoint_Callback'',gcbo,[],guidata(gcbo))');

            % Draw ROI in RFP screen on the left
            handles.points{j}=rectangle('Curvature',[1,1],'Position',[x-handles.r(j), y-handles.r(j), 2*handles.r(j), 2*handles.r(j)],'EdgeColor', 'r');

        end
        
        j=j+1;
        
    end
   
end

iend=max(handles.image_depth,handles.frame_number);

% Tracking algorithm
% for j=handles.frame_number+1:iend
%     
%     if ~handles.isproofread(j)
%         
%         for k=1:handles.neuron_number
%             
%             if isempty(handles.transformation_array)
%                 handles.neuronal_position{j,k}=update_neuron_position(handles.img_stack{j+handles.istart-1,1},...
%                                                                   handles.neuronal_position{j-1,k},4*handles.r(k),handles.tracking_threshold);
%             
%             else
%                 shift=handles.transformation_array{j-1+handles.istart-1,2};
%                 u=handles.neuronal_position{j-1,k}(1)-shift(1);
%                 v=handles.neuronal_position{j-1,k}(2)-shift(2);
%                 T=handles.transformation_array{j+handles.istart-1,1};
%                 [xm,ym] = tformfwd(T,u,v);
%                 handles.neuronal_position{j,k}(1)=xm;
%                 handles.neuronal_position{j,k}(2)=ym;
%                 shift_new=handles.transformation_array{j,2};
%                 handles.neuronal_position{j,k}=handles.neuronal_position{j,k}+shift_new(1:2);
%             
%             end
%             
%         end
%     
%     end
%     
% end


for j=handles.frame_number+1:iend

    if ~handles.isproofread(j)
        for k=1:handles.neuron_number
            radius = 2*handles.r(k);
            if isempty(handles.transformation_array)
                handles.neuronal_position{j,k}=update_neuron_position(handles.img_stack{j+handles.istart-1,1},...
                                                                  handles.neuronal_position{j-1,k},radius,handles.tracking_threshold);
                shift_update = pdist([handles.neuronal_position{j,k}; handles.neuronal_position{j-1,k}]);
                radius = min(shift_update, 4*handles.r(k));
%                 disp(['radius ' num2str(radius)]);
%                 disp(['shift ' num2str(shift_update)]);
            else
                shift=handles.transformation_array{j-1+handles.istart-1,2};
                u=handles.neuronal_position{j-1,k}(1)-shift(1);
                v=handles.neuronal_position{j-1,k}(2)-shift(2);
                T=handles.transformation_array{j+handles.istart-1,1};
                [xm,ym] = tformfwd(T,u,v);
                handles.neuronal_position{j,k}(1)=xm;
                handles.neuronal_position{j,k}(2)=ym;
                shift_new=handles.transformation_array{j,2};
                handles.neuronal_position{j,k}=handles.neuronal_position{j,k}+shift_new(1:2);
            end
        end
            
    end
end
guidata(hObject, handles);

% --- Executes on button press in Signal_plot.
function Signal_plot_Callback(hObject, eventdata, handles)
% hObject    handle to Signal_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.neuronal_position{handles.frame_number, 1})

    background_percent = 1;
    subtract_logical = 1;
    GC = zeros(handles.frame_number, handles.neuron_number);
    GC_m=zeros(handles.frame_number, handles.neuron_number);
    GC_GoR=zeros(handles.frame_number, handles.neuron_number);
    GC_GoR_mean=zeros(handles.frame_number, handles.neuron_number);
    
    for k = 1:handles.neuron_number

    %     GC = zeros(handles.frame_number, 1); % GCaMP on the right screen
    %     GC_m = zeros(handles.frame_number, 1); % wCherry on the left screen
    %     GC_GoR=zeros(handles.frame_number, 1); % GCaMP/wCherry

        for j = 1:handles.frame_number

            % Get the image pixels and background on the signal screen,
            % which is on the right side as default
            img = handles.img_stack{j + handles.istart - 1, 1}; % Data format: uint16
            background = background_percent * median(median(img(:, handles.image_width/2+1:end))); % Median is less sensitive to deviation
    
            % Signal that is used for tracking
            x = handles.neuronal_position{j, k}(1) + handles.on_the_left * handles.image_width/2;
            y = handles.neuronal_position{j, k}(2);
            c_mask = uint16(circle_pixels(handles.image_width, handles.image_height, x, y, handles.r(k)))'; % ROI on the signal side
            c_shape = uint16(circle_pixels(handles.image_width, handles.image_height, x - handles.image_width/2, y, handles.r(k)))'; % Cell body shape defined by reference fluorescence
            
            % Extract ROI and subtract background
            img_bw = double(img .* c_mask - subtract_logical * background); % Negative values are all zero; Raise to double format so that the ratio can be more accurate
            img_shape = double(img .* c_shape - subtract_logical * background);
            img_shape_positive = img_shape > 0;
            
            % Normalize the signal with corresponding pixels
            ratio = img_bw(:, handles.image_width/2+1:end) ./ double(img(:, 1:handles.image_width/2));

    %         [GC(j), handles.F_sorted, handles.F_thresh] = calculate_intensity(img_bw);
            handles.neuronal_position_left{j, k}(1) = x - handles.on_the_left * handles.image_width/2;
            handles.neuronal_position_left{j, k}(2) = y;
    %         c_mask_m = circle_mask(handles.image_width,handles.image_height,x_m,y_m,handles.r(k)); 
    %         img_bw_m = img(c_mask_m);
    %         GC_m(j) = calculate_intensity(img_bw_m);

            % Ratio of GFP over RFP
            GC(j, k) = mean(mean(img_bw(img_bw>0)));
            GC_m(j, k) = mean(mean(img_shape(img_shape>0)));
            GC_GoR(j, k) = median(median(ratio(ratio>0)));
            GC_GoR_mean(j, k) = sum(sum(ratio))/sum(sum(img_shape_positive)); % Total positive ratio values on the signal side normalized by number of positive ratio values on the reference side

        end

        handles.signal{k}=GC; % GFP signal
        handles.signal_mirror{k}=GC_m; % RFP signal
        handles.signal_GFPoverRFP{k}=GC_GoR; % GFP/RFP signal

        figure (1);
        
        subplot(handles.neuron_number * 2, 1, 2 * k - 1); 
        plot(((1:handles.frame_number)+handles.istart-1), handles.signal{k}, 'g'); hold on;
        plot(((1:handles.frame_number)+handles.istart-1), handles.signal_mirror{k}, 'r');
        
        subplot(handles.neuron_number * 2, 1, 2 * k); 
        plot(((1:handles.frame_number)+handles.istart-1), handles.signal_GFPoverRFP{k}, 'k'); hold on;
        plot(((1:handles.frame_number)+handles.istart-1), GC_GoR_mean(:, k), 'k:');
        
        xlabel('Frame number'); ylabel('GFP/RFP');

    end

guidata(hObject, handles);

end


function Threshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% answer = inputdlg({'Tracking threshold'}, 'Cancel to clear previous', 1, ...
%             {num2str(handles.tracking_threshold)});
%         
% handles.tracking_threshold=str2double(answer{1});

handles.tracking_threshold = str2double(get(hObject, 'String'));

thresh = ['Threshold chosen by user is ', num2str(handles.tracking_threshold), ' .'];
disp(thresh);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Threshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Track_neurons.
function Track_neurons_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Track_neurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Export_data.
function Export_data_Callback(hObject, eventdata, handles)
% hObject    handle to Export_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','signal',handles.signal);
assignin('base','signal_mirror',handles.signal_mirror);
assignin('base','normalized_signal',handles.normalized_signal);
assignin('base','dual_position_data',handles.neuronal_position);
assignin('base','ratio',handles.signal_GFPoverRFP);
assignin('base','points',handles.points);
assignin('base','F_thresh',handles.F_thresh);
assignin('base','F_sorted',handles.F_sorted);

handles.neuron_position_data=zeros(handles.frame_number,2);
for i=1:length(handles.neuron_position_data)
    handles.neuron_position_data(i,:)=handles.neuronal_position_left{i,1};
end
guidata(hObject,handles);
assignin('base','neuron_position_data',handles.neuron_position_data);
disp('Data exported\n');


% --- Executes on button press in Denote_Anterior_Neuron.
function Denote_Anterior_Neuron_Callback(hObject,eventdata,handles)
% hObject    handle to save annotated neuron as anterior one (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Anterior_neuron_position = zeros(handles.frame_number,2);
handles.Anterior_neuron_position = handles.neuron_position_data;
guidata(hObject,handles);
assignin('base','Anterior_neuron_position',handles.Anterior_neuron_position);
disp('Anterior neuron saved\n');

% --- Executes on button press in Denote_Posterior_Neuron.
function Denote_Posterior_Neuron_Callback(hObject, eventdata, handles)
% hObject    handle to Denote_Posterior_Neuron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Posterior_neuron_position = zeros(handles.frame_number,2);
handles.Posterior_neuron_position = handles.neuron_position_data;
guidata(hObject,handles);
assignin('base','Posterior_neuron_position',handles.Posterior_neuron_position);
disp('Posterior neuron saved\n');


% --- Executes on button press in Calculate_Velocity.
function Calculate_Velocity_Callback(hObject,eventdata,handles)
% hObject    handle to save annotated neuron as anterior one (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Velocity = Real_speed_cal(handles.istart, handles.iend, handles.Anterior_neuron_position, handles.Posterior_neuron_position, handles.filename);
assignin('base','Real_velocity',handles.Velocity);
smooth_v = smooth(handles.Velocity);
figure (2);
plot(1:length(handles.Velocity), smooth_v); hold on;
plot(1:length(handles.Velocity),0);
xlabel = ('frame number');
ylabel = ('Velocity (um/frame)');
