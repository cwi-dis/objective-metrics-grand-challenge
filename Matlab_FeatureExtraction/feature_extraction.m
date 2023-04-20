function feature_extraction(pathInPcloudsRef, pathInPcloudsDis)

% Initializations
pathOut = './mat/objective_scores/';
if ~exist(pathOut, 'dir')
    mkdir(pathOut);
end

% Extract features
[refList, disList] = get_lists(pathInPcloudsRef, pathInPcloudsDis);
numStimuli = size(disList,1);
lcpointpca = zeros(numStimuli,40);
for i = 1:numStimuli
    fprintf('Stimulus: %s\n', disList{i});
    filenameRef = strcat(pathInPcloudsRef, refList{i});
    filenameDis = strcat(pathInPcloudsDis, disList{i});
    [lcpointpca(i,:), predictors_name] = lc_pointpca(filenameRef,filenameDis);
end
stimuli = disList;

% Store features
save(strcat(pathOut,'lcpointpca_features.mat') , 'lcpointpca', 'predictors_name', 'stimuli')
