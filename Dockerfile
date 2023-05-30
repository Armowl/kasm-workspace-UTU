
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
#RUN wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
#RUN wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
#RUN echo "deb [arch=amd64] http://virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
RUN yes | sudo apt install virtualbox
#RUN sudo apt-get install virtualbox-6.1
#RUN wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
RUN wget https://download.virtualbox.org/virtualbox/6.1.26/Oracle_VM_VirtualBox_Extension_Pack-6.1.26.vbox-extpack
#RUN yes | sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.1.26.vbox-extpack
#RUN sudo groupadd vboxusers
#RUN sudo useradd -g vboxusers kasm-user
RUN sudo echo 'VBOXWEB_USER="kasm-user"/nVBOXWEB_TIMEOUT=0/nVBOXWEB_LOGFILE="/var/log/vboxwebservice.log"/nVBOXWEB_HOST="127.0.0.1"' > /etc/default/virtualbox
RUN sudo touch /var/log/vboxwebservice.log
RUN sudo chown kasm-user:vboxusers /var/log/vboxwebservice.log
RUN sudo mkdir /home/kasm-user/.VirtualBox
RUN sudo chown kasm-user:vboxusers /home/kasm-user/.VirtualBox
#RUN sudo service vboxweb-service start
#RUN sudo apt-get install libgtk2-perl libsoap-lite-perl rdesktop
#RUN sudo yum install perl-Gtk2 perl-SOAP-Lite rdesktop
RUN VBoxManage createvm --name "Pfsense" --ostype BSD --register
RUN VBoxManage createhd --filename "Pfsense.vdi" --size 5000
RUN VBoxManage storagectl "Pfsense" --name "IDE Controller" --add ide --controller PIIX4
RUN VBoxManage storageattach "Pfsense" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium "Pfsense.vdi"
RUN wget https://atxfiles.netgate.com/mirror/downloads/pfSense-CE-2.6.0-RELEASE-amd64.iso.gz
RUN gzip -d pfSense-CE-2.6.0-RELEASE-amd64.iso.gz
RUN yes | sudo apt-get install build-essential linux-headers-`uname -r` dkms virtualbox-dkms
RUN sudo apt-get install dkms
RUN sudo modprobe vboxdrv
RUN sudo modprobe vboxnetflt
RUN sudo apt-get install linux-headers-generic
RUN VBoxManage storageattach "Pfsense" --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium pfSense-CE-2.6.0-RELEASE-amd64.iso
RUN VBoxManage modifyvm "Pfsense" --vrde on
# RUN VBoxHeadless --startvm "Pfsense"
RUN wget https://cdimage.kali.org/kali-2023.1/kali-linux-2023.1-virtualbox-amd64.7z
RUN echo -e "lab instructions:\n\n. open virtualbox.\n\n.you can see Pfsense has been installed for you. some further installation and configuration is required to be done. do it.\n\n.after configuration go to shell and find the IP address of Pfsense.\n\n. on Dektop the virtualbox file of Kali has been downloaded. simply add it to Virtualbox. no installation is needed and this process is simple.\n\n. you need to do some changes to the network settings of both machine. for Pfsense add two network interfaces. the first one is for WAN and the second one is for LAN. WAN network should be set as NAT or bridge. LAN interface should be set as internal network. all the future machines will be connected to each other through this internal network.\n\n. open a terminal in Kali and set the IP of Pfsense as your default gateway.\n\n. go to the address https://[IP address of Pfsense machine]. username and password have not been changed. find the default credentials on the internet.\n\n. work with firewall and complete your assignments. you are free to virtualize more machines by simply copying the Kali file or just by cloning it." > ~/Desktop/Instructions.txt
# Run installations
RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
