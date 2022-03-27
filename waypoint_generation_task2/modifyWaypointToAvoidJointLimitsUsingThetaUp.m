function newWaypoint = modifyWaypointToAvoidJointLimitsUsingThetaUp(waypoint)
%MODIFYWAYPOINTTOAVOIDJOINTLIMITSUSINGTHETAUP
    
    newWaypoint = waypoint;
    maxTheta = waypoint.theta + 0.5;
    while (true)
        if (doValidIKExist(newWaypoint) || newWaypoint.theta > maxTheta)
            return
        end
        
        newWaypoint.theta = newWaypoint.theta + 0.01;
    end
end
