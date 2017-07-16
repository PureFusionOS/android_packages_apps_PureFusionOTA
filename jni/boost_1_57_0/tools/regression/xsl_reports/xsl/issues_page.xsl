<?xml version="1.0" encoding="utf-8"?><!--

Copyright MetaCommunications, Inc. 2003-2004.

Distributed under the Boost Software License, Version 1.0. (See
accompanying file LICENSE_1_0.txt or copy at
http://www.boost.org/LICENSE_1_0.txt)

-->

<xsl:stylesheet xmlns:exsl="http://exslt.org/common"
    xmlns:func="http://exslt.org/functions" xmlns:meta="http://www.meta-comm.com"
    xmlns:set="http://exslt.org/sets" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="set str meta" extension-element-prefixes="func exsl" version="1.0">

    <xsl:import href="common.xsl" />

    <xsl:output doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" encoding="utf-8"
        indent="yes" method="html" />


    <xsl:param name="links_file" />
    <xsl:param name="mode" />
    <xsl:param name="source" />
    <xsl:param name="run_date" />
    <xsl:param name="comment_file" />
    <xsl:param name="expected_results_file" />
    <xsl:param name="explicit_markup_file" />

    <!-- the author-specified expected test results -->
    <xsl:variable name="explicit_markup" select="document( $explicit_markup_file )" />
    <xsl:variable name="expected_results" select="document( $expected_results_file )" />

    <!-- necessary indexes -->
    <xsl:key name="test_name_key" match="test-log" use="concat( @library, '@', @test-name )" />
    <xsl:key name="a" match="." use="concat( @library, '@', @test-name )" />

    <xsl:key name="library_key" match="test-log" use="@library" />
    <xsl:key name="toolset_key" match="test-log" use="@toolset" />

    <!-- toolsets -->

    <xsl:variable name="required_toolsets"
        select="$explicit_markup//mark-toolset[ @status='required' ]" />
    <xsl:variable name="required_toolset_names"
        select="$explicit_markup//mark-toolset[ @status='required' ]/@name" />
    <!-- libraries -->
    <xsl:variable name="libraries"
        select="//test-log[ @library != '' and generate-id(.) = generate-id( key('library_key',@library)[1] )  ]/@library" />

    <xsl:variable name="unexpected_test_cases"
        select="//test-log[ @status='unexpected' and @result='fail' and @toolset = $required_toolset_names and meta:is_test_log_a_test_case(.)]" />

    <func:function name="meta:get_library_tests">
        <xsl:param name="tests" />
        <xsl:param name="library" />

        <xsl:variable name="a">
            <xsl:for-each select="$tests[ @library=$library ]">
                <xsl:sort order="ascending" select="@test-name" />
                <xsl:copy-of select="." />
            </xsl:for-each>
        </xsl:variable>
        <func:result select="exsl:node-set( $a )/*" />
    </func:function>


    <xsl:template match="/">

        <xsl:variable name="issues_list" select="'issues_.html'" />

        <!-- Issues page -->
        <html>
            <head>
                <link href="../master.css" rel="stylesheet" title="master" type="text/css" />
                <title>Boost regression unresolved issues:
                    <xsl:value-of select="$source" />
                </title>
            </head>
            <frameset border="0" cols="190px,*" frameborder="0" framespacing="0">
                <frame name="tocframe" scrolling="auto" src="toc.html" />
                <frame name="docframe" scrolling="auto" src="{$issues_list}" />
            </frameset>
        </html>

        <!-- Issues list -->
        <xsl:message>Writing document
            <xsl:value-of select="$issues_list" />
        </xsl:message>

        <exsl:document doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8"
            href="{$issues_list}" indent="yes" method="html">

            <html>
                <head>
                    <link href="../master.css" rel="stylesheet" title="master" type="text/css" />
                </head>
                <body>

                    <h1 class="page-title">
                        <xsl:text>Unresolved Issues:</xsl:text>
                        <a class="hover-link" href="summary.html" target="_top">
                            <xsl:value-of select="$source" />
                        </a>
                    </h1>

                    <div class="report-info">
                        <div>
                            <b>Report Time:</b>
                            <xsl:value-of select="$run_date" />
                        </div>
                        <div>
                            <b>Purpose:</b>
                            Provides a list of current unresolved test failures.
                        </div>
                    </div>

                    <xsl:for-each select="$libraries">
                        <xsl:sort order="ascending" select="." />
                        <xsl:variable name="library" select="." />
                        <xsl:variable name="library_page" select="meta:encode_path( $library )" />

                        <xsl:variable name="library_tests"
                            select="meta:get_library_tests( $unexpected_test_cases, $library )" />
                        <xsl:if test="count( $library_tests ) > 0">
                            <xsl:variable name="library_test_names"
                                select="set:distinct( $library_tests/@test-name )" />

                            <h2>
                                <a class="hover-link" href="{$library_page}.html" target="_top">
                                    <xsl:value-of select="$library" />
                                </a>
                            </h2>

                            <table class="library-issues-table" summary="issues">
                                <thead>
                                    <tr valign="middle">
                                        <td class="head">test</td>
                                        <td class="head">failures</td>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr valign="middle">
                                        <td class="head">test</td>
                                        <td class="head">failures</td>
                                    </tr>
                                </tfoot>

                                <tbody>
                                    <xsl:for-each select="$library_test_names">
                                        <xsl:sort order="ascending" select="." />
                                        <xsl:variable name="test_name" select="." />

                                        <xsl:variable name="unexpected_toolsets"
                                            select="$library_tests[ @test-name = $test_name and not (meta:is_unusable( $explicit_markup, $library, @toolset )) ]/@toolset" />

                                        <xsl:if test="count( $unexpected_toolsets ) > 0">
                                            <xsl:variable name="test_program"
                                                select="$library_tests[@test-name = $test_name]/@test-program" />
                                            <tr>
                                                <td class="test-name">
                                                    <a class="test-link"
                                                        href="../../../{$test_program}">
                                                        <xsl:value-of select="$test_name" />
                                                    </a>
                                                </td>
                                                <td class="failures-row">
                                                    <table class="issue-box"
                                                        summary="unexpected fail legend">
                                                        <tr class="library-row-single">

                                                            <xsl:for-each
                                                                select="$unexpected_toolsets">
                                                                <xsl:sort order="ascending"
                                                                    select="." />
                                                                <xsl:variable name="toolset"
                                                                    select="." />
                                                                <xsl:variable name="test_result"
                                                                    select="$library_tests[@test-name = $test_name and @toolset = $toolset]" />
                                                                <xsl:variable name="log_link"
                                                                    select="meta:output_file_path( $test_result/@target-directory )" />
                                                                <xsl:variable name="class">
                                                                    <xsl:choose>
                                                                        <xsl:when
                                                                            test="$test_result/@is-new = 'yes'">
                                                                            <xsl:text>
                                                                                library-fail-unexpected-new
                                                                            </xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:text>
                                                                                library-fail-unexpected
                                                                            </xsl:text>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:variable>

                                                                <td class="{$class}">
                                                                    <span>
                                                                        <a class="log-link"
                                                                            href="{$log_link}"
                                                                            target="_top">
                                                                            <xsl:value-of
                                                                                select="." />
                                                                        </a>
                                                                    </span>
                                                                </td>
                                                            </xsl:for-each>

                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                    </xsl:for-each>
                                </tbody>

                            </table>


                        </xsl:if>
                    </xsl:for-each>

                    <xsl:copy-of select="document( 'html/issues_legend.html' )" />
                    <xsl:copy-of select="document( 'html/make_tinyurl.html' )" />

                </body>
            </html>
        </exsl:document>

    </xsl:template>
</xsl:stylesheet>
