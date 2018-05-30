#!/usr/bin/env bash

vagrant_plugin_list="$(vagrant plugin list)"

if ! echo ${vagrant_plugin_list} | grep "vagrant-hostmanager" ; then
    vagrant plugin install vagrant-hostmanager
fi
if ! echo ${vagrant_plugin_list} | grep "vagrant-vbguest" ; then
    vagrant plugin install vagrant-vbguest
fi

vagrant up --provider virtualbox --provision