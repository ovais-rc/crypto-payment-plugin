<?xml version="1.0" encoding="UTF-8"?>
<!--
	=================================================================
	Licensed Materials - Property of IBM
	
	WebSphere Commerce
	
	(C) Copyright IBM Corp. 2008 All Rights Reserved.
	
	US Government Users Restricted Rights - Use, duplication or
	disclosure restricted by GSA ADP Schedule Contract with
	IBM Corp.
	=================================================================
-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- handle targeting condition -->
	<xsl:template name="TargetingConditionTemplate" match="/">
		<Targeting impl="com.ibm.commerce.marketing.promotion.condition.TargetingCondition">
			<!-- handle include member group -->
			<TargetedProfile>
				<xsl:for-each select="PromotionData/Elements/TargetingCondition/IncludeMemberGroupIdentifier">
					<xsl:call-template name="CustomerProfileKeyTemplate">
						<xsl:with-param name="dn" select="Data/DN" />
						<xsl:with-param name="name" select="Data/Name" />
					</xsl:call-template>
				</xsl:for-each>
			</TargetedProfile>
			<!-- handle exclude member group -->
			<ExcludedProfile>
				<xsl:for-each select="PromotionData/Elements/TargetingCondition/ExcludeMemberGroupIdentifier">
					<xsl:call-template name="CustomerProfileKeyTemplate">
						<xsl:with-param name="dn" select="Data/DN" />
						<xsl:with-param name="name" select="Data/Name" />
					</xsl:call-template>
				</xsl:for-each>
			</ExcludedProfile>
		</Targeting>
	</xsl:template>
	<!-- handle CustomerProfileKey -->
	<xsl:template name="CustomerProfileKeyTemplate">
		<xsl:param name="dn" />
		<xsl:param name="name" />
		<CustomerProfileKey>
			<OwnerDN><xsl:value-of select="$dn" /></OwnerDN>
			<ProfileName><xsl:value-of select="$name" /></ProfileName>
		</CustomerProfileKey>
	</xsl:template>
</xsl:transform>