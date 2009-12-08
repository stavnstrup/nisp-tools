<?xml version="1.0" encoding="ISO-8859-1"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default saxon">
  

<xsl:output method="html" encoding="ISO-8859-1" indent="no"/>


<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="ta-standards">
  <html><body>
  <table border="1">
   <tr><td>SA</td><td>SC</td><td>Tag</td><td>Title</td><td>Mandatory</td><td>Emerging</td><td>RD</td></tr>
    <xsl:apply-templates/>
  </table>
  </body></html>
</xsl:template>


<xsl:template match="servicearea|serviceclass">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="standardrecord|profilerecord">
  <xsl:variable name="id" select="@id"/>

  <xsl:if test=".//standard[@orgid='nato']">
    <tr>
      <td><xsl:value-of select="../../@id"/></td>
      <td><xsl:value-of select="../@cid"/></td>
      <td><xsl:value-of select="./@tag"/></td>
      <td><xsl:apply-templates 
                    select="standard|parts|profilenote"/></td>

      <xsl:call-template name="get-ncsp-rd">
        <xsl:with-param name="id" select="./@id"/>
        <xsl:with-param name="ncspl" select="../ncsp-list"/>
      </xsl:call-template> 
      <td></td>
    </tr>
  </xsl:if>
</xsl:template>


<xsl:template name="get-ncsp-rd">
  <xsl:param name="id" select=""/>
  <xsl:param name="ncspl" select=""/>
  <xsl:choose>
    <xsl:when test="$ncspl/ncsp-view[*/@id=$id]">
      <xsl:apply-templates select="$ncspl/ncsp-view[*/@id=$id]"/>
    </xsl:when>
    <xsl:otherwise>
      <td>&#xa0;</td><td>&#xa0;</td><td>&#xa0;</td>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="ncsp-view">
  <td>&#xa0;<xsl:value-of select="./mandatory"/></td>
  <td>&#xa0;<xsl:value-of select="./emerging"/></td>
  <td>&#xa0;<xsl:value-of select="./fading"/></td>
</xsl:template>


<xsl:template match="standard">
  <xsl:variable name="org" select="@orgid"/>

  <xsl:value-of select="@title"/>
  <xsl:if test="(@orgid != '') or (@pubnum != '') or (@date != '')">
    <xsl:if test="@title != ''"><xsl:text>, </xsl:text></xsl:if>
    <xsl:if test="@orgid != ''">
      <xsl:value-of
         select="ancestor::ta-standards/organisations/orgkey[@key=$org]/@text"/>
    </xsl:if>
    <xsl:if test="(@pubnum != '') or (@date != '')">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="@pubnum != ''">
      <xsl:value-of select="@pubnum"/>
    </xsl:if>
    <xsl:if test="(@pubnum != '') and (@date != '')">
      <xsl:text>:</xsl:text>
    </xsl:if>
    <xsl:value-of select="substring(@date,1,4)"/>
  </xsl:if>
  <xsl:apply-templates select="correction"/>
  <xsl:apply-templates select="alsoknown"/>
  <xsl:apply-templates select="comment"/>
  <xsl:apply-templates select="parts"/>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="correction">
  <xsl:if test="(@cpubnum != '') or (@date != '')">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:if test="@cpubnum != ''">
    <xsl:value-of select="@cpubnum"/>
  </xsl:if>
  <xsl:if test="(@cpubnum != '') and (@date != '')">
    <xsl:text>:</xsl:text>
  </xsl:if>
  <xsl:value-of select="substring(@date, 1, 4)"/>
  <xsl:if test=". != ''">
    <xsl:text> (</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="alsoknown">
  <xsl:text> / </xsl:text>

  <xsl:variable name="org" select="@orgid"/>
  <xsl:if test="@orgid != ''">
    <xsl:value-of
       select="ancestor::ta-standards/organisations/orgkey[@key=$org]/@text"/>
  </xsl:if>
  <xsl:if test="(@pubnum != '') or (@date != '')">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:if test="@pubnum != ''">
    <xsl:value-of select="@pubnum"/>
  </xsl:if>
  <xsl:if test="(@pubnum != '') and (@date != '')">
    <xsl:text>:</xsl:text>
  </xsl:if>
  <xsl:value-of select="substring(@date,1,4)"/>
  <xsl:if test=". != ''">
    <xsl:text> (</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="comment">
  <xsl:if test=". != ''">
    <xsl:choose>
      <xsl:when test="position() = 1"><xsl:text> - </xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>, </xsl:text></xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
  </xsl:if>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="parts">
   <ul>
   <xsl:for-each select="standard">
     <li><para><xsl:apply-templates select="."/></para></li>
   </xsl:for-each>
   </ul>
</xsl:template>


<xsl:template match="profilenote">
  <xsl:choose>
    <xsl:when test="position() = 1"><xsl:value-of select="."/></xsl:when>
    <xsl:when test="position() != 1"><para><xsl:value-of select="."/></para></xsl:when>
  </xsl:choose>
</xsl:template>



<xsl:template match="*"/>

</xsl:stylesheet>
