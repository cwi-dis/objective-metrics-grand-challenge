function [lcpointpca, predNames] = lc_pointpca(filenameRef, filenameDis, varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if isfolder(filenameRef) || isfolder(filenameDis)
    ME = MException('Dirinput', ...
        'Error: paths must point to single point clouds',str);
    throw(ME)
end

if size(varargin) < 3
    searchSize =  81;
    numPreds = 40;
end


% Initialization
lcpointpca = zeros(numPreds, 1);

% Load point clouds
pcloudInA = pcread(filenameRef);
pcloudInB = pcread(filenameDis);

% Point duplicate merging - NOTE that you remove normals, if exist
% fprintf('Point duplicate merging\n');
pcloudA = pc_duplicate_merging(pcloudInA);
pcloudB = pc_duplicate_merging(pcloudInB);

% Get attributes
% fprintf('Get attributes\n');
geoA = double(pcloudA.Location);
texA = double(rgb_to_yuv(pcloudA.Color));
geoB = double(pcloudB.Location);
texB = double(rgb_to_yuv(pcloudB.Color));

% Get neighbors
% fprintf('Get neighbors\n');
[idA, ~] = knnsearch(geoA, geoA, 'k', searchSize);  % A is the referenced point cloud 

% Correspondence
% fprintf('Correspondence\n');
[idAB, ~] = knnsearch(geoB, geoA, 'k', searchSize); %  finds the nearest neighbor in X (Dis) for each point in Y (Ref)

% Compute geometric features
% fprintf('Compute features\n');
[lfeats] = compute_features([geoA, texA], [geoB, texB], idA, idAB,  searchSize);

% Compute predictors
% fprintf('Compute predictors\n');
[preds, predNames] = compute_predictors(lfeats);

% Compute objective scores
% fprintf('Compute objective scores for geometry\n');
for p = 1:numPreds
    lcpointpca(p) = pool_across_samples(preds(:,p));
end
end

