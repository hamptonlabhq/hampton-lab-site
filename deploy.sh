#!/bin/bash
bin/rails server
mkdir -p deploy
wget --convert-links --mirror --adjust-extension http://127.0.0.1:3000/
