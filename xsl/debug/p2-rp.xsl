<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default date saxon">

<xsl:output method="html" indent="yes"/>
  
<xsl:key name="key1" match="standard" use="responsibleparty/@rpref"/>


<xsl:template match="standards">
  <html>
    <meta charset="utf-8" />
    <head><title>List responsible parties</title></head>
    <style type="text/css">
      table {
         border-collapse: collapse;
      }
      td, th {
        padding: 1px 4px;
      }
    </style>
  <body>
    <h1>List responsible parties</h1>

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
    <xsl:text> using rev. </xsl:text><xsl:value-of select="@describe"/></p>
    <xsl:apply-templates select="records"/>
  </body></html>
</xsl:template>


<xsl:template match="records">
  <ul>
  <xsl:for-each select="standard[generate-id() = generate-id(key('key1', responsibleparty/@rpref)[1])]">
    <xsl:sort select="responsibleparty/@rpref"/>

    <xsl:variable name="rp" select="responsibleparty/@rpref"/>
    <li>
      <a>
	<xsl:attribute name="href">
	  <xsl:text>#</xsl:text>
	  <xsl:value-of select="$rp"/>
	</xsl:attribute>
	<xsl:value-of select="../../responsibleparties/rpkey[@key=$rp]/@long"/>
      </a>
    </li>
  </xsl:for-each>
  </ul>

  <hr />
  
  <xsl:for-each select="standard[generate-id() = generate-id(key('key1', responsibleparty/@rpref)[1])]">
    <xsl:sort select="responsibleparty/@rpref"/>

    <xsl:variable name="rp" select="responsibleparty/@rpref"/>

    
    <h2 id="{$rp}">
      <xsl:value-of select="../../responsibleparties/rpkey[@key=$rp]/@long"/>
    </h2>

    <xsl:if test="$rp != 'undefined'">
      <xsl:variable name="poc" select="../../responsibleparties/rpkey[@key=$rp]/pointofcontact"/>
      <p><strong>POC: </strong> <xsl:value-of select="$poc/@name"/>
      <xsl:if test="$poc/@email != ''">
	<xsl:text>, email: </xsl:text>
	<xsl:value-of select="$poc/@email"/>
      </xsl:if>
      <xsl:if test="$poc/@phone != ''">
	<xsl:text>, phone: </xsl:text>
	<xsl:value-of select="$poc/@phone"/>
      </xsl:if>
      </p>
    </xsl:if>
    
    <table border='1'>
      <tr>
	<th>Org</th>
	<th>Pubnum</th>
	<th>Title</th>
      </tr>
      <xsl:for-each select="key('key1', responsibleparty/@rpref)">
	<tr>
	  <td><xsl:value-of select="document/@orgid"/></td>
	  <td><xsl:value-of select="document/@pubnum"/></td>
	  <td><xsl:value-of select="document/@title"/></td>
	</tr>
      </xsl:for-each>
    </table>
  </xsl:for-each>
</xsl:template>    

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
