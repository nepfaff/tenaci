function [jointAngles, times] = JointSpaceCubicSplineTrajectorySetPoints(...
    waypoints, timeForTrajectory, samplePeriod...
)
%JOINTSPACECUBICSPLINETRAJECTORYSETPOINTS

    if length(waypoints) < 2
        error("JointSpaceCubicSplineTrajectorySetPoints: Need a minimum of " +...
            "2 waypoints for spline interpolation");
    end
    
    timeBetweenWaypoints = timeForTrajectory / (length(waypoints)-1);
    
    % Construct (value, time) points
    theta1Points = [];
    theta2Points = [];
    theta3Points = [];
    theta4Points = [];
    t = 0.0;
    for i = 1 : length(waypoints)
        ik_sols = OpenManipIK(waypoints(i).x, waypoints(i).y, waypoints(i).z, waypoints(i).theta);
        if isempty(ik_sols)
            fprintf("Waypoint = X: %f, Y: %f, Z: %f, Th: %f, Name: %s\n",...
                waypoints(i).x, waypoints(i).y, waypoints(i).z, waypoints(i).theta, waypoint(i).name);
            error("JointSpaceCubicSplineTrajectorySetPoints: No IK solutions found. Time = %d", t);
        end
        [ik_sol, err] = getFirstValidIKSol(ik_sols);
        if err
           fprintf("Waypoint = X: %f, Y: %f, Z: %f, Th: %f\n",...
               waypoints(i).x, waypoints(i).y, waypoints(i).z, waypoints(i).theta);
           error("JointSpaceCubicSplineTrajectorySetPoints: No valid IK solution found. Time = %d", t);
        end
        
        theta1Point.y = ik_sol.joint1_angle;
        theta1Point.x = t;
        theta1Points = [theta1Points, theta1Point];
        theta2Point.y = ik_sol.joint2_angle;
        theta2Point.x = t;
        theta2Points = [theta2Points, theta2Point];
        theta3Point.y = ik_sol.joint3_angle;
        theta3Point.x = t;
        theta3Points = [theta3Points, theta3Point];
        theta4Point.y = ik_sol.joint4_angle;
        theta4Point.x = t;
        theta4Points = [theta4Points, theta4Point];
   
        t = t + timeBetweenWaypoints;
    end
    
    % Compute spline coefficients
    theta1Cubics = CubicSplineInterpolation(theta1Points);
    theta2Cubics = CubicSplineInterpolation(theta2Points);
    theta3Cubics = CubicSplineInterpolation(theta3Points);
    theta4Cubics = CubicSplineInterpolation(theta4Points);
    
    % Sample splines
    jointAngles = [];
    times = [];
    currentCubicIdx = 1;
    for t = 0 : samplePeriod : timeForTrajectory
        if t > theta1Cubics(currentCubicIdx).xmax
            currentCubicIdx = currentCubicIdx + 1;
        end
        
        jointAngle.joint1_angle = theta1Cubics(currentCubicIdx).a0 + theta1Cubics(currentCubicIdx).a1*t + ...
            theta1Cubics(currentCubicIdx).a2*t^2 + theta1Cubics(currentCubicIdx).a3*t^3;
        jointAngle.joint2_angle = theta2Cubics(currentCubicIdx).a0 + theta2Cubics(currentCubicIdx).a1*t + ...
            theta2Cubics(currentCubicIdx).a2*t^2 + theta2Cubics(currentCubicIdx).a3*t^3;
        jointAngle.joint3_angle = theta3Cubics(currentCubicIdx).a0 + theta3Cubics(currentCubicIdx).a1*t + ...
            theta3Cubics(currentCubicIdx).a2*t^2 + theta3Cubics(currentCubicIdx).a3*t^3;
        jointAngle.joint4_angle = theta4Cubics(currentCubicIdx).a0 + theta4Cubics(currentCubicIdx).a1*t + ...
            theta4Cubics(currentCubicIdx).a2*t^2 + theta4Cubics(currentCubicIdx).a3*t^3;

        jointAngles = [jointAngles, jointAngle];
        times = [times, t];
    end
end
