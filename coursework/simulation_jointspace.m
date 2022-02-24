clc;
clear;
close all;

beta = pi/2 - atan(0.024/0.128)
% % Draw a square in y-z plane
% YZ1 = [0, 0.2, 0.1, -0.523]
% YZ2 = [0, 0.2, 0.2, -0.523]
% YZ3 = [0, 0.1, 0.2, -0.523]
% YZ4 = [0, 0.1, 0.1, -0.523]

startX = [0, 0, 0, 0]
startY = [0.2, 0.2, 0.1, 0.1]
startZ = [0.1, 0.2, 0.2, 0.1]
startTheta =[ -0.523 -0.523 -0.523 -0.523]
endX =[ 0, 0, 0, 0]
endY =[ 0.2, 0.1, 0.1, 0.2]
endZ = [0.2, 0.2, 0.1, 0.1]
endTheta = [ -0.523 -0.523 -0.523 -0.523]
timeForTrajectory = 1
samplePeriod = 0.1

plot3([0 0], [0 0], [0 0])
xlabel('X')
ylabel('Y')
zlabel('Z')
xlim([-0.21, 0.21])
ylim([-0.21, 0.21])
zlim([0 0.457])
title("Forward Kinematics")
grid on
hold on

for i = 1:length(startX)
[thetas1, thetas2, thetas3, thetas4, times] = JointAngleSetPointsStartEndUsingJointSpace(startX(i), startY(i), startZ(i), startTheta(i), endX(i), endY(i), endZ(i), endTheta(i), timeForTrajectory, samplePeriod)
    for j = 1:length(times)
        %base frame
        T0 = tfFromDH(0.0, 0.0, 0.0, thetas1(j))
        x_dir0 = T0(1:3,1)*0.01
        y_dir0 = T0(1:3,2)*0.01
        z_dir0 = T0(1:3,3)*0.01
        pos0 = T0(:,4)

        %first joint
        T1 = T0* tfFromDH(0, 0.0, 0.077,pi/2);
        x_dir1 = T1(1:3,1)*0.01
        y_dir1 = T1(1:3,2)*0.01
        z_dir1 = T1(1:3,3)*0.01
        pos1 = T1(:,4)

        %second joint
        T2 = T1 * tfFromDH(pi/2, 0.0, 0.0, -thetas2(j) + beta)* tfFromDH(0.0, 0.130, 0, -thetas3(j)-beta);
        x_dir2 = T2(1:3,1)*0.01
        y_dir2 = T2(1:3,2)*0.01
        z_dir2 = T2(1:3,3)*0.01
        pos2 = T2(:,4)

        %third joint
        T3 = T2 * tfFromDH(0, 0.124, 0.0, -thetas4(j))
        x_dir3 = T3(1:3,1)*0.01
        y_dir3 = T3(1:3,2)*0.01
        z_dir3 = T3(1:3,3)*0.01
        pos3 = T3(:,4)

        %forth joint
        T4 = T3 * tfFromDH(0, 0.126, 0.0, 0)
        x_dir4 = T4(1:3,1)*0.01
        y_dir4 = T4(1:3,2)*0.01
        z_dir4 = T4(1:3,3)*0.01
        pos4 = T4(:,4)

        hold on
        base_x = plot3([0, 0 + x_dir0(1)], [0, 0+ x_dir0(2) ], [0, 0+ x_dir0(3)], 'Color','r','LineWidth',2)
        hold on
        base_y = plot3([0, 0 + y_dir0(1)], [0, 0 + y_dir0(2)], [0, 0+ y_dir0(3)], 'Color','g','LineWidth',2)
        hold on
        base_z = plot3([0, 0 + z_dir0(1) ], [0, 0 + z_dir0(2)], [0, 0+ z_dir0(3)], 'Color','b','LineWidth',2)
        hold on
        line1 = plot3([0, pos1(1)], [0, pos1(2)], [0,pos1(3)], 'Color','black','LineWidth',2)
        hold on
        frame1_x = plot3([pos1(1), pos1(1) + x_dir1(1)], [pos1(2), pos1(2)+ x_dir1(2) ], [pos1(3), pos1(3)+ x_dir1(3)], 'Color','r','LineWidth',2)
        hold on
        frame1_y = plot3([pos1(1), pos1(1) + y_dir1(1)], [pos1(2), pos1(2) + y_dir1(2)], [pos1(3), pos1(3) + y_dir1(3)], 'Color','g','LineWidth',2)
        hold on
        frame1_z = plot3([pos1(1), pos1(1) + z_dir1(1) ], [pos1(2), pos1(2) + z_dir1(2)], [pos1(3), pos1(3)+ z_dir1(3)], 'Color','b','LineWidth',2)
        hold on
        line2 = plot3([pos1(1), pos2(1)], [pos1(2), pos2(2)], [pos1(3),pos2(3)], 'Color','black','LineWidth',2)
        hold on
        frame2_x = plot3([pos2(1),pos2(1) +  x_dir1(1)], [pos2(2), pos2(2) +  x_dir1(2)], [pos2(3), pos2(3)+  x_dir1(3)], 'Color','r','LineWidth',2)
        hold on
        frame2_y = plot3([pos2(1), pos2(1) +  y_dir2(1)], [pos2(2), pos2(2) + y_dir2(2)], [pos2(3), pos2(3)+ y_dir2(3)], 'Color','g','LineWidth',2)
        hold on
        frame2_z = plot3([pos2(1),pos2(1) + z_dir2(1) ], [pos2(2), pos2(2) + z_dir2(2)], [pos2(3), pos2(3)+ z_dir2(3)], 'Color','b','LineWidth',2)
        hold on
        line3 =plot3([pos2(1), pos3(1)], [pos2(2), pos3(2)], [pos2(3), pos3(3)], 'Color','black','LineWidth',2)
        hold on
        frame3_x = plot3([pos3(1),pos3(1) +  x_dir3(1)], [pos3(2), pos3(2) +  x_dir3(2)], [pos3(3), pos3(3)+  x_dir3(3)], 'Color','r','LineWidth',2)
        hold on
        frame3_y = plot3([pos3(1), pos3(1) +  y_dir3(1)], [pos3(2), pos3(2)+ y_dir3(2)], [pos3(3), pos3(3)+ y_dir3(3)], 'Color','g','LineWidth',2)
        hold on
        frame3_z = plot3([pos3(1), pos3(1) + z_dir3(1) ], [pos3(2),pos3(2) + z_dir3(2)], [pos3(3), pos3(3)+ z_dir3(3)], 'Color','b','LineWidth',2)
        hold on
        line4 =plot3([pos3(1), pos4(1)], [pos3(2), pos4(2)], [pos3(3), pos4(3)], 'Color','black','LineWidth',2)
        hold on
        frame4_x = plot3([pos4(1), pos4(1) +  x_dir4(1)], [pos4(2), pos4(2) +  x_dir4(2)], [pos4(3), pos4(3)+  x_dir4(3)], 'Color','r','LineWidth',2)
        hold on
        frame4_y = plot3([pos4(1), pos4(1) +  y_dir4(1)], [pos4(2), pos4(2) + y_dir4(2)], [pos4(3), pos4(3)+ y_dir4(3)], 'Color','g','LineWidth',2)
        hold on
        frame4_z = plot3([pos4(1), pos4(1) + z_dir4(1) ], [pos4(2), pos4(2) + z_dir4(2)], [pos4(3), pos4(3)+ z_dir4(3)], 'Color','b','LineWidth',2)
        hold on
        plot3( pos4(1), pos4(2), pos4(3), '.', 'markersize', 8)
        pause(0.001)
        if( (i == length(startX)) && (j == length(times))) 
            break
        else 
            delete(base_x)
            delete(base_y)
            delete(base_z)
            delete(line4)
            delete(frame4_x)
            delete(frame4_y)
            delete(frame4_z)
            delete(line3)
            delete(frame3_x)
            delete(frame3_y)
            delete(frame3_z)
            delete(line2)
            delete(frame2_x)
            delete(frame2_y)
            delete(frame2_z)
            delete(line1)
            delete(frame1_x)
            delete(frame1_y)
            delete(frame1_z)
        end
    end
end


function tf = tfFromDH(alpha, a, d, theta)
%tfFromDH Converts DH parameters into a homogenous transformation matrix.

    tf = [
        cos(theta), -sin(theta), 0, a;
        sin(theta)*cos(alpha), cos(theta)*cos(alpha), -sin(alpha), -sin(alpha)*d;
        sin(theta)*sin(alpha), cos(theta)*sin(alpha), cos(alpha), cos(alpha)*d;
        0 0 0 1
    ];
end


