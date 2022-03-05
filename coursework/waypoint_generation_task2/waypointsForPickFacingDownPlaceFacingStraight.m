function waypoints = waypointsForPickFacingDownPlaceFacingStraight(...
    startX, startY, endX, endY,...
    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
    gripperZPlaceDownCubeFacingStraight, gripperZAbovePlacedCubeFacingStraight,...
    gripperPickDownOffset,...
    gripperOpenPos, gripperCubeHoldPos...
)
%WAYPOINTSFORPICKFACINGDOWNPLACEFACINGSTRAIGHT Waypoints for picking up a
%cube with the gripper facing down and placing it down with the gripper
%facing straight. The bottom face of the original cube will be the face
%facing away from the gripper of the moved cube.
%gripperZPickUpCubeFacingDown is a z-coordinate above the pick up cube
%where the gripper can savely move around. Relevant when the picking up a
%cube with the gripper facing down.
%gripperZAbovePlacedCubeFacingStraight is a z-coordinate above the placed down
%cube where the gripper can savely move around. Relevant when the picking
%up a cube with the gripper facing down.
%gripperZPlaceDownCubeFacingStraight is the z-coordinate where the gripper
%should place down the cube. Relevant when the picking up a cube with the gripper
%facing straight.
%gripperZAbovePlacedCubeFacingStraight is a z-coordinate above the placed down
%cube where the gripper can savely move around. Relevant when the picking
%up a cube with the gripper facing straight.
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
    if ~doValidIKExist([waypoint])
        waypoint = modifyWaypointFromTopToSideApproach(waypoint,...
            gripperZPickUpCubeFacingDown);
    end
    waypoints = [waypoints, waypoint];
    
    % Grab cube
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZPickUpCubeFacingDown;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false;
    waypoints = [waypoints, waypoint];
    
    % Pick up cube
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZAbovePickUpCubeFacingDown;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false; % TODO: try true
    if ~doValidIKExist([waypoint])
        waypoint = modifyWaypointFromTopToSideApproach(waypoint,...
            gripperZPickUpCubeFacingDown);
    end
    waypoints = [waypoints, waypoint];
    
    % Rotate gripper and move to place down (end) location
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZAbovePlacedCubeFacingStraight;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false; % TODO: try true
    if ~doValidIKExist([waypoint])
        waypoint = modifyWaypointFromTopToSideApproach(waypoint,...
            gripperZPlaceDownCubeFacingStraight);
    end
    waypoints = [waypoints, waypoint];
    
    % Place down cube
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZPlaceDownCubeFacingStraight;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperOpenPos;
    waypoint.groupToPrevious = false;
    [xOffset, yOffset] = computeXYOffset(gripperPickDownOffset, waypoint);
    waypoint.x = waypoint.x - xOffset;
    waypoint.y = waypoint.y - yOffset;
    waypoints = [waypoints, waypoint];
    
    % Move gripper up
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZAbovePlacedCubeFacingStraight;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperOpenPos;
    waypoint.groupToPrevious = false;
    if ~doValidIKExist([waypoint])
        waypoint = modifyWaypointFromTopToSideApproach(waypoint,...
            gripperZPlaceDownCubeFacingStraight);
    end
    waypoints = [waypoints, waypoint];
end
