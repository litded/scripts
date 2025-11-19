#!/bin/bash

VMNAME=$(cat /var/lib/hyperv/.kvp_pool_3 | sed -e 's/.*VirtualMachineName\x00\(.*\)\x00.*/\1/p' -e 's/\x0.*//g')
hostname $VMNAME
sed -iE "s/ localhost.*/ localhost $VMNAME/g" /etc/hosts
