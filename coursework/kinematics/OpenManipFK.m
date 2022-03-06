function [x, y, z] = OpenManipFK(joint1_angle, joint2_angle, joint3_angle, joint4_angle)
%OPENMANIPFK FK for OpenManipulator-X robot.
%   Returns robot tool position.

    T01 = tfFromDH(0.0, 0.0, 0.0, joint1_angle + pi/2.0);
    T12 = tfFromDH(0.0, 0.0, 0.077, 0.0);
    T23 = tfFromDH(pi/2.0, 0.0, 0.0, -joint2_angle + pi/2.0 - atan(0.024 / 0.128));
    T34 = tfFromDH(0.0, 0.130, 0.0, -joint3_angle - pi/2.0 + atan(0.024 / 0.128));
    T45 = tfFromDH(0.0, 0.124, 0.0, -joint4_angle);
    T56 = tfFromDH(0.0, 0.126, 0.0, 0.0);
    
    % Joint 1 pose = T01
    % Joint 2 pose = T01 * T12 * T23
    % Joint 3 pose = T01 * T12 * T23 * T34
    % Joint 4 pose = T01 * T12 * T23 * T34 * T45
    
    tool_position = T01*T12*T23*T34*T45*T56 * [0, 0, 0, 1]';
    x = tool_position(1);
    y = tool_position(2);
    z = tool_position(3);
end
