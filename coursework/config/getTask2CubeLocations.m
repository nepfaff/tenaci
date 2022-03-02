function [startLocations, endLocations] = getTask2CubeLocations()
%GETTASK2CUBELOCATIONS

    start1.x = 0.2;
    start1.y = 0.075;
    start1.direction = "front";
    
    start2.x = 0.0;
    start2.y = 0.225;
    start2.direction = "down";
    
    start3.x = -0.15;
    start3.y = 0.15;
    start3.direction = "front";
    
    finish1.x = 0.125;
    finish1.y = 0.125;
    
    finish2.x = 0.0;
    finish2.y = 0.1;
    
    finish3.x = -0.1;
    finish3.y = 0.0;
    
    startLocations = [start1, start2, start3];
    endLocations = [finish1, finish2, finish3];
end
