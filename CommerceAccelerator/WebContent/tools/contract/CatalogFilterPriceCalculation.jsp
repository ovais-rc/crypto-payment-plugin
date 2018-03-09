<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2002, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<html>
<head>
<%@page import = "java.util.*,
			com.ibm.commerce.beans.*,
			com.ibm.commerce.command.*,
			com.ibm.commerce.catalog.beans.*,
			com.ibm.commerce.tools.catalog.util.*,
			com.ibm.commerce.catalog.objects.*,
			com.ibm.commerce.catalog.common.ECCatalogConstants,
			com.ibm.commerce.price.beans.*,
			com.ibm.commerce.utils.*,
			com.ibm.commerce.common.objects.StoreAccessBean,
			com.ibm.commerce.tools.util.*"
%>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
 	String catentry_name = null;
 	String typeToDisplay = null;
 	String priceErrorMessage = null;

	try{	
		String catentry_id = request.getParameter("catentryID");
		//catentry_name = request.getParameter("catentryName");

		PriceDataBean lowestPrice = null;


		if(catentry_id != null){
			CatalogEntryAccessBean cAB = new CatalogEntryAccessBean();
			cAB.setInitKey_catalogEntryReferenceNumber(catentry_id);

			catentry_name = cAB.getDescription(contractCommandContext.getLanguageId(), fStoreId).getName();

			String catentry_type = cAB.getType();

			if(catentry_type.equalsIgnoreCase(com.ibm.commerce.catalog.common.ECCatalogConstants.EC_CAT_PRODUCT_BEAN)){

				//System.out.println("Type: " + catentry_type);
				typeToDisplay = (String)contractsRB.get("priceCalculationProductMessage");
				priceErrorMessage = UIUtil.toJavaScript((String)contractsRB.get("priceCalculationFailedMessage"));

				com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd comm =
				(com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd)CommandFactory.createCommand(
				com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd.NAME, contractCommandContext.getStoreId());
				Long [] cList = new Long[1];
				cList[0] = new Long(request.getParameter("contractID"));
				comm.setCatEntryId(new Long(catentry_id));
				comm.setCommandContext(contractCommandContext);
				comm.setErrorMode(true);
				comm.setTradingIds(cList);
				comm.execute();
				if(comm.getPrice() != null) {
					lowestPrice = new PriceDataBean(comm.getPrice(), contractCommandContext.getStore(),contractCommandContext.getLanguageId());
					lowestPrice.setNumberUsage( com.ibm.commerce.price.utils.NumberUsageConstants.COMMERCE_UNIT_PRICE );
				}

			}else if(catentry_type.equalsIgnoreCase(com.ibm.commerce.catalog.common.ECCatalogConstants.EC_CAT_ITEM_BEAN)){

				//System.out.println("Type: " + catentry_type);
				typeToDisplay = (String)contractsRB.get("priceCalculationItemMessage");
				priceErrorMessage = UIUtil.toJavaScript((String)contractsRB.get("priceCalculationFailedMessage"));

				com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd comm =
				(com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd)CommandFactory.createCommand(
				com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd.NAME, contractCommandContext.getStoreId());
				Long [] cList = new Long[1];
				cList[0] = new Long(request.getParameter("contractID"));
				comm.setCatEntryId(new Long(catentry_id));
				comm.setCommandContext(contractCommandContext);
				comm.setErrorMode(true);
				comm.setTradingIds(cList);
				comm.execute();
				if(comm.getPrice() != null) {
					lowestPrice = new PriceDataBean(comm.getPrice(), contractCommandContext.getStore(),contractCommandContext.getLanguageId());
					lowestPrice.setNumberUsage( com.ibm.commerce.price.utils.NumberUsageConstants.COMMERCE_UNIT_PRICE );
				}

			}else if(catentry_type.equalsIgnoreCase(com.ibm.commerce.catalog.common.ECCatalogConstants.EC_CAT_PACKAGE_BEAN)){

				//System.out.println("Type: " + catentry_type);
				typeToDisplay = (String)contractsRB.get("priceCalculationPackageMessage");
				priceErrorMessage = UIUtil.toJavaScript((String)contractsRB.get("priceCalculationFailedMessage"));

				com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd comm =
				(com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd)CommandFactory.createCommand(
				com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd.NAME, contractCommandContext.getStoreId());
				Long [] cList = new Long[1];
				cList[0] = new Long(request.getParameter("contractID"));
				comm.setCatEntryId(new Long(catentry_id));
				comm.setCommandContext(contractCommandContext);
				comm.setErrorMode(true);
				comm.setTradingIds(cList);
				comm.execute();
				if(comm.getPrice() != null) {
					lowestPrice = new PriceDataBean(comm.getPrice(), contractCommandContext.getStore(),contractCommandContext.getLanguageId());
					lowestPrice.setNumberUsage( com.ibm.commerce.price.utils.NumberUsageConstants.COMMERCE_UNIT_PRICE );
				}

			}else if(catentry_type.equalsIgnoreCase(com.ibm.commerce.catalog.common.ECCatalogConstants.EC_CAT_BUNDLE_BEAN)){

				//System.out.println("Type: " + catentry_type);
				typeToDisplay = (String)contractsRB.get("priceCalculationBundleMessage");
				priceErrorMessage = UIUtil.toJavaScript((String)contractsRB.get("priceCalculationBundleFailedMessage"));

				BundleDataBean bundle = new BundleDataBean();
				bundle.setBundleID(catentry_id);
				DataBeanManager.activate(bundle, request);
				
				Long [] cList = new Long[1];
				cList[0] = new Long(request.getParameter("contractID"));
				
				com.ibm.commerce.price.utils.MonetaryAmount tempMonetaryAmount = null;
				com.ibm.commerce.price.utils.MonetaryAmount clonedMonetaryAmount = null;

				com.ibm.commerce.price.utils.MonetaryAmount fPrice = new com.ibm.commerce.price.utils.MonetaryAmount(new java.math.BigDecimal("0"), contractCommandContext.getCurrency()) ;

				com.ibm.commerce.catalog.beans.CompositeItemDataBean[] bundledItems = bundle.getBundledItems();
				PriceDataBean bundleItemPrice = null;
				for (int i=0; i < bundledItems.length; i++)
				{
					com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd comm =
					(com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd)CommandFactory.createCommand(
					com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd.NAME, contractCommandContext.getStoreId());
					comm.setCatEntryId(new Long(bundledItems[i].getItem().getItemID()));
					comm.setCommandContext(contractCommandContext);
					comm.setErrorMode(true);
					comm.setTradingIds(cList);
					comm.execute();
					if(comm.getPrice() != null) {
						bundleItemPrice = new PriceDataBean(comm.getPrice(), contractCommandContext.getStore(),contractCommandContext.getLanguageId());
						bundleItemPrice.setNumberUsage( com.ibm.commerce.price.utils.NumberUsageConstants.COMMERCE_UNIT_PRICE );
						tempMonetaryAmount = bundleItemPrice.getPrimaryPrice();				
						tempMonetaryAmount = tempMonetaryAmount.multiply(new java.math.BigDecimal(bundledItems[i].getQuantity()));
						fPrice = fPrice.add(tempMonetaryAmount);
					}						
				}

				com.ibm.commerce.catalog.beans.CompositeProductDataBean[] bundledProducts = bundle.getBundledProducts();
				for (int i=0; i < bundledProducts.length; i++)
				{
					com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd comm =
					(com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd)CommandFactory.createCommand(
					com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd.NAME, contractCommandContext.getStoreId());
					comm.setCatEntryId(new Long(bundledProducts[i].getProduct().getProductID()));
					comm.setCommandContext(contractCommandContext);
					comm.setErrorMode(true);
					comm.setTradingIds(cList);
					comm.execute();
					if(comm.getPrice() != null) {
						bundleItemPrice = new PriceDataBean(comm.getPrice(), contractCommandContext.getStore(),contractCommandContext.getLanguageId());
						bundleItemPrice.setNumberUsage( com.ibm.commerce.price.utils.NumberUsageConstants.COMMERCE_UNIT_PRICE );		
						tempMonetaryAmount = bundleItemPrice.getPrimaryPrice();
						tempMonetaryAmount = tempMonetaryAmount.multiply(new java.math.BigDecimal(bundledProducts[i].getQuantity()));
						fPrice = fPrice.add(tempMonetaryAmount);
					}						
				}

				com.ibm.commerce.catalog.beans.CompositePackageDataBean[] bundledPackages = bundle.getBundledPackages();
				for (int i=0; i < bundledPackages.length; i++)
				{
					com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd comm =
					(com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd)CommandFactory.createCommand(
					com.ibm.commerce.price.commands.GetProductContractUnitPriceCmd.NAME, contractCommandContext.getStoreId());
					comm.setCatEntryId(new Long(bundledPackages[i].getPackage().getPackageID()));
					comm.setCommandContext(contractCommandContext);
					comm.setErrorMode(true);
					comm.setTradingIds(cList);
					comm.execute();
					if(comm.getPrice() != null) {
						bundleItemPrice = new PriceDataBean(comm.getPrice(), contractCommandContext.getStore(),contractCommandContext.getLanguageId());
						bundleItemPrice.setNumberUsage( com.ibm.commerce.price.utils.NumberUsageConstants.COMMERCE_UNIT_PRICE );		
						tempMonetaryAmount = bundleItemPrice.getPrimaryPrice();
						tempMonetaryAmount = tempMonetaryAmount.multiply(new java.math.BigDecimal(bundledPackages[i].getQuantity()));
						fPrice = fPrice.add(tempMonetaryAmount);
					}						
				}

				clonedMonetaryAmount = fPrice;
		 		lowestPrice = new PriceDataBean(clonedMonetaryAmount,contractCommandContext.getStore(),contractCommandContext.getLanguageId());
		 		lowestPrice.setNumberUsage( com.ibm.commerce.price.utils.NumberUsageConstants.COMMERCE_UNIT_PRICE );		

			}

		}

		String priceToDisplay = null;
		String priceToDisplayPrice = null;
		String priceToDisplayCurrency = null;			
		if(lowestPrice != null){	
			priceToDisplay = lowestPrice.getAmount() + " " + lowestPrice.getCurrency();
			priceToDisplayPrice = lowestPrice.getAmount().toString();
			priceToDisplayCurrency = lowestPrice.getCurrency();
		}
%>



<meta name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<meta http-equiv="Content-Style-Type" content="text/css">

<link rel=stylesheet href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css">

<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
<script>

function getPrice(){

	if("<%=priceToDisplay%>" != null && "<%=priceToDisplay%>" != ""){
		alertDialog(parent.changeSpecialText("<%=UIUtil.toJavaScript((String)contractsRB.get("priceCalculationSuccessMessage"))%>", "<%=typeToDisplay%>", "<%=catentry_name%>", 
			parent.parent.parent.numberToCurrency(<%= priceToDisplayPrice %>, "<%= priceToDisplayCurrency %>", "<%= fLanguageId %>") + " " + "<%= priceToDisplayCurrency %>"));
	}else{
		alertDialog(parent.changeSpecialText("<%=UIUtil.toJavaScript((String)contractsRB.get("priceCalculationNoPriceMessage"))%>", "<%=typeToDisplay%>", "<%=catentry_name%>"));
	}
	
	parent.stopIndicator();
}

</script>
</head>

<body class="content" onload="getPrice();">

<%
	} // end try
	catch(Exception e){
%>
		<script LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js">
</script>
		<script>
			alertDialog(parent.changeSpecialText("<%=priceErrorMessage%>", "<%=typeToDisplay%>", "<%=catentry_name%>"));
			parent.stopIndicator();
		
</script>
<%
		// System.out.println(e);
	}
%>

</body>
</html>
