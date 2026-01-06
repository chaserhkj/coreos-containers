mod bootc 'bootc/'

build_args := ""

default context:
    tag=$(basename {{context}}) && \
    podman build {{context}} {{build_args}}