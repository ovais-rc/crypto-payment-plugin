<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2011
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
<%@ page import="com.ibm.commerce.order.utils.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@include file="../common/common.jsp" %>
<%@include file="orderUtils.jsp" %>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Integer storeId		= cmdContextLocale.getStoreId();
Integer langId		= cmdContextLocale.getLanguageId();
Hashtable orderAddProducts 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderAddProducts", jLocale);
JSPHelper jspHelper 	= new JSPHelper(request);
String customerId	= jspHelper.getParameter("customerId");

/**
 * New: Support for "customer shopping under different organizations".
 * Capture the organization id that the customer is shopping under.
 **/
String tempOrgId 	= jspHelper.getParameter("activeOrganizationId");
Long activeOrganizationId = null;
if (tempOrgId != null && !tempOrgId.equals("")) {
	activeOrganizationId = new Long(tempOrgId);
}

Long[] tradingIds = getCustomerTradingIds(customerId, storeId, request, activeOrganizationId);
int totalSize = 10;
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
    <title><%= UIUtil.toHTML((String)orderAddProducts.get("quickAddTitle")) %></title>

      <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
      <script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>

      <script type="text/javascript">
	  <!-- <![CDATA[
	function initializeState() {
		if ("<%= UIUtil.toJavaScript(exMsg) %>" != "")
			alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");
		
		parent.setContentFrameLoaded(true);
		//Support For Customers,Shopping Under Multiple Accounts. 
		var selectedOrgId = top.get("selectedOrg");
		parent.put("activeOrganizationId", selectedOrgId);
		defineXMLObject();
	}

	function getCustomerId() {
		var rc = "<%=customerId%>";
   		if (rc == "null") rc = "";
			return rc;
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
		if (quantity == '0')
			return false;

		if (quantity < '0') 
			return false;

		number = parent.strToNumber(quantity, <%=langId%>);
	
		if (number == null)
			return false;
	
		if (number.toString() == "NaN")
			return false;
	
		return true;
	}
	
	function validateSKUAndQuantity()
	{
		var allEmpty 	= true;
		var anyProblem 	= false;
		var quantity	= "<%= OrderConstants.EC_QUANTITY %>";
		var partNumber 	= "<%= OrderConstants.EC_PART_NUMBER %>";
		var totalSize	= <%= totalSize %>;
		
		for (i=0; i<totalSize; i++)
		{
			if ( (document.quickAdd[partNumber + "_" + (i+1)].value == "") && 
			     (document.quickAdd[quantity + "_" + (i+1)].value   == "") )
			{
				continue;
			}
			else if ( (document.quickAdd[partNumber + "_" + (i+1)].value == "") && 
			          (document.quickAdd[quantity + "_" + (i+1)].value   != "") )
			{
				anyProblem = true;
				alertDialog("<%= UIUtil.toJavaScript((String)orderAddProducts.get("quickAddNoSKUEntered")) %>");
				document.quickAdd[partNumber + "_" + (i+1)].focus();
				break;
			}
			else if ( (document.quickAdd[partNumber + "_" + (i+1)].value != "") && 
			          (document.quickAdd[quantity + "_" + (i+1)].value   == "") )
			{
				anyProblem = true;
				alertDialog("<%= UIUtil.toJavaScript((String)orderAddProducts.get("quickAddNoQuantityEntered")) %>".replace(/%1/, document.quickAdd[partNumber + "_" + (i+1)].value));
				document.quickAdd[quantity + "_" + (i+1)].focus();
				break;
			}
			else
			{
				allEmpty = false;
				if ( !isValidQuantity(document.quickAdd[quantity + "_" + (i+1)].value) )
				{
					anyProblem = true;
					alertDialog("<%= UIUtil.toJavaScript((String)orderAddProducts.get("quickAddInvalidQuantity")) %>".replace(/%1/, document.quickAdd[partNumber + "_" + (i+1)].value));
					document.quickAdd[quantity + "_" + (i+1)].focus();
					break;
				}
			}
		}
		
		if (anyProblem)
		{
			return false;
		}
		else if (allEmpty)
		{
			alertDialog("<%= UIUtil.toJavaScript((String)orderAddProducts.get("quickAddAllFieldsEmpty")) %>");
			document.quickAdd[partNumber + "_1"].focus();
			return false;
		}
		else
		{
			return true;
		}
	}
	

	function quickAdd()
	{
		var order = parent.get("order");
		
		if (!validateSKUAndQuantity())
		{
			return;
		}
		// create the item to add into the XML
		var quantity	= "<%= OrderConstants.EC_QUANTITY %>";
		var partNumber 	= "<%= OrderConstants.EC_PART_NUMBER %>";
		var totalSize	= <%= totalSize %>;
		var newItems = new Vector();
		<% if (activeOrganizationId != null) { %>
			parent.put("activeOrganizationId", "<%= activeOrganizationId.toString() %>");
		<% } %>
		
		for (var i=0; i<totalSize; i++) {
			if ( (document.quickAdd[partNumber + "_" + (i+1)].value == "") && 
			     (document.quickAdd[quantity + "_" + (i+1)].value   == "") )
			{
				continue;
			}
		else
		{
				var anItem = new Object();
				anItem.partNumber 	= document.quickAdd[partNumber + "_" + (i+1)].value;	
				anItem.quantity 	= document.quickAdd[quantity + "_" + (i+1)].value;
				anItem.tradingId 	= document.quickAdd["<%= OrderConstants.EC_CONTRACT_ID %>_"+(i+1)].options[document.quickAdd["<%= OrderConstants.EC_CONTRACT_ID %>_"+(i+1)].selectedIndex].value;
				
				addElement(anItem, newItems);
			}
		}
		parent.put("orderItem", newItems);
		<% if (activeOrganizationId != null) { %>
			parent.put("activeOrganizationId", "<%= activeOrganizationId.toString() %>");
		<% } %>
	
		document.addProduct.XML.value = parent.modelToXML("XML");
		document.addProduct.URL.value = "OrderQuickAddRedirect";
	
		parent.setContentFrameLoaded(false);
		document.addProduct.submit();
	}
	 function getFromTop(){
		var orgName = top.get("selectedOrgName");
		
		return orgName; 
		
	}
  //[[>-->
  </script>

  </head>


  <body class="content" onload="initializeState();">
  <h1><%= UIUtil.toHTML((String)orderAddProducts.get("quickAddTitle")) %></h1>
  <p><%=orderAddProducts.get("quickAddDescriptionB2B")%>    
  <br /> <br/>
<!--Support For Customers,Shopping Under Multiple Accounts. -->
  <table border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td valign="bottom" align="left">
            <%= UIUtil.toHTML((String)orderAddProducts.get("activeOrganization")) %>
          </td>
          <td>
          &nbsp;&nbsp;
          </td>
          <td valign="bottom" align="left">
            <i><script>document.write(getFromTop()); </script></i>
          </td>
        </tr>
        
   </table>
   <br />   
<%--
  - Create a form to call the CSR command.
  --%>
<form name="addProduct" method="post" action="CSROrderItemAdd">
	<input type='hidden' name="XML" value=""> 
    <input type='hidden' name="URL" value="">
    <input type="hidden" name="<%= ECConstants.EC_ERROR_VIEWNAME %>" value="OrderQuickAddB2B" />
	  <input type="hidden" name="<%= OrderConstants.EC_ALLOCATE %>" value="**" />
	  <input type="hidden" name="<%= OrderConstants.EC_BACKORDER %>" value="**" />
	  <input type="hidden" name="<%= OrderConstants.EC_REVERSE %>" value="*n" />
	  <input type="hidden" name="<%= OrderConstants.EC_CHECK %>" value="**" />
	  <input type="hidden" name="<%= OrderConstants.EC_MERGE %>" value="*n" />
	  <input type="hidden" name="<%= OrderConstants.EC_REMERGE %>" value="*n" />

	</form>
    </p><form name="quickAdd"
          method="post"
          action="OrderItemAdd">
   


	<table class="list" border="0" cellpadding="0" cellspacing="0" width="300">
	<tr class="list_roles">	
	<th class="list_header" width="10%">
	</th>
	<th class="list_header" width="35%">
		<%= UIUtil.toHTML((String)orderAddProducts.get("quickAddSKU")) %>
	</th>
	<th class="list_header" width="30%">
		<%= UIUtil.toHTML((String)orderAddProducts.get("quickAddQuantity")) %>
	</th>
	<th class="list_header" width="25%">
		<%= UIUtil.toHTML((String)orderAddProducts.get("quickAddContract")) %>
	</th>
	</tr>

	<%
	int rowselect = 1;
	String classStr = "list_row1";
	StringBuffer aStrBuffer = null;
	
	for (int i=0; i<totalSize; i++)
	{
	%>
		<tr class="<%= classStr %>">
		<td>
			<%= i+1 %>
		</td>
		<td>
			<%
			aStrBuffer = new StringBuffer();
			aStrBuffer.append(OrderConstants.EC_PART_NUMBER);
			aStrBuffer.append("_");
			aStrBuffer.append(i+1);
			String partNumber = jspHelper.getParameter(aStrBuffer.toString());
			if (partNumber == null) {
				partNumber = "";
			}
			%>
			<label for='partnum<%= i+1 %>'><input type='text' maxlength='64' name='<%= OrderConstants.EC_PART_NUMBER %>_<%= i+1 %>' id='partnum<%= i+1 %>' value='<%= partNumber %>' size='20' align='right' /></label>
		</td>
		<td>
			<%
			aStrBuffer = new StringBuffer();
			aStrBuffer.append(OrderConstants.EC_QUANTITY);
			aStrBuffer.append("_");
			aStrBuffer.append(i+1);
			String quantity = jspHelper.getParameter(aStrBuffer.toString());
			if (quantity == null) {
				quantity = "";
			}
			%>
			<label for='quantity<%= i+1 %>'><input type='text' maxlength='10' name='<%= OrderConstants.EC_QUANTITY %>_<%= i+1 %>' id='quantity<%= i+1 %>' value='<%= quantity %>' size='8' align='right' /></label>
		</td>
		<td>
		       <label for="contract<%= i+1 %>">
			<select id="contract<%= i+1 %>" name="<%= OrderConstants.EC_CONTRACT_ID %>_<%= i+1 %>">
				<option  value=""></option>
				<%
				aStrBuffer = new StringBuffer();
				aStrBuffer.append(OrderConstants.EC_CONTRACT_ID);
				aStrBuffer.append("_");
				aStrBuffer.append(i+1);
				String selectedTradingId = jspHelper.getParameter(aStrBuffer.toString());
				
				String selectedOption = "";
	if (tradingIds !=null)	{
				for (int j=0; j<tradingIds.length; j++) {
					if (selectedTradingId != null && selectedTradingId.equals(tradingIds[j].toString())) {
						selectedOption = "selected";
					}
				%>
					<option  value="<%= tradingIds[j].toString() %>" <%= selectedOption %>> <%= getContractName(tradingIds[j].toString(), request) %></option>
				<%
					selectedOption = "";
				}
				}
				%>
			</select>
			</label>
		</td>
		</tr>
	
		<% 
		if (rowselect == 1) {
			rowselect = 2;
			classStr = "list_row2";
		} else {
			rowselect = 1;
			classStr = "list_row1";
		}
	}
	%>
	</table>
    </form>
  </body>
  </html>
