function waypoints = waypointsForTask2c(...
    startLocations, endLocations,...
    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
    gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
    gripperPickDownOffset,...
    gripperOpenPos, gripperCubeHoldPos...
)
%WAYPOINTSFORTASK2C Computes a sequence of waypoints to achieve task 2b.
%The task involves picking up cubes from three starting locations,
%potentially rotating them and stacking them on one of the finishing
%locations. All red faces must face away from the robot ("front") when
%stacked.
%startLocations is a list of structs with attributes x, y, and direction
%where direction is one of "front", "back", or "down".
%endLocations is a list of structs with attributes x and y.
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
    
    % Choose one of the finishing locations
    % TODO: Think about better method (e.g. closest to starting locations)
    finish = endLocations(1);
    
    % Keep track of where to place the next cube on the growing stack
    nextGripperZPlaceDownCubeFacingDown = gripperZPickUpCubeFacingDown;
    nextGripperZAbovePlacedCubeFacingDown = gripperZAbovePickUpCubeFacingDown;
    nextGripperZPlaceDownCubeFacingStraight = gripperZPickUpCubeFacingStraight;
    nextGripperZAbovePlacedCubeFacingStraight = gripperZAbovePickUpCubeFacingStraight;
    
    for i = 1 : length(startLocations)
        start = startLocations(i);
        
        if start.direction == "front"
            % No rotation required
            waypoints = [
                waypoints,...
                waypointsForMovingBetweenStartFinish(...
                    start.x, start.y, finish.x, finish.y,...
                    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
                    nextGripperZPlaceDownCubeFacingDown, nextGripperZAbovePlacedCubeFacingDown,...
                    gripperZPickUpCubeFacingStraight, gripperZAbovePickUpCubeFacingStraight,...
                    nextGripperZPlaceDownCubeFacingStraight, nextGripperZAbovePlacedCubeFacingStraight,...
                    gripperOpenPos, gripperCubeHoldPos...
                )...
            ];
        elseif start.direction == "back"
            % NOTE: It might be possible to achieve this without placing
            % down the cube again, using the gripper arm backwards IK
            % solutions (not tested).
            
            % Rotate and place back down at start location
            waypoints = [
                waypoints,...
                waypointsForPickFacingDownPlaceFacingStraight(...
                    start.x, start.y, start.x, start.y,...
                    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
                    nextGripperZPlaceDownCubeFacingStraight, nextGripperZAbovePlacedCubeFacingStraight,...
                    gripperPickDownOffset,...
                    gripperOpenPos, gripperCubeHoldPos...
                )...
            ];
            % Rotate again and move to finish location
            waypoints = [
                waypoints,...
                waypointsForPickFacingDownPlaceFacingStraight(...
                    start.x, start.y, finish.x, finish.y,...
                    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
                    nextGripperZPlaceDownCubeFacingStraight, nextGripperZAbovePlacedCubeFacingStraight,...
                    gripperPickDownOffset,...
                    gripperOpenPos, gripperCubeHoldPos...
                )...
            ];
        elseif start.direction == "down"
            waypoints = [
                waypoints,...
                waypointsForPickFacingDownPlaceFacingStraight(...
                    start.x, start.y, finish.x, finish.y,...
                    gripperZPickUpCubeFacingDown, gripperZAbovePickUpCubeFacingDown,...
                    nextGripperZPlaceDownCubeFacingStraight, nextGripperZAbovePlacedCubeFacingStraight,...
                    gripperPickDownOffset,...
                    gripperOpenPos, gripperCubeHoldPos...
                )...
            ];
        else
            fprintf("ERROR in waypointsForTask2c: Direction %s is invalid", loc.direction)
        end
        
        % Stack height has increased by cube height
        % (gripperZPickUpCubeFacingStraight in middle of cube height)
        cubeStandHeight = 0.02;
        nextGripperZPlaceDownCubeFacingDown =...
            nextGripperZPlaceDownCubeFacingDown + (gripperZPickUpCubeFacingStraight - cubeStandHeight);
        nextGripperZAbovePlacedCubeFacingDown =...
            nextGripperZAbovePlacedCubeFacingDown + (gripperZPickUpCubeFacingStraight - cubeStandHeight);
        nextGripperZPlaceDownCubeFacingStraight =...
            nextGripperZPlaceDownCubeFacingStraight + (gripperZPickUpCubeFacingStraight - cubeStandHeight);
        nextGripperZAbovePlacedCubeFacingStraight =...
            nextGripperZAbovePlacedCubeFacingStraight + (gripperZPickUpCubeFacingStraight - cubeStandHeight);
    end
    
    waypoints = insertCubeAvoidanceWaypoints(waypoints, 0.1, pi/12);
end
