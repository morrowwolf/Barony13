#!/bin/bash
set -e

if [ "$BUILD_TOOLS" = true ]; then
    cd tgui && source ~/.nvm/nvm.sh && npm install && npm cache clean --force && DEL "package-lock.json" && cd ..
fi;

