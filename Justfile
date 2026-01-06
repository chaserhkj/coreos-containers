mod bootc 'bootc/'

build_args := ""

build context:
    tag=$(basename {{context}}) && \
    podman build {{context}} -t $tag {{build_args}}