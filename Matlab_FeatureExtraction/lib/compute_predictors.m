function [preds, predNames] = compute_predictors(lfeats)

predNames = {'t_mu_y'; 't_mu_u'; 't_mu_v'; ...
            't_var_y'; 't_var_u'; 't_var_v'; ...
            't_cov_y'; 't_cov_u'; 't_cov_v'; ...
            't_varsum'; ...
            't_omnivariance'; ...
            't_entropy'; ...
            'g_pB2pA'; ...
            'g_vAB2plA_x'; 'g_vAB2plA_y'; 'g_vAB2plA_z'; ...
            %'g_pA2cA'; ...
            %'g_pA2plA_x'; 
            'g_pA2plA_y'; 'g_pA2plA_z'; ...
            'g_pB2cA'; ...
            %'g_pB2plA_x'; 
            'g_pB2plA_y'; 'g_pB2plA_z'; ...
            'g_cB2cA';  ...
            %'g_cB2plA_x'; 
            'g_cB2plA_y'; 'g_cB2plA_z'; ...
            'g_var_x'; 'g_var_y'; 'g_var_z'; ...
            'g_cov_x'; 'g_cov_y'; 'g_cov_z'; ...
            %'g_varsum'; ...
            'g_omnivariance'; ...
            'g_entropy'; ...
            'g_anisotropy'; ...
            'g_planarity'; ...
            'g_linearity'; ...
            'g_surfaceVariation'; ...
            'g_sphericity'; ...
            %'g_asim_x'; 
            'g_asim_y'; ...
            %'g_asim_z'; ...
            'g_paralellity_x'; % 'g_paralellity_y';
            'g_paralellity_z';
%             'g_ad_localMeanRes'; 'g_rd_localMeanRes'; ...
%             'g_ad_localVarRes'; 'g_rd_localVarRes';...
%             'g_ad_globalMeanLocalMeanRes'; 'g_rd_globalMeanLocalMeanRes'; ...
%             'g_ad_globalVarLocalMeanRes'; 'g_rd_globalVarLocalMeanRes'; ...
%             'g_ad_globalMeanLocalVarRes'; 'g_rd_globalMeanLocalVarRes'; ...
%             'g_ad_globalVarLocalVarRes'; 'g_rd_globalVarLocalVarRes'; ...
            };
       

pA = lfeats(:,1:3);
pB = lfeats(:,4:6);
gmeanB = lfeats(:,7:9); % Geometric distorted centroid  % maybe wrong      
tmeanA = lfeats(:,10:12);
tmeanB = lfeats(:,13:15); 
gvarA = lfeats(:,16:18);   % maybe wrong      
gvarB = lfeats(:,22:24);   % maybe wrong
tvarA = lfeats(:,19:21);   % maybe wrong
tvarB = lfeats(:,25:27);   % maybe wrong
gcovAB = lfeats(:,28:30);
tcovAB = lfeats(:,31:33);
geigvecB_x = lfeats(:,34:36);
geigvecB_y = lfeats(:,37:39);
geigvecB_z = lfeats(:,40:42);

% gmeanLocDistA = lfeats(:,43);
% gvarLocDistA = lfeats(:,44);
% gmeanLocDistB = lfeats(:,45);
% gvarLocDistB = lfeats(:,46);

% gmeanMeanLocDistA = gfeats(1);
% gvarMeanLocDistA = gfeats(2);
% gmeanVarLocDistA = gfeats(3);
% gvarVarLocDistA = gfeats(4);
% gmeanMeanLocDistB = gfeats(5);
% gvarMeanLocDistB = gfeats(6);
% gmeanVarLocDistB = gfeats(7);
% gvarVarLocDistB = gfeats(8);


% Initialization
preds = nan(size(lfeats,1), 40);

%%% Textural predictors
% Relative difference mean
preds(:,1:3) = rel_diff(tmeanA, tmeanB);

% Relative difference variance
preds(:,4:6) = rel_diff(tvarA, tvarB);

% Relative difference covariance
preds(:,7:9) = abs(sqrt(tvarA).*sqrt(tvarB) - tcovAB)./(sqrt(tvarA).*sqrt(tvarB));
               
% Relative difference sum of variances
preds(:,10) = rel_diff(sum(tvarA,2), sum(tvarB,2));

% Relative difference ominvariance
preds(:,11) = rel_diff(prod(tvarA,2).^(1/3), prod(tvarB,2).^(1/3));

% Relative difference entropy
preds(:,12) = rel_diff(-sum(tvarA.*log(tvarA+eps),2), -sum(tvarB.*log(tvarB+eps),2));

%%% Geometric predictors
% Euclidean distance of distorted point from reference point (error vector)
preds(:,13) = sqrt(sum((pB - pA).^2,2));
% Projected distance of vector (between distorted and reference point) from reference planes
preds(:,14) = abs(dot(pB - pA, repmat([1,0,0], size(pA,1),1), 2));
preds(:,15) = abs(dot(pB - pA, repmat([0,1,0], size(pA,1),1), 2));
preds(:,16) = abs(dot(pB - pA, repmat([0,0,1], size(pA,1),1), 2));
% % Euclidean distance of reference point from reference centroid
% preds(:,5) = sqrt(sum(pA.^2,2));
% Projected distances of reference point from reference planes
preds(:,17:18) = abs(pA(:,2:3));
% Euclidean distance of distorted point from reference centroid
preds(:,19) = sqrt(sum(pB.^2,2));
% Projected distances of distorted point from reference planes
preds(:,20:21) = abs(pB(:,2:3));

% Euclidean distance of distorted centroid from reference centroid
preds(:,22) = sqrt(sum(gmeanB.^2,2));

% Projected distances of distorted centroid from reference planes
preds(:,23:24) = abs(gmeanB(:,2:3));

% Relative difference variance
preds(:,25:27) = rel_diff(gvarA, gvarB);

% Relative difference covariance
preds(:,28:30) = abs(sqrt(gvarA).*sqrt(gvarB) - gcovAB)./(sqrt(gvarA).*sqrt(gvarB)); 

% Relative difference ominvariance
preds(:,31) = rel_diff(prod(gvarA,2).^(1/3), prod(gvarB,2).^(1/3));
% Relative difference entropy
preds(:,32) = rel_diff(-sum(gvarA.*log(gvarA+eps),2), -sum(gvarB.*log(gvarB+eps),2));
% Relative difference anisotropy
preds(:,33) = rel_diff((gvarA(:,1) - gvarA(:,3))./gvarA(:,1), (gvarB(:,1) - gvarB(:,3))./gvarB(:,1));
% Relative difference planarity
preds(:,34) = rel_diff((gvarA(:,2) - gvarA(:,3))./gvarA(:,1), (gvarB(:,2) - gvarB(:,3))./gvarB(:,1));
% Relative difference linearity
preds(:,35) = rel_diff((gvarA(:,1) - gvarA(:,2))./gvarA(:,1), (gvarB(:,1) - gvarB(:,2))./gvarB(:,1));
% Relative difference surface variation
preds(:,36) = rel_diff(gvarA(:,3)./sum(gvarA,2), gvarB(:,3)./sum(gvarB,2));
% Relative difference sphericity
preds(:,37) = rel_diff(gvarA(:,3)./gvarA(:,1), gvarB(:,3)./gvarB(:,1));

% Angular similarity between distorted and reference planes
preds(:,38) = 1 - 2*acos(abs( sum([0,1,0].*geigvecB_y,2)./(sqrt(sum([0,1,0].^2,2)).*sqrt(sum(geigvecB_y.^2,2))) ))/pi;
% Parallelity of distorted planes
preds(:,39) = 1 - sum(repmat([1,0,0], size(geigvecB_x,1),1) .* geigvecB_x, 2);
preds(:,40) = 1 - sum(repmat([0,0,1], size(geigvecB_z,1),1) .* geigvecB_z, 2);

% % (Relative) Difference between global mean of local mean resolution of distorted and reference data
% preds(:,41) = abs_diff(gmeanMeanLocDistA, gmeanMeanLocDistB);
% preds(:,42) = rel_diff(gmeanMeanLocDistA, gmeanMeanLocDistB);
% % (Relative) Difference between global var of local mean resolution of distorted and reference data
% preds(:,43) = abs_diff(gvarMeanLocDistA, gvarMeanLocDistB);
% preds(:,44) = rel_diff(gvarMeanLocDistA, gvarMeanLocDistB);
% % (Relative) Difference between global mean of local variance resolution of distorted and reference data
% preds(:,45) = abs_diff(gmeanVarLocDistA, gmeanVarLocDistB);
% preds(:,46) = rel_diff(gmeanVarLocDistA, gmeanVarLocDistB);
% % (Relative) Difference between global variance of local variance resolution of distorted and reference data
% preds(:,47) = abs_diff(gvarVarLocDistA, gvarVarLocDistB);
% preds(:,48) = rel_diff(gvarVarLocDistA, gvarVarLocDistB);



end
    

function [adXY] = abs_diff(X, Y)
adXY = abs(X - Y);
end

function [rdXY] = rel_diff(X, Y)
rdXY = 1 - abs(X - Y)./(abs(X) + abs(Y) + eps(1));
end

