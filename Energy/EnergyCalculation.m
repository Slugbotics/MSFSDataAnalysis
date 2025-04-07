function [totalEnergy_kWh, energyRate_kW, efficiency_nm_per_kWh] = EnergyCalculation(batteryCapacity_kWh, VTOL_Range, CTOL_Range)
% EnergyCalculation Computes energy usage and efficiency for an aircraft.
%
%   [totalEnergy_kWh, energyRate_kW, efficiency_nm_per_kWh] = EnergyCalculation(data, batteryCapacity_kWh, efficiencyFactor, maxRange, reserveEnergy)
%
%   
%   Inputs:
%       Capacity              - Total battery capacity in kWh
%       VTOL_Range            - VTOL range in nautical miles (default = 115)
%       CTOL_Range            - CTOL range in nautical miles (default = 125)
% 
%   Outputs:
%       totalEnergy_kWh       - Total energy consumed at a given time (kWh)
%       energyRate_kW         - Energy consumption rate (kW)
%       effective_nm_per_kWh  - Efficiency in nautical miles per kWh
%       efficiency            - Efficiency in percentage (%)
% 
%   Example:
%       [totalEnergy, energyRate, efficiency] = EnergyCalculation(data, 100, 0.9, 300, 10);

    %% Calculate Energy Consumption Rate
    % Assuming battery load represents the energy consumption rate
    energyRate_kW = batteryLoad_kW;

    %% Calculate Total Energy Consumed
    % Total energy consumed is the difference between max capacity and remaining capacity
    totalEnergy_kWh = batteryCapacity_kWh - (fuelRemaining / fuelCapacity) * batteryCapacity_kWh;

    %% Adjust Total Energy with Reserve Energy
    totalEnergy_kWh = totalEnergy_kWh - reserveEnergy;

    %% Calculate Effective Range
    % Effective Range is nautical miles per kWh
    efficiency = (speed_knots / energyRate_kW);

    %% Calculate Efficiency
    % Efficiency is Effective Range over ideal range is nautical miles per kWh
    efficiency_nm_per_kWh = (speed_knots / energyRate_kW);

    %% Display Results
    fprintf('Total Energy Consumed: %.2f kWh\n', totalEnergy_kWh);
    fprintf('Energy Consumption Rate: %.2f kW\n', energyRate_kW);
    fprintf('Effective Range: %.2f nautical miles per kWh\n', effective_nm_per_kWh);
    fprintf('Efficiency: %.2f%\n', efficiency);

end