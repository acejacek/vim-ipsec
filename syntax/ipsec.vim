" Language:	ipsec configuration file (ipsec.conf)
" Based on Bruce Christensen's freeswan-1.91 work here:
"    http://www.vim.org/scripts/script.php?script_id=312
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
let b:current_syntax = "ipsec.conf"


if !exists("main_syntax")
  let main_syntax = 'ipsec-conf'
endif

"-------------------------------------------------------------------------------
" Highlight anything this syntax file doesn't know about as an error
" (because this syntax file obviously knows everything, and anything that it
" doesn't know about *MUST* be an error, right? :)
"-------------------------------------------------------------------------------
syn match   ipsecError /./

"-------------------------------------------------------------------------------
" conn and config sections
"-------------------------------------------------------------------------------

" section header (e.g. 'conn %default' or 'config setup')
" (this is the only top-level element except for comments and errors)
syn match   ipsecSectionHeader /^[[:alpha:]][[:alnum:]._-]\+\>.*$/ contains=ipsecSectionKeyword,ipsecError nextgroup=ipsecSectionLine skipnl 
syn keyword ipsecSectionKeyword contained conn config nextgroup=@ipsecSectionName skipwhite 
syn cluster ipsecSectionName contains=ipsecSectionNameStr,ipsecMacro
syn match   ipsecSectionNameStr contained /\<[[:alpha:]][[:alnum:]._-]*\>$/

" Lines that make up sections (assignments)
syn match   ipsecSectionLine contained /^..*$/ contains=ipsecSectionWS,ipsecSectionHeader,ipsecError,ipsecComment nextgroup=ipsecSectionLine skipempty 
syn match   ipsecSectionWS contained /^\s\+/ nextgroup=ipsecParam

" User extension parameters
syn match   ipsecParam contained nextgroup=ipsecEq /\<[Xx][-_][[:alpha:]][[:alnum:]._-]*\>/

" Params valid in conn sections
                                                   " general
syn keyword ipsecParam contained nextgroup=ipsecEq aaa_identity also eap_identity
syn keyword ipsecParam contained nextgroup=ipsecCipher ah esp ike 
syn keyword ipsecParam contained nextgroup=ipsecYN aggressive compress forceencaps installpolicy rekey mobike
syn keyword ipsecParam contained nextgroup=ipsecYN cachecrls charonstart reauth sha256_96
syn keyword ipsecParam contained nextgroup=ipsecFrag fragmentation
syn keyword ipsecParam contained nextgroup=ipsecAuto auto
syn keyword ipsecParam contained nextgroup=ipsecAction closeaction dpdaction
syn keyword ipsecParam contained nextgroup=ipsecDscp ikedscp 
syn keyword ipsecParam contained nextgroup=ipsecXauth xauth
syn keyword ipsecParam contained nextgroup=ipsecEq xauth_identity
syn keyword ipsecParam contained nextgroup=ipsecTfc tfc
syn keyword ipsecParam contained nextgroup=ipsecSCrlP strictcrlpolicy 
" dur, need to do "<value>[/<mask>]" for mark*
syn keyword ipsecParam contained nextgroup=ipsecTunType type
syn keyword ipsecParam contained nextgroup=ipsecTunDir left right
syn keyword ipsecParam contained nextgroup=ipsecTunAuth leftauth leftauth2 rightauth rightauth2
syn keyword ipsecParam contained nextgroup=ipsecCA leftca leftca2 rightca rightca2
syn keyword ipsecParam contained nextgroup=ipsecYN leftallowany rightallowany
syn keyword ipsecParam contained nextgroup=ipsecYN lefthostaccess righthostaccess 
syn keyword ipsecParam contained nextgroup=ipsecYN leftfirewall rightfirewall
syn keyword ipsecParam contained nextgroup=ipsecEq mark mark_in mark_out 
syn keyword ipsecParam contained nextgroup=ipsecEq leftsubnet leftupdown
syn keyword ipsecParam contained nextgroup=ipsecEq rightsubnet rightupdown
syn keyword ipsecParam contained nextgroup=ipsecMC modeconfig
syn keyword ipsecParam contained nextgroup=ipsecPort leftikeport rightikeport
syn keyword ipsecParam contained nextgroup=ipsecSendCert leftsendcert rightsendcert

                                                   " automatic keying
syn keyword ipsecParam contained nextgroup=ipsecKE keyexchange
syn keyword ipsecParam contained nextgroup=ipsecKR keyingtries keyingretries
syn keyword ipsecParam contained nextgroup=ipsecTime keylife rekeymargin
syn keyword ipsecParam contained nextgroup=ipsecPercentage rekeyfuzz
syn keyword ipsecParam contained nextgroup=ipsecTime dpddelay dpdtimeout inactivity
syn keyword ipsecParam contained nextgroup=ipsecTime keylife lifetime ikelifetime margintime rekeymargin
syn keyword ipsecParam contained nextgroup=ipsecNumber lifebytes lifepackets marginbytes marginpackets reqid
							" left
syn keyword ipsecParam contained nextgroup=ipsecEq leftid leftrsasigkey leftdns 
syn keyword ipsecParam contained nextgroup=ipsecLSrcIp leftsourceip 
syn keyword ipsecParam contained nextgroup=ipsecEq leftsigkey leftrsasigkey
							" right
syn keyword ipsecParam contained nextgroup=ipsecEq rightid rightrsasigkey rightsourceip rightdns 
syn keyword ipsecParam contained nextgroup=ipsecEq rightsigkey rightrsasigkey
                                                   " manual keying
syn keyword ipsecParam contained nextgroup=ipsecNRW replay_window 
                                                   " X.509 patch
syn keyword ipsecParam contained nextgroup=ipsecEq leftcert rightcert
syn keyword ipsecParam contained nextgroup=ipsecEq leftprotoport rightprotoport
						   " IKEv2 Mediation Extensions
syn keyword ipsecParam contained nextgroup=ipsecYN mediation 
syn keyword ipsecParam contained nextgroup=ipsecEq mediated_by me_peerid

" Params valid in config sections
syn keyword ipsecParam contained nextgroup=ipsecUnique uniqueids
syn keyword ipsecParam contained nextgroup=ipsecEq interfaces forwardcontrol syslog
syn keyword ipsecParam contained nextgroup=ipsecEq klipsdebug plutodebug dumpdir charondebug
syn keyword ipsecParam contained nextgroup=ipsecEq manualstart pluto plutoload plutostart
syn keyword ipsecParam contained nextgroup=ipsecEq plutowait prepluto
syn keyword ipsecParam contained nextgroup=ipsecEq postpluto fragicmp packetdefault
syn keyword ipsecParam contained nextgroup=ipsecEq hidetos
syn keyword ipsecParam contained nextgroup=ipsecEq overridemtu
                                                   " X.509 patch
syn keyword ipsecParam contained nextgroup=ipsecEq nocrsend

" Equals sign that separates a param name from its value
" (includes leading and trailing whitespace)
syn match   ipsecEq contained /\s*=\s*/ nextgroup=ipsecQuotedValue,ipsecValue,ipsecSpaceError,ipsecError
" Value that is assigned to a parameter (eats up the rest of the line)

syn match   ipsecValue contained /.*$/ contains=ipsecNumber,ipsecMacro,ipsecComment,ipsecValueKeyword,ipsecIpAddress,ipsecPercentage,ipsecUnknownWord,ipsecTime
syn match   ipsecValue2 contained /.*$/ 

" Flag values with spaces that aren't in quotes as errors
" (this must be below all of the basic value types)
syn match   ipsecSpaceError contained /\S\+\s\+.*/

" Allow spaces in quoted values
" (this must be below ipsecSpaceError)
syn region  ipsecQuotedValue contained matchgroup=SpecialChar start=/"/ end=/"/ contains=ipsecValue keepend


" Yes, some of these could be more succinct one-liners, but I went for
" readability
syn match   ipsecYN  contained /=\(yes\|no\)/

" unique id handling
syn match   ipsecUnique contained /=yes/
syn match   ipsecUnique contained /=no/
syn match   ipsecUnique contained /=never/
syn match   ipsecUnique contained /=replace/
syn match   ipsecUnique contained /=keep/

" auto options for tunnels/connections
syn match   ipsecAuto contained /=ignore/
syn match   ipsecAuto contained /=add/
syn match   ipsecAuto contained /=route/
syn match   ipsecAuto contained /=start/

syn match   ipsecAction contained /=none/
syn match   ipsecAction contained /=clear/
syn match   ipsecAction contained /=hold/
syn match   ipsecAction contained /=restart/

syn match   ipsecDscp contained /=\d\{6}/

syn match   ipsecTfc contained /=%mtu/
syn match   ipsecTfc contained /=\d\+/

" Sruct CRL Policy
syn match   ipsecSCrlP contained /=yes/
syn match   ipsecSCrlP contained /=no/
syn match   ipsecSCrlP contained /=ifuri/

syn match   ipsecXauth contained /=\(client\|server\)/

syn match   ipsecFrag contained /=yes/ 
syn match   ipsecFrag contained /=accept/
syn match   ipsecFrag contained /=force/
syn match   ipsecFrag contained /=no/

" modeconfig
syn match   ipsecMC contained /=\(push\|pull\)/

" No replay window
syn match   ipsecNRW contained /=\(\d\+\|-1\)/

" Tunnel types
syn match ipsecTunType contained /=tunnel/
syn match ipsecTunType contained /=transport/
syn match ipsecTunType contained /=transport_proxy/
syn match ipsecTunType contained /=passthrough/
syn match ipsecTunType contained /=drop/

" Tunnel directions
syn match   ipsecTunDir contained /=\s*/ nextgroup=ipsecIpAddressRange,ipsecIpAddress,ipsecHost
syn match   ipsecTunDir contained /=%any/
syn match   ipsecTunDir contained /=%config/
syn match   ipsecTunDir contained /=%defaultroute\>/

" Tunnel Authentication methods
syn match ipsecTunAuth /=pubkey/
syn match ipsecTunAuth /=psk/
syn match ipsecTunAuth /=eap/
syn match ipsecTunAuth /=eap-aka/
syn match ipsecTunAuth /=eap-gtc/
syn match ipsecTunAuth /=eap-md5/
syn match ipsecTunAuth /=eap-mschapv2/
syn match ipsecTunAuth /=eap-peap/
syn match ipsecTunAuth /=eap-sim/
syn match ipsecTunAuth /=eap-tls/
syn match ipsecTunAuth /=eap-ttls/
syn match ipsecTunAuth /=eap-dynamic/
syn match ipsecTunAuth /=eap-radius/
	" IANA eap type vendor
syn match ipsecTunAuth /=eap-\(\d\+\)-\(\d\+\)/
syn match ipsecTunAuth /=xauth/
syn match ipsecTunAuth /=xauth-generic/
syn match ipsecTunAuth /=xauth-eap/

" Tunnel CA
syn match ipsecCA /=CN=.*/
syn match ipsecCA /=%same/

" IKE Port
syn match ipsecPort /=\d\+/

" When/how the Cert is sent
syn match ipsecSendCert /=never/
syn match ipsecSendCert /=no/
syn match ipsecSendCert /=ifasked/
syn match ipsecSendCert /=always/
syn match ipsecSendCert /=yes/

" Left Source IP
syn match ipsecLSrcIp /=\s*/ nextgroup=ipsecIpAddress
syn match ipsecLSrcIp /=%config/
syn match ipsecLSrcIp /=%config4/
syn match ipsecLSrcIp /=%config6/

" Available Ciphers - much todo, give a reasonable match for now...
syn match   ipsecCipher /=.*/

" Basic value types
syn match   ipsecUnknownWord contained /\S\+\>/

" Careful: be sure that shorter substrings appear above longer substrings
" (e.g. "default" above "defaultroute")
syn match   ipsecMacro contained /%default\>/
syn match   ipsecMacro contained /%defaultroute\>/
syn match   ipsecMacro contained /%any\>/
syn match   ipsecMacro contained /%opportunistic\>/
syn match   ipsecMacro contained /%direct\>/
syn match   ipsecMacro contained /%dns\>/
syn match   ipsecMacro contained /%search\>/
syn match   ipsecMacro contained /%config\>/

syn match   ipsecNumber contained /\d\+\(\.\d\+\)\=/
syn match   ipsecNumber contained /0x\(\x\+_\)*\x\+/
syn match   ipsecPercentage contained /=\d\{1,3}%/
syn match   ipsecIpAddressRange contained /\s+[-]?/ contains=ipsecAddress nextgroup=ipsecIpAddressRange
syn match   ipsecIpAddress contained /\([0-9]\{1,3}\.\)\{3}[0-9]\{1,3}\(\/[0-9]\{1,2}\)\=/ contains=ipsecIpPunct
syn match   ipsecIpPunct contained /[.\/]/
syn match   ipsecIpRange contained /[-\/]/
syn match   ipsecHost /\v(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/
syn match   ipsecTime contained /=\d\+[smhd]/

" Key Exchange
syn match   ipsecKE contained /=ike/
syn match   ipsecKE contained /=ikev1/
syn match   ipsecKE contained /=ikev2/

" Keying Retries
syn match   ipsecKR contained /=\d\+/
syn match   ipsecKR contained /=%forever/

" These keywords are valid on the right side of an assignment
syn match   ipsecValueKeyword contained /3des-md5/
syn match   ipsecValueKeyword contained /3des-md5-96/
syn match   ipsecValueKeyword contained /3des-sha1/
syn match   ipsecValueKeyword contained /3des-sha1-96/
syn match   ipsecValueKeyword contained /hmac-md5/
syn match   ipsecValueKeyword contained /hmac-md5-96/
syn match   ipsecValueKeyword contained /hmac-sha1/
syn match   ipsecValueKeyword contained /hmac-sha1-96/
syn keyword ipsecValueKeyword contained tunnel transport passthrough yes no ike clear
syn keyword ipsecValueKeyword contained add route start ignore esp ah secret
syn keyword ipsecValueKeyword contained rsasig none all pass drop reject

"-------------------------------------------------------------------------------
" Includes (including filenames and wildcards)
"-------------------------------------------------------------------------------
syn match   ipsecInclude /^include\>.*/ contains=ipsecIncludeKeyword,ipsecError
syn keyword ipsecIncludeKeyword contained include nextgroup=ipsecFileName skipwhite
syn match   ipsecFileName contained /[^"[:space:]]\S*/ contains=ipsecWildcard
syn match   ipsecWildcard contained /[][{}*?,]/

"-------------------------------------------------------------------------------
" Comments
"-------------------------------------------------------------------------------
syn match   ipsecComment /\s*#.*$/ contains=ipsecTodo
syn keyword ipsecTodo contained XXX TODO FIXME

"-------------------------------------------------------------------------------
" Help Vim out a little with re-coloring (parse back 30 lines)
"-------------------------------------------------------------------------------
syn sync minlines=30

"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
" syn keyword ipsecOperator =
"-------------------------------------------------------------------------------
" Highlighting
"-------------------------------------------------------------------------------

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_ipsec_conf__syn_inits")
  if version < 508
    let did_ipsec_conf__syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink ipsecIncludeKeyword Include

  HiLink ipsecWildcard       SpecialChar
  HiLink ipsecIpPunct        SpecialChar

  HiLink ipsecSectionWS      Normal
  HiLink ipsecUnknownWord    Normal
  HiLink ipsecOperator	     SpecialChar

  HiLink ipsecValueKeyword   ipsecKeyword
  HiLink ipsecSectionKeyword ipsecKeyword
  HiLink ipsecKeyword        Keyword

  HiLink ipsecParam          Identifier
  HiLink ipsecYN             Boolean 
  HiLink ipsecEq             Operator
  HiLink ipsecAuto           Operator
  HiLink ipsecAction         Operator
  HiLink ipsecTime           Operator
  HiLink ipsecKE             Operator
  HiLink ipsecFrag           Operator
  HiLink ipsecPercentage     Operator
  HiLink ipsecMC             Operator
  HiLink ipsecSendCert       Operator
  HiLink ipsecTunType	     String
  HiLink ipsecTunDir	     String
  HiLink ipsecTunAuth	     Operator
  HiLink ipsecCA	     String
  HiLink ipsecPort	     Number
  HiLink ipsecLSrcIp	     String
  HiLink ipsecTfc            Operator
  HiLink ipsecXauth          Operator
  HiLink ipsecUnique         Operator

  HiLink ipsecSpaceError     ipsecError
  HiLink ipsecError          Error

  HiLink ipsecFileName       ipsecString
  HiLink ipsecSectionNameStr ipsecString
  HiLink ipsecIpAddress      ipsecString
  HiLink ipsecHost           ipsecString
  HiLink ipsecString         String
  HiLink ipsecNumber         Number
  HiLink ipsecTime           DateTime
  HiLink ipsecComment        Comment
  HiLink ipsecTodo           Todo

  HiLink ipsecMacro          Macro

  delcommand HiLink
endif
