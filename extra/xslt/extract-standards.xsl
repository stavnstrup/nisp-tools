<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
                xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
                xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
                xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
                xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
                xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
                xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
                xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
                xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
                xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
                xmlns:math="http://www.w3.org/1998/Math/MathML"
                xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
                xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
                xmlns:ooo="http://openoffice.org/2004/office"
                xmlns:ooow="http://openoffice.org/2004/writer"
                xmlns:oooc="http://openoffice.org/2004/calc"
                xmlns:dom="http://www.w3.org/2001/xml-events"
                xmlns:xforms="http://www.w3.org/2002/xforms"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="office style text table draw fo xlink dc meta number svg
                                         chart dr3d math form script ooo ooow oooc dom xforms
                                         xsd xsi xdt xs"
                version="2.0">

<!-- 

Generate standard elements from data taken from an content.xml file in
an Open Office document, with the follwing rows:

          org, pubnum, title, date, applicability, uri & tag

The spreadsheet can be created with Excell and then saved as an open
office document.

Extract the file content.xml and apply this stylesheet.

The stylesheet assumes there is only one sheet in the worksbook.

After the standards have been imported in the database, remember to run

    build -f uuid-build.xml

to generate uuids.

Copyright (c) 2014  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->


<xsl:output indent="yes"/>

<xsl:variable name="next.version" select="'9.0'"/>

<!-- Get current date & time adjusted to UTC -->

<xsl:variable name="now">
  <xsl:value-of select="adjust-dateTime-to-timezone(
       current-dateTime(), xs:dayTimeDuration('PT0H'))"/>
</xsl:variable>


<xsl:template match="office:document-content">
  <new-standards>
    <xsl:apply-templates/>
  </new-standards>
</xsl:template>


<xsl:template match ="office:font-face-decls|office:automatic-styles|office:forms|table:table-column"/>


<xsl:template match="office:body|office:spreadsheet">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="table:table">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="table:table-row[position()=1]"/>


<xsl:template match="table:table-row[table:table-cell[position()=1]='']"/>


<xsl:template match="table:table-row">
  <standard>
    <xsl:attribute name="id">
      <xsl:value-of select="table:table-cell[position()=1]"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="lower-case(table:table-cell[position()=2])"/>
    </xsl:attribute>
    <xsl:attribute name="tag">
      <xsl:value-of select="table:table-cell[position()=7]"/>      
    </xsl:attribute>
    <document>
      <xsl:attribute name="orgid">
        <xsl:value-of select="table:table-cell[position()=1]/text:p"/>
      </xsl:attribute>
      <xsl:attribute name="pubnum">
        <xsl:value-of select="table:table-cell[position()=2]/text:p"/>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:value-of select="table:table-cell[position()=3]/text:p"/>
      </xsl:attribute>
      <xsl:attribute name="date">
        <xsl:value-of select="substring(table:table-cell[position()=4]/@office:date-value, 1, 10)"/>
      </xsl:attribute>
    </document>
    <applicability><xsl:value-of select="table:table-cell[position()=5]/text:p"/></applicability>
    <status mode="accepted">
      <uri><xsl:value-of select="table:table-cell[position()=6]/text:p"/></uri>
      <history>
        <event date="{substring($now, 1, 10)}" flag="added" rfcp="" version="{$next.version}"/>
      </history>
    </status>
  </standard> 
<xsl:text>

</xsl:text>
</xsl:template>

</xsl:stylesheet>
