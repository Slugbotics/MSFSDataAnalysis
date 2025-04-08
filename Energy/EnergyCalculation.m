function [fuel_percentage, total_energy_kWh] = EnergyCalculation(data)
    % EnergyCalculation computes energy metrics based on fuel data.
    %
    % Inputs:
    %   data - Struct containing database values, including fuel_max and fuel_current.
    %
    % Outputs:
    %   fuel_percentage - Remaining fuel percentage.
    %   total_energy_kWh - Total energy available in kWh.

    % Extract fuel data from the input struct
    fuel_max = data.fuel_max;
    fuel_current = data.fuel_current;

    % Validate inputs
    if fuel_max <= 0
        error('Invalid value for fuel_max. It must be greater than zero.');
    end

    % Calculate remaining fuel percentage
    fuel_percentage = (fuel_current / fuel_max) * 100;

    % Load energy parameters (e.g., battery capacity)
    EnergyParameters; % Loads `Capacity` from EnergyParameters.m

    % Calculate total energy available
    total_energy_kWh = (fuel_percentage / 100) * Capacity;

    % Display results
    fprintf('Fuel Percentage: %.2f%%\n', fuel_percentage);
    fprintf('Total Energy Available: %.2f kWh\n', total_energy_kWh);

    % Add further calculations or visualizations as needed
end