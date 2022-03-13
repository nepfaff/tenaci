function waypoints = waypointsForTask2a(...
    startLocations, endLocations,...
    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
    gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
    gripperOpenPos, gripperCubeHoldPos...
)
%WAYPOINTSFORTASK2A Computes a sequence of waypoints to achieve task 2a.
%The task involves picking up cubes from three starting locations and
%transfering them to three finishing locations.
%gripperZAbovePickUpCube is a z-coordinate above the pick up cube where the
%gripper can savely move around.
%startLocations is a list of structs with attributes x and y.
%endLocations is a list of structs with attributes x and y.
%gripperZPlaceDownCube is the z-coordinate where the gripper should place
%down the cube.
%gripperZAbovePlacedCube is a z-coordinate above the placed down cube where
%the gripper can savely move around.
%gripperOpenPos is the encoder value that results in an open gripper.
%gripperCubeHoldPos is the encoder value that results in a gripper that
%tightly encloses a cube.
    
    waypoints = [];
    for i = 1 : length(startLocations)
        start = startLocations(i);
        finish = endLocations(i);
  
        waypoints = [
            waypoints,...
            waypointsForMovingBetweenStartFinish(...
                start.x, start.y, finish.x, finish.y,...
                gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
                gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
                gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
                gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
                gripperOpenPos, gripperCubeHoldPos...
            )...
        ];
    end
    
%     waypoints = insertCubeAvoidanceWaypoints(waypoints, 0.15, pi/6);
end
