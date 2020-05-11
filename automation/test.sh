#!/bin/bash
#
# This file is part of the KubeVirt project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Copyright 2017 Red Hat, Inc.
#

# CI considerations: $TARGET is used by the jenkins build, to distinguish what to test
# Currently considered $TARGET values:
#     kubernetes-release: Runs all functional tests on a release kubernetes setup
#     openshift-release: Runs all functional tests on a release openshift setup

set -ex

export KUBEVIRT_PROVIDER=$TARGET

make cluster-down
make cluster-up
make cluster-sync

# Run functional tests
./cluster/kubectl.sh create -f tests/cirros/secret.yml

KUBECONFIG=$(./cluster/kubeconfig.sh)
go test ./tests --v -timeout 30m -kubeconfig "$KUBECONFIG" -ovirt-secret "default/ovirt-secret"
