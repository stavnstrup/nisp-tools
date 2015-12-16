<?xml version="1.0"?>

<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>

<!--

This stylesheet is created for the NISP , and is
intended to create an overview of the starndard database.

Copyright (c) 2003, 2014  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='1.1'
                exclude-result-prefixes="#default date saxon">


<xsl:output method="xml" indent="no" saxon:next-in-chain="p2-overview.xsl"/>

<xsl:param name="describe" select="''"/>


<xsl:strip-space elements="*"/>
  


<!-- If this param is set to one, only one headline is generated.
     You can therefore use the import the html file in a spreadsheet program 
     and use the freeze pane facility -->

<xsl:param name="excelXP" select="0"/>


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
        <td><b>Rejected</b></td>
      </tr>
      <tr>
        <td>Standards</td>
        <td align="right"><xsl:value-of select="count(.//standard)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and (position()=last()) and ancestor::standard])"/></td>
        <td align="right"><xsl:value-of select="count(.//standard[status='rejected'])"/></td>
      </tr>
      <tr>
        <td>Set of Standards</td>
        <td align="right"><xsl:value-of select="count(.//setofstandards)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and (position()=last()) and ancestor::setofstandards])"/></td>
        <td align="right"><xsl:value-of select="count(.//setofstandards[status='rejected'])"/></td>
      </tr>
<!--      
      <tr>
        <td>Service Groups</td>
        <td align="right"><xsl:value-of select="count(.//servicegroup)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and (position()=last()) and ancestor::serviceprofile])"/></td>
        <td align="right"><xsl:value-of select="count(.//servicegroup[status='rejected'])"/></td>
       </tr>      
      <tr>
        <td>Service Profiles</td>
        <td align="right"><xsl:value-of select="count(.//serviceprofile)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and (position()=last()) and ancestor::serviceprofile])"/></td>
        <td align="right"><xsl:value-of select="count(.//serviceprofile[status='rejected'])"/></td>
        </tr>
-->        
      <tr>
        <td>Capability Profiles</td>
        <td align="right"><xsl:value-of select="count(.//capabilityprofile)"/></td>
        <td align="right"><xsl:value-of select="count(.//event[(@flag='deleted') and (position()=last()) and ancestor::capabilityprofile])"/></td>
        <td align="right"><xsl:value-of select="count(.//capabilityprofile[status='rejected'])"/></td>
       </tr>
    </table>


  <h2>Standards</h2>

  <p>This page contains tables of all standards and profiles included in
  the database. The standards and profiles are sorted by the <emphasis>id</emphasis> attribute.</p>

  <p>In this overview, rows with a red background are represent 
  deleted standards and profiles. Cells with a yellow background, indicates that that we
  properly don't have the information for this field. It will be
  appreciated very much, if YOU will identify this information and send it to <a href="mailto:stavnstrup@mil.dk">me</a>.</p>


   <ul>
     <li><b>Rec</b> - The sorted position of the <i>standard</i> or <i>profile</i> in the database</li>
     <li><b>ID</b> - What ID is associated with this <i>standard</i></li>
     <li><b>Type</b> - Is this a <i>coverstandard</i> (CS), a <i>single standard</i> (S) or a <i>sub standard</i> (SS)</li>
     <li><b>Org</b> - What organisation have published this <i>standard</i></li>
     <li><b>Pubnum</b> - The publication number of the <i>standard</i></li>
     <li><b>Title</b> - The title of the <i>standard</i></li>
     <li><b>Date</b> - The publication date of the <i>standard</i></li>
     <li><b>Ver</b> - Version of the <i>standard</i> or <i>profile</i></li>
     <li><b>Correction</b> - Correction info for
        this <i>standard</i>. There might be multiple corrections
        records (Technical Correction, Ammentment etc.). Each record
        begins on a new line</li>
     <li><b>AKA</b> - (Also Known As) A standard can be published by
        another organisation. There might be multiple AKA record. Each
        record begins on a new line</li>
     <li><b>Tag</b> - What Tag is associated with this record</li>
     <li><b>Select</b> - Is this record selected by NATO (M : Mandatory, E: Emerging, F: fading)</li>
     <li><b>History</b> - What is the history of the record</li>
     <li><b>URI</b> - Location of the standard</li>
   </ul>

  <xsl:if test="$excelXP = 1">
    <table border="1" width="100%">
      <xsl:call-template name="htmlheader"/>
    </table>
  </xsl:if>

  <table class="overview" border="1">
    <xsl:call-template name="htmlheader"/>
    <xsl:apply-templates select="records/standard">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </table>

  <h2 id="profiles">Profiles</h2>
  
  <p>This table lists all capability, service- and setofstandards.

  <ul>
    <li>Setofstandards (SS) list standards and profiles which fits natually
     together and is mainly developed for convenience only.</li>

    <li>Service Profiles (SP) which will
    reference standards and interoperability profiles and provide guidance to
    describe the SIOP necessary to implement a service described in
    the <a
    href="https://tide.act.nato.int/em/index.php?title=Technical_Services">Technical
    Service Framework</a> (part of the <a
    href="https://tide.act.nato.int/em/index.php?title=C3_Taxonomy">C3
    taxonomy</a>).</li>
    <li>Capability Profiles (CP) consists of a set of serviceprofiless. An example of this is the FMN profile.</li>
  </ul></p>


  <table class="overview" border="1">
    <xsl:call-template name="htmlheader"/>
    <xsl:apply-templates select="//setofstandards|//capabilityprofile|//serviceprofile">
      <xsl:sort select="@id" order="ascending"/>
    </xsl:apply-templates>
  </table>
  
  </body></html>
</xsl:template>


<xsl:template name="htmlheader">
  <tr class="head">
    <th>Rec</th>
    <th>ID</th>
    <th>Type</th>
    <th>Org</th>
    <th>PubNum</th>
    <th>Title</th>
    <th>Date</th>
    <th>Ver</th>
    <th>Correction</th>
    <th>AKA</th>
    <th>Tag</th>
    <th>Select</th>
    <th>History</th>
    <th>URI</th>
   </tr>
</xsl:template>


<xsl:template match="setofstandards|serviceprofile|capabilityprofile">
  <xsl:variable name="myid" select="@id"/>
  <tr>
    <xsl:if test=".//event[(position()=last()) and (@flag = 'deleted')]">
      <xsl:attribute name="class">deleted</xsl:attribute>
    </xsl:if>
    <td><xsl:value-of select="@id"/></td>
    <td align="center">
      <xsl:choose>
        <xsl:when test="local-name(.)='capabilityprofile'">CP</xsl:when>
        <xsl:when test="local-name(.)='serviceprofile'">SP</xsl:when>
        <xsl:otherwise>SS</xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:if test="profilespec/@orgid =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@orgid"/>
    </td>
    <td>
      <xsl:if test="profilespec/@pubnum =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@pubnum"/>
    </td>
    <td>
      <xsl:if test="profilespec/@title =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@title"/>
      <xsl:apply-templates select="parts"/>
    </td>
    <td class="date">
      <xsl:if test="profilespec/@date =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="profilespec/@date"/>
    </td>        
    <td><xsl:value-of select="profilespec/@version"/></td>        
    <td><xsl:apply-templates select="document/correction"/></td>
    <td><xsl:apply-templates select="document/alsoknown"/></td>
    <td>
      <xsl:if test="@tag =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="@tag"/></td>
    <td align="center">
      <xsl:apply-templates select="/standards/bestpracticeprofile//refstandard[@refid=$myid]"/>
    </td>
    <td><xsl:apply-templates select=".//event"/></td>
    <td>N/A</td>
  </tr>
</xsl:template>


<xsl:template match="bprefstandard">
  <xsl:variable name="tref" select="ancestor::bpserviceprofile/@tref"/>
  <xsl:choose>
    <xsl:when test="parent::bpgroup[@mode='mandatory']">M</xsl:when>
    <xsl:when test="parent::bpgroup[@mode='emerging']">E</xsl:when>
    <xsl:when test="parent::bpgroup[@mode='fading']">F</xsl:when>
  </xsl:choose>
  <xsl:text> ( </xsl:text>
  <xsl:value-of select="/standards/taxonomy//*[@id=$tref]/@title"/>
  <xsl:text> ) </xsl:text>
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



<xsl:template match="standard">
  <xsl:variable name="myid" select="@id"/>
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
        <xsl:when test="document/substandards">CS</xsl:when>
        <xsl:when test="//substandards/refstandard/@refid=$myid">SS</xsl:when>
        <xsl:otherwise>S</xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
      <xsl:if test="document/@orgid =''">
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
    <td class="date">
      <xsl:if test="document/@date =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="document/@date"/>
    </td>        
    <td><xsl:value-of select="document/@version"/></td>        
    <td><xsl:apply-templates select="document/correction"/></td>
    <td><xsl:apply-templates select="document/alsoknown"/></td>
    <td>
      <xsl:if test="@tag =''">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>            
      <xsl:value-of select="@tag"/></td>
    <td align="center">
      <xsl:apply-templates select="/standards/bestpracticeprofile//bprefstandard[@refid=$myid]"/>
    </td>
    <td class="date"><xsl:apply-templates select=".//event"/></td>
    <td>
      <xsl:if test="not(status/uri)">
        <xsl:attribute name="class">missing</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="status/uri"/>
    </td>
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
