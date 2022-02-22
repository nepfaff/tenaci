function waypoints = waypointsForPickFacingDownPlaceFacingStraight(...
    startX, startY, endX, endY,...
    gripperZPickUpCube, gripperZAbovePickUpCube,...
    gripperZPlaceDownCube, gripperZAbovePlacedCube,...
    gripperOpenPos, gripperCubeHoldPos...
)
%WAYPOINTSFORPICKFACINGDOWNPLACEFACINGSTRAIGHT Waypoints for picking up a
%cube with the gripper facing down and placing it down with the gripper
%facing straight. The bottom face of the original cube will be the face
%facing away from the gripper of the moved cube.
%gripperZPickUpCube is the z-coordinate where the gripper should pick up
%the cube.
%gripperZAbovePickUpCube is a z-coordinate above the pick up cube where the
%gripper can savely move around.
%gripperZPlaceDownCube is the z-coordinate where the gripper should place
%down the cube.
%gripperZAbovePlacedCube is a z-coordinate above the placed down cube where
%the gripper can savely move around.
%gripperOpenPos is the encoder value that results in an open gripper.
%gripperCubeHoldPos is the encoder value that results in a gripper that
%tightly encloses a cube.

    waypoints = [];
    
    % Move to pick up (start) location
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZAbovePickUpCube;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperOpenPos;
    waypoints = [waypoints, waypoint];
    
    % Grab cube
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZPickUpCube;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperCubeHoldPos;
    waypoints = [waypoints, waypoint];
    
    % Pick up cube
    waypoint.x = startX;
    waypoint.y = startY;
    waypoint.z = gripperZAbovePickUpCube;
    waypoint.theta = -pi/2;
    waypoint.gripper = gripperCubeHoldPos;
    waypoints = [waypoints, waypoint];
    
    % Rotate gripper and move to place down (end) location
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZAbovePlacedCube;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperCubeHoldPos;
    waypoints = [waypoints, waypoint];
    
    % Place down cube
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZPlaceDownCube;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperOpenPos;
    waypoints = [waypoints, waypoint];
    
    % Move gripper up
    waypoint.x = endX;
    waypoint.y = endY;
    waypoint.z = gripperZAbovePlacedCube;
    waypoint.theta = 0.0;
    waypoint.gripper = gripperOpenPos;
    waypoints = [waypoints, waypoint];
end
