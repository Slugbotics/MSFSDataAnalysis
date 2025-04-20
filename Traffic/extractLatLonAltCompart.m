function traces = extractLatLonAltCompart(jsonFile)
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
    traces = {}; 
    
    for i = 1:length(data)
        traces = [traces; data(i).trace]; 
    end
end
