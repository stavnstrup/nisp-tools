#!/bin/sh
# Create added standards list
saxon91 -o added-standards.html ../../../src/standards/standards.xml add1.xsl
pandoc -o raw-added-standards.xml --id-prefix=ADD- -t DocBook added-standards.html
rm added-standards.html
saxon91 -o ../../../src/volume1/added-standards.xml raw-added-standards.xml fix-sect.xsl
# Create added standards list
saxon91 -o deleted-standards.html ../../../src/standards/standards.xml del1.xsl
pandoc -o raw-deleted-standards.xml --id-prefix=DEL- -t DocBook deleted-standards.html
rm deleted-standards.html
saxon91 -o ../../../src/volume1/deleted-standards.xml raw-deleted-standards.xml fix-sect.xsl
