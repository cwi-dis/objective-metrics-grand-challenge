function [lcpointpca,predictors_name] = feature_extraction(pathInPcloudsDis,pathInPcloudsRef)
    %% Initializations
    pathOut = './mat/objective_scores/';
    %% Run metric
    % Get lists
    [orgList, degList] = get_list_ICIP(pathInPcloudsDis, pathInPcloudsRef);
    numStimuli = size(degList,1);
    stimulus = cell(numStimuli,1);
    lcpointpca = zeros(numStimuli,40);
    for i = 1:numStimuli
        fprintf('Stimulus: %s\n', degList{i});
        filenameRef = strcat(pathInPcloudsRef, orgList{i});
        filenameDis = strcat(pathInPcloudsDis, degList{i});
        [lcpointpca_, predictors_name] = lc_pointpca(filenameRef,filenameDis);
        lcpointpca(i,:) = lcpointpca_';
        stimulus{i} = degList{i};
    end
    if ~exist(pathOut, 'dir')
        mkdir(pathOut);
    end
    lcpointpca = lcpointpca';
    save_name = [pathOut,'lcpointpca_feature.mat'];
    save(save_name , 'lcpointpca','predictors_name','stimulus')
    end
