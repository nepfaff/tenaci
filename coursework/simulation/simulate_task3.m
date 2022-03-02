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

% Task specific waypoints
line1Start.x = 0.15;
line1Start.y = 0.0;
line1Start.z = 0.05;
line1End.x = 0.0;
line1End.y = 0.15;
line1End.z = 0.05;
waypoints = [line1Start, line1End];

% Constant for drawing task
for i = 1 : length(waypoints)
   waypoints(i).theta = 0.0;
   waypoints(i).gripper = GRIPPER_CUBE_HOLD_POS;
   waypoints(i).groupToPrevious = false; % This should be true for circles
end

waypoints = [startPose, waypoints];

timeForTrajectory = 1; % In seconds
samplePeriod = 0.1; % In seconds
stages = taskSpaceStagesFromWaypoints(...
    waypoints, timeForTrajectory, samplePeriod...
);

simulateStages(stages);