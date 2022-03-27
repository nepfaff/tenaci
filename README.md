# tenaci
Imperial College London - Robotic Manipulation - Coursework

## Hardware

The system is based on the [OpenMANIPULATOR-X](https://emanual.robotis.com/docs/en/platform/openmanipulator_x/overview/) robot.

## Dependencies

1. Install MATLAB
2. Download the [Dynamixel SDK](https://emanual.robotis.com/docs/en/software/dynamixel/dynamixel_sdk/overview/) for MATLAB and store it somewhere sensible
3. Follow the instructions [here](https://emanual.robotis.com/docs/en/software/dynamixel/dynamixel_sdk/library_setup/matlab_windows/#matlab-windows)
(use the 64bit version of the build output folder)
4. Install the MinGW compiler using the MATLAB Add-Ons button

It is also highly recommended to install the [Dynamixel Wizard](https://emanual.robotis.com/docs/en/software/dynamixel/dynamixel_wizard2/).
This is an excellent debugging tool and makes testing small changes easy.

## Documentation

Please see the `docs` directory for both the coursework (video + demo day) specifications and the report (to be added).
A video of the robot's performance is TBC.

The `main/main.m` script is the entry point. Different tasks can be run by selecting different waypoints.
This can be achieved by commenting out the current waypoint function and using one of the other commented out waypoint functions.

## Note on code quality

Unfortunately, the code quality is very low. This includes incorrect/outdated docstrings.
The main reasons for this are time constraints and differing hardware between lab sessions (config values had to be adjusted for each robot used).
This is especially true for last-minute demo day related changes.

Complete refactoring is highly recommended before extending any of the code for larger projects.

## Note on accompanying Gazebo simulation

An accompanying ROS Noetic package for interacting with the OpenManipulator-X Gazebo simulation can be found
[here](https://github.com/nicholas-p1/open_manipulator_tenaci).

Please note that the initial plan was to maintain up to date versions of the code in both MATLAB (for the robot) and Python (for the simulation).
However, this effort was given up due to time constraints, better than expected MATLAB simulations (see `simulation` directory),
difficulties with obtaining appropriate friction values in Gazebo to enable picking up objects, and increased physical robot availability.
The last point was the most influential as the initial guidance was that we would only be able to use the robots for 6 hours in total, which
highlighted the need for advanced simulation. However, this was changed to unlimited time on the robots due to collective requests by the cohort.

Consequently, the ROS Noetic package is way behind the implemented logic in this repo.
