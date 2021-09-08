+++ 
draft = true
date = 2021-02-04T23:13:35+05:30
title = "Arch Linux Installation in a VM for Dummies"
description = "This is a simple guide" 
slug = "" 
tags = ["Arch Linux", "Installation"]
categories = ["Installation Guide"]
externalLink = ""
series = []
+++

## About Arch Linux

Arch Linux is a Linux distribution that follows a rolling-release model (unlike other popular Linux distros like Ubuntu for example). A Linux distribution following a rolling-release model always receives the latest software updates, which can be installed and used easily.

Installing Arch can be a tedious process, but this guide is written to help you install Arch in a Virtual Machine easily.

### Prerequisites

1. Get the Arch Linux ISO [here.](https://archlinux.org/download/)  
   Choose a suitable mirror to download the Arch Linux ISO.

2. [Virtualbox](https://www.virtualbox.org/wiki/Downloads)  
   Follow the instructions given by the installation wizard to install Virtualbox.

---

### Setting up the Virtual Machine

When you first start Virtualbox, you should see a window like the one shown below, but you wouldn't see any virtual machine instances.  

![Virtualbox initial screen](/img/ArchDummies/1_VirtualboxInitialScreen.png)

Click on the shiny 'New' button to create a new VM (which is what you're doing, BTW). A wizard pops up and asks you a riddle (which we're gonna help you solve). Please enter the name of the VM. Note that the Type and the Version should change automatically. If not, feel free to change it manually and hit 'Next'.

![VM wizard pop-up](/img/ArchDummies/2_VMWizardPop-up.png)   

The wizard will be asking about the memory (RAM) size of your VM. Please enter the RAM size in the number box instead of using the slider.  

![VM RAM Pop-up](/img/ArchDummies/3_VMRAMPop-up.png)  

Here's a table on how much RAM you need to allocate to the VM for your reference. (Feel free to allocate ridiculously high amounts of RAM if you want to wreck your system).

| System RAM | VM RAM |
| ---------- | ------- |
| 4 GB | 1 GB |
| 8 GB | 3 - 4 GB |
| 16 GB | 6 - 8 GB |
| > 16 GB | 10 GB is an overkill. |

Always make sure that you have at least 3 GB RAM remaining at all times. Click on 'Next'.

The wizard now leads you to a hard disk menu. You have three options:
- Not to create a hard disk
- To create a virtual hard disk (which has a default size of 8 GB)
- To use an existing virtual hard disk

![VM Hard disk pop-up](/img/ArchDummies/4_VMHDDPop-up.png)

At this stage, you have to select this second option and hit 'Next'.

The wizard now redirects you to choose the type of the virtual hard disk. If you're going to export the hard disk, then you can choose any other suitable option other than the default one. For now, you can leave as it is and hit 'Next'.

![VM Hard disk type](/img/ArchDummies/5_VMHDDType.png)

The next prompt asks if you want a dynamic hard disk or a hard disk with a fixed size. For demonstration purposes, there's not a big difference, so we're gonna stick with "Dynamically allocated".  

![VM Hard disk type](/img/ArchDummies/6_VMHDDStorageType.png)  

Since this is a virtual machine, there's no need for us to allocate a large amount of storage for our virtual hard disk. 15 GB should be more than enough.

![VM Hard disk size](/img/ArchDummies/7_VMHDDSize.png)  

You are now done with the VM wizard. However, there are some additional steps required to configure the VM to boot successfully.

In Virtualbox, open the Settings menu and go to the "System" submenu. Change the boot order in such a way that "Optical" comes first followed by "Hard Disk" using the arrow keys, shown in the screenshot below. Unchecking the "Floppy" and "Network" options is left at the readers' discretion.

![VM System Settings](/img/ArchDummies/8_VMSettingsSystem.png)

**NOTE: Don't forget to check the "Enable EFI" option.**

Since we don't need multiple cores for a demo VM, we need to instruct the hypervisor to allocate only 1 CPU core to the VM. To do so, head over to the "Processor" tab in the "System" menu and adjust the slider to 1 CPU core.

![VM System Processor Settings](/img/ArchDummies/9_VMSettingsProcessor.png)

Now this step MAY be unnecessary and you might not need to change anything here. Regardless, head over to the "Acceleration" tab in the same menu and check if the Paravirtualization interface is set to KVM. If not, change it accordingly.

![VM System Acceleration Settings](/img/ArchDummies/10_VMSettingsAcceleration.png)

A paravirtualization interface is an interface used by a hypervisor to enable efficient execution of software in a virtual machine. A KVM interface is used for this demo VM, since it is supported by Linux kernel versions 2.6.25+.

We now need to instruct Virtualbox to somehow read the ISO file that we have downloaded and to boot from it. To do so, head over to the "Storage" section of the settings menu and select the IDE controller to add the ISO file as given in the screenshot.

![VM Storage Settings](/img/ArchDummies/11_VMSettingsStorage.png)  

---

### Starting the Virtual Machine + Arch Linux Installation  

After configuring the VM, we need to boot it up to install Arch. To do so, simply start the VM in the main menu. There's a good chance that you might be redirected to a prompt which asks for some sort of a bootable media for your VM to boot from. Simply follow the instructions and select the ISO file.

![VM Boot Prompt](/img/ArchDummies/12_VMBootPrompt.png) 

You should now see the boot menu of the VM. If you see a menu like the one shown below, then your VM has booted successfully and you can install Arch. For now, use your arrow keys to highlight the first option and hit Enter.  

![VM Boot Menu](/img/ArchDummies/13_VMBootMenu.png)  

You will now be greeted by a wall of text rapidly scrolling down. This is perfectly normal as it is the init system that is firing up other essential services and background processes.  

![VM systemd startup](/img/ArchDummies/14_VMSystemdStartup.png)

You will now be redirected to a CLI prompt. Note that the prompt states that the user login is ```root```. This means that you have full administrative privileges for the VM. However, with great power comes great responsibility. The entire Arch installation will be done using this prompt.  

![Arch root prompt](/img/ArchDummies/15_ArchRootPrompt.png)  

Your first command now will be to sync a background service called ```timedatectl``` so that it follows the Network Time Protocol (NTP). To do so, type ```timedatectl set-ntp true```.

![Arch timedatectl](/img/ArchDummies/16_Archtimedatectl.png)  

**Optional: You can type ```ip a``` to check the status of your internet connection.**  

The next step absolutely requires an internet connection. If your VM is not able to connect to the internet, feel free to pause here and refer to the [Archwiki](https://wiki.archlinux.org/). To understand this step, you need to understand the concept of a package manager.  

A package manager is essentially a suite of tools that automates the entire process of installing, updating, uninstalling and even configuring computer software accordingly. It mostly deals with "packages", which is a fancy name for software, and "repositories" - a storage location where packages are stored.  

Many Linux distros use different package managers. For example, the package manager "apt" is used by Ubuntu and its derivatives, "emerge" is used by Gentoo and its derivatives. Arch uses the package manager called "pacman", which is short for **pac**kage **man**ager. 

We now use pacman to force a complete refresh of the local package repository such that it synchronizes with the remote repository, and to update all packages in the system (or in the installation media, in this case). This is achieved by using flags after the name of the package manager, by typing ```pacman -Syy```.

![pacman -Syy](/img/ArchDummies/17_ArchpacmanSyy.png)  


After the progress bars are filled, we now need to take a look at our virtual hard disk so that we can allocate the partitions properly. Type ```lsblk``` to view the details regarding the hard disk.

![lsblk before](/img/ArchDummies/18_Archlsblkinit.png)  

At first glance, you might not understand the details given. This is perfectly fine - we are only concerned with the middle row, the entry with the name ```sda``` which has a size of 15 GB (which is denoted as 15G). Linux systems tend to follow a naming convention where the hard disk is **mostly** denoted as ```sda```. Subsequent external devices connected are denoted as ```sdX```, where X is a letter allocated by the OS in alphabetical order. This means that if I plug in a pen drive, it gets denoted as ```sdb```, and so on.

The next step requires us to partition the hard disk. The Arch ISO provides us a pseudo-graphic partitioning tool called ```cfdisk``` that allows us to do so. We need to open cfdisk by specifying the name of the storage device (which is ```/dev/sda``` in this case, where ```dev``` stands for device). Type ```cfdisk /dev/sda``` to proceed.

![cfdisk menu](/img/ArchDummies/19_Archcfdiskmenu.png)

You will be redirected to a menu like the one shown above. Use the arrow keys to select the ```gpt``` option. For the purposes of demonstration, we are not choosing the ```dos``` option since it is outdated. After that, a pseudo-graphic menu will be displayed like this:  

![cfdisk main page](/img/ArchDummies/20_Archcfdiskmainmenu.png)  

Use the Up and Down arrow keys to select the different partitions and the Left and Right arrow keys to select different options. For now, hit Enter to create a new partition from the given free space of 15 GB. You will then be prompted to type the size of the parition with suffixes such as M for MB, G for GB and so on.

