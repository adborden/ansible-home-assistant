#!/bin/bash

set -o errexit
set -o pipefail


function usage () {
  cat <<EOF
$0: <container...>

Pull the latest image the container is running. If it's different from the running container, restart it.

  container: name of the conatiner.

EOF
}

function process () {
  local container image sha_container sha_image
  container="$1"
  image="$(docker container inspect --format='{{ .Config.Image }}' $container)"
  docker pull --quiet $image > /dev/null

  sha_container="$(docker container inspect --format='{{ .Image }}' $container)"
  sha_image="$(docker image inspect --format='{{ .Id }}' $image)"
  if [[ "$sha_container" != "$sha_image" ]]; then
    echo "Applying update container=$container image=$image"
    systemctl restart ${container}.service
  fi
}


if [[ "$#" -eq 0 ]]; then
  usage >&2
  exit 1
fi


while [[ "$#" -gt 0 ]]; do
  container="$1"
  shift

  process "$container"
done
