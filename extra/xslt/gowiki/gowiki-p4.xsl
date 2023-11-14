<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>

<xsl:output method="text"/>

<xsl:template match="standards">

<!-- ===========================================
                     ORGANIZATIONS
     =========================================== -->

<xsl:result-document href="./organizations.csv">
<xsl:text>Title,</xsl:text>
<xsl:text>Organization[uuid],</xsl:text>
<xsl:text>Organization[acronym],</xsl:text>
<xsl:text>Organization[website]&#x0A;</xsl:text>
<xsl:apply-templates select="organisations/orgkey" mode="list-org"/>
</xsl:result-document>





<!-- ===========================================
                     PARTIES
     =========================================== -->

<xsl:result-document href="parties.csv">
<xsl:text>Title,</xsl:text>
<xsl:text>Party[uuid],</xsl:text>
<xsl:text>Party[title]&#x0A;</xsl:text>
<xsl:apply-templates select="organisations/orgkey" mode="list-party"/>
</xsl:result-document>




<!-- ===========================================
                     REFERENCES
     =========================================== -->
<xsl:result-document href="references.csv">
<xsl:text>Title,</xsl:text>
<xsl:text>Reference[uuid],</xsl:text>
<xsl:text>Reference[title],</xsl:text>
<xsl:text>Reference[description],</xsl:text>
<xsl:text>Reference[code],</xsl:text>
<xsl:text>Reference[version],</xsl:text>
<xsl:text>Reference[classification],</xsl:text>
<xsl:text>Reference[date],</xsl:text>
<xsl:text>Reference[publisher],</xsl:text>
<xsl:text>Reference[filename],</xsl:text>
<xsl:text>Reference[link]&#x0A;</xsl:text>
<xsl:apply-templates select="records/coverdoc"/>
<xsl:apply-templates select="records/profile[@toplevel='yes']/refprofilespec"/>
</xsl:result-document>

<!-- ===========================================
                     FOOTNOTE
     =========================================== -->

<xsl:result-document href="footnote.csv">
<xsl:text>Title,</xsl:text>
</xsl:result-document>


<!-- ===========================================
                     STANDARDS
     =========================================== -->

<xsl:result-document href="standards.csv">
<xsl:text>Title,</xsl:text>
<xsl:text>Standard[uuid],</xsl:text>
<xsl:text>Standard[title],</xsl:text>
<xsl:text>Standard[description],</xsl:text>
<xsl:text>Standard[code],</xsl:text>
<xsl:text>Standard[version],</xsl:text>
<xsl:text>Standard[classification],</xsl:text>
<xsl:text>Standard[date],</xsl:text>
<xsl:text>Standard[link],</xsl:text>
<xsl:text>Standard[organization],</xsl:text>
<xsl:text>Standard[parties],</xsl:text>
<xsl:text>Standard[coverDocument]&#x0A;</xsl:text>
<xsl:apply-templates select="records/standard"/>
</xsl:result-document>

<xsl:apply-templates select="records/standard" mode="pages"/>


<!-- ===========================================
                     PROFILES
     =========================================== -->

<xsl:result-document href="profiles.csv">
<xsl:text>Title,</xsl:text>
<xsl:text>Profile[uuid],</xsl:text>
<xsl:text>Profile[title],</xsl:text>
<xsl:text>Profile[description],</xsl:text>
<xsl:text>Profile[state],</xsl:text>
<xsl:text>Profile[filename],</xsl:text>
<xsl:text>Profile[link],</xsl:text>
<xsl:text>Profile[code],</xsl:text>
<xsl:text>Profile[parties],</xsl:text>
<xsl:text>Profile[profileGroup],</xsl:text>
<xsl:text>Profile[references],</xsl:text>
<xsl:text>Profile[artefact]&#x0A;</xsl:text>
<xsl:text>Profile&#x0A;</xsl:text>
<xsl:apply-templates select="records/profile"/>
<xsl:text>Service Profile&#x0A;</xsl:text>
<xsl:apply-templates select="records/serviceprofile"/>
</xsl:result-document>

</xsl:template>



<!-- =================================================== -->

<!-- List Organisations -->

<xsl:template match="orgkey" mode="list-org">
<xsl:variable name="mykey" select="./@key"/>
<xsl:if test="count(/standards//standard[document/@orgid=$mykey])>0">
<xsl:text>"</xsl:text><xsl:value-of select="./@long"/><xsl:text>",</xsl:text>
<xsl:value-of select="./@uuid"/><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="./@short"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="./@uri"/><xsl:text>"&#x0A;</xsl:text>
</xsl:if>
</xsl:template>


<!-- List Parties -->

<xsl:template match="orgkey" mode="list-party">
<xsl:variable name="mykey" select="./@key"/>
<xsl:if test="count(/standards//standard[responsibleparty/@rpref=$mykey])>0">
<xsl:text>"</xsl:text><xsl:value-of select="./@short"/><xsl:text>",</xsl:text>
<xsl:value-of select="./@uuid"/><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="./@long"/><xsl:text>"&#x0A;</xsl:text>
</xsl:if>
</xsl:template>

<!-- List Standards -->

<xsl:template match="standard">
<xsl:variable name="myid" select="@id"/>
<xsl:variable name="myorgid" select="document/@orgid"/>
<xsl:variable name="myparty" select="responsibleparty/@rpref"/>
<xsl:text>"</xsl:text><xsl:value-of select="@wikiId"/><xsl:text>",</xsl:text>
<xsl:value-of select="uuid"/><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@title"/><xsl:text>",</xsl:text>
<xsl:text>"",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@pubnum"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@version"/><xsl:text>",</xsl:text>
<xsl:text>"",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@date"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="status/uri"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@long"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myparty]/@short"/><xsl:text>",</xsl:text>
<xsl:variable name="cid"><xsl:value-of select="/standards//coverdoc[coverstandards/refstandard/@refid=$myid]/@id"/></xsl:variable>
<xsl:text>"</xsl:text><xsl:if test="$cid != ''"><xsl:value-of select="/standards//coverdoc[@id=$cid]/@tag"/></xsl:if>
<xsl:text>"&#x0A;</xsl:text>
</xsl:template>


<xsl:template match="standard" mode="pages">
<xsl:variable name="myid" select="@id"/>
<xsl:variable name="myorgid" select="document/@orgid"/>
<xsl:variable name="myparty" select="responsibleparty/@rpref"/>
<xsl:result-document href="{@wikiId}.page">
<xsl:text>{{Standard&#x0A;</xsl:text>
<xsl:text>|organization=</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@long"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|title=</xsl:text><xsl:value-of select="document/@title"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|code=</xsl:text><xsl:value-of select="document/@pubnum"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|date=</xsl:text><xsl:value-of select="document/@date"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|version=</xsl:text><xsl:value-of select="document/@version"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|classification=&#x0A;</xsl:text>
<xsl:text>|parties=</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myparty]/@short"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|description=&#x0A;</xsl:text>
<xsl:variable name="cid"><xsl:value-of select="/standards//coverdoc[coverstandards/refstandard/@refid=$myid]/@id"/></xsl:variable>
<xsl:text>|coverdoc=</xsl:text><xsl:if test="$cid != ''"><xsl:value-of select="/standards//coverdoc[@id=$cid]/@tag"/></xsl:if>
<xsl:text>|link=</xsl:text><xsl:value-of select="status/uri"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>|uuid=</xsl:text><xsl:value-of select="uuid"/><xsl:text>&#x0A;</xsl:text>
<xsl:text>}}&#x0A;</xsl:text>
</xsl:result-document>
</xsl:template>


<!-- List references -->

<xsl:template match="coverdoc">
<xsl:variable name="myid" select="@id"/>
<xsl:variable name="myorgid" select="document/@orgid"/>
<xsl:variable name="myparty" select="responsibleparty/@rpref"/>
<xsl:text>"</xsl:text><xsl:value-of select="@tag"/><xsl:text>",</xsl:text>
<xsl:value-of select="uuid"/><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@title"/><xsl:text>",</xsl:text>
<xsl:text>"",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@pubnum"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@version"/><xsl:text>",</xsl:text>
<xsl:text>"",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@date"/><xsl:text>",</xsl:text>
<xsl:text>"",</xsl:text> <!-- publisher -->
<xsl:text>"",</xsl:text> <!-- filename -->
<xsl:text>"</xsl:text><xsl:value-of select="status/uri"/><xsl:text>"</xsl:text>
<xsl:text>&#x0A;</xsl:text>
</xsl:template>

<xsl:template match="refprofilespec">
  <xsl:variable name="myspecid" select="@refid"/>
  <xsl:apply-templates select="/standards//profilespec[@id=$myspecid]"/>
</xsl:template>

<xsl:template match="profilespec">
  <xsl:text>"</xsl:text><xsl:value-of select="@tag"/><xsl:text>",</xsl:text>
  <xsl:value-of select="uuid"/><xsl:text>,</xsl:text>
  <xsl:text>"</xsl:text><xsl:value-of select="@title"/><xsl:text>",</xsl:text>
  <xsl:text>"",</xsl:text>
  <xsl:text>"</xsl:text><xsl:value-of select="@pubnum"/><xsl:text>",</xsl:text>
  <xsl:text>"</xsl:text><xsl:value-of select="@version"/><xsl:text>",</xsl:text>
  <xsl:text>"",</xsl:text>
  <xsl:text>"</xsl:text><xsl:value-of select="@date"/><xsl:text>",</xsl:text>
  <xsl:text>"",</xsl:text> <!-- publisher -->
  <xsl:text>"",</xsl:text> <!-- filename -->
  <xsl:text>""&#x0A;</xsl:text>
</xsl:template>

<!-- List Profiles -->

<xsl:template match="capabilityprofile|profile">
<xsl:variable name="myid" select="@id"/>
<xsl:variable name="myspecid" select="refprofilespec/@refid"/>
<xsl:variable name="myorgid" select="/standards//profilespec[@id=$myspecid]/@orgid"/>

<xsl:text>"</xsl:text><xsl:value-of select="@wikiId"/><xsl:text>",</xsl:text>
<xsl:value-of select="uuid"/><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="@title"/><xsl:text>",</xsl:text>
<xsl:text>"",</xsl:text> <!-- Description -->
<xsl:text>"",</xsl:text> <!-- state -->
<xsl:text>"",</xsl:text> <!-- filename -->
<xsl:text>"",</xsl:text> <!-- link -->
<xsl:text>"</xsl:text><xsl:value-of select="/standards//profilespec[@id=$myspecid]/@pubnum"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@long"/><xsl:text>",</xsl:text>
<xsl:text>"Profile Group",</xsl:text> <!-- Profile Group -->
<xsl:text>"</xsl:text><xsl:value-of select="/standards//profilespec[@id=$myspecid]/@tag"/><xsl:text>",</xsl:text>

<xsl:text>"</xsl:text><xsl:value-of select="document/@date"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="status/uri"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@long"/><xsl:text>",</xsl:text>
<xsl:variable name="cid"><xsl:value-of select="/standards//coverdoc[coverstandards/refstandard/@refid=$myid]/@id"/></xsl:variable>
<xsl:text>"</xsl:text><xsl:if test="$cid != ''"><xsl:value-of select="/standards//coverdoc[@id=$cid]/@tag"/></xsl:if>
<xsl:text>"&#x0A;</xsl:text>
</xsl:template>

<xsl:template match="serviceprofile">
<xsl:variable name="myid" select="@id"/>
<xsl:variable name="myorgid" select="document/@orgid"/>
<xsl:variable name="myparty" select="responsibleparty/@rpref"/>
<xsl:text>"</xsl:text><xsl:value-of select="@wikiId"/><xsl:text>",</xsl:text>
<xsl:value-of select="uuid"/><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="@title"/><xsl:text>",</xsl:text>
<xsl:text>"",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@pubnum"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@version"/><xsl:text>",</xsl:text>
<xsl:text>"",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@date"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="status/uri"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@long"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myparty]/@short"/><xsl:text>",</xsl:text>
<xsl:variable name="cid"><xsl:value-of select="/standards//coverdoc[coverstandards/refstandard/@refid=$myid]/@id"/></xsl:variable>
<xsl:text>"</xsl:text><xsl:if test="$cid != ''"><xsl:value-of select="/standards//coverdoc[@id=$cid]/@tag"/></xsl:if>
<xsl:text>"&#x0A;</xsl:text>
</xsl:template>

</xsl:stylesheet>
