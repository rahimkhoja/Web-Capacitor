# Rahim’s Lazy Semi-High Availability Web Capacitor
### By: Rahim Khoja (rahim@khoja.ca)

## Description

If you want a high availability server that also gets high scores on Google Page Speed Insights, but don’t want to play with code, this is how to do it. This concoction should also be more secure than the standard Web Server. It really works best with websites and web applications that have at least 150 users a day or more. Getting higher scores on Page Speed Insights ensures websites get better Google search rankings. 

## Components:

1.	The Internet with a Public Static IP
2.	Router/Firewall
3.	VM Server (Hypervisor)
4.	HA-Proxy
5.	GlusterFS Server & Client
6.	Apache (& PHP 7.*)
7.	NGINX
8.	NGX PageSpeed Module
9.	Memcached
10.	CertBot
11.	Some Bash Scripts (eg. CertBot SSL Deployment or Backup Scripts)
12.	(Optional) Random Internal Web Servers (eg. Lamp Stacks/Wamp Stacks/IIS/Tomcat) 

## Systems:

1.	(1) The Router/Firewall
This routes TCP for port 80 & 443 from the public interface to the HA-Proxy Server. 

2.	(2) The HA-Proxy Server
This server ultimately acts as the Load Balancer for the NGINX/Apache Servers. It could be replaced with a hardware load balancer or some other type of software load balancer. HA-Proxy is pretty easy and deals with sessions.

3.	(4) NGINX/Apache Servers
These systems host replicated copies of the Web Server data in order to be served in a load balanced manner. They host the web data, SSL certificates, and configurations on a replicated dataset. NGINX is used to provide SSL and website proxy functionality. Apache is used to serve web data. A local replica of the shared data set is also housed on each server via GlusterFS. The NGINX Page Speed module is used to provide website optimizations, and caching to the sites. As the system configurations are hosted on the replicated data sets, all of the load balanced systems have the same configurations, SSL certificates.  

4.	(1) GlusterFS/Memcache Server
This server acts as the master controller for this web system. It is used to manage the GlusterFS replicated dataset where SSL certificates, system configurations, and web data is stored. It provides a memcache server for use with caching from the NGINX Page Speed module. Certbot is used to issue and renew the Free SSL certificates from Let’s Encrypt. Backups can be done from this server so not to effect the load balanced NGINX/Apache servers. System configurations for all NGINX/Apache servers managed here.  

5.	(Optional) Internal Web Servers
Internal Web Servers can be any web server flavor with any web application running on it. The web traffic will be proxied from this server to the NGINX/Apache Servers, then on to the internet. It allows the NGINX/Apache servers to optimize and enhance the data. The web traffic should be plain http rather than https as the NGINX/Apache Server will provide SSL.


![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")
