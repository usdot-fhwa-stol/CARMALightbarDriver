#!/bin/bash

#  Copyright (C) 2018-2020 LEIDOS.
# 
#  Licensed under the Apache License, Version 2.0 (the "License"); you may not
#  use this file except in compliance with the License. You may obtain a copy of
#  the License at
# 
#  http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#  License for the specific language governing permissions and limitations under
#  the License.

# CARMA packages checkout script
# Optional argument to set the root checkout directory with no ending '/' default is '~'

set -exo pipefail

dir=~
while [[ $# -gt 0 ]]; do
      arg="$1"
      case $arg in
            -d|--develop)
                  BRANCH=develop
                  shift
            ;;
            -c|--candidate)
                  echo "Enter branch name:"
                  BRANCH=$(git rev-parse --abbrev-ref HEAD)
                  if ! echo "$BRANCH" | grep -q "release/.*"; then
                        echo "Please switch to a release branch before using the -c option. Exiting script now."
                        exit 1
                  fi
                  shift
            ;;
            -r|--root)
                  dir=$2
                  shift
                  shift
            ;;
      esac
done

if [[ "$BRANCH" = "develop" ]]; then
      git clone https://github.com/usdot-fhwa-stol/carma-msgs.git ~/src/CARMAMsgs --branch $BRANCH --depth 1
      git clone https://github.com/usdot-fhwa-stol/carma-utils.git ~/src/CARMAUtils --branch $BRANCH --depth 1
elif echo "$BRANCH" | grep -q "release/.*"; then
      git clone https://github.com/usdot-fhwa-stol/carma-msgs.git ~/src/CARMAMsgs --branch $BRANCH --depth 1
      git clone https://github.com/usdot-fhwa-stol/carma-utils.git ~/src/CARMAUtils --branch $BRANCH --depth 1
else
      git clone https://github.com/usdot-fhwa-stol/carma-msgs.git ${dir}/src/CARMAMsgs --branch release/Wanderer --depth 1
      git clone https://github.com/usdot-fhwa-stol/carma-utils.git ${dir}/src/CARMAUtils --branch release/Wanderer --depth 1
fi
