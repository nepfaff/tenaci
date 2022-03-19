function waypoints = getTask4DrawingWaypoints(...
    gripperOpenPos, gripperPenCubeHoldPos...
)
%GETTASK3VIDEOWAYPOINTS Returns the waypoints for executing the task 3
%video specific drawing. The waypoints don't include the start pose.
    
    drawingHeight = 0.0845;
    % For some reason we need to draw lower towards the end
    secondDrawingHeight = 0.08325;

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
    penPickUp.z = 0.02;
    penPickUp.theta = -pi/2;
    penPickUp.gripper = gripperPenCubeHoldPos;
    penPickUp.groupToPrevious = false;
    penPickUp.timeForTrajectory = 0.2;
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

    
    % Drawing Letter E
    E_line1Above.x = 0.17;
    E_line1Above.y = 0.155;
    E_line1Above.z = drawingHeight + 0.02;
    E_line1Above.timeForTrajectory = 0.5;
    E_line1Above.name = "Above E start";

    E_line1Start.x = 0.17;
    E_line1Start.y = 0.155;
    E_line1Start.z = drawingHeight;
    E_line1Start.timeForTrajectory = 0.2;
    E_line1Start.name = "E start";
    
    E_line1End.x = 0.19;
    E_line1End.y = 0.155;
    E_line1End.z = drawingHeight;
    E_line1End.timeForTrajectory = 0.5;
    E_line1End.name = "Horizontal line end";
    
    E_line2End.x = 0.19;
    E_line2End.y = 0.195;
    E_line2End.z = drawingHeight;
    E_line2End.timeForTrajectory = 0.5;
    E_line2End.name = "Vertical line end";
    
    E_line3End.x = 0.17;
    E_line3End.y = 0.195;
    E_line3End.z = drawingHeight;
    E_line3End.timeForTrajectory = 0.5;
    E_line3End.name = "Horizontal line end";
    
    E_line3AboveEnd.x = 0.17;
    E_line3AboveEnd.y = 0.195;
    E_line3AboveEnd.z = drawingHeight + 0.02;
    E_line3AboveEnd.timeForTrajectory = 0.2;
    E_line3AboveEnd.name = "Horizontal line end above";
    
    E_line4Above.x = 0.19;
    E_line4Above.y = 0.175;
    E_line4Above.z = drawingHeight + 0.02;
    E_line4Above.timeForTrajectory = 0.5;
    E_line4Above.name = "Above line 4 start";
    
    E_line4Start.x = 0.19;
    E_line4Start.y = 0.175;
    E_line4Start.z = drawingHeight;
    E_line4Start.timeForTrajectory = 0.2;
    E_line4Start.name = "Horizontal start";
    
    E_line4End.x = 0.17;
    E_line4End.y = 0.175;
    E_line4End.z = drawingHeight;
    E_line4End.timeForTrajectory = 0.5;
    E_line4End.name = "Horizontal end";
    
    E_line4EndAbove.x = 0.17;
    E_line4EndAbove.y = 0.175;
    E_line4EndAbove.z = drawingHeight + 0.02;
    E_line4EndAbove.timeForTrajectory = 0.2;
    E_line4EndAbove.name = "Horizontal end";
    
    E_lineWaypoints = [E_line1Above, E_line1Start, E_line1End, E_line2End, E_line3End, ...
                       E_line3AboveEnd, E_line4Above,E_line4Start, E_line4End, ...
                       E_line4EndAbove];

   % Drawing Letter N
    N_line1Above.x = 0.16;
    N_line1Above.y = 0.195;
    N_line1Above.z = drawingHeight + 0.02;
    N_line1Above.timeForTrajectory = 0.5;
    N_line1Above.name = "Above E start";

    N_line1Start.x = 0.16;
    N_line1Start.y = 0.195;
    N_line1Start.z = drawingHeight;
    N_line1Start.timeForTrajectory = 0.2;
    N_line1Start.name = "N start";
    
    N_line1End.x = 0.16;
    N_line1End.y = 0.155;
    N_line1End.z = drawingHeight;
    N_line1End.timeForTrajectory = 0.5;
    N_line1End.name = "Vertical line end";
    
    N_line2End.x = 0.14;
    N_line2End.y = 0.195;
    N_line2End.z = drawingHeight;
    N_line2End.timeForTrajectory = 0.5;
    N_line2End.name = "Diagnoal line end";
    
    N_line3End.x = 0.14;
    N_line3End.y = 0.155;
    N_line3End.z = drawingHeight;
    N_line3End.timeForTrajectory = 0.5;
    N_line3End.name = "Vertical line end";
    
    N_line3AboveEnd.x = 0.14;
    N_line3AboveEnd.y = 0.155;
    N_line3AboveEnd.z = drawingHeight + 0.02;
    N_line3AboveEnd.timeForTrajectory = 0.2;
    N_line3AboveEnd.name = "Horizontal line end above";
    
    N_lineWaypoints = [N_line1Above, N_line1Start, N_line1End, N_line2End, N_line3End, N_line3AboveEnd];
   
    % Drawing Letter J
    J_line1Above.x = 0.11;
    J_line1Above.y = 0.155;
    J_line1Above.z = drawingHeight + 0.02;
    J_line1Above.timeForTrajectory = 0.5;
    J_line1Above.name = "Above J start";
    
    J_line1Start.x = 0.11;
    J_line1Start.y = 0.155;
    J_line1Start.z = drawingHeight;
    J_line1Start.timeForTrajectory = 0.2;
    J_line1Start.name = "J line start";
    
    J_line1End.x = 0.11;
    J_line1End.y = 0.185;
    J_line1End.z = drawingHeight;
    J_line1End.timeForTrajectory = 0.5;
    J_line1End.name = "J line end";
    
    J_arc = drawArc([0.11, 0.185, drawingHeight], [0.12, 0.185, drawingHeight], pi, 0.1, false);
    arcWaypoints = generateWaypointsByList(J_arc, 0.0, 0.0);
    for i = 1 : length(arcWaypoints)
        arcWaypoints(i).theta = 0.0;
        arcWaypoints(i).gripper = gripperPenCubeHoldPos;
        % Directly group to last line point as otherwise we have a delay before starting arc
        arcWaypoints(i).groupToPrevious = true;
        arcWaypoints(i).timeForTrajectory = 1.2;
        arcWaypoints(i).name = "arc";
    end
    aboveJ_ArcEnd.x = 0.11;
    aboveJ_ArcEnd.y = 0.185;
    aboveJ_ArcEnd.z = drawingHeight + 0.02;
    aboveJ_ArcEnd.theta = 0.0;
    aboveJ_ArcEnd.gripper = gripperPenCubeHoldPos;
    aboveJ_ArcEnd.groupToPrevious = false;
    aboveJ_ArcEnd.timeForTrajectory = 0.2;
    aboveJ_ArcEnd.name = "Above arc end";
    
    J_lineWaypoints = [J_line1Above, J_line1Start, J_line1End];
    J_ArcWaypoints = [arcWaypoints, aboveJ_ArcEnd];

    % Drawing Letter O
    aboveCircleStart.x = 0.095;
    aboveCircleStart.y = 0.175;
    aboveCircleStart.z = secondDrawingHeight + 0.02;
    aboveCircleStart.theta = 0.0;
    aboveCircleStart.gripper = gripperPenCubeHoldPos;
    aboveCircleStart.groupToPrevious = false;
    aboveCircleStart.timeForTrajectory = 0.5;
    aboveCircleStart.name = "Above circle start";
    circle = drawArc([0.095, 0.175, secondDrawingHeight], [0.08, 0.175, secondDrawingHeight], 2*pi+0.2, 0.1, false);
    circleWaypoints = generateWaypointsByList(circle, 0.0, 0.0);
    for i = 1 : length(circleWaypoints)
        circleWaypoints(i).theta = 0.0;
        circleWaypoints(i).gripper = gripperPenCubeHoldPos;
        % Directly group to last line point as otherwise we have a delay before starting arc
        circleWaypoints(i).groupToPrevious = true;
        circleWaypoints(i).timeForTrajectory = 2.5;
        circleWaypoints(i).name = "circle";
    end
    aboveCircleEnd.x = 0.095;
    aboveCircleEnd.y = 0.175;
    aboveCircleEnd.z = secondDrawingHeight + 0.02;
    aboveCircleEnd.theta = 0.0;
    aboveCircleEnd.gripper = gripperPenCubeHoldPos;
    aboveCircleEnd.groupToPrevious = false;
    aboveCircleEnd.timeForTrajectory = 0.2;
    aboveCircleEnd.name = "Above arc end";
    
    circle_Waypoints = [aboveCircleStart, circleWaypoints, aboveCircleEnd];
    
   % Drawing Letter Y
    Y_line1Above.x = 0.055;
    Y_line1Above.y = 0.155;
    Y_line1Above.z = secondDrawingHeight + 0.02;
    Y_line1Above.timeForTrajectory = 0.5;
    Y_line1Above.name = "Above E start";

    Y_line1Start.x = 0.055;
    Y_line1Start.y = 0.155;
    Y_line1Start.z = secondDrawingHeight;
    Y_line1Start.timeForTrajectory = 0.2;
    Y_line1Start.name = "Y start";
    Y_line1End.x = 0.045;
    Y_line1End.y = 0.175;
    Y_line1End.z = secondDrawingHeight;
    Y_line1End.timeForTrajectory = 0.5;
    Y_line1End.name = "left Diagnoal line end";
    Y_line2End.x = 0.045;
    Y_line2End.y = 0.195;
    Y_line2End.z = secondDrawingHeight;
    Y_line2End.timeForTrajectory = 0.5;
    Y_line2End.name = "vertical line end";
    Y_line2AboveEnd.x = 0.045;
    Y_line2AboveEnd.y = 0.195;
    Y_line2AboveEnd.z = secondDrawingHeight;
    Y_line2AboveEnd.timeForTrajectory = 0.2;
    Y_line2AboveEnd.name = "vertical line end";
    
    Y_line3Above.x = 0.035;
    Y_line3Above.y = 0.155;
    Y_line3Above.z = secondDrawingHeight + 0.02;
    Y_line3Above.timeForTrajectory = 0.5;
    Y_line3Above.name = "Above E start";
    Y_line3Start.x = 0.035;
    Y_line3Start.y = 0.155;
    Y_line3Start.z = secondDrawingHeight;
    Y_line3Start.timeForTrajectory = 0.2;
    Y_line3Start.name = "Y start";
    Y_line3End.x = 0.045;
    Y_line3End.y = 0.175;
    Y_line3End.z = secondDrawingHeight;
    Y_line3End.timeForTrajectory = 0.5;
    Y_line3End.name = "Vertical line end";
    Y_line3AboveEnd.x = 0.045;
    Y_line3AboveEnd.y = 0.175;
    Y_line3AboveEnd.z = secondDrawingHeight + 0.02;
    Y_line3AboveEnd.timeForTrajectory = 0.2;
    Y_line3AboveEnd.name = "Horizontal line end above";
    
    Y_lineWaypoints = [Y_line1Above, Y_line1Start, Y_line1End, Y_line2End,Y_line2AboveEnd,...
                        Y_line3Above, Y_line3Start, Y_line3End, Y_line3AboveEnd];
  
    % Drawing exclaimation mark
    EM_line1Above.x = 0.025;
    EM_line1Above.y = 0.155;
    EM_line1Above.z = secondDrawingHeight + 0.02;
    EM_line1Above.timeForTrajectory = 0.5;
    EM_line1Above.name = "Above EM start";
    
    EM_line1Start.x = 0.025;
    EM_line1Start.y = 0.155;
    EM_line1Start.z = secondDrawingHeight;
    EM_line1Start.timeForTrajectory = 0.2;
    EM_line1Start.name = "EM line1 start";
    
    EM_line1End.x = 0.025;
    EM_line1End.y = 0.185;
    EM_line1End.z = secondDrawingHeight;
    EM_line1End.timeForTrajectory = 0.5;
    EM_line1End.name = "EM line1 end";
    
    EM_line1AboveEnd.x = 0.025;
    EM_line1AboveEnd.y = 0.185;
    EM_line1AboveEnd.z = secondDrawingHeight + 0.02;
    EM_line1AboveEnd.timeForTrajectory = 0.5;
    EM_line1AboveEnd.name = "EM line1 end";  
    
    EM_dotAbove.x = 0.025;
    EM_dotAbove.y = 0.195;
    EM_dotAbove.z = secondDrawingHeight + 0.02;
    EM_dotAbove.timeForTrajectory = 0.5;
    EM_dotAbove.name = "Above dot start";
    
    EM_dot.x = 0.025;
    EM_dot.y = 0.195;
    EM_dot.z = secondDrawingHeight;
    EM_dot.timeForTrajectory = 0.2;
    EM_dot.name = " Dot start";
    
    EM_dotAboveEnd.x = 0.025;
    EM_dotAboveEnd.y = 0.195;
    EM_dotAboveEnd.z = secondDrawingHeight + 0.02;
    EM_dotAboveEnd.timeForTrajectory = 0.2;
    EM_dotAboveEnd.name = "Above dot end";  
    
    EM_lineWaypoints = [EM_line1Above, EM_line1Start ,EM_line1End, EM_line1AboveEnd, EM_dotAbove, EM_dot, EM_dotAboveEnd ];
    
    ENJ_line_waypoints = [E_lineWaypoints, N_lineWaypoints, J_lineWaypoints];
    YEM_line_waypoints = [Y_lineWaypoints, EM_lineWaypoints];

    %     Constant for ALL lines
    for i = 1 : length(ENJ_line_waypoints)
       ENJ_line_waypoints(i).theta = 0.0;
       ENJ_line_waypoints(i).gripper = gripperPenCubeHoldPos;
%        Lines are more straight if they are defined by start and end waypoints
%        that are not grouped together. Multiple intermediate waypoints for
%        lines works less well.
       ENJ_line_waypoints(i).groupToPrevious = false;
    end
    for i = 1 : length(YEM_line_waypoints)
       YEM_line_waypoints(i).theta = 0.0;
       YEM_line_waypoints(i).gripper = gripperPenCubeHoldPos;
%        Lines are more straight if they are defined by start and end waypoints
%        that are not grouped together. Multiple intermediate waypoints for
%        lines works less well.
       YEM_line_waypoints(i).groupToPrevious = false;
    end
   
   % Place down pen
    penAbovePlaceDown.x = 0.08;
    penAbovePlaceDown.y = 0.08;
    penAbovePlaceDown.z = 0.075;
    penAbovePlaceDown.theta = -pi/2;
    penAbovePlaceDown.gripper = gripperPenCubeHoldPos;
    penAbovePlaceDown.groupToPrevious = false;
    penAbovePlaceDown.timeForTrajectory = 0.4;
    penAbovePlaceDown.name = "Pen above place down";
    
    penPlaceDown.x = 0.08;
    penPlaceDown.y = 0.08;
    penPlaceDown.z = 0.02;
    penPlaceDown.theta = -pi/2;
    penPlaceDown.gripper = gripperOpenPos;
    penPlaceDown.groupToPrevious = false;
    penPlaceDown.timeForTrajectory = 0.2;
    penPlaceDown.name = "Pen place down";
    
    penAbovePlaceDown1.x = 0.08;
    penAbovePlaceDown1.y = 0.08;
    penAbovePlaceDown1.z = drawingHeight + 0.05;
    penAbovePlaceDown1.theta = 0.0;
    penAbovePlaceDown1.gripper = gripperOpenPos;
    penAbovePlaceDown1.groupToPrevious = false;
    penAbovePlaceDown1.timeForTrajectory = 0.25;
    penAbovePlaceDown1.name = "Pen above place down";
    
    placeDownWaypoints = [penAbovePlaceDown, penPlaceDown, penAbovePlaceDown1];
    
   waypoints = [
       pickUpWaypoints,...
       ENJ_line_waypoints, J_ArcWaypoints, circle_Waypoints, YEM_line_waypoints...
       placeDownWaypoints];
end
