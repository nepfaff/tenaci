function [thetas1, thetas2, thetas3, thetas4, times] = JointAngleSetPointsStartEndUsingJointSpace(startX, startY, startZ, startTheta, endX, endY, endZ, endTheta, timeForTrajectory, samplePeriod)
%JOINTANGLESETPOINTSSTARTENDUSINGJOINTSPACE Computes joint angle set points
%to move from a start to an end pose.

    % IK to get start and end pose in joint space
    startIKSols = OpenManipIK(startX, startY, startZ, startTheta);
    endIKSols = OpenManipIK(endX, endY, endZ, endTheta);
    startIKSol = getFirstValidIKSol(startIKSols);
    endIKSol = getFirstValidIKSol(endIKSols);
    
    % Get theta set points forming trajectories between start and end
    [thetas1, times] = JointSpaceTrajectorySetPoints(startIKSol.joint1_angle, endIKSol.joint1_angle, timeForTrajectory, samplePeriod);
    thetas2 = JointSpaceTrajectorySetPoints(startIKSol.joint2_angle, endIKSol.joint2_angle, timeForTrajectory, samplePeriod);
    thetas3 = JointSpaceTrajectorySetPoints(startIKSol.joint3_angle, endIKSol.joint3_angle, timeForTrajectory, samplePeriod);
    thetas4 = JointSpaceTrajectorySetPoints(startIKSol.joint4_angle, endIKSol.joint4_angle, timeForTrajectory, samplePeriod);
end

function sol = getFirstValidIKSol(sols)
    for i = 1:4
        if ~DoJointAnglesViolateJointLimits(sols(i).joint1_angle, sols(i).joint2_angle, sols(i).joint3_angle, sols(i).joint4_angle)
            sol = sols(i);
            return
        end
    end
end
