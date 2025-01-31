latitudes = p_lat;
longitudes = p_lon;

% Check if the number of latitude and longitude data points match
if height(latitudes) ~= height(longitudes)
    error('The number of latitude and longitude points must match.');
end

% Create a geographic plot
figure;
geoplot(latitudes, longitudes, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'Color', "r");
geobasemap('satellite'); % Set the basemap to satellite

% Add labels and title
title('Path of the Plane');

% Adjust the view to ensure the entire path is visible
geolimits([min(latitudes) - 0.01, max(latitudes) + 0.01], ...
          [min(longitudes) - 0.01, max(longitudes) + 0.01]);

% Display grid for better visual reference
grid on;