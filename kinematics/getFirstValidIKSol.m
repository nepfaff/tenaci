function [sol, err] = getFirstValidIKSol(sols)
%GETFIRSTVALIDIKSOL Returns the first IK solution that does not violate any
%joint limits.
    
    sol = -1;
    err = false;
    for i = 1:4
        if ~DoJointAnglesViolateJointLimits(sols(i).joint1_angle, sols(i).joint2_angle, sols(i).joint3_angle, sols(i).joint4_angle)
            sol = sols(i);
            return
        end
    end
    if sol == -1
       err = true; 
    end
end
