<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="collection">
		<html>
			<head>
				<meta charset="utf-8" />
				<title>English Citations</title>
				<link rel="stylesheet" href="html5.css" />
			</head>
			<body>
				<table>
					<tr>
						<td style="font-weight: bold;">Author</td>
						<td style="font-weight: bold;">Quote</td>
					</tr>
					<xsl:apply-templates/>
				</table>
			</body>
		</html>
    </xsl:template>

    <xsl:template match="quote">
        <tr>
			<td><xsl:value-of select="@author"/></td>
			<td><xsl:value-of select="."/></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>
