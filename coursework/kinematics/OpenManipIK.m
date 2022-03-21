function sols = OpenManipIK(Xtool, Ytool, Ztool, ThetaTool)
%OPENMANIPFK IK for OpenManipulator-X robot.
% Returns a list of IK solution structs that have the following attributes:
% - joint1_angle
% - joint2_angle
% - joint3_angle
% - joint4_angle
    
    % Values of -0.0 cause issues
    margin = 1e-3;
    if Xtool > -margin && Xtool < margin
        Xtool = 0.0;
    end
    if Ytool > -margin && Ytool < margin
       Ytool = 0.0;
    end

    % System constants
    d1 = 0.077;
    l1 = 0.130;
    l2 = 0.124;
    l3 = 0.126;
    
    sols = [];
    
    % i = 1 => Robot reaches forward
    % i = 2 => Robot reaches backward
    for i = 1:2
        % System 1
        t1 = atan2(Ytool, Xtool);

        % System 2
        r = sqrt(Xtool^2 + Ytool^2);
        z = Ztool - d1;

        x = r - l3*cos(ThetaTool);
        y = z - l3*sin(ThetaTool);
        
        if (i == 2)
            % See https://motion.cs.illinois.edu/RoboticSystems/InverseKinematics.html
            % (section 3.1) for reasoning behind this producing another 2 solutions
            % (total of 4 solutions)
            t1 = t1 + pi;
            x = -x;
        end
        
        [t2, t3, t2_, t3_] = TwoRIK(l1, l2, x, y);

        t4 = ThetaTool - t2 - t3;
        t4_ = ThetaTool - t2_ - t3_;

        if (i == 2 && ThetaTool == 0)
            % NOTE: This seems to be an edge case. Otherwise angles can't
            % all be zero to achieve ThetaTool = 0. Not sure if there are
            % other cases when this occurs.
            % TODO: Look into this!
            if (t4 <= pi)
                t4 = t4 + pi;
            end
            if (t4_ <= pi)
                t4_ = t4_ + pi;
            end
        end
        
        % Elow up and elbow down solutions
        sol1.joint1_angle = t1 - pi/2.0;
        sol1.joint2_angle = -t2 + (pi/2.0 - atan(0.024/0.128));
        sol1.joint3_angle = -t3 - (pi/2.0 - atan(0.024/0.128));
        sol1.joint4_angle = -t4;

        sol2.joint1_angle = t1 - pi/2.0;
        sol2.joint2_angle = -t2_ + (pi/2.0 - atan(0.024/0.128));
        sol2.joint3_angle = -t3_ - (pi/2.0 - atan(0.024/0.128));
        sol2.joint4_angle = -t4_;
        
        sols = [sols, [sol1, sol2]];
    end
end

function [t1, t2, t1_, t2_] = TwoRIK(l1, l2, x, y)
    c2 = (x^2 + y^2 - l1^2 - l2^2) / (2*l1*l2);
    if (abs(c2) > 1)
       %fprintf("OpenManipIK: TwoRIK: No possible IK solution: %d\n", c2);
       t1 = inf;
       t2 = inf;
       t1_ = inf;
       t2_ = inf;
       return
    end
    
    s2 = sqrt(1-c2^2);
    s2_ = -s2;
    
    t2 = atan2(s2, c2);
    t2_ = atan2(s2_, c2);
    
    k1 = l1 + l2*cos(t2);
    k1_ = l1 + l2*cos(t2_);
    k2 = l2*sin(t2);
    k2_ = l2*sin(t2_);

    t1 = atan2(y, x) - atan2(k2, k1);
    t1_ = atan2(y, x) - atan2(k2_, k1_);
end
