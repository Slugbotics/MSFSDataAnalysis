time = datetime(t, 'InputFormat', 'yyyy-MM-dd HH:mm:ss.SSS');

% Convert time to minutes after the first time
startTime = time(1)
timeMinutes = minutes(time - startTime);

total_rpm = abs(p_rpm_1) + abs(p_rpm_2) + abs(p_rpm_3);

% Create the altitude plot
figure;
%plot(timeMinutes, p_rpm_1, 'g', timeMinutes, p_rpm_2, 'r', timeMinutes, p_rpm_3, 'b');
plot(timeMinutes, total_rpm, 'r');


% Customize the altitude graph
title('RPM Over Time');
xlabel('Time (minutes)');
ylabel('RPM');
grid on;