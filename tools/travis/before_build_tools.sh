#!/bin/bash
set -e

if [ "$BUILD_TOOLS" = true ]; then
    cd tgui && source ~/.nvm/nvm.sh && npm cache clear --force && npm i -g npm && npm install gulp && cd ..
fi;

