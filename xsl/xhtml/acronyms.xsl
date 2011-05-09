<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<!-- 

Name        : acronyms.xsl

Description : This stylesheet is created for the NATO Interoperability
              Standards and profilesTechnical Architecture, and is
              intended for the creation of the acronyms pages.

              Copyright (C) 2001,2011 Jens Stavnstrup/DALO <stavnatrup@mil.dk>,
              Danish Defence Acquisition and Logistic Organisation (DALO),
              Danish Defence Research Establishment (DDRE) and
              NATO Command, Control and Consultation Organisation.(NC3O)

$Id

-->

<!-- ==================================================================== -->

<xsl:import href="../common/common.xsl"/>


<!-- Set method to html to avoid Saxon for printing an XML Decl to stdout -->
<xsl:output method="html"/>


<xsl:param name="doctype-public"
           select="'-//W3C//DTD XHTML 1.0 Transitional//EN'"/>

<xsl:param name="doctype-system" 
           select="'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'"/>

<xsl:param name="encoding" select="'iso-8859-1'"/>


<xsl:template name="mkLetterBar">
  <div xmlns="http://www.w3.org/1999/xhtml" class="letterBar">
    <a href="index.html">A</a> 
    <a href="acronyms-B.html">B</a>
    <a href="acronyms-C.html">C</a>
    <a href="acronyms-D.html">D</a>
    <a href="acronyms-E.html">E</a>
    <a href="acronyms-F.html">F</a>
    <a href="acronyms-G.html">G</a>
    <a href="acronyms-H.html">H</a>
    <a href="acronyms-I.html">I</a>
    <a href="acronyms-J.html">J</a>
    <a href="acronyms-K.html">K</a>
    <a href="acronyms-L.html">L</a>
    <a href="acronyms-M.html">M</a>
    <a href="acronyms-N.html">N</a>
    <a href="acronyms-O.html">O</a>
    <a href="acronyms-P.html">P</a>
    <a href="acronyms-Q.html">Q</a>
    <a href="acronyms-R.html">R</a>
    <a href="acronyms-S.html">S</a>
    <a href="acronyms-T.html">T</a>
    <a href="acronyms-U.html">U</a>
    <a href="acronyms-V.html">V</a>
    <a href="acronyms-W.html">W</a>
    <a href="acronyms-X.html">X</a>
    <a href="acronyms-Y.html">Y</a>
    <a href="acronyms-Z.html">Z</a>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="acrogroup">
  <xsl:variable name="letter"><xsl:value-of select="@tag"/></xsl:variable>

  <xsl:variable name="documentname">
    <xsl:choose>
      <xsl:when test="$letter='A'">index.html</xsl:when>
      <xsl:otherwise>acronyms-<xsl:value-of select="$letter"/>.html</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:document href="{$documentname}" 
                method="xml" indent="no"
                doctype-public="{$doctype-public}"
                doctype-system="{$doctype-system}"
                encoding="{$encoding}">
    <html xmlns="http://www.w3.org/1999/xhtml"><head>
      <title>NC3 Acronyms</title>
      <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
      <meta http-equiv="Content-Language" content="en-uk" />
      <meta name="MSSmartTagsPreventParsing" content="true" />
      <meta name="author" content="NATO Open Systems Working Group (NOSWG)" /> 
      <link rel="stylesheet" href="../css/nisp.css" type="text/css" media="all" />
    </head>
    <body>
      <xsl:call-template name="create-header"/>
      <xsl:call-template name="create-menubar"/>
      <div id="container">
        <div id="nav">
          <ul>
            <li id="menuhead">Acronyms</li>
            <li><img src="../images/menu_icon-onder.gif" alt="NATO Logo" width="195" height="72"/></li>
          </ul>
        </div> 
        <div id="docbook">
          <xsl:call-template name="mkLetterBar"/>
          <table id="acrotable" border="0">
            <tr>
              <td width="23%" valign="top" align="left"><b>Acronyms</b></td>
              <td width="54%" valign="top" align="left"><b>Meaning /<br />Significance</b></td>
              <td width="23%" valign="top" align="left"><b>Source</b></td>
            </tr>
            <xsl:if test="count(acronym)>0">
              <xsl:apply-templates/>
            </xsl:if>
          </table>
          <div id="acrofoot">Last Updated on <xsl:value-of select="//lastupdated"/><br />
             By <xsl:value-of select="//authority"/></div>      
        </div>
      </div>
      <div id="footer">Copyright &#x00A9; NATO - OTAN 2004-2011 | <a href="../disclaimer.html">Disclaimer</a></div>
    </body>
    </html>
  </xsl:document>
</xsl:template>


<xsl:template match="acronym">
  <tr xmlns="http://www.w3.org/1999/xhtml">
    <xsl:if test="position() mod 4">
      <xsl:attribute name="class">acroeven</xsl:attribute>
    </xsl:if>
    <td width="23%"><xsl:value-of select="name"/></td>
    <td width="54%"><xsl:value-of select="meaning"/></td>
    <td width="23%"><xsl:value-of select="source"/></td>
  </tr>
</xsl:template>


<xsl:template match="lastupdated|authority"/>

<xsl:template match="text()"/>

</xsl:stylesheet>
