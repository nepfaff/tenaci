function newWaypoints = insertCubeAvoidanceWaypoints(waypoints, minDistance, joint2AngleDecrease)
%INSERTCUBEAVOIDANCEWAYPOINTS Iterates over a sequence of waypoints and
%inserts additional waypoints if two consequtive waypoints are too far from
%each other (L2 norm). The additional waypoints are at higher z-coordinates
%to avoid collisions with stationary cubes while moving between gripper
%poses.
%waypoints: The waypoint sequence to modfiy.
%minDistance: The minimum L2 norm between two waypoints (x,y) that causes
%an additional waypoint to be inserted.
%joint2AngleDecrease: Amount in radians to decrease joint angle 2 by to
%compute the cube avoidance waypoint.
%newWaypoints: The entire waypoint list consisting of 'waypoints' and the
%new inserted waypoints.
    
    newWaypoints = [waypoints(1)];
    for i = 2 : length(waypoints)
        start = waypoints(i-1);
        finish = waypoints(i);
        
        % Determine if we should insert a waypoint
        distance = norm([start.x, start.y]-[finish.x, finish.y]);
        if distance < minDistance
            newWaypoints = [newWaypoints, finish];
            continue;
        end
        
        % Find midpoint for inserting the waypoint
        mid.x = (start.x + finish.x)/2;
        mid.y = (start.y + finish.y)/2;
        mid.z = (start.z + finish.z)/2;
        mid.theta = (start.theta + finish.theta)/2;
        ik_sols = OpenManipIK(mid.x, mid.y, mid.z, mid.theta);
        if isempty(ik_sols)
            fprintf("insertCubeAvoidanceWaypoints: Failed to insert " +...
                "waypoint due to no IK solutions; x=%f, y=%f, z=%f, theta=%f\n",...
                mid.x, mid.y, mid.z, mid.theta);
            newWaypoints = [newWaypoints, finish];
            continue;
        end
        [ik_sol, err] = getFirstValidIKSol(ik_sols);
        if err
            fprintf("insertCubeAvoidanceWaypoints: Failed to insert " +...
                "waypoint due to no valid IK solutions; x=%f, y=%f, z=%f, theta=%f\n",...
                mid.x, mid.y, mid.z, mid.theta);
            newWaypoints = [newWaypoints, finish];
            continue;
        end
        
        % Modify joint angle 2 for moving gripper upwards
        joint2_angle = ik_sol.joint2_angle - joint2AngleDecrease;
        [x, y, z, theta] = OpenManipFK(ik_sol.joint1_angle, joint2_angle,...
            ik_sol.joint3_angle, ik_sol.joint4_angle);
        
        % Create new waypoint
        newWaypoint.x = x;
        newWaypoint.y = y;
        newWaypoint.z = z;
        newWaypoint.theta = theta;
        newWaypoint.gripper = start.gripper;
        newWaypoint.timeForTrajectory = 0.0;
        newWaypoint.name = "cube avoidance";
        
        % Make this a spline trajectory
        newWaypoint.groupToPrevious = true;
        finish.groupToPrevious = true;
        finish.timeForTrajectory = 1.0;
        
        newWaypoints = [newWaypoints, newWaypoint, finish];
    end
end
