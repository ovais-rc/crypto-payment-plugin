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
<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale 		= cmdContextLocale.getLocale();
Integer langId		= cmdContextLocale.getLanguageId();
Integer storeId 	= cmdContextLocale.getStoreId();
Hashtable orderAddProducts 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderAddProducts", jLocale);
JSPHelper jspHelper 	= new JSPHelper(request);
String customerId	= jspHelper.getParameter("customerId");

String catentryId	= jspHelper.getParameter("originalCatentryId");
if (catentryId == null) {
	catentryId = jspHelper.getParameter(OrderConstants.EC_CATENTRY_ID);
}

String currency		= jspHelper.getParameter(OrderConstants.EC_CURRENCY);
String aQuantity;


// Get package information
BundleDataBean bundleDB = new BundleDataBean();
bundleDB.setBundleID(catentryId);
com.ibm.commerce.beans.DataBeanManager.activate(bundleDB, request);

CatalogEntryDescriptionAccessBean catDescAB = bundleDB.getDescription();
CompositeItemDataBean[] compositeItems = bundleDB.getBundledItems();
CompositeProductDataBean[] compositeProducts = bundleDB.getBundledProducts();
CompositePackageDataBean[] compositePackages = bundleDB.getBundledPackages();
ItemDataBean anItemDB;
ProductDataBean aProductDB;
PackageDataBean aPackageDB;
%>

<%--
//---------------------------------------------------------------------
//- Forward Error JSP 
//---------------------------------------------------------------------
--%>
<%
String exMsg = "";
StringBuffer catEntrySKUs=null;
ErrorDataBean errorBean = new ErrorDataBean(); 
try {
	DataBeanManager.activate (errorBean, request);

	String exKey = errorBean.getMessageKey();

	//If the message type in the ErrorDataBean is type SYSTEM then 
	//display the system message.  Otherwise the message is type USER
	//so display the user message.
	if ( errorBean.getECMessage().getType() == ECMessageType.SYSTEM ) {
		exMsg = errorBean.getSystemMessage();
	} else {
		exMsg = errorBean.getMessage();
	}
	
	if (exKey.equals("_ERR_GENERIC")) {
		String[] paramObj = (String[])errorBean.getMessageParam();
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
    <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 
    <title><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageBundleDetails")) %></title>

    <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>

    <script type="text/javascript">
	<!-- <![CDATA[
	function initializeState() {
		if ("<%= UIUtil.toJavaScript(exMsg) %>" != "")
			alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");
		
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
	//[[>-->	
    </script>

  </head>
  
  
  <body class="content" onload="initializeState();">
  <h1><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageBundleDetails")) %></h1>
  <p><%= (String)orderAddProducts.get("addProductPageBundleDetailsDescription") %>    

    </p><form name="addForm"
          method="post"
          action="OrderItemAdd">

	<input type="hidden" name="<%= ECConstants.EC_STORE_ID %>" value="<%= storeId.toString() %>" />
	<input type="hidden" name="<%= ECConstants.EC_LANGUAGE_ID %>" value="<%= langId.toString() %>" />
	<input type="hidden" name="<%= ECConstants.EC_FOR_USER_ID %>" value="<%= customerId %>" />
	<input type="hidden" name="<%= ECConstants.EC_CLEAR_FOR_USER %>" value="true" />
	<input type="hidden" name="<%= ECConstants.EC_ERROR_VIEWNAME %>" value="OrderAddProductBundleDetailsB2C" />
	<input type="hidden" name="<%= ECConstants.EC_URL %>" value="OrderAddProductRedirect" />
	<input type="hidden" name="customerId" value="<%= customerId %>" />
	<input type="hidden" name="originalCatentryId" value="<%= catentryId %>" />
	<input type="hidden" name="<%= OrderConstants.EC_ALLOCATE %>" value="**" />
	<input type="hidden" name="<%= OrderConstants.EC_BACKORDER %>" value="**" />
	<input type="hidden" name="<%= OrderConstants.EC_REVERSE %>" value="*n" />
	<input type="hidden" name="<%= OrderConstants.EC_CHECK %>" value="**" />
	<input type="hidden" name="<%= OrderConstants.EC_MERGE %>" value="*n" />
	<input type="hidden" name="<%= OrderConstants.EC_REMERGE %>" value="*n" />
	<input type="hidden" name="<%= OrderConstants.EC_ORDER_RN %>" value="**" />
	<input type="hidden" name="<%=OrderConstants.EC_CURRENCY%>" value="<%=currency%>" />
	<input type="hidden" name="<%=OrderConstants.EC_CALCULATE_ORDER%>" value="1" />
      	
      	<p>
	</p><table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td valign="bottom" align="left">
            <%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageBundleDetailsPackageName")) %>
          </td>
          <td>
          &nbsp;&nbsp;
          </td>
          <td valign="bottom" align="left">
            <i><%= UIUtil.toHTML(catDescAB.getName()) %></i>
          </td>
        </tr>
        <tr>
          <td valign="bottom" align="left">
            &nbsp;<br /><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageDetailsProductSKU")) %>
          </td>
          <td>
          &nbsp;&nbsp;
          </td>
          <td valign="bottom" align="left">
            <i><%= UIUtil.toHTML(bundleDB.getBundlePartNumber()) %></i>
          </td>
        </tr>
        <tr>
          <td valign="bottom" align="left">
            &nbsp;<br /><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageDetailsProductDesc")) %>
          </td>
          <td>
          &nbsp;&nbsp;
          </td>
          <td valign="bottom" align="left">
            <i><%= UIUtil.toHTML(catDescAB.getShortDescription()) %></i>
          </td>
        </tr>
        <tr>
          <td valign="bottom" align="left">
            &nbsp;<br /><%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageBundleDetailsContents")) %>
          </td>
        </tr>
        </table>
        
        
	<table class="list" border="0" cellpadding="1" cellspacing="1" width="100%">
	<tr class="list_roles">
	<th bgcolor="#1B436F" width="20%">
   		<table class="list_roles">
		<tr>
		<td class="list_header">
		<%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageBundleDetailsName")) %>
		</td>
		</tr>
		</table>
	</th>
	<th bgcolor="#1B436F" width="15%">
   		<table class="list_roles">
		<tr>
		<td class="list_header">
		<%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageBundleDetailsSKU")) %>
		</td>
		</tr>
		</table>
	</th>
	<th bgcolor="#1B436F" width="15%">
   		<table class="list_roles">
		<tr>
		<td class="list_header">
		<%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageBundleDetailsQuantity")) %>
		</td>
		</tr>
		</table>
	</th>
	<th bgcolor="#1B436F" width="25%">
   		<table class="list_roles">
		<tr>
		<td class="list_header" >
		<%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageBundleDetailsAttributes")) %>
		</td>
		</tr>
		</table>
	</th>
	<th bgcolor="#1B436F" width="25%">
   		<table class="list_roles">
		<tr>
		<td class="list_header">
		<%= UIUtil.toHTML((String)orderAddProducts.get("addProductPageBundleDetailsPrice")) %>
		</td>
		</tr>
		</table>
	</th>
	</tr>
	
	
        <%
	int rowselect = 1;
	String bgcolor = "#FFFFFF";
	int catEntry_counter = 1;
	StringBuffer aStrBuffer = null;
	
        // display items inside the bundle
        for (int i=0; i<compositeItems.length; i++) {
        	anItemDB = compositeItems[i].getItem();
        	catDescAB = anItemDB.getDescription();
        	%>
		<tr>
		<th bgcolor="<%= bgcolor %>" width="20%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%= catDescAB.getName() %>
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="15%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%= anItemDB.getPartNumber() %>
			<input type="hidden" name="<%= OrderConstants.EC_CATENTRY_ID %>_<%= catEntry_counter %>" value="<%= anItemDB.getItemID() %>" />
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="15%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%
			aStrBuffer = new StringBuffer();
			aStrBuffer.append(OrderConstants.EC_QUANTITY);
			aStrBuffer.append("_");
			aStrBuffer.append(catEntry_counter);
			aQuantity = jspHelper.getParameter(OrderConstants.EC_QUANTITY + "_" + catEntry_counter);
			if (aQuantity == null || aQuantity.equals("")) {
				aQuantity = compositeItems[i].getQuantity();
			}
			%>
			<label for="itemQuantity<%= i %>"><input id="itemQuantity<%= i %>" type="text" name="<%= OrderConstants.EC_QUANTITY %>_<%= catEntry_counter %>" size="10" maxlength="10" value="<%= aQuantity %>" /></label>
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="25%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%
			AttributeValueDataBean[] attrValueDBs = anItemDB.getAttributeValueDataBeans(langId);
        		for (int j=0; j<attrValueDBs.length; j++) { %>
				<%= (attrValueDBs[j].getAttributeDataBean()).getName() %>: <%= attrValueDBs[j].getValue() %><br />
			<% 
			}
			%>
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="25%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%= getContractPriceB2C(anItemDB.getItemID(), currency, customerId, storeId, getCustomerTradingIds(customerId, storeId), langId, catEntry_counter, cmdContextLocale) %>
			</td>
			</tr>
			</table>
		</th>
        	<%
		if (rowselect == 1) {
			rowselect = 2;
			bgcolor = "#EBF0EE";
		} else {
			rowselect = 1;
			bgcolor = "#FFFFFF";
		}
		
		catEntry_counter++;
        }
        
        
        // display products inside the bundle
        for (int i=0; i<compositeProducts.length; i++) {
        	aProductDB = compositeProducts[i].getProduct();
        	catDescAB = aProductDB.getDescription();
                %>
		</tr><tr>
		<th bgcolor="<%= bgcolor %>" width="20%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%= catDescAB.getName() %>
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="15%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%= aProductDB.getPartNumber() %>
			<input type="hidden" name="<%= OrderConstants.EC_CATENTRY_ID %>_<%= catEntry_counter %>" value="<%= aProductDB.getProductID() %>" />
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="15%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%
			aStrBuffer = new StringBuffer();
			aStrBuffer.append(OrderConstants.EC_QUANTITY);
			aStrBuffer.append("_");
			aStrBuffer.append(catEntry_counter);
			aQuantity = jspHelper.getParameter(OrderConstants.EC_QUANTITY + "_" + catEntry_counter);
			if (aQuantity == null || aQuantity.equals("")) {
				aQuantity = compositeProducts[i].getQuantity();
			}
			%>
			<label for="packageQuantity<%= i %>"><input id="packageQuantity<%= i %>" type="text" name="<%= OrderConstants.EC_QUANTITY %>_<%= catEntry_counter %>" size="10" maxlength="10" value="<%= aQuantity %>" /></label>
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="25%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">        	
			<%
			AttributeAccessBean[] attributeABs = aProductDB.getAttributes();
			for (int j=0; j<attributeABs.length; j++) { %>
				<input type="hidden" name="<%= OrderConstants.EC_ATTR_NAME %>_<%= catEntry_counter %>" value="<%= attributeABs[j].getAttributeReferenceNumber() %>" />
				<%
				if (j!=0) {
					%>
					<br />
				<%
				}
				%>
				<label for="attrVal_<%= i %>_<%= j %>"><%= attributeABs[j].getName() %></label>:&nbsp;
				<select id="attrVal_<%= i %>_<%= j %>" name="<%= OrderConstants.EC_ATTR_VALUE %>_<%= catEntry_counter %>">
				<%
				Object[] attributeValues = attributeABs[j].getDistinctAttributeValues();
             			for (int k=0; k<attributeValues.length; k++) { %>
					<option  value="<%= attributeValues[k] %>" ><%= attributeValues[k] %></option>
						<%
						}
						%>
				</select>
			<%
			}
			%>
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="25%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%= getContractPriceB2C(aProductDB.getProductID(), currency, customerId, storeId, getCustomerTradingIds(customerId, storeId), langId, catEntry_counter, cmdContextLocale) %>
			</td>
			</tr>
			</table>
		</th>
        	<%
		if (rowselect == 1) {
			rowselect = 2;
			bgcolor = "#EBF0EE";
		} else {
			rowselect = 1;
			bgcolor = "#FFFFFF";
		}
		catEntry_counter++;
        }
        
        
        // display packages inside the bundle
        for (int i=0; i<compositePackages.length; i++) {
        	aPackageDB = compositePackages[i].getPackage();
        	catDescAB = aPackageDB.getDescription();
		%>
		</tr><tr>
		<th bgcolor="<%= bgcolor %>" width="20%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%= catDescAB.getName() %>
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="15%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%= aPackageDB.getPartNumber() %>
			<input type="hidden" name="<%= OrderConstants.EC_CATENTRY_ID %>_<%= catEntry_counter %>" value="<%= aPackageDB.getPackageID() %>" />
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="15%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%
			aStrBuffer = new StringBuffer();
			aStrBuffer.append(OrderConstants.EC_QUANTITY);
			aStrBuffer.append("_");
			aStrBuffer.append(catEntry_counter);
			aQuantity = jspHelper.getParameter(OrderConstants.EC_QUANTITY + "_" + catEntry_counter);
			if (aQuantity == null || aQuantity.equals("")) {
				aQuantity = compositePackages[i].getQuantity();
			}
			%>
			<label for="bundleQuantity<%= i %>"><input id="bundleQuantity<%= i %>" type="text" name="<%= OrderConstants.EC_QUANTITY %>_<%= catEntry_counter %>" size="10" maxlength="10" value="<%= aQuantity %>" /></label>
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="25%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			&nbsp;
			</td>
			</tr>
			</table>
		</th>
		<th bgcolor="<%= bgcolor %>" width="25%">
   			<table class="list_role_off">
			<tr>
			<td class="list_row">
			<%= getContractPriceB2C(aPackageDB.getPackageID(), currency, customerId, storeId, getCustomerTradingIds(customerId, storeId), langId, catEntry_counter, cmdContextLocale) %>
			</td>
			</tr>
			</table>
		</th>
        	<%
		if (rowselect == 1) {
			rowselect = 2;
			bgcolor = "#EBF0EE";
		} else {
			rowselect = 1;
			bgcolor = "#FFFFFF";
		}
		
		catEntry_counter++;
        }
        %>
	</tr></table>
	
	<script type="text/javascript">
	<!-- <![CDATA[
	/******************************
	* returns true if the input is a valid quantity, false otherwise
	*******************************/
	function isValidQuantity(quantity)
	{
		if (quantity == '0')
			return false;

		if (quantity < '0') 
			return false;

		number = parent.strToNumber(quantity, <%=langId%>);
	
		if (number == null) {
			return false;
		}
	
		if (number.toString() == "NaN") {
			return false;
		}
	
		return true;
	}


	/******************************
	* returns true if all quantity fields are valid, false otherwise
	* (skips all 0 quantities and empty quantities)
	*******************************/
	function validateQuantity() {
		for (i=0; i<<%= catEntry_counter-1 %>; i++) {
			if (document.addForm["<%= OrderConstants.EC_QUANTITY %>_"+(i+1)].value == "")
				continue;
			else if (!isValidQuantity(document.addForm["<%= OrderConstants.EC_QUANTITY %>_"+(i+1)].value)) {
				alertDialog("<%= UIUtil.toJavaScript((String)orderAddProducts.get("addProductPageDetailsQuantityError")) %>");
				return false;
			}
			else
				continue;
		}
		
		return true;
	}
	

	/******************************
	* Clears the catentry and quantity fields if quantity is empty.
	* This will make sure the OrderItemAdd command omits these catentries.
	*******************************/
	function removeProductsFromForm() {
		for (i=0; i<<%= catEntry_counter-1 %>; i++) {
			if ( document.addForm["<%= OrderConstants.EC_QUANTITY %>_"+(i+1)].value == "" ) {
				document.addForm["<%= OrderConstants.EC_QUANTITY %>_"+(i+1)].value = "";
				document.addForm["<%= OrderConstants.EC_CATENTRY_ID %>_"+(i+1)].value = "";
			}
		}		
	}


	function addBundle()
	{
		var order = parent.get("order");
		
		// do validation of SKUa and quantity
		if (!validateQuantity())
			return false;
		
		removeProductsFromForm();
		
		if (defined(order.orderId) && (order.orderId != null) && (order.orderId!="") )
			document.addForm["<%= OrderConstants.EC_ORDER_RN %>"].value = order.orderId;
		
		parent.setContentFrameLoaded(false);
		document.addForm.submit();
	}

	function closeDialog()
	{
  		top.goBack();
	}
	//[[>-->
	</script>
    </form>
  </body>
  </html>
