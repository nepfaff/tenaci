function newWaypoint = modifyWaypointToAvoidJointLimitsUsingTheta(waypoint)
%MODIFYWAYPOINTTOAVOIDJOINTLIMITSUSINGTHETA
    
    newWaypoint = waypoint;
    minTheta = waypoint.theta - 0.5;
    while (true)
        if (doValidIKExist(newWaypoint) || newWaypoint.theta < minTheta)
            return
        end
        
        newWaypoint.theta = newWaypoint.theta - 0.01;
    end
end
