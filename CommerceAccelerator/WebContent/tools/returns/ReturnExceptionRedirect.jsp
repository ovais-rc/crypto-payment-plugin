<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ras.ECMessageType" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>

<%@include file="../common/common.jsp" %>



<%
	ErrorDataBean errorBean = new ErrorDataBean ();
	com.ibm.commerce.beans.DataBeanManager.activate (errorBean, request);

	String exKey = errorBean.getMessageKey();

	String exMsg = "";
	//If the message type in the ErrorDataBean is type SYSTEM then 
	//display the system message.  Otherwise the message is type USER
	//so display the user message.
	if ( errorBean.getECMessage().getType() == ECMessageType.SYSTEM )
		exMsg = errorBean.getSystemMessage();
	else
		exMsg = errorBean.getMessage();
		
	String orgCmd = errorBean.getOriginatingCommand();
	
	String backToReturnList = "N";
	if (exKey.equals("_ERR_GENERIC")) {
		String[] paramObj = (String[])errorBean.getMessageParam();
		exMsg = paramObj[0];
	}else if (exKey.equals("_ERR_RETURNS_IS_LOCKED")
				||exKey.equals("_ERR_RETURNS_IS_NOT_LOCKED")
				||exKey.equals("_ERR_RMA_IN_INVALID_STATE_FOR_COMMAND")){
		String[] paramObj = (String[])errorBean.getMessageParam();
		exMsg = paramObj[0];
		backToReturnList = "Y";
	}
	
	//This is an optional redirecturl parameter for better customization
	JSPHelper jspHelper = new JSPHelper(request);
	String redirectURL = jspHelper.getParameter("redirecturl");
%>

<HTML>
   <HEAD>
    	<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
    	<SCRIPT>
    	function init() {
   		alertDialog("<%=UIUtil.toJavaScript(exMsg)%>");


		if ("<%=backToReturnList%>" == "Y"){
			top.mccbanner.showLink(3);
			return;
		}

   		var prev = "";
		//exception caught while in wizard or notebook page with dynamic list
   		if (parent.parent.get) {
   		    prev = parent.parent.get("prev");
   		    if (defined(prev) && prev != null && prev != "") {
			parent.parent.setContentFrameLoaded(true);
   		        parent.parent.gotoPanel(prev);
   		        return;
   		    }
   		}
   		
		//exception caught while in wizard or notebook page without dynamic list
   		if (parent.get) {
   		    prev = parent.get("prev");
   		    if (defined(prev) && prev != null && prev != "") {
			parent.setContentFrameLoaded(true);
   		        parent.gotoPanel(prev);
   		        return;
   		    }
   		}

		if ("<%=orgCmd%>" == "CSRReturnCancelCmd" && "<%=redirectURL%>" != "")
		{
			var wizardModel = top.getModel(1);
			var prev = wizardModel.prev;
			if (defined(prev) && prev != null && prev != "") {
				//cancel from wizard or notebook
				top.goBack();
				return;
			} else {
				//cancel from return list
				this.location.replace("<%=redirectURL%>");
				return;
			}
		}
		else if ("<%=orgCmd%>" == "CSRReturnRestoreCopyCmd")
		{
			top.goBack();
			return;
		}
		else if ( defined(parent.isDialog) || defined(parent.parent.isDialog) )
		{
   			top.goBack();
   			return;
   		}
		else if ("<%=redirectURL%>" != "")
		{
			this.location.replace("<%=redirectURL%>");
			return;
		}
		else
		{
			top.goBack();
			return;
		}
	}
   	</SCRIPT>
   </HEAD>

   <BODY class="content" onload="init();">
   </BODY>
</HTML>



