# Создание виртуальной машины из готового темплейта (vhdx диска)
# .\hyper-v-add-vm.ps1 -name centos -mem 4 -temp centos -sw HV -disk G -cpu 2

# $name - имя новой виртуальной машины
# $mem - выделяемое количество гигабайт при старте 
# $temp - имя диска темплейта до .vhdx
# $sw - имя сетевого интерфейса
# $disk - буква диска для vhd
# $cpu - количество ядер

# Все параметры не обязательны, смотрите дефолтные параметры в блоках if

# При подготовки темплейтов
# Установите ос, и экспортируйте в любую папку, а затем перенесите диск в папку на которую указывает переменная $iso
# Чтобы получить ip на последнем шаге в debian 10 и ниже, установите:
# apt-get install hyperv-daemons
# Скопируйте загрузчик
# cd /boot/efi/EFI && cp -r debian/ boot && cd boot && mv shimx64.efi bootx64.efi
# 
# В ubuntu 20.04:
# for i in hv_utils hv_vmbus hv_storvsc hv_blkvsc hv_netvsc; do echo $i >> /etc/initramfs-tools/modules; done
# apt install linux-virtual linux-cloud-tools-virtual linux-tools-virtual
# update-initramfs -u


Param (
[string]$name,
[System.Int64]$mem,
[string]$temp,
[string]$sw,
[string]$disk,
[System.Int64]$cpu
)
if ($name -eq ""){$name = "vm"+$(Get-Date -format "yyMMddmm")}
if ($mem -eq ""){$mem=2*1073741824} else{$mem=$mem*1073741824}
if ($temp -eq ""){$iso="E:\Hyper-V\template\deb10.vhdx"} else {$iso="E:\Hyper-V\template\$temp.vhdx"}
if ($sw -eq ""){$sw="Default Switch"}
if ($disk -eq ""){$ptch = "E:\Hyper-V\Virtual Hard Disks\$name.vhdx"} else {$ptch = $disk+":\Hyper-V\Virtual Hard Disks\$name.vhdx"}
if ($cpu -eq ""){$cpu=2}

Write-Output "COPPY VD"
Copy-Item -Path $iso -Destination $ptch

Write-Output "NEW VM"
New-VM -Name $name -MemoryStartupBytes $mem -BootDevice VHD -VHDPath "$ptch" -Generation 2 -Switch "$sw"
Set-VMFirmware -VMName $name -EnableSecureBoot Off
Set-VM -Name $name -AutomaticCheckpointsEnabled $false
Set-VMProcessor $name -Count $cpu 
Set-VMMemory $name -DynamicMemoryEnabled $true -MinimumBytes 64MB -MaximumBytes 8GB

Write-Output "STARTING VM"
Start-VM -Name $name

Start-Sleep -s 60

Write-Output "GET IP"
get-vm $name | select -ExpandProperty networkadapters | select vmname, macaddress, switchname, ipaddresses
