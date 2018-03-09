<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2002, 2005
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<%
//---------------------------------------------------------------------
//- Import and Include Section
//---------------------------------------------------------------------
%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.beans.LanguageDescriptionDataBean"%>

<%@include file="../common/common.jsp" %>

<%
   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Hashtable rbProduct = (Hashtable)ResourceDirectory.lookup("catalog.ProductNLS", cmdContext.getLocale());
%>

<HTML>
<HEAD>

<LINK rel=stylesheet href="<%= UIUtil.getCSSFile(cmdContext.getLocale()) %>" type="text/css">
<TITLE><%=UIUtil.toHTML((String)rbProduct.get("descriptiveAttributeDialog_Title"))%></TITLE>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>
<SCRIPT> 


	function displayButtons(count)
	{
		if (count == 0)
		{
			newButton.className    = 'enabled';
			changeButton.className = 'disabled';
			removeButton.className = 'disabled';
		}

		if (count == 1)
		{
			newButton.className    = 'enabled';
			changeButton.className = 'enabled';
			removeButton.className = 'enabled';
		}

		if (count > 1)
		{
			newButton.className    = 'enabled';
			changeButton.className = 'disabled';
			removeButton.className = 'enabled';
		}
	}

	function buttonCreate()
	{
		if (newButton.className != "enabled") return;

		if (parent.contentFrame && parent.contentFrame.proceedHandler)
		{
			if (parent.contentFrame.proceedHandler() == false) return;
		}

		var url                 = "/webapp/wcs/tools/servlet/DialogView"
		var urlPara             = new Object();
		urlPara.XMLFile         = "catalog.attributeCreateDescriptiveDialog";
		urlPara.productrfnbr    = parent.contentFrame.getCatentryID();
		urlPara.isNewAttribute  = "true";
		if (top.get("CatalogExtendedFunction", false) == true) { urlPara.onlyOne = "false"; }
		else                                                   { urlPara.onlyOne = "true";  }
		top.setContent("<%= UIUtil.toJavaScript((String)rbProduct.get("attribute_title_newAttribute")) %>", url, true, urlPara);     
	}

	function buttonChange()
	{
		if (changeButton.className != "enabled") return;

		if (parent.contentFrame && parent.contentFrame.proceedHandler)
		{
			if (parent.contentFrame.proceedHandler() == false) return;
		}

		var url                 = "/webapp/wcs/tools/servlet/DialogView"
		var urlPara             = new Object();
		urlPara.XMLFile         = "catalog.attributeCreateDescriptiveDialog";
		urlPara.productrfnbr    = parent.contentFrame.getCatentryID();
		urlPara.attributeId     = parent.contentFrame.getAttributeID();
		urlPara.isNewAttribute  = "false";
		if (top.get("CatalogExtendedFunction", false) == true) { urlPara.onlyOne = "false"; }
		else                                                   { urlPara.onlyOne = "true";  }
		top.setContent("<%= UIUtil.toJavaScript((String)rbProduct.get("attribute_title_updateAttribute")) %>", url, true, urlPara);     
	}
	function buttonRemove()
	{
		if (removeButton.className != "enabled") return;
		if (!confirmDialog("<%= UIUtil.toJavaScript((String)rbProduct.get("AttributeDeleteMsg")) %>")) return;
		if (parent.contentFrame && parent.contentFrame.buttonRemove) parent.contentFrame.buttonRemove();
	}


	function onLoad()
	{
		displayButtons(0);
	}

</SCRIPT>
</HEAD>

<BODY class="content_bt" ONLOAD=onLoad() bgcolor=white style="background-color:#EFEFEF;">

  	<script>
  	beginButtonTable();

	drawButton("newButton", 
			    "<%=UIUtil.toHTML((String)rbProduct.get("attribute_button_newAttribute"))%>", 
				"buttonCreate()", 
				"enabled");		  				
				
	drawButton("changeButton", 
			"<%=UIUtil.toHTML((String)rbProduct.get("attribute_button_updateAttribute"))%>", 
				"buttonChange()", 
				"enabled");		  				

	drawButton("removeButton", 
			    "<%=UIUtil.toHTML((String)rbProduct.get("attribute_button_removeAttribute"))%>", 
				"buttonRemove()", 
				"enabled");		  				

	endButtonTable();			
  	</script>


</BODY>

<SCRIPT>
	AdjustRefreshButton(newButton);
	AdjustRefreshButton(changeButton);
	AdjustRefreshButton(removeButton);
</SCRIPT>

</HTML>
