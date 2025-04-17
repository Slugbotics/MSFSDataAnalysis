%% Parameters
% Reference coordinate and altitude (in feet)
latList = p_lat;   
lonList = p_lon;
heightList = a_msl;
numIntervals = 10;
indices = round(linspace(1, length(heightList), numIntervals));
first = indices(1);
middle = indices(round(numIntervals / 2));
last = indices(end);

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
greenMasks = cell(length(heightList), 1);

for idx = 1:numIntervals
    i = indices(idx);
    % Create logical masks for the current height
    redMasks{i} = (A >= heightList(i) - 100);                     % pixels that are 100 ft below or above
    yellowMasks{i} = (A >= heightList(i) - 1000) & (A < heightList(i) - 100);  % pixels within 1000 ft but not in red range
    greenMasks{i} = (A < heightList(i) - 1000);                 % pixels that are below 1000 ft

end

%% Build an RGB image for the heatmap
% Initialize an RGB image array the same size as the DEM.
RGB = zeros([size(A) 3]);

% For red pixels, set the red channel to 1.
RGB(:,:,1) = redMasks{1};

% For yellow pixels, set red and green channels to 1.
RGB(:,:,1) = RGB(:,:,1) | yellowMasks{middle};  % ensure red channel is on for yellow too
RGB(:,:,2) = RGB(:,:,2) | yellowMasks{middle};  % ensure green channel is on for yellow

% For green pixels, set the green channel to 1 and blue channel to 1.
RGB(:,:,2) = RGB(:,:,2) | greenMasks{middle};   % ensure green channel is on for green masks
RGB(:,:,3) = RGB(:,:,3) | greenMasks{middle};   % ensure blue channel is on for green masks

% Build an alpha channel: opaque (1) for red, yellow, or green pixels, transparent (0) otherwise.
alphaChannel = double(redMasks{middle} | yellowMasks{middle} | greenMasks{middle});

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
