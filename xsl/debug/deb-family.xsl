<?xml version="1.0" encoding="ISO-8859-1"?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>

<!--

This stylesheet is created for the NISP , and is
intended to create an parent/child relationship in the standard database.

Copyright (c) 2003, 2010  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default saxon">
  

<xsl:output method="html" encoding="ISO-8859-1" indent="yes"/>


<xsl:template match="standards">
  <xsl:message>Generating parent/child relationship in DB.</xsl:message>
  <html>
    <head>
      <title>Parent/Child relationships in the NISP Standard Database</title>
      <style type="text/css">
        .head {background-color: #808080;  }
        .body,table {font-family: sans-serif;}
        .table {width: 100%;}
        .deleted { background-color: #FF5A41; color: white; font-weight: bold;}
        .missing { background-color: #FFFEA0;}
        .head { }
      </style>
    </head>
    <body>

    <h1>Parent/Child relationships in the NISP Standard Database</h1>

    <p>Created on 
    <xsl:variable name="date">
      <xsl:value-of select="date:date-time()"/>
    </xsl:variable>

    <xsl:value-of select="date:month-abbreviation($date)"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="date:day-in-month()"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="date:year()"/>
    <xsl:text> - </xsl:text>
    <xsl:value-of select="substring-before(substring-after($date, 'T'),'+')"/>
    </p>
   

    <p>Note:
      <ul>
        <li>Standards and profiles marked with redbackground have been deleted</li>
        <li>Cells with yellow background should be filled out.</li>
        <li>If a reference to a child/parent standard/profile is prefixed with '@ ' it has been deleted. N.B. It is ok if a parent standard/profile have been deleted, but it is NOT OK if a child standard/profile have been deleted. It does not make sence to refere to a deleted child standard/profile.</li>
      </ul>
    </p>

  <h2>Standards</h2>
  

  <table border="1">
    <tr class="head">
      <td><b>ID</b></td>
      <td><b>Type</b></td>
      <td><b>Org</b></td>
      <td><b>PubNum</b></td>
      <td><b>Title</b></td>
      <td><b>Date</b></td>
      <td><b>Standard<br/>Children</b></td>
      <td><b>Standard<br/>Parent</b></td>
      <td><b>Profile<br/>Parents</b></td>
    </tr>
    <xsl:apply-templates select="records/standard">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </table>

  <h2>Profiles</h2>
    
  <table border="1">
    <tr class="head">
      <td><b>ID</b></td>
      <td><b>Type</b></td>
      <td><b>Org</b></td>
      <td><b>PubNum</b></td>
      <td><b>Title</b></td>
      <td><b>Date</b></td>
      <td><b>Standard<br/>Children</b></td>
      <td><b>Profile<br/>Children</b></td>
      <td><b>Profile<br/>Parents</b></td>
    </tr>
    <xsl:apply-templates select="//profile">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </table>
  </body></html>
</xsl:template>


<xsl:template match="standard">
  <xsl:variable name="myid" select="@id"/>
  <tr>
    <xsl:if test=".//event[@flag = 'deleted']">
      <xsl:attribute name="class">deleted</xsl:attribute>
    </xsl:if>
    <td><a name="{@id}"><xsl:value-of select="@id"/></a></td>
    <td align="center">
      <xsl:choose>
        <xsl:when test="document/substandards">CS</xsl:when>
        <xsl:when test="//substandards/refstandard/@refid=$myid">SS</xsl:when>
        <xsl:otherwise>S</xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:if test="@orgid =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@orgid"/>
    </td>
    <td>
      <xsl:if test="document/@pubnum =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@pubnum"/>
    </td>
    <td>
      <xsl:if test="document/@title =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@title"/>
    </td>
    <td>
      <xsl:if test="document/@date =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@date"/>
    </td>
    <td><xsl:apply-templates select=".//refstandard"/></td>
    <td><xsl:apply-templates select="//standard[document/substandards/refstandard/@refid=$myid]" mode="parent"/></td>
    <td><xsl:apply-templates select="//profile[parts/refstandard/@refid=$myid]" mode="parent"/></td>
  </tr>
</xsl:template>


<xsl:template match="profile">
  <xsl:variable name="myid" select="@id"/>
  <tr>
    <xsl:if test=".//event[@flag = 'deleted']">
      <xsl:attribute name="class">deleted</xsl:attribute>
    </xsl:if>
    <td><a name="{@id}"><xsl:value-of select="@id"/></a></td>
    <td align="center">
      <xsl:choose>
        <xsl:when test="@type='base'">BP</xsl:when>
        <xsl:when test="@type='coi'">C</xsl:when>
        <xsl:otherwise>CM</xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:if test="@orgid =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@orgid"/>
    </td>
    <td>
      <xsl:if test="d/@pubnum =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@pubnum"/>
    </td>
    <td>
      <xsl:if test="document/@title =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@title"/>
    </td>
    <td>
      <xsl:if test="document/@date =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@date"/>
    </td>
    <td><xsl:apply-templates select=".//refstandard"/></td>        
    <td><xsl:apply-templates select=".//refprofile"/></td>        
    <td><xsl:apply-templates select="//profile[parts/refprofile/@refid=$myid]" mode="parent"/></td>
  </tr>
</xsl:template>




<xsl:template match="standard|profile" mode="parent">
  <xsl:if test="position() != 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:if test=".//event[@flag = 'deleted']"><emphasis role="bold">@ </emphasis></xsl:if><a href="#{@id}"><xsl:value-of select="@id"/></a>
</xsl:template>


<xsl:template match="refstandard">
  <xsl:variable name="myrefid" select="@refid"/>
  <xsl:if test="position() != 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:if test="/standards/records/standard[@id=$myrefid]//event[@flag='deleted']">
    <emphasis role="bold">@ </emphasis>
  </xsl:if>
  <a href="#{@refid}"><xsl:value-of select="@refid"/></a>
</xsl:template>


<xsl:template match="refprofile">
  <xsl:variable name="myrefid" select="@refid"/>
  <xsl:if test="position() != 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:if test="//profile[@id=$myrefid]//event[@flag='deleted']">
    <emphasis role="bold">@ </emphasis>
  </xsl:if>
  <a href="#{@refid}"><xsl:value-of select="@refid"/></a>
</xsl:template>


</xsl:stylesheet>
