function...
    [GRIPPER_Z_PICK_UP_CUBE_FACING_DOWN, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_DOWN,...
    GRIPPER_Z_PICK_UP_CUBE_FACING_STRAIGHT, GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_STRAIGHT,...
    GRIPPER_PICK_DOWN_OFFSET]...
    = getTask2GripperZValues()
%GETTASK2GRIPPERZVALUES
    
    % Cube specific values
    % Cube has sidelength of 2.5cm, cube stand's top edge is 19.8mm from
    % base-plate
    GRIPPER_Z_PICK_UP_CUBE_FACING_DOWN = 0.037;%0.054;
    GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_DOWN = 0.07;%0.08;
    
    GRIPPER_Z_PICK_UP_CUBE_FACING_STRAIGHT = 0.029;%0.04;
    GRIPPER_Z_ABOVE_CUBE_PICK_UP_FACING_STRAIGHT = 0.08;%0.08;
    
    % Gripper can't pick cube in the middle when picking facing down
    % This causes problems when for example picking up a cube facing down
    % and placing it facing straight. The placed cube won't be at the
    % desired destination due to the offset
    GRIPPER_PICK_DOWN_OFFSET = 0.018;
end
