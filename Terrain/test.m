%% Parameters
% Reference coordinate and altitude (in feet)
latList = p_lat;   
lonList = p_lon;
heightList = a_msl;
numIntervals = 10;
timestep = round(linspace(1, length(heightList), numIntervals));
first = timestep(1);
middle = timestep(round(numIntervals / 2));
last = timestep(end);

time = first;

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
    i = timestep(idx);
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
RGB(:,:,1) = RGB(:,:,1) | yellowMasks{time};  % ensure red channel is on for yellow too
RGB(:,:,2) = RGB(:,:,2) | yellowMasks{time};  % ensure green channel is on for yellow

% For green pixels, set only the green channel to 1 where red or yellow aren't.
greenOnlyMask = greenMasks{time} & ~redMasks{time} & ~yellowMasks{time};
RGB(:,:,2) = RGB(:,:,2) | greenOnlyMask;  % ensure green channel is on for green-only areas

% Build an alpha channel: opaque (1) for red, yellow, or green pixels, transparent (0) otherwise.
alphaChannel = double(redMasks{time} | yellowMasks{time} | greenOnlyMask);

%% Add a slider to control the timestep
% Create a figure for the heatmap with a slider
figure;
hold on;

% Display the DEM in grayscale as a fallback
geoshow(A, R, 'DisplayType', 'texturemap');
colormap(gray);

% Create the slider
slider = uicontrol('Style', 'slider', ...
                   'Min', first, ...
                   'Max', last, ...
                   'Value', first, ...
                   'SliderStep', [1/(numIntervals-1), 1/(numIntervals-1)], ...
                   'Units', 'normalized', ...
                   'Position', [0.2, 0.01, 0.6, 0.05]);

% Add a listener to update the heatmap when the slider value changes
addlistener(slider, 'Value', 'PostSet', @(src, event) updateHeatmap(round(slider.Value)));

% Initial heatmap overlay
geoshow(RGB, R, 'DisplayType', 'texturemap', 'FaceAlpha', 0.3);
hold off;
title('Terrain Heatmap with Slider Control');

%% Callback function to update the heatmap
function updateHeatmap(selectedTime)
    % Update the RGB image based on the selected timestep
    RGB(:,:,1) = redMasks{selectedTime} | yellowMasks{selectedTime}; % Red channel
    RGB(:,:,2) = yellowMasks{selectedTime} | ...
                 (greenMasks{selectedTime} & ~redMasks{selectedTime} & ~yellowMasks{selectedTime}); % Green channel

    % Update the alpha channel
    alphaChannel = double(redMasks{selectedTime} | yellowMasks{selectedTime} | ...
                          (greenMasks{selectedTime} & ~redMasks{selectedTime} & ~yellowMasks{selectedTime}));

    % Refresh the heatmap display
    hold on;
    geoshow(RGB, R, 'DisplayType', 'texturemap', 'FaceAlpha', 0.3);
    hold off;
    title(['Terrain Heatmap - Timestep: ', num2str(selectedTime)]);
end
