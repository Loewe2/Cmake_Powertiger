#!/usr/bin/env bash

set -ex

sed -i 's/-lhdf5/$hdf5_lib\/libhdf5.a -ldl/g' configure
