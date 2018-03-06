button = length(questdlg('Load new data?','','Yes (TIF)','Yes (MAT) ','No', 'Yes (TIF)') ) ;

if button == 10
    
    [filename, pathname] = uigetfile({'*.mat'});
    load([pathname filename]);

elseif button == 9

    do_dialog = 1;

    if do_dialog

        if exist('pathname', 'var')
            
            try
                
                if isdir(pathname)
                
                    cd(pathname);
                
                end
                
            end
            
        end

        [filename, pathname]  = uigetfile({'*.tif'});

        fname = [pathname filename];

        %load the nd2 data

        if ~exist('data','var')
            
            data=bfopen(fname);
        
        end

        [num_series, num]=size(data);

        imagelist=data{num_series,1};

        [m,n]=size(imagelist{1,1});

        img_stack=zeros(m,n,length(imagelist));

        %if ~exist('calibration_matrix_green','var')

        %   disp('Please load green calibration matrix');

        %   [filename,pathname]  = uigetfile({'*.mat'});

        %   f_calibration_green=[pathname filename];

        %   load(f_calibration_green);
        % end

        for i=1:size(img_stack,3)

            img_stack(:,:,i)=imagelist{i,1};

        end

        if ~exist('frames','var')
            
            frames = input('Please enter start and end frames for analyzing the data:','s');
            frames = str2num(frames);
        
        end

        istart = frames(1);
        iend = frames(2); 

        numframes=iend-istart+1; 

        %number of time series

    end

    [imagelist_r, imagelist_g] = split_two_screens(imagelist);
   
    %%Read labels to get stage postion
%     %%integrated file loses the stage information in frame labels
%     xpos = zeros(numframes,1);
%     ypos = zeros(numframes,1);
%     StageInfo = imfinfo(fname);
%     for i = istart:iend
%         FrameTag = char(StageInfo(i).UnknownTags(2).Value);                   %read in Info.info field. Shown in ASCII in Matlab.
%         FrameTag = regexprep(FrameTag,'\0','');                               %remove blanks
%         FrameTag_split = strsplit(FrameTag,'pos=');
%         xtmp = strsplit(char(FrameTag_split(2)),',');
%         ytmp = strsplit(char(FrameTag_split(3)),',');
%         xpos(i+1) = str2num(char(xtmp(1)));
%         ypos(i+1) = str2num(char(ytmp(1)));       
%     end

end
figure; 
imshowpair(imagelist_g{1,1}, imagelist_r{1,1});