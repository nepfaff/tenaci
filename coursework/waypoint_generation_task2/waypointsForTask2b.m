function waypoints = waypointsForTask2b(...
    cubeLocations,...
    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
    gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
    gripperPickDownOffset,...
    gripperOpenPos, gripperCubeHoldPos...
)
%WAYPOINTSFORTASK2B Computes a sequence of waypoints to achieve task 2b.
%The task involves picking up cubes, rotating them, and placing them back
%down in the same location. The cubes start with the red face to the front
%(away from the robot), back (towards the robot), or down (towards the
%ground). They should end with the red face at the top.
%cubeLocations is a list of structs with attributes x, y, and direction
%where direction is one of "front", "back", or "down".
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
    for i = 1 : length(cubeLocations)
        loc = cubeLocations(i);
        
        if loc.direction == "front"
            waypoints = [
                waypoints,...
                waypointsForPickFacingDownPlaceFacingStraight(...
                    loc.x, loc.y, loc.x, loc.y,...
                    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
                    gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
                    gripperPickDownOffset,...
                    gripperOpenPos, gripperCubeHoldPos...
                )...
            ];
        elseif loc.direction == "back"
            waypoints = [
                waypoints,...
                waypointsForPickFacingStraightPlaceFacingDown(...
                    loc.x, loc.y, loc.x, loc.y,...
                    gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
                    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
                    gripperPickDownOffset,...
                    gripperOpenPos, gripperCubeHoldPos...
                )...
            ];
        elseif loc.direction == "down"
            % NOTE: It might be possible to achieve this without placing
            % down the cube again, using the gripper arm backwards IK
            % solutions (not tested).
            waypoints = [
                waypoints,...
                waypointsForPickFacingDownPlaceFacingStraight(...
                    loc.x, loc.y, loc.x, loc.y,...
                    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
                    gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
                    gripperPickDownOffset,...
                    gripperOpenPos, gripperCubeHoldPos...
                )...
            ];
            waypoints = [
                waypoints,...
                waypointsForPickFacingDownPlaceFacingStraight(...
                    loc.x, loc.y, loc.x, loc.y,...
                    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
                    gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
                    gripperPickDownOffset,...
                    gripperOpenPos, gripperCubeHoldPos...
                )...
            ];
        else
            fprintf("ERROR in waypointsForTask2b: Direction %s is invalid", loc.direction)
        end
    end
    
    waypoints = insertCubeAvoidanceWaypoints(waypoints, 0.1, pi/6);
end
