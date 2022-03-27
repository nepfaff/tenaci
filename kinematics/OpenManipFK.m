function [x, y, z, theta] = OpenManipFK(joint1_angle, joint2_angle, joint3_angle, joint4_angle)
%OPENMANIPFK FK for OpenManipulator-X robot.
%Returns the robot's tool position.

    T01 = tfFromDH(0.0, 0.0, 0.0, joint1_angle + pi/2.0);
    T12 = tfFromDH(0.0, 0.0, 0.077, 0.0);
    T23 = tfFromDH(pi/2.0, 0.0, 0.0, 0.0);
    T34 = tfFromDH(0.0, 0.0, 0.0, -joint2_angle + pi/2.0 - atan(0.024 / 0.128));
    T45 = tfFromDH(0.0, 0.130, 0.0, -joint3_angle - pi/2.0 + atan(0.024 / 0.128));
    T56 = tfFromDH(0.0, 0.124, 0.0, -joint4_angle);
    T67 = tfFromDH(0.0, 0.126, 0.0, 0.0);
    
    % Joint 1 pose = T01
    % Joint 2 pose = T01 * T12 * T23 * T34
    % Joint 3 pose = T01 * T12 * T23 * T34 * T45
    % Joint 4 pose = T01 * T12 * T23 * T34 * T45 * T56
    
    tool_position = T01*T12*T23*T34*T45*T56*T67 * [0, 0, 0, 1]';
    x = tool_position(1);
    y = tool_position(2);
    z = tool_position(3);
    
    % Obtain tool orientation using IK subsystem 2
    subsystem2_pose = T34*T45*T56*T67;
    % theta = atan2(sin(theta), cos(theta))
    theta = atan2(subsystem2_pose(2,1), subsystem2_pose(1,1));
end
