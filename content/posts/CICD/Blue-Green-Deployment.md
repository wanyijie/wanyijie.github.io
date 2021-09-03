Blue-green deployment is a way to safely deploy applications that are serving live traffic by creating two versions of an application (BLUE and GREEN). To deploy a new version of the application, you will drain all traffic, requests, and pending operations from the current version of the application, switch to the new version, and then turn off the old version. Blue-green deployment eliminates application downtime and allows you to quickly roll back to the BLUE version of the application if necessary.
<!--more-->
For an overview of the process, here’s [a great article by Martin Fowler](http://martinfowler.com/bliki/BlueGreenDeployment.html).

In a production environment, you would typically script this process and integrate it into your existing deployment system
