<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%-- 
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
--%>

<%@ page import="com.ibm.commerce.order.objects.*"%>
<%@ page import="com.ibm.commerce.server.*"%>
<%@ page import="com.ibm.commerce.tools.util.*"%>
<%@ page import="com.ibm.commerce.command.CommandContext"%>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*"%>
<%@ page import="com.ibm.commerce.beans.*"%>
<%@ page import="com.ibm.commerce.ras.ECMessageType"%>
<%@ page import="com.ibm.commerce.tools.util.UIUtil"%>
<%@ page
	import="com.ibm.commerce.marketing.databeans.PromoCodeListDataBean"%>
<%@include file="../../tools/common/common.jsp"%>
<%@include file="../../tools/common/NumberFormat.jsp"%>

<%-- 
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>

<%! 
	
%>

<%-- 
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<% 

	// obtain the resource bundle for display
	CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale jLocale 		= cmdContextLocale.getLocale();
	String langId		= cmdContextLocale.getLanguageId().toString();
	Integer storeId 	= cmdContextLocale.getStoreId();
	Hashtable orderLabels 	= (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
   	Hashtable orderMgmtNLS 	= (Hashtable)ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
   	Hashtable orderAddProducts 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderAddProducts", jLocale);

	// retrieve request parameters
	JSPHelper jspHelper 	= new JSPHelper(request);
	String firstOrderId 	= jspHelper.getParameter("firstOrderId");
	String isDisplayOnly 	= jspHelper.getParameter("isDisplayOnly");
	// get standard list parameters
	String xmlFile 		= request.getParameter("ActionXMLFile");
	int startIndex 		= 0;
	String orderByParam	= "";
	int endIndex		= 0;
	int rowselect 		= 1;

	PromoCodeListDataBean promoCodeList = new PromoCodeListDataBean();
	if (firstOrderId != null && firstOrderId.length() > 0) {
			promoCodeList.setOrderId(new Long(firstOrderId));
		try {
			com.ibm.commerce.beans.DataBeanManager.activate(promoCodeList, request, response);
		} catch (Exception ex) {
			System.out.println(ex.getMessage());
		}
	}
	
	//the totalsize 
	int totalsize = 0;
	if ((promoCodeList != null) && (promoCodeList.getCodes().length != 0)) {
		totalsize = promoCodeList.getCodes().length;
	}

	//get the order's member id
	OrderAccessBean abOrder = new OrderAccessBean();
	abOrder.setInitKey_orderId(firstOrderId);
	String memberId = abOrder.getMemberId();
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
	DataBeanManager.activate (errorBean, request, response);

//	String exKey = errorBean.getMessageKey();

	//If the message type in the ErrorDataBean is type SYSTEM then 
	//display the system message.  Otherwise the message is type USER
	//so display the user message.
	if ( errorBean.getECMessage().getType() == ECMessageType.SYSTEM ) {
		exMsg = errorBean.getSystemMessage();
	} else {
		exMsg = errorBean.getMessage();
	}
	

	
} catch (Exception ex) {
	exMsg = "";
}

%>

<html>
<head>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>"
	type="text/css" />

<title><%= UIUtil.toHTML((String)orderMgmtNLS.get("promotionCodesPage")) %></title>

<script src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
<script src="/wcs/javascript/tools/common/Vector.js"></script>
<script src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
<script src="/wcs/javascript/tools/common/dynamiclist.js"></script>

<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[
//---------------------------------------------------------------------
//  Required javascript function for wizard panel and notebook panel and dynamic list
//---------------------------------------------------------------------
function savePanelData() {
  parent.parent.put("callPrepareRequired", "true");
  
  var authToken = parent.parent.get("authToken");
  if (defined(authToken)) {
	parent.parent.addURLParameter("authToken", authToken);
  }
	
}// END savePanelData()


function validatePanelData() { 
	return true;
}

function validateNoteBookPanel() {
	return validatePanelData();
}

function onLoad() {
	parent.loadFrames();

}

function getResultsSize() {
    return <%=totalsize%>;
}

//---------------------------------------------------------------------
//  user defined javascript functions 
//---------------------------------------------------------------------


function initializeState() {
	if ("<%= UIUtil.toJavaScript(exMsg) %>" != "")
		alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");
		parent.parent.setContentFrameLoaded(true);
	}
function addPromoCode() {

	if (document.getElementById("promoCodeDisplay").value != ""){
		// Before leaving this page needs to save the data changed in the panel
		savePanelData();
		document.PromotionCodeForm.promoCode.value = document.getElementById("promoCodeDisplay").value;
		document.PromotionCodeForm.taskType.value = "A";
		parent.parent.setContentFrameLoaded(false);
		document.PromotionCodeForm.submit();   
	}
}

function removePromotionCode() {

	// Before leaving this page needs to save the data changed in the panel
	savePanelData();
	var checkedItems = new Array;
	checkedItems = parent.getChecked();

	var promoCodes = "";		

	for (var i=0; i<checkedItems.length; i++) {
		promoCodes = promoCodes + "," + checkedItems[i];
	}
	document.PromotionCodeDeleteForm.promoCode.value = promoCodes;
	parent.parent.setContentFrameLoaded(false);
	document.PromotionCodeDeleteForm.submit();   	
}


//[[>-->
</script>

</head>
<!--BODY bgcolor= "#A6A6A6" LINK = "#00436A" VLINK = "#00436A"  ALINK = "#00436A" -->
<body class="content" onload="initializeState();">
<!--Support For Customers,Shopping Under Multiple Accounts. -->
<%request.setAttribute("resourceBundle", orderAddProducts);%>
<%if (isDisplayOnly == null || isDisplayOnly == "") {%>
<table>
	<tr valign="top">
		<td><label for="promoCodeDisplay"><%=UIUtil.toJavaScript((String)orderMgmtNLS.get("promotionCodeLabel"))%></label>
		</td>
	</tr>
	<tr valign="top">
		<td><input type="text" size="20" name="promoCodeDisplay"
			id="promoCodeDisplay" value="" /></td>
		<td>
		<button id="contentButton" name="updateBtn" onclick="addPromoCode();"><%=UIUtil.toJavaScript((String)orderMgmtNLS.get("addPromotionCode"))%></button>
		</td>
	</tr>
</table>
<% } %>
<form name="PromotionCodeForm" method="post" action="PromotionCodeManage">
	<input type="hidden" name="orderId" value="<%=firstOrderId%>" /> 
	<input type="hidden" name="forUserId" value="<%=memberId%>" /> 
	<input type="hidden" name="taskType" value="A" /> 
	<input type="hidden" name="promoCode" value="" /> 
	<input type="hidden" name="clearForUser" value="true" /> 
	<input type="hidden" name="URL"	value="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=order.orderPromotionCodesPageB2C&cmd=OrderPromotionCodesPageB2C&firstOrderId=<%=firstOrderId%>" />
	<input type="hidden" name="errorViewName" value="OrderPromotionCodesPageB2C" /> 
	<input type="hidden" name="firstOrderId" value="<%=firstOrderId%>" />
</form>

<form name="PromotionCodeDeleteForm" method="post" action="PromotionCodeManage" id="PromotionCodeDeleteForm">
	<input type="hidden" name="orderId" value="<%=firstOrderId%>" /> 
	<input type="hidden" name="forUserId" value="<%=memberId%>" /> 
	<input type="hidden" name="taskType" value="R" /> 
	<input type="hidden" name="promoCode" value="" /> 
	<input type="hidden" name="clearForUser" value="true" /> 
	<input type="hidden" name="URL" value="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=order.orderPromotionCodesPageB2C&cmd=OrderPromotionCodesPageB2C&firstOrderId=<%=firstOrderId%>" />
	<input type="hidden" name="errorViewName" value="OrderPromotionCodesPageB2C" /> 
	<input type="hidden" name="firstOrderId" value="<%=firstOrderId%>" />
</form>

<form name="itemListForm" method="post" action="">
	<%= comm.startDlistTable("PromotionCodesListTable") %>
	<%= comm.startDlistRowHeading() %> 
	<% 
	if (isDisplayOnly == null || isDisplayOnly == "") {  %>
		<%= comm.addDlistCheckHeading() %> 
	<% } %> 
	<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("promotionCode"), null, true) %>
	<%= comm.addDlistColumnHeading((String)orderMgmtNLS.get("promotionDescription"), null, false) %>
	<%= comm.endDlistRow() %> 
	<% 
	if (totalsize != 0) {
		//the end index is the amount of the promotion codes
		endIndex = promoCodeList.getCodes().length;

	} else {
		endIndex = 0;
	}

	
	//TABLE CONTENT
	int indexFrom = startIndex;
	for (int i=indexFrom; i<endIndex; i++) {
	%> 
	<%= comm.startDlistRow(rowselect) %> 
	<% 
	if (isDisplayOnly == null || isDisplayOnly == "") { %>
		<%= comm.addDlistCheck(promoCodeList.getCodes()[i].getCode(), "parent.setChecked();") %>
	<% } %> 
	<%= comm.addDlistColumn(promoCodeList.getCodes()[i].getCode(), "none") %>
	<%= comm.addDlistColumn(promoCodeList.getCodes()[i].getDescription(), "none") %>

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
       	parent.setButtonPos("0px", "69px");
		<%if (isDisplayOnly != null && isDisplayOnly != "") {%>
       		parent.hideButton("removePromotionCode");
       	<% } %>
//[[>-->
</script>

<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[
//For IE
if (document.all) {
	onLoad();
}
//[[>-->
</script>

</body>
</html>
