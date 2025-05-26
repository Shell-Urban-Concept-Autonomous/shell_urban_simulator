<p align="center">
  <img width=300 src="https://github.com/user-attachments/assets/711ffbca-01dc-4ad6-af79-e4d849f745fb" />
   <img width=150 src="https://github.com/ebrahimabdelghfar/EVER_Simulator/assets/81301684/701fb094-edd0-4d97-a3be-eca381d8a3c2" />
</p>


># Introduction
This is a simulator developed for Autotronics Research Teams to test their autononmous stack on it
># Specs
- Open GUI via nvidia gpu
- Installed ros2 humble full desktop
- Works only in Ubuntu distro
># Dependencies
## Install docker
```bash
sudo apt update && sudo apt upgrade -y

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io

docker --version #to verfiy that docker is installed
``` 
## Post-Installation Steps
**Step 1**: Start and enable the Docker service
```bash
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```
After that please restart your device

>## Install nvidia docker tool-kit

**Step 1:**
```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

**Step 2:**
```bash
sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

**Step 3**
```bash
sudo apt-get update
```

***Step 4**
```bash
sudo apt-get install -y nvidia-container-toolkit
```
**Step 5**
```bash
sudo nvidia-ctk runtime configure --runtime=docker
```

**Step 6**
```bash
sudo systemctl restart docker
```

**Step 7**
```bash
nvidia-ctk runtime configure --runtime=docker --config=$HOME/.config/docker/daemon.json
```

**Step 8**
```bash
systemctl --user restart docker
```


**Step 9**
```bash
sudo nvidia-ctk config --set nvidia-container-cli.no-cgroups --in-place
```

># How To Work
1. install cyclone dds to have intercommunication without any problem
    ```bash
    sudo apt install ros-${ROS_DISTRO}-rmw-cyclonedds-cpp
    echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> ~/.bashrc
    source .bashrc
    ```
2. run the docker container
```bash
cd docker
./run_simulator.sh
```

# Topics

## Vehicle Control Topics
| **Topic Name**       | **Description**                                   | **Message Type**               | **Direction**    | **Rate (Hz)** | **Role**                              |
|-----------------------|---------------------------------------------------|--------------------------------|------------------|---------------|---------------------------------------|
| `/cmd_vel`           | Vehicle velocity and steering commands            | `geometry_msgs/msg/Twist`      | ROS → Gazebo     | -             | Control vehicle movement and steering |

## Sensor Topics
| **Topic Name**                | **Description**                        | **Message Type**               | **Direction**    | **Rate (Hz)** | **Role**                              |
|-------------------------------|----------------------------------------|--------------------------------|------------------|---------------|---------------------------------------|
| `/odom`                      | Vehicle odometry (position & velocity) | `nav_msgs/msg/Odometry`        | Gazebo → ROS     | 30            | Provide vehicle pose and velocity     |
| `/imu`                       | Inertial Measurement Unit data         | `sensor_msgs/msg/Imu`          | Gazebo → ROS     | 400           | Provide acceleration and orientation  |
| `/scan/points`               | LiDAR point cloud data                 | `sensor_msgs/msg/PointCloud2`  | Gazebo → ROS     | 10            | 3D environment perception             |

## Camera Topics (ZED Camera)
| **Topic Name**                | **Description**                        | **Message Type**               | **Direction**    | **Rate (Hz)** | **Role**                              |
|-------------------------------|----------------------------------------|--------------------------------|------------------|---------------|---------------------------------------|
| `camera/rgb/image`           | RGB camera image                       | `sensor_msgs/msg/Image`        | Gazebo → ROS     | 30            | Visual perception                     |
| `camera/depth/image`         | Depth camera image                     | `sensor_msgs/msg/Image`        | Gazebo → ROS     | 30            | Depth perception                      |
| `camera/pointcloud`          | Camera-based point cloud               | `sensor_msgs/msg/PointCloud2`  | Gazebo → ROS     | 30            | 3D visual perception                  |
| `camera/camera_info`         | Camera calibration information         | `sensor_msgs/msg/CameraInfo`   | Gazebo → ROS     | 30            | Camera parameters and calibration    |

## System Topics
| **Topic Name**                | **Description**                        | **Message Type**               | **Direction**    | **Rate (Hz)** | **Role**                              |
|-------------------------------|----------------------------------------|--------------------------------|------------------|---------------|---------------------------------------|
| `/joint_states`              | Vehicle joint positions and velocities | `sensor_msgs/msg/JointState`   | Gazebo → ROS     | 100           | Monitor vehicle joint states          |
| `/tf`                        | Transform tree                         | `tf2_msgs/msg/TFMessage`       | Gazebo → ROS     | 30            | Coordinate frame relationships        |
| `clock`                      | Simulation time                        | `rosgraph_msgs/msg/Clock`      | Gazebo → ROS     | -             | Synchronize simulation time           |

## Hardware Specifications
- **Vehicle Model**: Shell Racing Car with Ackermann steering
- **LiDAR**: Velodyne-style sensor (32 layers, 10,000 samples per scan, 200m range)
- **Camera**: ZED stereo camera (2560x720 resolution, 110° FOV)
- **IMU**: High-frequency inertial measurement unit
- **Wheels**: 4-wheel configuration with front steering and rear-wheel drive


# ScreenShots for inside the simulator

![Screenshot from 2025-05-26 14-32-31](https://github.com/user-attachments/assets/d921d96f-3791-4cd0-a4f2-da0ea6791c79)
![Screenshot from 2025-05-26 14-32-14](https://github.com/user-attachments/assets/8922baa7-994c-4479-b748-e71367361601)
![Screenshot from 2025-05-26 14-12-21](https://github.com/user-attachments/assets/1e725a4c-de1d-4a09-988a-e5392b8547b4)
