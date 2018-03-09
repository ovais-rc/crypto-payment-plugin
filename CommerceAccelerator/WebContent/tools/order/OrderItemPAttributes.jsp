<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2003, 2008 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.ras.*" %>
<%@ page import="com.ibm.commerce.rfq.helpers.PersonalizationAttribute" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@include file="../common/common.jsp" %>

<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();

Hashtable orderLabels 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderLabels", jLocale);

com.ibm.commerce.server.JSPHelper URLParameters = new com.ibm.commerce.server.JSPHelper(request);
String orderItemId = URLParameters.getParameter(ECConstants.EC_ORDERITEM_RN);

OrderItemDataBean orderItemDB = new OrderItemDataBean();
orderItemDB.setOrderItemId(orderItemId);
com.ibm.commerce.beans.DataBeanManager.activate(orderItemDB, request);

%>

<%--
//---------------------------------------------------------------------
//- Forward Error JSP 
//---------------------------------------------------------------------
--%>
<%
String exMsg = "";
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
} catch (Exception ex) {
	exMsg = "";
}
%>

<html>
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 
	<title><%= UIUtil.toHTML((String)orderLabels.get("pAttributesTitle")) %></title>
	<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
	
	<script type="text/javascript">
	<!-- <![CDATA[
	function initialize() {    
		parent.setContentFrameLoaded(true);
	
		if ("<%= UIUtil.toJavaScript(exMsg) %>" != "") {
			alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");
		}
	}	
		
	function viewAttachment(attachmentId) {
		document.attachmentViewForm.<%= ECConstants.EC_ATTACH_ID %>.value = attachmentId;
		document.attachmentViewForm.submit();
	}
	//[[>-->
	</script>
</head>

<body onload="initialize();" class="content">
  <h1><%= UIUtil.toHTML((String)orderLabels.get("pAttributesTitle")) %></h1> 

  <table class="list" width="75%" >
  
  <tr class="list_roles">
    <td width="20%" class="list_header" id="col1">
    &nbsp;&nbsp;&nbsp;<%= UIUtil.toHTML((String)orderLabels.get("pAttributesName")) %>&nbsp;&nbsp;&nbsp;
    </td>

    <td width="20%" class="list_header" id="col2">
    &nbsp;&nbsp;&nbsp;<%= UIUtil.toHTML((String)orderLabels.get("pAttributesOperator")) %>&nbsp;&nbsp;&nbsp;
    </td>

    <td width="40%" class="list_header" id="col3">
    &nbsp;&nbsp;&nbsp;<%= UIUtil.toHTML((String)orderLabels.get("pAttributesValue")) %>&nbsp;&nbsp;&nbsp;
    </td>
    
    <td width="20%" class="list_header" id="col4">
    &nbsp;&nbsp;&nbsp;<%= UIUtil.toHTML((String)orderLabels.get("pAttributesUnit")) %>&nbsp;&nbsp;&nbsp;
    </td>
  </tr>
  
  <%
  if (!orderItemDB.hasPAttributes()) {
  %>
  	<%= UIUtil.toHTML((String)orderLabels.get("pAttributesNotFound")) %>
  <%
  } else {
  	PersonalizationAttribute[] pAttributes = orderItemDB.getPAttributes(cmdContextLocale.getLanguageId());
  	String classId = "list_row1";
  	for (int i=0; i<pAttributes.length; i++) {
  	%>
  		<tr class="<%= classId %>" >
  			<td class="list_info1"><%= pAttributes[i].getName() %></td>
  			<td class="list_info1"><%= pAttributes[i].getOperator() %></td>
  			<%
  			if (!pAttributes[i].getType().equals(PersonalizationAttribute.TYPE_ATTACHMENT)) {
  			%>
  				<td class="list_info1"><%= pAttributes[i].getValue() %></td>
  			<%
  			} else {
  				String attachmentId = pAttributes[i].getValue();
  				System.out.println(attachmentId);
  				StringBuffer hereLink = new StringBuffer();
  				hereLink.append("<a href=\"javascript:viewAttachment('");
  				hereLink.append(attachmentId);
  				hereLink.append("')\">");
  				hereLink.append((String)orderLabels.get("pAttributesHere"));
  				hereLink.append("</a>");
  				System.out.println(hereLink.toString());
  				Object[] arguments = { hereLink.toString() };
  				String resultText = MessageFormat.format(ECMessageHelper.doubleTheApostrophy((String)orderLabels.get("pAttributesViewAttachment")),arguments);
  			%>
  				<td class="list_info1"><%= resultText %></td>
  			<%
  			}
  			%>
  			<td class="list_info1"><%= pAttributes[i].getQuantityUnit() %></td>
  		</tr>
  	<%
  		if (classId.equals("list_row1")) {
  			classId="list_row2";
  		} else {
  			classId="list_row1";
  		}
  	}
  }
  %>
  </table>
  <form name="attachmentViewForm" method="post" action="OrderItemAttachmentView" >
  	<input type="hidden" name="<%= ECConstants.EC_ATTACH_ID %>" value="" />
  	<input type="hidden" name="<%= ECConstants.EC_ORDERITEM_RN %>" value="<%= orderItemId %>" />
  	<input type="hidden" name="<%= ECConstants.EC_ERROR_VIEWNAME %>" value="OrderItemPAttributesView" />
  </form>
</body>
</html>
