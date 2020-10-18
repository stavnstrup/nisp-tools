<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'>

<xsl:variable name="draft" select="'(Sample) '"/>     <!-- Prefix text used in name for DRAFT version -->

<xsl:variable name="nispVersion" select="'13.0'"/>
<xsl:variable name="dateCreated" select="current-dateTime()"/>
<xsl:variable name="dateAccepted" select="'2020-06-19'"/>
<xsl:variable name="acceptedDocIF" select="''"/>
<xsl:variable name="creator" select="'Interoperability Profiles Capability Team (IP CaT)'"/>
<xsl:variable name="publisher" select="'Consultation, Command and Control Board (C3B)'"/>

<!-- Version 3.0 of the C3 Taxonomy -->
<xsl:variable name="c3t-statement" select="'Generated from the ACT Enterprise Mapping Wiki on 26 Aug 2019'"/>
<xsl:variable name="c3t-date" select="'26 Aug 2019'"/>

</xsl:stylesheet>
