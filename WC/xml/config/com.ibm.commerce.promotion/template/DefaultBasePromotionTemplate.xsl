<?xml version="1.0" encoding="UTF-8"?>

<!--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tns="http://www.w3.org/1999/xhtml">
	<!-- handle promotion rule -->
	<xsl:template name="PromotionTemplate" match="/">
		<Promotion impl="com.ibm.commerce.marketing.promotion.DefaultPromotion">
			<!-- Promotion Key -->
			<xsl:call-template name="PromotionKeyTemplate">
				<xsl:with-param name="name" select="PromotionData/Base/Name" />
				<xsl:with-param name="version" select="PromotionData/Base/Version" />
				<xsl:with-param name="revision" select="PromotionData/Base/Revision" />
				<xsl:with-param name="storeDN" select="PromotionData/Base/StoreDN" />
				<xsl:with-param name="storeName" select="PromotionData/Base/StoreIdentifier" />
			</xsl:call-template>
			<!-- Promotion Group -->
			<xsl:call-template name="PromotionGroupKeyTemplate">
				<xsl:with-param name="name" select="PromotionData/Base/PromotionGroupIdentifier" />
				<xsl:with-param name="storeDN" select="PromotionData/Base/PromotionGroupStoreDN" />
				<xsl:with-param name="storeName" select="PromotionData/Base/PromotoinGroupStoreIdentifier" />
			</xsl:call-template>
			<!-- Description -->
			<TypedNLDescription impl="com.ibm.commerce.marketing.promotion.TypedNLDescription">
				<DefaultLocale><xsl:value-of select="PromotionData/Base/DefaultLocale" /></DefaultLocale>
				<xsl:for-each select="PromotionData/Base/Description">
					<xsl:call-template name="PromotionDescriptionTemplate">
						<xsl:with-param name="locale" select="@locale" />
						<xsl:with-param name="type" select="@type" />
						<xsl:with-param name="description" select="." />
					</xsl:call-template>
				</xsl:for-each>
				<!-- default admin desc -->
				<xsl:choose>
					<xsl:when test="PromotionData/Base/Comments">
						<xsl:call-template name="PromotionDescriptionTemplate">
							<xsl:with-param name="locale" select="PromotionData/Base/DefaultLocale" />
							<xsl:with-param name="type">admin</xsl:with-param>
							<xsl:with-param name="description" select="PromotionData/Base/Comments" />
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="PromotionDescriptionTemplate">
							<xsl:with-param name="locale" select="PromotionData/Base/DefaultLocale" />
							<xsl:with-param name="type">admin</xsl:with-param>
							<xsl:with-param name="description" select="PromotionData/Base/AdministrativeName" />
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</TypedNLDescription>
			<Priority><xsl:value-of select="PromotionData/Base/Priority" /></Priority>
			<Exclusive><xsl:value-of select="PromotionData/Base/Exclusive" /></Exclusive>
			<ExemptPolicyList />
			<ExplicitlyAppliedPolicyList />
			<Status><xsl:value-of select="PromotionData/Base/Status" /></Status>
			<LastUpdate>
						<xsl:call-template name="LastUpdateDateFormatTemplate">
							<xsl:with-param name="origDateTime" select="PromotionData/Base/LastUpdate" />
						</xsl:call-template>
			</LastUpdate>
			<LastUpdateBy>
				<xsl:call-template name="CustomerKeyTemplate">
					<xsl:with-param name="logonId" select="PromotionData/Base/LastUpdateByLogonId" />
				</xsl:call-template>
			</LastUpdateBy>
			<PerOrderLimit><xsl:value-of select="PromotionData/Base/PerOrderLimit" /></PerOrderLimit>
			<PerShopperLimit><xsl:value-of select="PromotionData/Base/PerShopperLimit" /></PerShopperLimit>
			<ApplicationLimit><xsl:value-of select="PromotionData/Base/ApplicationLimit" /></ApplicationLimit>
			<TargetSales><xsl:value-of select="PromotionData/Base/TargetSales" /></TargetSales>
			<CorrespondingRBDTypeName><xsl:value-of select="PromotionData/Base/PromotionTypeName" /></CorrespondingRBDTypeName>
			<Schedule impl="com.ibm.commerce.marketing.promotion.schedule.PromotionSchedule">
				<DateRange impl="com.ibm.commerce.marketing.promotion.schedule.DateRangeSchedule">
					<Start inclusive="true">
						<xsl:call-template name="DateRangeScheduleDateFormatTemplate">
							<xsl:with-param name="origDateTime" select="PromotionData/Base/StartDate" />
						</xsl:call-template>
					</Start>
					<End inclusive="true">
						<xsl:call-template name="DateRangeScheduleDateFormatTemplate">
							<xsl:with-param name="origDateTime" select="PromotionData/Base/EndDate" />
						</xsl:call-template>
					</End>
				</DateRange>
				<TimeWithinADay impl="com.ibm.commerce.marketing.promotion.schedule.TimeRangeWithinADaySchedule">
					<Start inclusive="true"><xsl:value-of select="PromotionData/Base/DailyStartTime" /></Start>
					<End inclusive="true"><xsl:value-of select="PromotionData/Base/DailyEndTime" /></End>
				</TimeWithinADay>
				<Week impl="com.ibm.commerce.marketing.promotion.schedule.WeekDaySchedule">
					<xsl:for-each select="PromotionData/Base/WeekDay">
						<WeekDay><xsl:value-of select="." /></WeekDay>
					</xsl:for-each>
				</Week>
			</Schedule>
			<PromotionType><xsl:value-of select="PromotionData/Base/Type" /></PromotionType>
			<!--  handle coupon attributes -->
			<xsl:choose>
				<xsl:when test="PromotionData/Base/Type='1'">
					<CouponAttribute impl="com.ibm.commerce.marketing.promotion.DefaultCouponAttribute">
						<EffectiveDays><xsl:value-of select="PromotionData/Base/EffectiveDays" /></EffectiveDays>
						<ExpirationDays><xsl:value-of select="PromotionData/Base/ExpirationDays" /></ExpirationDays>
						<AllowTransfer>false</AllowTransfer>
					</CouponAttribute>
				</xsl:when>
				<xsl:otherwise>
					<!-- handle promotion codes -->
					<xsl:choose>
						<xsl:when test="PromotionData/Base/PromotionCodeRequired='1'">
							<PromotionCodeRequired>true</PromotionCodeRequired>
							<PromotionCodeCue><xsl:value-of select="PromotionData/Base/PromotionCodeCue" /></PromotionCodeCue>
						</xsl:when>
						<xsl:otherwise>
							<PromotionCodeRequired>false</PromotionCodeRequired>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<SkipTargetingConditionOnProperPromotionCodeEntered>false</SkipTargetingConditionOnProperPromotionCodeEntered>
			<CheckTargetingConditionAtRuntime>true</CheckTargetingConditionAtRuntime>
			<PromotionCodeCondition impl="com.ibm.commerce.marketing.promotion.condition.PromotionCodeCondition" />
			<!-- handle default targeting condition -->
			<Targeting impl="com.ibm.commerce.marketing.promotion.condition.TargetingCondition" />
			<!-- handle base custom conditions -->
			<CustomConditions />
			<!-- handle default purchase conditions -->
			<PurchaseCondition impl="com.ibm.commerce.marketing.promotion.condition.AlwaysFalsePurchaseCondition" />
		</Promotion>
	</xsl:template>
	<!-- handle PromotionKey -->
	<xsl:template name="PromotionKeyTemplate">
		<xsl:param name="name" />
		<xsl:param name="version" />
		<xsl:param name="revision" />
		<xsl:param name="storeDN" />
		<xsl:param name="storeName" />
		<PromotionKey>
			<PromotionName><xsl:value-of select="$name" /></PromotionName>
			<xsl:if test="$version">
				<Version><xsl:value-of select="$version" /></Version>
			</xsl:if>
			<xsl:if test="$revision">
				<Revision><xsl:value-of select="$revision" /></Revision>
			</xsl:if>
			<xsl:call-template name="StoreKeyTemplate">
				<xsl:with-param name="name" select="$storeName" />
				<xsl:with-param name="dn" select="$storeDN" />
			</xsl:call-template>
		</PromotionKey>
	</xsl:template>
	<!-- handle PromotionGroupKey -->
	<xsl:template name="PromotionGroupKeyTemplate">
		<xsl:param name="name" />
		<xsl:param name="storeDN" />
		<xsl:param name="storeName" />
		<PromotionGroupKey>
			<GroupName><xsl:value-of select="$name" /></GroupName>
			<xsl:call-template name="StoreKeyTemplate">
				<xsl:with-param name="name" select="$storeName" />
				<xsl:with-param name="dn" select="$storeDN" />
			</xsl:call-template>
		</PromotionGroupKey>
	</xsl:template>
	<!-- handle Description -->
	<xsl:template name="PromotionDescriptionTemplate">
		<xsl:param name="locale" />
		<xsl:param name="type" />
		<xsl:param name="description" />
		<Description>
			<xsl:attribute name="locale"><xsl:value-of select="$locale" /></xsl:attribute>
			<xsl:attribute name="type"><xsl:value-of select="$type" /></xsl:attribute>
			<xsl:value-of select="$description" />
		</Description>
	</xsl:template>
	<!-- handle CustomerKey -->
	<xsl:template name="CustomerKeyTemplate">
		<xsl:param name="logonId" />
		<CustomerKey>
			<LogonId><xsl:value-of select="$logonId" /></LogonId>
		</CustomerKey>
	</xsl:template>
	<!-- handle StoreKey -->
	<xsl:template name="StoreKeyTemplate">
		<xsl:param name="dn" />
		<xsl:param name="name" />
		<StoreKey>
			<DN><xsl:value-of select="$dn" /></DN>
			<Identifier><xsl:value-of select="$name" /></Identifier>
		</StoreKey>
	</xsl:template>
	
	<!-- convert DateTime format from "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" to "dd-MM-yyyy HH:mm:ss" -->
	<xsl:template name="DateRangeScheduleDateFormatTemplate">
		<xsl:param name="origDateTime" />
		<xsl:value-of select="substring-after(substring-after(substring-before($origDateTime,'T'),'-'),'-')" />-<xsl:value-of select="substring-before(substring-after(substring-before($origDateTime,'T'),'-'),'-')" />-<xsl:value-of select="substring-before(substring-before($origDateTime,'T'),'-')" /><xsl:text> </xsl:text><xsl:value-of select="substring-before(substring-after($origDateTime,'T'),'.')" />
	</xsl:template>
	
	<!-- convert DateTime format from "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" to "dd-MM-yyyy HH:mm:ss" -->
	<xsl:template name="LastUpdateDateFormatTemplate">
		<xsl:param name="origDateTime" />
		<xsl:value-of select="substring-after(substring-after(substring-before($origDateTime,'T'),'-'),'-')" />-<xsl:value-of select="substring-before(substring-after(substring-before($origDateTime,'T'),'-'),'-')" />-<xsl:value-of select="substring-before(substring-before($origDateTime,'T'),'-')" /><xsl:text> </xsl:text><xsl:value-of select="substring-before(substring-after($origDateTime,'T'),'.')" />
	</xsl:template>
	
</xsl:transform>
