%% Define Aircraft Positions (latitudes and longitudes)
latList = p_lat;   
lonList = p_lon;
heightList = a_msl;

%% Generate Circle (Glide Area) Parameters
theta = linspace(0, 360, 361);  % Angles for the circle
stepSize = 1000;

%% Compute glide area polygons for each aircraft
polys = cell(1, length(latList));
for i = 1:length(latList)
    % GlideCalculation (assumed to return the glide distance for the given height)
    [~, ~, ~, ~, ~, ~, ~, ~, ~, maxGlideDistance_m] = GlideCalculation(Weight, WingReferenceArea, WingAspectRatio, ParasiteDragCoefficient, AircraftEfficiencyFactor, heightList(i), 0);
    
    % Calculate a constant descent rate (meters per horizontal meter) based on max glide.
    descentRate = heightList(i) / maxGlideDistance_m;
    
    % For each azimuth, find the maximum distance where the glide altitude is above terrain.
    effectiveDistance = zeros(size(theta));
    for k = 1:length(theta)
        d = 0;
        % Continue stepping out until reaching max glide or the glide path intersects terrain.
        while d <= maxGlideDistance_m
            % Altitude above ground expected at distance d along the glide path:
            % (Assuming a linear descent from heightList(i) to 0 at maxGlideDistance_m)
            glideAltitude = heightList(i) - (descentRate * d);
            
            % Determine the geographic location at this distance and angle
            [latPt, lonPt] = reckon(latList(i), lonList(i), d, theta(k), referenceEllipsoid('wgs84'));
            
            % Get the terrain elevation at this point (in meters)
            terrainElev = getTerrainElevation(latPt, lonPt);  % User-defined function
            
            % Check if the glide altitude is above the terrain.
            if glideAltitude < terrainElev
                % Stop at the previous step if we have descended into terrain.
                break;
            end
            d = d + stepSize;
        end
        % Record the effective glide distance for this direction.
        effectiveDistance(k) = d;
    end
    
    % Compute the boundary of the glide area based on the effective distances.
    latCircle = zeros(size(theta));
    lonCircle = zeros(size(theta));
    for k = 1:length(theta)
        [latCircle(k), lonCircle(k)] = reckon(latList(i), lonList(i), effectiveDistance(k), theta(k), referenceEllipsoid('wgs84'));
    end
    
    % Create a polyshape from the computed boundary coordinates.
    polys{i} = polyshape(lonCircle, latCircle);
end

%% Compute the union of all glide area polygons to remove overlapping boundaries
unionPoly = polys{1};
for i = 2:length(polys)
    unionPoly = union(unionPoly, polys{i});
end
[lonUnion, latUnion] = boundary(unionPoly);

%% Create a geographic axes figure and plot the union boundary
figure
geoplot(latUnion, lonUnion, 'r-', 'LineWidth', 2)
hold on

%% Plot each aircraft position individually with a callback for contained inner boundaries
% (For a contained glide area, the inner boundary is hidden by default.)
%{
for i = 1:length(latList)
    % Check if the current glide area polygon is entirely contained in any other polygon.
    [lonPoly, latPoly] = boundary(polys{i});
    contained = false;
    for j = 1:length(polys)
        if j ~= i
            [in, on] = inpolygon(lonPoly, latPoly, polys{j}.Vertices(:,1), polys{j}.Vertices(:,2));
            if all(in | on)
                contained = true;
                break;
            end
        end
    end
    
    % Plot the aircraft position as a geoscatter point.
    % Plot each point separately so we can attach an individual callback.
    hScatter = geoscatter(latList(i), lonList(i), 50, 'bo');
    
    % If this glide area is entirely contained, plot its inner boundary (hidden by default)
    % and attach a callback to the aircraft point to toggle its visibility.
    if contained
        hInner = geoplot(latPoly, lonPoly, 'b--', 'LineWidth', 2, 'Visible', 'off');

        % Store the inner boundary handle in the scatter object's UserData.
        hScatter.UserData = hInner;

        % Create a context menu for this marker
        cm = uicontextmenu;
        uimenu(cm, "Label", "Glide Distance", 'Callback', @(src, event)toggleInnerBoundary(hScatter));
        hScatter.ContextMenu = cm;
    end
end
%}

%% Add basemap, title, and legend
geobasemap('satellite')
title('Combined Aircraft Glide Areas with Hidden Inner Boundaries')
legend('Glide Area Union Boundary', 'Aircraft Position','Location','best')
hold off

%% Callback function to toggle inner boundary visibility
function toggleInnerBoundary(src)
    innerHandle = src.UserData;
    if isempty(innerHandle)
        return;
    end
    if strcmp(innerHandle.Visible, 'off')
        innerHandle.Visible = 'on';
    else
        innerHandle.Visible = 'off';
    end
end


function elev = getTerrainElevation(lat, lon)
% GETTERRAINELEVATION Returns the terrain elevation at the given latitude and longitude.
%   elev = GETTERRAINELEVATION(lat, lon) reads from a DEM GeoTIFF file ('dem.tif')
%   and returns the elevation (in meters) at the specified geographic coordinates.
%
%   The function uses persistent variables to load the DEM and its spatial referencing
%   object only once. Adjust the file name and path as needed for your application.

    persistent DEM R

    if isempty(DEM)
        try
            [DEM, R] = readgeoraster('./TerrainData/output_USGS10m_eg.tif');
            DEM = double(DEM);  % Convert to double for computations
        catch ME
            warning('Error loading DEM: %s. Defaulting elevation to 0.', ME.message);
            elev = 0;
            return;
        end
    end

    % Convert geographic coordinates to intrinsic coordinates using the referencing object.
    try
        [row, col] = geographicToIntrinsic(R, lat, lon);
        row = round(row);
        col = round(col);
        
        % Validate indices to ensure they fall within the DEM boundaries.
        if row < 1 || col < 1 || row > size(DEM, 1) || col > size(DEM, 2)
            elev = NaN;  % Return NaN if the coordinate is outside the DEM region.
        else
            elev = DEM(col, row);
        end
    catch ME
        warning('Error computing elevation: %s. Defaulting elevation to 0.', ME.message);
        elev = 0;
    end
end
