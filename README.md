# homebrew-hostsblock
a homebrew formula for installing [hostsblock](gaenserich.github.io/hostsblock), an `/etc/hosts`-based ad-blocker

## Install

1. get [homebrew](https://brew.sh)
2. `brew install --HEAD --with-p7zip nicknovitski/hostsblock/hostsblock`

## Usage

**First**: `ls $(brew --prefix)/etc/hostsblock`, and examine each file in full.

`hostsblock.conf` is the primary configuration file.  It's annotated to explain all possible options, and even the formats of the other files.  Notably it contains the list of online sources which will be downloaded and combined into your black list.

`hosts.head` will be added to the _front_ of any host file you generate.  If your installation worked right, this should currently be identical to your original `/etc/hosts` file, and you won't have to do anything with it.

`black.list` is a list of hosts, one per line, which you wish to explicitly block.  Here's where you can put sites which aren't necessarily serving ads or malware, but which you sometimes wish you couldn't easily reach.  It should be empty right now.

`white.list` is a list of hosts which you wish to explicitly _un_-block, even if they appear on any of the downloaded blacklists.  Right now it should contain a few hosts which must be whitelisted to keep some common web applications from breaking (dropbox, for example). It has a slightly tricky syntax.  Quoting `hostsblock.conf` (which, recall, you should already have read):

> In this file, put a space in front of
> a string in order to let through that specific site (without quotations), e.g.
> ` www.example.com` will unblock `http://www.example.com` but not
> `http://subdomain.example.com`. Leave no space in front of the entry to
> unblock all subdomains that contain that string, e.g. `.dropbox.com` will let
> through `www.dropbox.com`, `dl.www.dropbox.com`, `foo.dropbox.com`,
> `bar.dropbox.com`, etc.

Now that you understand what is going on, invoking `sudo hostsblock` will combine all that stuff into your new `/etc/hosts` file.  Run it every now and then to stay up to date, or install a service which will do that for you:

```
$ brew tap gapple/services
$ brew services start hostsblock
```
