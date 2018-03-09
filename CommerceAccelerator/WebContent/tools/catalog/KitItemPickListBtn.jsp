<!--
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------->

<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="KitUtil.jsp" %> 

<%
    CommandContext	cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
    Locale jLocale = cmdContext.getLocale();
    Hashtable		nlsKit = (Hashtable) ResourceDirectory.lookup("catalog.KitNLS", jLocale);
%>

<HTML>
<HEAD>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/DTable.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/KitContents.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/catalog/button.js"></SCRIPT>

<SCRIPT>

function enableButtons(nNumOfSKUs)
{
	enableButton(btnClear,(nNumOfSKUs >0));
}

function btnClear_onclick()
{
	parent.List.removeSelectedSKUs();
}

function btnFind_onclick()
{
	parent.findMoreSKUs();
}

</SCRIPT>

</HEAD>

<BODY class="content_bt" >
	<P><H1>&nbsp;</H1></P>
	
  	<script>
  	beginButtonTable();
  	
	drawButton("btnFindMore", 
				"<%=getNLString(nlsKit,"btnFindMore")%>", 
				"btnFind_onclick()", 
				"enabled");		  				

				
	drawButton("btnClear", 
				"<%=getNLString(nlsKit,"btnClear")%>", 
				"btnClear_onclick()", 
				"disabled");		  				
				
	endButtonTable();			
  	</script>
		
</BODY>

<script>

	AdjustRefreshButton(btnFindMore);
	AdjustRefreshButton(btnClear);

	parent.initAllFrames();
	
</script>

</HTML>