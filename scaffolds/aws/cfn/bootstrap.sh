#!/bin/sh

echo "Starting bootstrap of network!"
stackup vibrato-network up -t template.yml -p parameters.yml