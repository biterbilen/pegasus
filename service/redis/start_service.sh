#!/bin/bash

# Copyright 2015 Insight Data Science
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

PEG_ROOT=$(dirname ${BASH_SOURCE})/../..
source ${PEG_ROOT}/util.sh

if [ "$#" -ne 1 ]; then
    echo "Please specify cluster name!" && exit 1
fi

CLUSTER_NAME=$1

PUBLIC_DNS=$(fetch_cluster_public_dns ${CLUSTER_NAME})
MASTER_DNS=$(fetch_cluster_master_public_dns ${CLUSTER_NAME})

# Start redis servers
for dns in ${PUBLIC_DNS};
do
  #cmd='/usr/local/redis/src/redis-server /usr/local/redis/redis.conf &'
  cmd='/usr/local/redis/src/redis-server /usr/local/redis/redis.conf --daemonize yes &'
  run_cmd_on_node ${dns} ${cmd} &
done

wait

# begin discovery of redis servers
sleep 5

#script=${PEG_ROOT}/config/redis/join_redis_cluster.sh
script=${PEG_ROOT}/service/redis/join_redis_cluster.sh
args="${PUBLIC_DNS}"
run_script_on_node ${MASTER_DNS} ${script} ${args} &

echo "Redis Started!"
