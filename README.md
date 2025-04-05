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

```bash
cd docker
docker compose up
```

# Topics
| **Topic Name**       | **Description**                     | **Message Type**               | **Direction**    | **Role**                              |
|-----------------------|-------------------------------------|---------------------------------|------------------|---------------------------------------|
| `/cmd`               | Publishes car linear velocity in km/h           | `std_msgs/msg/Float32`      | coppeliasim → ROS     | publish linear velocity commands          |
| `/steering_wheel_cmd`| Publishes steering wheel command in degree   | `std_msgs/msg/Float32`       | coppeliasim → ROS     | publish steering wheel commands        |
| `/odom`              | publish global postion of the cog of the car           | `geometry_msgs/msg/Pose`    | coppeliasim → ROS     | Provide global postion of the car      |


