function waypoints = waypointsForMovingBetweenStartFinishFacingStraight(...
    startX, startY, endX, endY,...
    gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
    gripperZPlaceDownCubeFacingStraight, gripperZAbovePlacedCubeFacingStraight,...
    gripperOpenPos, gripperCubeHoldPos...
)
%WAYPOINTSFORMOVINGBETWEENSTARTFINISH Waypoints for picking up a cube at
%the start location and placing it down at the end location.
%gripperZPickUpCubeFacingStraight is the z-coordinate where the gripper should
%pick up the cube.
%gripperZAbovePickUpCubeFacingStraight is a z-coordinate above the pick up cube
%where the gripper can savely move around.
%gripperZPlaceDownCubeFacingStraight is the z-coordinate where the gripper
%should place down the cube.
%gripperZAbovePlacedCubeFacingStraight is a z-coordinate above the placed down
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
    waypoint.z = gripperZAbovePickUpCubeFacingStraight;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperOpenPos;
    waypoint.groupToPrevious = false;
    if ~doValidIKExist([waypoint])
        waypoint = modifyWaypointFromTopToSideApproach(waypoint,...
            gripperZPickUpCubeFacingStraight);
    end
    waypoints = [waypoints, waypoint];
    
    % Grab cube
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZPickUpCubeFacingStraight;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false; % TODO: Try true
    waypoints = [waypoints, waypoint];
    
    % Pick up cube
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZAbovePickUpCubeFacingStraight;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false;
    if ~doValidIKExist([waypoint])
        waypoint = modifyWaypointFromTopToSideApproach(waypoint,...
            gripperZPickUpCubeFacingStraight);
    end
    waypoints = [waypoints, waypoint];
    
    % Move to place down (end) location
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZAbovePlacedCubeFacingStraight;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperCubeHoldPos;
    waypoint.groupToPrevious = false; % TODO: Try true
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
    waypoint.groupToPrevious = false; % TODO: Try true
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
