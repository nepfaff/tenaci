function writePosition(dxl_id, position, port_num, PROTOCOL_VERSION, COMM_SUCCESS, ADDR_PRO_GOAL_POSITION)
% WRITEPOSITION Send the position command to the encoder specified by dxl_id.
% position refers to the encoder value.
% Prints any errors that occur.
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
