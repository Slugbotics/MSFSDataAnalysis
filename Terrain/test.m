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

time = middle;

%% Read the terrain data from a .tif file
% This reads the DEM (Digital Elevation Model) and its spatial referencing info.
% Replace 'terrain.tif' with your file.
[A, R] = readgeoraster('/TerrainData/output_USGS10m_eg.tif');

%% Create masks based on the elevation relative to refAlt
disp('Memory usage before creating masks:');
memory;

% Initialize containers for masks only for the selected timesteps
redMasks = cell(numIntervals, 1);
yellowMasks = cell(numIntervals, 1);
greenMasks = cell(numIntervals, 1);

for idx = 1:numIntervals
    i = timestep(idx);
    % Create logical masks for the current height
    redMasks{idx} = (A >= heightList(i) - 100);                     % pixels that are 100 ft below or above
    yellowMasks{idx} = (A >= heightList(i) - 1000) & (A < heightList(i) - 100);  % pixels within 1000 ft but not in red range
    greenMasks{idx} = (A < heightList(i) - 1000);                   % pixels that are below 1000 ft
end

disp('Memory usage after creating masks:');
memory;

%% Dynamically Determine Downsample Size
% Create a temporary figure to get the axes size
tempFig = figure('Visible', 'off'); % Create an invisible figure
tempAxes = axes(tempFig); % Add axes to the figure

% Get the size of the axes in pixels
axesPosition = get(tempAxes, 'Position'); % Position in normalized units
screenSize = get(0, 'ScreenSize'); % Screen size in pixels
axesPixelSize = axesPosition(3:4) .* screenSize(3:4); % Convert to pixel size

% Close the temporary figure
close(tempFig);

% Use the axes pixel size as the target resolution
targetResolution = round(axesPixelSize);

% Downsample the DEM
A_resized = imresize(A, targetResolution);

% Flip the downsampled DEM vertically to correct orientation
A_resized = flipud(A_resized);

% Adjust the spatial referencing object to match the downsampled resolution
R_resized = georefcells(R.LatitudeLimits, R.LongitudeLimits, size(A_resized));

% Downsample the masks for each timestep
redMasks_resized = cell(numIntervals, 1);
yellowMasks_resized = cell(numIntervals, 1);
greenMasks_resized = cell(numIntervals, 1);

for idx = 1:numIntervals
    redMasks_resized{idx} = flipud(imresize(redMasks{idx}, targetResolution, 'nearest'));
    yellowMasks_resized{idx} = flipud(imresize(yellowMasks{idx}, targetResolution, 'nearest'));
    greenMasks_resized{idx} = flipud(imresize(greenMasks{idx}, targetResolution, 'nearest'));
end

%% Build an RGB image for the heatmap (using resized data)
% Initialize an RGB image array the same size as the resized DEM.
RGB_resized = zeros([size(A_resized) 3]);

% For red pixels, set the red channel to 1.
RGB_resized(:,:,1) = redMasks_resized{1};

% For yellow pixels, set red and green channels to 1.
RGB_resized(:,:,1) = RGB_resized(:,:,1) | yellowMasks_resized{1};  % ensure red channel is on for yellow too
RGB_resized(:,:,2) = RGB_resized(:,:,2) | yellowMasks_resized{1};  % ensure green channel is on for yellow

% For green pixels, set only the green channel to 1 where red or yellow aren't.
greenOnlyMask_resized = greenMasks_resized{1} & ~redMasks_resized{1} & ~yellowMasks_resized{1};
RGB_resized(:,:,2) = RGB_resized(:,:,2) | greenOnlyMask_resized;  % ensure green channel is on for green-only areas

% Build an alpha channel: opaque (1) for red, yellow, or green pixels, transparent (0) otherwise.
alphaChannel_resized = double(redMasks_resized{1} | yellowMasks_resized{1} | greenOnlyMask_resized);

%% Display the Downsampled Heatmap with Slider Control
% Create a figure for the optimized heatmap with a slider
figure;
hold on;

% Display the downsampled DEM in grayscale as a fallback
geoshow(A_resized, R_resized, 'DisplayType', 'texturemap');
colormap(gray);

% Create the slider
slider = uicontrol('Style', 'slider', ...
                   'Min', 1, ...
                   'Max', numIntervals, ...
                   'Value', 1, ...
                   'SliderStep', [1/(numIntervals-1), 1/(numIntervals-1)], ...
                   'Units', 'normalized', ...
                   'Position', [0.2, 0.01, 0.6, 0.05]);

% Add a listener to update the heatmap when the slider value changes
addlistener(slider, 'Value', 'PostSet', @(src, event) updateOptimizedHeatmap(round(slider.Value), A_resized, redMasks_resized, yellowMasks_resized, greenMasks_resized, R_resized, timestep, latList, lonList, heightList));

% Initial heatmap overlay for the first timestep
updateOptimizedHeatmap(1, A_resized, redMasks_resized, yellowMasks_resized, greenMasks_resized, R_resized, timestep, latList, lonList, heightList);
hold off;
title('Optimized Terrain Heatmap with Slider Control');

%% Callback function to update the optimized heatmap
function updateOptimizedHeatmap(selectedIdx, A_resized, redMasks_resized, yellowMasks_resized, greenMasks_resized, R_resized, timestep, latList, lonList, heightList)
    % Clear the current axes to prevent overlapping layers
    cla;

    % Display the grayscale terrain map as the base layer
    geoshow(A_resized, R_resized, 'DisplayType', 'texturemap'); % Removed flipud
    colormap(gray); % Set the colormap to grayscale
    hold on;

    % Initialize an RGB image array the same size as the resized DEM
    RGB_resized = zeros([size(redMasks_resized{selectedIdx}), 3]);

    % Update the RGB image based on the selected timestep
    RGB_resized(:,:,1) = redMasks_resized{selectedIdx} | yellowMasks_resized{selectedIdx}; % Red channel
    RGB_resized(:,:,2) = yellowMasks_resized{selectedIdx} | ...
                         (greenMasks_resized{selectedIdx} & ~redMasks_resized{selectedIdx} & ~yellowMasks_resized{selectedIdx}); % Green channel

    % Update the alpha channel
    alphaChannel_resized = double(redMasks_resized{selectedIdx} | yellowMasks_resized{selectedIdx} | ...
                                  (greenMasks_resized{selectedIdx} & ~redMasks_resized{selectedIdx} & ~yellowMasks_resized{selectedIdx}));

    % Overlay the RGB heatmap on top of the grayscale terrain map
    geoshow(RGB_resized, R_resized, 'DisplayType', 'texturemap', 'FaceAlpha', 0.3);

    % Overlay the aircraft's path
    selectedLatitudes = latList(timestep);
    selectedLongitudes = lonList(timestep);
    geoplot(selectedLatitudes, selectedLongitudes, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'Color', "b");

    % Annotate the current position with altitude
    currentLat = latList(timestep(selectedIdx));
    currentLon = lonList(timestep(selectedIdx));
    currentAlt = heightList(timestep(selectedIdx));
    geoscatter(currentLat, currentLon, 100, "r", "filled"); % Highlight the current position
    textm(currentLat, currentLon, sprintf('%.0f ft', currentAlt), 'Color', 'white', 'FontSize', 8);

    % Update the title with the current timestep
    title(['Optimized Terrain Heatmap - Timestep: ', num2str(timestep(selectedIdx))]);
    hold off;
end

%% Aircraft Position Plot for Selected Timesteps
% Extract latitude, longitude, and altitude for the selected timesteps
selectedLatitudes = latList(timestep);
selectedLongitudes = lonList(timestep);
selectedAltitudes = heightList(timestep);

% Create a new figure with geographic axes
figure;
geoAx = geoaxes; % Create geographic axes
hold(geoAx, 'on');

% Plot the aircraft's path
geoplot(geoAx, selectedLatitudes, selectedLongitudes, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'Color', "b");
geobasemap(geoAx, 'satellite'); % Set the basemap to satellite

% Annotate the plot with altitude information
for i = 1:length(selectedLatitudes)
    % Use geoscatter to mark the points and add altitude annotations
    geoscatter(geoAx, selectedLatitudes(i), selectedLongitudes(i), 50, "r", "filled");
    text(geoAx, selectedLongitudes(i), selectedLatitudes(i), ...
        sprintf('%.0f ft', selectedAltitudes(i)), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', ...
        'FontSize', 8, 'Color', 'white');
end

% Add labels and title
title(geoAx, 'Aircraft Position at Selected Timesteps');

% Adjust the view to ensure the entire path is visible
geolimits(geoAx, [min(selectedLatitudes) - 0.01, max(selectedLatitudes) + 0.01], ...
                 [min(selectedLongitudes) - 0.01, max(selectedLongitudes) + 0.01]);

% Display grid for better visual reference
grid(geoAx, 'on');
