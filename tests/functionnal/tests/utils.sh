#!/usr/bin/env bash

function sanity_check {
echo "-SANITY CHECK-"
BASE_DIR=$1

# shellcheck disable=SC1091
. current/admin-openrc

echo "-OPENSTACK VALIDATION-"
sleep 15
openstack endpoint list
openstack image list
openstack flavor list
nova --debug service-list
neutron --debug agent-list
nova\
  --debug\
  boot\
  --poll\
  --image cirros.uec\
  --flavor m1.tiny\
  --nic net-id="$(openstack network show private --column id --format value)"\
  jenkins-vm
nova delete jenkins-vm

echo "-ENOS BENCH-"
enos bench --workload="$BASE_DIR/enos/workload"

echo "-ENOS BACKUP-"
enos backup

echo "-/SANITY CHECK-"
}
