function [preds, predNames] = compute_predictors(lfeats)

predNames = {'t_varsum'; ...
            'g_pB2pA'; ...
            'g_vAB2plA_x'; 'g_vAB2plA_y'; 'g_vAB2plA_z'; ...
            'g_pA2cA'; ...
            'g_pA2plA_x'; 'g_pA2plA_y'; 'g_pA2plA_z'; ...
            'g_cB2plA_x'; 'g_cB2plA_y'; 'g_cB2plA_z'; ...
            'g_var_x'; 'g_var_y'; 'g_var_z'; ...
            'g_cov_x'; 'g_cov_y'; 'g_cov_z'; ...        
            'g_surfaceVariation'; ...
            'g_sphericity'; ...
            };
       

pA = lfeats(:,1:3);
pB = lfeats(:,4:6);
gvarA = lfeats(:,7:9);         
gvarB = lfeats(:,13:15);
tvarA = lfeats(:,10:12);
tvarB = lfeats(:,16:18);
gcovAB = lfeats(:,19:21);

% Initialization
preds = nan(size(lfeats,1), 20);

%%% Textural predictors
% Relative difference sum of variances
preds(:,1) = rel_diff(sum(tvarA,2), sum(tvarB,2));


%%% Geometric predictors
% Euclidean distance of distorted point from reference point (error vector)
preds(:,2) = sqrt(sum((pB - pA).^2,2));

% Projected distance of vector (between distorted and reference point) from reference planes
preds(:,3) = abs(dot(pB - pA, repmat([1,0,0], size(pA,1),1), 2));
preds(:,4) = abs(dot(pB - pA, repmat([0,1,0], size(pA,1),1), 2));
preds(:,5) = abs(dot(pB - pA, repmat([0,0,1], size(pA,1),1), 2));
% Euclidean distance of Reference point from reference centroid
preds(:,6) = sqrt(sum(pA.^2,2)); 
% Projected distances of reference point from reference planes
preds(:,7:9) = abs(pA);



% Projected distances of distorted point from reference planes
preds(:,10:12) = abs(pB);


% Relative difference variance
preds(:,13:15) = rel_diff(gvarA, gvarB);
% Relative difference covariance
preds(:,16:18) = abs(sqrt(gvarA).*sqrt(gvarB) - gcovAB)./(sqrt(gvarA).*sqrt(gvarB)); 


% Relative difference surface variation
preds(:,19) = rel_diff(gvarA(:,3)./sum(gvarA,2), gvarB(:,3)./sum(gvarB,2));
% Relative difference sphericity
preds(:,20) = rel_diff(gvarA(:,3)./gvarA(:,1), gvarB(:,3)./gvarB(:,1));

end
    
function [rdXY] = rel_diff(X, Y)
rdXY = 1 - abs(X - Y)./(abs(X) + abs(Y) + eps(1));
end

