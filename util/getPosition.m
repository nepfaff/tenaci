function pos = getPosition(dxl_id, port_num, PROTOCOL_VERSION, ADDR_PRO_PRESENT_POSITION, COMM_SUCCESS)
%GETPOSITION Returns encoder position as an int32.
% If an error occurs, -1 is returned and the error is printed.

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
