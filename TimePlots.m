time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
altitude = a_msl;
speed = as_true;
ambient_density = a_dens;
ambient_pressure = a_pres;
ambient_temperature = OAT;

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

% Create a unified plot
figure;
[ax, h1, h2] = plotyy(timeMinutes, altitude, timeMinutes, speed);

% Customize the unified graph
title('Altitude, Speed, and Ambient Conditions Over Time');
xlabel('Time (minutes)');
ax(1).YLabel.String = 'Altitude (feet)';
ax(2).YLabel.String = 'Speed (knots)';
h1.LineStyle = '-';
h2.LineStyle = '-';
grid on;

% Add ambient density to the unified plot
hold(ax(1), 'on');
plot(ax(1), timeMinutes, ambient_density, '-b');
legend(ax(1), 'Altitude', 'Ambient Density');

% Add ambient pressure and temperature to the unified plot
hold(ax(2), 'on');
plot(ax(2), timeMinutes, ambient_pressure, '-r');
plot(ax(2), timeMinutes, ambient_temperature, '-g');
legend(ax(2), 'Speed', 'Ambient Pressure', 'Ambient Temperature');