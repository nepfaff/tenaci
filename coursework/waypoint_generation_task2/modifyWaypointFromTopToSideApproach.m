function newWaypoint = modifyWaypointFromTopToSideApproach(waypoint, gripperZCube)
%MODIFYWAYPOINTFROMTOPTOSIDEAPPROACH Modifies a way point that represents
%approaching a cube from the top to one that represents approaching a cube
%from the side.

    % All other waypoint values stay the same
    newWaypoint = waypoint;
    
    % Offset by cube width
    [xOffset, yOffset] = computeXYOffset(0.025, waypoint);
    newWaypoint.x = waypoint.x - xOffset;
    newWaypoint.y = waypoint.y - yOffset;
    % Offset to avoid crashing into cube stand (stand has higher sides)
    newWaypoint.z = gripperZCube + 0.005;
end
