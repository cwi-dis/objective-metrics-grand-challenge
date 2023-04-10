function [lcpointpca, predNames] = lc_pointpca(filenameOrg, filenameDeg, varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if isfolder(filenameOrg) || isfolder(filenameDeg)
    ME = MException('Dirinput', ...
        'Error: paths must point to single point clouds',str);
    throw(ME)
end

if size(varargin) < 3
    searchSize =  81;                  % [9, 25, 49, 81] % [0.01, 0.0075, 0.005]
    numPreds = 40;
    poolType = 'Mean';
end


% Initialization
lcpointpca = zeros(numPreds, 1);

% Load point clouds
pcloudInA = pcread(filenameOrg);
pcloudInB = pcread(filenameDeg);

% Point duplicate merging - NOTE that you remove normals, if exist
tic;
fprintf('Point duplicate merging\n');
% pcloudA = pc_duplicate_merging(pcloudInA);
% pcloudB = pc_duplicate_merging(pcloudInB);
pcloudA = pcloudInA;
pcloudB = pcloudInB;
toc;

% Get attributes
tic;
fprintf('Get attributes\n');
geoA = single(pcloudA.Location);
texA = single(rgb_to_yuv(pcloudA.Color));
geoB = single(pcloudB.Location);
texB = single(rgb_to_yuv(pcloudB.Color));
toc;

% Get neighbors
tic;
fprintf('Get neighbors\n');
[idA, distA] = knnsearch(geoA, geoA, 'k', searchSize);  % A is the referenced point cloud 
[~, distB] = knnsearch(geoB, geoB, 'k', searchSize);    % B is the distorted point cloud
toc;

% Correspondence
tic;
fprintf('Correspondence\n');
[idAB, ~] = knnsearch(geoB, geoA, 'k', searchSize); %  finds the nearest neighbor in X (Dis) for each point in Y (Ref)
toc;

% Compute geometric features
fprintf('Compute features\n');
tic;

[lfeats] = compute_features([geoA, texA], [geoB, texB], idA, idAB, distA, distB(idAB(:,1),:), searchSize);
toc;

% Compute predictors
fprintf('Compute predictors\n');
tic;
[preds, predNames] = compute_predictors(lfeats);
toc;

% Compute objective scores
fprintf('Compute objective scores for geometry\n');
tic;
for p = 1:numPreds
    lcpointpca(p) = pool_across_samples(preds(:,p), poolType);
end
toc;
end

