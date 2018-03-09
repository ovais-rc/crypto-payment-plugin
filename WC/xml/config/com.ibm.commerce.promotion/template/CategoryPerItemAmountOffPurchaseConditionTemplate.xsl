<?xml version="1.0" encoding="UTF-8"?>

<!--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
-->
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- handles purchase condition -->
	<xsl:template name="PurchaseConditionTemplate" match="/">
		<PurchaseCondition impl="com.ibm.commerce.marketing.promotion.condition.PurchaseCondition">
			<Pattern impl="com.ibm.commerce.marketing.promotion.condition.Pattern">
				<Constraint impl="com.ibm.commerce.marketing.promotion.condition.Constraint">
					<WeightedRange impl="com.ibm.commerce.marketing.promotion.condition.WeightedRange">
						<LowerBound>1</LowerBound>
						<UpperBound>1</UpperBound>
						<Weight>1</Weight>
					</WeightedRange>
					<FilterChain impl="com.ibm.commerce.marketing.promotion.condition.FilterChain">
						<Filter impl="com.ibm.commerce.marketing.promotion.condition.CategoryFilter">
							<xsl:for-each select="PromotionData/Elements/PurchaseCondition/IncludeCategoryIdentifier">
								<IncludeCategory>
									<xsl:call-template name="CategoryKeyTemplate">
										<xsl:with-param name="dn" select="Data/DN" />
										<xsl:with-param name="name" select="Data/Name" />
									</xsl:call-template>
								</IncludeCategory>
							</xsl:for-each>
							<xsl:for-each select="PromotionData/Elements/PurchaseCondition/ExcludeCategoryIdentifier">
								<ExcludeCategory>
									<xsl:call-template name="CategoryKeyTemplate">
										<xsl:with-param name="dn" select="Data/DN" />
										<xsl:with-param name="name" select="Data/Name" />
									</xsl:call-template>
								</ExcludeCategory>
							</xsl:for-each>
						</Filter>
						<xsl:choose>
							<xsl:when test="PromotionData/Elements/PurchaseCondition/ExcludeCatalogEntryIdentifier">
							<!-- Only populate when there are exclude items -->
								<Filter impl="com.ibm.commerce.marketing.promotion.condition.MultiSKUFilter">
									<xsl:for-each select="PromotionData/Elements/PurchaseCondition/ExcludeCatalogEntryIdentifier">
										<ExcludeCatEntryKey>
											<xsl:call-template name="CatalogEntryKeyTemplate">
												<xsl:with-param name="dn" select="Data/DN" />
												<xsl:with-param name="sku" select="Data/SKU" />
											</xsl:call-template>
										</ExcludeCatEntryKey>
									</xsl:for-each>
								</Filter>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="PromotionData/Elements/PurchaseCondition/CatalogEntryAttributeRule">
							<!-- Only populate when there are attributes -->
								<Filter
									impl="com.ibm.commerce.marketing.promotion.condition.CatalogEntryAttributeFilter">
									<AssociatedLanguage><xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/Language" /></AssociatedLanguage>
									<CaseSensitive>false</CaseSensitive>
									<SupportAttributeWithNoAssociatedLanguage>true</SupportAttributeWithNoAssociatedLanguage>
									<xsl:for-each select="PromotionData/Elements/PurchaseCondition/CatalogEntryAttributeRule">
										<xsl:call-template name="CatalogEntryAttributeRuleTemplate">
											<xsl:with-param name="attributeRule" select="." />
										</xsl:call-template>	
									</xsl:for-each>					
								</Filter>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="PromotionData/Elements/PurchaseCondition/IncludePaymentTypeIdentifier">
								<xsl:choose>
									<xsl:when test="PromotionData/Elements/PurchaseCondition/IncludePaymentTypeIdentifier/Data/PaymentType != 'Any'">
										<Filter impl="com.ibm.commerce.marketing.promotion.condition.PaymentTypeFilter">
											<IncludePaymentType>
												<PaymentMethodName><xsl:value-of select="PromotionData/Elements/PurchaseCondition/IncludePaymentTypeIdentifier/Data/PaymentType" /></PaymentMethodName>
											</IncludePaymentType>
										</Filter>
									</xsl:when>
								</xsl:choose>						
							</xsl:when>
						</xsl:choose>						
					</FilterChain>
				</Constraint>
			</Pattern>
			<xsl:choose>
				<xsl:when test="PromotionData/Elements/PurchaseCondition/Data/MinimumPurchaseType ='Amount' ">
					<Distribution impl="com.ibm.commerce.marketing.promotion.reward.ItemCostVolumeDistribution">
						<Currency><xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/Currency" /></Currency>
						<CostBase>1</CostBase>
						<xsl:for-each select="PromotionData/Elements/PurchaseCondition/DiscountRange">
							<xsl:choose>
								<xsl:when test="position()=last()">
									<xsl:call-template name="DistributionRangeTemplate">
										<xsl:with-param name="lowerBound" select="Data/LowerBound" />
										<xsl:with-param name="upperBound">-1</xsl:with-param>
										<xsl:with-param name="includeShipModeIdentifier" select="../../PurchaseCondition/IncludeShipModeIdentifier" />
										<xsl:with-param name="amountOff" select="Data/AmountOff" />
										<xsl:with-param name="priceAdjustmentBase" select="parent::*/Data/PriceAdjustmentBase" />
										<xsl:with-param name="currency" select="parent::*/Data/Currency" />
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="DistributionRangeTemplate">
										<xsl:with-param name="lowerBound" select="Data/LowerBound" />
										<xsl:with-param name="upperBound" select="following-sibling::*/Data/LowerBound" />
										<xsl:with-param name="includeShipModeIdentifier" select="../../PurchaseCondition/IncludeShipModeIdentifier" />
										<xsl:with-param name="amountOff" select="Data/AmountOff" />
										<xsl:with-param name="priceAdjustmentBase" select="parent::*/Data/PriceAdjustmentBase" />
										<xsl:with-param name="currency" select="parent::*/Data/Currency" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<PatternFilter impl="com.ibm.commerce.marketing.promotion.condition.DummyPatternFilter"></PatternFilter>
					</Distribution>				
				</xsl:when>
				<xsl:otherwise>
					<Distribution impl="com.ibm.commerce.marketing.promotion.reward.PatternQuantityVolumeDistribution">
						<xsl:for-each select="PromotionData/Elements/PurchaseCondition/DiscountRange">
							<xsl:choose>
								<xsl:when test="position()=last()">
									<xsl:call-template name="DistributionRangeTemplate">
										<xsl:with-param name="lowerBound" select="Data/LowerBound" />
										<xsl:with-param name="upperBound">-1</xsl:with-param>
										<xsl:with-param name="includeShipModeIdentifier" select="../../PurchaseCondition/IncludeShipModeIdentifier" />
										<xsl:with-param name="amountOff" select="Data/AmountOff" />
										<xsl:with-param name="priceAdjustmentBase" select="parent::*/Data/PriceAdjustmentBase" />
										<xsl:with-param name="currency" select="parent::*/Data/Currency" />
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="DistributionRangeTemplate">
										<xsl:with-param name="lowerBound" select="Data/LowerBound" />
										<xsl:with-param name="upperBound" select="following-sibling::*/Data/LowerBound" />
										<xsl:with-param name="includeShipModeIdentifier" select="../../PurchaseCondition/IncludeShipModeIdentifier" />
										<xsl:with-param name="amountOff" select="Data/AmountOff" />
										<xsl:with-param name="priceAdjustmentBase" select="parent::*/Data/PriceAdjustmentBase" />
										<xsl:with-param name="currency" select="parent::*/Data/Currency" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<PatternFilter impl="com.ibm.commerce.marketing.promotion.condition.DummyPatternFilter"></PatternFilter>
					</Distribution>
				</xsl:otherwise>
			</xsl:choose>
		</PurchaseCondition>
	</xsl:template>
	<!-- handles DistributionRange -->
	<xsl:template name="DistributionRangeTemplate">
		<xsl:param name="lowerBound">0</xsl:param>
		<xsl:param name="upperBound">-1</xsl:param>
		<xsl:param name="includeShipModeIdentifier" />
		<xsl:param name="priceAdjustmentBase">-3</xsl:param>
		<xsl:param name="amountOff" />
		<xsl:param name="currency" />
		<Range impl="com.ibm.commerce.marketing.promotion.reward.DistributionRange">
			<LowerBound><xsl:value-of select="$lowerBound" /></LowerBound>
			<UpperBound><xsl:value-of select="$upperBound" /></UpperBound>
			<LowerBoundIncluded>true</LowerBoundIncluded>
			<UpperBoundIncluded>false</UpperBoundIncluded>
			<RewardChoice>
				<Reward impl="com.ibm.commerce.marketing.promotion.reward.DefaultReward">
					<AdjustmentFunction impl="com.ibm.commerce.marketing.promotion.reward.AdjustmentFunction">
						<FilterChain impl="com.ibm.commerce.marketing.promotion.condition.FilterChain">
							<xsl:choose>
								<xsl:when test="string-length($includeShipModeIdentifier) &gt; 0">
									<Filter impl="com.ibm.commerce.marketing.promotion.condition.ShippingModeFilter">
										<DN><xsl:value-of select="$includeShipModeIdentifier/Data/DN" /></DN>
										<StoreIdentifier><xsl:value-of select="$includeShipModeIdentifier/Data/StoreIdentifier" /></StoreIdentifier>
										<Carrier><xsl:value-of select="$includeShipModeIdentifier/Data/Carrier" /></Carrier>
										<ShippingCode><xsl:value-of select="$includeShipModeIdentifier/Data/ShippingCode" /></ShippingCode>
									</Filter>
								</xsl:when>
								<xsl:otherwise>
									<Filter impl="com.ibm.commerce.marketing.promotion.condition.DummyFilter"></Filter>
								</xsl:otherwise>
							</xsl:choose>
						</FilterChain>
						<Adjustment impl="com.ibm.commerce.marketing.promotion.reward.FixedAmountOffPriceAdjustment">
							<Currency><xsl:value-of select="$currency" /></Currency>
							<AmountOff><xsl:value-of select="$amountOff" /></AmountOff>
							<AdjustmentType>IndividualAffectedItems</AdjustmentType>
							<xsl:choose>
                                 <xsl:when test="$priceAdjustmentBase!=''">
							         <PriceAdjustmentBase><xsl:value-of select="$priceAdjustmentBase" /></PriceAdjustmentBase>
							     </xsl:when>
                                 <xsl:otherwise>
							         <PriceAdjustmentBase>-3</PriceAdjustmentBase>
							     </xsl:otherwise>
							</xsl:choose>
						</Adjustment>
					</AdjustmentFunction>
				</Reward>
			</RewardChoice>
		</Range>
	</xsl:template>
	<!-- handles CatalogEntryKey -->
	<xsl:template name="CatalogEntryKeyTemplate">
		<xsl:param name="dn" />
		<xsl:param name="sku" />
		<CatalogEntryKey>
			<DN><xsl:value-of select="$dn" /></DN>
			<SKU><xsl:value-of select="$sku" /></SKU>
		</CatalogEntryKey>
	</xsl:template>
	<!-- handles CategoryKey -->
	<xsl:template name="CategoryKeyTemplate">
		<xsl:param name="dn" />
		<xsl:param name="name" />
		<CategoryKey>
			<DN><xsl:value-of select="$dn" /></DN>
			<Name><xsl:value-of select="$name" /></Name>
		</CategoryKey>
	</xsl:template>
	<!-- handles CatalogEntryAttributeRule  -->
	<xsl:template name="CatalogEntryAttributeRuleTemplate">
		<xsl:param name="attributeRule" />
		<AttributeRule>
			<Name><xsl:value-of select="Data/Name" /></Name>
			<DataType><xsl:value-of select="Data/DataType" /></DataType>
			<MatchingType><xsl:value-of select="Data/MatchingType" /></MatchingType>
			<xsl:for-each select="Data/Value">
				<Value><xsl:value-of select="." /></Value>
			</xsl:for-each>
		</AttributeRule>
	</xsl:template>		
</xsl:transform>
