%% Parameters
% Reference coordinate and altitude (in feet)
latList = p_lat;   
lonList = p_lon;
heightList = a_msl;

%% Read the terrain data from a .tif file
% This reads the DEM (Digital Elevation Model) and its spatial referencing info.
% Replace 'terrain.tif' with your file.
[A, R] = readgeoraster('../TerrainData/output_USGS10m_eg.tif');

% Define the number of time steps
numTimeSteps = length(latList);

% Create a figure with a slider for the timeline
figure('Name', 'Dynamic Glide Masks', 'NumberTitle', 'off');
timelineSlider = uicontrol('Style', 'slider', ...
    'Min', 1, 'Max', numTimeSteps, 'Value', 1, ...
    'SliderStep', [1/(numTimeSteps-1), 1/(numTimeSteps-1)], ...
    'Units', 'normalized', ...
    'Position', [0.1, 0.01, 0.8, 0.05], ...
    'Callback', @updateDisplay);

% Add a text label to show the current time step
timeLabel = uicontrol('Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0.45, 0.07, 0.1, 0.03], ...
    'String', 'Time: 1');

% Create an axes for the geographic plot
geoAxes = axes('Units', 'normalized', 'Position', [0.1, 0.15, 0.8, 0.8]);
geobasemap('satellite');
title('Dynamic Glide Masks');
hold on;

% Initialize the mask plot
maskPlot = geoplot([], [], 'r-', 'LineWidth', 2);

% Callback function to update the display
function updateDisplay(~, ~)
    % Get the current time step from the slider
    timeStep = round(timelineSlider.Value);
    
    % Update the time label
    timeLabel.String = sprintf('Time: %d', timeStep);
    
    % Get the current lat, lon, and height
    currentLat = latList(timeStep);
    currentLon = lonList(timeStep);
    currentHeight = heightList(timeStep);
    
    %% Update mask definitions based on the current timestep
    % Define thresholds dynamically
    redThreshold = currentHeight - 100;     % 100 ft below or above => red
    yellowLow = currentHeight - 1000;       % 1000 ft below the ref altitude
    yellowHigh = currentHeight - 100;       % upper limit for yellow

    % Create logical masks
    redMask = (A >= redThreshold);                     % pixels that are 100 ft below or above
    yellowMask = (A >= yellowLow) & (A < yellowHigh);  % pixels within 1000 ft but not in red range

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

    %% Update the heatmap overlay
    cla(geoAxes); % Clear the axes
    geoshow(A, R, 'DisplayType', 'texturemap', 'Parent', geoAxes); % Display the DEM
    colormap(geoAxes, gray);
    hold(geoAxes, 'on');
    geoshow(RGB, R, 'DisplayType', 'texturemap', 'FaceAlpha', 0.3, 'Parent', geoAxes); % Overlay the heatmap
    hold(geoAxes, 'off');
end

% Initialize the display
updateDisplay();
