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
startPose.timeForTrajectory = 0.0;

[startLocations, endLocations] = getTask2CubeLocations();

% Task specific waypoints
line1Start.x = -0.05;
line1Start.y = 0.2;
line1Start.z = 0.05;
line1End.x = 0.05;
line1End.y = 0.2;
line1End.z = 0.05;
line2End.x = 0.10;
line2End.y = 0.18;
line2End.z = 0.05;
waypoints = [line1Start, line1End, line2End];

% Constant for drawing task
for i = 1 : length(waypoints)
   waypoints(i).theta = 0.0;
   waypoints(i).gripper = GRIPPER_CUBE_HOLD_POS;
   waypoints(i).timeForTrajectory = 1.0;
   % This should be true for circles
   % Lines are more straight if they are defined by start and end waypoints
   % that are not grouped together. Multiple intermediate waypoints for
   % lines works less well.
   waypoints(i).groupToPrevious = false;
end

% Draw arc
arc = drawArc([0.1, 0.21, 0.05], [0.0, 0.16, 0.05], pi*.75, 0.1);
w = generateWaypointsByList(arc, 0.0, 0.0);
for i = 1 : length(w)
    w(i).theta = 0.0;
    w(i).gripper = GRIPPER_CUBE_HOLD_POS;
    w(i).groupToPrevious = (i ~= 1);
    w(i).timeForTrajectory = 2.0;
    waypoints = [waypoints, w(i)];
end

waypoints = [startPose, waypoints];

samplePeriod = 0.1; % In seconds
stages = taskSpaceStagesFromWaypoints(...
    waypoints, samplePeriod...
);

simulateStages(stages);