function printWaypoints(waypoints)
%PRINTWAYPOINT Prints the waypoint structs in waypoints.

    for i = 1 : length(waypoints)
       waypoint = waypoints(i);
       fprintf("Waypoint %i = X: %f, Y: %f, Z: %f, Th: %f\n",...
            i, waypoint.x, waypoint.y, waypoint.z, waypoint.theta); 
    end
end
