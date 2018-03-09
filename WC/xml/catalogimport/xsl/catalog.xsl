<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!--
	Hard coded constants: $StartDate, $EndDate
-->
<xsl:param name="StartDate" select="'2000-01-01 00:00:00.000000'"/>
<xsl:param name="EndDate"   select="'9999-12-31 23:59:59.000000'"/>

<!--
	Global vraiables
-->
<xsl:param name="MemberId" select="//Constants/@MemberId"/>
<xsl:param name="CatalogId" select="//Constants/@CatalogId"/>
<xsl:param name="StoreId" select="//Constants/@StoreId"/>
<xsl:param name="FFMCenterId" select="//Constants/@FFMCenterId"/>
<xsl:param name="TradingPositionContainerId" select="//Constants/@TradingPositionContainerId"/>

<xsl:template match= "/" >
	<xsl:text disable-output-escaping = "yes">&lt;!DOCTYPE import SYSTEM &quot;wcs.dtd&quot;&gt;</xsl:text>
	<xsl:element name = "import" >
		<xsl:apply-templates/>
	</xsl:element>
</xsl:template>

<xsl:template match= "category" >
	<xsl:variable name="markForDelete">
		<xsl:choose>
			<xsl:when test="string-length(@markForDelete)=0">0</xsl:when>
			<xsl:otherwise><xsl:value-of select="@markForDelete" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:element name = "catgroup" >
		<xsl:attribute name = "identifier" ><xsl:value-of select = "@categoryName" /></xsl:attribute>
		<xsl:attribute name = "member_id" ><xsl:value-of select="$MemberId" /></xsl:attribute>
		<xsl:attribute name = "markfordelete" ><xsl:value-of select = "$markForDelete" /></xsl:attribute>
		<xsl:if test="string-length(@field1)>0">
			<xsl:attribute name = "field1" ><xsl:value-of select="@field1" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@field2)>0">
			<xsl:attribute name = "field2" ><xsl:value-of select="@field2" /></xsl:attribute>
		</xsl:if>
	</xsl:element>
	<xsl:element name = "storecgrp" >
		<xsl:attribute name = "storeent_id" ><xsl:value-of select="$StoreId" /></xsl:attribute>
		<xsl:attribute name = "catgroup_id" >@<xsl:value-of select = "@categoryName" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
	</xsl:element>
</xsl:template>

<xsl:template match= "categoryDescription" >
	<xsl:element name = "catgrpdesc" >
		<xsl:attribute name = "catgroup_id" >@<xsl:value-of select = "@categoryName" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
		<xsl:attribute name = "name" ><xsl:value-of select= "@displayName" /></xsl:attribute>
		<xsl:attribute name = "fullimage" ><xsl:value-of select= "@fullImage" /></xsl:attribute>
		<xsl:attribute name = "language_id" ><xsl:value-of select = "@languageId" /></xsl:attribute>
		<xsl:attribute name = "longdescription" ><xsl:value-of select = "@longDescription" /></xsl:attribute>
		<xsl:attribute name = "published" ><xsl:value-of select= "@published" /></xsl:attribute>
		<xsl:attribute name = "shortdescription" ><xsl:value-of select = "@shortDescription" /></xsl:attribute>
		<xsl:attribute name = "thumbnail" ><xsl:value-of select= "@thumbnail" /></xsl:attribute>
	</xsl:element>
</xsl:template>

<xsl:template match= "categoryRelation" >
	<xsl:variable name="parentMemberId">
		<xsl:choose>
			<xsl:when test="string-length(@parentMemberId)=0"><xsl:value-of select="$MemberId" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="@parentMemberId" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="isTopCatGroup" select="boolean(string-length(@parent)=0)" />
	<xsl:choose>
		<xsl:when test="$isTopCatGroup">
			<xsl:element name="cattogrp">
				<xsl:attribute name = "catalog_id" ><xsl:value-of select="$CatalogId" /></xsl:attribute>
				<xsl:attribute name = "catgroup_id" >@<xsl:value-of select = "@child" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<xsl:element name = "catgrprel" >
				<xsl:attribute name = "catalog_id" ><xsl:value-of select="$CatalogId" /></xsl:attribute>
				<xsl:attribute name = "catgroup_id_parent" >@<xsl:value-of select = "@parent" />@<xsl:value-of select="$parentMemberId" /></xsl:attribute>
				<xsl:attribute name = "catgroup_id_child" >@<xsl:value-of select = "@child" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
				<xsl:attribute name = "sequence" ><xsl:value-of select = "@sequence" /></xsl:attribute>
			</xsl:element>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match= "product" >
	<xsl:variable name="markForDelete">
		<xsl:choose>
			<xsl:when test="string-length(@markForDelete)=0">0</xsl:when>
			<xsl:otherwise><xsl:value-of select="@markForDelete" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="isBaseProduct" select="boolean(string-length(@parentPartNumber)=0)" />
	<xsl:variable name="isItem" select="boolean(string(@type)='ItemBean')" />
	<xsl:variable name="baseProductPartNumber">
		<xsl:choose>
			<xsl:when test="$isBaseProduct">
				<xsl:value-of select = "@partNumber" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select = "@parentPartNumber" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:if test="$isBaseProduct">
		<xsl:element name = "baseitem" >
			<xsl:attribute name = "partnumber" ><xsl:value-of select = "@partNumber" /></xsl:attribute>
			<xsl:attribute name = "member_id" ><xsl:value-of select="$MemberId" /></xsl:attribute>
			<xsl:attribute name = "itemtype_id" >ITEM</xsl:attribute>
		</xsl:element>
		<xsl:element name = "itemversn" >
			<xsl:attribute name = "itemversn_id" >@itemversn_id_<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
			<xsl:attribute name = "baseitem_id" >@<xsl:value-of select="$MemberId" />@<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
			<xsl:attribute name = "expirationdate" ><xsl:value-of select="$EndDate" /></xsl:attribute>
		</xsl:element>
		<xsl:element name = "distarrang" >
			<xsl:attribute name="distarrang_id">@distarrang_id_<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
			<xsl:attribute name="wholesalestore_id"><xsl:value-of select="$StoreId" /></xsl:attribute>
			<xsl:attribute name="merchantstore_id"><xsl:value-of select="$StoreId" /></xsl:attribute>
			<xsl:attribute name="baseitem_id">@<xsl:value-of select="$MemberId" />@<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
			<xsl:attribute name="pickingmethod">F</xsl:attribute>
			<xsl:attribute name="startdate"><xsl:value-of select="$StartDate" /></xsl:attribute>
			<xsl:attribute name="enddate"><xsl:value-of select="$EndDate" /></xsl:attribute>
		</xsl:element>
		<xsl:element name = "storeitem" >
			<xsl:attribute name="storeent_id"><xsl:value-of select="$StoreId" /></xsl:attribute>
			<xsl:attribute name="baseitem_id">@<xsl:value-of select="$MemberId" />@<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
			<xsl:attribute name="returnnotdesired">N</xsl:attribute>
			<xsl:attribute name="minqtyforsplit">0</xsl:attribute>
		</xsl:element>
		<xsl:element name = "storitmffc" >
			<xsl:attribute name="baseitem_id">@<xsl:value-of select="$MemberId" />@<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
			<xsl:attribute name="storeent_id"><xsl:value-of select="$StoreId" /></xsl:attribute>
			<xsl:attribute name="ffmcenter_id"><xsl:value-of select="$FFMCenterId" /></xsl:attribute>
		</xsl:element>
	</xsl:if>

	<xsl:if test="$isItem">
		<xsl:element name = "itemspc" >
			<xsl:attribute name = "baseitem_id" >@<xsl:value-of select="$MemberId" />@<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
			<xsl:attribute name = "partnumber" ><xsl:value-of select = "@partNumber" /></xsl:attribute>
			<xsl:attribute name = "member_id" ><xsl:value-of select="$MemberId" /></xsl:attribute>
		</xsl:element>
		<xsl:element name = "versionspc" >
			<xsl:attribute name = "versionspc_id" >@versionspc_id_<xsl:value-of select = "@partNumber" />_<xsl:value-of select="$MemberId" />_<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
			<xsl:attribute name = "itemspc_id" >@<xsl:value-of select = "@partNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
			<xsl:attribute name = "itemversn_id" >@itemversn_id_<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
		</xsl:element>
		<xsl:element name = "receipt" >
			<xsl:attribute name = "versionspc_id" >@versionspc_id_<xsl:value-of select = "@partNumber" />_<xsl:value-of select="$MemberId" />_<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
			<xsl:attribute name="receipt_id">@receipt_id_<xsl:value-of select = "@partNumber" />_<xsl:value-of select="$MemberId" />_<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
			<xsl:attribute name="store_id"><xsl:value-of select="$StoreId" /></xsl:attribute>
			<xsl:attribute name="ffmcenter_id"><xsl:value-of select="$FFMCenterId" /></xsl:attribute>
			<xsl:attribute name="receiptdate"><xsl:value-of select="$StartDate" /></xsl:attribute>
			<xsl:attribute name="qtyreceived"><xsl:value-of select="@inventory"/></xsl:attribute>
			<xsl:attribute name="qtyonhand"><xsl:value-of select="@inventory"/></xsl:attribute>
			<xsl:attribute name="createtime"><xsl:value-of select="$StartDate" /></xsl:attribute>
		</xsl:element>
		<xsl:element name = "rcptavail" >
			<xsl:attribute name="distarrang_id">@distarrang_id_<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
			<xsl:attribute name="receipt_id">@receipt_id_<xsl:value-of select = "@partNumber" />_<xsl:value-of select="$MemberId" />_<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
		</xsl:element>
		<xsl:element name = "itemffmctr" >
			<xsl:attribute name = "itemspc_id" >@<xsl:value-of select = "@partNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
			<xsl:attribute name="store_id"><xsl:value-of select="$StoreId" /></xsl:attribute>
			<xsl:attribute name="ffmcenter_id"><xsl:value-of select="$FFMCenterId" /></xsl:attribute>
		</xsl:element>
	</xsl:if>

	<xsl:element name = "catentry" >
		<xsl:attribute name = "partnumber" ><xsl:value-of select = "@partNumber" /></xsl:attribute>
		<xsl:attribute name = "markfordelete" ><xsl:value-of select = "$markForDelete" /></xsl:attribute>
		<xsl:attribute name = "member_id" ><xsl:value-of select="$MemberId" /></xsl:attribute>
		<xsl:attribute name = "buyable" >1</xsl:attribute>
		<xsl:attribute name = "catenttype_id" ><xsl:value-of select="@type" /></xsl:attribute>
		<xsl:if test="$isBaseProduct">
			<xsl:attribute name = "baseitem_id" >@<xsl:value-of select="$MemberId" />@<xsl:value-of select = "$baseProductPartNumber" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="$isItem">
			<xsl:attribute name = "itemspc_id" >@<xsl:value-of select = "@partNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@field1)>0">
			<xsl:attribute name = "field1" ><xsl:value-of select="@field1" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@field2)>0">
			<xsl:attribute name = "field2" ><xsl:value-of select="@field2" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@field3)>0">
			<xsl:attribute name = "field3" ><xsl:value-of select="@field3" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@field4)>0">
			<xsl:attribute name = "field4" ><xsl:value-of select="@field4" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@field5)>0">
			<xsl:attribute name = "field5" ><xsl:value-of select="@field5" /></xsl:attribute>
		</xsl:if>
	</xsl:element>

	<xsl:element name = "storecent" >
		<xsl:attribute name = "storeent_id" ><xsl:value-of select="$StoreId" /></xsl:attribute>
		<xsl:attribute name = "catentry_id" >@<xsl:value-of select="@partNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
	</xsl:element>

	<xsl:element name = "catentship" >
		<xsl:attribute name = "catentry_id" >@<xsl:value-of select="@partNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
		<xsl:if test="string-length(@height)>0">
			<xsl:attribute name = "height" ><xsl:value-of select="@height" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@length)>0">
			<xsl:attribute name = "length" ><xsl:value-of select="@length" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@width)>0">
			<xsl:attribute name = "width" ><xsl:value-of select="@width" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@sizeMeasure)>0">
			<xsl:attribute name = "sizemeasure" ><xsl:value-of select="@sizeMeasure" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@weight)>0">
			<xsl:attribute name = "weight" ><xsl:value-of select="@weight" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@weightMeasure)>0">
			<xsl:attribute name = "weightmeasure" ><xsl:value-of select="@weightMeasure" /></xsl:attribute>
		</xsl:if>
	</xsl:element>

	<xsl:if test="not($isBaseProduct)">
		<xsl:element name = "catentrel" >
			<xsl:attribute name = "catentry_id_child" >@<xsl:value-of select="@partNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
			<xsl:attribute name = "catentry_id_parent" >@<xsl:value-of select="@parentPartNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
			<xsl:attribute name = "catreltype_id" >PRODUCT_ITEM</xsl:attribute>
			<xsl:attribute name = "quantity" >1</xsl:attribute>
		</xsl:element>
	</xsl:if>

	<xsl:if test="$isItem">
		<xsl:element name = "inventory" >
			<xsl:attribute name = "catentry_id" >@<xsl:value-of select="@partNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
			<xsl:attribute name = "ffmcenter_id" ><xsl:value-of select="$FFMCenterId" /></xsl:attribute>
			<xsl:attribute name = "store_id" ><xsl:value-of select="$StoreId" /></xsl:attribute>
			<xsl:attribute name = "quantity" ><xsl:value-of select="@inventory" /></xsl:attribute>
		</xsl:element>
	</xsl:if>

	<xsl:element name = "listprice" >
		<xsl:attribute name = "catentry_id" >@<xsl:value-of select = "@partNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
		<xsl:attribute name = "currency" >CAD</xsl:attribute>
		<xsl:attribute name = "listprice" >0.00</xsl:attribute>
	</xsl:element>
</xsl:template>

<xsl:template match= "productDescription" >
	<xsl:element name = "catentdesc" >
		<xsl:attribute name = "available" >1</xsl:attribute>
		<xsl:attribute name = "fullimage" ><xsl:value-of select= "@fullImage" /></xsl:attribute>
		<xsl:attribute name = "language_id" ><xsl:value-of select = "@languageId" /></xsl:attribute>
		<xsl:attribute name = "name" ><xsl:value-of select= "@displayName" /></xsl:attribute>
		<xsl:attribute name = "longdescription" ><xsl:value-of select = "@longDescription" /></xsl:attribute>
		<xsl:attribute name = "catentry_id" >@<xsl:value-of select = "@partNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
		<xsl:attribute name = "published" ><xsl:value-of select= "@published" /></xsl:attribute>
		<xsl:attribute name = "shortdescription" ><xsl:value-of select = "@shortDescription" /></xsl:attribute>
		<xsl:attribute name = "thumbnail" ><xsl:value-of select= "@thumbnail" /></xsl:attribute>
	</xsl:element>
	<xsl:variable name="isBaseItem" select="boolean(string(@type)='ProductBean')" />
	<xsl:if test="$isBaseItem">
		<xsl:element name = "baseitmdsc" >
			<xsl:attribute name = "baseitem_id" >@<xsl:value-of select="$MemberId" />@<xsl:value-of select = "@partNumber" /></xsl:attribute>
			<xsl:attribute name = "language_id" ><xsl:value-of select = "@languageId" /></xsl:attribute>
			<xsl:attribute name = "shortdescription" ><xsl:value-of select = "@shortDescription" /></xsl:attribute>
			<xsl:attribute name = "longdescription" ><xsl:value-of select = "@longDescription" /></xsl:attribute>
		</xsl:element>
	</xsl:if>
</xsl:template>

<xsl:template match= "price" >
	<xsl:variable name="partNumberMemberId">
		<xsl:choose>
			<xsl:when test="string-length(@memberId)=0"><xsl:value-of select="$MemberId" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="@memberId" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name = "offerId" >@offer_id_<xsl:value-of select = "@partNumber" />_<xsl:value-of select = "number(@price)" />_<xsl:value-of select="@currency" />_<xsl:value-of select="$partNumberMemberId" /></xsl:variable>

	<xsl:element name = "offer" >
		<xsl:attribute name = "offer_id" ><xsl:value-of select = "$offerId" /></xsl:attribute>
		<xsl:attribute name = "identifier" ><xsl:value-of select = "1" /></xsl:attribute>
		<xsl:attribute name = "catentry_id" >@<xsl:value-of select = "@partNumber" />@<xsl:value-of select="$partNumberMemberId" /></xsl:attribute>
		<xsl:attribute name = "precedence" ><xsl:value-of select = "@precedence" /></xsl:attribute>
		<xsl:if test="string-length(@startDate)>0">
			<xsl:attribute name = "startdate" ><xsl:value-of select= "@startDate" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@endDate)>0">
			<xsl:attribute name = "enddate" ><xsl:value-of select ="@endDate" /></xsl:attribute>
		</xsl:if>
		<xsl:attribute name = "published" >1</xsl:attribute>
		<xsl:attribute name = "tradeposcn_id" ><xsl:value-of select="$TradingPositionContainerId" /></xsl:attribute>
		<xsl:if test="string-length(@field1)>0">
			<xsl:attribute name = "field1" ><xsl:value-of select="@field1" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@field2)>0">
			<xsl:attribute name = "field2" ><xsl:value-of select="@field2" /></xsl:attribute>
		</xsl:if>
	</xsl:element>

	<xsl:element name = "offerprice" >
		<xsl:attribute name = "offer_id" ><xsl:value-of select = "$offerId" /></xsl:attribute>
		<xsl:attribute name = "currency" ><xsl:value-of select = "@currency" /></xsl:attribute>
		<xsl:attribute name = "price" ><xsl:value-of select = "number(@price)" /></xsl:attribute>
	</xsl:element>
</xsl:template>

<xsl:template match= "categoryProductRelation" >
	<xsl:variable name="categoryMemberId">
		<xsl:choose>
			<xsl:when test="string-length(@categoryMemberId)=0"><xsl:value-of select="$MemberId" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="@categoryMemberId" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:element name = "catgpenrel" >
		<xsl:attribute name = "catalog_id" ><xsl:value-of select="$CatalogId" /></xsl:attribute>
		<xsl:attribute name = "catgroup_id" >@<xsl:value-of select = "@categoryName" />@<xsl:value-of select="$categoryMemberId" /></xsl:attribute>
		<xsl:attribute name = "catentry_id" >@<xsl:value-of select = "@partNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
		<xsl:attribute name = "sequence" ><xsl:value-of select = "@sequence" /></xsl:attribute>
	</xsl:element>
</xsl:template>

<xsl:template match= "attribute" >
	<xsl:element name = "attribute" >
		<xsl:attribute name = "attribute_id" >@attribute_id_<xsl:value-of select = "@languageId" />_<xsl:value-of select = "@attributeName" />_<xsl:value-of select = "@parentPartNumber" /></xsl:attribute>
		<xsl:attribute name = "name" ><xsl:value-of select = "@attributeName" /></xsl:attribute>
		<xsl:attribute name = "attrtype_id" ><xsl:value-of select = "@attributeType" /></xsl:attribute>
		<xsl:attribute name = "description" ><xsl:value-of select = "@description" /></xsl:attribute>
		<xsl:attribute name = "catentry_id" >@<xsl:value-of select = "@parentPartNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute>
		<xsl:attribute name = "language_id" ><xsl:value-of select = "@languageId" /></xsl:attribute>
		<xsl:if test="string-length(@description2)>0">
			<xsl:attribute name = "description2" ><xsl:value-of select="@description2" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@sequence)>0">
			<xsl:attribute name = "sequence" ><xsl:value-of select="@sequence" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@field1)>0">
			<xsl:attribute name = "field1" ><xsl:value-of select="@field1" /></xsl:attribute>
		</xsl:if>
	</xsl:element>
</xsl:template>

<xsl:template match= "attributeValue" >
	<xsl:element name = "attrvalue" >
		<xsl:attribute name = "attribute_id" >@attribute_id_<xsl:value-of select = "@languageId" />_<xsl:value-of select = "@attributeName" />_<xsl:value-of select = "@parentPartNumber" /></xsl:attribute>
		<xsl:attribute name = "name" ><xsl:value-of select = "@attributeValue" /></xsl:attribute>
		<xsl:attribute name = "attrtype_id" ><xsl:value-of select = "@attributeType" /></xsl:attribute>
		<xsl:attribute name = "language_id" ><xsl:value-of select = "@languageId" /></xsl:attribute>
		
		<xsl:choose>
			<xsl:when test="string-length(@itemPartNumber)=0"><xsl:attribute name = "catentry_id" >0</xsl:attribute></xsl:when>
			<xsl:otherwise><xsl:attribute name = "catentry_id" >@<xsl:value-of select = "@itemPartNumber" />@<xsl:value-of select="$MemberId" /></xsl:attribute></xsl:otherwise>
		</xsl:choose>		
				
		<xsl:if test="string(@attributeType)='STRING'">
			<xsl:attribute name = "stringvalue" ><xsl:value-of select = "@attributeValue" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string(@attributeType)='INTEGER'">
			<xsl:attribute name = "integervalue" ><xsl:value-of select = "@attributeValue" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string(@attributeType)='FLOAT'">
			<xsl:attribute name = "floatvalue" ><xsl:value-of select = "@attributeValue" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@sequence)>0">
			<xsl:attribute name = "sequence" ><xsl:value-of select="@sequence" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@field1)>0">
			<xsl:attribute name = "field1" ><xsl:value-of select="@field1" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@field2)>0">
			<xsl:attribute name = "field2" ><xsl:value-of select="@field2" /></xsl:attribute>
		</xsl:if>
		<xsl:if test="string-length(@field3)>0">
			<xsl:attribute name = "field3" ><xsl:value-of select="@field3" /></xsl:attribute>
		</xsl:if>
	</xsl:element>
</xsl:template>

</xsl:stylesheet>
