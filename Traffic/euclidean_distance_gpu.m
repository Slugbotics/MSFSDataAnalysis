function distance_miles = euclidean_distance_gpu(lat1, lon1, lat2, lon2)
    miles_per_degree_lat = 69;

    % Ensure all inputs are gpuArrays for GPU computation
    lat1 = gpuArray(lat1);
    lon1 = gpuArray(lon1);
    lat2 = gpuArray(lat2);
    lon2 = gpuArray(lon2);
    
    % Convert latitude and longitude differences
    delta_lat = lat2 - lat1;
    delta_lon = lon2 - lon1;
    
    % Adjust longitude difference based on the latitude (cosine of latitude)
    delta_lon_adjusted = delta_lon .* cos(deg2rad((lat1 + lat2) / 2));
    
    % Calculate the Euclidean distance in miles
    distance_miles = sqrt((delta_lat * miles_per_degree_lat).^2 + (delta_lon_adjusted * miles_per_degree_lat).^2);
end