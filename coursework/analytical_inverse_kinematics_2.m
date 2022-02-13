clear
clc

% Define tool pose
Xtool = 0.0;
Ytool = 0.2;
Ztool = 0.05;
ThetaTool = pi/2.0;

% Define constants
d1 = 0.077;
l1 = 0.130;
l2 = 0.124;
l3 = 0.126;

% IK

%System 1
t1 = atan2(Ytool, Xtool);

%System 2
r = sqrt(Xtool^2 + Ytool^2);
z = Ztool - d1;

c3 = ((r - l3*cos(ThetaTool))^2 + (z - l3*sin(ThetaTool))^2 - l1^2 - l2^2) / (2*l1*l2);
if (c3 > 1 || c3 < -1)
   fprintf("No possible IK solution: %d", c3) 
end

s3 = sqrt(1-c3^2);
s3_ = -s3;

t3 = atan2(s3, c3);
t3_ = atan2(s3_, c3);

k1 = l1 + l2*cos(t3);
k1_ = l1 + l2*cos(t3_);
k2 = l2*sin(t3);
k2_ = l2*sin(t3_);

t2 = atan2(z - l3*sin(ThetaTool), r - l3*cos(ThetaTool)) - atan2(k2, k1);
t2_ = atan2(z - l3*sin(ThetaTool), r - l3*cos(ThetaTool)) - atan2(k2_, k1_);

t4 = ThetaTool - t2 - t3;
t4_ = ThetaTool - t2_ - t3_;

% Convert DH angles to encoder (joint) angles
joint1_angle = t1 + pi/2.0
joint2_angle = t2 - (pi/2.0 + atan(0.024/0.128))
joint3_angle = t3 - (pi/2.0 - atan(0.024/0.128))
joint4_angle = t4

joint1_angle_ = t1 + pi/2.0
joint2_angle_ = t2_ - (pi/2.0 + atan(0.024/0.128))
joint3_angle_ = t3_ - (pi/2.0 - atan(0.024/0.128))
joint4_angle_ = t4_
