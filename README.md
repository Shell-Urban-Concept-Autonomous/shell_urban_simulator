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

># How To RUN
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
| **Topic** | **Description** | **Message Type** | **Dir** | **Hz** | **Role** |
|-----------|-----------------|------------------|---------|--------|----------|
| `/cmd_vel` | Velocity & steering commands | `geometry_msgs/Twist` | ROS→GZ | - | Vehicle control |

## Sensor Topics
| **Topic** | **Description** | **Message Type** | **Dir** | **Hz** | **Role** |
|-----------|-----------------|------------------|---------|--------|----------|
| `/odom` | Vehicle odometry | `nav_msgs/Odometry` | GZ→ROS | 30 | Pose & velocity |
| `/imu` | IMU data | `sensor_msgs/Imu` | GZ→ROS | 400 | Acceleration & orientation |
| `/scan/points` | LiDAR point cloud | `sensor_msgs/PointCloud2` | GZ→ROS | 10 | 3D perception |

## Camera Topics (ZED)
| **Topic** | **Description** | **Message Type** | **Dir** | **Hz** | **Role** |
|-----------|-----------------|------------------|---------|--------|----------|
| `camera/rgb/image` | RGB image | `sensor_msgs/Image` | GZ→ROS | 30 | Visual perception |
| `camera/depth/image` | Depth image | `sensor_msgs/Image` | GZ→ROS | 30 | Depth perception |
| `camera/pointcloud` | Camera point cloud | `sensor_msgs/PointCloud2` | GZ→ROS | 30 | 3D visual data |
| `camera/camera_info` | Camera calibration | `sensor_msgs/CameraInfo` | GZ→ROS | 30 | Camera parameters |

## System Topics
| **Topic** | **Description** | **Message Type** | **Dir** | **Hz** | **Role** |
|-----------|-----------------|------------------|---------|--------|----------|
| `/joint_states` | Joint positions & velocities | `sensor_msgs/JointState` | GZ→ROS | 100 | Joint monitoring |
| `/tf` | Transform tree | `tf2_msgs/TFMessage` | GZ→ROS | 30 | Coordinate frames |
| `clock` | Simulation time | `rosgraph_msgs/Clock` | GZ→ROS | - | Time sync |

## Hardware Specifications
- **Vehicle Model**: Shell Racing Car with Ackermann steering
- **LiDAR**: Velodyne-style sensor (32 layers, 10,000 samples per scan, 200m range)
- **Camera**: ZED stereo camera (2560x720 resolution, 110° FOV)
- **IMU**: High-frequency inertial measurement unit
- **Wheels**: 4-wheel configuration with front steering and rear-wheel drive

## Vehicle Specifications

### Physical Dimensions
| **Parameter** | **Value** | **Unit** | **Description** |
|---------------|-----------|----------|-----------------|
| **Wheelbase** | 1.8 | m | Front to rear axle distance |
| **Track Width (F/R)** | 0.816/0.901 | m | Front/rear wheel spacing |
| **Wheel Radius** | 0.6 | m | All wheels radius |
| **Wheel Diameter** | 1.2 | m | All wheels diameter |
| **Overall L×W** | ~2.4×1.0 | m | Estimated dimensions |

### Mass Properties
| **Component** | **Mass (kg)** | **Description** |
|---------------|---------------|-----------------|
| **Total Vehicle** | ~110 | Estimated total mass |
| **Chassis** | 19.425 | Main vehicle chassis |
| **Body** | 11.145 | Vehicle body structure |
| **Drive Motor+Wheel** | 13.706 | Rear-left motorized assembly |
| **Front Wheels (ea.)** | 2.747 | Front wheel mass each |
| **Rear Wheel (passive)** | 2.792 | Rear-right passive wheel |
| **Roof Assembly** | 1.407 | Roof structure |
| **Velodyne LiDAR** | 0.696 | LiDAR sensor unit |
| **ZED Camera** | 0.170 | Stereo camera unit |

### Performance Characteristics
| **Parameter** | **Value** | **Unit** | **Description** |
|---------------|-----------|----------|-----------------|
| **Max Speed** | 4.17 (15.0) | m/s (km/h) | Maximum velocity |
| **Max Acceleration** | 3.0 | m/s² | Max acceleration/deceleration |
| **Steering Limit** | ±20.0° | degrees | Max steering angle |
| **Steering P-Gain** | 10.0 | - | Control proportional gain |

### Drivetrain & Sensors
| **Parameter** | **Value/Type** | **Specifications** |
|---------------|----------------|-------------------|
| **Drive Type** | RWD | Rear-wheel drive (left powered) |
| **Steering** | Ackermann | 2 front steered wheels |
| **LiDAR** | Velodyne-style | 32 layers, 10K samples, 200m |
| **Camera** | ZED Stereo | 2560×720, 110° FOV, 30Hz |
| **IMU** | 6-DOF | 400Hz, base_link mounted |
| **Odometry** | Wheel-based | 30Hz pose estimation |

# ScreenShots for inside the simulator

<p align="center">
<img width=550 src="https://github.com/user-attachments/assets/d921d96f-3791-4cd0-a4f2-da0ea6791c79"/>
<img width=400 src="https://github.com/user-attachments/assets/8922baa7-994c-4479-b748-e71367361601"/>
</p>
