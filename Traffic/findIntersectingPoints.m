vtol = struct('p_lat', p_lat, 'p_lon', p_lon, 'a_msl', a_msl);
traces = extractLatLonAltCompart('../../Traffic/relevant_traces.json');

points = zeros(1, 3);
k=1;

added_tracks = false(1, numel(traces));   % one flag per trace cell
for i = 1:length(vtol.p_lat)
    
    latitude = vtol.p_lat(i);
    longitude = vtol.p_lon(i);
    altitude = vtol.a_msl(i);
    for track_i = 1:length(traces)
        add = 0;
        if added_tracks(track_i)
            continue
        end

        track = traces{track_i};

        for trace_i = 1:length(track)
            trace = track(trace_i);
            dist = euclidean_distance(latitude, longitude, trace.latitude, trace.longitude);

            alt = getAlt(trace.altitude);
            if dist < 3 && abs(altitude-alt) < 1000
                add = 1;
            end
        end
        if add == 1
            for trace_i = 1:length(track)
                trace = track(trace_i);
                
                points(k, :) = [trace.latitude, trace.longitude, round(getAlt(trace.altitude))];
                k = k + 1;
                added_tracks(track_i) = true; % <- prevents future duplicates
            end
        end
    end
    fprintf('Latitude: %.2f, Longitude: %.2f, Altitude: %.2f\n', latitude, longitude, altitude);
    fprintf('%d / %d\n', i, length(vtol.p_lat));
end