---
layout: post
title:  "What is an IP Address?"
categories: intro IP
---

# What is an IP address?

While the question may seem simple, to many who are new to the IT scene it may not be so obvious as to what an IP address truly is. IP addresses are logical and dynamic addresses applied to [Layer 3](https://en.wikipedia.org/wiki/OSI_protocols) device interfaces. Let's give an example: A computer with an internet connection must have some sort of IP address in order to talk to the LAN's router and reach the internet. Most commonly, this IP would either be assigned to the Ethernet interface that a cable is plugged into or a WiFi adapter, where the computer has previously joined an SSID. Or, both! A device can have as many IP addresses as it has interfaces (or with virtual interfaces even more). 

IP addresses are critical as they allow computers to be grouped into networks that can communicate interdependently.

# What do they look like?

An IP address has many representations but always follows the same form. In decimal, it is written as four decimal numbers between 0 and 255, separated by periods. For example: `127.0.0.1, 192.168.1.1, 255.255.255.255, 9.9.9.9`

In binary, however, an IP address can also be written as a series of 32 individual bits - binary 1s and 0s. For the sake of convenience humans writing out IP addresses in binary may opt to continue using the dotted decimal notation between each 8 bits to improve readability. However, do note that these dots are not real characters but simply notation. Computers still see the 32 bits as they're written. An example of a bianry representation of an IP address may look like: `11000000.10101000.00000001.00000001`

Writing binary may seem a bit obtuse right now, but for certain topics (subnet masks, subnetting, wildcard masks) it aids understanding enough that I would consider it downright essential knowledge for any prospective networking professional.

# Where do they come from?

IP addresses are primarily assigned in two different ways: statically, or through DHCP. Static addresses are typed into a computer, manually, by a human. This _can_ be nice, but as you add more computers or want to change your address scheme it quickly becomes unmanageable. Nowadays, static IP addresses are only really used for devices that are accessed by many users and are expected to not change. Some examples may include a server, router, printer, and so on. For end devices though the only real option is to use DHCP. DHCP, or the Dynamic Host Control Protocol, is a way of centralizing and automating the distribution of IP addresses. One DHCP server can be used to automatically hand out IP addresses (along with DNS settings, a gateway address, and more) to hosts as they request them. 

# How do I find them?

Now these explanations are good and all, but where things really start to get fun is in practice. There are tons of ways to find IP addresses of various devices and on different operating systems, but I've gone ahead and listed a few that you'll find yourself potentially using frequently.  

Windows devices: `ipconfig /all`
```
...

Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . : howtocutapineapple.com
   Description . . . . . . . . . . . : Intel(R) Ethernet Connection (7) I219-V
   Physical Address. . . . . . . . . : 0C-9D-92-C0-D3-8E
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes
   Link-local IPv6 Address . . . . . : fe80::1c74:b239:ba56:4ff1%12(Preferred)
   IPv4 Address. . . . . . . . . . . : 192.168.10.18(Preferred)
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Lease Obtained. . . . . . . . . . : Wednesday, November 10, 2021 6:12:49 PM
   Lease Expires . . . . . . . . . . : Thursday, November 11, 2021 6:15:53 PM
   Default Gateway . . . . . . . . . : 192.168.10.1
   DHCP Server . . . . . . . . . . . : 192.168.10.1
   DHCPv6 IAID . . . . . . . . . . . : 151821714
   DHCPv6 Client DUID. . . . . . . . : 00-01-00-01-26-3B-BA-A1-0C-9D-92-C0-D3-8E
   DNS Servers . . . . . . . . . . . : 1.1.1.1
                                       1.0.0.1
   NetBIOS over Tcpip. . . . . . . . : Enabled

...
```
The flag `/all` simply asks windows to display as much information about the interface as possible. While the IP address is still shown without it, usually some of the other fields are going to end up being helpful to look at so there's no harm in adding it for fun.

Linux/MacOS devices: `ip -4 a`
```bash
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
4: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    inet 172.31.247.57/20 brd 172.31.255.255 scope global eth0
       valid_lft forever preferred_lft forever
```
The flag `-4` means to only include IPv4 addresses. More about the differences between IPv4 and IPv6 later. The flag `-a` means to show addresses on devices. My first device here is `lo:`, a virtual interface loopback adapter. My second device is `eth0:`, an ethernet adapter. The IP address (or, inet) of `eth0` is 172.31.247.57.

# What is a subnet mask?

By themselves, IP addresses simply label interfaces and don't provide much value. However, combining IP addresses with subnet masks allows you to define networks in a way that is essential to routing and network addressing. Subnet masks look similar to IP addresses, but with some slightly different rules. Let's look at an example of a valid subnet mask:
```
Decimal: 255.255.255.192
Binary:  11111111.11111111.11111111.11000000
```
Notice how there's a 'divide' of sorts in the binary representation? This is something that must be true for all subnet masks, you start with a continuous stream of binary 1's and at some point switch to a stream of bianry 0's. Let's call the first part the "network portion" and the second part the "host portion." How are these used in practice? Well, using some binary math we can calculate some important special IPs in any given network. Let me define those: 

- Network address: The first IP of any IP range. This can be thought of as an identifier for a network. Do you want to refer to multiple computers on the same network at once (Say, `192.168.2.23/24` and `192.168.2.33/24`)? Then you can use the network address for that segment (Here, that would be `192.168.2.0/24`). Often you'll find network addresses in use in things like firewalls or Access Control Lists, as they may need to permit or deny traffic to any given network range. 
- Broadcast address: The last IP of any IP range. This is a special address that can be used to send a _broadcast_ message to all hosts on a network at once. These are most often going to be used by various protocols and applications that may need to communicate with anybody nearby (Such as DHCP) rather than a specific unicast target.

I'm not going to dive too deep into the nitty-gritty of subnet masks for now, but briefy entertain me while I write out a few more examples. Something like this may seem arbitrary if this is the first you're hearing of it, but once you see the patterns and binary tricks being used I hope it'll make more sense. First, the decmial representations:
```
Host IP address:   172.16.10.223
Host subnet mask:  255.255.255.128
Network address:   172.16.10.128
Broadcast address: 172.16.10.255
```
Then, the binary ones.
```
Host IP address:   10101100.00010000.00001010.11011111
Host subnet mask:  11111111.11111111.11111111.10000000
Network address:   10101100.00010000.00001010.10000000
Broadcast address: 10101100.00010000.00001010.11111111
```
It's important to note the columns and their relationships with other rows. Any digit where the subnet mask is a 1 will have the same value between the IP address, network address, and broadcast address. This is always true, as those 1's indicate the "network portion" of the IP address as we defined earlier. Also notice how anything that is a 0 in the subnet mask has the opposite effect. A network address sets all columns that are 0 in the subnet mask to 0, while a broadcast address sets those to 1 instead, and an IP address does some combination of the two.

# Special IP addresses

Not all IP ranges were made equal, and by spec some are reserved for any number of special functions. I will only discuss a few of the most common in daily life, but if you wish to view a full list then the [RFC](https://datatracker.ietf.org/doc/html/rfc5735#section-4) is a great place to start reading!

Private-Use Networks:
```
10.0.0.0/8
172.16.0.0/12
192.168.0.0/16
```
These networks are all reserved for private use. Meaning, they cannot be routed on the global internet. Instead, they are often used for internal, private networks as a local addresses. Then, they are translated by the router using NAT to a single public address. This helps conserve IP addresses and (depending on who you ask) increases security marginally, as those devices are no longer directly accessible to the public internet. You will see these ranges constantly, and I can nearly guarantee if you looked at the IP address of the device you're on right now it would be in one of these three ranges. 

Loopback:
```
127.0.0.0/8
```
A loopback address is a way of targeting your own computer, for whatever purpose that may serve. One use for a loopback may be to test if the network stack is working. If sending a ping to `127.0.0.1` doesn't work, then you may want to look into getting a new NIC for your computer. Another reason would be for local web development, as you can access websites that are being hosted on your own machine by using `127.0.0.1` in the address bar of a web browser. Even though any address in the `/8` range is a valid loopback address, the vast majority of people simply use the first address for convenience. Don't let that catch you off guard if another one pops up in the wild though!

Link Local (APIPA):
```
169.254.0.0/16
```
A link local address (which also goes by the name Automatic Private IP Addressing) is a result of a DHCP failure. When requesting a dynamic IP, a computer will first send a broadcast discovery message that requests to be offered an address. However, if this were to fail and no DHCP server is able to offer the host an address, it will automatically assign itself a random IP in the link local address space. In other words, if you were investigating a computer that did not have internet connectivity and saw that it had a link local address you would be able to conclude that _something_ about DHCP is amiss and might want to start looking that direction to solve the issue.

# IPv4 vs IPv6

While this post is limited in scope to IPv4, I feel I should mention IPv6 so that it doesn't catch any new networkers off-guard when they first encounter it. Historically, there have been a decent number of hurdles and limitations of IPv4 that have had to be worked around. One such limitation is the limited number of addresses available. A `0.0.0.0/0` sized network may seem large, but that's only 4,294,967,296 addresses. If every connected device, smart fridge, camera, business, IP phone, and so on had it's own address then that 4 billion number would run out _fast_. To mitigate this, some very smart engineers created NAT, network address translation. This is what enables us to use those private-use network ranges over and over again. Instead of all 10 devices in a residential home needing their own IP address, they can use the same private range as the neighbor and just have 1 IP on the router instead. For a while this worked fine, but for some the added complexity and CPU time this takes was not enough. The solution to this issue (and many more that IPv4 face) was to completely rework IP from the ground up. What I've been calling IP is more accurately IP version 4, and this new version 6 would purport to solve all those issues and more. If you wish to learn more about IPv6, there are many great resources online, I would recommend the [RFC](https://datatracker.ietf.org/doc/html/rfc8200) to get you started.
