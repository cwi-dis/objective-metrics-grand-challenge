function [local_feats] = compute_features(attA, attB, idA, idB, searchSize)

%%% Local features
local_feats = nan(size(attA,1), 21);
parfor i = 1:size(attA,1)
    
    % Get data
    dataA = attA(idA(i,1:searchSize), :);
    dataB = attB(idB(i,1:searchSize), :);
    
    geoA = dataA(:, 1:3);
    texA = dataA(:, 4:6);
    
    geoB = dataB(:, 1:3);
    texB = dataB(:, 4:6);
    
    % Principal components of reference data (new orthonormal basis)
    covMatrixA = cov(geoA,1); % Covariance matrix on reference data
    if sum(~isfinite(covMatrixA(:))) >= 1
        eigvecsA = nan(3,3);
    else
        [eigvecsA, ~] = pcacov(covMatrixA); % Eigen decomposition on reference data
        if size(eigvecsA, 2) ~= 3
            eigvecsA = nan(3,3);
        end
    end
    
    % Project reference and distorted data onto the new orthonormal basis
    geoA_prA = (geoA - nanmean(geoA,1))*eigvecsA;
    geoB_prA = (geoB - nanmean(geoA,1))*eigvecsA;

    % Mean
    meanA = nanmean([geoA_prA, texA],1);
    meanB = nanmean([geoB_prA, texB],1);

    % Deviation from mean
    devmeanA = [geoA_prA, texA] - meanA;
    devmeanB = [geoB_prA, texB] - meanB;
    
    % Variance
    varA = nanmean(devmeanA.^2, 1);
    varB = nanmean(devmeanB.^2, 1);
    
    % Covariance    
    covAB = mean(devmeanA.*devmeanB);

    % Append features
    local_feats(i,:) = [geoA_prA(1,:), ...  % 1-3
                    geoB_prA(1,:), ...      % 4-6
                    varA, ...               % 7-12
                    varB, ...               % 13-18
                    covAB(:,1:3), ...       % 19-21
                    ];        
                
end
