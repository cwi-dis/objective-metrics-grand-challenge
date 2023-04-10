function [pcOut] = pc_duplicate_merging(pcIn)
% Merging of points with duplicate coordinates in a point cloud.  
%   Corresponding color values (if present) are averaged, and unique 
%   coordinates are kept.
% 
%   [pcOut] = pc_duplicate_merging(pcIn)
%
%   INPUTS
%       pcIn: Input point cloud
%
%   OUTPUTS
%       pcOut: Output point cloud with "double" floating geometry


geomIn = double(pcIn.Location);
[vertices, ind_v] = unique(geomIn, 'rows');

if (size(pcIn.Location,1) ~= size(vertices,1)) 
    warning('Duplicated points found.');
    if ~isempty(pcIn.Color)
        warning('Color blending is applied.');
        [vertices_sorted, ind_v] = sortrows(geomIn);
        colors_sorted = double(pcIn.Color(ind_v, :));
        d = diff(vertices_sorted,1,1);
        sd = sum(abs(d),2) > 0;
        id = [1; find(sd == 1)+1; size(vertices_sorted,1)+1];
        colors = zeros(size(id,1)-1,3);
        for j = 1:size(id,1)-1
            colors(j,:) = round(mean(colors_sorted(id(j):id(j+1)-1, :), 1));
        end
        id(end) = [];
        vertices = vertices_sorted(id,:);
    end
else
    if ~isempty(pcIn.Color)
        colors = double(pcIn.Color(ind_v, :));
    end
end

if ~isempty(pcIn.Color)
    pcOut = pointCloud(double(vertices), 'Color', uint8(colors));
else
    pcOut = pointCloud(double(vertices));
end
