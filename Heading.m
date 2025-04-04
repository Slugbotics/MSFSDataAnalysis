% Heading = p_h_true
time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
heading = p_h_true * (180/pi);

% Convert time to minutes after the first time
startTime = time(1);
timeMinutes = minutes(time - startTime);

% Create the heading plot
figure;
plot(timeMinutes, heading, '-');

% Customize the graph
title('Heading Over Time');
xlabel('Time (minutes)');
ylabel('Heading (degrees)');
grid on;

% Calculate turn rate using gradient
turnRate = gradient(heading);

% Create the turn rate plot
figure;
plot(timeMinutes, turnRate, '-');

% Customize the graph
title('Turn Rate Over Time');
xlabel('Time (minutes)');
ylabel('Turn Rate (degrees/min)');
grid on;
