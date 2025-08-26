#!/bin/bash
rm -rf vendor && mkdir vendor
(cd vendor && git clone --depth=1 https://github.com/mit-han-lab/radial-attention)
podman build . -t radial-attention-wheel