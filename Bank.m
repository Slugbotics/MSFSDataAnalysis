% Bank = p_bank
time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');
bank = p_bank * (180/pi);

% Convert time to minutes after the first time
startTime = time(1);
timeMinutes = minutes(time - startTime);

% Create the bank plot
figure;
plot(timeMinutes, bank, '-');

% Customize the graph
title('Bank Over Time');
xlabel('Time (minutes)');
ylabel('Bank (degrees)');
grid on;

% Calculate change using gradient
dp_bank = gradient(bank);

% Create the change in bank plot
figure;
plot(timeMinutes, dp_bank, '-');

% Customize the graph
title('Change in Bank Over Time');
xlabel('Time (minutes)');
ylabel('Change in Bank (degrees/min)');
grid on;

