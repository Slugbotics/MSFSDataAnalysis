%% Parameters
% Reference coordinate and altitude (in feet)
latList = p_lat;   
lonList = p_lon;
heightList = a_msl;
numIntervals = 10;
timestep = round(linspace(1, length(heightList), numIntervals));
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

time = first;

% For yellow pixels, set red and green channels to 1.
RGB(:,:,1) = RGB(:,:,1) | yellowMasks{time};  % ensure red channel is on for yellow too
RGB(:,:,2) = RGB(:,:,2) | yellowMasks{time};  % ensure green channel is on for yellow

% For green pixels, set only the green channel to 1 where red or yellow aren't.
greenOnlyMask = greenMasks{time} & ~redMasks{time} & ~yellowMasks{time};
RGB(:,:,2) = RGB(:,:,2) | greenOnlyMask;  % ensure green channel is on for green-only areas

% Build an alpha channel: opaque (1) for red, yellow, or green pixels, transparent (0) otherwise.
alphaChannel = double(redMasks{time} | yellowMasks{time} | greenOnlyMask);

%% Create a figure with a slider for interaction
figure;
hold on;

% Display the DEM in grayscale as the base layer
geoshow(A, R, 'DisplayType', 'texturemap');
colormap(gray);

% Create a slider for selecting the time index
slider = uicontrol('Style', 'slider', ...
                   'Min', 1, 'Max', numIntervals, ...
                   'Value', 1, ...
                   'SliderStep', [1/(numIntervals-1) 1/(numIntervals-1)], ...
                   'Position', [20 20 300 20]);

% Add a text label to display the current time index
sliderLabel = uicontrol('Style', 'text', ...
                        'Position', [330 20 50 20], ...
                        'String', sprintf('Idx: %d', timestep(1)));

% Callback function to update the heatmap when the slider is moved
function updateHeatmap(slider, ~)
    % Get the current slider value and round it to the nearest index
    sliderValue = round(slider.Value);
    time = timestep(sliderValue); % Use the slider value to get the corresponding index in timestep

    % Update the RGB image for the selected time
    RGB = zeros([size(A) 3]);
    RGB(:,:,1) = redMasks{time};  % Red channel
    RGB(:,:,1) = RGB(:,:,1) | yellowMasks{time};  % Yellow affects red channel
    RGB(:,:,2) = RGB(:,:,2) | yellowMasks{time};  % Yellow affects green channel
    greenOnlyMask = greenMasks{time} & ~redMasks{time} & ~yellowMasks{time};
    RGB(:,:,2) = RGB(:,:,2) | greenOnlyMask;  % Green-only areas

    % Update the heatmap overlay
    geoshow(RGB, R, 'DisplayType', 'texturemap', 'FaceAlpha', 0.3);

    % Update the slider label
    sliderLabel.String = sprintf('Idx: %d', time);
end

% Set the slider callback to the updateHeatmap function
slider.Callback = @(src, event) updateHeatmap(src, event);

% Initialize the heatmap for the first time index
updateHeatmap(slider);

hold off;
title('Terrain Heatmap with Interactive Slider');
