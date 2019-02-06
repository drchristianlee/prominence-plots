function [prominences_l_accum , widths_l_accum] = quantify_peaks(prominences_l_keep , widths_l_keep)
%function [no_lick_peaks, no_lick_widths, lick_peaks, lick_widths] = quantify_peaks(prominences_l_keep, widths_l_keep, prominences_nl_keep, widths_nl_keep)

for lick_trials = 1:size(prominences_l_keep, 1);
    if lick_trials == 1;
        prominences_l_accum = [];
        widths_l_accum = []
        prominences_l_accum = prominences_l_keep{1, 1};
        widths_l_accum = widths_l_keep{1, 1};
        for count = 2:30;
            prominences_l_accum = horzcat(prominences_l_accum , prominences_l_keep{1, count});
            widths_l_accum = horzcat(widths_l_accum , widths_l_keep{1, count});
        end
    else
        for count2 = 1:30;
            prominences_l_accum = horzcat(prominences_l_accum, (prominences_l_keep{lick_trials, count2}));
            widths_l_accum = horzcat(widths_l_accum, (widths_l_keep{lick_trials, count2}));
        end
    end
end
