% Pitch = p_pitch
time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
pitch = p_pitch;

% Convert time to minutes after the first time
startTime = time(1);
timeMinutes = minutes(time - startTime);

% Create the pitch plot
figure;
plot(timeMinutes, pitch, '-');

% Customize the graph
title('Pitch Over Time');
xlabel('Time (minutes)');
ylabel('Pitch (degrees)');
grid on;

% Calculate change using gradient
dp_pitch = gradient(pitch);

% Create the change in pitch plot
figure;
plot(timeMinutes, dp_pitch, '-');

% Customize the graph
title('Change in Pitch Over Time');
xlabel('Time (minutes)');
ylabel('Change in Pitch (degrees/min)');
grid on;
