---
summary: "In this text we're going to be talking about Docker architecture. And Docker is the container implementationthat is supported by Red Hat and is used by OpenShift."
tags:
    - wangyijie
    - container
categories:
    - Development
    - Opetration
---
In this text we're going to be talking about Docker architecture.
And Docker is the container implementation
that is supported by Red Hat and is used by OpenShift.
So Docker uses a client-server architecture,
and the client will run our command-line tool,
which is known as docker,
so all of our requests that we're going to make are running on the client server.
And then we'll also have another server,
which is running the Docker service,
and that has a daemon on it that's responsible for all of the building
and running and downloading images.
And we'll get into all of that in a little bit.
But essentially, we have these two separate servers
and they can actually be running on the same host.
In the classroom, in the demonstrations I'll show you in later videos,
ours is actually running on the same host
so we have a client and server running together,
which is not necessarily the best way to do it if you're production
but for the sake of development that's an OK architecture.
So I'll talk a little bit about some of the core elements of Docker
and some of the resources that they use.
So we are in about containers, right?
Containers are segregated user space environments for running our applications.
These are the primary objects in Docker and almost all of
the commands will somehow reference containers in some capacity,
that's like our working item.
We also have images. And images are templates for containers,
so you'll have -- they're sort of like a definition for containers.
So we can have one template and from that we can create,
you know, five, ten, a thousand containers.
All those are based on that template.
So this is a really powerful tool that we can use to recreate containers
and we can version control images and we can add all of the libraries
and configuration files we need to run our application.
So where do we get the images from?
Well, the images are stored in different registries,
and registries can be something that you have that's private
and local on your own machine, you can use public registries,
DockerHub is one of the most popular ones.
Red Hat also has their own image registry
and these are already preconfigured and you can pull from them
and you can also go to DockerHub as a web site
and you can pull down the images from there.
So as I mentioned before, up here we have our client,
and we have our host, and we have our registry.
So the client is where you're going to do things like run all these Docker commands,
and we'll get a little bit more into the commands when we start doing demonstration
but for now let's stick with docket pull.
This is going to pull an image for us locally
and we have Docker run.
Now on the host, we have our Docker daemon,
and the daemon is going to be responding to any of the commands
that are run on the client.
So anything like docker run,
that's going to go to the daemon, docker pull, that's going to go here.
So let's say we do a docker pull, and we want to pull down an image for MySQL,
so we want to create our own database container.
So the first thing we'll run is docker pull mysql.
So what happens there is you run docker pull,
it goes to the docker daemon and it says OK, I need an image.
And the first thing it's going to do is it's going to take a look
at our local image repository,
so on this host it'll say, do I have a MySQL image.
And if it doesn't it'll say OK, let's send this off,
I want to go look at one of these public registries.
Let's say that this is DockerHub,
and in this registry we'll find our little MySQL image,
which as I mentioned before, that's just a simple template
that includes all the things we need in order to run a MySQL environment.
So it'll take that image and it'll bring it back
and drop it right into our image repository
so that's available for any future containers that we may want to run.
So now we have our MySQL image.
OK, so let's talk about what happens when we run docker run.
So if you do docker run, it's going to go to the daemon and it's going to say OK,
I want to run a MySQL container.
It's then going to go look at our image and say
there is a MySQL image, and let's create a container based on that image,
so it's going to run our own MySQL container.
And we could run this five, ten, a thousand times,
and we can just keep creating new containers
over and over again based on that one specific image.
So as I mentioned before, containers aren't necessarily a new concept.
However, Docker was one of the first implementations to make this
really user-friendly and easy, and it does so by using
basic features that are already available in the Linux kernel.
So first, it uses namespaces, it uses control groups, and it uses SELinux.
And so namespaces are generally used to isolate processes,
to protect system resources and what Docker does is it
creates a namespace for each individual containers,
so you have container A over here, you have container B over here,
and the namespace will protect these processes
so they're not going to interact with each other unnecessarily.
We have control groups and control groups create partition
to the set of processes and that is essentially protecting the host machine
from the container consuming too many resources.
So if you have the host down here at the bottom,
we have the containers that are going to be isolated
so that they are not borrowing too many resources
that could potentially cause a failure to the host.
We have SELinux and SELinux is there to protect access between
both the containers and the containers to the host.
So just to refresh, namespaces are there to protect
the containers interactions between each other,
cgroups are to protect the containers interaction to the host,
and SELinux is there to protect access between
both the containers and the containers to the host.
