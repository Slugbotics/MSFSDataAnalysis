data = Database(32);
t = data.time_inserted; 

MapPos();
SpeedAltitudePlots();
Thrust();
Bank();
Heading();
Pitch();
ControlSurfaces();

GroundElevation();
%{
addpath(genpath('./Glide/'));
addpath(genpath('./TerrainData/'));
GlideParameters();
GlideDisplay();
%}
