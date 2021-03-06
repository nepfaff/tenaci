function disableDynamixelTorque(dxl_id, port_num, PROTOCOL_VERSION, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE, COMM_SUCCESS)
%DISABLEDYNAMIXELTORQUE Disable Dynamixel torque.

    write1ByteTxRx(port_num, PROTOCOL_VERSION, dxl_id, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
    dxl_comm_result = getLastTxRxResult(port_num, PROTOCOL_VERSION);
    dxl_error = getLastRxPacketError(port_num, PROTOCOL_VERSION);
    if dxl_comm_result ~= COMM_SUCCESS
        fprintf('Disable torque error: %03d, %s\n', dxl_id, getTxRxResult(PROTOCOL_VERSION, dxl_comm_result));
    elseif dxl_error ~= 0
        fprintf('Disable torque error: %03d, %s\n', dxl_id, getRxPacketError(PROTOCOL_VERSION, dxl_error));
    end
end
