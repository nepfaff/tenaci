clc;
clear;

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

%% ---- Other Settings ---- %%

% Protocol version
PROTOCOL_VERSION            = 2.0;          % See which protocol version is used in the Dynamixel

% Default setting
DXL_ID1                      = 11;            % Dynamixel ID: 1
DXL_ID2                      = 14;  % TODO: Add correct IDs
DXL_ID3                      = 14;
DXL_ID4                      = 14;
DXL_ID5                      = 14;
BAUDRATE                    = 1000000;
DEVICENAME                  = 'COM4';       % Check which port is being used on your controller
                                            % ex) Windows: 'COM1'   Linux: '/dev/ttyUSB0' Mac: '/dev/tty.usbserial-*'
% Link lengths in cm
LINK_LENGTH_1 = 8;
LINK_LENGTH_2 = 6;
                                            
TORQUE_ENABLE               = 1;            % Value for enabling the torque
TORQUE_DISABLE              = 0;            % Value for disabling the torque
POSITION_MODE               = 3;            % Position control mode
TIME_BASED_MODE             = 8;            % Time based drive mode
TIME_BASED_REVERSED_MODE    = 9;            % Time based + reversed drive mode
DXL_MINIMUM_POSITION_VALUE  = -150000;      % Dynamixel will rotate between this value
DXL_MAXIMUM_POSITION_VALUE  = 150000;       % and this value (note that the Dynamixel would not move when the position value is out of movable range. Check e-manual about the range of the Dynamixel you use.)
DXL_MOVING_STATUS_THRESHOLD = 20;           % Dynamixel moving status threshold

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

% -----SET MOTION LIMITS -----------%
% TODO: Add updated limits for all servos (should correspond to motion
% limits defined elsewhere)
ADDR_MAX_POS = 48;
ADDR_MIN_POS = 52;
MAX_POS = 3400;
MIN_POS = 600;

% Set max position limit
write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_MAX_POS, MAX_POS);
write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_MAX_POS, MAX_POS);

% Set min position limit
write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_MIN_POS, MIN_POS);
write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_MIN_POS, MIN_POS);
% ----------------------------------%

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
% Gripper is not in time-based mode!

% Disable Dynamixel Torque (Should either enable or disable torque)
disableDynamixelTorque(DXL_ID1, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID2, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID3, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID4, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID5, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)

% Enable Dynamixel Torque (Should either enable or disable torque)
disableDynamixelTorque(DXL_ID1, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID2, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID3, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID4, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE, COMM_SUCCESS)
disableDynamixelTorque(DXL_ID5, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE, COMM_SUCCESS)

% Set up live position plot
tool_x_lst = [];
tool_y_lst = [];
tool_z_lst = [];
figure;
hold on;
title("Tool position");

j = 0;
while (j<500)
    j = j+1;
    
    % Read all encoder positions
    pos1 = getPosition(DXL_ID1, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
    pos2 = getPosition(DXL_ID2, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
    pos3 = getPosition(DXL_ID3, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
    pos4 = getPosition(DXL_ID4, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
    pos5 = getPosition(DXL_ID5, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
    fprintf('[ID:%03d] Position: %03d\n', DXL_ID1, pos1);
    fprintf('[ID:%03d] Position: %03d\n', DXL_ID2, pos2);
    fprintf('[ID:%03d] Position: %03d\n', DXL_ID3, pos3);
    fprintf('[ID:%03d] Position: %03d\n', DXL_ID4, pos4);
    fprintf('[ID:%03d] Position: %03d\n', DXL_ID5, pos5);
    
    % Convert all encoder positions into radians
    joint1_angle = encoderToRadians(pos1);
    joint2_angle = encoderToRadians(pos2);
    joint3_angle = encoderToRadians(pos3);
    joint4_angle = encoderToRadians(pos4);
    gripper_angle = encoderToRadians(pos5);
    fprintf('[ID:%03d] Position (rad): %03d\n', DXL_ID1, joint1_angle);
    fprintf('[ID:%03d] Position (rad): %03d\n', DXL_ID2, joint2_angle);
    fprintf('[ID:%03d] Position (rad): %03d\n', DXL_ID3, joint3_angle);
    fprintf('[ID:%03d] Position (rad): %03d\n', DXL_ID4, joint4_angle);
    fprintf('[ID:%03d] Position (rad): %03d\n', DXL_ID5, gripper_angle);
    
    % Get tool position
    [tool_x, tool_y, tool_z] = OpenManipFK(joint1_angle, joint2_angle, joint3_angle, joint4_angle);
    
    % Plot tool position
    tool_x_lst = [tool_x_lst, tool_x];
    tool_y_lst = [tool_y_lst, tool_y];
    tool_z_lst = [tool_z_lst, tool_z];
    plot3(tool_x_lst, tool_y_lst, tool_z_lst, "-r");
    drawnow;
    
%     writePosition(DXL_ID1, 600, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION);
%     writeVelocity(DXL_ID1, 600, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_VELOCITY);
%     writeAcceleration(DXL_ID1, 600, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION);
    
end

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
