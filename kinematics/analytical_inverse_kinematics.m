% Define tool pose
Xtool = 0.0;
Ytool = 0.148;
Ztool = 0.079;
ThetaTool = -pi/2;

sols = OpenManipIK(Xtool, Ytool, Ztool, ThetaTool);
for i = 1:4
    fprintf("Sol %d: ja1 = %d, ja2 = %d, ja3 = %d, ja4 = %d\n", i, sols(i).joint1_angle, sols(i).joint2_angle, sols(i).joint3_angle, sols(i).joint4_angle)
end
