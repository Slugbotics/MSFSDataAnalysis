function data = get_data(run_id) 
    % Database connection settings
    username = 'root'; % Replace with your database username
    password = 'slugbotics@123!'; % Replace with your database password
    dbname = 'citris_db'; % Replace with your database name
    host = 'localhost';   % Change this if your database is remote
    port = '3306';        % Default MySQL port
    
    javaaddpath('C:\Users\SOMARS\CITRIS\mysql-connector-j-9.2.0\mysql-connector-j-9.2.0.jar');

    % Create the database connection
    conn = database(dbname, username, password, 'Vendor', 'MySQL', 'Server', host, 'Port', str2double(port));

    % Check connection status
    if isopen(conn)
        disp('Database connection successful!');
    else
        disp(conn.Message);
        error('Database connection failed!');
    end

    % SQL query to retrieve latitude and longitude data
    sqlQuery = sprintf('SELECT * FROM per_step_data WHERE run_id=%d ORDER BY collection_step', run_id);
    data = fetch(conn, sqlQuery);

    % Close the database connection
    close(conn);

    dataStruct = table2struct(data);
    
    Var_Mapping(dataStruct);

    dataStruct;
end