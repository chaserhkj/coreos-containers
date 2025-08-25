#!/bin/bash
rm -rf vendor && mkdir vendor
(cd vendor && git clone --depth=1 --branch=fatbin-fix https://github.com/chaserhkj/SageAttention)
podman build . -t sage-attention-wheel