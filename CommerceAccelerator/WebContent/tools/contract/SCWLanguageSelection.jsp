<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.command.ECStringConverter" %>
<%@ page import="com.ibm.commerce.server.ECConstants" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.common.ECToolsConstants" %>
<%@ page import="com.ibm.commerce.exception.ECApplicationException" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.Util" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.StoreCreationWizardDataBean" %>
<%@ page import="com.ibm.commerce.tools.util.StringPair" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="com.ibm.commerce.server.WcsApp" %>

<%@include file="../common/common.jsp" %>
<%@include file="../contract/SCWCommon.jsp" %>
<%
	try {
		String originalLangId = cc.getLanguageId().toString();

		JSPHelper jspHelper = new JSPHelper(request);
		String MerchantCenterURL = jspHelper.getParameter(ECToolsConstants.EC_TOOLS_MERCHANT_CENTER_URL);	
		String launchSeparateWindow = jspHelper.getParameter("launchSeparateWindow");
		final int _LANG_LIST_SIZE = 10;

		// Getting the url of the calling page.
		String callingURL = null;
		boolean isCallingURLPresent = false;
		boolean fromAccelerator = false;
        	Cookie[] cookies = request.getCookies();   
        	for (int i = 0; i < cookies.length; i++){
			if (cookies[i].getName().equalsIgnoreCase("callingURLCookie")) {
				callingURL = cookies[i].getValue();
				isCallingURLPresent = true;
			}
			if (cookies[i].getName().equalsIgnoreCase("fromAcceleratorCookie")) {
				if (cookies[i].getValue().equals("true"))
					fromAccelerator = true;
			}
		} 

		// getting the user type to check later if the user is registered
        	String userRegisteredType = cc.getUser().getRegisterType();		      		
%>

<html>
<head>
<title> <%=UIUtil.toHTML((String)resourceBundle.get("langtitle"))%> </title>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript" src="/wcs/javascript/tools/contract/StoreCreationWizardLogon.js">
</script>
<script language="JavaScript" src="/wcs/javascript/tools/common/URLParser.js">
</script>
<script language="JavaScript">

function init(){
	
	if('<%= userRegisteredType %>' == 'G'){
		if(<%= launchSeparateWindow %> != null && "<%= launchSeparateWindow %>" == "false"){
            		document.getElementById("storeCreationLanguage_div").style.display = "none";	
			document.getElementById("storeLanguage_Logon_div").style.display = "block";
		}else{
			document.getElementById("storeCreationLanguage_div").style.display = "none";	
			document.getElementById("storeLanguage_Logon_div").style.display = "none";
		}		
	}else{
		document.getElementById("storeCreationLanguage_div").style.display = "block";	
		document.getElementById("storeLanguage_Logon_div").style.display = "none";
	}

}



function cancelStoreSelection()	{

	if(<%= isCallingURLPresent %>){
		top.location.href = "<c:out value='<%= UIUtil.toJavaScript(callingURL) %>'/>";
	}else{
		top.location.href = "ToolsLogon?" + '<%= ECToolsConstants.EC_XMLFILE%>' +  "=" + "contract.scwizardLogon";
	}
}


function launchSCW(langid) {
	
	var launch = "<c:out value='<%= MerchantCenterURL%>'/>";
	var language = '<%=ECConstants.EC_LANGUAGE_ID%>';
		
	launch = launch + "?XMLFile=contract.StoreCreationWizardConsole&" + language + "=" + langid + "&originalLangId=<%=originalLangId%>";
	
	// launch the store creation wizard in the same window
	if(<%= launchSeparateWindow %> != null && "<%= launchSeparateWindow %>" == "false"){
    		launch = preserveParameters(document.URL, launch);    		
		top.location.href = launch;
 	
    	// open a new window to launch the store creation wizard
    	}else{
    		if (defined(top.getModel)==true && <%= fromAccelerator %> == false) {     // if inside SCW, just refresh it!
			top.location.replace(launch);
			return false;
		}

		document.getElementById("f1").action = "SCWLaunched";		
    		childWindow=open(launch, 'StoreCreationWizardConsole', 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes');   
    		if (childWindow.opener == null) childWindow.opener = self;   	
    	}  	  	
	return true;
}


function openHelp() {
	var helpfile= 'http://<%= WcsApp.configProperties.getValue("Websphere/HelpServerHostName") + ":" + WcsApp.configProperties.getValue("Websphere/HelpServerPort", "8001") %>/help/index.jsp?lang=<%=locale.toString()%>&topic=/com.ibm.commerce.base.doc/f1/fctsclng.htm';
	
	window.open(helpfile, "Help", "resizable=yes,scrollbars=yes,menubar=yes, copyhistory=no");
}


function SubmitHandler() {
	var langid;

	langid = document.f1.<%=ECConstants.EC_LANGUAGE_ID%>.options[document.f1.<%=ECConstants.EC_LANGUAGE_ID%>.selectedIndex].value;
	
   	if (launchSCW(langid)==true) {
		return true;
	} else {
		return false;
	}
}


</script>
</head>
<body style="overflow:auto" onload="init();">

<div id="storeCreationLanguage_div">

<form NAME="f1" METHOD="GET" ACTION="" onSubmit="return SubmitHandler()" id="f1">
     <table width=100% CELLPADDING=0 CELLSPACING=0 BORDER=0 HEIGHT=100% id="SCWLanguageSelection_Table_1">
          <tr>
             <td id="SCWLanguageSelection_TableCell_1">
                <table width=100% CELLPADDING=0 CELLSPACING=0 BORDER=0 id="SCWLanguageSelection_Table_2">
                    <tr>
                       <% if (fromAccelerator == false) { %>  
                       <td COLSPAN=4 HEIGHT="44" class="logon" id="SCWLanguageSelection_TableCell_2">&nbsp;</td>
                       <% } %>
                    </tr>
                </table>
                <table height=100% CELLPADDING=0 CELLSPACING=0 BORDER=0 WIDTH=791 id="SCWLanguageSelection_Table_3">
                    <tr>
                       <td WIDTH="20" ROWSPAN="9" id="SCWLanguageSelection_TableCell_3">&nbsp;</td>
                       <td class="h1" HEIGHT="50" id="SCWLanguageSelection_TableCell_4"><%=UIUtil.toHTML((String)resourceBundle.get("pageheading"))%></td>
                       <td ROWSPAN="9" VALIGN=TOP WIDTH="320" HEIGHT=100% id="SCWLanguageSelection_TableCell_5"><img src="/wcs/images/tools/logon/logon.jpg" border="0" alt="<%=UIUtil.toJavaScript((String)resourceBundle.get("pageheading"))%>"></td>
                    </tr>

				<tr>
					<td class="text" id="SCWLanguageSelection_TableCell_6"><label for="langlb"><%=UIUtil.toHTML((String)resourceBundle.get("langlistname"))%></label></td>
				</tr>
				<tr>
					<td id="SCWLanguageSelection_TableCell_7">
							<%
							StoreCreationWizardDataBean scDB = new StoreCreationWizardDataBean ();
							DataBeanManager.activate(scDB, request);
							Vector languages = scDB.getLanguages();
							if (!languages.isEmpty()) {	
								int langlistsize = languages.size();
								if (langlistsize > _LANG_LIST_SIZE) {
									langlistsize = _LANG_LIST_SIZE;
								}
							%>

							<select NAME="<%=ECConstants.EC_LANGUAGE_ID%>" ID="langlb" SIZE="<%=langlistsize%>" width=100%>
							<%

								for (int i = 0; i <languages.size(); i++) {
									StringPair langStringPair = (StringPair)languages.elementAt(i);
									String langId = langStringPair.getKey();
									String langDesc = langStringPair.getValue();

									if (langId.equals(cc.getLanguageId().toString())) { %>									
										<OPTION value=<%= langId %> SELECTED><%=langDesc%></option>
									<% } else { %>
										<OPTION value=<%= langId %>><%=langDesc%></option>
									<% }
								}

							%>
							</select>
							<%
							}
							%>
					</td>
				</tr>

				<tr>
					<td class="text" id="SCWLanguageSelection_TableCell_8">
					   <script>
						document.write(changeSpecialText("<%=UIUtil.toHTML((String)resourceBundle.get("changeDisplayLanguage"))%>", '<B>', '</B>'));
					   
</script>
					</td>
				</tr>
				<tr>
					<td class="text" id="SCWLanguageSelection_TableCell_9">&nbsp;</td>
				</tr>

				<tr>
					<td class="text" id="SCWLanguageSelection_TableCell_10">
						<table CELLPADDING=0 CELLSPACING=0 BORDER=0 height="26" id="SCWLanguageSelection_Table_4">
							<tr>
								<td id="SCWLanguageSelection_TableCell_11"><button type="submit" value="<%=UIUtil.toJavaScript((String)resourceBundle.get("ok"))%>" class="general"> &nbsp;<%=UIUtil.toHTML((String)resourceBundle.get("ok"))%>&nbsp;</button></td>
								<td WIDTh="5" id="SCWLanguageSelection_TableCell_12">&nbsp;</td>
							<% if (fromAccelerator == false) { %>
								<td id="SCWLanguageSelection_TableCell_13"><button type="button" value="<%=UIUtil.toJavaScript((String)resourceBundle.get("cancel"))%>"  onClick="cancelStoreSelection()" class="general"> <%=UIUtil.toHTML((String)resourceBundle.get("cancel"))%></button></td>
								<td WIDTh="5" id="SCWLanguageSelection_TableCell_14">&nbsp;</td>
								<td id="SCWLanguageSelection_TableCell_15"><button type="button" value="<%=UIUtil.toJavaScript((String)resourceBundle.get("help"))%>"  onClick="openHelp()" class="general"> <%=UIUtil.toHTML((String)resourceBundle.get("help"))%></button></td>
							<% } %>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td HEIGHT=95% id="SCWLanguageSelection_TableCell_16">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<% if (fromAccelerator == false) { %>
	<tr>
		<td COLSPAN=4 class="legal" id="SCWLanguageSelection_TableCell_17"><%=UIUtil.toHTML((String)resourceBundle.get("copyright"))%></td>
	</tr>
<% } %>
</table>
</form>

</div>

<div id="storeLanguage_Logon_div">
<center>
<h1>
<%=UIUtil.toHTML((String)resourceBundle.get("storeLanguageLogonMessage"))%>
</h1>
</center>
</div>


</body>
</html>
<%
	}catch(Exception e){ %>
	<script language="JavaScript">
		document.URL="/webapp/wcs/tools/servlet/SCWErrorView";
	
</script>
	<% }
%>

