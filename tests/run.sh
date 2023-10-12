#!/bin/bash -ex

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${script_dir}/..
  # echo "-----> `date`: Upload stemcell"
  # bosh -n upload-stemcell --sha1 a7149636b910f9be940e9ccaf73b12f32d5d2bd7 \
  # https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-jammy-go_agent?v=1.260

  echo "-----> `date`: Update Cloud Config"
  bosh -n update-cloud-config ./manifests/cloud-config.yml

  echo "-----> `date`: Delete previous deployment"
  bosh -n -d test delete-deployment --force

  echo "-----> `date`: Deploy"
  bosh -n -d test deploy ./manifests/test.yml -v stemcell="ubuntu-jammy"

  release_version=$(bosh releases | grep elixir | head -n1 | sed 's/.*dev\./0+dev./g' | sed 's/\*.*//g')

  echo "----> `date`: Export to test compilation"
  mkdir -p ./releases
  bosh -n -d test export-release "elixir/${release_version}" "ubuntu-jammy/1.260" --dir ./releases

  echo "-----> `date`: Run test errand"
  bosh -n -d test run-errand otp-26-test
  bosh -n -d test run-errand elixir-1.15-otp-26-test

  echo "-----> `date`: Delete deployments"
  bosh -n -d test delete-deployment

  echo "-----> `date`: Done"
popd
