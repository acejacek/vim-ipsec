vim-ipsec
===

ipsec.conf syntax highlighting plugin for vim.

This updates Bruce Christensen's [ipsec.conf syntax highlighting](http://www.vim.org/scripts/script.php?script_id=312) 
into a plugin because it's built for freeswan-1.91 (so a bit dated) and I'm lazy, so use 
[Plug](https://github.com/junegunn/vim-plug/) to automatically install/update things everywhere via my common .vimrc

*note*: I'd provide install instructions for Plug or other plugins managers that I don't use, but see the lazy comment above. Also, if you use one, you should know how to do that

Tailored (for the most part) to StrongSwan > 5.0
docs from: https://wiki.strongswan.org/projects/strongswan/wiki/ConnSection

### Goals
* support StrongSwan > 5.0
* get close to linting 
	- only highlight values accepted for a param - eg. a value of "yes" should not look okay for a param of "leftid"
	- try to match highlights with appropriate values eg...
		- if we have a yes/no, say "rekey", that's a Boolean
		- if something has multiple types, say "fragmentation", call that something else - Operator, currently
		- yes, my type defs could use some work &/or be customized
* remove/kind of ignore deprecated params - (eg. authby may not be included (error state), or without directly defined allowed parameters (crappy/don't care highlighting)
* remove parameters that are ... non-existant. imagine that.

### todo 
* maybe reorder things to be slightly logical groupings
* replace ipsecEq where it should be (both easy/defined nextgroups and removing dupes that are no longer matching anyway)
* figure out how to chain ipsecEQ into specific groups (like ipsecYN) to ease linting (ie, parse param=value globally instead of grossly including =
* fix ipsecAddressRange :/
* left|rightauth - try to support the crazy "ike:blah...." syntax
* not done: left|rightcert, left|rightcert2, left|rightcertpolicy, mark
* ipv6 match rule in ipsecIpAdress
* need comma delimited for left|rightdns, left|rightsourceip, ciphers, more?
* left|rightgroups, left|rightgroups2 (comma delimted strings)
* left|rightid, left|rightid2
* left|rightprotoport (deprecatated, though)
* left|rightsourceip
* left|rightsubnet
* left|rightupdown (path regex again)
* mediated_by, me_peerid 
* xauth_identity (another 'id')
### WOULD BE NICE
* some referential integrity (ie, options that are only allowed when other params have a particular value)
* this probably requires lots of vimscript-fu and/or just passing most everything off to a real script


And if you've read this far you may be questioning what I consider lazy...
