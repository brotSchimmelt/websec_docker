# Websec Docker Environment
This repo contains the Docker environment for the [websec project](https://github.com/brotSchimmelt/websec).


## Install Docker


### Post Installation (Linux Only)
1. Create a Docker group
```
$ sudo groupadd docker
```

2. Add the current user to the newly created group
```
$ sudo usermod -aG docker $USER
```

3. Apply the group changes (or log out and back in again)
```
$ newgrp docker 
```

4. Test the Docker installation
```
$ docker run hello-world
```

5. Configure Docker to start at boot
```
sudo systemctl enable docker
```

6. [Trouble shooting](https://docs.docker.com/engine/install/linux-postinstall/)




## Check Docker Version

```
$ docker version
$ docker-compose -v
```

