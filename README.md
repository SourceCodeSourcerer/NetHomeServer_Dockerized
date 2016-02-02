# NetHomeServer_Dockerized
A docker configuration that runs a [NetHomeServer](http://opennethome.org) in a linux debian container.
As the tellstick drivers are not supported (not yet) in this configuration, the Tellstick homeitem is not supported.
The demo.xml file has removed this homeitem.

## Requireirements
Docker installed locally.

# Start your docker-machine
Take note of the local ip-address, for example: 192.168.99.100

## Build the container
Checkout project NetHomeServer_Dockerized and in the directory enter the following:

```
docker build -t sourcecodesourcerer/opennethome .
```
This might not work... if you get an error warning about not installing udev, something like this:
```
Errors were encountered while processing: 
 udev
E: Sub-process /usr/bin/dpkg returned an error code (1)
The command '/bin/sh -c apt-get update && apt-get install -y unzip apt-utils procps net-tools autofs udev nano && apt-get clean && rm -rf /var/lib/apt/lists/*' returned a non-zero code: 100
```
If so, then, try re-run the command.

You should at least see a lot of messages while setting up the image among others are configuring the needed components of the machine.
Finally, the latest NetHomeServer nightly build will be downloaded and installed to the machine (the image).

## Run your NetHomeServer container shell
```
docker run -P -t -i sourcecodesourcerer/opennethome /bin/bash
```
* The -P parameter exposes the internal port, 8020, to your local machine.
* The -t parameter and -i parameters let the console be interactive while you run the bash command
* The /bin/bash parameter will start the container's shell so that you can have a chance of looking arount the machine.

You should see something similar to this:
```
nethome@6d5b045f5086:/var/run/nethome$ 
```
### Start the NetHomeServer:
Enter the following:
```
nethome@6d5b045f5086:/var/run/nethome$ java -verbose -Djava.library.path=. -jar /opt/nethome/lib/home.jar -l/var/log/nethome $@ /etc/opt/nethome/config.xml
```
### Access NetHomeServer from your local machine
As we started NetHomeServer from the commandline, you will have to start another docker shell so the following command can be run:
```
$> docker ps
CONTAINER ID        IMAGE                             COMMAND                  CREATED              STATUS              PORTS                     NAMES
6d5b045f5086        sourcecodesourcerer/opennethome   "/bin/tini -v -- /usr"   About a minute ago   Up About a minute   0.0.0.0:32768->8020/tcp   condescending_hopper
```
The PORTS column lists the local port, in this example 32768. So from your local browser, enter:
```
http://192.168.99.100:32768/home
```
And there you have it, your own local dockerized NetHomeServer running.

:+1: But we can do better, let's run the container by itself.

# Run your NetHomeServer container by itself
```
docker run -P -d sourcecodesourcerer/opennethome
```
This time, the last parameter has been omitted which should start and run the container. You'll see something similar to this:
```
775a123fe585ee4e32a11d3f6a96b55601794c2036f4c4415bac27fc099d9823
```
Then, run:
```
docker ps
CONTAINER ID        IMAGE                             COMMAND                  CREATED             STATUS              PORTS                     NAMES
775a123fe585        sourcecodesourcerer/opennethome   "/bin/tini -v -- /usr"   2 minutes ago       Up 2 minutes        0.0.0.0:32770->8020/tcp   tender_dubinsky
```
And notice the port number you need to access the NetHomeServer, in this example it has changed to 32770. So:
```
http://192.168.99.100:32770/home
```
Good luck!
