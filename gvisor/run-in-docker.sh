#!/bin/bash

if [ ! -d "gvisor" ]; then
    git clone https://cnb.cool/DragonOS-Community/gvisor -b dragonos/release-20250616.0 --depth 1
fi

docker run -it --rm -v $(pwd)/gvisor:/workspace/gvisor -v $(pwd)/compile-syscall-test.sh:/workspace/compile-syscall-test.sh \
     -v $(pwd)/results:/workspace/results \
     gvisor-build-env bash
