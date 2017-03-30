#!/bin/bash

echo "chisel wsocket :8080 -> nginx proxy -> :80" 

/home/vagrant/go/bin/chisel  server --port 8080&

