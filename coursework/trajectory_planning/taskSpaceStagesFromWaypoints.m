function stages = taskSpaceStagesFromWaypoints(...
    waypoints, samplePeriod...
)
%TASKSPACESETPOINTSFROMWAYPOINTS Converts a list of waypoints into a list
%of stages using task space trajectories. Groups waypoints labeled
%using groupToPrevious into a spline trajectory. All other waypoints will
%be directly connected using a cubic trajectory.
%waypoints is a list of waypoint structs with attributes x, y, z, theta,
%gripper, groupToPrevious, and timeForTrajectory. The list must include the
%gripper's starting pose.
%samplePeriod is the sample period for sampling the set points from the
%trajectory functions.
%stages is a list of structs with attributes setPointJointAngles,
%setPointTimes, and gripperOpening:
%setPointJointAngles is a list of joint angle stucts with attributes
%joint1_angle, joint2_angle, joint3_angle, and joint4_angle
%setPointTimes is a list of timestamps associated with the joint angles in
%setPointJointAngles
%gripperOpening is the gripper opening associated with the movement stage.
%The gripper should be opened to this opening after reaching that stage's
%final setpoint

    if length(waypoints) < 2
        error("Need a minimum of 2 waypoints for spline interpolation");
    end
    
    stages = [];
    i = 2;
    while i <= length(waypoints)
        if waypoints(i).groupToPrevious % Spline trajectory connecting a sequence of waypoints
           % Group all waypoints forming this spline trajectory
           splineWaypoints = [waypoints(i-1)];
           while i <= length(waypoints) && waypoints(i).groupToPrevious
               splineWaypoints = [splineWaypoints, waypoints(i)];
               i = i+1;
           end
           i = i-1;
           
           timeForTrajectory = splineWaypoints(length(splineWaypoints)).timeForTrajectory;
           [setPointJointAngles, setPointTimes] = TaskSpaceCubicSplineTrajectorySetPoints(...
                splineWaypoints, timeForTrajectory, samplePeriod...
            );

        else % Direct trajectory between waypoints
            timeForTrajectory = waypoints(i).timeForTrajectory;
            [setPointJointAngles, setPointTimes] = TaskSpaceTrajectorySetPoints(...
                waypoints(i-1), waypoints(i), timeForTrajectory, samplePeriod...
            );
        end
        
        stage.setPointJointAngles = setPointJointAngles;
        stage.setPointTimes = setPointTimes;
        % Use last gripper opening of waypoint sequence
        stage.gripperOpening = waypoints(i).gripper;
        stages = [stages, stage];
        
        i = i+1;
    end
end
