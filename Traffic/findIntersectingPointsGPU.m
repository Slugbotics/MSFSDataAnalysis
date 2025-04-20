% Assuming the presence of 'gpuArray' and 'gather' for efficient GPU computation

% Move relevant data to GPU
p_lat_gpu = gpuArray(vtol.p_lat);  % Latitude on GPU
p_lon_gpu = gpuArray(vtol.p_lon);  % Longitude on GPU
a_msl_gpu = gpuArray(vtol.a_msl);  % Altitude on GPU

% Initialize points on GPU
points_gpu = gpuArray.zeros(1, 3);

k = 1;

% Pre-calculate the length of traces and use it in the loop to avoid multiple calls to length()
num_traces = length(traces);

for i = 1:length(p_lat_gpu)
    latitude = p_lat_gpu(i); 
    longitude = p_lon_gpu(i); 
    altitude = a_msl_gpu(i); 
    
    for track_i = 1:num_traces
        track = traces{track_i}; 
        
        % Move the trace data to GPU for parallel distance computation
        trace_latitudes = gpuArray([track.latitude]);
        trace_longitudes = gpuArray([track.longitude]);
        
        % Compute distances on the GPU (Vectorized)
        dist = euclidean_distance_gpu(latitude, longitude, trace_latitudes, trace_longitudes);
        
        rawAlt = {track.altitude};  % Cell array for altitudes to handle different types
        
        % Convert altitude to numeric value
        altitudes = gpuArray.zeros(1, numel(rawAlt));
        
        for trace_i = 1:numel(rawAlt)
            if ischar(rawAlt{trace_i}) || isstring(rawAlt{trace_i})
                if strcmpi(rawAlt{trace_i}, "ground")
                    altitudes(trace_i) = 0;
                else
                    altitudes(trace_i) = str2double(rawAlt{trace_i});
                end
            elseif isempty(rawAlt{trace_i}) || isnan(rawAlt{trace_i})
                altitudes(trace_i) = 0;
            else
                altitudes(trace_i) = rawAlt{trace_i};
            end
        end
        
        % Filter and store the points based on distance threshold
        idx = dist < 0.25; % Logical array of points that satisfy the condition
        points_gpu(k:k+sum(idx)-1, :) = [trace_latitudes(idx), trace_longitudes(idx), round(altitudes(idx))];
        k = k + sum(idx);
    end
    fprintf('Latitude: %.2f, Longitude: %.2f, Altitude: %.2f\n', latitude, longitude, altitude);
    fprintf('%d / %d\n', i, length(p_lat_gpu));
end

% Transfer results back to CPU
points = gather(points_gpu);
