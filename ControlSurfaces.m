% Rudder = rud_def
time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
rudder = rud_def;

% Convert time to minutes after the first time
startTime = time(1);
timeMinutes = minutes(time - startTime);

% Create the rudder plot
figure;
plot(timeMinutes, rudder, '-');

% Customize the graph
title('Rudder Deflection Over Time');
xlabel('Time (minutes)');
ylabel('Rudder (degrees)');
grid on;

% Elevator = ele_def
time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
elevator = ele_def;

% Create the elevator plot
figure;
plot(timeMinutes, elevator, '-');

% Customize the graph
title('Elevator Deflection Over Time');
xlabel('Time (minutes)');
ylabel('Elevator (degrees)');
grid on;

% Aileron = ail_avg_def
time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
aileron = ail_avg_def;

% Create the aileron plot
figure;
plot(timeMinutes, aileron, '-');

% Customize the graph
title('Aileron Deflection Over Time');
xlabel('Time (minutes)');
ylabel('Aileron (degrees)');
grid on;
