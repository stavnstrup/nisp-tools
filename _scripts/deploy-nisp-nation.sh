#!/bin/bash

# Deployment to nisp.nw3.dk

# Enable error reporting to the console.
set -e

# Checkout Web generation tool package
git clone https://${GH_TOKEN}@github.com/stavnstrup/nisp-nation.git ../nisp-nation.master
cd ../nisp-nation.master

# Generate yaml and json representation of NISP database elements
saxonb-xslt -ext:on ../nisp-tools/src/standards/standards.xml debug.xsl
