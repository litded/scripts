Небольшие скрипты, которые я пишу для своих нужд. 

# Создание виртуальной машины из готового темплейта (vhdx диска)

.\hyper-v-add-vm.ps1 -name centos -mem 4 -temp centos -sw HV -disk G -cpu 2

$name - имя новой виртуальной машины

$mem - выделяемое количество гигабайт при старте 

$temp - имя диска темплейта до .vhdx

$sw - имя сетевого интерфейса

$disk - буква диска для vhd

$cpu - количество ядер

Все параметры не обязательны, смотрите дефолтные параметры в блоках if

# При подготовке темплейтов

Установите ос, и экспортируйте VM в любую папку, а затем перенесите диск в папку на которую указывает переменная $iso 

В debian 10 и ниже, установите:

apt-get install hyperv-daemons

И скопируйте загрузчик

cd /boot/efi/EFI && cp -r debian/ boot && cd boot && mv shimx64.efi bootx64.efi

В ubuntu 20.04:

for i in hv_utils hv_vmbus hv_storvsc hv_blkvsc hv_netvsc; do echo $i >> /etc/initramfs-tools/modules; done

apt install linux-virtual linux-cloud-tools-virtual linux-tools-virtual

update-initramfs -u


Нашёл способ подхватывать имена машин, проверил только на ubuntu 20.04

VMNAME=$(cat /var/lib/hyperv/.kvp_pool_3 | sed -e 's/^.*VirtualMachineName\x0*//g' -e 's/\x0.*//g') && sudo hostname $VMNAME && sudo sed -iE "s/ localhost.*/ localhost $VMNAME/g" /etc/hosts

 chmod 744 /usr/local/bin/vmname.sh

 chmod 664 /etc/systemd/system/vmname.service

 systemctl daemon-reload
 
 systemctl enable vmname.service
