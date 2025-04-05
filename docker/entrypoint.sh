#!/bin/bash
Red='\033[0;31m' 
Green='\033[0;32m' 
Yellow='\033[0;33m'

#the following script used to make an operation if there's new change detected and pulled

LOCAL_COMMIT_ID=$(git rev-parse HEAD)
# fetch in the latest change in the remote repo from main branch
git fetch origin main
# Store the remote commit ID
REMOTE_COMMIT_ID=$(git rev-parse @{u})

# Compare the hashes to see if anything changed
if [ "$LOCAL_COMMIT_ID" != "$REMOTE_COMMIT_ID" ]; then
    echo -e "${Yellow}Changes detected and pulled from remote repository!"
    git pull https://github.com/Shell-Urban-Concept-Autonomous/shell_urban_simulator.git
    #do some operation after pulling
    colcon build --symlink-install
    #source the workspace
    source /opt/ros/humble/setup.bash
    source install/setup.bash
    #run the docker container
    ./home/ubuntu/CoppeliaSim_Edu_V4_9_0_rev6_Ubuntu22_04/coppeliaSim.sh
else
    echo -e "${Green}Repository is already up to date. No changes pulled."
    source /opt/ros/humble/setup.bash
    source install/setup.bash
    #run the docker container
    /home/ubuntu/CoppeliaSim_Edu_V4_9_0_rev6_Ubuntu22_04/coppeliaSim /home/ubuntu/shell_urban_simulator/src/shell_car_model/coppeliasim_scene/simulator.ttt & ros2 launch shell_car_model launch.py 

fi
/bin/bash