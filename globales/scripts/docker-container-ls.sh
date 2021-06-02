#!/bin/bash

# docker container ls --format '{{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}'
docker container ls --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'