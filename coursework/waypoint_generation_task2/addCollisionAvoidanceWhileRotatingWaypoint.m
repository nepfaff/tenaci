function newWaypoints = addCollisionAvoidanceWhileRotatingWaypoint(...
    waypoint, joint2AngleDecrease)
%INSERTCOLLISIONAVOIDANCEWHILEROTATINGWAYPOINT Preprends a waypoint to
%'waypoint', which is higher up, to avoid floor collisions while rotating
%the gripper.
%waypoint: The waypoint at which the gripper rotation ends.
%joint2AngleDecrease: Amount in radians to decrease joint angle 2 by to
%compute the collision avoidance waypoint.
%newWaypoints: A list containing 'waypoint' and the new waypoint.

    ik_sols = OpenManipIK(waypoint.x, waypoint.y, waypoint.z, waypoint.theta);
    if isempty(ik_sols)
        fprintf("insertCollisionAvoidanceWhileRotatingWaypoint: Failed to prepend " +...
            "waypoint due to no IK solutions; x=%f, y=%f, z=%f, theta=%f\n",...
            waypoint.x, waypoint.y, waypoint.z, waypoint.theta);
        newWaypoints = [waypoint];
        return
    end
    [ik_sol, err] = getFirstValidIKSol(ik_sols);
    if err
        fprintf("insertCollisionAvoidanceWhileRotatingWaypoint: Failed to prepend " +...
            "waypoint due to no valid IK solutions; x=%f, y=%f, z=%f, theta=%f\n",...
            waypoint.x, waypoint.y, waypoint.z, waypoint.theta);
        newWaypoints = [waypoint];
        return
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
    newWaypoint.gripper = waypoint.gripper;
    newWaypoint.timeForTrajectory = 0.5;

    % Make this a spline trajectory
    newWaypoint.groupToPrevious = false;
    waypoint.groupToPrevious = true;

    newWaypoints = [newWaypoint, waypoint];
end
