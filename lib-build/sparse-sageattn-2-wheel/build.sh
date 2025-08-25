#!/bin/bash
rm -rf vendor && mkdir vendor
(cd vendor && git clone --depth=1 https://github.com/Radioheading/Block-Sparse-SageAttention-2.0)
podman build . -t sparse-sageattn-2-wheel