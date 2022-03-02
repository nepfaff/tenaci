function wayPoints = generateWaypointsByList(lst,t,grip)
    wayPoints = []
    [m,n] = size(lst)
    for i = 1:m
        waypoint.x = lst(i,1);
        waypoint.y = lst(i,2);
        waypoint.z = lst(i,3);
        waypoint.theta = t;
        waypoint.gripper = grip;
        wayPoints = [wayPoints,waypoint]
    end
   
end

