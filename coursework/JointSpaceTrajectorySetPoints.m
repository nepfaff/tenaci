function [thetas, times] = JointSpaceTrajectorySetPoints(thetaStart, thetaEnd, timeForTrajectory, samplePeriod)
%JOINTSPACETRAJECTORYSETPOINTS Returns samples of a cubic joint space
%interpolation.
    
    thetaDelta = thetaEnd - thetaStart;
    
    % Polynomical coefficients
    a0 = thetaStart;
    a1 = 0;
    a2 = 3 / (timeForTrajectory^2) * thetaDelta;
    a3 = -2 / (timeForTrajectory^3) * thetaDelta;
    
    % Sample polynomial
    thetas = [];
    times = [];
    for t = 0 : samplePeriod : timeForTrajectory
        theta = a0 + a1*t + a2*t^2 + a3*t^3;
        
        thetas = [thetas, theta];
        times = [times, t];
    end
end
