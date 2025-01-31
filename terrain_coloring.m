% Load a DEM GeoTIFF file
[Z, R] = readgeoraster('.\Terrain Data\output_USGS10m.tif');

% Convert search radius (10 miles) to meters
search_radius_meters = 16093.4;

% Approximate conversion: meters per pixel
meters_per_pixel = abs(R.CellExtentInLatitude) * 111320; % Rough conversion
search_radius_pixels = round(search_radius_meters / meters_per_pixel);

% Convert plane route to row, col in the DEM
[row, col] = geographicToDiscrete(R, p_lat, p_lon);

% Extract a larger region covering all points
row_min = max(1, min(row) - search_radius_pixels);
row_max = min(size(Z,1), max(row) + search_radius_pixels);
col_min = max(1, min(col) - search_radius_pixels);
col_max = min(size(Z,2), max(col) + search_radius_pixels);

% Extract the terrain patch
terrain_patch = double(Z(row_min:row_max, col_min:col_max));

% Compute relative height based on first point altitude
relative_height = terrain_patch - a_msl(1);

% Create the plot
figure;
imagesc([col_min col_max], [row_min row_max], relative_height);
colorbar;
hold on;

% Overlay the flight path
plot(col, row, 'r-o', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerFaceColor', 'r');

% Labels and title
title('Terrain with Flight Path Overlay');
xlabel('Longitude (pixels)');
ylabel('Latitude (pixels)');
axis equal;
grid on;

% Show plot
hold off;
