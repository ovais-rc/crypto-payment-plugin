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
	<!-- Import the OrderFreeGiftBehaviorControl.xsl file to enable customization of behavior of order level free gift promotions.-->
	<xsl:import href="../../com.ibm.commerce.promotion-ext/template/OrderFreeGiftBehaviorControl.xsl"/>
	<!-- Entry template -->
	<xsl:template name="PurchaseConditionTemplate" match="/">
		<!-- handle purchase conditions -->
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
							<xsl:when test="PromotionData/Elements/PurchaseCondition/ExcludeCategoryIdentifier">
							<!-- Only populate when there are exclude categories -->
							<Filter impl="com.ibm.commerce.marketing.promotion.condition.CategoryFilter">
								<xsl:for-each select="PromotionData/Elements/PurchaseCondition/ExcludeCategoryIdentifier">
									<ExcludeCategory>
										<xsl:call-template name="CategoryKeyTemplate">
											<xsl:with-param name="dn" select="Data/DN" />
											<xsl:with-param name="name" select="Data/Name" />
										</xsl:call-template>
									</ExcludeCategory>
								</xsl:for-each>
							</Filter>
							</xsl:when>
						</xsl:choose>
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
							<xsl:when test="PromotionData/Elements/PurchaseCondition/CatalogEntryExcludeAttributeRule">
							<!-- Only populate when there are attributes -->
								<Filter
									impl="com.ibm.commerce.marketing.promotion.condition.CatalogEntryAttributeFilter">
									<AssociatedLanguage><xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/Language" /></AssociatedLanguage>
									<CaseSensitive>false</CaseSensitive>
									<SupportAttributeWithNoAssociatedLanguage>true</SupportAttributeWithNoAssociatedLanguage>
									<Inclusion>false</Inclusion>
									<xsl:for-each select="PromotionData/Elements/PurchaseCondition/CatalogEntryExcludeAttributeRule">
										<xsl:call-template name="CatalogEntryAttributeRuleTemplate">
											<xsl:with-param name="attributeRule" select="." />
										</xsl:call-template>	
									</xsl:for-each>					
								</Filter>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="PromotionData/Elements/PurchaseCondition/IncludePaymentTypeIdentifier/Data/PaymentType != 'Any'">
								<Filter impl="com.ibm.commerce.marketing.promotion.condition.PaymentTypeFilter">
									<IncludePaymentType>
										<PaymentMethodName>
											<xsl:value-of select="PromotionData/Elements/PurchaseCondition/IncludePaymentTypeIdentifier/Data/PaymentType" />
										</PaymentMethodName>
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
					<LowerBound>
						<xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/MinimumPurchase" />
					</LowerBound>
					<UpperBound>-1</UpperBound>
					<LowerBoundIncluded>true</LowerBoundIncluded>
					<UpperBoundIncluded>false</UpperBoundIncluded>
					<RewardChoice>
						<Reward impl="com.ibm.commerce.marketing.promotion.reward.DefaultReward">
							<xsl:if test="$preventRemovalOfFreeGiftFromCart = 'false'">
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
								<xsl:choose>
									<xsl:when test="PromotionData/Elements/PurchaseCondition/Data/chooseBehavior ='pickFreeGift'">
										<Adjustment impl="com.ibm.commerce.marketing.promotion.reward.DefaultChoiceOfFreeGiftAdjustment">
											<RewardSpecification impl="com.ibm.commerce.marketing.promotion.choice.gift.FreeGiftSpecification">
												<MaxQuantity>
													<xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/NoOfItems" />
												</MaxQuantity>
												<xsl:for-each select="PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier">
													<GiftItem impl="com.ibm.commerce.marketing.promotion.choice.gift.CatalogEntryGiftItem">
														<Quantity>1</Quantity>
														<xsl:call-template name="CatalogEntryKeyTemplate">
															<xsl:with-param name="dn" select="Data/DN" />
															<xsl:with-param name="sku" select="Data/SKU" />
														</xsl:call-template>
													</GiftItem>
												</xsl:for-each>
											</RewardSpecification>
											<AdjustmentType>AllAffectedItems</AdjustmentType>
										</Adjustment>
									</xsl:when>
									<xsl:otherwise>
										<Adjustment impl="com.ibm.commerce.marketing.promotion.reward.DefaultChoiceOfFreeGiftAdjustment">
											<RewardSpecification impl="com.ibm.commerce.marketing.promotion.choice.gift.FreeGiftSpecification">
												<MaxQuantity>
													<xsl:value-of select="count(PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier)" />
												</MaxQuantity>
												<xsl:for-each select="PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier">
													<GiftItem impl="com.ibm.commerce.marketing.promotion.choice.gift.CatalogEntryGiftItem">
														<Quantity>1</Quantity>
														<xsl:call-template name="CatalogEntryKeyTemplate">
															<xsl:with-param name="dn" select="Data/DN" />
															<xsl:with-param name="sku" select="Data/SKU" />
														</xsl:call-template>
													</GiftItem>
												</xsl:for-each>
											</RewardSpecification>
											<RewardChoice impl="com.ibm.commerce.marketing.promotion.choice.gift.FreeGiftChoice">
												<xsl:for-each select="PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier">
													<GiftItem impl="com.ibm.commerce.marketing.promotion.choice.gift.CatalogEntryGiftItem">
														<Quantity>1</Quantity>
														<xsl:call-template name="CatalogEntryKeyTemplate">
															<xsl:with-param name="dn" select="Data/DN" />
															<xsl:with-param name="sku" select="Data/SKU" />
														</xsl:call-template>
													</GiftItem>
												</xsl:for-each>
											</RewardChoice>
											<AdjustmentType>AllAffectedItems</AdjustmentType>
										</Adjustment>
									</xsl:otherwise>
								</xsl:choose>
								</AdjustmentFunction>
							</xsl:if>
							<xsl:if test="$preventRemovalOfFreeGiftFromCart = 'true'">
								<xsl:choose>
									<xsl:when test="PromotionData/Elements/PurchaseCondition/Data/chooseBehavior = 'pickFreeGift'">
										<AdjustmentFunction impl="com.ibm.commerce.marketing.promotion.reward.AdjustmentFunction">
											<FilterChain impl="com.ibm.commerce.marketing.promotion.condition.FilterChain">
												<Filter impl="com.ibm.commerce.marketing.promotion.condition.DummyFilter"></Filter>
											</FilterChain>
											<Adjustment impl="com.ibm.commerce.marketing.promotion.reward.DefaultChoiceOfFreeGiftAdjustment">
												<RewardSpecification impl="com.ibm.commerce.marketing.promotion.choice.gift.FreeGiftSpecification">
													<MaxQuantity>
														<xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/NoOfItems" />
													</MaxQuantity>
													<xsl:for-each select="PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier">
														<GiftItem impl="com.ibm.commerce.marketing.promotion.choice.gift.CatalogEntryGiftItem">
															<Quantity>1</Quantity>
															<xsl:call-template name="CatalogEntryKeyTemplate">
																<xsl:with-param name="dn" select="Data/DN" />
																<xsl:with-param name="sku" select="Data/SKU" />
															</xsl:call-template>
														</GiftItem>
													</xsl:for-each>
												</RewardSpecification>
												<AdjustmentType>AllAffectedItems</AdjustmentType>
											</Adjustment>
										</AdjustmentFunction>
									</xsl:when>
									<xsl:otherwise>
									<!-- Support for v6 FEP4 promotion type behavior where a shopper is unable to remove the free gift from the shopping cart. This applies only when there is one unique item added in the cart as allowed by FEP 4 promotion type-->
										<xsl:if test="count(PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier/Data/Id[not(following::GiftCatalogEntryIdentifier/Data/Id/text() = text())]) = 1">
											<AdjustmentFunction impl="com.ibm.commerce.marketing.promotion.reward.AdjustmentFunction">
												<FilterChain impl="com.ibm.commerce.marketing.promotion.condition.FilterChain">
													<Filter impl="com.ibm.commerce.marketing.promotion.condition.MultiSKUFilter">
														<IncludeCatEntryKey>
															<xsl:call-template name="CatalogEntryKeyTemplate">
																<xsl:with-param name="dn" select="PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier/Data/DN" />
																<xsl:with-param name="sku" select="PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier/Data/SKU" />
															</xsl:call-template>
														</IncludeCatEntryKey>
													</Filter>
													<Filter impl="com.ibm.commerce.marketing.promotion.condition.OrderedQuantityFilter">
														<Type>lowest</Type>
														<FilterCriteria>upto</FilterCriteria>
														<NoOfItems><xsl:value-of select="PromotionData/Elements/PurchaseCondition/Data/NoOfItems" /></NoOfItems>
													</Filter>
												</FilterChain>
												<Adjustment impl="com.ibm.commerce.marketing.promotion.reward.FreePurchasableGiftAdjustment">
													<GiftItem>
														<xsl:call-template name="CatalogEntryKeyTemplate">
															<xsl:with-param name="dn" select="PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier/Data/DN" />
															<xsl:with-param name="sku" select="PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier/Data/SKU" />
														</xsl:call-template>
													</GiftItem>
													<Quantity>1</Quantity>
													<AddStrategy>1</AddStrategy>
													<AdjustmentType>AllAffectedItems</AdjustmentType>
												</Adjustment>
											</AdjustmentFunction>											
										</xsl:if>
										<!-- If more than one item (not units of item) is automatically added to the shopper's  cart, then allow shopper to choose and decline the free gifts -->
										<xsl:if test="count(PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier/Data/Id[not(following::GiftCatalogEntryIdentifier/Data/Id/text() = text())]) &gt; 1">
											<AdjustmentFunction impl="com.ibm.commerce.marketing.promotion.reward.AdjustmentFunction">
												<FilterChain impl="com.ibm.commerce.marketing.promotion.condition.FilterChain">
													<Filter impl="com.ibm.commerce.marketing.promotion.condition.DummyFilter"></Filter>
												</FilterChain>
												<Adjustment impl="com.ibm.commerce.marketing.promotion.reward.DefaultChoiceOfFreeGiftAdjustment">
													<RewardSpecification impl="com.ibm.commerce.marketing.promotion.choice.gift.FreeGiftSpecification">
														<MaxQuantity>
															<xsl:value-of select="count(PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier)" />
														</MaxQuantity>
														<xsl:for-each select="PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier">
															<GiftItem impl="com.ibm.commerce.marketing.promotion.choice.gift.CatalogEntryGiftItem">
																<Quantity>1</Quantity>
																<xsl:call-template name="CatalogEntryKeyTemplate">
																	<xsl:with-param name="dn" select="Data/DN" />
																	<xsl:with-param name="sku" select="Data/SKU" />
																</xsl:call-template>
															</GiftItem>
														</xsl:for-each>
													</RewardSpecification>
													<RewardChoice impl="com.ibm.commerce.marketing.promotion.choice.gift.FreeGiftChoice">
														<xsl:for-each select="PromotionData/Elements/PurchaseCondition/GiftCatalogEntryIdentifier">
															<GiftItem impl="com.ibm.commerce.marketing.promotion.choice.gift.CatalogEntryGiftItem">
																<Quantity>1</Quantity>
																<xsl:call-template name="CatalogEntryKeyTemplate">
																	<xsl:with-param name="dn" select="Data/DN" />
																	<xsl:with-param name="sku" select="Data/SKU" />
																</xsl:call-template>
															</GiftItem>
														</xsl:for-each>
													</RewardChoice>
													<AdjustmentType>AllAffectedItems</AdjustmentType>
												</Adjustment>
											</AdjustmentFunction>
										</xsl:if>										
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</Reward>
					</RewardChoice>
				</Range>
				<PatternFilter impl="com.ibm.commerce.marketing.promotion.condition.DummyPatternFilter"></PatternFilter>
			</Distribution>
		</PurchaseCondition>
	</xsl:template>
	<!-- handle CatalogEntryKey -->
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