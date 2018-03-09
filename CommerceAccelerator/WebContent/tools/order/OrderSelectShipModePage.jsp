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
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.commands.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@include file="../common/common.jsp" %>

<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<% 
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale 		= cmdContext.getLocale();
	String langId		= cmdContext.getLanguageId().toString();
	Integer storeId 	= cmdContext.getStoreId();
	String currency		= cmdContext.getCurrency();
	Hashtable orderMgmtNLS 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
	
	Vector storeShipModes 	= new Vector();
		
	// retrieve request parameters
	JSPHelper jspHelper 	= new JSPHelper(request);
	String orderItemId 	= jspHelper.getParameter("orderItemId");
	String xmlFile 	= jspHelper.getParameter("ActionXMLFile");
	int startIndex 	= Integer.parseInt(jspHelper.getParameter("startindex"));
	int listSize 	= Integer.parseInt(jspHelper.getParameter("listsize"));
	int endIndex	= startIndex + listSize;
	int rowselect 	= 1;


	OrderItemDataBean anOrderItem = new OrderItemDataBean();
	anOrderItem.setOrderItemId(orderItemId);
	DataBeanManager.activate(anOrderItem, request);
	
	ShippingHelper TCShip = new ShippingHelper();
	
	ShippingModeAccessBean[] TCShipMode = TCShip.getAllowableShippingModes(anOrderItem);
	
	int size = TCShipMode.length;
	
	Vector shipModes = new Vector();
	 
	for (int i = 0; i < size; i++) {
		
		Hashtable mode = new Hashtable();
		mode.put("id", "");
		mode.put("carrier", "");
		mode.put("code", "");
		mode.put("desc", "");
		String id = TCShipMode[i].getShippingModeId();
		String carrier = TCShipMode[i].getCarrier();
		String code = TCShipMode[i].getCode();
		
		String desc = "";
		try {
			desc = TCShipMode[i].getDescription(new Integer(langId), new Integer(id)).getDescription();
		} catch (Exception ex) {
			System.out.println("Exception in OrderSelectShipModePage.jsp (Obtain the shipping descriptions) shipModeId="+id);
			ex.printStackTrace();
			desc = "";
			
		}
		
		if (id != null)
			mode.put("id", id);
		if (carrier != null)
			mode.put("carrier", carrier);
		if (code != null)
			mode.put("code", code);
		if (desc != null)
			mode.put("desc", desc);
		shipModes.addElement(mode);
	}
	

	int actualsize = shipModes.size(); 
	int totalsize = actualsize;
	int totalpage = 0;
	if (listSize > 0) {
		totalpage = totalsize / listSize;
	}
%>


<%--
//---------------------------------------------------------------------
//- Forward Error JSP 
//---------------------------------------------------------------------
--%>
<html>
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
<title><%= UIUtil.toHTML((String)orderMgmtNLS.get("shippingModeTitle")) %></title> 

<script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[

//---------------------------------------------------------------------
//  Required javascript function for wizard panel and list
//---------------------------------------------------------------------

var finalId = "";

function onLoad() {
  	parent.loadFrames();
  	parent.parent.setContentFrameLoaded(true);
  	defineXMLObject();
}

function getResultsSize() {
        return <%=totalsize%>;
}

/******************************
* prepare the xml object
* pre: 	assume that the wizard xml object is placed in the banner
* post: an xml object for local use in defined
*******************************/
function defineXMLObject() {
	var XMLObject = top.getData("model", 1);

	var order = parent.parent.get("order");
	if ((order == null) || (!defined(order))) 
		order = new Object();
		
	order.billingAddressId 	= XMLObject.order.billingAddressId;
	order.customerId 	= XMLObject.order.customerId;

	if (defined(XMLObject.order.firstOrder) && (XMLObject.order.firstOrder!= null)) {
		order.firstOrder 	= new Object();
		order.firstOrder.id 	= XMLObject.order.firstOrder.id;
	}
	
	if (defined(XMLObject.order.secondOrder) && (XMLObject.order.secondOrder!= null)) {
		order.secondOrder 	= new Object();
		order.secondOrder.id 	= XMLObject.order.secondOrder.id;
	}

	parent.parent.put("order", order);

	parent.parent.remove("orderItem");
	orderItem = new Vector();
		
	if (defined(XMLObject.orderItem) && (XMLObject.orderItem != null)) {
		for (var i=0; i<size(XMLObject.orderItem); i++) {
			var anItem  = elementAt(i, XMLObject.orderItem);
			var newItem = new Object();
			newItem.orderItemId 	= anItem.orderItemId;
			newItem.quantity	= anItem.quantity;
			newItem.shipModeId	= anItem.shipModeId;
			newItem.shipAddrId	= anItem.shipAddrId;
			newItem.orderId		= anItem.orderId;
			addElement(newItem, orderItem);
		}		
		
		if (size(orderItem) > 0)
			parent.parent.put("orderItem", orderItem);
	}

}



/******************************
* update the ship mode for the selected order items
* pre:	all the selected order items are within the xml object
* post:	the update order item cmd is called to make the changes
*******************************/
function updateShipMode() {
	
	if (finalId == "") {
		alertDialog("<%=UIUtil.toJavaScript((String)orderMgmtNLS.get("ModeMustBeSelectedMsg"))%>");
		return;
	}
	
	var orderItems = parent.parent.get("orderItem");

	items = new Vector();
	
	if (defined(orderItems) && (orderItems != null)) {
		for (var i=0; i<size(orderItems); i++) {
			var anItem = elementAt(i, orderItems);
			anItem.shipModeId = finalId;
			addElement(anItem, items);
		}
		
		parent.parent.put("orderItem", items);
		
	  	parent.parent.setContentFrameLoaded(false);
		document.changeShipMode.XML.value = parent.parent.modelToXML("XML");
		document.changeShipMode.URL.value = "OrderSelectShipModeRedirect";
		document.changeShipMode.submit();
	} else {
		alertDialog("<%=UIUtil.toJavaScript((String)orderMgmtNLS.get("noItemForUpdate"))%>");
		return;
	}
}

//---------------------------------------------------------------------
//  GUI functions
//---------------------------------------------------------------------

function selectOne(modeId) {

	if (finalId == modeId)
		finalId = "";
	else
		finalId = modeId;
	
	for (var i=0; i<document.changeShipMode.elements.length; i++) {
		if (modeId != document.changeShipMode.elements[i].name)
			document.changeShipMode.elements[i].checked = false;
	}

}
//[[>-->
</script>
</head>

<body class="content">
 
<%= comm.addControlPanel(xmlFile, totalpage, totalsize, jLocale) %>
<form name="changeShipMode" method="post" action="CSROrderItemUpdate">
	<input type="hidden" name="XML" value="" /> 
    <input type="hidden" name="URL" value="" />
        
	<%= comm.startDlistTable((String)orderMgmtNLS.get("selectShipModeTitle")) %>
	<%= comm.startDlistRowHeading() %>
		<%= comm.addDlistCheckHeading(false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("shipMethod"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("shipCarrier"), null, false) %>
		<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("shipService"), null, false) %>
	<%= comm.endDlistRow() %>
	
	<%
	if (totalsize != 0) {
		if (endIndex > actualsize) {
			endIndex = actualsize;
		}
	} else {
		endIndex = 0;
	}
	
	
	//TABLE CONTENT
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
	%>
		<%= comm.startDlistRow(rowselect) %>
			<%= comm.addDlistCheck(((Hashtable)shipModes.elementAt(i)).get("id").toString(), "selectOne('" + ((Hashtable)shipModes.elementAt(i)).get("id") + "')") %>
			<%= comm.addDlistColumn(((Hashtable)shipModes.elementAt(i)).get("desc").toString(), "none") %>
			<%= comm.addDlistColumn(((Hashtable)shipModes.elementAt(i)).get("carrier").toString(), "none") %>
			<%= comm.addDlistColumn(((Hashtable)shipModes.elementAt(i)).get("code").toString(), "none") %>
		<%= comm.endDlistRow() %>
		
		<%
		if (rowselect == 1) {
			rowselect = 2;
		} else {
			rowselect = 1;
		}
	}
	%>
	
	<%= comm.endDlistTable() %>

</form>

<script type="text/javascript">
<!-- <![CDATA[
        parent.afterLoads();
        parent.setResultssize(getResultsSize());
//[[>-->
</script>

<script type="text/javascript">
<!-- <![CDATA[
        // For IE
        if (document.all) {
          onLoad();
        }
//[[>-->
 </script>

</body>
</html>

