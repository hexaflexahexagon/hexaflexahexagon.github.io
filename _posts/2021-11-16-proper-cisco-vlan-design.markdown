---
layout: post
title:  "Proper Cisco VLAN Design"
tags: intro VLAN switching
---

VLANs (Virtual Local Area Networks) are a way of securing and segmenting layer 2 networks. When implemented properly, they can both reduce broadcast overhead and increase security through isolation. However, these configurations need to be designed and implemented with care so as to not open a network up to any number of known VLAN-bypassing attacks. 

<!--preview-->

# What Do VLANs Do?

VLANs can be considered a way of creating new networks (LANs) without the use of an entire router interface per network (Virtually, if you will). There are many reasons one may want to do this, the primary ones being that it is both cheap and convenient. Without the interference of a layer 3 device, any hosts that are on different VLANs will be unable to communicate whatsoever. For example, in the image below no hosts in the blue square are able to communicate to those in the orange square if square represented a different VLAN (see the IP address scheme underneath the devices):
![VLANs Image](/assets/images/proper-cisco-vlan-design/VLANs.PNG)

The only way to establish a connection between two different VLANs is with separate layer 3 capabilities connecting the two (such as a router or layer 3 switch). An example of how one may choose to connect the above topology may look like so, using "Router on a Stick":
![RoaS VLANs Image](/assets/images/proper-cisco-vlan-design/VLANs2.PNG)

When assigning VLANs to devices you will mark each interface as having a given "access" VLAN. This means that there will be 1 vlan per interface. If you instead wanted to let multiple VLANs travel across a single interface, perhaps to another switch in your network or to a default gateway for an internet connection, you would instead need a "trunk" interface.

# 802.1q Trunks

Trunks, defined by the IEEE 802.1q spec, are a way of carrying VLAN-tagged traffic over an interface and forwarding them to another network device. Trunks need multiple different types of VLANs to be assigned to them:
- Untagged (Native): This is the VLAN that will be sent across the trunk as _untagged_ ethernet frames. Tags are added to verify what VLAN a frame is supposed to be on, so these untagged packets are necessary in order to faciliate conversation between two switches. The ports on both ends of a trunk link must have the same native VLAN, otherwise communications will fail! Configure using the command: `SW(config-if)# switchport trunk native vlan <vlan-id>`
- Tagged (Allowed): These are the VLANs that are tagged and allowed to traverse across the trunk. In other words, the data that should be allowed to go between trunks. At a minimum, this should include all access VLANs and the trunk's native VLAN. Configure using the command: `SW(config-if)# switchport trunk allowed vlan <vlan-id>`

Hot Tip: when configuring allowed VLANs you may experience some friction dealing with jamming lots of VLANs into the same command. This can be done more efficiently with a couple different command syntaxes:
```
SW(config-if)# switchport trunk allowed vlan 10 	// Allow only 10
SW(config-if)# switchport trunk allowed vlan 2,3,20,40 	// Allow only 2, 3, 20, and 40
SW(config-if)# switchport trunk allowed vlan add 10 	// Add 10 to the allowed list
SW(config-if)# switchport trunk allowed vlan except 10 	// Allow all but 10
SW(config-if)# switchport trunk allowed vlan remove 10 	// Remove 10 from the allowed list
SW(config-if)# switchport trunk allowed vlan all 	// Allow all (not recommended!)
SW(config-if)# switchport trunk allowed vlan none 	// Allow none
```

# Cisco vs Other Vendors

A small thing that may cause some confusion in the field is how different vendors implement VLANs into their systems. Cisco, the primary vendor I've been targeting with this post, classifies VLANs as either Access or Trunk. Access ports expect data to be sent to them from a host without any VLAN information added to the frame, 'untagged.' On the contrary, trunk ports expect to recieve data that has been tagged and does contain VLAN information within it. While Cisco has their own words for these, they aren't in the 802.1q spec and thus the vast majority of other vendors like HP or Aruba do not use them. Instead, you will hear the terms 'tagged' and 'untagged.' It is important to be very familiar with the innerworkings of the tagging process and knowing where tags are added, removed, changed, and absent in order to help mitigate known vulnerabilities. 

# The Issues With VLAN 1

It is extremely common advice to be told to avoid VLAN 1 at all costs when designing and configuring a network. While this is absolutely true and recommended, it is also helpful to understand _why_ exactly one should avoid it. This post by Matt Schmitz at [0x2142.com](https://0x2142.com/whats-wrong-with-vlan-1/) illustrates the concept very well, as well as listing some common attacks that can result from insecure VLAN configuration.

# In Summary

VLANs to Create:
- One for Data
- One for Native
- One for Management
- One for a Blackhole

Optionally, consider things such as VoIP, Wireless, Guest networks, sensitive data, etc. as the network design plan calls for them.

On access interfaces:
```
switchport mode access
switchport access vlan x
switchport nonegotiate

! Optional to prevent sending data between host ports for added security
switchport protected
```

On trunk interfaces:
```
switchport mode trunk
switchport trunk encapsulation dot1q
switchport trunk native vlan x
switchport trunk allowed vlan x,y,z
```