<p align="center"><img src="http://cloud.lrgex.com/s/mCxTfnA2bikjYyZ/download/Dark%20Full%20Logo.png" alt= “” width="400" height="100"></p>


<p align="center"><img src="https://download.lrgex.com/ci.png" alt= “” width="150" height="150"></p>






# <div align="center">LRGEX-CodeIgniter</div>


This repository contains the Docker setup for a web application development using CodeIgniter 4 on PHP 8.2 with Apache, running on Debian Bookworm.

## Developers : 

- Hesham M ALAHDAL a.k.a L.R.G 

- Nidhal A Brniyyah a.k.a Ezmex

  

## Prerequisites

- Docker installed on your machine.
- Basic knowledge of Docker commands.

## Setup



1. **Run the Docker Container**:
   After the image is built, you can run the container using:
   
   ```dockerfile
   docker run -d --name lrgex-app -v /path/to/your/app:/var/www/html -p 8585:80 lrgex/codeigniter
   ```
   
   - This command runs the Docker container and maps the container's port 80 to port 8585 on your host machine. you can use any host port like -p 80:80 .
   
   - --name is optional. you can name the container whatever you want 
   
   - -v is optional. However you can directly edit you application inside the container in /var/www/html 
   
   
   
5. **Access the Application**:
   Once the container is running, you can access the CodeIgniter application by visiting `http://your-ip:port and codeigniter welcoming page.  

## LRGEX-Codeigniter  Details

Lrgex-Codeigniter ` included in this repository performs the following actions:

- Uses PHP 8.2 with Apache on Debian Bookworm as the base image.
- Installs necessary system dependencies and PHP extensions.
- Enables Apache's `mod_rewrite`.
- Installs Composer globally and uses it to install CodeIgniter 4.
- Sets up the working directory and moves the CodeIgniter files to it.
- Copies the Apache configuration and `.htaccess` file to the container.
- Sets appropriate permissions for the Apache document root.
- Exposes port 80 for web access.
- Sets the `ServerName` directive in the Apache configuration.
- Modifies the `App.php` and `Constants.php` files for CodeIgniter configuration.
- Uses an entrypoint script to start the Apache server.

## Troubleshooting

- If you encounter any issues while accessing the application, ensure the Docker container is running and your port in example case 8585 is not being used by another process.
- you can check the containers logs, for further investigations.


