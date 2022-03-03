function waypoints = waypointsForMovingBetweenStartFinishFacingDown(...
    startX, startY, endX, endY,...
    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
    gripperZPlaceDownCubeFacingDown, gripperZAbovePlacedCubeFacingDown,...
    gripperOpenPos, gripperCubeHoldPos...
)
%WAYPOINTSFORMOVINGBETWEENSTARTFINISH Waypoints for picking up a cube at
%the start location and placing it down at the end location.
%gripperZPickUpCubeFacingDown is the z-coordinate where the gripper should
%pick up the cube.
%gripperZPickUpCubeFacingDown is a z-coordinate above the pick up cube
%where the gripper can savely move around.
%gripperZPlaceDownCubeFacingDown is the z-coordinate where the gripper
%should place down the cube.
%gripperZAbovePlacedCubeFacingDown is a z-coordinate above the placed down
%cube where the gripper can savely move around.
%gripperOpenPos is the encoder value that results in an open gripper.
%gripperCubeHoldPos is the encoder value that results in a gripper that
%tightly encloses a cube.
%Returns a list of waypoint structs with attributes x, y, z, theta,
%gripper, and groupToPrevious. gripper specifies the gripper opening.
%groupToPrevious is a boolean that is true when the waypoint can be grouped
%in a trajectory with the previous waypoint and false otherwise. This
%allows multiple waypoints to be part of a fast spline trajectory.

    waypoints = [];
    
    % Move to pick up (start) location
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZAbovePickUpCubeFacingDown;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperOpenPos;
    waypoint.groupToPrevious = false;
    waypoints = [waypoints, waypoint];
    
    % Grab cube
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZPickUpCubeFacingDown;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false; % TODO: Try true
    waypoints = [waypoints, waypoint];
    
    % Pick up cube
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZAbovePickUpCubeFacingDown;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false;
    waypoints = [waypoints, waypoint];
    
    % Move to place down (end) location
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZAbovePlacedCubeFacingDown;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false; % TODO: Try true
    waypoints = [waypoints, waypoint];
    
    % Place down cube
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZPlaceDownCubeFacingDown;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperOpenPos;
    waypoint.groupToPrevious = false; % TODO: Try true
    waypoints = [waypoints, waypoint];
    
    % Move gripper up
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZAbovePlacedCubeFacingDown;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperOpenPos;
    waypoint.groupToPrevious = false;
    waypoints = [waypoints, waypoint];
end
