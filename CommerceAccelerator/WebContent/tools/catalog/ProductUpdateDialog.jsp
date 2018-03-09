

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.catalog.commands.CatalogEntryXMLControllerCmd" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.AccessControlHelperDataBean" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>

<%@include file="../common/common.jsp" %>
<%
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable) ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
	String catgroupID = UIUtil.toHTML(request.getParameter("catgroupID"));
	JSPHelper helper= new JSPHelper(request);

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	// Handle the difference between VAJ and WSAD in request 
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	if((catgroupID == null) || (catgroupID.equals("")))
	{
		catgroupID = "null";
	}
	
	String myInterfaceName = CatalogEntryXMLControllerCmd.NAME;
	AccessControlHelperDataBean myACHelperBean= new AccessControlHelperDataBean();
	myACHelperBean.setInterfaceName(myInterfaceName);
	DataBeanManager.activate(myACHelperBean,cmdContext);

	// to do, need to change to get value from access control helper after access control is done
	boolean attachmentAccessGained = true;
%>

<HTML>

<SCRIPT>

	var storeDirectory = "<%= cmdContext.getStore().getDirectory() %>";
	var detailPageLoadedTF = false;
	var readonlyAccess = <%=myACHelperBean.isReadOnly()%>;
	var attachmentAccessGained = <%=attachmentAccessGained%>;
	
	function isInsideWizard()
	{
		return true;
	}

	function detailPageLoaded()
	{
		detailPageLoadedTF = true;
	}

	function getDetailPageLoaded()
	{
		return detailPageLoadedTF;
	}

	function getHelp()
	{
		return "MC.catalogTool.ProductUpdateDialog.Help";
	}

	function visibleList(s)
	{
		if(s=='hidden')
		{
			titleFrame.oPopup.hide();
			contentFrame.oPopup.hide();
		}
	}


	top.put("AttributeEditorReturnLanguage", "null");
	var catentryId  = top.get("ProductUpdateDetailCatentryId", null);
	top.put("ProductUpdateDetailCatentryId" , null);

	function onLoad()
	{
		top.showProgressIndicator(true);
		var urlPara = new Object();
		urlPara.catgroupID="<%=UIUtil.toJavaScript(catgroupID)%>";
		urlPara.menuXML="catalog.CatalogMenuProduct";
<%
		Enumeration e = request.getParameterNames();
		String strName = new String();
		while (e.hasMoreElements())
		{
			strName = (String) e.nextElement();
			if (strName == null || strName.trim().equals("")) { continue; }
%>
			urlPara.<%=UIUtil.toHTML(strName)%>="<%=UIUtil.toJavaScript(UIUtil.toHTML(helper.getParameter(strName)))%>";
<%
		}
%>
		urlPara.catentryId= "" + catentryId;
		urlPara.pageSize = "<%=UIUtil.toHTML(helper.getParameter("displayNum"))%>";
		urlPara.displayNum = "9999";
		top.mccmain.submitForm("/webapp/wcs/tools/servlet/ProductUpdateDetail", urlPara, "contentFrame");
	}

</SCRIPT>

<FRAMESET BORDER=0 FRAMEBORDER=NO ID=frameset1 NAME=frameset1 ROWS="76,*,33" ONLOAD=onLoad()>
	<FRAME NAME=titleFrame   TITLE="<%= UIUtil.toHTML( (String)rbProduct.get("ProductUpdateDialog_FrameTitle_1")) %>" SRC="/webapp/wcs/tools/servlet/ProductUpdateTitle?menuXML=catalog.CatalogMenuProduct&catgroupID=<%=UIUtil.toHTML(catgroupID)%>">
	<FRAME NAME=contentFrame TITLE="<%= UIUtil.toHTML( (String)rbProduct.get("ProductUpdateDialog_FrameTitle_2")) %>" SRC="/wcs/tools/common/blank.html">
	<FRAME NAME=buttonFrame  TITLE="<%= UIUtil.toHTML( (String)rbProduct.get("ProductUpdateDialog_FrameTitle_3")) %>" SRC="/webapp/wcs/tools/servlet/ProductUpdateBottom">
</FRAMESET>

</HTML>
