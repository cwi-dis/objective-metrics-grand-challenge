function [refList,stimuli] = get_list_ICIP(pathInPcloudsDis, pathInPcloudsRef)
Refstimuli_ = dir(pathInPcloudsRef);
Refstimuli = Refstimuli_(~ismember({Refstimuli_.name},{'.', '..', '.DS_Store'}));
refContents = {Refstimuli.name}';
stimuli_ = dir(pathInPcloudsDis);
stimuli = stimuli_(~ismember({stimuli_.name},{'.', '..', '.DS_Store'}));
stimuli = {stimuli.name}';


refList = cell(size(stimuli));
for i = 1:length(stimuli)
    tmp = strsplit(stimuli{i}(1:end-4), '_'); %remove externsion 
    refList{i} = refContents{startsWith(refContents, tmp{1})};
end
end
