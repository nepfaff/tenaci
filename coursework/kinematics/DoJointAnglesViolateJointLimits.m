function violateJointLimits = DoJointAnglesViolateJointLimits(joint1_angle, joint2_angle, joint3_angle, joint4_angle)
%DOJOINTANGLESVIOLATEJOINTLIMITS Returns true if the joint angles violate
%the joint limits.
    
    violateJointLimits = false;
    
    if joint1_angle > pi+0.05 || joint1_angle < -pi-0.05
        violateJointLimits = true;
    end

    if joint2_angle > 1.92 || joint2_angle < -2.09
        violateJointLimits = true;
    end
    
    if joint3_angle > 1.54 || joint3_angle < -2.07
        violateJointLimits = true;
    end
    
    if joint4_angle > 2.15 || joint4_angle < -2
        violateJointLimits = true;
    end
end
