% Fuel = fuel_current / fuel_max * 100 (percentage)
time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
fuelPercentage = (fuel_current ./ fuel_max) * 100;

% Convert time to minutes after the first time
startTime = time(1);
timeMinutes = minutes(time - startTime);

% Create the fuel percentage plot
figure;
plot(timeMinutes, fuelPercentage, '-b', 'LineWidth', 2);

% Customize the graph
title('Fuel Percentage Over Time');
xlabel('Time (minutes)');
ylabel('Fuel Remaining (%)');
grid on;

% Calculate fuel consumption rate using gradient
fuelConsumptionRate = -gradient(fuel_current);

% Smooth the fuel consumption rate over 1-minute intervals
windowSize = 1; % 1 minute
smoothedFuelConsumptionRate = movmean(fuelConsumptionRate, windowSize * 60); % Assuming data is per second

% Create the fuel consumption rate plot
figure;
plot(timeMinutes, fuelConsumptionRate, '-r', 'LineWidth', 2); % Original line
hold on;
plot(timeMinutes, smoothedFuelConsumptionRate, '-g', 'LineWidth', 2); % Smoothed line
hold off;

% Customize the graph
title('Fuel Consumption Rate Over Time');
xlabel('Time (minutes)');
ylabel('Fuel Consumption Rate (units/min)');
legend('Original', 'Smoothed (1-min avg)');
grid on;