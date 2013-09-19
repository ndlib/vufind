<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>


<!--

  addunitid.xsl - insert unitids into dids, if they don't exist,
  or replace existing ones wiht new values
  
  Eric Lease Morgan (emorgan@nd.edu)
  September 27, 2010 - first cut
  September 28, 2010 - tweaked to catch attributes
  September 29, 2010 - replaced existing unitid values
  October    5, 2010 - update id attribute of unitid instead; removed processing instructions
  April     30, 2013 - updated location of doctype-system
  
  Special thanks go to:
  
	* MJ Suhonos for the cool //did[not(unitid)] expression
	* Tod Olson for the idea of identity transformation (copying), and 
	* Stefan Krause for the use of generate-id

-->

	<xsl:output
		method='xml'
		doctype-public="+//ISBN 1-931666-00-8//DTD ead.dtd (Encoded Archival Description (EAD) Version 2002)//EN"
		doctype-system="http://www.catholicresearch.net/data/ead/ead.dtd"
		indent='yes'
	/>
	
	<!-- match everything and copy it -->
	<xsl:template match="node()|@*">
		<xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy>
	</xsl:template>

	<!-- special case #1; add unitid with id -->
	<xsl:template match="//did[not(unitid)]">
		<xsl:copy>
		  <xsl:apply-templates select="@*"/>
		  <unitid>
		  	<xsl:attribute name='id'><xsl:value-of select="generate-id()"/></xsl:attribute>
		  </unitid>
          <xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
    
  	<!-- special case #2; insert and/or replace existing id attributes -->
	<xsl:template match="//did/unitid">
		<xsl:copy>
		  <xsl:apply-templates select="@*"/>
		  <xsl:attribute name='id'><xsl:value-of select="generate-id()"/></xsl:attribute>
          <xsl:apply-templates select="node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!-- special case #3; remove processing instructions -->
	<xsl:template match="processing-instruction('xml-stylesheet')" />
	
</xsl:stylesheet>
