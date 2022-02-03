% Read the position of the dynamixel horn with the torque off
% The code executes for a given amount of time then terminates


clc;
clear all;

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

ADDR_PRO_TORQUE_ENABLE       = 64;           % Control table address is different in Dynamixel model
ADDR_PRO_GOAL_POSITION       = 116; 
ADDR_PRO_PRESENT_POSITION    = 132; 
ADDR_PRO_OPERATING_MODE      = 11;

%% ---- Other Settings ---- %%

% Protocol version
PROTOCOL_VERSION            = 2.0;          % See which protocol version is used in the Dynamixel

% Default setting
DXL_ID1                      = 11;            % Dynamixel ID: 1
DXL_ID2                      = 14; 
BAUDRATE                    = 1000000;
DEVICENAME                  = 'COM4';       % Check which port is being used on your controller
                                            % ex) Windows: 'COM1'   Linux: '/dev/ttyUSB0' Mac: '/dev/tty.usbserial-*'
% Link lengths in cm
LINK_LENGTH_1 = 8;
LINK_LENGTH_2 = 6;
                                            
TORQUE_ENABLE               = 1;            % Value for enabling the torque
TORQUE_DISABLE              = 0;            % Value for disabling the torque
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
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_PRO_OPERATING_MODE, 3);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_PRO_OPERATING_MODE, 3);

% Enable Dynamixel Torque
% write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
% write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);

dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);

if dxl_comm_result ~= COMM_SUCCESS
    fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
elseif dxl_error ~= 0
    fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
else
    fprintf('Dynamixel has been successfully connected \n');
end

ENCODE_IN_RAD = 4096 / (2*pi);
ENCODE_IN_DEG = 4096 / 360;

tool_x_lst = [];
tool_y_lst = [];

figure;
hold on;
title("Tenaci");

j = 0;
while (j<500)
    j = j+1;
    
    pos1 = getPosition(DXL_ID1, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
    pos2 = getPosition(DXL_ID2, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS);
    fprintf('[ID:%03d] Position: %03d\n', DXL_ID1, pos1);
    fprintf('[ID:%03d] Position: %03d\n', DXL_ID2, pos2);
    
    theta1 = double(pos1) / ENCODE_IN_RAD + pi;
    theta2 = double(pos2) / ENCODE_IN_RAD + pi;
    fprintf('[ID:%03d] Position (degrees): %03d\n', DXL_ID1, pos1 / ENCODE_IN_DEG);
    fprintf('[ID:%03d] Position (degrees): %03d\n', DXL_ID2, pos2 / ENCODE_IN_DEG);
    
    T_0 = [1 0 0 ; 0 1 0; 0 0 1];
    T_1 = [cos(theta1) -sin(theta1) 0 ; sin(theta1) cos(theta1) 0; 0 0 1];
    T_2 = [1 0 0 ; 0 1 LINK_LENGTH_1; 0 0 1];
    T_3 = [cos(theta2) -sin(theta2) 0 ; sin(theta2) cos(theta2) 0; 0 0 1];
    T_4 = [1 0 0 ; 0 1 LINK_LENGTH_2; 0 0 1];
    
    tool_pose = T_0 * T_1 * T_2 * T_3 * T_4
    tool_x = tool_pose(1,3);
    tool_y = tool_pose(2,3);
    tool_x_lst = [tool_x_lst, tool_x];
    tool_y_lst = [tool_y_lst, tool_y];
    plot(tool_x_lst, tool_y_lst, "-r");
    drawnow
    
%     writePosition(DXL_ID1, 600, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION)
%     writePosition(DXL_ID2, 2000, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION)
    
end

% Disable Dynamixel Torque
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
if dxl_comm_result ~= COMM_SUCCESS
    fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
elseif dxl_error ~= 0
    fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
end
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID2, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
if dxl_comm_result ~= COMM_SUCCESS
    fprintf('%s\n', getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
elseif dxl_error ~= 0
    fprintf('%s\n', getRxPacketError(PROTOCOL_VERSION, dxl_error));
end

% Close port
closePort(port_num);
fprintf('Port Closed \n');

% Unload Library
unloadlibrary(lib_name);

% close all;
% clear all;
plot(tool_x_lst, tool_y_lst);

% Returns encoder position as an int32.
% If an error occurs, -1 is returned and the error is printed.
function pos = getPosition(dxl_id, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS)
    dxl_present_position = read4ByteTxRx(port_num, PROTOCOL_VERSION, dxl_id, ADDR_PRO_PRESENT_POSITION);
    
    % Check for errors
    dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
    dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
    if dxl_comm_result ~= COMM_SUCCESS
        fprintf('Get position error: %03d, %s\n', dxl_id, getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
        pos = -1;
    elseif dxl_error ~= 0
        fprintf('Get position error: %03d, %s\n', dxl_id, getRxPacketError(PROTOCOL_VERSION, dxl_error));
        pos = -1;
    else
       pos = typecast(uint32(dxl_present_position), 'int32'); 
    end
end

% Send the position command to the encoder specified by dxl_id.
% position refers to the encoder value.
% Prints any errors that occur.
function writePosition(dxl_id, position, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION)
    write4ByteTxRx(port_num, PROTOCOL_VERSION, dxl_id, ADDR_PRO_GOAL_POSITION, position);
    
    % Check for errors
    dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
    dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
    if dxl_comm_result ~= COMM_SUCCESS
        fprintf('Write position error: %03d, %s\n', dxl_id, getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
    elseif dxl_error ~= 0
        fprintf('Write position error: %03d, %s\n', dxl_id, getRxPacketError(PROTOCOL_VERSION, dxl_error));
    end
end

function sinWave = computeSinWave()
    step_size = 0.005;
    range = 500;
    translation = 2048;

    x = (0.0:step_size:2*pi);
    sinWave = range * sin(x) + translation;
end

