function writeAcceleration(dxl_id, acceleration, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_PROFILE_ACCELERATION)
% WRITEACCELERATION Send the acceleration command to the Dynamixel specified with
% dxl_id.
% Prints any errors that occur.

    write4ByteTxRx(port_num, PROTOCOL_VERSION, dxl_id, ADDR_PRO_PROFILE_ACCELERATION, acceleration);
    
    % Check for errors
    dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
    dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
    if dxl_comm_result ~= COMM_SUCCESS
        fprintf('Write velocity error: %03d, %s\n', dxl_id, getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
    elseif dxl_error ~= 0
        fprintf('Write velocity error: %03d, %s\n', dxl_id, getRxPacketError(PROTOCOL_VERSION, dxl_error));
    end
end
