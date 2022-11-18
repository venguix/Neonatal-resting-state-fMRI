% INPUTS
in_folder=['/Users/vicenteenguix/Desktop/QA_test'];%input data folder
% Data format example: QA_realtime_data > sub-3401966 > AP_dicom > dicom files inside
id=(['3401966']); %patient ID
pe='AP'; %Phase encoding direction AP '-j' or PA 'j' 

% RUN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(in_folder) 
subject=['sub-' id];
input=[subject filesep pe filesep subject '_' pe '_bold.nii'];
system(['mkdir ' subject]);
system(['mkdir ' subject filesep pe]);

output=[subject filesep pe '/cross_realignRS'];
filename=[subject filesep pe '/outliers_.txt'];%outliers
mFD_all=[];

% dcm2niix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
in=[pe '_dicom'];
%cmd=(['dcm2niix -f %i_bold_' pe ' ' subject filesep in]); 
cmd=(['dcm2niix -f %i_' pe '_bold ' subject filesep in]);
system(cmd)

% Move files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cmd2=['mv ' subject filesep in filesep id '_' pe '_bold.nii ' input ]
system(cmd2)

input2=input(1:end-4)
cmd2=['mv ' subject filesep in filesep id '_' pe '_bold.json ' input2 '.json' ]
system(cmd2)

% Cross-realignment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mcflirt_cmd=['mcflirt -in ' input ' -out ' output ' -sinc_final -refvol 0 -smooth 0 -plots'];%-smooth 1 by default
system(mcflirt_cmd)

% Save results
clc
cd([subject filesep pe]);
options.motionparameters='cross_realignRS.par';
[FD,motion_detrended]=framewiseDisplacement(options);
save('FD_power.1D','FD','-ascii')
save('cross_realignRS_detrend.par','motion_detrended','-ascii')
mFD=mean(FD)
save('meanFD_power.1D','mFD','-ascii');

FD_maximum=max(FD); %variable F_max is for the maximum FD allowed (threshold)
save('maxFD.1D','FD_maximum','-ascii');

save('FD_vector.1D','FD','-ascii');

% plots
f = figure('visible','off');
subplot(3,1,1),hold on
plot(motion_detrended(:,1),'-b')
plot(motion_detrended(:,2),'-g')
plot(motion_detrended(:,3),'-r')
legend('x','y','z')
title('Estimated rotation (radians)')

subplot(3,1,2), hold on
plot(motion_detrended(:,4),'-b')
plot(motion_detrended(:,5),'-g')
plot(motion_detrended(:,6),'-r')
legend('x','y','z')
title('Estimated translation (mm)')

subplot(3,1,3),
plot(FD,'-b'),title('Framewise Displacement'),legend('FD')
saveas(gcf,'FD.png')