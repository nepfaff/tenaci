
clc;
clear;
close all;
%
% 
timeForTrajectory = 1
samplePeriod = 0.1
% 
% % Define waypoints (must include startPose!)
waypoint1.x = 0.0;
waypoint1.y = 0.2;
waypoint1.z = 0.1;
waypoint1.theta = -0.523;
waypoint1.gripper = 0;

waypoint2.x = 0;
waypoint2.y = 0.2;
waypoint2.z = 0.2;
waypoint2.theta =-0.523;
waypoint2.gripper = 0

waypoint3.x = 0;
waypoint3.y = 0.1;
waypoint3.z = 0.2;
waypoint3.theta = -0.523;
waypoint3.gripper = 0;

waypoint4.x = 0;
waypoint4.y = 0.1;
waypoint4.z = 0.1;
waypoint4.theta = -0.523;
waypoint4.gripper = 0;
%

waypoint5.x = -0.05;
waypoint5.y = 0.05;
waypoint5.z = 0.1;
waypoint5.theta = -0.723;
waypoint5.gripper = 0;

waypoint6.x = -0.05;
waypoint6.y = 0.15;
waypoint6.z = 0.1;
waypoint6.theta =-0.723;
waypoint6.gripper = 0

waypoint7.x = 0.05;
waypoint7.y = 0.15;
waypoint7.z = 0.1;
waypoint7.theta = -0.723;
waypoint7.gripper = 0;

waypoint8.x = 0.05;
waypoint8.y = 0.05;
waypoint8.z = 0.1;
waypoint8.theta = -0.723;
waypoint8.gripper = 0;

waypoint9.x = -0.05;
waypoint9.y = 0.2;
waypoint9.z = 0.1;
waypoint9.theta = -0.523;
waypoint9.gripper = 0;

waypoint10.x = -0.05;
waypoint10.y = 0.2;
waypoint10.z = 0.2;
waypoint10.theta =-0.523;
waypoint10.gripper = 0

waypoint11.x = 0.05;
waypoint11.y = 0.2;
waypoint11.z = 0.2;
waypoint11.theta = -0.523;
waypoint11.gripper = 0;

waypoint12.x = 0.05;
waypoint12.y = 0.2;
waypoint12.z = 0.1;
waypoint12.theta = -0.523;
waypoint12.gripper = 0;

waypoints_yz = [waypoint1, waypoint2, waypoint3, waypoint4]
waypoints_xy = [waypoint5, waypoint6, waypoint7, waypoint8]
waypoints_xz = [waypoint9, waypoint10, waypoint11, waypoint12]

figure1 = simulation_taskspace(waypoints_yz,timeForTrajectory, samplePeriod )
figure2 = simulation_taskspace(waypoints_xy,timeForTrajectory, samplePeriod )
figure3 = simulation_taskspace(waypoints_xz,timeForTrajectory, samplePeriod )
