function [jointAngles, times, failedPoints] = TaskSpaceTrajectorySetPoints(...
    startWaypoint, endWaypoint, timeForTrajectory, samplePeriod)
%TASKSPACETRAJECTORYSETPOINTS Returns samples of a cubic task space
%interpolation in joint space representation.
%failedPoints is equal to the number of set-points that were skipped due to
%non-valid IK solutions.

    failedPoints = 0;
    
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
        if isempty(ik_sols)
%             fprintf("Target = X: %f, Y: %f, Z: %f, Th: %f\n",...
%                 tool_pose(1), tool_pose(2), tool_pose(3), tool_pose(4));
%             printWaypoints([startWaypoint, endWaypoint]);
%             error("TaskSpaceTrajectorySetPoints: No IK solutions found. Time = %d\n", t);

            failedPoints = failedPoints + 1;
            continue
        end
        [ik_sol, err] = getFirstValidIKSol(ik_sols);
        if err
%            fprintf("Target = X: %f, Y: %f, Z: %f, Th: %f\n",...
%                 tool_pose(1), tool_pose(2), tool_pose(3), tool_pose(4));
%            printWaypoints([startWaypoint, endWaypoint]);
%            error("TaskSpaceTrajectorySetPoints: No valid IK solution found. Time = %d\n", t);
    
           failedPoints = failedPoints + 1;
           continue
        end
        
        jointAngles = [jointAngles, ik_sol];
        times = [times, t];
    end
end

function toolPose = waypointToPoseVector(waypoint)
    toolPose = [waypoint.x, waypoint.y, waypoint.z, waypoint.theta];
end
