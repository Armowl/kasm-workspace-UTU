
FROM kasmweb/ubuntu-jammy-desktop:1.13.1

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

# Copy install scripts
COPY ./src/ $INST_DIR

# custom commands
RUN cd ~/Desktop
RUN yes | sudo apt-get update 
RUN sudo apt update
RUN yes | sudo apt-get install terminator
RUN yes | sudo apt-get install curl
RUN yes | sudo apt-get install tar
RUN yes | sudo apt-get install rdesktop
RUN yes | sudo apt-get install nmap
RUN yes | sudo apt-get install software-properties-common
RUN yes | sudo apt install virtualbox
RUN wget https://download.virtualbox.org/virtualbox/6.1.26/Oracle_VM_VirtualBox_Extension_Pack-6.1.26.vbox-extpack

#RUN yes | sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.1.26.vbox-extpack
#RUN sudo groupadd vboxusers
#RUN sudo useradd -g vboxusers kasm-user

RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian jammy contrib" >> /etc/apt/sources.list
RUN wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
RUN sudo apt-get update
RUN yes | sudo apt-get install virtualbox-6.1

#RUN touch tmpp.sh
#RUN echo "#!/bin/bash" >> tmpp.sh
#RUN echo "cd /etc/init.d/"
#RUN echo "services=(vboxautostart-service vboxweb-service vboxballoonctrl-service)" >> tmpp.sh
#RUN echo 'base_url="https://www.virtualbox.org/svn/vbox/trunk/src/VBox/Installer/linux"' >> #tmpp.sh
#RUN echo 'for service in "${services[@]}"' >> tmpp.sh
#RUN echo "    do" >> tmpp.sh
#RUN echo '      wget "${base_url}/${service}".sh -O "${service}" \' >> tmpp.sh
#RUN echo '      && chmod +x "$service"  \' >> tmpp.sh
#RUN echo '      && update-rc.d "$service" defaults 90 10' >> tmpp.sh
#RUN echo "    done" >> tmpp.sh
#RUN chmod u+x tmpp.sh
#RUN ./tmpp.sh


#RUN sudo apt-get install libgtk2-perl libsoap-lite-perl rdesktop
#RUN sudo yum install perl-Gtk2 perl-SOAP-Lite rdesktop

RUN VBoxManage createvm --name "Pfsense" --ostype BSD --register
RUN VBoxManage createhd --filename "Pfsense.vdi" --size 5000
RUN VBoxManage storagectl "Pfsense" --name "IDE Controller" --add ide --controller PIIX4
RUN VBoxManage storageattach "Pfsense" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "Pfsense.vdi"

RUN yes | sudo apt-get install build-essential linux-headers-`uname -r` dkms virtualbox-dkms
RUN sudo apt-get install dkms
RUN sudo modprobe vboxdrv
RUN sudo modprobe vboxnetflt
RUN sudo apt-get install linux-headers-generic



RUN sudo apt-get install virtualbox-dkms
RUN sudo dpkg-reconfigure virtualbox-dkms
#RUN sudo dpkg-reconfigure virtualbox
RUN sudo apt-get install linux-headers-generic




#RUN yes | sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
#RUN sudo systemctl enable libvirtd
#RUN yes | sudo apt-get install virtinst
#RUN sudo service libvirtd start
#RUN cd /var/lib/libvirt/boot/
#RUN wget https://atxfiles.netgate.com/mirror/downloads/pfSense-CE-2.6.0-RELEASE-amd64.iso.gz
#RUN gzip -d pfSense-CE-2.6.0-RELEASE-amd64.iso.gz
#RUN sudo virt-install --os-variant freebsd9.3 --network=default --name Pfsense --ram=512 --vcpus=1 --cpu host --hvm --disk path=/var/lib/libvirt/images/Pfsense,size=8 --cdrom /var/lib/libvirt/boot/pfSense-CE-2.6.0-RELEASE-amd64.iso --graphics vnc



RUN VBoxManage storageattach "Pfsense" --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium pfSense-CE-2.6.0-RELEASE-amd64.iso 
RUN VBoxManage modifyvm "Pfsense" --vrde on


RUN VBoxHeadless --startvm "Pfsense"

RUN wget https://cdimage.kali.org/kali-2023.1/kali-linux-2023.1-virtualbox-amd64.7z
RUN echo -e "lab instructions:\n\n. open virtualbox.\n\n.you can see Pfsense has been installed for you. some further installation and configuration is required to be done. do it.\n\n.after configuration go to shell and find the IP address of Pfsense.\n\n. on Dektop the virtualbox file of Kali has been downloaded. simply add it to Virtualbox. no installation is needed and this process is simple.\n\n. you need to do some changes to the network settings of both machine. for Pfsense add two network interfaces. the first one is for WAN and the second one is for LAN. WAN network should be set as NAT or bridge. LAN interface should be set as internal network. all the future machines will be connected to each other through this internal network.\n\n. open a terminal in Kali and set the IP of Pfsense as your default gateway.\n\n. go to the address https://[IP address of Pfsense machine]. username and password have not been changed. find the default credentials on the internet.\n\n. work with firewall and complete your assignments. you are free to virtualize more machines by simply copying the Kali file or just by cloning it." > ~/Desktop/Instructions.txt
# Run installations
RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
