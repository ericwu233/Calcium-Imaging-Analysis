% Stage velocity vector
% Not called by proof_reading. Run separately in case of bugs.
function Stage_velocity()
tic
Video_dir = uigetdir(pwd(),'Pick a video stack');
FileList = dir(fullfile(Video_dir,'*tif'));
Video_dir;
FileName = {FileList.name};

stage_xpos= zeros(length(FileName),1);
stage_ypos = zeros(length(FileName),1);
real_velocity = 0;

for i = 0:(length(FileName)-1)
    FrameName = strcat(Video_dir,'\',num2str(i),'.tif');
    FrameInfo = imfinfo(FrameName);
    StageInfo = char(FrameInfo.UnknownTags(2).Value);
    StageInfo = regexprep(StageInfo,'\0','');
    StageInfo_split = strsplit(StageInfo,'pos=');
    xtmp = strsplit(char(StageInfo_split(2)),',');
    ytmp = strsplit(char(StageInfo_split(3)),',');
    stage_xpos(i+1) = str2num(char(xtmp(1)));
    stage_ypos(i+1) = str2num(char(ytmp(1)));
end

global xpos;
xpos = stage_xpos;
global ypos;
ypos = stage_ypos;
assignin('base','xpos',xpos);
assignin('base','ypos',ypos);

toc
return;

