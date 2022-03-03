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
   waypoints(i).groupToPrevious = false; % This should be true for circles
end

% Draw arc
% arc = drawArc([-0.05, 0.2, 0.05], [0.010, 0.1, 0.05], 10, 1);
% waypoints = [];
% for i = 1 : length(arc)
%     waypoint.x = arc(i,1);
%     waypoint.y = arc(i,2);
%     waypoint.z = arc(i,3);
%     waypoint.theta = 0.0;
%     waypoint.gripper = GRIPPER_CUBE_HOLD_POS;
%     waypoint.groupToPrevious = true;
%     waypoints = [waypoints, waypoint];
% end

waypoints = [startPose, waypoints];

timeForTrajectory = 1; % In seconds
samplePeriod = 0.1; % In seconds
stages = taskSpaceStagesFromWaypoints(...
    waypoints, timeForTrajectory, samplePeriod...
);

simulateStages(stages);