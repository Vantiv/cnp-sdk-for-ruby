Setting up and Configuring the Vantiv eCommerce SDK
=========================================

Running the built in configuration file generator
-------------------------------------------------
The Ruby SDK ships with a built in program which can be used to generate your specific configuration.

This program runs as follows:
   
```
>Setup.rb 
Welcome to Vantiv eCommerce Ruby_SDK
please input your user name:
test_user
please input your password:
test_password
Please choose Vantiv eCommerce url from the following list (example: 'prelive') or directly input another URL:
sandbox => hhttps://www.testvantivcnp.com/sandbox/new/sandbox/communicator/online
prelive => https://payments.vantivprelive.com/vap/communicator/online
postlive => https://payments.vantivpostlive.com/vap/communicator/online
production => https://payments.vantivcnp.com/vap/communicator/online
transact_prelive => https://transact.vantivprelive.com/vap/communicator/online
transact_postlive => https://transact.vantivpostlive.com/vap/communicator/online
transact_production => https://transact.vantivcnp.com/vap/communicator/online
sandbox
Please input the proxy address, if no proxy hit enter key: 

Please input the proxy port, if no proxy hit enter key: 

The Vantiv eCommerce configuration file has been generated, the file is located at: /<your-home-directory>/.cnp_SDK_config.yml 
```

Modifying your configuration
----------------------------
You may change the configuration values at anytime by running Setup.rb again, or simpy opening the configuration file directly in the editor of your choice and changing the appropriate fields. 

Changing the location of the Cnp configuration file:
------------------------------------------------------
NOTICE you can set the environment variable $CNP_CONFIG_DIR to locate your configuration file in a location other than the $HOME Directory, the the file will reside in $CNP_CONFIG_DIR/.cnp_SDK_config.yml  

Sample configuration file contents
----------------------------------
```
user: test_user
password: test_password
url: https://www.testcnp.com/vap/communicator/online
proxy_addr: yourproxyserver
proxy_port: 8080
```