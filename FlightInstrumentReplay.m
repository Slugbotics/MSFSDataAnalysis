% Create the UI figure (instruments panel)
fig = uifigure('Name','Flight Instruments',...
    'Position',[100 100 572 502],...
    'Color',[0.2667 0.2706 0.2784],'Resize','off');
fig.Visible = "off";
fig.UserData.a_msl = a_msl;

% Load a background panel image (optional)
try
    imgPanel = imread('FlightInstrumentPanel.png');
    ax = uiaxes('Parent',fig,'Visible','off','Position',[10 30 530 460],...
        'BackgroundColor',[0.2667 0.2706 0.2784]);
    image(ax,imgPanel);
    disableDefaultInteractivity(ax);
catch ME
    warning('Could not load panel image: %s', ME.message);
end

% Create standard flight instruments
alt = uiaeroaltimeter('Parent',fig,'Position',[369 299 144 144]);
head = uiaeroheading('Parent',fig,'Position',[212 104 144 144]);
air = uiaeroairspeed('Parent',fig,'Position',[56 299 144 144]);
% Adjust airspeed limits for your aircraft (adjust if needed)
air.Limits = [25 250];
air.ScaleColorLimits = [0,60; 50,200; 200,225; 225,250];
hor = uiaerohorizon('Parent',fig,'Position',[212 299 144 144]);
climb = uiaeroclimb('Parent',fig,'Position',[369 104 144 144]);
% Adjust maximum climb rate if necessary
climb.MaximumRate = 8000;
turn = uiaeroturn('Parent',fig,'Position',[56 104 144 144]);

% Create a slider for selecting the time instant to display
sl = uislider('Parent',fig,'Limits',[0 length(t)],'FontColor','white');
sl.Position = [50 60 450 3];
% Create a label to display the current time
lbl = uilabel('Parent',fig,'Text',['Time: ' num2str(sl.Value,4) ' sec'],'FontColor','white');
lbl.Position = [230 10 90 30];

% Assign the slider callback to update instruments
sl.ValueChangingFcn = @(sl, event) flightInstrumentsCallback(event.Value, alt, head, air, hor, turn, a_msl, p_h_true, as_ind, p_pitch, p_bank);

% Create a Play button to start/stop playback
playBtn = uibutton(fig, 'push', 'Text', 'Play', 'FontColor', 'white');
playBtn.Position = [510 10 50 30];

% Variable to store the timer handle
playTimer = [];

% Set the play button callback
playBtn.ButtonPushedFcn = @(src, event) playButtonCallback(playTimer);

% Make the figure visible now that it is set up
fig.Visible = "on";
% The callback function interpolates the instrument values from your data.
function flightInstrumentsCallback(dt, alt, head, air, hor, turn, a_msl, p_h_true, as_ind, p_pitch, p_bank)
    t = round(dt);
    alt.Value = a_msl(t, 1);
    
    head.Value = p_h_true(t,1);
    air.Value = as_ind(t,1);
    hor.Pitch = p_pitch(t,1);
    turn.Value = p_bank(t,1);
 
    % Update the time label
    lbl.Text = ['Timestep: ' num2str(t,4)];
end


% Callback for the Play button
function playButtonCallback(playTimer)
    % Use the timer to update slider value at fixed intervals (e.g., every 0.1 sec)
    if ~isempty(playTimer) && isvalid(playTimer)
        % If timer is running, stop playback
        stop(playTimer);
        delete(playTimer);
        playTimer = [];
        playBtn.Text = 'Play';
    else
        playBtn.Text = 'Stop';
        playTimer = timer('ExecutionMode','fixedRate','Period',0.1, ...
            'TimerFcn', @(~,~) updateSlider());
        start(playTimer);
    end
end

% Timer function to increment the slider value and update instruments
function updateSlider()
    newVal = sl.Value + 1;
    if newVal > sl.Limits(2)
        % Stop timer if reached end of time vector
        newVal = sl.Limits(2);
        stop(playTimer);
        delete(playTimer);
        playTimer = [];
        playBtn.Text = 'Play';
    end
    sl.Value = newVal; % hiiii :3
    flightInstrumentsCallback(newVal, alt, head, air, hor, turn, a_msl, p_h_true, as_ind, p_pitch, p_bank);
    lbl.Text = ['Timestep: ' num2str(round(newVal),4)];
end