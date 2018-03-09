<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011, 2012 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%--
***** 
This object snippet displays the price for a catalog entry.

Required parameters:

type: 		This parameter is used to indicate the type of the given catalogEntry. It 
		has to be one of {product, item, bundle, package}. By default, the type 
		is either package or item.

displayPriceRange: 	This parameter is used to indicate whether or not to display the tiered
			pricing setup for the catalog entry. Only items, products, packages will
			display this.

dynamicKitprice:  Override for a 'dynamicKit' type, this parameter is used to pass in the price 
		object of particular contract.  If set, this value will override the price 
		in the catalogEntryDB (CatalogEntryViewTypeImpl) object.

The rules for price display are as follows: 
    
     For product and bundle: 
     	-- If there is no available item price, a message indicating 
           that no price is available will be displayed. 
        -- If the minimum item price is not equal to the maximum item
           price, a price range will be displayed. 
        -- If there is only one item price, and the list price is either
           unavailable or smaller than the item price, then only the
           item price will be displayed. 
        -- If there is only one item price, and the list price is greater than
           the item price, then both the list price and the item price will be
           displayed. 
           
      For item and package: 
        -- If there is no offer price, a message indicating that no price is
           available will be displayed. 
        -- If there is no list price or the list price is smaller than the 
           offer price, then only will the offer price be displayed. 
        -- If the list price is greater than the offer price, then both the
           list price and the offer price will be displayed. 
*****
--%>

<!-- BEGIN PriceDisplay.jsp -->

<%@ include file= "../../Common/JSTLEnvironmentSetup.jspf" %>

<%@ include file="ext/PriceDisplay_Data.jspf" %>
<c:if test = "${param.custom_data ne 'true'}">
	<%@ include file="PriceDisplay_Data.jspf" %>
</c:if>

<%@ include file="ext/PriceDisplay_UI.jspf" %>
<c:if test = "${param.custom_view ne 'true'}">
	<%@ include file="PriceDisplay_UI.jspf" %>
</c:if>

<!-- END PriceDisplay.jsp -->