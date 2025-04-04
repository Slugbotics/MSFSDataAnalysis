
time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
altitude = a_msl;
speed = as_true;

% Convert time to minutes after the first time
startTime = time(1)
timeMinutes = minutes(time - startTime);

% Create the altitude plot
figure;
plot(timeMinutes, altitude, '-');

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

% Create a unified plot
figure;
[ax, h1, h2] = plotyy(timeMinutes, altitude, timeMinutes, speed);

% Customize the unified graph
title('Altitude and Speed Over Time');
xlabel('Time (minutes)');
ax(1).YLabel.String = 'Altitude (feet)';
ax(2).YLabel.String = 'Speed (knots)';
h1.LineStyle = '-';
h2.LineStyle = '-';
grid on;