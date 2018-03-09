<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2010 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page import="java.util.*" %> 
<%@page import="com.ibm.commerce.tools.util.*" %> 
<%@page import="com.ibm.commerce.tools.common.*" %>                          
<%@page import="com.ibm.commerce.command.*" %>
<%@page import="com.ibm.commerce.tools.resourcebundle.*" %> 
<%@page import="com.ibm.commerce.server.*" %>
<%@page import="com.ibm.commerce.common.objects.*" %>
<%@page import="com.ibm.commerce.contract.util.*" %>
<%@page import="com.ibm.commerce.contract.helper.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.server.ConfigProperties" %>

<%@include file="../common/common.jsp" %>
<%@include file="../contract/SCWCommon.jsp" %>
<%
	try {
    		JSPHelper jspHelper = new JSPHelper(request);	      	
   		String contract_id = jspHelper.getParameter("contractId");
   		String launchSeparateWindow = jspHelper.getParameter("launchSeparateWindow");
		String fromAccelerator = jspHelper.getParameter("fromAccelerator");   		
   		// By default, the store view will be "StoreView"
   		String storeViewName = "StoreView";
		if(jspHelper.getParameter("storeViewName") != null && !jspHelper.getParameter("storeViewName").equalsIgnoreCase("")){
			storeViewName = jspHelper.getParameter("storeViewName");
		}

		boolean isSeparateWindowLaunched = true;
		if(launchSeparateWindow != null && launchSeparateWindow.equalsIgnoreCase("false")){
			isSeparateWindowLaunched = false;
		}
		boolean isFromAccelerator = false;
		if(fromAccelerator != null && fromAccelerator.equalsIgnoreCase("true")){
			isFromAccelerator = true;
		}

		String toolsPort = ConfigProperties.singleton().getValue("WebServer/ToolsPort");
		
%>

<html>
<head>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(locale) %>" type="text/css">
<script language="JavaScript" src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript" src="/wcs/javascript/tools/contract/StoreCreationWizard.js">
</script>
<script language="JavaScript">
//Maximum number of tries to check if store creation is successful
var MAX_TRY = 60;

// counter to track the number of tries
var counter = 0;

var storeId = null;
var storeIdentifier = "";
var storeType = null;
var store_url = null;
var storeCreationStatus = '<%= ECContractConstants.EC_STATE_DEPLOY_IN_PROGRESS %>';
	
function init(){
	display();	
	checkStatus();
	parent.setContentFrameLoaded(true);
}


function checkStatus(){
	if(document.getElementById("storeCreationIframe") != null){
		document.body.removeChild(document.getElementById("storeCreationIframe"));		
	}
	counter++;
	if(counter == MAX_TRY){
		storeCreationStatus = '<%= ECContractConstants.EC_STATE_DEPLOY_FAILED %>';
		display();
		return;
	}

	// create the hidden iframe to check store creation status	
	var storeCreationIframe = document.createElement("IFRAME");
	storeCreationIframe.id="storeCreationIframe";
	storeCreationIframe.src="/webapp/wcs/tools/servlet/SCWConfirmationIframeView?contractId=<%=contract_id%>" + "&storeViewName=<%=storeViewName%>";
	storeCreationIframe.style.position = "absolute";
	storeCreationIframe.style.visibility = "hidden";
	storeCreationIframe.style.height="130";
	storeCreationIframe.style.width="220";
	storeCreationIframe.style.top="130";
	storeCreationIframe.style.left="330";
	storeCreationIframe.frameborder="1";
	storeCreationIframe.MARGINHEIGHT="0"
	storeCreationIframe.MARGINWIDTH="0";		
	document.body.appendChild(storeCreationIframe);	
}


function display(){
	if(storeCreationStatus == '<%= ECContractConstants.EC_STATE_ACTIVE %>' || storeCreationStatus == '<%= ECContractConstants.EC_STATE_SUSPENDED %>'){
		generateInstructions();
		document.getElementById("waitingIndicator").style.display = "none";	
		document.getElementById("successfulResultText").style.display = "block";
		document.getElementById("failedResultText").style.display = "none";
		document.getElementById("nextStepsInstructions").style.display = "block";
		// document.getElementById("successfulDiv").style.display = "block";
		document.getElementById("successfulDiv").style.visibility = "visible";
	
	}else if(storeCreationStatus == '<%= ECContractConstants.EC_STATE_DEPLOY_FAILED %>'){
		document.getElementById("waitingIndicator").style.display = "none";	
		document.getElementById("successfulResultText").style.display = "none";
		document.getElementById("failedResultText").style.display = "block";
		document.getElementById("nextStepsInstructions").style.display = "none";
		document.getElementById("successfulDiv").style.display = "none";
		
	}else{
		document.getElementById("waitingIndicator").style.display = "block";	
		document.getElementById("successfulResultText").style.display = "none";
		document.getElementById("failedResultText").style.display = "none";
		document.getElementById("nextStepsInstructions").style.display = "none";
		// document.getElementById("successfulDiv").style.display = "none";
		document.getElementById("successfulDiv").style.visibility = "hidden";
	}
}


function launchAccelerator(){
	var acceleratorURL = "https://";
	acceleratorURL += self.location.hostname;
	acceleratorURL += ":<%= toolsPort %>";
	acceleratorURL += "<%= UIUtil.getWebappPath(request) %>MerchantCenterView?XMLFile=common.merchantCenter" + storeType + "&storeId=" + storeId;
	window.open(acceleratorURL, 'MerchantCenter', 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes').focus();	
}


function launchStore(){
	window.open(store_url);
}


function bookmark(){
	var bookmark_name = changeSpecialText("<%=UIUtil.toHTML((String)resourceBundle.get("storeBookmark"))%>", storeIdentifier);	
	window.external.AddFavorite(store_url,bookmark_name);
}



function generateInstructions(){
	var htmlText = null;	
        htmlText = "<BR><BR><TABLE border=0 width=100%>";
    	htmlText += "<TR><TD>" + "<B><%= UIUtil.toHTML((String)resourceBundle.get("confirmationInstruction")) %></B></TD></TR>";    
              
        htmlText += "<TR>";
        htmlText += "<TD>";
      
        htmlText += "<TABLE border=0>";
        htmlText += "<TR>";
        htmlText += "<TD valign=top>";
        htmlText += "<%=UIUtil.toHTML((String)resourceBundle.get("confirmationNumber1"))%>";
        htmlText += "</TD>";
        htmlText += "<TD>";        
        htmlText += changeSpecialText("<%=UIUtil.toHTML((String)resourceBundle.get("confirmationInstructionnew1"))%>", '<A href="javascript:bookmark();">', '</A>' );
        htmlText += "</TD>";
        htmlText += "</TR>";        

        htmlText += "<TR>";
        htmlText += "<TD valign=top>";
        htmlText += "<%=UIUtil.toHTML((String)resourceBundle.get("confirmationNumber2"))%>";
        htmlText += "</TD>";
        htmlText += "<TD>";  
        if(<%=isFromAccelerator%>){    
        	htmlText += "<%=UIUtil.toHTML((String)resourceBundle.get("confirmationInstructionnew2"))%>";
        } else {
        	htmlText += "<%=UIUtil.toHTML((String)resourceBundle.get("confirmationInstructionnew2"))%>";
        }
        htmlText += "</TD>";
        htmlText += "</TR>";        

	if(<%=isSeparateWindowLaunched%>){
        	htmlText += "<TR>";
        	htmlText += "<TD valign=top>";
        	htmlText += "<%=UIUtil.toHTML((String)resourceBundle.get("confirmationNumber3"))%>";
        	htmlText += "</TD>";
        	htmlText += "<TD>";        
        	htmlText += changeSpecialText("<%=UIUtil.toHTML((String)resourceBundle.get("confirmationInstruction3"))%>", '<A href="javascript:launchAccelerator();">', '</A>' );
        	htmlText += "</TD>";
        	htmlText += "</TR>";        
        }
        
        htmlText += "</TABLE>";
        htmlText += "</TD>"; 
	htmlText += "</TR>";
	htmlText += "</TABLE><BR><BR>";

	document.getElementById("nextStepsInstructions").innerHTML = htmlText;
}



function progress_clear() {
	for (var i = 1; i <= progressEnd; i++) document.getElementById('progress'+i).style.backgroundColor = 'transparent';
	progressAt = 0;
}


function progress_update() {
	progressAt++;
	if (progressAt > progressEnd) progress_clear();
	else document.getElementById('progress'+progressAt).style.backgroundColor = progressColor;
	progressTimer = setTimeout('progress_update()',progressInterval);
}


function progress_stop() {
	clearTimeout(progressTimer);
	progress_clear();
}


</script>
</head>

<body onload="init()" class="content">
<h1><%=UIUtil.toHTML((String)resourceBundle.get("confirmationTitle"))%></h1>


<div id="waitingIndicator">
<center>
	<table border=0 id="SCWConfirmation_Table_1">
		<tr>
			<td id="SCWConfirmation_TableCell_1">
				<b>
					<div style='padding:1px;border:solid silver 2px;width=82px;'>
						<span id='progress1'>&nbsp;</span>
						<span id='progress2'>&nbsp;</span>
						<span id='progress3'>&nbsp;</span>
						<span id='progress4'>&nbsp;</span>
						<span id='progress5'>&nbsp;</span>
						<span id='progress6'>&nbsp;</span>
						<span id='progress7'>&nbsp;</span>
						<span id='progress8'>&nbsp;</span>
						<span id='progress9'>&nbsp;</span>
						<span id='progress10'>&nbsp;</span>
					</div>
				</b>
			</td>
		</tr>
	</table>

<script language="javascript">
var progressEnd = 10;		// set to number of progress <SPAN>'s. //25
var progressColor = '#FFD350';	// set to progress bar color
var progressInterval = 360;	// set to time between updates (milli-seconds)

var progressAt = progressEnd;
var progressTimer;

progress_update();		// start progress bar


</script>

<br>
<%=UIUtil.toHTML((String)resourceBundle.get("waitingMessage"))%>
</center>
</div>


<div id="successfulResultText">
<center>
<b>
<%=UIUtil.toHTML((String)resourceBundle.get("storeCreationSuccessful"))%>
</b>
</center>
</div>

<div id="failedResultText">
<center>
<b>
<%=UIUtil.toHTML((String)resourceBundle.get("storeCreationFailed"))%>
</b>
</center>
</div>

<!-- The content of the DIV below is generated dynamically -->
<div id="nextStepsInstructions">
</div>
<div id="successfulDiv">
<center>

<table id="SCWConfirmation_Table_2">
	<tr>
		<td id="SCWConfirmation_TableCell_2">
			<button hidden="true" type="button" value="launchBookmark" onclick="bookmark()" class="general"> <%=UIUtil.toHTML((String)resourceBundle.get("launchBookmark"))%></button>
		</td>
		<%
		if(isSeparateWindowLaunched){
		%>
			<td id="SCWConfirmation_TableCell_3">
				<button type="button" value="launchAccelerator" onclick="launchAccelerator()" class="general"> <%=UIUtil.toHTML((String)resourceBundle.get("launchAccelerator"))%></button>
			</td>
		<%
		}
		%>	
		<%
		if(!isFromAccelerator){
		%>	
		<td id="SCWConfirmation_TableCell_4">
			<button type="button" value="launchStore" onclick="launchStore()" class="general"> <%=UIUtil.toHTML((String)resourceBundle.get("launchStore"))%></button>
		</td>
		<%
		}
		%>			
	</tr>
</table>
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

