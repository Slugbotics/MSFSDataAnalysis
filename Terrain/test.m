%% Parameters
% Reference coordinate and altitude (in feet)
latList = p_lat;   
lonList = p_lon;
heightList = a_msl;

%% Read the terrain data from a .tif file
% This reads the DEM (Digital Elevation Model) and its spatial referencing info.
% Replace 'terrain.tif' with your file.
[A, R] = readgeoraster('../TerrainData/output_USGS10m_eg.tif');

%% Create masks based on the elevation relative to refAlt
% Define the thresholds
redThreshold = heightList(i) - 100;     % 100 ft below or above => red
yellowLow = heightList(i) - 1000;       % 1000 ft below the ref altitude
yellowHigh = heightList(i) - 100;       % upper limit for yellow

% Create logical masks
redMask = (A >= redThreshold);                     % pixels that are 100 ft below or above
yellowMask = (A >= yellowLow) & (A < yellowHigh);    % pixels within 1000 ft but not in red range

%% Build an RGB image for the heatmap
% Initialize an RGB image array the same size as the DEM.
RGB = zeros([size(A) 3]);

% For red pixels, set the red channel to 1.
RGB(:,:,1) = redMask;

% For yellow pixels, set red and green channels to 1.
RGB(:,:,1) = RGB(:,:,1) | yellowMask;  % ensure red channel is on for yellow too
RGB(:,:,2) = yellowMask;               % green channel on

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
