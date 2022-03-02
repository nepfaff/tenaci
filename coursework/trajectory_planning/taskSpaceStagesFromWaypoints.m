function stages = taskSpaceStagesFromWaypoints(...
    waypoints, timeForTrajectory, samplePeriod...
)
%TASKSPACESETPOINTSFROMWAYPOINTS Converts a list of waypoints into a list
%of stages using task space trajectories. Groups waypoints labeled
%using groupToPrevious into a spline trajectory. All other waypoints will
%be directly connected using a cubic trajectory.
%waypoints is a list of waypoint structs with attributes x, y, z, theta,
%gripper, and groupToPrevious. The list must include the gripper's starting
%pose.
%timeForTrajectory is the time in seconds to use for trajectories. This is
%used for individual trajectories rather than the time for all waypoints
%samplePeriod is the sample period for sampling the set points from the
%trajectory functions
%stages is a list of structs with attributes setPointJointAngles,
%setPointTimes, and gripperOpening:
%setPointJointAngles is a list of joint angle stucts with attributes
%joint1_angle, joint2_angle, joint3_angle, and joint4_angle
%setPointTimes is a list of timestamps associated with the joint angles in
%setPointJointAngles
%gripperOpening is the gripper opening associated with the movement stage.
%The gripper should be opened to this opening after reaching that stage's
%final setpoint
    
    stages = [];
    for i = 2 : length(waypoints)
        if waypoints(i).groupToPrevious % Spline trajectory connecting a sequence of waypoints
           % Group all waypoints forming this spline trajectory
           splineWaypoints = [];
           while waypoints(i).groupToPrevious
               splineWaypoints = [splineWaypoints, waypoints(i)];
               i = i+1;
           end
           i = i-1;

           [setPointJointAngles, setPointTimes] = TaskSpaceCubicSplineTrajectorySetPoints(...
                splineWaypoints, timeForTrajectory, samplePeriod...
            );

        else % Direct trajectory between waypoints
            [setPointJointAngles, setPointTimes] = TaskSpaceTrajectorySetPoints(...
                waypoints(i-1), waypoints(i), timeForTrajectory, samplePeriod...
            );
        end
        
        stage.setPointJointAngles = setPointJointAngles;
        stage.setPointTimes = setPointTimes;
        % Use last gripper opening of waypoint sequence
        stage.gripperOpening = waypoints(i).gripper;
        stages = [stages, stage];
    end
end
