data = Database(40);
t = data.time_inserted; 

MapPos();
SpeedAltitudePlots();
Thrust();
Bank();
Heading();
Pitch();
ControlSurfaces();
Fuel()

GroundElevation();
%{
addpath(genpath('./Glide/'));
addpath(genpath('./TerrainData/'));
GlideParameters();
GlideDisplay();
%}
