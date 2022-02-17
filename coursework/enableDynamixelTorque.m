function enableDynamixelTorque(dxl_id, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE, COMM_SUCCESS)
%DISABLEDYNAMIXELTORQUE Enable Dynamixel torque.

    write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID1, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
    dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
    dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
    if dxl_comm_result ~= COMM_SUCCESS
        fprintf('Enable torque error: %03d, %s\n', dxl_id, getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
    elseif dxl_error ~= 0
        fprintf('Enable torque error: %03d, %s\n', dxl_id, getRxPacketError(PROTOCOL_VERSION, dxl_error));
    end
end
