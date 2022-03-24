function [startLocations, endLocations] = getTask2CubeLocations()
%GETTASK2CUBELOCATIONS

    start1.x = 0.175;
    start1.y = 0.175;
    start1.direction = "back";
    
    start2.x = -0.05;
    start2.y = 0.175;
    start2.direction = "down";
    
    start3.x = -0.175;
    start3.y = 0.0;
    start3.direction = "front";
    
    finish1.x = 0.15;
    finish1.y = 0.0;
    
    finish2.x = 0.1;
    finish2.y = 0.1;
    
    finish3.x = 0.0;
    finish3.y = 0.225;
    
    startLocations = [start3, start2, start1];
    endLocations = [finish1, finish2, finish3];
end
