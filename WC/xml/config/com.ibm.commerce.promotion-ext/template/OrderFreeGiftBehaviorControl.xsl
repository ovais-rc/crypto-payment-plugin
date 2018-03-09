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
<!-- 
	This XSLT is imported into the OrderLevelFreeGiftPurchaseConditionTemplate.xsl file located in the xml/config/com.ibm.commerce.promotion/template directory, 
	to enable customization of the behavior of order level free gift promotions. 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"> 
	<!-- Flag to choose the behavior when a free gift is automatically added to the shopping cart. If set to true, shopper is unable to remove the free gift from his/her shopping cart -->
	<xsl:variable name="preventRemovalOfFreeGiftFromCart">false</xsl:variable>
</xsl:stylesheet>