#!/usr/bin/env bash
################################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

HERE=` basename "$PWD"`
if [[ "$HERE" != "docs" ]]; then
    echo "Please only execute in the docs/ directory";
    exit 1;
fi

function integrate_connector_docs {
  local connector ref additional_folders
  connector=$1
  ref=$2

  git clone --single-branch --branch ${ref} https://github.com/apache/flink-connector-${connector}
  theme_dir="../themes/connectors"
  mkdir -p "${theme_dir}"

  cp -r flink-connector-${connector}/docs/* "${theme_dir}/"
}


SKIP_INTEGRATE_CONNECTOR_DOCS=false
for arg in "$@"; do
  if [ "$arg" == "--skip-integrate-connector-docs" ]; then
    SKIP_INTEGRATE_CONNECTOR_DOCS=true
    break
  fi
done

# Integrate the connector documentation
if [ "$SKIP_INTEGRATE_CONNECTOR_DOCS" = false ]; then
  rm -rf themes/connectors/*
  rm -rf tmp
  mkdir tmp
  cd tmp

  integrate_connector_docs elasticsearch v4.0
  integrate_connector_docs aws v5.0
  integrate_connector_docs cassandra v3.2
  integrate_connector_docs pulsar v4.0
  integrate_connector_docs jdbc v3.1
  integrate_connector_docs rabbitmq v3.0
  integrate_connector_docs gcp-pubsub v3.0
  integrate_connector_docs mongodb v2.0
  integrate_connector_docs opensearch v1.2
  integrate_connector_docs kafka v4.0
  integrate_connector_docs hbase v4.0
  integrate_connector_docs prometheus v1.0
  integrate_connector_docs hive v3.0

  cd ..
  rm -rf tmp
fi
