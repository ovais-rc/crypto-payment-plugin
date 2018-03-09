<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
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

<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.order.utils.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>
<%@include file="orderUtils.jsp" %>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%CommandContext cmdContextLocale = (CommandContext) request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Integer langId = cmdContextLocale.getLanguageId();
Integer storeId = cmdContextLocale.getStoreId();
Hashtable orderAddProducts = (Hashtable) com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderAddProducts", jLocale);
JSPHelper jspHelper = new JSPHelper(request);
String customerId = jspHelper.getParameter("customerId");
String catentryId	= jspHelper.getParameter("originalCatentryId");
if (catentryId == null) {
	catentryId = jspHelper.getParameter(OrderConstants.EC_CATENTRY_ID);
}
String quantity	= jspHelper.getParameter("originalQuantity");
if (quantity == null) {
	quantity = jspHelper.getParameter(OrderConstants.EC_QUANTITY);
}
//String quantity = jspHelper.getParameter(OrderConstants.EC_QUANTITY);
String currency		= jspHelper.getParameter(OrderConstants.EC_CURRENCY);

if (quantity == null)
{
	quantity = "";
}

// Get item information
ItemDataBean itemDB = new ItemDataBean();
itemDB.setItemID(catentryId);
DataBeanManager.activate(itemDB, request);

CatalogEntryDescriptionAccessBean catDescAB = itemDB.getDescription();
AttributeValueDataBean[] attributeValueDBs = itemDB.getAttributeValueDataBeans(langId);
%>

<%--
//---------------------------------------------------------------------
//- Forward Error JSP
//---------------------------------------------------------------------
--%>
<%String exMsg = "";
StringBuffer catEntrySKUs=null;
ErrorDataBean errorBean = new ErrorDataBean();
String exKey = "";
try
{
	DataBeanManager.activate(errorBean, request);

	exKey = errorBean.getMessageKey();

	//If the message type in the ErrorDataBean is type SYSTEM then
	//display the system message.  Otherwise the message is type USER
	//so display the user message.
	if (errorBean.getECMessage().getType() == ECMessageType.SYSTEM)
	{
		exMsg = errorBean.getSystemMessage();
	}
	else
	{
		exMsg = errorBean.getMessage();
	}

	if (exKey.equals("_ERR_GENERIC"))
	{
		String[] paramObj = (String[]) errorBean.getMessageParam();
		exMsg = paramObj[0];
	}
    if (errorBean.getExceptionData() != null && errorBean.getExceptionData().get(OrderConstants.EC_NO_INVENTORY, null) != null){
    	catEntrySKUs= new StringBuffer();
		Vector vCatEntryIds= (Vector)errorBean.getExceptionData().get(OrderConstants.EC_NO_INVENTORY, null);
		Enumeration en = vCatEntryIds.elements();
		while (en != null && en.hasMoreElements()) {
			String catEntryId = (String) en.nextElement().toString();
			CatalogEntryAccessBean ceab = new CatalogEntryAccessBean();
			ceab.setInitKey_catalogEntryReferenceNumber(catEntryId);
			catEntrySKUs.append(" "+ ceab.getPartNumber() + " ");
			
			}
	}
	if (catEntrySKUs != null){
	exMsg += catEntrySKUs.toString();	
	}	
} catch (Exception ex) {
	exMsg = "";
}
%>

<html>
<head>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>"
	type="text/css" />
<title><%=UIUtil.toHTML((String) orderAddProducts.get("addProductPageItemDetails"))%></title>

<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>

<script type="text/javascript">
	<!-- <![CDATA[
	function initializeState() {
		if ("<%=UIUtil.toJavaScript(exMsg)%>" != "") {
			alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");
			if ("<%=exKey%>" == "_ERR_ORDER_IS_LOCKED" || "<%=exKey%>" == "_ERR_ORDER_IS_NOT_LOCKED") {
				top.goBack();
				top.goBack();
				return;
			}
		}
		parent.setContentFrameLoaded(true);
		defineXMLObject();
	}

	/******************************
	* prepare the xml object
	* pre: 	assume that the wizard xml object is placed in the banner
	* post: an xml object for local use in defined
	*******************************/
	function defineXMLObject() {
		var XMLObject = top.getData("model", 1);

		var order = parent.get("order");
		if ((order == null) || (!defined(order)))
			order = new Object();

		order.billingAddressId 	= XMLObject.order.billingAddressId;
		order.customerId 	= XMLObject.order.customerId;
		if (defined(XMLObject.order.firstOrder) && (XMLObject.order.firstOrder!= null))
			order.orderId 	= XMLObject.order.firstOrder.id;

		parent.put("order", order);
	}

	/******************************
	* returns true if the input is a valid quantity, false otherwise
	*******************************/
	function isValidQuantity(quantity)
	{
		if (quantity == '0') return false;
		if (quantity < '0') return false;
		number = parent.strToNumber(quantity, <%=langId%>);
		if (number == null) {return false;}
		if (number.toString() == "NaN") {return false;}
		return true;
	}

	function validateQuantity() {
		if (document.addForm["<%=OrderConstants.EC_QUANTITY%>"].value == "") {
			alertDialog("<%=UIUtil.toJavaScript((String) orderAddProducts.get("addProductPageDetailsNoQuantityError"))%>");
			return false;
		}
		if (!isValidQuantity(document.addForm["<%=OrderConstants.EC_QUANTITY%>"].value)) {
			alertDialog("<%=UIUtil.toJavaScript((String) orderAddProducts.get("addProductPageDetailsQuantityError"))%>");
			return false;
		}

		return true;
	}


	function addItem()
	{
		var order = parent.get("order");

		// do validation of SKUa and quantity
		if (!validateQuantity())
			return false;

		if (defined(order.orderId) && (order.orderId != null) && (order.orderId!=""))
			document.addForm["<%=OrderConstants.EC_ORDER_RN%>"].value = order.orderId;
		parent.setContentFrameLoaded(false);
		document.addForm["originalQuantity"].value = document.addForm["<%=OrderConstants.EC_QUANTITY%>"].value;
		document.addForm.submit();
	}

	function closeDialog()
	{
  		top.goBack();
	}
	//[[>-->
    </script>
</head>


<body class="content" onload="initializeState();">
<h1><%=UIUtil.toHTML((String) orderAddProducts.get("addProductPageItemDetails"))%></h1>
<p><%=(String) orderAddProducts.get("addProductPageItemDetailsDescription")%></p>
<form name="addForm" method="post" action="OrderItemAdd">
  <input type="hidden" name="<%=ECConstants.EC_STORE_ID%>"
	value="<%=storeId.toString()%>" /> <input type="hidden"
	name="<%=ECConstants.EC_LANGUAGE_ID%>" value="<%=langId.toString()%>" />
  <input type="hidden" name="<%=ECConstants.EC_FOR_USER_ID%>"
	value="<%=customerId%>" /> <input type="hidden"
	name="<%=ECConstants.EC_CLEAR_FOR_USER%>" value="true" />
  <input type="hidden" name="<%=ECConstants.EC_ERROR_VIEWNAME%>"
	value="OrderAddProductItemDetailsB2C" /> <input type="hidden"
	name="<%=ECConstants.EC_URL%>" value="OrderAddProductRedirect" />
  <input type="hidden" name="customerId" value="<%=customerId%>" />
  <input type="hidden" name="originalCatentryId" value="<%= catentryId %>" />
  	<input type="hidden" name="originalQuantity" value="<%= quantity %>" />
  <input type="hidden" name="<%=OrderConstants.EC_CATENTRY_ID%>"
	value="<%=catentryId%>" /> <input type="hidden"
	name="<%=OrderConstants.EC_ALLOCATE%>" value="**" />
  <input type="hidden" name="<%=OrderConstants.EC_BACKORDER%>" value="**" />
  <input type="hidden" name="<%=OrderConstants.EC_REVERSE%>" value="*n" />
  <input type="hidden" name="<%=OrderConstants.EC_CHECK%>" value="**" />
  <input type="hidden" name="<%=OrderConstants.EC_MERGE%>" value="*n" />
  <input type="hidden" name="<%=OrderConstants.EC_REMERGE%>" value="*n" />
  <input type="hidden" name="<%=OrderConstants.EC_ORDER_RN%>" value="**" />
  <input type="hidden" name="<%=OrderConstants.EC_CURRENCY%>" value="<%=currency%>" />
  <input type="hidden" name="<%=OrderConstants.EC_CALCULATE_ORDER%>" value="1" />
  
  <p></p>
  <table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="bottom" align="left"><%=UIUtil.toHTML((String) orderAddProducts.get("addProductPageDetailsProductName"))%>
		</td>
		<td>&nbsp;&nbsp;</td>
		<td valign="bottom" align="left"><i><%=UIUtil.toHTML(catDescAB.getName())%></i>
		</td>
	</tr>
	<tr>
		<td valign="bottom" align="left">&nbsp;<br />
		<%=UIUtil.toHTML((String) orderAddProducts.get("addProductPageDetailsProductSKU"))%>
		</td>
		<td>&nbsp;&nbsp;</td>
		<td valign="bottom" align="left"><i><%=UIUtil.toHTML(itemDB.getPartNumber())%></i>
		</td>
	</tr>
	<tr>
		<td valign="bottom" align="left">&nbsp;<br />
		<%=UIUtil.toHTML((String) orderAddProducts.get("addProductPageDetailsProductDesc"))%>
		</td>
		<td>&nbsp;&nbsp;</td>
		<td valign="bottom" align="left"><i><%=UIUtil.toHTML(catDescAB.getShortDescription())%></i>
		</td>
	</tr>
	<tr>
		<td valign="bottom" align="left">&nbsp;<br />
		<label for="addItemQuantity"><%=UIUtil.toHTML((String) orderAddProducts.get("addProductPageDetailsQuantity"))%></label>
		</td>
		<td>&nbsp;&nbsp;</td>
		<td valign="bottom" align="left"><input type="text"
			name="<%=OrderConstants.EC_QUANTITY%>" size="10" maxlength="10"
			id="addItemQuantity" value="<%=quantity%>" /></td>
	</tr>
	<tr>
		<td valign="middle" align="left">&nbsp;<br />
		<%=UIUtil.toHTML((String) orderAddProducts.get("addProductPageDetailsPrice"))%>
		</td>
		<td>&nbsp;&nbsp;</td>
		<td valign="bottom" align="left"><br />
		<%=getContractPriceB2C(catentryId, currency, customerId, storeId, getCustomerTradingIds(customerId, storeId), langId, 0, cmdContextLocale)%>
		</td>
	</tr>


	<%if ((attributeValueDBs != null) && (attributeValueDBs.length > 0))
{%>
	<tr>
		<td valign="bottom" align="left">&nbsp;<br />
		<%=UIUtil.toHTML((String) orderAddProducts.get("addProductPageDetailsAttributes"))%>
		</td>
	</tr>
	<%for (int i = 0; i < attributeValueDBs.length; i++)
{%>
	<tr>
		<td valign="bottom" align="left"><%=(attributeValueDBs[i].getAttributeDataBean()).getName()%>:
		</td>
		<td>&nbsp;&nbsp;</td>
		<td valign="bottom" align="left"><i><%=attributeValueDBs[i].getValue()%></i>
		</td>
	</tr>
	<%}
}%>
</table>
</form>
</body>
</html>
