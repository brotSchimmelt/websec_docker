# Websec Docker Environment
**TODO**: Add descriptive description to describe $this.

 

## Install Docker on macOS
Download and install **Docker Desktop** from [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-mac/)

## Install Docker on Windows 10 (Pro required)
Download and install **Docker Desktop** from [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-windows/)

*Hyper-V and Windows Container must be enabled.*

## Install Docker on Linux (Ubuntu)
0. Remove older versions of Docker:
```
$ sudo apt-get remove docker docker-engine docker.io containerd runc
```

1. Setup the Docker repository:
```
$ sudo apt-get update

$ sudo apt-get install apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```

2. Add the Docker GPG key:
```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
**Check the fingerprint** [link](https://docs.docker.com/engine/install/ubuntu/)

```
$ sudo apt-key fingerprint <last 8 digits of the fingerprint>
```

3. Add the stable repository for the used Ubuntu version:
```
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

4. Install Docker Engine:
```
 $ sudo apt-get update
 $ sudo apt-get install docker-ce docker-ce-cli containerd.io
```

5. Verify the Docker installation:
```
$ sudo docker run hello-world
```

[Original Source and Trouble shooting](https://docs.docker.com/engine/install/ubuntu/)

## Post Installation (Linux Only)
1. Create a Docker group:
```
$ sudo groupadd docker
```

2. Add the current user to the newly created group:
```
$ sudo usermod -aG docker $USER
```

3. Apply the group changes (or log out and back in again):
```
$ newgrp docker 
```

4. Test the Docker installation without ```sudo```:
```
$ docker run hello-world
```

5. Configure Docker to start at boot:
```
sudo systemctl enable docker
```

[Original Source and Trouble shooting](https://docs.docker.com/engine/install/linux-postinstall/)

 

## Docker-Compose

**TODO**: Add more content

- **Check docker-compose version**
```
$ docker-compose -v
```
or for a more verbose version:
```
$ docker-compose version
```

## Docker commands

- **Check Docker version**
```
$ docker -v
```
or for a more verbose version:
```
$ docker version

```

- **Resources used by Docker container**
```
$ docker stats --all
```

- **Docker processes**
```
$ docker ps
```

- **Kill all running containers**
```
$ docker kill $(docker ps -q)
```

- **Stop all running containers and remove persistent data**
```
$ docker-compose down -v
```

- **Delete all containers including it volumes**
```
$ docker rm -vf $(docker ps -a -q)
```

- **Delete all images**
```
$ docker rmi -f $(docker images -a -q)
```

- **Delete all images in powershell**
```
$ $images = docker images -a -q
$ foreach ($image in $images) { docker image rm $image -f } 
```

- **Remove all unused containers, volumes, networks and images**
```
$ docker system prune -a -volumes
```
