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
	<!-- handle purchase condition -->
	<xsl:template name="PurchaseConditionTemplate" match="/">
		<PurchaseCondition impl="com.ibm.commerce.marketing.promotion.condition.PurchaseCondition">
			<Pattern impl="com.ibm.commerce.marketing.promotion.condition.Pattern">
				<Constraint impl="com.ibm.commerce.marketing.promotion.condition.Constraint">
					<WeightedRange impl="com.ibm.commerce.marketing.promotion.condition.WeightedRange">
						<LowerBound>1</LowerBound>
						<UpperBound>-1</UpperBound>
						<Weight>1</Weight>
					</WeightedRange>
					<FilterChain impl="com.ibm.commerce.marketing.promotion.condition.FilterChain">
						<xsl:choose>
							<xsl:when test="PromotionData/Elements/PurchaseCondition/IncludePaymentTypeIdentifier/Data/PaymentType != 'Any'">
								<Filter impl="com.ibm.commerce.marketing.promotion.condition.PaymentTypeFilter">
									<IncludePaymentType>
										<PaymentMethodName><xsl:value-of select="PromotionData/Elements/PurchaseCondition/IncludePaymentTypeIdentifier/Data/PaymentType" /></PaymentMethodName>
									</IncludePaymentType>
								</Filter>
							</xsl:when>
							<xsl:otherwise>
								<Filter impl="com.ibm.commerce.marketing.promotion.condition.DummyFilter"></Filter>
							</xsl:otherwise>
						</xsl:choose>
					</FilterChain>
				</Constraint>
			</Pattern>
			<Distribution impl="com.ibm.commerce.marketing.promotion.reward.Distribution">
				<Type>Volume</Type>
				<Base>Cost</Base>
				<Currency>
					<xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/Currency" />
				</Currency>
				<Range impl="com.ibm.commerce.marketing.promotion.reward.DistributionRange">
					<LowerBound><xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/MinimumPurchase" /></LowerBound>
					<UpperBound>-1</UpperBound>
					<LowerBoundIncluded>true</LowerBoundIncluded>
					<UpperBoundIncluded>false</UpperBoundIncluded>
					<RewardChoice>
						<Reward impl="com.ibm.commerce.marketing.promotion.reward.DefaultReward">
							<AdjustmentFunction impl="com.ibm.commerce.marketing.promotion.reward.AdjustmentFunction">
								<FilterChain impl="com.ibm.commerce.marketing.promotion.condition.FilterChain">
									<xsl:choose>
										<xsl:when test="string-length(PromotionData/Elements/PurchaseCondition/IncludeShipModeIdentifier) &gt; 0">
											<Filter impl="com.ibm.commerce.marketing.promotion.condition.ShippingModeFilter">
												<DN><xsl:value-of select="PromotionData/Elements/PurchaseCondition/IncludeShipModeIdentifier/Data/DN" /></DN>
												<StoreIdentifier><xsl:value-of select="PromotionData/Elements/PurchaseCondition/IncludeShipModeIdentifier/Data/StoreIdentifier" /></StoreIdentifier>
												<Carrier><xsl:value-of select="PromotionData/Elements/PurchaseCondition/IncludeShipModeIdentifier/Data/Carrier" /></Carrier>
												<ShippingCode><xsl:value-of select="PromotionData/Elements/PurchaseCondition/IncludeShipModeIdentifier/Data/ShippingCode" /></ShippingCode>
											</Filter>
										</xsl:when>
										<xsl:otherwise>
											<Filter impl="com.ibm.commerce.marketing.promotion.condition.DummyFilter"></Filter>
										</xsl:otherwise>
									</xsl:choose>
								</FilterChain>
								<Adjustment impl="com.ibm.commerce.marketing.promotion.reward.FixedCostShippingAdjustment">
									<Currency><xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/Currency" /></Currency>
									<FixedCost><xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/FixedCost" /></FixedCost>
									<AdjustmentType><xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/AdjustmentType" /></AdjustmentType>
								</Adjustment>
							</AdjustmentFunction>
						</Reward>
					</RewardChoice>
				</Range>
				<PatternFilter impl="com.ibm.commerce.marketing.promotion.condition.DummyPatternFilter"></PatternFilter>
			</Distribution>
		</PurchaseCondition>
	</xsl:template>
</xsl:transform>
