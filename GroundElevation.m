% Ground Elevation = a_msl - a_agl
time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
groundElevation = a_msl - a_agl;


% Convert time to minutes after the first time
startTime = time(1);
timeMinutes = minutes(time - startTime);

% Create the ground elevation plot
figure;
plot(timeMinutes, groundElevation, '-');

% Customize the graph
title('Ground Elevation Over Time');
xlabel('Time (minutes)');
ylabel('Elevation (feet)');
grid on;

altitude = a_msl;

% Create a unified plot
figure;
plot(timeMinutes, altitude, '-');
hold on;
plot(timeMinutes, groundElevation, '-');


% Customize the unified graph
title('Altitude and Elevation Over Time');
xlabel('Time (minutes)');
ylabel('MSL Altitude (feet)');
grid on;

% Create a unified plot
figure;
plot(timeMinutes, a_agl, '-');


% Customize the unified graph
title('Elevation Clearance Over Time');
xlabel('Time (minutes)');
ylabel('AGL Altitude (feet)');
grid on;