clc;
clear;
close all;

lib_name = '';

if strcmp(computer, 'PCWIN')
  lib_name = 'dxl_x86_c';
elseif strcmp(computer, 'PCWIN64')
  lib_name = 'dxl_x64_c';
elseif strcmp(computer, 'GLNX86')
  lib_name = 'libdxl_x86_c';
elseif strcmp(computer, 'GLNXA64')
  lib_name = 'libdxl_x64_c';
elseif strcmp(computer, 'MACI64')
  lib_name = 'libdxl_mac_c';
end

% Load Libraries
if ~libisloaded(lib_name)
    [notfound, warnings] = loadlibrary(lib_name, 'dynamixel_sdk.h', 'addheader', 'port_handler.h', 'addheader', 'packet_handler.h');
end

%% ---- Control Table Addresses ---- %%

ADDR_PRO_TORQUE_ENABLE        = 64;           % Control table address is different in Dynamixel model
ADDR_PRO_GOAL_POSITION        = 116; 
ADDR_PRO_PRESENT_POSITION     = 132; 
ADDR_PRO_OPERATING_MODE       = 11;
ADDR_PRO_DRIVE_MODE           = 10;
ADDR_PRO_PROFILE_ACCELERATION = 108;
ADDR_PRO_PROFILE_VELOCITY     = 112;
ADDR_PRO_MOVING               = 122;
ADDR_P_GAIN                   = 84;
ADDR_I_GAIN                   = 82;
ADDR_D_GAIN                   = 80;

%% ---- Other Settings ---- %%

% Protocol version
PROTOCOL_VERSION            = 2.0;          % See which protocol version is used in the Dynamixel

% Default setting
DXL_ID1                      = 11;            % Dynamixel ID: 1
DXL_ID2                      = 12;  % TODO: Add correct IDs
DXL_ID3                      = 13;
DXL_ID4                      = 14;
DXL_ID5                      = 15;
BAUDRATE                    = 115200;
DEVICENAME                  = 'COM9';       % Check which port is being used on your controller
                                            % ex) Windows: 'COM1'   Linux: '/dev/ttyUSB0' Mac: '/dev/tty.usbserial-*'
% Link lengths in cm
LINK_LENGTH_1 = 8;
LINK_LENGTH_2 = 6;
                                            
TORQUE_ENABLE               = 1;            % Value for enabling the torque
TORQUE_DISABLE              = 0;            % Value for disabling the torque
POSITION_MODE               = 3;            % Position control mode
TIME_BASED_MODE             = 4;            % Time based drive mode
TIME_BASED_REVERSED_MODE    = 5;            % Time based + reversed drive mode
DXL_MINIMUM_POSITION_VALUE  = -150000;      % Dynamixel will rotate between this value
DXL_MAXIMUM_POSITION_VALUE  = 150000;       % and this value (note that the Dynamixel would not move when the position value is out of movable range. Check e-manual about the range of the Dynamixel you use.)
DXL_MOVING_STATUS_THRESHOLD = 20;           % Dynamixel moving status threshold

% Values to send to the gripper
GRIPPER_OPEN_POS = 1700;
GRIPPER_CLOSED_POS = 2647;
GRIPPER_CUBE_HOLD_POS = 2600;
GRIPPER_PEN_CUBE_HOLD_POS = 2350;%2250;

% get Z locations from the config folder
[GRIPPER_Z_PICK_UP_CUBE_FACING_DOWN, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_DOWN,...
GRIPPER_Z_PICK_UP_CUBE_FACING_STRAIGHT, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_STRAIGHT,...
GRIPPER_PICK_DOWN_OFFSET]...
= getTask2GripperZValues();

ESC_CHARACTER               = 'e';          % Key for escaping loop

COMM_SUCCESS                = 0;            % Communication Success result value
COMM_TX_FAIL                = -1001;        % Communication Tx Failed

%% ------------------ %%

% Initialize PortHandler Structs
% Set the port path
% Get methods and members of PortHandlerLinux or PortHandlerWindows
port_num = portHandler(DEVICENAME);

% Initialize PacketHandler Structs
packetHandler();

index = 1;
dxl_comm_result = COMM_TX_FAIL;           % Communication result
dxl_goal_position = [DXL_MINIMUM_POSITION_VALUE DXL_MAXIMUM_POSITION_VALUE];         % Goal position

dxl_error = 0;                              % Dynamixel error
dxl_present_position = 0;                   % Present position

% Open port
if (openPort(port_num))
    fprintf('Port Open\n');
else
    unloadlibrary(lib_name);
    fprintf('Failed to open the port\n');
    input('Press any key to terminate...\n');
    return;
end

% Set port baudrate
if (setBaudRate(port_num, BAUDRATE))
    fprintf('Baudrate Set\n');
else
    unloadlibrary(lib_name);
    fprintf('Failed to change the baudrate!\n');
    input('Press any key to terminate...\n');
    return;
end

% Put actuator into Position Control Mode
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_PRO_OPERATING_MODE, POSITION_MODE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_PRO_OPERATING_MODE, POSITION_MODE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID3, ADDR_PRO_OPERATING_MODE, POSITION_MODE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID4, ADDR_PRO_OPERATING_MODE, POSITION_MODE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID5, ADDR_PRO_OPERATING_MODE, POSITION_MODE);

% Put actuator into Time-Based Drive Mode
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_PRO_DRIVE_MODE, TIME_BASED_MODE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_PRO_DRIVE_MODE, TIME_BASED_MODE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID3, ADDR_PRO_DRIVE_MODE, TIME_BASED_MODE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID4, ADDR_PRO_DRIVE_MODE, TIME_BASED_MODE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID5, ADDR_PRO_DRIVE_MODE, TIME_BASED_MODE);

% Set PID gains
% pGain = 600;
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_P_GAIN, pGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_P_GAIN, pGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID3, ADDR_P_GAIN, pGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID4, ADDR_P_GAIN, pGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID5, ADDR_P_GAIN, pGain);
% 
% iGain = 200;
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_I_GAIN, iGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_I_GAIN, iGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID3, ADDR_I_GAIN, iGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID4, ADDR_I_GAIN, iGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID5, ADDR_I_GAIN, iGain);
% 
% dGain = 0;
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_D_GAIN, dGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_D_GAIN, dGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID3, ADDR_D_GAIN, dGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID4, ADDR_D_GAIN, dGain);
% write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID5, ADDR_D_GAIN, dGain);

% Disable Dynamixel Torque (Should either enable or disable torque)
disableDynamixelTorque(DXL_ID1, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID2, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID3, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID4, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID5, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)

% Enable Dynamixel Torque (Should either enable or disable torque)
enableDynamixelTorque(DXL_ID1, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE, COMM_SUCCESS)
enableDynamixelTorque(DXL_ID2, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE, COMM_SUCCESS)
enableDynamixelTorque(DXL_ID3, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE, COMM_SUCCESS)
enableDynamixelTorque(DXL_ID4, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE, COMM_SUCCESS)
enableDynamixelTorque(DXL_ID5, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE, COMM_SUCCESS)

while (false)
    pos1 = getPosition(DXL_ID1, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
    pos2 = getPosition(DXL_ID2, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
    pos3 = getPosition(DXL_ID3, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
    pos4 = getPosition(DXL_ID4, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
    joint1_angle = encoderToRadians(pos1);
    joint2_angle = encoderToRadians(pos2);
    joint3_angle = encoderToRadians(pos3);
    joint4_angle = encoderToRadians(pos4);
    [tool_x, tool_y, tool_z, tool_theta] = OpenManipFK(...
    joint1_angle, joint2_angle, joint3_angle, joint4_angle);
    fprintf("stage: %f, tool_x: %f, tool_y: %f, tool_z: %f, tool_theta: %f\n",...
        i, tool_x, tool_y, tool_z, tool_theta); 
%     fprintf("---------------------------------------------------------------");
end

% Define start pose
startPose.x = 0.0;
startPose.y = 0.274;
startPose.z = 0.2048;
startPose.theta = 0.0; 
% startPose.gripper = GRIPPER_PEN_CUBE_HOLD_POS;
startPose.gripper = GRIPPER_OPEN_POS;
startPose.groupToPrevious = false;
startPose.timeForTrajectory = 0.0;
startPose.name = "Start pose";

% Define waypoints (must include startPose!)

% Official task 2 cube locations
[startLocations, endLocations] = getTask2CubeLocations();

% Task specific waypoints (only one of these should be uncommented)

% waypoints = load(".\config\waypoints_task2a_video.mat").waypoints;
% waypoints = load(".\config\waypoints_task2b_video.mat").waypoints;
% waypoints = load(".\config\waypoints_task2c_video.mat").waypoints;

% waypoints = waypointsForTask2a(...
%     startLocations, endLocations,...
%     GRIPPER_Z_PICK_UP_CUBE_FACING_DOWN, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_DOWN,...
%     GRIPPER_Z_PICK_UP_CUBE_FACING_STRAIGHT, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_STRAIGHT,...
%     GRIPPER_OPEN_POS, GRIPPER_CUBE_HOLD_POS...
% );

% waypoints = waypointsForTask2b(...
%     startLocations,...
%     GRIPPER_Z_PICK_UP_CUBE_FACING_DOWN, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_DOWN,...
%     GRIPPER_Z_PICK_UP_CUBE_FACING_STRAIGHT, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_STRAIGHT,...
%     GRIPPER_PICK_DOWN_OFFSET,...
%     GRIPPER_OPEN_POS, GRIPPER_CUBE_HOLD_POS...
% );

% waypoints = waypointsForTask2c(...
%     startLocations, endLocations,...
%     GRIPPER_Z_PICK_UP_CUBE_FACING_DOWN, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_DOWN,...
%     GRIPPER_Z_PICK_UP_CUBE_FACING_STRAIGHT, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_STRAIGHT,...
%     GRIPPER_PICK_DOWN_OFFSET,...
%     GRIPPER_OPEN_POS, GRIPPER_CUBE_HOLD_POS...
% );

% waypoints = getTask3VideoWaypoints(...
%     GRIPPER_OPEN_POS, GRIPPER_PEN_CUBE_HOLD_POS...
% );

waypoints = getTask4Waypoints(...
    GRIPPER_OPEN_POS, GRIPPER_PEN_CUBE_HOLD_POS...
);


% Waypoints must include the gripper's starting pose
waypoints = [startPose, waypoints];

% Modify all timeForTrajectory values by a constant (allows tuning while
% keeping relative times)
additionalTimePerTrajectory = 0.0;
temp = num2cell([waypoints.timeForTrajectory] + additionalTimePerTrajectory);
[waypoints.timeForTrajectory] = temp{:};

% Convert waypoints into stages (sequences of set points) using trajectory planning
samplePeriod = 0.05; % In seconds
stages = taskSpaceStagesFromWaypoints(...
    waypoints, samplePeriod...
);

% Calibration
% Robot 01
% joint1_offset = 0.0;
% joint2_offset = -0.06;
% joint3_offset = -0.05;
% joint4_offset = -0.03;
% Robot 07
joint1_offset = 0.0;
joint2_offset = 0.01;
joint3_offset = -0.03;
joint4_offset = 0.0;
% Robot 03
% joint1_offset = 0.0;
% joint2_offset = -0.01;
% joint3_offset = -0.02;
% joint4_offset = 0.0;
% Robot 02
% joint1_offset = 0.0;
% joint2_offset = -0.015;
% joint3_offset = -0.06;
% joint4_offset = 0.0;

% Move to start pose
fprintf("Moving to start pose\n");

% Get joint angles required to reach start position
startIKSols = OpenManipIK(startPose.x, startPose.y, startPose.z, startPose.theta);
startIKSol = getFirstValidIKSol(startIKSols);

% Convert joint angles into encoder values
pos1 = radiansToEncoder(startIKSol.joint1_angle+joint1_offset);
pos2 = radiansToEncoder(startIKSol.joint2_angle+joint2_offset);
pos3 = radiansToEncoder(startIKSol.joint3_angle+joint3_offset);
pos4 = radiansToEncoder(startIKSol.joint4_angle+joint4_offset);

% Move to start position without specific trajectory
vel = 1000; % Range [0,32767] where units are in milliseconds for time-based profile
writeVelocity(DXL_ID1, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);
writeVelocity(DXL_ID2, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);
writeVelocity(DXL_ID3, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);
writeVelocity(DXL_ID4, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);

acc = 300; % Range [0,32767] where units are in milliseconds for time-based profile
writeAcceleration(DXL_ID1, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);
writeAcceleration(DXL_ID2, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);
writeAcceleration(DXL_ID3, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);
writeAcceleration(DXL_ID4, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);

writePosition(DXL_ID1, pos1, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);
writePosition(DXL_ID2, pos2, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);
writePosition(DXL_ID3, pos3, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);
writePosition(DXL_ID4, pos4, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);

% Gripper configuration
writePosition(DXL_ID5, startPose.gripper, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);

disp("Press any keay to start the main task sequence!");
pause;

% Set velocity and acceleration
% In time-based mode, velocity represents the total time in milliseconds
% for the trajectory and acceleration represents the acceleration time in milliseconds
vel = samplePeriod * 1000 * 4; % Range [0,32767] where units are in milliseconds for time-based profile
writeVelocity(DXL_ID1, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);
writeVelocity(DXL_ID2, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);
writeVelocity(DXL_ID3, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);
writeVelocity(DXL_ID4, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);

% acc should be (samplePeriod * 250 * 4) by default and (samplePeriod * 250 *
% 2) for drawing
acc = samplePeriod * 250 * 4; % Range [0,32767] where units are in milliseconds for time-based profile
writeAcceleration(DXL_ID1, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);
writeAcceleration(DXL_ID2, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);
writeAcceleration(DXL_ID3, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);
writeAcceleration(DXL_ID4, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);

% Main stage sequence
currentGripper = startPose.gripper;
for i = 1 : length(stages)
    jointAngles = stages(i).setPointJointAngles;
    
    % Send set points to robot
    for j = 1 : length(jointAngles)
        % Optionally print tool pose
%         pos1 = getPosition(DXL_ID1, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
%         pos2 = getPosition(DXL_ID2, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
%         pos3 = getPosition(DXL_ID3, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
%         pos4 = getPosition(DXL_ID4, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
%         joint1_angle = encoderToRadians(pos1);
%         joint2_angle = encoderToRadians(pos2);
%         joint3_angle = encoderToRadians(pos3);
%         joint4_angle = encoderToRadians(pos4);
%         [tool_x, tool_y, tool_z, tool_theta] = OpenManipFK(...
%         joint1_angle, joint2_angle, joint3_angle, joint4_angle);
%         fprintf("stage: %f, tool_x: %f, tool_y: %f, tool_z: %f, tool_theta: %f\n",...
%             i, tool_x, tool_y, tool_z, tool_theta);
        
        pos1 = radiansToEncoder(jointAngles(j).joint1_angle+joint1_offset);
        pos2 = radiansToEncoder(jointAngles(j).joint2_angle+joint2_offset);
        pos3 = radiansToEncoder(jointAngles(j).joint3_angle+joint3_offset);
        pos4 = radiansToEncoder(jointAngles(j).joint4_angle+joint4_offset);

        writePosition(DXL_ID1, pos1, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);
        writePosition(DXL_ID2, pos2, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);
        writePosition(DXL_ID3, pos3, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);
        writePosition(DXL_ID4, pos4, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);

        pause(samplePeriod/2); % Try to send next set point at max velocity
    end
    
    % Pause until the last waypoint of this stage is reached (all servos
    % stopped moving)
    while read1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_PRO_MOVING) ||...
            read1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_PRO_MOVING) ||...
            read1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID3, ADDR_PRO_MOVING) ||...
            read1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID4, ADDR_PRO_MOVING)
        % Do nothing
    end

    % Gripper configuration
    writePosition(DXL_ID5, stages(i).gripperOpening, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);

    while read1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID5, ADDR_PRO_MOVING)
        % Do nothing
    end
end

% Move to finish pose
fprintf("Moving to finish pose\n");

% Convert joint angles into encoder values
pos1 = radiansToEncoder(-0.0445); % TODO: Determine correct joint angles for this
pos2 = radiansToEncoder(-2.0417);
pos3 = radiansToEncoder(1.5417);
pos4 = radiansToEncoder(-pi/2);

% Move to end position without specific trajectory
vel = 1000; % Range [0,32767] where units are in milliseconds for time-based profile
writeVelocity(DXL_ID1, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);
writeVelocity(DXL_ID2, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);
writeVelocity(DXL_ID3, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);
writeVelocity(DXL_ID4, vel, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);

acc = 300; % Range [0,32767] where units are in milliseconds for time-based profile
writeAcceleration(DXL_ID1, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);
writeAcceleration(DXL_ID2, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);
writeAcceleration(DXL_ID3, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);
writeAcceleration(DXL_ID4, acc, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);

writePosition(DXL_ID1, pos1, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);
writePosition(DXL_ID2, pos2, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);
writePosition(DXL_ID3, pos3, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);
writePosition(DXL_ID4, pos4, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);
pause(2);

% Disable Dynamixel Torque
disableDynamixelTorque(DXL_ID1, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID2, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID3, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID4, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID5, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)

% Close port
closePort(port_num);
fprintf('Port Closed \n');

% Unload Library
unloadlibrary(lib_name);
