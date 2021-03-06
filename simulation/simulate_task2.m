clc; clear;

% Values to send to the gripper
GRIPPER_OPEN_POS = 1800;
GRIPPER_CLOSED_POS = 2647;
GRIPPER_CUBE_HOLD_POS = 2450;

[GRIPPER_Z_PICK_UP_CUBE_FACING_DOWN, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_DOWN,...
GRIPPER_Z_PICK_UP_CUBE_FACING_STRAIGHT, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_STRAIGHT,...
GRIPPER_PICK_DOWN_OFFSET]...
= getTask2GripperZValues();

% Start pose of gripper
startPose.x = 0.0;
startPose.y = 0.274;
startPose.z = 0.2048;
startPose.theta = 0.0;
startPose.gripper = GRIPPER_OPEN_POS;
startPose.groupToPrevious = false;
startPose.timeForTrajectory = 0.0;
startPose.name = "Start pose";

[startLocations, endLocations] = getTask2CubeLocations();

% Optionally load waypoints from file. The below waypoint generation
% functions should be commented out when loading the waypoints from a file.

% waypoints = load(".\config\waypoints_task2a_demo.mat").waypoints;
% waypoints = load(".\config\waypoints_task2b_demo.mat").waypoints;
% waypoints = load(".\config\waypoints_task2c_demo.mat").waypoints;

% waypoints = load(".\config\waypoints_task2a_video.mat").waypoints;
% waypoints = load(".\config\waypoints_task2b_video.mat").waypoints;
% waypoints = load(".\config\waypoints_task2c_video.mat").waypoints;

% Comment out 2/3 of these

waypoints = waypointsForTask2a(...
    startLocations, endLocations,...
    GRIPPER_Z_PICK_UP_CUBE_FACING_DOWN, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_DOWN,...
    GRIPPER_Z_PICK_UP_CUBE_FACING_STRAIGHT, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_STRAIGHT,...
    GRIPPER_OPEN_POS, GRIPPER_CUBE_HOLD_POS...
);

% waypoints = waypointsForTask2b(...
%     startLocations,...
%     GRIPPER_Z_PICK_UP_CUBE_FACING_DOWN, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_DOWN,...
%     GRIPPER_Z_PICK_UP_CUBE_FACING_STRAIGHT, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_STRAIGHT,...
%     GRIPPER_PICK_DOWN_OFFSET,...
%     GRIPPER_OPEN_POS, GRIPPER_CUBE_HOLD_POS...
% );

% waypoints = waypointsForTask2c(...
%     startLocations, endLocations,...
%     GRIPPER_Z_PICK_UP_CUBE_FACING_DOWN, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_DOWN,...
%     GRIPPER_Z_PICK_UP_CUBE_FACING_STRAIGHT, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_STRAIGHT,...
%     GRIPPER_PICK_DOWN_OFFSET,...
%     GRIPPER_OPEN_POS, GRIPPER_CUBE_HOLD_POS...
% );

waypoints = [startPose, waypoints];

% Slow down simulation by a constant time
additionalTimePerTrajectory = 0.0;
temp = num2cell([waypoints.timeForTrajectory] + additionalTimePerTrajectory);
[waypoints.timeForTrajectory] = temp{:};

samplePeriod = 0.1; % In seconds
stages = taskSpaceStagesFromWaypoints(...
    waypoints, samplePeriod...
);

simulateStages(stages);