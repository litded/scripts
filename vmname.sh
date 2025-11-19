#!/bin/bash

VMNAME=$(sed -n 's/.*VirtualMachineName\x00\(.*\)\x00.*/\1/p' /var/lib/hyperv/.kvp_pool_3' -e 's/\x0.*//g')
hostname $VMNAME
sed -iE "s/ localhost.*/ localhost $VMNAME/g" /etc/hosts
