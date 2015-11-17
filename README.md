# homebrew-hostsblock
a homebrew formula for installing [hostsblock](gaenserich.github.io/hostsblock), an `/etc/hosts`-based ad-blocker

## Install

1. get [homebrew](https://brew.sh)
2. `brew install --HEAD nicknovitski/hostsblock/hostsblock`

## Usage

### `hostsblock`

`sudo hostsblock` will update your `/etc/hosts` file against a bunch of different online sources.  You might want to make a back-up of that file first, and/or look at `$(brew --prefix)/etc/hostsblock/hostsblock.conf` to see what the default sources are.

When you install the formula, homebrew will give you instructions on how to install a launchctl service to automatically run hostsblock daily, but ignore them, this way is much better:

```
$ brew tap gapple/services
$ brew services start hostsblock
```
#### configuration

All configuration files live in `$(brew --prefix)/etc/hostsblock`.

- `hostsblock.conf`: the primary config file, documented with defaults and options.
- `hosts.head`: a file whose contents will be added to the _front_ of the resulting hosts file.  Starts as a copy of your original hosts file.
- `black.list`: a list of additional hosts you wish to block.  Starts as an empty file. 
- `white.list`: a list of hosts you wish to keep un-blocked, overriding online sources.  Starts as a list of common  

### `hostsblock-urlcheck`

This command lets you easily black- and white-list sites.
#### Scenario 1: whitelisting

You've updated your hosts file, you're blocking hundreds of thousands of ad servers, your web experience has improved immeasurably...but you've noticed a site, or just one page on it, which breaks as a result.  You decide that the content of that site is worth the sacrifice of being tracked or advertised to.  Enter `hostsblock-urlcheck`

```
sudo hostsblock-urlcheck www.daisuki.net
Password:
Checking to see if url is blocked or unblocked...

'daisuki.net' NOT BLOCKED/REDIRECTED
	1) Block daisuki.net
	2) Block daisuki.net and delete all whitelist url entries containing daisuki.net
	3) Keep unblocked (default)
1-3 (default: 3):
```

Of course that host isn't blocked, and no you don't want to block it 
