<?xml version="1.0" encoding="utf-8"?><!--

Copyright MetaCommunications, Inc. 2003-2007.

Distributed under the Boost Software License, Version 1.0. (See
accompanying file LICENSE_1_0.txt or copy at
http://www.boost.org/LICENSE_1_0.txt)

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="func meta"
    extension-element-prefixes="func" version="1.0">

    <xsl:output encoding="UTF-8" method="html" />
    <xsl:template match="/">
        <html>
            <head>
                <title>BoostBook build log for
                    <xsl:value-of select="build/@timestamp" />
                </title>
                <style>
                    span.failure { background-color: red; }
                </style>
            </head>
            <body>
                <xsl:apply-templates />
            </body>
        </html>
    </xsl:template>
    <xsl:template match="build">
        <pre>
            <xsl:apply-templates />
        </pre>
    </xsl:template>

    <xsl:template match="line">
        <span class="{@type}">
            <xsl:value-of select="text()" />
        </span>
        <br />
    </xsl:template>
</xsl:stylesheet>