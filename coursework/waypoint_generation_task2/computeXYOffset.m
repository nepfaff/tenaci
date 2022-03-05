function [xOffset, yOffset] = computeXYOffset(offset, waypoint)
%COMPUTEXYOFFSET
    
    % We don't care about the z-value or theta (theoretically could move
    % all but joint angle 1:
    % We want the waypoint to be potentially reachable after offseting it,
    % even if it is not currently reachable
    for z = 0 : 0.01 : 0.5
        for theta = -pi/2 : 0.15 : pi/2
            ik_sols = OpenManipIK(waypoint.x, waypoint.y, z, theta);
            if isempty(ik_sols)
                continue;
            end
            [ik_sol, err] = getFirstValidIKSol(ik_sols);
            if err
                continue;
            end
            break;
        end
        if isempty(ik_sols)
            continue;
        end
        [ik_sol, err] = getFirstValidIKSol(ik_sols);
        if err
            continue;
        end
        break;
    end
    if z == 0.5
       fprintf("Target = X: %f, Y: %f, Z: %f, Th: %f\n",...
                waypoint.x, waypoint.y, waypoint.z, waypoint.theta);
       error("computeXYOffset: No valid IK solution found\n"); 
    end
    
    % Angle in x-y plane (always in range [-pi, pi])
    angle = ik_sol.joint1_angle;
    
    % These appear switched as angle 0 is 90 degrees in normal plane
    % xOffset's sign is such that the offset can be subtracted when going
    % from pick facing down to place facing straight
    xOffset = -offset*sin(angle);
    yOffset = abs(offset*cos(angle));
end
