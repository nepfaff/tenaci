clear
clc

% Define tool pose
Xtool = 0.27395;
Ytool = 0.0;
Ztool = 0.20477;
ThetaTool = 0;

% Define constants
d1 = 0.077;
l1 = 0.130;
l2 = 0.124;
l3 = 0.126;

% IK

% System 1
t1 = atan2(Ytool, Xtool) - pi;

% System 2
r = sqrt(Xtool^2 + Ytool^2);
z = Ztool - d1;

x = r - l3*cos(ThetaTool);
y = z - l3*sin(ThetaTool);
% See https://motion.cs.illinois.edu/RoboticSystems/InverseKinematics.html
% (section 3.1) for reasoning behind this producing another 2 solutions
% (total of 4 solutions)
[t2, t3, t2_, t3_] = TwoRIK(l1, l2, -x, y);

t4 = ThetaTool - t2 - t3;
t4_ = ThetaTool - t2_ - t3_;

% NOTE: Not sure why this works (got this by trial and error).
% This is necessary because ThetaTool = 0 can't otherwise be achieved by
% setting all joint angles equal to zero. Maybe because this causes the
% TODO: Figure out why this is works + find a better solution if possible.
if (t4 <= pi)
    t4 = t4 + pi;
end
if (t4_ <= pi)
    t4_ = t4_ + pi;
end

% Convert DH angles to encoder (joint) angles
joint1_angle = t1 + pi/2.0
joint2_angle = t2 - (pi/2.0 + atan(0.024/0.128))
joint3_angle = t3 - (pi/2.0 - atan(0.024/0.128))
joint4_angle = t4

joint1_angle_ = t1 + pi/2.0
joint2_angle_ = t2_ - (pi/2.0 + atan(0.024/0.128))
joint3_angle_ = t3_ - (pi/2.0 - atan(0.024/0.128))
joint4_angle_ = t4_


function [t1, t2, t1_, t2_] = TwoRIK(l1, l2, x, y)
    c2 = (x^2 + y^2 - l1^2 - l2^2) / (2*l1*l2);
    if (abs(c2) > 1)
       fprintf("No possible IK solution: %d", c2);
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
