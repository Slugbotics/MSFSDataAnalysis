data = Database(22);
t = data.time_inserted; 
latitudes = p_lat;
longitudes = p_lon;
height_agl = a_agl;


MapPos();

addpath(genpath('../FAAObjects'));
addpath(genpath('../FAAObjects/DOF_250119'));
object_data_parser(latitudes, longitudes, height_agl);

%{

Fuel();
Thrust();

%addpath(genpath('./Terrain/'));
%addpath(genpath('./TerrainData/'));
%test();

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
