% Vertical Speed = v_s
time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
verticalSpeed = v_s;

% Convert time to minutes after the first time
startTime = time(1);
timeMinutes = minutes(time - startTime);

% Create the vertical speed plot
figure;
plot(timeMinutes, verticalSpeed, '-');

% Customize the graph
title('Vertical Speed Over Time');
xlabel('Time (minutes)');
ylabel('Vertical Speed (units)');
grid on;

% Calculate change using gradient (keeps the same vector length)
dv_s = gradient(verticalSpeed);

% Create the change in vertical speed plot
figure;
plot(timeMinutes, dv_s, '-');

% Customize the graph
title('Change in Vertical Speed Over Time');
xlabel('Time (minutes)');
ylabel('Change in Vertical Speed (units/min)');
grid on;
