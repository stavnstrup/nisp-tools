<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>

<xsl:output method="text"/>

<xsl:variable name="db" select="document('profile-groups.xml')"/>

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
<xsl:text>Reference[pubnum],</xsl:text>
<xsl:text>Reference[date],</xsl:text>
<xsl:text>Reference[version],</xsl:text>
<xsl:text>Reference[publisher],</xsl:text>
<xsl:text>Reference[link]&#x0A;</xsl:text>
<xsl:apply-templates select="records/coverdoc"/>
<xsl:apply-templates select="records/profile[@toplevel='yes']/refprofilespec"/>
</xsl:result-document>

<!-- ===========================================
                     FOOTNOTE
     =========================================== -->

<xsl:result-document href="footnotes.csv">
<xsl:text>Title,</xsl:text>
<xsl:text>Footnote[remark]&#x0A;</xsl:text>
<xsl:apply-templates select="records/standard[document/@note != '']" mode="makeFootnote"/>
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
<xsl:text>Standard[date],</xsl:text>
<xsl:text>Standard[version],</xsl:text>
<xsl:text>Standard[link],</xsl:text>
<xsl:text>Standard[organization],</xsl:text>
<xsl:text>Standard[parties],</xsl:text>
<xsl:text>Standard[coverDocument]&#x0A;</xsl:text>
<xsl:apply-templates select="records/standard"/>
</xsl:result-document>


<!-- ===========================================
                     PROFILES
     =========================================== -->

<xsl:result-document href="profiles.csv">
<xsl:text>Title,</xsl:text>
<xsl:text>Profile[uuid],</xsl:text>
<xsl:text>Profile[title],</xsl:text>
<xsl:text>Profile[description],</xsl:text>
<xsl:text>Profile[code],</xsl:text>
<xsl:text>Profile[parties],</xsl:text>
<xsl:text>Profile[profileGroup],</xsl:text>
<xsl:text>Profile[references],</xsl:text>
<xsl:text>Profile[artefact]&#x0A;</xsl:text>
<xsl:apply-templates select="records/profile"/>
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
<xsl:text>"</xsl:text><xsl:value-of select="document/@date"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@version"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="status/uri"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@long"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myparty]/@short"/><xsl:text>",</xsl:text>
<xsl:variable name="cid"><xsl:value-of select="/standards//coverdoc[coverstandards/refstandard/@refid=$myid]/@id"/></xsl:variable>
<xsl:text>"</xsl:text><xsl:if test="$cid != ''"><xsl:value-of select="/standards//coverdoc[@id=$cid]/@wikiId"/></xsl:if>
<xsl:text>"&#x0A;</xsl:text>
</xsl:template>

<xsl:template match="standard" mode="makeFootnote">
<xsl:text>"</xsl:text><xsl:value-of select="@wikiId"/><xsl:text>","</xsl:text>
<xsl:value-of select="document/@note"/>
<xsl:text>"&#x0A;</xsl:text>
</xsl:template>



<!-- List references -->

<xsl:template match="coverdoc">
<xsl:variable name="myid" select="@id"/>
<xsl:variable name="myorg" select="document/@orgid"/>
<xsl:variable name="myparty" select="responsibleparty/@rpref"/>
<xsl:text>"</xsl:text><xsl:value-of select="@wikiId"/><xsl:text>",</xsl:text>
<xsl:value-of select="uuid"/><xsl:text>,</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@title"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@pubnum"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@date"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="document/@version"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myorg]/@short"/><xsl:text>"</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="status/uri"/><xsl:text>",</xsl:text>
<xsl:text>&#x0A;</xsl:text>
</xsl:template>

<xsl:template match="refprofilespec">
  <xsl:variable name="myspecid" select="@refid"/>
  <xsl:apply-templates select="/standards//profilespec[@id=$myspecid]"/>
</xsl:template>

<xsl:template match="profilespec">
  <xsl:variable name="myorg" select="@orgid"/>
  <xsl:text>"</xsl:text><xsl:value-of select="@wikiId"/><xsl:text>",</xsl:text>
  <xsl:value-of select="uuid"/><xsl:text>,</xsl:text>
  <xsl:text>"</xsl:text><xsl:value-of select="@title"/><xsl:text>",</xsl:text>
  <xsl:text>"</xsl:text><xsl:value-of select="@pubnum"/><xsl:text>",</xsl:text>
  <xsl:text>"</xsl:text><xsl:value-of select="@date"/><xsl:text>",</xsl:text>
  <xsl:text>"</xsl:text><xsl:value-of select="@version"/><xsl:text>",</xsl:text>
  <xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myorg]/@short"/><xsl:text>",</xsl:text>
  <xsl:text>""&#x0A;</xsl:text> <!-- link -->
</xsl:template>

<!-- List Profiles -->

<xsl:template match="capabilityprofile|profile">
<xsl:variable name="myid" select="@id"/>
<xsl:variable name="myspecid" select="refprofilespec/@refid"/>
<xsl:variable name="myorgid" select="/standards//profilespec[@id=$myspecid]/@orgid"/>

<xsl:variable name="cid" select="/standards/profilehierachy//*[@id=$myid]/ancestor-or-self::capabilityprofile/@id"/> 

<xsl:text>"</xsl:text><xsl:value-of select="@wikiId"/><xsl:text>",</xsl:text>
<xsl:value-of select="uuid"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="@title"/><xsl:text>",</xsl:text>
<xsl:text>"",</xsl:text> <!-- coverprofiles and profiles do not have a description -->
<xsl:text>"</xsl:text><xsl:value-of select="/standards//profilespec[@id=$myspecid]/@pubnum"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@long"/><xsl:text>",</xsl:text>
<xsl:text>"Profile Group:</xsl:text><xsl:value-of select="$cid"/><xsl:text>",</xsl:text> <!-- Profile Group -->
<xsl:text>"</xsl:text><xsl:value-of select="/standards//profilespec[@id=$myspecid]/@wikiId"/><xsl:text>",</xsl:text>
<xsl:text>""&#x0A;</xsl:text>
</xsl:template>


<xsl:template match="serviceprofile">
<xsl:variable name="myid" select="@id"/>
<xsl:variable name="myspecid" select="refprofilespec/@refid"/>
<xsl:variable name="myorgid" select="/standards//profilespec[@id=$myspecid]/@orgid"/>

<xsl:text>"</xsl:text><xsl:value-of select="@wikiId"/><xsl:text>",</xsl:text>
<xsl:value-of select="uuid"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="@title"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="description"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards//profilespec[@id=$myspecid]/@pubnum"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards/organisations/orgkey[@key=$myorgid]/@long"/><xsl:text>",</xsl:text>
<xsl:text>"Profile Group",</xsl:text>
<xsl:text>"</xsl:text><xsl:value-of select="/standards//profilespec[@id=$myspecid]/@tag"/><xsl:text>",</xsl:text>
<xsl:text>"</xsl:text>
<xsl:apply-templates select="reftaxonomy"/>
<xsl:text>"&#x0A;</xsl:text>
</xsl:template>




<xsl:template match="reftaxonomy">
  <xsl:variable name="myrefid" select="@refid"/>
  <xsl:apply-templates select="/standards//node[@id=$myrefid]"/>
  <xsl:if test="following-sibling::reftaxonomy">
    <xsl:text>;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="node">
<!--
  <xsl:value-of select="ancestor::node()[@level=5]/@title"/>
-->
  <xsl:value-of select="@level"/>
</xsl:template>

</xsl:stylesheet>
