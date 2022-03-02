function pos = radiansToEncoder(rad)
%RADIANSTOENCODER Converts radians in range [-pi, pi] into absolute encoder
% position in range [0, 4096].
    
    RAD_IN_ENCODE = (2*pi) / 4096;
    pos = int32(double(rad) / RAD_IN_ENCODE + 2048);
end
