function rad = encoderToRadians(pos)
%ENCODERTORADIANS Converts absolute encoder position into radians in range
%[-pi, pi].

    ENCODE_IN_RAD = 4096 / (2*pi);
    rad = double(pos) / ENCODE_IN_RAD + pi;
    
    % Ensure that in range [-pi, pi]
    if rad > pi
        rad = rad - 2*pi;
    elseif rad < -pi
        rad = rad + 2*pi;
    end
end
