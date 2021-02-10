# Daniel Larusso's Arma 3 Server
*A docker based arma 3 server with ftp server for arma3sync repo*

## Requirements
* Docker
* docker-compose
* git

## Usage
Clone the repository to your linux server

`git clone git@github.com:DanielLarusso/docker-arma.git`

### .env-file
Copy `.env.dist` to `.env` and adjust this file to your needs
* `ARMA3SERVER_PARAMETER_MOD` The mods string to launch the server with e.g. "@cba_a3;@ace;@task_force_radio;"
* `ARMA3SERVER_PARAMETER_SERVERMOD` Same as above but for server mods only
* `STEAM_ACCOUNT_USER` Arma 3 server requires a valid steam user. Make sure to turn off steam guard!
* `STEAM_ACCOUNT_PASSWORD` The password for the declared steam user above
* `FTP_USER_UID` **Default:** 1000; The UID of the linux user to use for ftp access
* `FTP_USER_NAME` **Default:** vsftp; The username of the linux user to use for ftp access
* `FTP_USER_PASSWORD` **Default:** changeme; The password of the linux user to use for ftp access
* `FTP_PORT` **Default:** 21
* `FTP_PASV_PORT_MIN` **Default:** 21000
* `FTP_PASV_PORT_MAX` **Default:** 21010

### server.cfg & basic.cfg
Copy `config/server.cfg.dist` and `config/basic.cfg.dist` to `config/server.cfg` and `config/basic.cfg` and adjust them to your needs

### Start the server
`docker-compose up -d`