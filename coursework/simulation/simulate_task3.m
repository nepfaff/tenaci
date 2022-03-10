clc;
clear;

% Values to send to the gripper
GRIPPER_OPEN_POS = 1800;
GRIPPER_PEN_CUBE_HOLD_POS = 2250;

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

% Task specific waypoints
drawingHeight = 0.08;

% Lines
line1Start.x = -0.06;
line1Start.y = 0.2;
line1Start.name = "Diagonal line start";
line1End.x = -0.14;
line1End.y = 0.125;
line1End.name = "Diagonal line end";
line2End.x = -0.14;
line2End.y = 0.2;
line2End.name = "Vertical line end";
line3End.x = -0.06;
line3End.y = 0.2;
line3End.name = "Horizontal line end";
waypoints = [line1Start, line1End, line2End, line3End];

% Constant for lines
for i = 1 : length(waypoints)
   waypoints(i).z = drawingHeight;
   waypoints(i).theta = 0.0;
   waypoints(i).gripper = GRIPPER_PEN_CUBE_HOLD_POS;
   waypoints(i).timeForTrajectory = 1.0;
   % This should be true for circles
   % Lines are more straight if they are defined by start and end waypoints
   % that are not grouped together. Multiple intermediate waypoints for
   % lines works less well.
   waypoints(i).groupToPrevious = false;
end

% Draw arc
arc = drawArc([-0.06, 0.2, drawingHeight], [-0.10, 0.2, drawingHeight], pi, 0.1);
w = generateWaypointsByList(arc, 0.0, 0.0);
for i = 1 : length(w)
    w(i).theta = 0.0;
    w(i).gripper = GRIPPER_PEN_CUBE_HOLD_POS;
    w(i).groupToPrevious = (i ~= 1);
    w(i).timeForTrajectory = 1.5;
    w(i).name = "arc";
    waypoints = [waypoints, w(i)];
end

waypoints = [startPose, waypoints];

samplePeriod = 0.1; % In seconds
stages = taskSpaceStagesFromWaypoints(...
    waypoints, samplePeriod...
);

simulateStages(stages);