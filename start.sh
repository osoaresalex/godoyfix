#!/bin/bash
# Use the Painel startup script so we run the full cache-clear + serve flow there
cd Painel
chmod +x railway-start.sh || true
./railway-start.sh
