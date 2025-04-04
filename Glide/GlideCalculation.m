function [KCAS_bg, gamma_bg, D_bg, L_bg, C_D_bg, C_L_bg, glide_ratio, maxGlideDistance_ft, maxGlideDistance_nm, maxGlideDistance_m] = GlideCalculation(W, S, A, C_D0, e, h, phi)
% bestGlideCalc Computes best glide performance for an aircraft (e.g., Cessna 172)
%
%   [KCAS_bg, gamma_bg, D_bg, L_bg, C_D_bg, C_L_bg, glide_ratio, maxGlideDistance_ft, maxGlideDistance_nm, maxGlideDistance_m] 
%       = bestGlideCalc(W, S, A, C_D0, e, h, phi)
%
%   Inputs (with default values):
%       W     - Weight in lbf (default = 2400)
%       S     - Wing reference area in ft^2 (default = 174)
%       A     - Wing aspect ratio (default = 7.38)
%       C_D0  - Parasite drag coefficient (default = 0.037)
%       e     - Airplane efficiency factor (default = 0.72)
%       h     - Altitude in ft (default = 2000)
%       phi   - Bank angle in deg (default = 0)
%
%   Outputs:
%       KCAS_bg              - Best Glide Calibrated Airspeed (kts)
%       gamma_bg             - Best Glide Angle (deg)
%       D_bg                 - Best Glide Drag (lbf)
%       L_bg                 - Best Glide Lift (lbf)
%       C_D_bg               - Drag Coefficient during best glide
%       C_L_bg               - Lift Coefficient during best glide
%       glide_ratio          - Glide ratio (L/D)
%       maxGlideDistance_ft  - Maximum horizontal glide distance (ft)
%       maxGlideDistance_nm  - Maximum horizontal glide distance (nautical miles)
%       maxGlideDistance_m   - Maximum horizontal glide distance (meters)
%
%   Note: This function uses several conversion functions (convlength, convdensity,
%   convvel, correctairspeed, convang, dpressure, and atmoscoesa) which are assumed 
%   to be available in your MATLAB environment or defined elsewhere.
%
%   Example:
%       [KCAS, gamma, D, L, C_D, C_L, GR, dist_ft, dist_nm, dist_m] = bestGlideCalc();

    % Set default values if not provided


    %% Flight Conditions
    % Convert altitude from ft to meters for atmospheric calculations
    h_m = convlength(h, 'ft', 'm');

    % Calculate atmospheric properties at altitude
    [T, a, P, rho] = atmoscoesa(h_m, 'Warning');

    % Convert density from kg/m^3 to slug/ft^3 (for consistency with English units)
    rho = convdensity(rho, 'kg/m^3', 'slug/ft^3');

    %% Calculate Best Glide True Airspeed (TAS_bg)
    % TAS_bg = sqrt((2*W)/(rho*S)) * (1/(4*C_D0^2 + C_D0*pi*e*A*cos(phi)^2))^(1/4)
    % Note: phi is zero by default so cos(phi)=1.
    TAS_bg = sqrt((2*W)/(rho*S)) * (1 / ( (4*(C_D0^2)) + (C_D0*pi*e*A*(cosd(phi)^2)) ))^(1/4);  % ft/s

    % Convert TAS to knots (KTAS)
    KTAS_bg = convvel(TAS_bg, 'ft/s', 'kts');

    % Correct to KCAS (Calibrated Airspeed)
    KCAS_bg = correctairspeed(KTAS_bg, a, P, 'TAS', 'CAS');

    %% Calculate Best Glide Angle (γ_bg)
    % Best glide angle (radians) is calculated as:
    %   sin(γ_bg) = -sqrt((4*C_D0)/(pi*e*A*cos(phi)^2 + 4*C_D0))
    gamma_bg_rad = asin( -sqrt((4*C_D0) / (pi*e*A*(cosd(phi)^2) + 4*C_D0)) );
    % Convert glide angle to degrees
    gamma_bg = convang(gamma_bg_rad, 'rad', 'deg');

    %% Calculate Best Glide Drag and Lift
    % Drag and Lift are given by:
    D_bg = -W * sin(gamma_bg_rad);   % lbf
    L_bg = W * cos(gamma_bg_rad);      % lbf

    %% Calculate Dynamic Pressure and Coefficients
    % Compute dynamic pressure using the true airspeed and density.
    % Assuming dpressure takes an [n x 3] matrix where the first column is speed.
    qbar = dpressure([TAS_bg, 0, 0], rho);

    % Calculate drag and lift coefficients.
    C_D_bg = D_bg / (qbar*S);
    C_L_bg = L_bg / (qbar*S);

    %% Calculate Maximum Horizontal Glide Distance
    % The glide ratio (L/D) is given by cot(|γ_bg|) 
    glide_ratio = cot(abs(gamma_bg_rad));
    maxGlideDistance_ft = h * glide_ratio;
    maxGlideDistance_nm = convlength(maxGlideDistance_ft, 'ft', 'naut mi');
    maxGlideDistance_m = convlength(maxGlideDistance_ft, 'ft', 'm');

    %% Display Best Glide Quantities
    fprintf('Best Glide Calibrated Airspeed (KCAS): %.1f kts\n', KCAS_bg);
    fprintf('Best Glide Angle (γ): %.2f deg\n', gamma_bg);
    fprintf('Best Glide Drag (D_bg): %.1f lbf\n', D_bg);
    fprintf('Best Glide Lift (L_bg): %.1f lbf\n', L_bg);
    fprintf('Drag Coefficient (C_D_bg): %.3f\n', C_D_bg);
    fprintf('Lift Coefficient (C_L_bg): %.4f\n', C_L_bg);
    fprintf('Glide Ratio (L/D): %.2f\n', glide_ratio);
    fprintf('Maximum Horizontal Glide Distance: %.1f ft (%.2f NM)\n', maxGlideDistance_ft, maxGlideDistance_nm);

end
