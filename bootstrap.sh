#!/bin/bash

REF=origin/${REF:-master}

echo "Bootstrappin"

git fetch origin
git reset --hard $REF

npm install
npm run build
npm start
