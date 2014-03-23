#!/usr/bin/bash

printf '#!/bin/sh\n\nexec java -classpath "$0" org.objectweb.asm.util.ASMifier "$@"\n\n' > ~/bin/asmifier
curl 'http://central.maven.org/maven2/org/ow2/asm/asm-all/5.0.1/asm-all-5.0.1.jar' >> ~/bin/asmifier
chmod +x ~/bin/asmifier
