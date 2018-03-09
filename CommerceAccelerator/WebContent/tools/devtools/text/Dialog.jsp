<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2003, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="com.ibm.commerce.command.CommandContext" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.ResourceBundleProperties" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.ResourceBundle" %>
<%@page import="java.io.File" %>
<%@page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@page import="com.ibm.commerce.server.ConfigProperties" %>
<%@page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@page import="com.ibm.commerce.exception.ECException" %>
<%@page import="com.ibm.commerce.tools.devtools.store.databeans.StoreFrontDataBean" %>
<%@page import="com.ibm.commerce.tools.devtools.store.ui.storefront.api.Content" %>
<%@page import="com.ibm.commerce.tools.devtools.store.ui.storefront.api.Text" %>
<%@page import="com.ibm.commerce.server.WcsApp" %>
<%@page import="com.ibm.commerce.server.WebModuleConfig" %>
<%@page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@page import="com.ibm.commerce.common.helpers.StoreUtil" %>
<%@page import="com.ibm.commerce.registry.StoreRegistry" %>
<%@page import="com.ibm.commerce.server.ECConstants" %>

<%@include file="../../common/common.jsp" %>

<jsp:useBean id="sdb" class="com.ibm.commerce.common.beans.StoreDataBean" scope="request">
<% com.ibm.commerce.beans.DataBeanManager.activate(sdb, request); %>
</jsp:useBean>

<%
try {
	CommandContext cmdContext  = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties dialogRB = (ResourceBundleProperties)com.ibm.commerce.tools.util.ResourceDirectory.lookup("devtools.StoreTextRB", locale);

	Integer StoreId= cmdContext.getStoreId();
	// Find out if "MC" is on store.storelevel
	String STORE_LEVEL = "MC";
	String strStoreLevel = null;
	StoreAccessBean storeAB = StoreRegistry.singleton().find(StoreId);
	if (storeAB != null) {
		strStoreLevel = storeAB.getStoreLevel();
		if (strStoreLevel == null) {
			Integer[] storePathIds = StoreUtil.getStorePath(storeAB.getStoreEntityIdInEntityType(), ECConstants.EC_STRELTYP_VIEW);
			StoreAccessBean relatedStoreAccessBean = null;
			boolean storeLevelFound = false;
			for (int i=1; i<storePathIds.length; i++) {
				if (!storeLevelFound) {
					relatedStoreAccessBean = StoreRegistry.singleton().find(storePathIds[i]);
					strStoreLevel = relatedStoreAccessBean.getStoreLevel();
					if (strStoreLevel != null) {
						storeLevelFound = true;
					}
				}
			}
		}
	}
	if (strStoreLevel != null && strStoreLevel.toUpperCase().contains(STORE_LEVEL.toUpperCase())) {
%>
		<html>
			<head>
				<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
				<script src="/wcs/javascript/tools/common/Util.js"></script>
				
				<script>
					function initializeState() {
						top.showProgressIndicator(false);
						alertDialog('<%=UIUtil.toJavaScript(dialogRB.get("Text.managementCenter"))%>');
						top.setHome();
					}
				</script>
			</head>
			<body class="content" onload="initializeState();">
				<br>
			</body>
		</html>
<%
	} else {
%>

<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale) %>" type="text/css"/>
<script src="/wcs/javascript/tools/common/Util.js"></script>
<%
	StoreFrontDataBean storeFrontDataBean = new StoreFrontDataBean();
	String uiStoreDir = null;
	try {
		storeFrontDataBean.setCommandContext(cmdContext);
		storeFrontDataBean.populate();
		uiStoreDir = storeFrontDataBean.getStoreDir();
	} catch (ECException e) {
		%></head>
		<body class="content">
		<script>
			parent.setContentFrameLoaded(true);
			alertDialog("<%= dialogRB.getJSProperty("Text.notConfigured") %>");
			top.setHome();
		</script>
		<%
		return;
	}
%>

<script>
	var textList = new Object();

	function viewLocation(url) {
		var url2 = self.location.protocol + '//';
		url2 = url2 + self.location.hostname;
		url2 = url2 + '<%=ConfigProperties.singleton().getValue("WebServer/StoresWebPath")%>/';
		url2 = url2 + url.replace("$storeDir$", "<%= UIUtil.toJavaScript(uiStoreDir) %>");
		window.open(url2, '', 'location=no,menubar=yes,resizable=yes,scrollbars=yes,status=no,titlebar=no,toolbar=yes,width=810,height=450,top=50,left=50').focus();
	}
	
	function showPanelData() {
		for (var i = 0; i < document.generalForm.elements.length; i++) {
			var element = document.generalForm.elements[i];
			if (element.name != null && element.name != "") {
				element.value = textList[element.name];
			}
		}	
	}
	
	/******************************************************************************
	*
	*	Framework hooks.
	*
	******************************************************************************/
	function initializeState() {
		parent.setContentFrameLoaded(true);
		showPanelData();
	}	

	function savePanelData() {
		for (var i = 0; i < document.generalForm.elements.length; i++) {
			var element = document.generalForm.elements[i];
			if (element.name != null && element.name != "") {
				textList[element.name] = element.value;
			}
		}
		parent.put("STORE_TEXT", textList);
	}
	
	function onClickLink(elementId) {
		for (var i = 0; i < document.images.length; i++) {
			var element = document.images[i];
			if (element.id != null && element.id != "" && element.id == elementId) {
				onClick(element);
			}
		}
	}
	
	function onClick(element) {

		var divId = "div" + element.id;
		var index = element.src.lastIndexOf("/");
		var name = element.src.slice(index + 1);

		if (name == "right.gif") {
			element.src = top.getWebPrefix() + "images/tools/devtools/down.gif";
			document.getElementById(divId).style.display = "inline";
			document.getElementById(divId + "a").style.display = "none";
			document.getElementById("textareafor"+element.id).focus();
		} else {
			element.src = top.getWebPrefix() + "images/tools/devtools/right.gif";
			document.getElementById(divId + "a").style.display = "inline";
			document.getElementById(divId).style.display = "none";
		}
	}
</script>
</head>

<body class="content" onload="initializeState()">
<h1><%= (String)dialogRB.getProperty("Text.title") %></h1>

<form name="generalForm">
<p>
<%
	Text[] text = storeFrontDataBean.getStoreText();
	
	if (text.length != 0) {
	out.print(dialogRB.getProperty("Text.instructions"));
%>
	<br><br>
	<table><tr>
		<td valign="top" nowrap>
			<b><%= dialogRB.getProperty("Text.note") %></b>
		</td>
		<td>
			<%= dialogRB.getProperty("Text.note1") %>
			<br>
		
	<script>
		var note = "<%= UIUtil.toJavaScript(UIUtil.toHTML(dialogRB.getProperty("Text.note2"))) %>";
		
		var var0 = "<%
				String prefix = null;
				WebModuleConfig module = WcsApp.configProperties.getWebModule(WcsApp.storeWebModuleName);
				if (module.getFileServletEnabled().equalsIgnoreCase(com.ibm.commerce.server.ECConstants.EC_CFG_FALSE)) {
					prefix = module.getWebAlias();
				} else {
					prefix = module.getContextPath();
				}
				out.print(prefix);
		%>";
		
		note = note.replace("{0}", var0);
		var storeDir = "<% 
			String storeDir = cmdContext.getStore().getDirectory();
			if (storeDir == null) {
				storeDir = "";
			}
			out.print(UIUtil.toJavaScript(storeDir) + "/");
		%>";
		
		var var1 = var0 + "/" + storeDir + "upload";
		note = note.replace("{1}", var1);
		document.write(note);
	</script>
		</td></tr>
	</table>
<%	} else {
		out.print(dialogRB.getProperty("Text.notConfigured"));
	}
	%>
</p><b><%= (String)dialogRB.getProperty("Text.heading") %></b><br><br>

	<%
		
	ResourceBundle rb = null;

	for (int i = 0; i < text.length; i++)
	{
		String label ="";
		if (text[i].getLabel() != null) {
			rb = sdb.getResourceBundle(text[i].getLabel().getResource());
			label = rb.getString(text[i].getLabel().getKey());
		}
%>

	<!-- image -->
	<script>
		var src = top.getWebPrefix() + "images/tools/devtools/right.gif";
		document.write('<img alt="<%=UIUtil.toJavaScript(label)%>" src="'+ src +'" id="<%= i%>" onClick="onClick(this)">')
	</script>

	<!-- label -->
	<a href="javascript:onClickLink(<%= i%>)" >
	<label for="textareafor<%= i %>"><%=label%></label>
	</a>

	<div id="div<%= i%>" style="display: none;">

	<table>
		<!-- description -->		
		<tr><td width="100px"></td><td>
		<%
			if (text[i].getDescription() != null) {
				rb = sdb.getResourceBundle(text[i].getDescription().getResource());
				String description = rb.getString(text[i].getDescription().getKey());
				out.print(description);
			}
		%></td>
		</tr>
		
		<!-- location -->
		<tr><td width="100px"></td><td align="right" width="625px">
			<%	String file = text[i].getLocation(locale);
				if (file != null) {
			%>
					<input type="button" class="button" style="width:auto" onClick="viewLocation('<%= UIUtil.toJavaScript(file) %>')" id="dialog" value="<%= (String)dialogRB.getProperty("Text.view.location") %>">
			<%	}	%></td>
		</tr>

		<!-- content -->
		<% if (text[i].getContent() != null) {
			Content[] content = text[i].getContent();
			for (int j = 0; j < content.length; j++) {
		%>			
		<tr valign="top"> <td width="100px"></td><td>
			<textarea id="textareafor<%= i %>" name="<%= UIUtil.toJavaScript(content[j].getId()) %>" rows="<%= content[j].getRows() %>" cols="100%" wrap="physical" >""</textarea>
			<script>
				textList["<%= UIUtil.toJavaScript(content[j].getId()) %>"] = "<%
				rb = sdb.getResourceBundle(content[j].getMessage().getResource());
				String contentTxt = rb.getString(content[j].getMessage().getKey());
				out.print(UIUtil.toJavaScript(contentTxt));
			%>";
			</script>
			</td>
		</tr>

		<%	}
		   } 
		%>
	</table>
	</div>

<span id="div<%= i%>a"></br></span>

<%
	}
%>
</table>
</form>

<%
}
} catch (Exception e) {
	com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}
%>
</body>
</html>
