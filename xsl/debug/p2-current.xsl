<?xml version="1.0"?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>

<!--

This stylesheet is created for the NISP , and is
intended to create an overview of the starndard database.

Copyright (c) 2003, 2023  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default date saxon">


<xsl:output method="xml" indent="no" saxon:next-in-chain="p3-current.xsl"/>

<xsl:param name="describe" select="''"/>


<xsl:strip-space elements="*"/>




<xsl:template match="standards">
  <xsl:message>Generating DB Overview.</xsl:message>
  <html>
    <head>
      <title>Overview of the NISP Standard Database</title>
      <style type="text/css">
        .head {background-color: #808080;  }
        .body,table {font-family: sans-serif;}
        .table {width: 100%;}
        .deleted { background-color: #FF5A41; color: white; font-weight: bold;}
        .missing { background-color: #FFFEA0;}
        .head { }
        .date {white-space: nowrap;}
      </style>
    </head>
    <body>

    <h1>Overview of the NISP Standard Database</h1>

    <xsl:variable name="date">
      <xsl:value-of select="date:date-time()"/>
    </xsl:variable>

    <xsl:variable name="formatted-date">
      <xsl:value-of select="date:month-abbreviation($date)"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="date:day-in-month()"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="date:year()"/>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="substring-before(substring-after($date, 'T'),'+')"/>
    </xsl:variable>

    <table border="0"><tr><td><xsl:text>Created on </xsl:text><xsl:value-of select="$formatted-date"/><xsl:text> using rev. </xsl:text><xsl:value-of select="$describe"/></td></tr></table>

    <h2>Statistics</h2>

    <table border="0">
      <tr>
        <td><b>Rec</b></td>
        <td><b>Total</b></td>
        <td><b>Deleted</b></td>
      </tr>
      <tr>
        <td>Standards</td>
        <td align="right"><xsl:value-of select="count(.//standard)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and (position()=last()) and ancestor::standard])"/></td>
      </tr>
      <tr>
        <td>Cover Documents</td>
        <td align="right"><xsl:value-of select="count(.//coverdoc)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and (position()=last()) and ancestor::coverdoc])"/></td>
      </tr>
      <tr>
        <td>Capability Profiles</td>
        <td align="right"><xsl:value-of select="count(.//profile[@toplevel='yes'])"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and (position()=last()) and ancestor::profile/@toplevel='yes'])"/></td>
      </tr>
      <tr>
        <td>Profiles</td>
        <td align="right"><xsl:value-of select="count(.//profile)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and (position()=last()) and ancestor::profile])"/></td>
      </tr>
      <tr>
        <td>Service Profiles</td>
        <td align="right"><xsl:value-of select="count(.//serviceprofile)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and (position()=last()) and ancestor::serviceprofile])"/></td>
      </tr>
    </table>


  <h2>Standards</h2>

  <p>This page contains tables of all standards and profiles included in
  the database. The standards and profiles are sorted by the <emphasis>id</emphasis> attribute. The same data are also available in a <a href="https://docs.google.com/spreadsheets/d/1fOgQa375vK-LgkP2fPx6oY95p7CaSTPWYLcXaeSc2_8/edit?pli=1#gid=0">Google spreadsheet</a>.</p>

  <p>In this overview, rows with a red background are represent
  deleted standards and profiles. Cells with a yellow background, indicates that that we
  properly don't have the information for this field. It will be
  appreciated very much, if YOU will identify this information and send it to <a href="mailto:stavnstrup@mil.dk">me</a>.</p>


   <ul>
     <li><b>Rec</b> - The sorted position of the <i>standard</i> or <i>profile</i> in the database</li>
     <li><b>ID</b> - What ID is associated with this <i>standard</i></li>
     <li><b>Type</b> - Is this a <i>cover document</i> (C) or a <i>standard</i> (S)</li>
     <li><b>Org</b> - What organisation have published this <i>standard</i></li>
     <li><b>Pubnum</b> - The publication number of the <i>standard</i></li>
     <li><b>Title</b> - The title of the <i>standard</i></li>
     <li><b>Date</b> - The publication date of the <i>standard</i></li>
     <li><b>Ver</b> - Version of the <i>standard</i> or <i>profile</i></li>
     <li><b>Responsible Party</b> - An organisational unit within NATO, who takes the responsibility to guide NATO on the specific standard.</li>
     <li><b>Tag</b> - What Tag is associated with this record</li>
     <li><b>BSP</b> - Is this record part of the basic standards profile (A : Agreed, C: Candidate), i.e. mandatory for NATO common funded systems</li>
     <li><b>History</b> - What is the history of the record</li>
     <li><b>URI</b> - Location of the standard</li>
     <li><b>UUID</b> - UUID of the standard</li>
   </ul>


  <table class="overview" border="1">
    <tr class="head">
      <th>Rec</th>
      <th>ID</th>
      <th>Type</th>
      <th>Org</th>
      <th>PubNum</th>
      <th>Title</th>
      <th>Date</th>
      <th>Ver</th>
      <th>Responsible Party</th>
      <th>Tag</th>
      <th>BSP</th>
      <th>History</th>
      <th>URI</th>
      <th>UUID</th>
    </tr>
    <xsl:apply-templates select="records/coverdoc|records/standard">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </table>

  <h2 id="profiles">Profiles</h2>

  <p>This table lists all profiles and serviceprofiles.

  <ul>
    <li>Profiles (PR) list standards and profiles which fits natually
     together and is mainly developed for convenience only.</li>

    <li>Service Profiles (SP) which will
    reference standards and interoperability profiles and provide guidance to
    describe the SIOP necessary to implement a service described in
    the <a
    href="https://tide.act.nato.int/em/index.php?title=Technical_Services">Technical
    Service Framework</a> (part of the <a
    href="https://tide.act.nato.int/em/index.php?title=C3_Taxonomy">C3
    taxonomy</a>).</li>
    <li>We use the term Capability Profile (CP) for a profile with the toplevel attribute set to yes. An example of this is the FMN profile.</li>
  </ul></p>


  <table class="overview" border="1">
    <tr class="head">
      <th>Rec</th>
      <th>ID</th>
      <th>Type</th>
      <th>Org</th>
      <th>PubNum</th>
      <th>Title</th>
      <th>Date</th>
      <th>Ver</th>
      <th>History</th>
    </tr> 
    <xsl:apply-templates select="//profile|//serviceprofile">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </table>

  </body></html>
</xsl:template>


<xsl:template name="htmlheader">

</xsl:template>



<xsl:template match="profilespec">
    <td>
      <xsl:if test="@orgid =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="@orgid"/>
    </td>
    <td>
      <xsl:if test="@pubnum =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="@pubnum"/>
    </td>
    <td>
      <xsl:if test="@title =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="@title"/>
      <xsl:apply-templates select="parts"/>
    </td>
    <td class="date">
      <xsl:if test="@date =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="@date"/>
    </td>
    <td><xsl:value-of select="@version"/></td>
</xsl:template>

<xsl:template match="profile|serviceprofile">
  <xsl:variable name="myid" select="@id"/>
  <xsl:variable name="pref" select="refprofilespec/@refid"/>
  <tr>
    <xsl:if test=".//event[(position()=last()) and (@flag = 'deleted')]">
      <xsl:attribute name="class">deleted</xsl:attribute>
    </xsl:if>
    <td><xsl:value-of select="@id"/></td>
    <td align="center">
      <xsl:choose>
        <xsl:when test="(local-name(.)='profile') and (@toplevel='yes')">CP</xsl:when>
        <xsl:when test="local-name(.)='serviceprofile'">SP</xsl:when>
        <xsl:otherwise>PR</xsl:otherwise>
      </xsl:choose>
    </td>

    <xsl:apply-templates select="//profilespec[@id=$pref]"/>
    <td><xsl:apply-templates select=".//event"/></td>
  </tr>
</xsl:template>


<xsl:template match="refstandard">
  <xsl:variable name="tref" select="ancestor::serviceprofile/reftaxonomy/@refid"/>
  <xsl:choose>
    <xsl:when test="parent::refgroup[@lifecycle='current']">M</xsl:when>
    <xsl:when test="parent::refgroup[@lifecycle='candidate']">C</xsl:when>
  </xsl:choose>
  <xsl:text> (</xsl:text>
  <xsl:value-of select="/standards/taxonomy//*[@id=$tref]/@title"/>
  <xsl:text>) </xsl:text>
</xsl:template>




<xsl:template match="parts">
  <ul>
   <xsl:apply-templates/>
  </ul>
</xsl:template>

<!--  do we need this?
<xsl:template match="refstandard">
  <xsl:variable name="refid" select="@refid"/>
  <li>
    <xsl:text>(S: </xsl:text>
    <xsl:value-of select="@refid"/>
    <xsl:text>) </xsl:text>
    <xsl:apply-templates select="/standards/records/standard[@id=$refid]/document/@title"/>
  </li>
</xsl:template>
-->

<xsl:template match="refprofile">
  <xsl:variable name="refid" select="@refid"/>
  <li>
    <xsl:text>(P: </xsl:text>
    <xsl:value-of select="@refid"/>
    <xsl:text>) </xsl:text>
    <xsl:apply-templates select="/standards/records/profile[@id=$refid]/profilespec/@title"/>
  </li>
</xsl:template>



<xsl:template match="standard|coverdoc">
  <xsl:variable name="myid" select="@id"/>
  <xsl:variable name="myorg" select="document/@orgid"/>
  <xsl:variable name="myrp" select="responsibleparty/@rpref"/>
  <tr>
    <xsl:if test=".//event[(position()=last()) and (@flag = 'deleted')]">
      <xsl:attribute name="class">deleted</xsl:attribute>
    </xsl:if>
<!--
    <td align="right"><xsl:number from="records" count="standard" format="1" level="any"/></td>
-->
    <td><xsl:value-of select="@id"/></td>
    <td align="center">
      <xsl:choose>
        <xsl:when test="local-name()='coverdoc'">C</xsl:when>
        <xsl:otherwise>S</xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:if test="document/@orgid =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <!--
      <xsl:value-of select="document/@orgid"/>
      -->
      <xsl:apply-templates select="/standards/organisations/orgkey[@key=$myorg]/@short"/>
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
    <td class="date">
      <xsl:if test="document/@date =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@date"/>
    </td>
    <td><xsl:value-of select="document/@version"/></td>
    <td><xsl:apply-templates select="/standards/organisations/orgkey[@key=$myrp]/@short"/></td>
    <td>
      <xsl:if test="@tag =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="@tag"/></td>
    <td align="center">
      <xsl:apply-templates select="/standards/records/serviceprofile[starts-with(@id, 'bsp')]//refstandard[@refid=$myid]"/>
    </td>
    <td class="date"><xsl:apply-templates select=".//event"/></td>
    <td>
      <xsl:if test="not(status/uri) or (status/uri='')">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="status/uri"/>
    </td>
    <td><xsl:value-of select="uuid"/></td>
  </tr>
</xsl:template>


<xsl:template match="correction">
  <xsl:if test="position()=1 and (@cpubnum = ''or @date = '')">
    <xsl:attribute name="bgcolor">yellow</xsl:attribute>
  </xsl:if>
  <xsl:value-of select="@cpubnum"/><xsl:text>:</xsl:text><xsl:value-of select="@date"/>
  <xsl:if test=".!=''"><xsl:text> (</xsl:text><xsl:value-of select="."/><xsl:text>)</xsl:text></xsl:if>
  <xsl:if test="following-sibling::correction[position()=1]"><br /></xsl:if>
</xsl:template>


<xsl:template match="alsoknown">
  <xsl:value-of select="@orgid"/><xsl:text>:</xsl:text><xsl:value-of
       select="@pubnum"/><xsl:text>:</xsl:text><xsl:value-of select="@date"/>
  <xsl:if test="following-sibling::alsoknown[position()=1]"><br /></xsl:if>
</xsl:template>


<xsl:template match="uri">
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="."/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </a>
</xsl:template>


<xsl:template match="event">
  <xsl:if test="position()=1 and (@date = '')">
    <xsl:attribute name="class">missing</xsl:attribute>
  </xsl:if>
  <xsl:value-of select="translate(substring(@flag,1,1), 'acd', 'ACD')"/>
  <xsl:text>:</xsl:text><xsl:value-of select="@date"/>
  <xsl:if test="following-sibling::event[position()=1]"><br /></xsl:if>
</xsl:template>


<xsl:template match="*"/>


</xsl:stylesheet>
