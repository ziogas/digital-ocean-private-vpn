Private VPN setup script based on Digital Ocean API
==============
Install/remove your own private [VPN] server hosted on [Digital Ocean] with a single command.
Advantages:
* No commitment: Launch VPN when you need it and in whatever region you want.
* Extremely low price: Because of Digital Ocean [hourly pricing] VPN will cost you $0.007/h.
* Safe: After usage you can just destroy the droplet and all the information will be destroyed too.
* Quick & dirty: Yes, it is not full blown VPN service but it is 100% controller by you. And you should destroy it after each usage.

## Install

Checkout and place in a safe place the latest version:

    git clone git://github.com/ziogas/do-private-vpn
    chmod +x ./vps.sh;

## Obtain Digital Ocean API key

* Visit https://cloud.digitalocean.com/settings/api/tokens
* Click on "Generate new token" (or skip if you already have it)
* Copy generated token

## Obtain Digital Ocean ssh key fingerprint

* Visit https://cloud.digitalocean.com/settings/security
* Click on "Add ssh key" (or skip if you already have it)
* Copy ssh key fingerprint

## Usage

Execute without any parameters:

    ./vps.sh

## Create VPN

Execute and then follow instructions on the screen:

    ./vps.sh create "API_KEY_HERE" "SSH_FINGERPRINT_HERE" [optional_tagname]
    
Then you can import downloaded .ovpn file into your network manager.

## Check whenever VPN already exists

Execute:

    ./vps.sh check "API_KEY_HERE" [optional_tagname]

## Destroy VPN

Execute:

    ./vps.sh destroy "API_KEY_HERE" [optional_tagname]

## Optional arguments

Each command supports additional argument called optional_tagname which is by default "private-vpn". Tagname is used to identify droplets if you have more of them.

## Change VPS type/configuration

Modify vps.sh file variable called `DROPLET_CONFIGURATION`

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

## Author
Arminas Zukauskas - arminas@ini.lt
*Actual VPN install script can be found here https://github.com/Nyr/openvpn-install*

## License

[MIT] Do whatever you want, attribution is nice but not required

[VPN]: https://en.wikipedia.org/wiki/Virtual_private_network
[Digital Ocean]: https://www.digitalocean.com/
[hourly pricing]: https://www.digitalocean.com/pricing/
[MIT]: https://tldrlegal.com/license/mit-license
