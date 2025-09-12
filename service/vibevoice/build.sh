#!/bin/bash
rm -rf vendor && mkdir vendor
(cd vendor && git clone --depth=1 https://github.com/microsoft/VibeVoice)
podman build . -t vibevoice