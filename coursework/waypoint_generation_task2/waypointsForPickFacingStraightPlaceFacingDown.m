function waypoints = waypointsForPickFacingStraightPlaceFacingDown(...
    startX, startY, endX, endY,...
    gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
    gripperZPlaceDownCubeFacingDown, gripperZAbovePlacedCubeFacingDown,...
    gripperPickDownOffset,...
    gripperOpenPos, gripperCubeHoldPos...
)
%WAYPOINTSFORPICKFACINGSTRAIGHTPLACEFACINGDOWN Waypoints for picking up a
%cube with the gripper facing straight and placing it down with the gripper
%facing down. The bottom face of the original cube will be the face
%facing towards the gripper of the moved cube.
%gripperZPickUpCubeFacingStraight is a z-coordinate above the pick up cube
%where the gripper can savely move around. Relevant when the picking up a
%cube with the gripper facing straight.
%gripperZAbovePickUpCubeFacingStraight is a z-coordinate above the placed down
%cube where the gripper can savely move around. Relevant when the picking
%up a cube with the gripper facing straight.
%gripperZPlaceDownCubeFacingDown is the z-coordinate where the gripper
%should place down the cube. Relevant when the picking up a cube with the gripper
%facing down.
%gripperZAbovePlacedCubeFacingDown is a z-coordinate above the placed down
%cube where the gripper can savely move around. Relevant when the picking
%up a cube with the gripper facing down.
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
    waypoint.z = gripperZAbovePickUpCubeFacingStraight;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperOpenPos;
    waypoint.groupToPrevious = false;
    waypoints = [waypoints, waypoint];
    
    % Grab cube
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZPickUpCubeFacingStraight;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false;
    waypoints = [waypoints, waypoint];
    
    % Pick up cube
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZAbovePickUpCubeFacingStraight;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false; % TODO: try true
    [xOffset, yOffset] = computeXYOffset(gripperPickDownOffset, waypoint);
    waypoint.x = waypoint.x - xOffset;
    waypoint.y = waypoint.y - yOffset;
    waypoints = [waypoints, waypoint];
    
    % Rotate gripper and move to place down (end) location
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZAbovePlacedCubeFacingDown;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false; % TODO: try true
    waypoints = [waypoints, waypoint];
    
    % Place down cube
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZPlaceDownCubeFacingDown;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperOpenPos;
    waypoint.groupToPrevious = false;
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
