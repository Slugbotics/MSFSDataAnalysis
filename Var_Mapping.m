function Var_Mapping(dataStruct)
    % Define a full mapping between database column names and MATLAB variable names
    varMap = containers.Map({
        'AMBIENT_DENSITY', 'AMBIENT_PRESSURE', 'AMBIENT_TEMPERATURE', 'AMBIENT_VISIBILITY', ...
        'AMBIENT_WIND_DIRECTION', 'AMBIENT_WIND_VELOCITY', 'AMBIENT_WIND_X', 'AMBIENT_WIND_Y', 'AMBIENT_WIND_Z', ...
        'BAROMETER_PRESSURE', 'DENSITY_ALTITUDE', 'SEA_LEVEL_PRESSURE', ...
        'PROP_BETA_1', 'PROP_BETA_2', 'PROP_BETA_3', 'PROP_ROTATION_ANGLE', 'PROP_RPM_1', 'PROP_RPM_2', ...
        'PROP_RPM_3', 'PROP_THRUST_1', 'PROP_THRUST_2', 'PROP_THRUST_3', ...
        'DYNAMIC_PRESSURE', 'G_FORCE', 'INCIDENCE_ALPHA', 'INCIDENCE_BETA', 'LINEAR_CL_ALPHA', ...
        'TOTAL_WEIGHT', 'TOTAL_WEIGHT_CROSS_COUPLED_MOI', 'TOTAL_WEIGHT_PITCH_MOI', ...
        'TOTAL_WEIGHT_ROLL_MOI', 'TOTAL_WEIGHT_YAW_MOI', 'AMBIENT_IN_CLOUD', ...
        'ACCELERATION_BODY_X', 'ACCELERATION_BODY_Y', 'ACCELERATION_BODY_Z', ...
        'GROUND_VELOCITY', 'PLANE_ALTITUDE', 'PLANE_ALT_ABOVE_GROUND', 'PLANE_BANK_DEGREES', ...
        'PLANE_HEADING_DEGREES_MAGNETIC', 'PLANE_HEADING_DEGREES_TRUE', ...
        'PLANE_LATITUDE', 'PLANE_LONGITUDE', 'PLANE_PITCH_DEGREES', ...
        'ROTATION_VELOCITY_BODY_X', 'ROTATION_VELOCITY_BODY_Y', 'ROTATION_VELOCITY_BODY_Z', ...
        'VELOCITY_BODY_X', 'VELOCITY_BODY_Y', 'VELOCITY_BODY_Z', 'VERTICAL_SPEED', ...
        'AIRCRAFT_WIND_X', 'AIRCRAFT_WIND_Y', 'AIRCRAFT_WIND_Z', ...
        'AIRSPEED_INDICATED', 'AIRSPEED_TRUE', 'AIRSPEED_TRUE_CALIBRATE', ...
        'ANGLE_OF_ATTACK_INDICATOR', 'DELTA_HEADING_RATE', 'HEADING_INDICATOR', ...
        'INDICATED_ALTITUDE', 'RUDDER_DEFLECTION', 'RUDDER_DEFLECTION_PCT', ... 
        'RUDDER_TRIM', 'RUDDER_TRIM_PCT', 'AILERON_AVERAGE_DEFLECTION', ...
        'AILERON_TRIM', 'AILERON_TRIM_PCT', 'ELEVATOR_DEFLECTION', ...
        'ELEVATOR_DEFLECTION_PCT', 'ELEVATOR_POSITION', 'GENERAL_ENG_THROTTLE_LEVER_POSITION', ...
        'GENERAL_ENG_THROTTLE_LEVER_POSITION_2', 'GENERAL_ENG_THROTTLE_LEVER_POSITION_3', ...
        'FUEL_TOTAL_CAPACITY', 'FUEL_TOTAL_QUANTITY', 'ELECTRICAL_BATTERY_ESTIMATED_CAPACITY_PCT', ...
        'ELECTRICAL_BATTERY_LOAD', 'ELECTRICAL_BATTERY_VOLTAGE', 'ELECTRICAL_BATTERY_BUS_AMPS', ...
        'ELECTRICAL_BATTERY_BUS_VOLTAGE'
        }, {
            'a_dens', 'a_pres', 'OAT', 'vis', ...
            'wind_dir', 'wind_vel', 'a_wind_x', 'a_wind_y', 'a_wind_z', ...
            'b_pres', 'd_alt', 'sl_pres', ...
            'p_beta_1', 'p_beta_2', 'p_beta_3', 'p_rot_ang', 'p_rpm_1', ...
            'p_rpm_2', 'p_rpm_3', 'p_thrust_1', 'p_thrust_2', 'p_thrust_3'...
            'd_pres', 'g_f', 'inc_alpha', 'inc_beta', 'l_cl_alpha', ...
            't_weight', 't_weight_cc_moi', 't_weight_p_moi', ...
            't_weight_r_moi', 't_weight_y_moi', 'a_in_cloud', ...
            'a_x', 'a_y', 'a_z', ...
            'g_vel', 'a_msl', 'a_agl', 'p_bank', ...
            'p_h_mag', 'p_h_true', ...
            'p_lat', 'p_lon', 'p_pitch', ... 
            'w_x', 'w_y', 'w_z', ...
            'v_x', 'v_y', 'v_z', 'v_s', ...
            'ac_wind_x', 'ac_wind_y', 'ac_wind_y', ...
            'as_ind', 'as_true', 'as_true_cal', ...
            'aoa_ind', 'del_h_rate', 'h_ind', ...
            'ind_alt', 'rud_def', 'rud_def_pct' ...
            'rud_trim', 'rud_trim_pct', 'ail_avg_def' ... 
            'ail_trim', 'ail_trim_pct', 'ele_def' ...
            'ele_def_pct', 'ele_pos', 'gen_eng_thr_pos'...
            'gen_eng_thr_pos_2', 'gen_eng_thr_pos_3', ...
            'fuel_max', 'fuel_current', 'bat_cap', ... 
            'bat_load', 'bat_voltage', 'bat_bus_amps', ...
            'bat_bus_voltage'

    });

    mappedData = struct();
    fields = fieldnames(dataStruct);

    for i = 1:length(fields)
        fieldName = fields{i};
        if isKey(varMap, fieldName)
            mappedFieldName = varMap(fieldName);
            
            % Extract the full array (all time steps)
            mappedData.(mappedFieldName) = [dataStruct.(fieldName)]';  % Ensure column vector
            
            % Assign to workspace
            assignin('base', mappedFieldName, mappedData.(mappedFieldName));
        end
    end
end
