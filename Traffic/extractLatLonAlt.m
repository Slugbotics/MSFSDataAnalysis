function points = extractLatLonAlt(jsonFile)
% extractLatLonAlt  Parse a flight‑trace JSON file and return [lat lon alt].
%
%   points = extractLatLonAlt(jsonFile)
%
%   INPUT
%       jsonFile – full path or name of the JSON file.
%
%   OUTPUT
%       points   – N‑by‑3 double matrix:
%                    column 1 : latitude
%                    column 2 : longitude
%                    column 3 : altitude (0 for "ground")
%
%   Example:
%       pts = extractLatLonAlt('trace_sample.json');

    % Read and decode JSON
    txt   = fileread(jsonFile);
    data  = jsondecode(txt);
        
    % Ensure the file contains a “trace” field
    if ~isfield(data, "trace")
        error('No "trace" data found in the JSON file.');
    end
    trc = []; 
    
    for i = 1:length(data)
        trc = [trc; data(i).trace]; 
    end
    

    nPoints  = numel(trc);
    points   = zeros(nPoints, 3);     % pre‑allocate [lat lon alt]

    for k = 1:nPoints
        % Latitude / longitude
        lat = trc(k).latitude;
        lon = trc(k).longitude;

        % Altitude handling
        rawAlt = trc(k).altitude;
        if ischar(rawAlt) || isstring(rawAlt)
            if strcmpi(rawAlt, "ground")
                alt = 0;
            else                       % numeric altitude stored as text
                alt = str2double(rawAlt);
                if isnan(alt), alt = 0; end
            end
        elseif isempty(rawAlt) || isnan(rawAlt)
            alt = 0;
        else                           % already numeric
            alt = rawAlt;
        end

        points(k, :) = [lat, lon, round(alt)];   % round to integer feet/metres
    end
end
