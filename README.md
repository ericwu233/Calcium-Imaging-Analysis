# Calcium-Imaging-Analysis
Analyze calcium imaging videos and extract intensity and velocity information

#Updated Feb. 28, 2018. GUI for velocity calculation updated.
1.	Eyeball the video and annotate the reversal periods.
2.	Convert the image stack generated by ImageJ into a .tif format file.
3.	Open Matlab, add the “Beta_funtion_analysis” folder and the subfolders to path.
4.	Enter command “setup_proof_reading_0”. Select the target .tif file.
5.	Enter the period for processing (either the whole video or the period of interest according to the reversal annotation), after Matlab finishes loading the video. The strat frame needs to be no smaller than 1.
6.	A merged GFP/RFP picture will be shown for checking the channel alignment. If the alignment is not ideal, enter command “Alignment”. RFP channel will be shifted based on the mean shift value of the first 30 frames. The adjusted GFP/RFP mergence will then be shown. 
# The alignment command may go wrong if the original panels have been well aligned. 
7.	Enter “Stage_velocity”. Select the folder of the image stack. The stage position will be read into [xpos, ypos]. 
8.	Enter command “proof_reading(imagelist,[],filename,istart,iend,1,1)”
-Select a ROI and click on “track neuron”, the program will track the bright region throughout the selected period.
-Check frame by frame whether ROI resides on the right spot of the neuron of interest. If not, reposition the ROI and click on “track neuron” again. The program will track the neuron based on the corrected position throughout the rest frames. Continue on frame-by-frame proof reading until the end of the period for analysis. If the neuron of interest is out of sight in some frames, set the ROI in a background position in these frames until the neuron reappears in sight. Select the neuron, click on “track neuron” and move on proof-reading. Take down the related frame numbers and exclude these out-of-sight frames in later analysis.
-Click on “signal plot” to visualize the GFP and RFP signals along the period. #important, the bar must be dragged to the end before plotting and the plotting must be done before exporting data.
-Click on “export data” to export the ratio and signal data.
-If doing multi-neuron imaging, drag the progress bar to the beginning, select anther neuron of interest, track it and proof-read the tracking through.
#######################################################################
# To extract the velocity data, at least two neurons need to be annotated
#######################################################################
9.	After annotating one neuron and exporting the data, click on “Ant neuron” to save the position as anterior reference. Click on “Post neuron” after annotating and exporting a posterior one to save it as posterior reference. Click on “Calculate velocity” to calculate and export the velocity as “Real_velocity”. A smoothened curve will be displayed. 
10.	Revise the velocity plot according to the eyeballed reversal annotation. Removing outlines and smoothening may be required.
#######################################################################
