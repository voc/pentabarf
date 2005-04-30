<?xml version="1.0" encoding="utf-8"?>
<xsl:transform version="1.1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" >

  <xsl:strip-space elements="*"/>

  <xsl:output mode="xml" />

  <xsl:template match="/">
    <events>
      <xsl:apply-templates select="//events/event" />
    </events>
  </xsl:template>

  <xsl:template match="event">
    <event>
      <id><xsl:value-of select="id" /></id>
      <title><xsl:value-of select="title" /></title>
      <subtitle><xsl:value-of select="subtitle" /></subtitle>
      <track><xsl:value-of select="track" /></track>
      <type><xsl:value-of select="type" /></type>
      <duration><xsl:value-of select="@duration" /></duration>
      <slots><xsl:value-of select="@slots" /></slots>
      <language><xsl:value-of select="language" /></language>
      <abstract><xsl:value-of select="abstract" /></abstract>
      <description>
        <xsl:apply-templates select="description/xhtml:body/xhtml:br|description/xhtml:body/text()" mode="description" />
      </description>
      <person>
        <xsl:for-each select="person">
          <xsl:text></xsl:text>
          <xsl:variable name="person-id" select="@person-id" />
          <xsl:for-each select="//persons/person[id = $person-id]">
            <xsl:value-of select="public-name" />
          </xsl:for-each>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@role" />
          <xsl:text>)&#x0a;</xsl:text>
        </xsl:for-each>
      </person>
    </event>
  </xsl:template>

  <xsl:template match="text()" mode="description">
     <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="xhtml:br" mode="description">
     <xsl:text>&#x0a;</xsl:text>
  </xsl:template>

</xsl:transform>	
