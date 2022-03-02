function [jointAngles, times] = TaskSpaceCubicSplineTrajectorySetPoints(...
    waypoints, timeForTrajectory, samplePeriod...
)
%TASKSPACECUBICSPINETRAJECTORYSETPOINTS Returns samples of a cubic task
%space spine interpolation in joint space representation.

    if length(waypoints) < 2
        error("Need a minimum of 2 waypoints for spline interpolation");
    end

    timeBetweenWaypoints = timeForTrajectory / (length(waypoints)-1);
    
    % Construct (value, time) points
    xPoints = [];
    yPoints = [];
    zPoints = [];
    thetaPoints = [];
    t = 0.0;
    for i = 1 : length(waypoints)
        xPoint.y = waypoints(i).x;
        xPoint.x = t;
        xPoints = [xPoints, xPoint];
        yPoint.y = waypoints(i).y;
        yPoint.x = t;
        yPoints = [yPoints, yPoint];
        zPoint.y = waypoints(i).z;
        zPoint.x = t;
        zPoints = [zPoints, zPoint];
        thetaPoint.y = waypoints(i).theta;
        thetaPoint.x = t;
        thetaPoints = [thetaPoints, thetaPoint];
   
        t = t + timeBetweenWaypoints;
    end
    
    % Compute spline coefficients
    xCubics = CubicSplineInterpolation(xPoints);
    yCubics = CubicSplineInterpolation(yPoints);
    zCubics = CubicSplineInterpolation(zPoints);
    thetaCubics = CubicSplineInterpolation(thetaPoints);
    
    % Sample splines
    jointAngles = [];
    times = [];
    currentCubicIdx = 1;
    for t = 0 : samplePeriod : timeForTrajectory
        if t > xCubics(currentCubicIdx).xmax
            currentCubicIdx = currentCubicIdx + 1;
        end
        
        x = xCubics(currentCubicIdx).a0 + xCubics(currentCubicIdx).a1*t + ...
            xCubics(currentCubicIdx).a2*t^2 + xCubics(currentCubicIdx).a3*t^3;
        y = yCubics(currentCubicIdx).a0 + yCubics(currentCubicIdx).a1*t + ...
            yCubics(currentCubicIdx).a2*t^2 + yCubics(currentCubicIdx).a3*t^3;
        z = zCubics(currentCubicIdx).a0 + zCubics(currentCubicIdx).a1*t + ...
            zCubics(currentCubicIdx).a2*t^2 + zCubics(currentCubicIdx).a3*t^3;
        theta = thetaCubics(currentCubicIdx).a0 + thetaCubics(currentCubicIdx).a1*t + ...
            thetaCubics(currentCubicIdx).a2*t^2 + thetaCubics(currentCubicIdx).a3*t^3;
        
        % Covert into joint space
        ik_sols = OpenManipIK(x, y, z, theta);
        if isempty(ik_sols)
            printWaypoints(waypoints);
            fprintf("Target = X: %f, Y: %f, Z: %f, Th: %f\n", x, y, z, theta);
            error("TaskSpaceCubicSplineTrajectorySetPoints: No IK solutions found. Time = %d", t);
        end
        [ik_sol, err] = getFirstValidIKSol(ik_sols);
        if err
           printWaypoints(waypoints);
           fprintf("Target = X: %f, Y: %f, Z: %f, Th: %f\n", x, y, z, theta);
           error("TaskSpaceCubicSplineTrajectorySetPoints: No valid IK solution found. Time = %d", t);
        end
        
        jointAngles = [jointAngles, ik_sol];
        times = [times, t];
    end
end
