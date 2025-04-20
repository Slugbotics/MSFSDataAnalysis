function alt = getAlt(rawAlt)
    if ischar(rawAlt) || isstring(rawAlt)
        if strcmpi(rawAlt, "ground")
            alt = 0;
        else                       % numeric altitude stored as text
            alt = str2double(rawAlt);
            if isnan(alt), alt = 0; end
        end
    elseif isempty(rawAlt) || isnan(rawAlt)
        alt = 0;
    else                           % already numeric
        alt = rawAlt;
    end
end