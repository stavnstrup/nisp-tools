java -jar saxon-he-10.3.jar ^
  new.profile.source.dir=../../../src/standards/fmn4-20210112-baseline ^
  new.profile.source.name=nisp-fmn4-20210112.xml ^
  -xsl:addprofile2nispdb.xsl ^
  -s:../../../src/standards/standards.xml ^
  -o:../../../src/standards/fmn4-20210112-baseline/standards.xml
