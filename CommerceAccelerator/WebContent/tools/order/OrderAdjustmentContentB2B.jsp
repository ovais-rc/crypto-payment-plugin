<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<%--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.user.beans.*" %>
<%@ page import="com.ibm.commerce.user.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.beans.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.objects.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.ECOptoolsConstants" %>
<%@ page import="com.ibm.commerce.order.calculation.GetOrderLevelParameterCmd" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.ibm.commerce.couponredemption.databeans.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@ page import="com.ibm.commerce.order.calculation.CalculationConstants" %>



<%@include file="../common/common.jsp" %>

<%-- 
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%! 
	// Method to get catalog entry name for an order item
		public String getOrderItemName(String catalogEntryId, HttpServletRequest request) {
			String name;
	     
			try {
				CatalogEntryDataBean aCatalogEntry	= new CatalogEntryDataBean(); 
				aCatalogEntry.setCatalogEntryID(catalogEntryId);
			
				com.ibm.commerce.beans.DataBeanManager.activate(aCatalogEntry, request);
	
		   
				// The databean did not expose the name method	
				name = aCatalogEntry.getDescription().getName();
				if (name == null) {
					return "";
				}   
		   } catch (Exception exec) {
		      // Exceptions:
		      // - catalogEntryId.length() == 0
		      // - aCatalogEntry.getDescription() == null
		   	return "";
		   }	
			return name;

		}

	public String initOrderTotals(CommandContext tmpCmdContext, OrderDataBean tmpOrderBean, String tmpOrder, Integer storeId, HttpServletRequest request)
	{
		
		try {
			String result = " totalAdjustment = new TotalAdjustment(); ";
			result += " totalAdjustment.value = -1 * "+getOrderLevelMenuAdjustment(tmpCmdContext, tmpOrderBean, storeId)+";";
			result += " updateEntry("+tmpOrder+", \"totalAdjustment\", totalAdjustment);";
		
			result += "orderLevelDiscount = new Discount();";
			result += "orderLevelDiscount.value = -1 * " + getOrderLevelDiscountForDisplay(tmpOrderBean) + ";";
			result += " updateEntry("+tmpOrder+", \"orderLevelDiscount\", orderLevelDiscount);";
		
			result += " totalTax = new TotalTax();";
			result += " totalTax.value = "+tmpOrderBean.getTotalTax()+";";
			result += " updateEntry("+tmpOrder+", \"totalTax\", totalTax);";
		
			result += " totalShipping = new ShippingCharge();";
			result += " totalShipping.value = "+tmpOrderBean.getShippingChargeTotal()+";";
			result += " updateEntry("+tmpOrder+", \"totalShipping\", totalShipping);";
			
			result += " totalBaseShipping = new BaseShippingCharge();";
			result += " totalBaseShipping.value = "+tmpOrderBean.getTotalShippingCharge()+";";
			result += " updateEntry("+tmpOrder+", \"totalBaseShipping\", totalBaseShipping);";
		
			result += " totalShippingAdjustment = new TotalShippingAdjustment();";
			result += " totalShippingAdjustment.value = "+tmpOrderBean.getShippingAdjustmentTotal()+";";
			result += " updateEntry("+tmpOrder+", \"totalShippingAdjustment\", totalShippingAdjustment);";
			
			result += " totalShippingTax = new ShippingTax();";
			result += " totalShippingTax.value = "+tmpOrderBean.getTotalShippingTax()+";";
			result += " updateEntry("+tmpOrder+", \"totalShippingTax\", totalShippingTax);";

			String couponIdDisplay = getCouponsForDisplay(tmpOrderBean, storeId, request);
			if (couponIdDisplay.length() > 0) {
				
				result += " couponIds = new Object();";
				result += " addEntry(couponIds, \"value\", \"" + couponIdDisplay +"\");"; 
				result += " updateEntry("+tmpOrder+", \"couponIds\", couponIds);";		
 				
			} else {
				result += " couponIds = new Object();";
				result += " couponIds.value = '';"; 
				result += " updateEntry("+tmpOrder+", \"couponIds\", couponIds);";		
			
			}
					
			return result;
	
		} catch (Exception exec) {
			// Exceptions:
				   	   
					   	   
			return "";
	   	}	
	
	}
	
	public double getOrderLevelDiscountForDisplay(OrderDataBean tmpOrderBean) {
		double displayDiscount = 0;
		java.math.BigDecimal discount = new java.math.BigDecimal(0);
		try {
			//discount = tmpOrderBean.getTotalAdjustmentByDisplayLevel(new Integer(1));
			discount = tmpOrderBean.getTotalAdjustmentByCalculationUsageIdAndDisplayLevel(new Integer(-1),new Integer(1));
		} catch (Exception ex) { }
		if (discount != null)
			displayDiscount = discount.doubleValue() * -1;
		return displayDiscount;
			
	}
	
	public double getOrderItemLevelDiscountForDisplay(OrderItemDataBean tmpOrderItemBean) {
		double displayDiscount = 0;
		java.math.BigDecimal discount = new java.math.BigDecimal(0);
		try {
			discount = tmpOrderItemBean.getTotalAdjustmentByDisplayLevel(new Integer(0));
		} catch (Exception ex) { }
		if (discount != null)
			displayDiscount = discount.doubleValue() * -1;
		return displayDiscount;
	}


	public String getCouponsForDisplay(OrderDataBean tempOrderBean, Integer storeId, HttpServletRequest request) {
		String orderId = tempOrderBean.getOrderId();


		
		//Obtain the coupons associated with this order
		Long orderIdLong = new Long(Long.parseLong(orderId));
		
		//Long orderIdLong = new Long(10051);
		ViewAppliedCouponDataBean couponBean = new ViewAppliedCouponDataBean();
		Vector couponList = new Vector();
		String couponIdDisplay = "";
		
		try {
			couponBean.setOrderId(orderIdLong);
			com.ibm.commerce.beans.DataBeanManager.activate(couponBean, request);
			//couponBean.populate();
			couponList = couponBean.getBcIds();
			couponIdDisplay = "";
			
			for (Enumeration e=couponList.elements(); e.hasMoreElements();)
			{	Long coupon = (Long) e.nextElement();
				couponIdDisplay += coupon.toString();
				
				if (e.hasMoreElements()) {
					couponIdDisplay += ",";
				}
			}
			
			
		} catch (Exception e) {
			System.out.println("an exception was thrown when coupon bean was populated - in OrderAdjustmentContent page");
			e.printStackTrace();
		}
		
		
		//return couponList;
		return couponIdDisplay;
	}


	public String initOrderOverrides(CommandContext tmpCmdContext, OrderDataBean tmpOrderBean, String tmpOrder, Integer storeId, HttpServletRequest request)
	{
		Vector couponList = null;
		String couponIdDisplay = "";
		try {
			String result = " totalAdjustment = new TotalAdjustment(); ";
			result += " totalAdjustment.value = -1 * "+getOrderLevelMenuAdjustment(tmpCmdContext, tmpOrderBean, storeId)+";";
			result += " updateEntry("+tmpOrder+", \"totalAdjustment\", totalAdjustment);";
		

			result += " totalShipping = new ShippingCharge();";
			result += " totalShipping.value = "+tmpOrderBean.getTotalShippingCharge()+";";
			result += " updateEntry("+tmpOrder+", \"totalShipping\", totalShipping);";


			couponIdDisplay = getCouponsForDisplay(tmpOrderBean, storeId, request);
			if (couponIdDisplay.length() > 0) {
				
				result += " couponIds = new Object();";
				result += " addEntry(couponIds, \"value\", \"" + couponIdDisplay +"\");"; 
				result += " updateEntry("+tmpOrder+", \"couponIds\", couponIds);";		
 				
			} else {
				result += " couponIds = new Object();";
				result += " couponIds.value = '';"; 
				result += " updateEntry("+tmpOrder+", \"couponIds\", couponIds);";		
			
			}
			
			
			return result;
	
		} catch (Exception exec) {
			// Exceptions:
				   	   
					   	   
			return "";
	   	}	
	
	}
	
	
	
	
	public String getOrderLevelMenuAdjustment(CommandContext tmpCmdContext, OrderDataBean tmpOrderBean, Integer storeId)
	{
	
		BigDecimal origOrderLevelMenuAdjustment = null;
		try {
			GetOrderLevelParameterCmd getAdjustment = (GetOrderLevelParameterCmd) CommandFactory.createCommand(GetOrderLevelParameterCmd.NAME, storeId);
			if (getAdjustment != null) {
				// Get order level menu adjustment
				getAdjustment.setCommandContext(tmpCmdContext);
				getAdjustment.setOrder(tmpOrderBean);
				getAdjustment.setOrderItems(tmpOrderBean.getOrderItems());
				getAdjustment.setUsageId(CalculationConstants.USAGE_DISCOUNT);
				getAdjustment.execute();
				origOrderLevelMenuAdjustment = getAdjustment.getAmount();
			}

			
			
		} catch (Exception ex) {
			return "0";
		
		}
		
		if (null != origOrderLevelMenuAdjustment)
			return origOrderLevelMenuAdjustment.toString();
		else
			return "0";
		
	

	}
	
	

	public String getEstimatedShipDate(OrderDataBean tmpOrderBean, Locale loc)
	{
						
		String result = "";
		try {
			if (null != tmpOrderBean.getEstimatedShipDate())
				result = TimestampHelper.getDateTimeFromTimestamp(tmpOrderBean.getEstimatedShipDate(), loc);
		} catch (Exception ex) {
		}
		return result;
				
		
	}
	
	public String getContractName(String contractId, HttpServletRequest request) {
		try {
			if (contractId != null && !contractId.equals("")) {
				com.ibm.commerce.contract.beans.ContractDataBean contractDataBean = new com.ibm.commerce.contract.beans.ContractDataBean();
				contractDataBean.setDataBeanKeyReferenceNumber(contractId); 
				DataBeanManager.activate(contractDataBean, request);
				return contractDataBean.getName();
			} else {
				return "";
			}

		} catch (Exception ex) {
			return "";
		}
		
	}
	
	
	public String getOrderGrandTotal(OrderDataBean tmpOrderBean) {
		try {
			return tmpOrderBean.getGrandTotal().getAmount().toString();

		} catch (Exception ex) {
			return "0";
		}
	
	
	
	
	}
	
	
	public double getOrderItemSubTotal(OrderItemDataBean tmpOrderItem) {
		double total = 0;
		try {
		
			total = tmpOrderItem.getFormattedTotalProduct().getAmount().doubleValue();
			double discount = getOrderItemLevelDiscountForDisplay(tmpOrderItem);
			total = total - discount;
			
		} catch (Exception ex) {
			//Exception
			System.out.println("Exception in OrderAdjustmentContentB2C.jsp (getOrderItemSubTotal)");	
			ex.printStackTrace();
		
			
		}
	
		return total;
	
	
	
	}
	
		
	public double getOrderSubTotal(OrderDataBean tmpOrder) {
		double total = 0;

		// obtain order item level discounts		
		double discount = 0;
		try {
			discount = tmpOrder.getTotalAdjustmentByDisplayLevel(new Integer(0)).doubleValue();
		} catch (Exception ex) { }
				
				
		try {
		
			total = tmpOrder.getTotalProductPriceInEntityType().doubleValue();
			total = total + discount;
			
		} catch (Exception ex) {
			//Exception
			System.out.println("Exception in OrderAdjustmentContentB2C.jsp (getOrderSubTotal)");	
			ex.printStackTrace();
		
			
		}
	
		return total;
	
	
	
	}
	
	
	public String getFormattedQuantity(double quantity, Locale locale) {
		java.text.NumberFormat numberFormat = java.text.NumberFormat.getNumberInstance(locale);
		return numberFormat.format(quantity);
	}

	

	
%>



<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
Hashtable orderLabels = (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
Hashtable userNLS = (Hashtable)ResourceDirectory.lookup("csr.userNLS", jLocale);	
Hashtable orderAddProducts 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderAddProducts", jLocale);
Integer storeId = cmdContextLocale.getStoreId();
String langId = cmdContextLocale.getLanguageId().toString();

CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
String localeUsed = cmdContext.getLocale().toString();
TypedProperty requestProperty = (TypedProperty) request.getAttribute(ECConstants.EC_REQUESTPROPERTIES);



com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
String firstOrderId = URLParameters.getParameter(ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID);

String secondOrderId = URLParameters.getParameter(ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID);

// Determine which order adjustment to display
// If nothing is set, default is to display the adjustment of the first order
String PARAM_NAME_DISPLAY_ADJUSTMENT_FOR_ORDER = "displayAdjustmentForOrder";
String FIRST_ORDER = "firstOrder";
String SECOND_ORDER = "secondOrder";
String displayAdjustmentFor;


OrderDataBean orderBean = new OrderDataBean ();
OrderDataBean orderBean2 = new OrderDataBean ();
OrderItemDataBean[] afirstOrderItems = null;
OrderItemDataBean[] asecondOrderItems = null;
boolean firstOrderExist = false;
boolean secondOrderExist = false;


if ((firstOrderId != null) && !(firstOrderId.equals(""))) {
	orderBean.setSecurityCheck(false);
	orderBean.setOrderId(firstOrderId);
	com.ibm.commerce.beans.DataBeanManager.activate(orderBean, request);
	afirstOrderItems = orderBean.getOrderItemDataBeans();
	if (afirstOrderItems.length != 0)
		firstOrderExist = true;
}

if ((secondOrderId != null) && !(secondOrderId.equals(""))) {
	orderBean2.setSecurityCheck(false);
	orderBean2.setOrderId(secondOrderId);
	com.ibm.commerce.beans.DataBeanManager.activate(orderBean2, request);
	asecondOrderItems = orderBean2.getOrderItemDataBeans();
	if (asecondOrderItems.length != 0)
		secondOrderExist = true;
}


try {
	displayAdjustmentFor = URLParameters.getParameter(PARAM_NAME_DISPLAY_ADJUSTMENT_FOR_ORDER);
} catch (Exception ex) {
	if (!firstOrderExist)
		displayAdjustmentFor = SECOND_ORDER;
	else
		displayAdjustmentFor = FIRST_ORDER;
}

if (null == displayAdjustmentFor)
	if (!firstOrderExist)
		displayAdjustmentFor = SECOND_ORDER;
	else
		displayAdjustmentFor = FIRST_ORDER;

%>


<html>
  <head>  
    <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />

    <title><%= UIUtil.toHTML(orderMgmtNLS.get("wizardConfirmTitle").toString()) %></title>   
    <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
    <script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>


    <script type="text/javascript">
	<!-- <![CDATA[
      var langId = <%=UIUtil.toJavaScript(langId)%>;
     
      var order = parent.parent.get("order");
      if (!defined(order)) {
          	 order = new Object();
          	 parent.parent.put("order", order);
      }
      
      var manualShippingOverride = false;      
     
      // remove preCommand in XML when this page loaded
	var preCommand = parent.parent.get("preCommand");
	if (defined(preCommand) && preCommand != "") {
		parent.parent.remove("preCommand");
	}
     // Clean up the chains of pre commands in the XML when this page is loaded
     	removePreCmdChain();
     
     // for first order
     if (defined(order["firstOrder"])) {
          
     	firstOrder = order["firstOrder"];
     	
     	
     	if (!defined(firstOrder))
     	{
     	 	firstOrder = new Object(); 
     		
     	}
     	
   
//alert("0" + parent.parent.modelToXML("XML"));  	
     	if (!ifOrderOverrideDefined(firstOrder))
     	{
     		<%= initOrderOverrides(cmdContextLocale, orderBean, "firstOrder", storeId, request) %>      
     		updateEntry(order, "firstOrder", firstOrder);
     		
     		var origFirstOrder = new Object();
     		<%= initOrderOverrides(cmdContextLocale, orderBean, "origFirstOrder", storeId, request) %>      
     		parent.parent.put("origFirstOrder", origFirstOrder);

     	} 
/*     	else {
     		//alert("else statement true");
	     	couponIds = firstOrder["couponIds"];
	     	if (!defined(couponIds)) {
	     		couponIds = new Object();
	     		couponIds.value = "";
	     		addEntry(firstOrder, "couponIds", couponIds);
	     	}
	     	
        }
*/	     	
     	
     }	
     
//alert("1" + parent.parent.modelToXML("XML"));
    
     var firstOrderTotals = new Object();
     updateEntry(firstOrderTotals, "subTotal", <%=getOrderSubTotal(orderBean)%>);
     updateEntry(firstOrderTotals, "grandTotal", <%= UIUtil.toJavaScript(getOrderGrandTotal(orderBean)) %>);
   
     <%= initOrderTotals(cmdContextLocale, orderBean, "firstOrderTotals", storeId, request) %>

     
     // For 2nd order
     if (defined(order["secondOrder"])) 
     {
     	  var secondOrder = order["secondOrder"];
      	  if (!defined(secondOrder))
      	  {
     	  	secondOrder = new Object();
     	       	  	
          }
          
          if (!ifOrderOverrideDefined(secondOrder))
          {
          	<% if (secondOrderExist) { %>
	    		<%= initOrderOverrides(cmdContextLocale, orderBean2, "secondOrder", storeId, request) %>
	       		updateEntry(order, "secondOrder", secondOrder);
	       		
	       		var origSecondOrder = new Object();
			<%= initOrderOverrides(cmdContextLocale, orderBean2, "origSecondOrder", storeId, request) %>      
     			parent.parent.put("origSecondOrder", origSecondOrder);
	       	<% } %>	
          } 	
                  
     	  <% if (secondOrderExist) { %>
          	var secondOrderTotals = new Object();
	  	updateEntry(secondOrderTotals, "subTotal", <%=getOrderSubTotal(orderBean2)%>);
	  	updateEntry(secondOrderTotals, "grandTotal", <%= UIUtil.toJavaScript(getOrderGrandTotal(orderBean2)) %>);

	  	<%= initOrderTotals(cmdContextLocale, orderBean2, "secondOrderTotals", storeId, request) %>
	  <% } %>	

     }
           
	function removePreCmdChain() {
		parent.parent.remove("preCmdChain");
	}

	
     function ifOrderOverrideDefined(tmpOrder)
     {
     	return (defined(tmpOrder["totalAdjustment"]));
     
     }

      function validateTotalAdjustment(name)
      {
          parent.validateTotalAdjustment(name);
                 
      }

      function validateShippingCharge(name)
      {
          parent.validateShippingCharge(name);
          
      }
      
           
    
      
      function displayTotals(tmpOrder, formVarNameIndex, tmpOrigOrderTotals, currency)
      {
      	
	var discount = tmpOrigOrderTotals["orderLevelDiscount"];
        if (!defined(discount)) {
        	discount = new Discount();
        	discount.value = 0;
        	addEntry(tmpOrigOrderTotals,"orderLevelDiscount", discount);
        }
                
        var totalTax = tmpOrigOrderTotals["totalTax"];
        var totalShippingTax = tmpOrigOrderTotals["totalShippingTax"];

        if(!defined(totalTax))
        {
          totalTax = new TotalTax();
          totalTax.value = 0;
          addEntry(tmpOrigOrderTotals, "totalTax", totalTax);
        }

        if(!defined(totalShippingTax))
        {
          totalShippingTax = new ShippingTax();
          totalShippingTax.value = 0;
          addEntry(tmpOrigOrderTotals, "totalShippingTax", totalShippingTax);
        }
        
        var allTax = totalTax.value + totalShippingTax.value;
        
        var subTotal = tmpOrigOrderTotals["subTotal"];
	if(!defined(subTotal))
        {
          subTotal = 0;
          addEntry(tmpOrigOrderTotals, "subTotal", subTotal);
        }

        var grandTotal = tmpOrigOrderTotals["grandTotal"];
	if(!defined(grandTotal))
        {
          grandTotal = 0;
          
        }

        var totalShipping = tmpOrder["totalShipping"];

        if(!defined(totalShipping))
        {
          totalShipping = new ShippingCharge();
          totalShipping.value = 0;
          addEntry(tmpOrder, "totalShipping", totalShipping);
        }

	var orderBeanShipping = tmpOrigOrderTotals["totalShipping"];
	if (defined(totalShipping) && defined(orderBeanShipping)) {
		if (totalShipping.value != orderBeanShipping.value) {
			totalShipping.value = orderBeanShipping.value;
			addEntry(tmpOrder, "totalShipping", totalShipping);
		}
	}
	
    var totalBaseShipping = tmpOrigOrderTotals["totalBaseShipping"];

    if(!defined(totalBaseShipping))
    {
      totalBaseShipping = new BaseShippingCharge();
      totalBaseShipping.value = 0;
      addEntry(tmpOrder, "totalBaseShipping", totalBaseShipping);
    }   
	
    var totalShippingAdjustment = tmpOrigOrderTotals["totalShippingAdjustment"];

    if(!defined(totalShippingAdjustment))
    {
    	totalShippingAdjustment = new TotalShippingAdjustment();
    	totalShippingAdjustment.value = 0;
      addEntry(tmpOrder, "totalShippingAdjustment", totalShippingAdjustment);
    }

	var totalAdjustment = tmpOrder["totalAdjustment"];
	
	if(!defined(totalAdjustment))
	{
	 	totalAdjustment = new TotalAdjustment();
	 	totalAdjustment.value = 0;
	 	addEntry(tmpOrder, "totalAdjustment", totalAdjustment);
	 }
	 
	 
	document.writeln("<tr>");
        document.writeln("  <td></td>");
        document.writeln("  <td></td>");
        document.writeln("  <td colspan=2 align=right nowrap><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("adjustmentSubTotal")) %></td>");
        document.writeln("  <td align=right>");
        document.writeln(     parent.parent.numberToCurrency(subTotal, currency, langId));
        document.writeln("  </td>");
        document.writeln("</tr>");

	
	
	document.writeln("<tr>");
        document.writeln("  <td></td>");
        document.writeln("  <td></td>");
        document.writeln("  <td colspan=2 align=right nowrap><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("orderLevelDiscount")) %></td>");
        document.writeln("  <td align=right>");
        document.writeln(     parent.parent.numberToCurrency(discount.value, currency, langId));
        document.writeln("  </td>");
        document.writeln("</tr>");


        document.writeln("<tr>");
	document.writeln("  <td></td>");
	document.writeln("  <td></td>");
	document.writeln("  <td colspan=2 align=right nowrap><label for='adjustment"+formVarNameIndex+"'><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("minusOrderLevelAdjustment")) %></label></td>");
	document.writeln("  <td align=right>");
	document.writeln("    <input type='text' style='text-align:right' maxlength='10' name='adjustment"+formVarNameIndex+"' id='adjustment"+formVarNameIndex+"' size=7 align='right' ONFOCUS='parent.setDirtyBit(true);' ONCHANGE='enableUNDO();validateTotalAdjustment(name);' value='" + parent.parent.numberToCurrency(totalAdjustment.value, currency, langId) + "'>");
	document.writeln("  </td>");
	document.writeln("</tr>");

        
        document.writeln("<tr>");
        document.writeln("  <td></td>");
        document.writeln("  <td></td>");
        document.writeln("  <td colspan=2 align=right nowrap><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("totalOriginalShippingCharge")) %></td>");
        document.writeln("  <td align=right>");
       // document.writeln("  <input type='text' style='text-align:right' maxlength='10' name='totalShipping"+formVarNameIndex+"' size=7 align='right' ONFOCUS='parent.setDirtyBit(true);' ONCHANGE='enableUNDO();manualShippingOverride=true;validateShippingCharge(name);' value='" + parent.parent.numberToCurrency(totalShipping.value, currency, langId) + "'>");
       	document.writeln(	parent.parent.numberToCurrency(totalBaseShipping.value, currency, langId));
       	document.writeln("  </td>");
        document.writeln("</tr>");
       
        
        document.writeln("<tr>");
        document.writeln("  <td></td>");
        document.writeln("  <td></td>");
        document.writeln("  <td colspan=2 align=right nowrap><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("totalShippingAdjustment")) %></td>");
        document.writeln("  <td align=right>");       
       	document.writeln(	parent.parent.numberToCurrency(totalShippingAdjustment.value, currency, langId));
       	document.writeln("  </td>");
        document.writeln("</tr>");
        
        document.writeln("<tr>");
        document.writeln("  <td></td>");
        document.writeln("  <td></td>");
        document.writeln("  <td colspan=2 align=right nowrap><label for='totalShipping"+formVarNameIndex+"'><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("totalShippingCharge")) %></label></td>");
        document.writeln("  <td align=right>");    
        document.writeln("  <input type='text' style='text-align:right' maxlength='10' name='totalShipping"+formVarNameIndex+"' id='totalShipping"+formVarNameIndex+"' size=7 align='right' ONFOCUS='parent.setDirtyBit(true);' ONCHANGE='enableUNDO();manualShippingOverride=true;validateShippingCharge(name);' value='" + parent.parent.numberToCurrency(totalShipping.value, currency, langId) + "'>");
	document.writeln("  </td>");
        document.writeln("</tr>");
       
       
        document.writeln("<tr>");
        document.writeln("  <td></td>");
        document.writeln("  <td></td>");
        document.writeln("  <td colspan=2 align=right nowrap><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("totalTax")) %></td>");
        document.writeln("  <td align=right>");
        document.writeln(	parent.parent.numberToCurrency(allTax, currency, langId));
        document.writeln("  </td>");
        document.writeln("</tr>");
        

        document.writeln("<tr>");
        document.writeln("  <td></td>");
        document.writeln("  <td></td>");
        document.writeln("  <td colspan=2 align=right nowrap><b><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("grandTotal")) %>&nbsp;[" + currency + "]</b></td>");
        document.writeln("  <td align='right'><b>" + parent.parent.numberToCurrency(grandTotal, currency, langId) + "</b>");
        document.writeln("  </td>");
        document.writeln("</tr>");
        
        if (grandTotal < 0)
        {
        	var str = "<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("invalidOrderTotal")) %>";
        	alertDialog(str);
        
        }
        
       
      }// END displayTotals
      
      

      // get the xml data from the parent window
      function initializeState() 
      {
        parent.initializeState();
        <%
	 if (null != displayAdjustmentFor && displayAdjustmentFor.equals(SECOND_ORDER))
	 {
	%>
		if (defined(this.document.itemSummary.showAdjustment))
	 		this.document.itemSummary.showAdjustment.options[1].selected = true;
	   	
	   
	<% 
	 }
    	%>	
    	disableUNDO();
      }
      
      function recalculate()
      {
        if(saveEntries()) {
	      	var order	= parent.parent.get("order");
	      	var firstOrder 	= order["firstOrder"];
	      	var secondOrder = order["secondOrder"];
      	
		var xmlObject = parent.parent.modelToXML("XML");
		document.callActionForm.action="CSROrderAdjustmentUpdate";
		document.callActionForm.XML.value=xmlObject;
			
		if (("<%=firstOrderExist%>" == "true") && ("<%=secondOrderExist%>" == "true")) {
			document.callActionForm.URL.value="OrderAdjustmentContentB2B?<%= ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID %>=<%= firstOrderId %>&<%= ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID %>=<%= secondOrderId %>";
		} else if (("<%=firstOrderExist%>" == "true")) {
		    	document.callActionForm.URL.value="OrderAdjustmentContentB2B?<%= ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID %>=<%= firstOrderId %>";
		} else {
		    	document.callActionForm.URL.value="OrderAdjustmentContentB2B?<%= ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID %>=<%= secondOrderId %>";
		}
			
		parent.parent.setContentFrameLoaded(false);
	
		document.callActionForm.submit();
	}        
      }


	function restoreOrderOverrideValues(tmpOrigOrder, formVarNamExtention, currency)
	{
		var itemSummaryForm = document.itemSummary;
		
		var origShipping = tmpOrigOrder["totalShipping"];
		var origTotalAdjustment = tmpOrigOrder["totalAdjustment"];
		var origCouponIds = tmpOrigOrder["couponIds"];
		if (!defined(origCouponIds)) {
			origCouponIds = new Object();
			origCouponIds.value = '';
		}
		//alert("coupon value = origCouponIds.value = " + origCouponIds.value);
		
		itemSummaryForm["totalShipping"+formVarNamExtention].value = parent.parent.numberToCurrency(origShipping.value, currency, langId);
		itemSummaryForm["adjustment"+formVarNamExtention].value = parent.parent.numberToCurrency(origTotalAdjustment.value, currency, langId);
		itemSummaryForm["couponIds"+formVarNamExtention].value = origCouponIds.value;
		
	}

	function restoreOverrideValues(ifRestoreFirstOrder, currency)
	{
		
		if (ifRestoreFirstOrder)
		{
			//var origFirstOrder = parent.parent.get("origFirstOrder");
			restoreOrderOverrideValues(firstOrderTotals, "", currency);
		} else {	
		
			//var origSecondOrder = parent.parent.get("origSecondOrder");
			restoreOrderOverrideValues(secondOrderTotals, "second", currency);
			
		
		}
		
		
		//recalculate();
		//disable the UNDO button
		disableUNDO();
		
	}
	

	function validateCoupons(formCouponName) {
	
		var itemSummaryForm = document.itemSummary;
		var num = itemSummaryForm[formCouponName].value;
		num = num.replace(/ /g, "");
		return num;            
	}

      //**********************************************************************
      //* Save order override in the form to the the tmpOrder object
      //*
      //* return true, if successfull; false, otherwise.
      //*********************************************************************~/
      function saveOrderOverrideEntry(tmpOrder, formVarNamExtention)
      {
        var itemSummaryForm = document.itemSummary;
        
                
        // Validate and save the shipping charge
        var newTotalShipping = parent.validateShippingCharge("totalShipping"+formVarNamExtention);
	
        if(newTotalShipping == null)
          return(false);

        updateEntry(tmpOrder["totalShipping"], "value", newTotalShipping);


        //Validate and save the order level menual adjustments
	var newAdjustmentTotal = parent.validateTotalAdjustment("adjustment"+formVarNamExtention);
	
	if(newAdjustmentTotal == null)
	     return(false);
	
        updateEntry(tmpOrder["totalAdjustment"], "value", newAdjustmentTotal);
        
        //handle coupons
        
	var validatedCouponValue = validateCoupons("couponIds"+formVarNamExtention);
	couponIds.value = validatedCouponValue;  	
	//alert("in save entries, secondOrder couponValue=" + validatedCouponValue);
 	updateEntry(tmpOrder, "couponIds", couponIds);
        
        return(true);

      }// END saveOrderOverrideEntry      



      function updateDirtyBit(tmpOrder, value)
      {
      
      
          updateEntry(tmpOrder, "dirtyBit", value);
          
      }
      
      
      //**********************************************************************
      //* Get a string representation of the couponIds stored in the vector
      //* passed to it as argument.
      //*
      //* return the display value of the coupons (coupon ids separated by comma)
      //*********************************************************************~/      
      function getCouponDisplayValue(couponIds) {
      	var couponList = new Vector();
      	couponList = couponIds;
      	couponDisplay = "";
      	
      	if (defined(couponList) && (couponList != null)) {
      		for (var i=0; i<size(couponList); i++) {
      			var aCoupon = elementAt(i, couponList);
      			couponDisplay += aCoupon;
      			
      			if (i<size(couponList)-1) {
      				couponDisplay += ",";
      			}
      		}
      	}
      	
      	return couponDisplay;
      }
      
      
      //**********************************************************************
      //* Create a vector of couponsIds  
      //* The parameter is the string of couponIds separated by commas.
      //*
      //* return the vector of coupon Ids
      //*********************************************************************~/      
      
      function parseCouponDisplayToVector(couponDisplay) {
      	couponString = couponDisplay;
      	couponString = couponString.replace(/ /g, "");
      	var couponArray = couponString.split(",");
      	var couponVector = new Vector();
      	
      	for (var i=0; i<couponArray.length; i++) {
      		addElement(couponVector, couponArray[i]);
      	}
      	
      	return couponVector(); 
      }


      //**********************************************************************
      //* Save all entries into the model.
      //*
      //* return true, if successfull; false, otherwise.
      //*********************************************************************~/
      function saveEntries()
      {
        
        var result = true;        
        var order = parent.parent.get("order");
        var couponIds = new Object();
    
       <%
	 if (null != displayAdjustmentFor && displayAdjustmentFor.equals(SECOND_ORDER))
	 {
	%>

		var secondOrder = order["secondOrder"];
         	if (defined(secondOrder)) {
         		result = saveOrderOverrideEntry(secondOrder, "second");
 			if (false == result)
 				return (false);
 			
 			updateDirtyBit(secondOrder, "true");
 			if (manualShippingOverride) updateEntry(secondOrder, "shippingOverride", "true");
 		  		
         	}

 
 
 
    
        <% } else { %>
 
     	    var firstOrder = order["firstOrder"];
     	    if (defined(firstOrder)) {
     	    	result = saveOrderOverrideEntry(firstOrder, "");
 		if (false == result)
 			return (false);
 		
 		updateDirtyBit(firstOrder, "true");
 		if (manualShippingOverride) updateEntry(firstOrder, "shippingOverride", "true");
 		
     	    }
		//alert("save entries " + parent.parent.modelToXML("XML"));
        	
        <% } %>	
        
        
        
                
        return(true);

      }// END saveEntries      
      
      function displayOrderAdjustments(value)
      {
      
      	var url = "/webapp/wcs/tools/servlet/OrderAdjustmentContentB2B?"+
		"<%= ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID %>=<%= firstOrderId %>&"+
      		"<%= ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID %>=<%= secondOrderId %>&"+
      		"<%= PARAM_NAME_DISPLAY_ADJUSTMENT_FOR_ORDER  %>="+value;
      	
      	saveEntries();
	this.location.replace(url);   
      }
      
      function enableUNDO() {
      	document.itemSummary.restoreValueBtn.disabled = false;
      }
      
      function disableUNDO() {
      	document.itemSummary.restoreValueBtn.disabled = true;
      	manualShippingOverride = false;
      }
      
      function savePanelData() {
        parent.parent.put("callPrepareRequired", "true");       
      }// END savePanelData()
      
      //alert("displayOrderAdjustment " + parent.parent.modelToXML("XML"));
    //[[>-->
    </script>
  </head>
  <body  class='content' onload="initializeState();" >        
  <!--Support For Customers,Shopping Under Multiple Accounts.-->
	<form name="itemSummary" method="post" action="">
  <%request.setAttribute("resourceBundle", orderAddProducts);%> 
<jsp:include page="ActiveOrganization.jsp"
	flush="true" /> 
	<br />
	
	<% if (firstOrderExist && secondOrderExist) { %>
	      	<table>
 			<tr>
				<td align="left">
					<p><b><label for="forAdjustment"><%= UIUtil.toHTML(orderMgmtNLS.get("showAdjustmentForTheFollowing").toString()) %></label></b></p>
				</td>
			</tr>
			<tr>
				<td align="left">
					<select id="forAdjustment" name="showAdjustment" size=2 onchange="displayOrderAdjustments(value);"> 
						<option id="firstOrder" value="<%= FIRST_ORDER %>" selected ="selected"><%= UIUtil.toHTML(orderMgmtNLS.get("showAdjustmentForCurrentOrder1").toString()) %> <%= firstOrderId %><%= UIUtil.toHTML(orderMgmtNLS.get("showAdjustmentForCurrentOrder2").toString()) %> </option> 
						<option id="secondOrder" value="<%= SECOND_ORDER %>"> <%= UIUtil.toHTML(orderMgmtNLS.get("showAdjustmentForOtherOrder1").toString()) %> <%= secondOrderId %><%= UIUtil.toHTML(orderMgmtNLS.get("showAdjustmentForOtherOrder2").toString()) %> </option> 
					</select>
				</td>
			</tr>
		</table>
		<br />
	<% } %>	




	<!-- Add first order information -->
	<%
	if (firstOrderExist && (null != displayAdjustmentFor && displayAdjustmentFor.equals(FIRST_ORDER))) { 
	%>
 
 	      	<table>
 			<tr>
 				<td align="left"><%= UIUtil.toHTML( (String) orderMgmtNLS.get("estimatedShipDate")) %><%= UIUtil.toHTML( (String) orderMgmtNLS.get("labelTextSeparator")) %></td>
 				<td><i><%= getEstimatedShipDate(orderBean, jLocale) %></i></td>
 			</tr>
 		</table>

 
	
		<table class="list" width="99%" cellpadding="2" cellspacing="1" summary='<%= UIUtil.toHTML(orderMgmtNLS.get("orderInfo").toString()) %>'>
			<tr class="list_roles" align="center"> 
				<th class="list_header" id="iNa"><%= UIUtil.toHTML(orderMgmtNLS.get("itemName").toString()) %></td>
				<th class="list_header" id="iNu"><%= UIUtil.toHTML(orderMgmtNLS.get("itemNumber").toString()) %></td>
				<th class="list_header" id="iQu"><%= UIUtil.toHTML(orderMgmtNLS.get("itemQuantity").toString()) %></td>
				<th class="list_header" id="iCt"><%= UIUtil.toHTML(orderMgmtNLS.get("AdjustmentPageContractName").toString()) %></td>			
				<th class="list_header" id="iPr"><%= UIUtil.toHTML(orderMgmtNLS.get("itemPrice").toString()) %></td>
				<th class="list_header" id="iDs"><%= UIUtil.toHTML(orderMgmtNLS.get("orderItemLevelDiscount").toString()) %></td>
				<th class="list_header" id="iTo"><%= UIUtil.toHTML(orderMgmtNLS.get("itemTotal").toString()) %></td>
			</tr>


		<%
			String classId="list_row2";
			for (int i=0; afirstOrderItems != null && i<afirstOrderItems.length && afirstOrderItems[i].getCatalogEntryId().length()!=0; i++) {
		%>
			<tr class="<%= UIUtil.toHTML(classId) %>">
				<td class="list_info1" align="left">
					<%= UIUtil.toHTML(getOrderItemName(afirstOrderItems[i].getCatalogEntryId(), request)) %>
				</td>
				<td class="list_info1" align="left">
					<%= UIUtil.toHTML(afirstOrderItems[i].getPartNumber()) %>
				</td>
				<td class="list_info1" align="left">
					<%= UIUtil.toHTML(getFormattedQuantity(afirstOrderItems[i].getQuantityInEntityType().doubleValue(), jLocale)) %>
				</td>
				<td class="list_info1" align="left">
					<%= UIUtil.toHTML(getContractName(afirstOrderItems[i].getContractId(), request)) %>
				
				</td><td class="list_info1" align="right">
					<script>document.writeln(parent.parent.numberToCurrency("<%=afirstOrderItems[i].getPrice()%>", "<%= orderBean.getCurrency() %>", langId))</script>
				</td>
				<td class="list_info1" align="right">
					<script>document.writeln(parent.parent.numberToCurrency("<%=getOrderItemLevelDiscountForDisplay(afirstOrderItems[i])%>", "<%= orderBean.getCurrency() %>", langId))</script>
				</td>	
				<td class="list_info1" align="right">
					<script>document.writeln(parent.parent.numberToCurrency("<%=getOrderItemSubTotal(afirstOrderItems[i])%>", "<%= orderBean.getCurrency() %>", langId))</script>	 
				</td>	
			</tr>
		<%
				if (classId.equals("list_row2")) classId="list_row1";
				else classId="list_row2";
			}
		%>
		</table>
	
		<br />
	
		<table width="99%">
			<tr>
		          <td colspan="6" align="right">
					<script type="text/javascript">
					<!-- <![CDATA[
						document.writeln("<table cellpadding='0' cellspacing='0' border='0'>");
						var order = parent.parent.get("order");
						var firstOrder = order["firstOrder"];
						displayTotals(firstOrder, "", firstOrderTotals, "<%= orderBean.getCurrency() %>");
						document.writeln("<TR><TD><BR></TD></TR>");
		                
						var couponIds = firstOrder["couponIds"];
				
						//alert("from from display: couponvalue = " + couponIds.value);
				
						if(!defined(couponIds)){
							couponIds = new Object();
							couponIds.value = "";
							addEntry(firstOrder, "couponIds", couponIds);
						}

						// d 69284
						<% if ( com.ibm.commerce.tools.common.ToolsConfiguration.isComponentEnabled("Coupon") ) { %>
							document.writeln("<TR>");
							document.writeln("<TD></TD><TD></TD>");
					    		document.writeln("  <td colspan=2 align=right nowrap><label for='couponIds'><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("AdjustmentPageCoupon")) %></label></td>");
	        					document.writeln("  <td align=right>");
							document.writeln("  <input type='text' name='couponIds' id='couponIds' size=17 maxlength=15 align='right' ONFOCUS='parent.setDirtyBit(true);' ONCHANGE='enableUNDO();' value='" + couponIds.value + "'>");
							document.writeln("  </td>");
							document.writeln("</TR>");
							document.writeln("</TABLE>");
						<% } else { %>
							document.writeln("<TR>");
							document.writeln("<TD></TD><TD></TD>");
					    		document.writeln("  <td colspan=2 align=right nowrap>&nbsp;</td>");
	        					document.writeln("  <td align=right>");
							document.writeln("  <input type='hidden' name='couponIds' size=17 maxlength=15 align='right' ONFOCUS='parent.setDirtyBit(true);' ONCHANGE='enableUNDO();' value='" + couponIds.value + "'>");
							document.writeln("  </td>");
							document.writeln("</TR>");
							document.writeln("</TABLE>");
						<% } %>
				//[[>-->
			    </script>
			  </td>
			</tr>
		</table>
		<br />
		<br />
		<table border="0" cellspacing="2" cellpadding="0" width="99%">
			<tr>
				<td width="98%"></td>
			
				<td align="right">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
	        
	        					<td align="right">
	          					<button type="button" name="restoreValueBtn" id="contentButton" onclick="restoreOverrideValues(true, '<%= orderBean.getCurrency() %>')" ><%= UIUtil.toHTML(orderMgmtNLS.get("restoreValueButton").toString()) %></button>
	          					</td>
	          				</tr>
	   	    			</table></td>
			
			
				<td align="right">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
	        					<td align="right">
	          					<button type="button" name="recalculateBtn" id="contentButton" onclick="recalculate()" ><%= UIUtil.toHTML(orderMgmtNLS.get("recalculateButton").toString()) %></button>
	          					</td>
	          				</tr>
	          			</table></td>
			
	          		
	       
	   		</tr>  	
	        
		</table>
	<% } %>

            
 	<!-- Add second order information -->
 	<% if (secondOrderExist && 
 		(null != displayAdjustmentFor && displayAdjustmentFor.equals(SECOND_ORDER))) { %>


	      	<table>
			<tr>
				<td align="left"><%= UIUtil.toHTML( (String) orderMgmtNLS.get("estimatedShipDate")) %><%= UIUtil.toHTML( (String) orderMgmtNLS.get("labelTextSeparator")) %></td>
				<td><i><%= getEstimatedShipDate(orderBean2, jLocale) %></i></td>
			</tr>
		</table>

      		
      		<table class="list" width="99%" cellpadding="2" cellspacing="1" summary='<%= UIUtil.toHTML( (String) orderMgmtNLS.get("orderInfo")) %>'>
		<tr class="list_roles" align="center"> 
			<th class="list_header" id="iNa"><%= UIUtil.toHTML(orderMgmtNLS.get("itemName").toString()) %></td>
			<th class="list_header" id="iNu"><%= UIUtil.toHTML(orderMgmtNLS.get("itemNumber").toString()) %></td>
			<th class="list_header" id="iQu"><%= UIUtil.toHTML(orderMgmtNLS.get("itemQuantity").toString()) %></td>
			<th class="list_header" id="iCt"><%= UIUtil.toHTML(orderMgmtNLS.get("AdjustmentPageContractName").toString()) %></td>			
			<th class="list_header" id="iPr"><%= UIUtil.toHTML(orderMgmtNLS.get("itemPrice").toString()) %></td>
			<th class="list_header" id="iDs"><%= UIUtil.toHTML(orderMgmtNLS.get("orderItemLevelDiscount").toString()) %></td>
			<th class="list_header" id="iTo"><%= UIUtil.toHTML(orderMgmtNLS.get("itemTotal").toString()) %></td>
		</tr>
	

		<%
			String classId="list_row2";
			for (int i=0; asecondOrderItems != null && i<asecondOrderItems.length && asecondOrderItems[i].getCatalogEntryId().length()!=0; i++) {
		%>
			<tr class="<%=classId%>">
				<td class="list_info1" align="left">
					<%= UIUtil.toHTML(getOrderItemName(asecondOrderItems[i].getCatalogEntryId(), request)) %>
				</td>
				<td class="list_info1" align="left">
					<%= UIUtil.toHTML(asecondOrderItems[i].getPartNumber()) %>
				</td>
				<td class="list_info1" align="left">
					<%= UIUtil.toHTML(getFormattedQuantity(asecondOrderItems[i].getQuantityInEntityType().doubleValue(), jLocale)) %>
				</td>
				<td class="list_info1" align="left">
					<%= UIUtil.toHTML(getContractName(asecondOrderItems[i].getContractId(), request)) %>
				</td>
				
				<td class="list_info1" align="right">
					<script>document.writeln(parent.parent.numberToCurrency("<%=asecondOrderItems[i].getPrice()%>", "<%= orderBean.getCurrency() %>", langId))</script>
				</td>
				<td class="list_info1" align="right">
					<script>document.writeln(parent.parent.numberToCurrency("<%=getOrderItemLevelDiscountForDisplay(asecondOrderItems[i])%>", "<%= orderBean.getCurrency() %>", langId))</script>
				</td>	
				<td class="list_info1" align="right">
					<script>document.writeln(parent.parent.numberToCurrency("<%=getOrderItemSubTotal(asecondOrderItems[i])%>", "<%= orderBean.getCurrency() %>", langId))</script>
				</td>	
			</tr>
		<%
				if (classId.equals("list_row2")) classId="list_row1";
				else classId="list_row2";
			}
		%>
		</table>
	
		<br />
	
		<table width="99%" >
			<tr>
				<td colspan="6" align="right">    
        	      	<script type="text/javascript">
					<!-- <![CDATA[
						document.writeln("<table cellpadding='0' cellspacing='0' border='0'>");
						var order = parent.parent.get("order");
        	   			var secondOrder = order["secondOrder"];
						if (defined(secondOrder)) { 
							displayTotals(secondOrder, "second", secondOrderTotals, "<%= orderBean.getCurrency() %>");
						}
						document.writeln("<TR><TD><BR></TD></TR>");
						var couponIds = secondOrder["couponIds"];
						//alert("from from display: couponvalue = " + couponIds.value);
						if(!defined(couponIds)){
							couponIds = new Object();
							couponIds.value = "";
							addEntry(secondOrder, "couponIds", couponIds);
						}
						
						// d 69284
						<% if ( com.ibm.commerce.tools.common.ToolsConfiguration.isComponentEnabled("Coupon") ) { %>
							document.writeln("<TR>");
							document.writeln("<TD></TD><TD></TD>");
							document.writeln("  <td colspan=2 align=right nowrap><label for='couponIdssecond'><%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("AdjustmentPageCoupon")) %></label></td>");
							document.writeln("  <td align=right>");
							document.writeln("  <input type='text' name='couponIdssecond' id='couponIdssecond' size=17 maxlength=15 align='right' ONFOCUS='parent.setDirtyBit(true);' ONCHANGE='' value='" + couponIds.value + "'>");
							document.writeln("  </td>");
							document.writeln("</TR>");
							document.writeln("</TABLE>");
						<% } else { %>
							document.writeln("<TR>");
							document.writeln("<TD></TD><TD></TD>");
							document.writeln("  <td colspan=2 align=right nowrap>&nbsp;</td>");
							document.writeln("  <td align=right>");
							document.writeln("  <input type='hidden' name='couponIdssecond' size=17 maxlength=15 align='right' ONFOCUS='parent.setDirtyBit(true);' ONCHANGE='' value='" + couponIds.value + "'>");
							document.writeln("  </td>");
							document.writeln("</TR>");
							document.writeln("</TABLE>");
						<% } %>
					//[[>-->
					</script>        	        	
				</td>
			</tr>
		</table>
   
	
		<br />
		<br />
		<table border="0" cellspacing="2" cellpadding="0" width="99%">
			<tr>
				<td width="98%"></td>
			
				<td align="right"><table cellpadding="0" cellspacing="0" border="0">
				<tr>
		        
		        		<td align="right">
		          		<button type="button" name="restoreValueBtn" id="contentButton" onclick="restoreOverrideValues(false, '<%= orderBean.getCurrency() %>')" ><%= UIUtil.toHTML(orderMgmtNLS.get("restoreValueButton").toString()) %></button>
		          		</td>
		          	</tr>
		          	</table></td>
			
				
				<td align="right"><table cellpadding="0" cellspacing="0" border="0">
				<tr>
		        		<td align="right">
		          		<button type="button" name="recalculateBtn" id="contentButton" onclick="recalculate()" ><%= UIUtil.toHTML(orderMgmtNLS.get("recalculateButton").toString()) %></button>
		          		</td>
		          	</tr>
		          	</table></td>
			
	          		
		       
		        </tr>  	
	        
		</table>
	<% } %>



		
    </form>

<form name="callActionForm" action="" method="post">
<input type="hidden" name="XML" value="" />
<input type="hidden" name="URL" value="" />
</form>
  </body>
</html>



