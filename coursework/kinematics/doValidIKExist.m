function doExist = doValidIKExist(waypoints)
%DOVALIDIKEXIST Returns true if all the waypoint structs in waypoints have
%valid IK solutions and false otherwise.
    
    exists = true;
    for i = 1 : length(waypoints)
        ik_sols = OpenManipIK(waypoints(i).x, waypoints(i).y, waypoints(i).z, waypoints(i).theta);
        if isempty(ik_sols)
            exists = false;
        end
        [~, err] = getFirstValidIKSol(ik_sols);
        if err
           exists = false;
        end
    end
    
    doExist = exists;
end
