function waypoints = getTask3VideoWaypoints(...
    gripperOpenPos, gripperPenCubeHoldPos...
)
%GETTASK3VIDEOWAYPOINTS Returns the waypoints for executing the task 3
%video specific drawing. The waypoints don't include the start pose.
    
    drawingHeight = 0.078;

    % Pick up pen
    penAbovePickUp.x = 0.075;
    penAbovePickUp.y = 0.075;
    penAbovePickUp.z = 0.075;
    penAbovePickUp.theta = -pi/2;
    penAbovePickUp.gripper = gripperOpenPos;
    penAbovePickUp.groupToPrevious = false;
    penAbovePickUp.timeForTrajectory = 0.4;
    penAbovePickUp.name = "Pen above pick up";
    
    penPickUp.x = 0.075;
    penPickUp.y = 0.075;
    penPickUp.z = 0.015;
    penPickUp.theta = -pi/2;
    penPickUp.gripper = gripperPenCubeHoldPos;
    penPickUp.groupToPrevious = false;
    penPickUp.timeForTrajectory = 0.15;
    penPickUp.name = "Pen pick up";
    
    penAbovePickUp1.x = 0.075;
    penAbovePickUp1.y = 0.075;
    penAbovePickUp1.z = drawingHeight + 0.05;
    penAbovePickUp1.theta = 0.0;
    penAbovePickUp1.gripper = gripperPenCubeHoldPos;
    penAbovePickUp1.groupToPrevious = false;
    penAbovePickUp1.timeForTrajectory = 0.25;
    penAbovePickUp1.name = "Pen above pick up";
    
    pickUpWaypoints = [penAbovePickUp, penPickUp, penAbovePickUp1];

    
    % Lines
    line1Above.x = -0.06;
    line1Above.y = 0.2;
    line1Above.z = drawingHeight + 0.02;
    line1Above.theta = 0.0;
    line1Above.gripper = gripperPenCubeHoldPos;
    line1Above.groupToPrevious = false;
    line1Above.timeForTrajectory = 0.4;
    line1Above.name = "Above line 1 start";

    line1Start.x = -0.06;
    line1Start.y = 0.2;
    line1Start.z = drawingHeight;
    line1Start.timeForTrajectory = 0.1;
    line1Start.name = "Diagonal line start";
    line1End.x = -0.14;
    line1End.y = 0.125;
    line1End.z = drawingHeight;
    line1End.timeForTrajectory = 0.55;
    line1End.name = "Diagonal line end";
    line2End.x = -0.14;
    line2End.y = 0.2;
    line2End.z = drawingHeight;
    line2End.timeForTrajectory = 0.4;
    line2End.name = "Vertical line end";
    line3End.x = -0.06;
    line3End.y = 0.2;
    line3End.z = drawingHeight;
    line3End.timeForTrajectory = 0.5;
    line3End.name = "Horizontal line end";
    lineWaypoints = [line1Start, line1End, line2End, line3End];
    % Constant for lines
    for i = 1 : length(lineWaypoints)
       lineWaypoints(i).theta = 0.0;
       lineWaypoints(i).gripper = gripperPenCubeHoldPos;
       % Lines are more straight if they are defined by start and end waypoints
       % that are not grouped together. Multiple intermediate waypoints for
       % lines works less well.
       lineWaypoints(i).groupToPrevious = false;
    end

    
    % Draw arc
    arc = drawArc([-0.06, 0.2, drawingHeight], [-0.10, 0.2, drawingHeight], pi, 0.1, false);
    arcWaypoints = generateWaypointsByList(arc, 0.0, 0.0);
    for i = 1 : length(arcWaypoints)
        arcWaypoints(i).theta = 0.0;
        arcWaypoints(i).gripper = gripperPenCubeHoldPos;
        % Directly group to last line point as otherwise we have a delay before starting arc
        arcWaypoints(i).groupToPrevious = true;
        arcWaypoints(i).timeForTrajectory = 2;
        arcWaypoints(i).name = "arc";
    end

    aboveArcEnd.x = -0.14;
    aboveArcEnd.y = 0.2;
    aboveArcEnd.z = drawingHeight + 0.05;
    aboveArcEnd.theta = 0.0;
    aboveArcEnd.gripper = gripperPenCubeHoldPos;
    aboveArcEnd.groupToPrevious = false;
    aboveArcEnd.timeForTrajectory = 0.1;
    aboveArcEnd.name = "Above arc end";
    
    
    % Combine waypoints
    waypoints = [
        pickUpWaypoints,...
        line1Above, lineWaypoints,...
        arcWaypoints, aboveArcEnd
    ];
end
