%this script plots prominence plots for spontaneous data

clear
mouse = 'D:\Share\Dropbox (Rutgers SAS)\GCaMP6f spont and tone reward\150609am GC6-emx 4-6 spont\GC6f_emx_04\';
%mouse = 'C:\Users\margolis\Desktop\pupil test\early\';
cd([mouse]); 
load('Ca.mat')

%this step creates a matrix with trials in rows, frames in columns, and
%rois in z axis

for roi = 1:30;
    for trial_num = 1:size(Ca.Ch0, 2);
        for col_num = 1:size(Ca.Ch0{roi, trial_num}, 2);
            session_keeper(trial_num, col_num, roi) = Ca.Ch0{roi, trial_num}(1, col_num);
        end
    end
end




t = linspace(0, 2047/100, 2047);

%this step calculates findpeaks for the lick trials. The results are stored
%in a cell array with rows corresponding to trials and colums corresponding
%to roi. 

for trial_l = 1:size(Ca.Ch0, 2);
    if nansum(session_keeper(trial_l, :, 1)) == 0;
        
    else
        for rois = 1:30;
            [peakValues_l, peakLocations_l, widths_l, prominences_l] = findpeaks(session_keeper(trial_l, :, rois), t);
            peakValues_l_keep(trial_l, rois) = {peakValues_l};
            peakLocations_l_keep(trial_l, rois) = {peakLocations_l};
            widths_l_keep(trial_l, rois) = {widths_l};
            prominences_l_keep(trial_l, rois) = {prominences_l};
        end
    end
end


figure

for trial_lp = 1:size(Ca.Ch0, 2);
    for plot_l = 1:30;
        plot(cell2mat(widths_l_keep(trial_lp, plot_l)), cell2mat(prominences_l_keep(trial_lp, plot_l)), '.');
        hold on
    end
end

axis([0 1 0 60])
title('Thy1 GC6s (thy1gc 2)')
xlabel('peak width (s)')
ylabel('prominence (df/f)')

%now create a single vector of all peaks. This uses the quantify_peaks
%function which I wrote and stored with this file. 

[prominences_l_accum , widths_l_accum] = quantify_peaks(prominences_l_keep , widths_l_keep);

num_l_peaks = size(prominences_l_accum, 2)


%this portion changes widths greater than 0.02 to NaN

prominences_l_accum_thresh = prominences_l_accum;
for search = 1:size(widths_l_accum, 2);
    if widths_l_accum(1, search) > 0.2;
        prominences_l_accum_thresh(1, search) = NaN;
    else
    end
end



%this portion calculates a threshold for prominent peaks, here it is 5 *
%the standard deviation of the prominences_l_accum. It uses one threshold
%for lick and no lick trials. 

thresh = mean(prominences_l_accum) + (5*(std(prominences_l_accum)));

%this portion calculates the number of width thresholded prominences
%greater than the height threshold.

num_prom_l_peaks_thresh = nansum(prominences_l_accum_thresh > thresh)

