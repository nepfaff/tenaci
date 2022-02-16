function violateJointLimits = DoJointAnglesViolateJointLimits(joint1_angle, joint2_angle, joint3_angle, joint4_angle)
%DOJOINTANGLESVIOLATEJOINTLIMITS Returns true if the joint angles violate
%the joint limits.
    
    violateJointLimits = false;
    
    if joint1_angle > pi || joint1_angle < -pi
        violateJointLimits = true;
    end

    if joint2_angle > 1.67 || joint2_angle < -2.05
        violateJointLimits = true;
    end
    
    if joint3_angle > 1.53 || joint3_angle < -1.67
        violateJointLimits = true;
    end
    
    if joint4_angle > 2.0 || joint4_angle < -1.8
        violateJointLimits = true;
    end
end
