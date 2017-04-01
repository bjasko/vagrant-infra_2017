#!/bin/bash

VBoxManage createmedium --format VDI --size 50000 --filename srv1bout.vdi

for f in rcli1 rcli2
do
    VBoxManage createmedium --format VDI --size 40000 --filename $f.vdi
done
