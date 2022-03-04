function [xOffset, yOffset] = computePickDownOffsetXY(offset, waypoint)
%COMPUTEPICKDOWNOFFSETXY

    ik_sols = OpenManipIK(waypoint.x, waypoint.y, waypoint.z, waypoint.theta);
        if isempty(ik_sols)
            fprintf("Target = X: %f, Y: %f, Z: %f, Th: %f\n",...
                waypoint.x, waypoint.y, waypoint.z, waypoint.theta);
            error("computePickDownOffsetXY: No IK solutions found\n");
        end
    [ik_sol, err] = getFirstValidIKSol(ik_sols);
    if err
       fprintf("Target = X: %f, Y: %f, Z: %f, Th: %f\n",...
                waypoint.x, waypoint.y, waypoint.z, waypoint.theta);
       error("computePickDownOffsetXY: No valid IK solution found\n");
    end
    
    % Angle in x-y plane (always in range [-pi, pi])
    angle = ik_sol.joint1_angle;
    
    % These appear switched as angle 0 is 90 degrees in normal plane
    % xOffset's sign is such that the offset can be subtracted when going
    % from pick facing down to place facing straight
    xOffset = -offset*sin(angle);
    yOffset = abs(offset*cos(angle));
end
