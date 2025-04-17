%% Parameters
% Reference coordinate and altitude (in feet)
latList = p_lat;   
lonList = p_lon;
heightList = a_msl;

%% Read the terrain data from a .tif file
% This reads the DEM (Digital Elevation Model) and its spatial referencing info.
% Replace 'terrain.tif' with your file.
[A, R] = readgeoraster('/TerrainData/output_USGS10m_eg.tif');

%% Create masks based on the elevation relative to refAlt
% Initialize a cell array to store masks for each index of heightList
redMasks = cell(length(heightList), 1);
yellowMasks = cell(length(heightList), 1);

% Define the thresholds for the current height
redThreshold = heightList(i) - 100;     % 100 ft below or above => red
yellowLow = heightList(i) - 1000;       % 1000 ft below the ref altitude
yellowHigh = heightList(i) - 100;       % upper limit for yellow

% Initialize a cell array to store masks for each index of heightList
redMasks = cell(length(heightList), 1);
yellowMasks = cell(length(heightList), 1);

for i = 1:60:length(heightList)
    % Create logical masks for the current height
    redMasks{i} = (A >= redThreshold);                     % pixels that are 100 ft below or above
    yellowMasks{i} = (A >= yellowLow) & (A < yellowHigh);  % pixels within 1000 ft but not in red range
end

%% Build an RGB image for the heatmap
% Initialize an RGB image array the same size as the DEM.
RGB = zeros([size(A) 3]);

% For red pixels, set the red channel to 1.
RGB(:,:,1) = redMasks{100};

% For yellow pixels, set red and green channels to 1.
RGB(:,:,1) = RGB(:,:,1) | yellowMasks{100};  % ensure red channel is on for yellow too
RGB(:,:,2) = yellowMasks{100};               % green channel on

% Build an alpha channel: opaque (1) for red or yellow pixels, transparent (0) otherwise.
alphaChannel = double(redMask | yellowMask);

%% Display the heatmap overlay on a satellite base (or fallback to grayscale DEM)
figure;
hold on;
    % If satellite imagery is not available, display the DEM in grayscale.
    geoshow(A, R, 'DisplayType', 'texturemap');
    colormap(gray);

    % Now overlay the heatmap using the RGB image and the alpha channel.
    geoshow(RGB, R, 'DisplayType', 'texturemap', 'FaceAlpha', 0.3);
hold off;
title('Terrain Heatmap with Satellite Base');
