!!! WARNING !!!

Should be only used along with

[Comgress64 VPN project](https://github.com/comgress64/vpn) and [Comgress64 VPN Frontend](https://github.com/comgress64/vpn_frontend
)


# OpenVPN frontend (ipv6)
Web interface for OpenVpn with ipv6



## System description

## Architecture design

![](http://i.imgur.com/8NsQhfq.png)

## Architecture description

Project includes three sub projects - API, Frontend and Backend

### Roles of authorized users

* Super Admin account - has full access to all features.
* Admin account is able to:
  * Create User accounts
  * Add new devices and export the VPN configuration files to be installed on device or client computer.
  * Delete Accounts, Change passwords, etc.
  * View VPN Connection Logs for each device
  * See a list of devices, connection status, last activity time, IP address, link to logs, enable / disable button. 
* User Accounts can:
  * Login and see list of all the devices, status, IP, logs, traffic etc.
* Optional permissions for User Account - 
  * Log into web portal - some users don’t need this.
  * Add new devices 
  * Add new client.
  * Export config files






## Screenshots


![](http://i.imgur.com/iGDverq.gif)




## DEMO
http://vpn.comgress64.com/

login/pass
vpn@vpn.com/vpn


## Support

Feel free to contact us at comgress64@gmail.com if any questions


