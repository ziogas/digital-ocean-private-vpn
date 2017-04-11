Personal VPN setup on Digital Ocean in less than 5 minutes
==========================================================

Setup your own personal [VPN] server hosted on [Digital Ocean] with a single command.

Advantages:

* *No commitment*: Launch VPN when you need it and in whatever region you want.
* *Extremely low price*: Because of Digital Ocean [hourly pricing] VPN will cost you $0.007/h.
* *Safe*: After usage you can just destroy the droplet and all the information will be destroyed too.
* *Quick & dirty*: Yes, it is not full blown VPN service but it is 100% controlled by you.

## Install

Checkout repo and add execute permissions:

    git clone git://github.com/ziogas/digital-ocean-private-vpn
    cd digital-ocean-private-vpn
    chmod +x ./vps.sh

## Create VPN

Execute and then follow instructions on the screen (normally it's enough to press ENTER on every question):

    ./vps.sh create "API_KEY_HERE" "SSH_FINGERPRINT_HERE" [optional_region] [optional_tagname]

Read below how to get *API_KEY_HERE* and *SSH_FINGERPRINT_HERE*. First is needed to create/destroy droplets by your account, another is to be able to access created droplet using SSH.

Once script is finished, it will download client.ovpn file you can inport into your networking applet.

## Obtain Digital Ocean API key

* Visit https://cloud.digitalocean.com/settings/api/tokens
* Click on "Generate new token" (or skip if you already have it)
* Copy generated token

## Obtain Digital Ocean SSH key fingerprint

* Visit https://cloud.digitalocean.com/settings/security
* Click on "Add ssh key" (or skip if you already have it)
* Copy ssh key fingerprint

## Check whenever VPN already exists

Execute:

    ./vps.sh check "API_KEY_HERE" [optional_tagname]

## Destroy VPN

Execute:

    ./vps.sh destroy "API_KEY_HERE" [optional_tagname]

## Optional arguments

Each command supports additional argument called optional_tagname which is by default "private-vpn". Tagname is used to identify droplets if you have more of them.

Create command also supports optional_region which is by default "nyc3". See supported [digital ocean regions]. At the time of this writing it is AMS1, AMS2, AMS3, BLR1, FRA1, LON1, NYC1, NYC2, NYC3, SFO1, SFO2, SGP1, TOR1.

## Change VPS type/configuration

Modify vps.sh file variable called `DROPLET_CONFIGURATION`.

## Tweak VPN

After droplet creation openvpn-script-run.sh script is uploaded and executed on the server. If you want to modify vpn behavior just add anything to this file.

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
[digital ocean regions]: https://status.digitalocean.com/
[MIT]: https://tldrlegal.com/license/mit-license
