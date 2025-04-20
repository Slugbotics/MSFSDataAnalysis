function geoPlotTraceNoAircraft(pts)
% geoPlotTrace  Plot points on a 2‑D map.=
%   • Plots every point on a geographic axes.  
%   • Ground points (alt = 0) appear as black triangles.  
%   • Airborne points are colored by altitude (a colorbar is shown).  

    % --- Get the [lat lon alt] matrix -------------------------------
    % pts = extractLatLonAlt(jsonFile);          % <-- function from previous step
    length(pts)
    lat = pts(:,1);
    lon = pts(:,2);
    alt = pts(:,3);

    % --- Create map axes --------------------------------------------
    figure('Name','Flight Trace','Color','w');
    gx = geoaxes;                      % interactive axes (pan / scroll wheel)
    geobasemap(gx,'streets');          % choose any built‑in base map

    hold(gx,'on')

    % --- Plot ground vs. airborne segments --------------------------
    gnd   = alt == 0;                  % logical indices
    air   = ~gnd;

    % Ground: black triangles
    geoscatter(gx,lat(gnd),lon(gnd),10,'k','^',...
               'DisplayName','Ground');

    % Airborne: filled circles colored by altitude
    hAir = geoscatter(gx,lat(air),lon(air),10,alt(air),...
                      'filled','o','DisplayName','Airborne');

    colorbar('eastoutside'), ylabel(colorbar,'Altitude')

    % --- Decorations -------------------------------------------------
    title(gx,'Flight Trace (latitude / longitude)');
    legend('Location','best')
end
