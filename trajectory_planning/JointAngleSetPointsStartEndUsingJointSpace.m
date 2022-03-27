function [jointAngles, times] = JointAngleSetPointsStartEndUsingJointSpace(...
    startX, startY, startZ, startTheta, endX, endY, endZ, endTheta, timeForTrajectory, samplePeriod)
%JOINTANGLESETPOINTSSTARTENDUSINGJOINTSPACE Computes joint angle set points
%to move from a start to an end pose.

    % IK to get start and end pose in joint space
    startIKSols = OpenManipIK(startX, startY, startZ, startTheta);
    endIKSols = OpenManipIK(endX, endY, endZ, endTheta);
    [startIKSol, err] = getFirstValidIKSol(startIKSols);
    if err
       fprintf("Start target = X: %f, Y: %f, Z: %f, Th: %f\n",...
            startX, startY, startZ, startTheta);
       error("JointAngleSetPointsStartEndUsingJointSpace: No valid start IK solution found\n");
    end
    [endIKSol, err] = getFirstValidIKSol(endIKSols);
    if err
       fprintf("End target = X: %f, Y: %f, Z: %f, Th: %f\n",...
            endX, endY, endZ, endTheta);
       error("JointAngleSetPointsStartEndUsingJointSpace: No valid end IK solution found\n");
    end
       
    % Get theta set points forming trajectories between start and end
    [thetas1, times] = JointSpaceTrajectorySetPoints(...
        startIKSol.joint1_angle, endIKSol.joint1_angle, timeForTrajectory, samplePeriod);
    thetas2 = JointSpaceTrajectorySetPoints(...
        startIKSol.joint2_angle, endIKSol.joint2_angle, timeForTrajectory, samplePeriod);
    thetas3 = JointSpaceTrajectorySetPoints(...
        startIKSol.joint3_angle, endIKSol.joint3_angle, timeForTrajectory, samplePeriod);
    thetas4 = JointSpaceTrajectorySetPoints(...
        startIKSol.joint4_angle, endIKSol.joint4_angle, timeForTrajectory, samplePeriod);
    
    jointAngles = [];
    for i = 1 : length(times)
       jointAngle.joint1_angle = thetas1(i);
       jointAngle.joint2_angle = thetas2(i);
       jointAngle.joint3_angle = thetas3(i);
       jointAngle.joint4_angle = thetas4(i);
       
       jointAngles = [jointAngles, jointAngle];
    end
end
