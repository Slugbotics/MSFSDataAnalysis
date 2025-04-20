data = Database(44);
t = data.time_inserted; 

MapPos();
Fuel();
Thrust();

%addpath(genpath('./Terrain/'));
%addpath(genpath('./TerrainData/'));
%test();

%{
SpeedAltitudePlots();

Thrust();
Bank();
Heading();
Pitch();
ControlSurfaces();
Fuel();
%}


%GroundElevation();

%{
addpath(genpath('./Glide/'));
addpath(genpath('./TerrainData/'));
GlideParameters();
GlideDisplay();
%}
