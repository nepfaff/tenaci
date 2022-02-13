clc
clear
syms t1 t2 t3 t4

% beta = atan(0.024/0.128)
% delta = pi/2-beta
T01 = [cos(t1 - pi/2), -sin(t1 - pi/2), 0, 0;
    sin(t1 - pi/2),  cos(t1 - pi/2), 0, 0;
                 0,               0, 1, 0;
                 0,               0, 0, 1];

T12 =     [1.0000         0         0         0;
             0    1.0000         0         0;
     	    0         0    1.0000    0.0770;
           0         0         0    1.0000];
         
T23 = [cos(t2 + 988621338820367/562949953421312), -sin(t2 + 988621338820367/562949953421312),  0, 0;
                                        0,                                          0, -1, 0;
sin(t2 + 988621338820367/562949953421312),  cos(t2 + 988621338820367/562949953421312),  0, 0;
                                        0,                                          0,  0, 1];

T34 = [cos(t3 + 779938099186743/562949953421312), -sin(t3 + 779938099186743/562949953421312), 0, 13/100;
sin(t3 + 779938099186743/562949953421312),  cos(t3 + 779938099186743/562949953421312), 0,      0;
                                        0,                                          0, 1,      0;
                                        0,                                          0, 0,      1];
                                    
T45 = [cos(t4), -sin(t4), 0, 31/250;
    sin(t4),  cos(t4), 0,      0;
          0,        0, 1,      0;
          0,        0, 0,      1];

T56 = [1 0 0 0.126;
        0 1 0 0;
        0 0 1 0;
        0 0 0 1];

T06 = T01 * T12 * T23 * T34 * T45 * T56;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

x = T06(1,4);
y = T06(2,4);
z = T06(3,4);

% TODO: Determine joint constraints and add these limits here
% See here for joint limits: https://github.com/ROBOTIS-GIT/open_manipulator/blob/be2859a0506b4e941a19435c0a07562b41768a27/open_manipulator_libs/src/OpenManipulator.cpp#L34-L82
range = [-2,2; -2,2; -2,2; -2,2];

eqns = [x == 0.0, y == 0.1, z == 0.03];
vars = [t1 t2 t3 t4];
[st1, st2, st3, st4] = vpasolve(eqns, vars, range)

