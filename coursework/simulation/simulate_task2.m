clc; clear;

% Values to send to the gripper
GRIPPER_OPEN_POS = 1800;
GRIPPER_CLOSED_POS = 2647;
GRIPPER_CUBE_HOLD_POS = 2370;

% Cube specific values
% Cube has sidelength of 2.5cm, cube stand's top edge is 19.8mm from
% base-plate
GRIPPER_Z_CUBE = 0.045;
GRIPPER_Z_ABOVE_CUBE = 0.06;

% Start pose of gripper
startPose.x = 0.0;
startPose.y = 0.274;
startPose.z = 0.2048;
startPose.theta = 0.0;
startPose.gripper = GRIPPER_OPEN_POS;
startPose.groupToPrevious = false;

[startLocations, endLocations] = getTask2CubeLocations();

% Comment out 2/3 of these

% waypoints = waypointsForTask2a(...
%     startLocations, endLocations,...
%     GRIPPER_Z_CUBE, GRIPPER_Z_ABOVE_CUBE,...
%     GRIPPER_Z_CUBE, GRIPPER_Z_ABOVE_CUBE,...
%     GRIPPER_OPEN_POS, GRIPPER_CUBE_HOLD_POS...
% );

waypoints = waypointsForTask2b(...
    startLocations,...
    GRIPPER_Z_CUBE, GRIPPER_Z_ABOVE_CUBE,...
    GRIPPER_Z_CUBE, GRIPPER_Z_ABOVE_CUBE,...
    GRIPPER_OPEN_POS, GRIPPER_CUBE_HOLD_POS...
);

% waypoints = waypointsForTask2c(...
%     startLocations, endLocations,...
%     GRIPPER_Z_CUBE, GRIPPER_Z_ABOVE_CUBE,...
%     GRIPPER_Z_CUBE, GRIPPER_Z_ABOVE_CUBE,...
%     GRIPPER_OPEN_POS, GRIPPER_CUBE_HOLD_POS...
% );

waypoints = [startPose, waypoints];

timeForTrajectory = 1; % In seconds
samplePeriod = 0.1; % In seconds
stages = taskSpaceStagesFromWaypoints(...
    waypoints, timeForTrajectory, samplePeriod...
);

simulateStages(stages);