clc;
clear;

% Values to send to the gripper
GRIPPER_OPEN_POS = 1800;
GRIPPER_PEN_CUBE_HOLD_POS = 2350;

% Start pose of gripper
startPose.x = 0.0;
startPose.y = 0.274;
startPose.z = 0.2048;
startPose.theta = 0.0;
startPose.gripper = GRIPPER_OPEN_POS;
startPose.groupToPrevious = false;
startPose.timeForTrajectory = 0.0;
startPose.name = "Start pose";

% waypoints = getTask3VideoWaypoints(...
%     GRIPPER_OPEN_POS, GRIPPER_PEN_CUBE_HOLD_POS...
% );

% Task 4 (exluding writing part)
% waypoints = load(".\config\waypoints_task4_without_writing.mat").waypoints;
waypoints = getTask4DrawingWaypoints(...
    GRIPPER_OPEN_POS, GRIPPER_PEN_CUBE_HOLD_POS...
);

waypoints = [startPose, waypoints];

% Using a sample period of 0.1 causes overshoot when drawing the arc
samplePeriod = 0.05; % In seconds
stages = taskSpaceStagesFromWaypoints(...
    waypoints, samplePeriod...
);

simulateStages(stages);