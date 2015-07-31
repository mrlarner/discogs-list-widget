#!/bin/bash

REF=origin/${REF:-master}

git fetch origin
git reset --hard $REF

npm install
npm run build
npm start
