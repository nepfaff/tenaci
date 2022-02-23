function [jointAngles, times] = TaskSpaceTrajectorySetPoints(startWaypoint, endWaypoint, timeForTrajectory, samplePeriod)
%TASKSPACETRAJECTORYSETPOINTS Returns samples of a cubic task space
%interpolation in joint space representation.
    
    startToolPose = waypointToPoseVector(startWaypoint);
    endToolPose = waypointToPoseVector(endWaypoint);
    
    toolPoseDelta = endToolPose - startToolPose;
    
    % Polynomical coefficients
    a0 = startToolPose;
    a1 = 0;
    a2 = 3 / (timeForTrajectory^2) * toolPoseDelta;
    a3 = -2 / (timeForTrajectory^3) * toolPoseDelta;
    
    % Sample polynomial
    jointAngles = [];
    times = [];
    for t = 0 : samplePeriod : timeForTrajectory
        tool_pose = a0 + a1*t + a2*t^2 + a3*t^3;
        
        % Covert into joint space
        ik_sols = OpenManipIK(tool_pose(1), tool_pose(2), tool_pose(3), tool_pose(4));
        if length(ik_sols) == 0
            fprintf("TaskSpaceTrajectorySetPoints: No solutions found");
        end
        ik_sol = getFirstValidIKSol(ik_sols);
        
        jointAngles = [jointAngles, ik_sol];
        times = [times, t];
    end
end

function toolPose = waypointToPoseVector(waypoint)
    toolPose = [waypoint.x, waypoint.y, waypoint.z, waypoint.theta];
end
