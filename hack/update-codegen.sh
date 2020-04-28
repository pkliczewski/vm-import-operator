#!/usr/bin/env bash

# Copyright 2017 The Kubernetes Authors.
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

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
if [ ! -d "$GOPATH/src/github.com/kubernetes/code-generator" ]
then
    wget https://github.com/kubernetes/code-generator/archive/v0.16.4.tar.gz -P /tmp
    tar -zxf /tmp/v0.16.4.tar.gz -C /tmp
    rm /tmp/v0.16.4.tar.gz
    if [ ! -d "$GOPATH/src/github.com/kubernetes" ]
    then
      mkdir -p $GOPATH/src/github.com/kubernetes
    fi
    mv /tmp/code-generator-0.16.4 $GOPATH/src/github.com/kubernetes/code-generator
fi
CODEGEN_PKG=$GOPATH/src/github.com/kubernetes/code-generator

# generate the code with:
# --output-base    because this script should also be able to run inside the vendor dir of
#                  k8s.io/kubernetes. The output-base is needed for the generators to output into the vendor dir
#                  instead of the $GOPATH directly. For normal projects this can be dropped.
bash "${CODEGEN_PKG}"/generate-groups.sh "client" \
  github.com/kubevirt/vm-import-operator/pkg/api-client github.com/kubevirt/vm-import-operator/pkg/apis \
  v2v:v1alpha1 \
  --fake-clientset=false \
  --output-base "$SCRIPT_ROOT/../../../" \
  --go-header-file "${SCRIPT_ROOT}"/hack/boilerplate.go.txt
