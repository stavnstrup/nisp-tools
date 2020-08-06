<!--

This stylesheet is created for the NISP, and is
intended to create a list of all standards in the Basic Standards Profile.
This list is intented for the bi-annual reviev where we identify responsible parties for standards and taxonomuy nodes.


Copyright (c) 2019,  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='2.0'
                exclude-result-prefixes="date saxon">


<xsl:template match="standards">
<html>
<body>
  <table>
    <tr>
      <th>Id</th>
      <th>Organisation</th>
      <th>Pubnumber</th>
      <th>Title</th>
      <th>Date</th>
      <th>Responsible Party</th>
      <th>URL</th>
      <th>Obligation</th>
      <th>Original Taxonomy Node</th>
      <th>New Taxonomy Node</th>
      <th>New Responsible party</th>
    </tr>
    <xsl:apply-templates select="records/capabilityprofile[@id='bsp']//refprofile"/>
  </table>
</body>
</html>
</xsl:template>

<xsl:template match="refprofile">
  <xsl:variable name="myref" select="@refid"/>
  <xsl:apply-templates select="/standards/records/serviceprofile[@id=$myref]/refgroup/refstandard"/>
</xsl:template>

<xsl:template match="refstandard">
  <xsl:variable name="stdid" select="@refid"/>
  <xsl:variable name="nodeid" select="../../reftaxonomy/@refid"/>
  <tr>
    <!-- List standard parameters -->
    <xsl:apply-templates select="/standards/records/standard[@id=$stdid]"/>
    <td>
      <xsl:choose>
         <xsl:when test="../@lifecycle='current'">MANDATORY</xsl:when>
         <xsl:otherwise>CANDIDATE</xsl:otherwise>
       </xsl:choose>
    </td>
    <td><xsl:value-of select="/standards//node[@id=$nodeid]/@title"/></td>
    <td></td>
    <td></td>
  </tr>
</xsl:template>

<xsl:template match="standard">
   <xsl:variable name="std" select="."/>
   <td><xsl:value-of select="@id"/></td>
   <td><xsl:value-of select="/standards/organisations/orgkey[@key=$std/document/@orgid]/@short"/></td>
    <td><xsl:value-of select="document/@pubnum"/></td>
    <td><xsl:value-of select="document/@title"/></td>
    <td><xsl:value-of select="document/@date"/></td>
    <td><xsl:value-of select="/standards/organisations/orgkey[@key=$std/responsibleparty/@rpref]/@short"/></td>
    <td><xsl:value-of select="status/uri"/></td>
</xsl:template>



</xsl:stylesheet>
