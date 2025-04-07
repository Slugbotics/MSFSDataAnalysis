function EnergyDisplay(data)
% EnergyDisplay Visualizes energy outputs and overlays efficiency on the flight path.
%
%   Inputs:
%       data - Struct containing aircraft data mapped from the database
%
%   This function generates:
%       - Line graph for total energy consumed over time
%       - Line graph for energy consumption rate over time
%       - Line graph for efficiency over time
%       - Flight path overlay with efficiency-based color coding

    %% Calculate Energy Metrics
    [totalEnergy_kWh, energyRate_kW, effective_nm_per_kWh, efficiency] = EnergyCalculation(data);

    %% Extract Time and Flight Path Data
    time = datetime(data.time_inserted, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
    timeMinutes = minutes(time - time(1)); % Convert time to minutes after the first time
    latitudes = data.p_lat;
    longitudes = data.p_lon;

    %% Plot Total Energy Consumed
    figure;
    plot(timeMinutes, totalEnergy_kWh, 'b-', 'LineWidth', 2);
    title('Total Energy Consumed Over Time');
    xlabel('Time (minutes)');
    ylabel('Total Energy (kWh)');
    grid on;

    %% Plot Energy Consumption Rate
    figure;
    plot(timeMinutes, energyRate_kW, 'r-', 'LineWidth', 2);
    title('Energy Consumption Rate Over Time');
    xlabel('Time (minutes)');
    ylabel('Energy Rate (kW)');
    grid on;

    %% Plot Effective Range
    figure;
    plot(timeMinutes, effective_nm_per_kWh, 'g-', 'LineWidth', 2);
    title('Effective Range Over Time');
    xlabel('Time (minutes)');
    ylabel('Efficiency (nm/kWh)');
    grid on;

    %% Plot Efficiency
    figure;
    plot(timeMinutes, efficiency, 'g-', 'LineWidth', 2);
    title('Efficiency Over Time');
    xlabel('Time (minutes)');
    ylabel('Efficiency (nm/kWh)');
    grid on;

    %% Overlay Efficiency on Flight Path
    figure;
    hold on;
    % Normalize efficiency for color mapping
    efficiencyNormalized = (effective_nm_per_kWh - min(effective_nm_per_kWh)) / ...
                           (max(effective_nm_per_kWh) - min(effective_nm_per_kWh));
    % Map efficiency to a colormap
    cmap = jet(256); % Use the 'jet' colormap
    colors = interp1(linspace(0, 1, size(cmap, 1)), cmap, efficiencyNormalized);

    % Plot the flight path with color-coded efficiency
    for i = 1:length(latitudes) - 1
        plot([longitudes(i), longitudes(i + 1)], [latitudes(i), latitudes(i + 1)], ...
             'Color', colors(i, :), 'LineWidth', 2);
    end

    % Add colorbar for efficiency
    colormap(cmap);
    c = colorbar;
    c.Label.String = 'Efficiency (nm/kWh)';
    caxis([min(effective_nm_per_kWh), max(effective_nm_per_kWh)]);

    % Add labels and title
    title('Flight Path with Efficiency Overlay');
    xlabel('Longitude');
    ylabel('Latitude');
    grid on;
    hold off;

end