function [refList,stimuli] = get_lists(pathInPcloudsRef, pathInPcloudsDis)
refStimuli_ = dir(pathInPcloudsRef);
refStimuli = refStimuli_(~ismember({refStimuli_.name},{'.', '..', '.DS_Store'}));
refContents = {refStimuli.name}';

stimuli_ = dir(pathInPcloudsDis);
stimuli = stimuli_(~ismember({stimuli_.name},{'.', '..', '.DS_Store'}));
stimuli = {stimuli.name}';

refList = cell(size(stimuli));
for i = 1:length(stimuli)
    tmp = strsplit(stimuli{i}(1:end-4), '_'); % remove extension 
    refList{i} = refContents{startsWith(refContents, tmp{1})};
end
end
