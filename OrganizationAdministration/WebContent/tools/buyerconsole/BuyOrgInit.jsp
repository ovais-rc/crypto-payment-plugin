<!--==========================================================================
/*
 *-------------------------------------------------------------------
 * Licensed Materials - Property of IBM
 *
 * WebSphere Commerce
 *
 * (c) Copyright International Business Machines Corporation. 2005
 *     All rights reserved.
 *
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 *-------------------------------------------------------------------
*/
////////////////////////////////////////////////////////////////////////////////
//
// Change History
//
// YYMMDD    F/D#   WHO       Description
//------------------------------------------------------------------------------
//
////////////////////////////////////////////////////////////////////////////////
===========================================================================-->
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>

<%
CommandContext cmdContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
Locale locale = cmdContext.getLocale();

// obtain the resource bundle for display
Hashtable orgEntityNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("buyerconsole.BuyOrgEntityNLS", locale);
%>

<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></script>
<script language="JavaScript">
<!---- hide script from old browsers
   function finishHandler(finishMessage)
   {
	top.goBack();
   }

   function errorHandler(submitErrorMessage, submitErrorStatus)
   {
    if (submitErrorStatus == "_ERR_RDN_ALREADY_EXIST")
    {
        alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("orgExists"))%>");
    }
    else if (submitErrorStatus == "_ERR_DN_ALREADY_EXIST")
    {
        alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("nameAlreadyExists"))%>");
    }
    else if (submitErrorStatus == "_ERR_USER_AUTHORITY")
    {
        alertDialog("<%=UIUtil.toJavaScript((String)orgEntityNLS.get("buyOrgEntityCommandAccessControlError"))%>");
    }
    else
    {
    	alertDialog(submitErrorMessage);
    }
   }
//-->
</script>
