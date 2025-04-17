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

%% Display the heatmap overlay with an interactive slider
% Create a figure
figure;

% Create a slider for selecting the time (index in `indices`)
slider = uicontrol('Style', 'slider', ...
                   'Min', 1, 'Max', numIntervals, ...
                   'Value', 1, ...
                   'SliderStep', [1/(numIntervals-1), 1/(numIntervals-1)], ...
                   'Position', [20, 20, 300, 20], ...
                   'Callback', @updateVisualization);

% Add a text label to display the current time value
timeLabel = uicontrol('Style', 'text', ...
                      'Position', [330, 20, 50, 20], ...
                      'String', '1');

% Initial rendering
time = first;
renderVisualization();

% Callback function for slider
function updateVisualization(src, ~)
    % Update the time variable based on the slider value
    timeIdx = round(src.Value); % Get the rounded slider value
    time = indices(timeIdx);    % Map slider value to the corresponding index in `indices`
    
    % Update the label to show the current time index
    timeLabel.String = num2str(timeIdx);
    
    % Re-render the visualization
    renderVisualization();
end

% Function to render the visualization
function renderVisualization()
    % Clear the current figure
    clf;

    % Build the RGB image for the current time
    RGB = zeros([size(A) 3]);

    % For red pixels, set the red channel to 1.
    RGB(:,:,1) = redMasks{time};

    % For yellow pixels, set red and green channels to 1.
    RGB(:,:,1) = RGB(:,:,1) | yellowMasks{time};  % ensure red channel is on for yellow too
    RGB(:,:,2) = RGB(:,:,2) | yellowMasks{time};  % ensure green channel is on for yellow

    % For green pixels, set only the green channel to 1 where red or yellow aren't.
    greenOnlyMask = greenMasks{time} & ~redMasks{time} & ~yellowMasks{time};
    RGB(:,:,2) = RGB(:,:,2) | greenOnlyMask;  % ensure green channel is on for green-only areas

    % Build an alpha channel: opaque (1) for red, yellow, or green pixels, transparent (0) otherwise.
    alphaChannel = double(redMasks{time} | yellowMasks{time} | greenOnlyMask);

    % Display the heatmap overlay on a satellite base (or fallback to grayscale DEM)
    hold on;
        % If satellite imagery is not available, display the DEM in grayscale.
        geoshow(A, R, 'DisplayType', 'texturemap');
        colormap(gray);

        % Now overlay the heatmap using the RGB image and the alpha channel.
        geoshow(RGB, R, 'DisplayType', 'texturemap', 'FaceAlpha', 0.3);
    hold off;

    % Add a title to indicate the current time index
    title(['Terrain Heatmap for Index: ', num2str(time)]);
end
