time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
altitude = a_msl;
speed = as_true;
ambient_density = a_dens;
ambient_pressure = a_pres;
ambient_temperature = OAT;
ambient_visibility = vis;
ambient_wind_direction = wind_dir;
ambient_wind_velocity = wind_vel;
ambient_wind_x = a_wind_x;
ambient_wind_y = a_wind_y;
ambient_wind_z = a_wind_z;
barometer_pressure = b_pres;

% Convert time to minutes after the first time
startTime = time(1);
timeMinutes = minutes(time - startTime);

% Create the altitude plot
figure;
plot(timeMinutes, altitude, '-');
hold on;
fill([timeMinutes; flipud(timeMinutes)], [altitude; zeros(size(altitude))], 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
hold off;

% Customize the altitude graph
title('Altitude Over Time');
xlabel('Time (minutes)');
ylabel('Altitude (feet)');
grid on;

% Create the speed plot
figure;
plot(timeMinutes, speed, '-');

% Customize the speed graph
title('Speed Over Time');
xlabel('Time (minutes)');
ylabel('Speed (knots)');
grid on;

% Create the ambient density plot
figure;
plot(timeMinutes, ambient_density, '-');

% Customize the ambient density graph
title('Ambient Density Over Time');
xlabel('Time (minutes)');
ylabel('Ambient Density (kg/m^3)');
grid on;

% Create the ambient pressure plot
figure;
plot(timeMinutes, ambient_pressure, '-');

% Customize the ambient pressure graph
title('Ambient Pressure Over Time');
xlabel('Time (minutes)');
ylabel('Ambient Pressure (Pa)');
grid on;

% Create the ambient temperature plot
figure;
plot(timeMinutes, ambient_temperature, '-');

% Customize the ambient temperature graph
title('Ambient Temperature Over Time');
xlabel('Time (minutes)');
ylabel('Ambient Temperature (°C)');
grid on;

% Create the ambient visibility plot
figure;
plot(timeMinutes, ambient_visibility, '-');

% Customize the ambient visibility graph
title('Ambient Visibility Over Time');
xlabel('Time (minutes)');
ylabel('Ambient Visibility (miles)');
grid on;

% Create the ambient wind direction plot
figure;
plot(timeMinutes, ambient_wind_direction, '-');

% Customize the ambient wind direction graph
title('Ambient Wind Direction Over Time');
xlabel('Time (minutes)');
ylabel('Ambient Wind Direction (degrees)');
grid on;

% Create the ambient wind X component plot
figure;
plot(timeMinutes, ambient_wind_x, '-');

% Customize the ambient wind X component graph
title('Ambient Wind X Component Over Time');
xlabel('Time (minutes)');
ylabel('Ambient Wind X Component (m/s)');
grid on;

% Create the ambient wind Y component plot
figure;
plot(timeMinutes, ambient_wind_y, '-');

% Customize the ambient wind Y component graph
title('Ambient Wind Y Component Over Time');
xlabel('Time (minutes)');
ylabel('Ambient Wind Y Component (m/s)');
grid on;

% Create the ambient wind Z component plot
figure;
plot(timeMinutes, ambient_wind_z, '-');

% Customize the ambient wind Z component graph
title('Ambient Wind Z Component Over Time');
xlabel('Time (minutes)');
ylabel('Ambient Wind Z Component (m/s)');
grid on;

% Create the barometer pressure plot
figure;
plot(timeMinutes, barometer_pressure, '-');

% Customize the barometer pressure graph
title('Barometer Pressure Over Time');
xlabel('Time (minutes)');
ylabel('Barometer Pressure (Pa)');
grid on;

% Create a unified plot for ambient density, temperature, and pressure
figure;
hold on;
plot(timeMinutes, ambient_density, '-b');
plot(timeMinutes, ambient_pressure, '-r');
plot(timeMinutes, ambient_temperature, '-g');
hold off;

% Customize the unified ambient conditions graph
title('Ambient Density, Temperature, and Pressure Over Time');
xlabel('Time (minutes)');
ylabel('Values');
legend('Ambient Density', 'Ambient Pressure', 'Ambient Temperature');
grid on;

% Create a unified plot for wind components
figure;
hold on;
plot(timeMinutes, ambient_wind_direction, '-g')
plot(timeMinutes, ambient_wind_x, '-k');
plot(timeMinutes, ambient_wind_y, '--b');
plot(timeMinutes, ambient_wind_z, '--r');
hold off;

% Customize the unified wind components graph
title('Wind Components Over Time');
xlabel('Time (minutes)');
ylabel('Values');
legend('Wind X', 'Wind Y', 'Wind Z');
grid on;

% Create a plot for ambient visibility
figure;
plot(timeMinutes, ambient_visibility, '-');

% Customize the ambient visibility graph
title('Ambient Visibility Over Time');
xlabel('Time (minutes)');
ylabel('Ambient Visibility (miles)');
grid on;