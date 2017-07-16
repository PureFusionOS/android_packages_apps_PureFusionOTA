<?xml version="1.0" encoding="utf-8"?><!--

Copyright MetaCommunications, Inc. 2003-2005.

Distributed under the Boost Software License, Version 1.0. (See
accompanying file LICENSE_1_0.txt or copy at
http://www.boost.org/LICENSE_1_0.txt)

-->

<xsl:stylesheet xmlns:meta="http://www.meta-comm.com"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="meta" version="1.0">

    <xsl:import href="common.xsl" />

    <xsl:output encoding="utf-8" method="xml" />

    <xsl:template match="/">
        <root>
            <expected-failures>
                <xsl:apply-templates select="*//test-log" />
            </expected-failures>
        </root>
    </xsl:template>

    <xsl:template match="test-log">
        <xsl:if test="meta:is_test_log_a_test_case(.)">
            <test-result library="{@library}" result="{@result}" test-name="{@test-name}"
                toolset="{@toolset}" />
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
