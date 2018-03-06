%Combining the stage infomation and ROI movement to calculate the real
%speed. 
%Multiple ROIs and raise the same problem as the original ImageJ plugin.
%Only single ROI would be used. Therefore the direction of the velocity needs
%to be annotated manually. 
%Parameters from Taizo's R script
%  63x 0.1 um/pix? 4xbin 
%  scale<-0.1*4
%  10x obj, 0.63?
%  scale<-0.63*4
%  16x obj
%  scale<-0.39375*4
%  measuring showed actualy its about 0.47.? check if it change
%  scale<-0.47*4
%  seems not better than 0.39....
%  40x obj
%  scale<-0.1575*4

% Update Feb. 28, 2018
% 1.Called by GUI proof_reading_v2
% 2.Use two neurons to determine the direction

function [real_velocity] = Real_speed_cal(istart, iend, ant_neuron, post_neuron, filename) 
%
global xpos;
global ypos;                                                               %call global variants stage position info xpos and ypos from StageInfo.m

scale = 0.1575*4;
frames = iend - istart +1;
real_velocity = zeros(frames,1);
Stage_v_vec = zeros(frames,2);
ROI_v_vec = zeros(frames,2);
real_v_vec = zeros(frames,2);
P2A_vec = zeros(frames,2);

%Process Stage info (xpos[], ypos[])
for i = 2:frames
    Stage_v_vec(i,1) = xpos(istart +i -1)-xpos(istart +i -2 );
    Stage_v_vec(i,2) = ypos(istart +i -1)-ypos(istart +i -2 );
    
    ROI_v_vec(i,1)  = ant_neuron(i,1)-ant_neuron(i-1,1); 
    ROI_v_vec(i,2) = ant_neuron(i,2)-ant_neuron(i-1,2);
    
    real_v_vec(i,1) = ROI_v_vec(i,1)*scale - Stage_v_vec(i,1);
    real_v_vec(i,2) = ROI_v_vec(i,2)*scale - Stage_v_vec(i,2);
    
    P2A_vec(i-1,1) = ant_neuron(i-1,1) - post_neuron(i-1,1);  %posterior to anterior direction 
    P2A_vec(i-1,2) = ant_neuron(i-1,2) - post_neuron(i-1,2);
    
    direction = 1;
    if ((P2A_vec(i-1,1)*real_v_vec(i,1) + P2A_vec(i-1,2)*real_v_vec(i,2)) <0) %angle > pi/2. viewed as backward movement.
        direction = -1;
    end
    real_velocity(i) = sqrt(real_v_vec(i,1)^2 + real_v_vec(i,2)^2) * direction;
end

filetag = strsplit(char(filename),'.tif');
filetag = filetag(1);
csvwrite(strcat(char(filetag),'_velocity.csv'),real_velocity);
return;
