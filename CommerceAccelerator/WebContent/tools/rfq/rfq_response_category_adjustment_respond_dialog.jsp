<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 

<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ include file="../common/common.jsp" %>

<%
    //*** GET LOCALE FROM COMANDCONTEXT ***//
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    Locale locale = null;
    Integer languageId = null; 
    String lang = null;
    String storeId = null;
    if ( aCommandContext!= null ) {
   		locale = aCommandContext.getLocale();
   		languageId = aCommandContext.getLanguageId();	
    } 
    if (locale == null) {
		locale = new Locale("en","US");
    }
    if (languageId == null) {
		languageId = new Integer(-1);
    }
    lang = languageId.toString();
    storeId = aCommandContext.getStoreId().toString();
    //*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",locale);  
    JSPHelper jspHelper = new JSPHelper(request);
    String rfqId = jspHelper.getParameter("requestId");     
    String ppCategoryId = jspHelper.getParameter("ppCategoryId");
    String ppRequestName = jspHelper.getParameter("ppRequestName");
    String requestPP = jspHelper.getParameter("requestPP");
    String responsePP = jspHelper.getParameter("responsePP");   
    String ppSynchonInfo = jspHelper.getParameter("ppSynchonInfo");    
    String ppSynchonInfoRes = jspHelper.getParameter("ppSynchonInfoRes");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>

<script type="text/javascript">
var ppCategoryId = '<%= UIUtil.toJavaScript(ppCategoryId) %>';     
var pprequestName = '<%= UIUtil.toJavaScript(ppRequestName) %>'; 
var pprequest = '<%= UIUtil.toJavaScript(requestPP) %>'; 
var ppresponse = '<%= UIUtil.toJavaScript(responsePP) %>'; 
var ppsynchonInfo = '<%= UIUtil.toJavaScript(ppSynchonInfo) %>';
var ppsynchonInfoRes = '<%= UIUtil.toJavaScript(ppSynchonInfoRes) %>';

var aCatalogPP = new Object();
aCatalogPP = top.getData("aCatalogPP", 1);
var allCatalogPP = new Array();
allCatalogPP = top.getData("allCatalogPP", 1);


if (ppCategoryId == undefined || ppCategoryId == null || isEmpty(ppCategoryId)) {
	ppCategoryId = aCatalogPP.<%= RFQConstants.EC_OFFERING_CATEGORYID %>;	
}
if (pprequestName == undefined || pprequestName == null || isEmpty(pprequestName)) {
	pprequestName = aCatalogPP.categoryName;
}   
if (pprequest == undefined || pprequest == null || isEmpty(pprequest)) {
	pprequest = aCatalogPP.<%= RFQConstants.EC_RFQ_OFFERING_PRICEADJUSTMENT %>;
}
if (ppresponse == undefined || ppresponse == null || isEmpty(ppresponse)) {	
	ppresponse =  aCatalogPP.<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %>;	
}    
if (ppsynchonInfo == undefined || ppsynchonInfo == null || isEmpty(ppsynchonInfo)) {
	ppsynchonInfo = aCatalogPP.<%= RFQConstants.EC_RFQ_OFFERING_SYNCHRONIZE %>;
}
if (ppsynchonInfoRes == undefined || ppsynchonInfoRes == null || isEmpty(ppsynchonInfoRes)) {
	ppsynchonInfoRes = aCatalogPP.<%= RFQConstants.EC_OFFERING_SYNCHRONIZE %>;
} 
function onLoad() { 
	loadFrames(); 
}
function retrievePanelData() {
	var tempValue = aCatalogPP.res_priceAdjustment;
	document.rfqCatAdjustForm.responseadjust.value = tempValue.substring(1, tempValue.length);
}    
function initializeState() {
    parent.setContentFrameLoaded(true);
}        
var VPDResult;
function validatePanelData() {
	return VPDResult;
}
function validatePanelData0() {
	var form = document.rfqCatAdjustForm;
	var flag = true, adjust=false;
	if ((form.responseadjust.value == null) || (form.responseadjust.value =="")) {
	    alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgEmptyResponseValue")) %>");
	    return false;
	}	
	if (form.responseadjust.value!= null && form.responseadjust.value!="")	{
	    if (!parent.isValidNumber(form.responseadjust.value,"<%=lang%>", false))	    {
			adjust=true;
			flag=false;
	    }
	    if (form.responseadjust.value < 0 || form.responseadjust.value > 99) {	    
			adjust=true;
			flag=false;
	    } 
	}
	if (adjust)	{
	    alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidNumber")) %>");
	}
	return flag;
}
function savePanelData()    {
	VPDResult = validatePanelData0();
	if (!VPDResult)	{
	    return;
	}
	var form = document.rfqCatAdjustForm;
	var resCategoryId = ppCategoryId;
	
	aCatalogPP.<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> = '-' + parent.strToNumber(form.responseadjust.value,"<%=lang%>");
	aCatalogPP.res_priceAdjustment = '-' + form.responseadjust.value;	
	
	if(form.rfqcatalogsynchronized[form.rfqcatalogsynchronized.selectedIndex].value == 'true') {		
		aCatalogPP.<%= RFQConstants.EC_OFFERING_SYNCHRONIZE %> = 'true';
	} else if(form.rfqcatalogsynchronized[form.rfqcatalogsynchronized.selectedIndex].value == 'false') {		
		aCatalogPP.<%= RFQConstants.EC_OFFERING_SYNCHRONIZE %> = 'false';	
	}
		
	for(var i = 0;i < allCatalogPP.length;i++) 
	{
	    if (allCatalogPP[i].<%= RFQConstants.EC_OFFERING_CATEGORYID %> == aCatalogPP.<%= RFQConstants.EC_OFFERING_CATEGORYID %>) 
	    { 
		allCatalogPP[i].<%= RFQConstants.EC_OFFERING_RESPOND_TO_CATEGORY %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_CATEGORY_YES %>"; 
		allCatalogPP[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> = aCatalogPP.<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %>;
		allCatalogPP[i].res_priceAdjustment = aCatalogPP.res_priceAdjustment;
		allCatalogPP[i].<%= RFQConstants.EC_OFFERING_SYNCHRONIZE %> = aCatalogPP.<%= RFQConstants.EC_OFFERING_SYNCHRONIZE %>;           
		break; 
	    }
	}
	top.sendBackData(allCatalogPP, "allCatalogPP");
}

</script>
</head>

<body class="content">

<h1><%= rfqNLS.get("rfqresponsecategoryadjust") %></h1>
<%= rfqNLS.get("instruction_PDresponse_priceajustdialog_dialog") %>

<form name="rfqCatAdjustForm" action="">
<table border="0" width="100%">

    <tr>
  		<td>  	
  		<b><%= rfqNLS.get("resrequest") %><br /></b>
  		&nbsp;<br />	
  		</td>
    </tr>    

    <tr>
    	<td><%= rfqNLS.get("RFQCreateCategoryDisplay_Name") %>:
		<script type="text/javascript">
	    	document.write(ToHTML(aCatalogPP.<%= RFQConstants.EC_OFFERING_CATEGORYNAME %>));
		</script>
    	</td>
    </tr>
    
    <tr>
    	<td><%= rfqNLS.get("rfqcategorydescription") %>:
		<script type="text/javascript">
	    	document.write(ToHTML(aCatalogPP.<%= RFQConstants.EC_OFFERING_CATEGORYDESCRIPTION %>));
		</script>
    	</td>
    </tr>
         
    <tr>
    	<td><%= rfqNLS.get("rfqpriceadjustment") %>:
		<script type="text/javascript">
	    	document.write(ToHTML(aCatalogPP.<%= RFQConstants.EC_RFQ_OFFERING_PRICEADJUSTMENT %>));
		</script>
		&nbsp;<%=rfqNLS.get("percentagemark")%>
    	</td>
    </tr>   
 
    <tr>
    	<td><%= rfqNLS.get("rfqcatalogsynchronized") %>:
		<script type="text/javascript">
		if((aCatalogPP.<%= RFQConstants.EC_RFQ_OFFERING_SYNCHRONIZE %>) == 'true') {
			document.write(ToHTML("<%= (String)rfqNLS.get("yes") %>")); 
		} else if ((aCatalogPP.<%= RFQConstants.EC_RFQ_OFFERING_SYNCHRONIZE %>) == 'false') {
			document.write(ToHTML("<%= (String)rfqNLS.get("no") %>")); 
		} else {		
			document.write(ToHTML(aCatalogPP.<%= RFQConstants.EC_RFQ_OFFERING_SYNCHRONIZE %>));		 
		}	
		</script>
    	</td>
    </tr>    

    <tr>
    	<td>    
    	<br /><b><%= rfqNLS.get("resresponse") %><br /></b> 
    	&nbsp;<br />    	
    	</td>
    </tr>    
    
    <tr>
    	<td><%= rfqNLS.get("RFQCreateCategoryDisplay_Name") %>:
		<script type="text/javascript"> 
    		if (pprequestName == null || isEmpty(pprequestName)) {
            	document.write("<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>");
    		} else {
	    	document.write(ToHTML(aCatalogPP.<%= RFQConstants.EC_OFFERING_CATEGORYNAME %>));
    		}
		</script>
    	</td>
    </tr>
         
    
    <tr>
    	<td><%= rfqNLS.get("rfqcategorydescription") %>:
		<script type="text/javascript">
            	document.write(ToHTML(aCatalogPP.<%= RFQConstants.EC_OFFERING_CATEGORYDESCRIPTION %>));
		</script>
    	</td>
    </tr>         
         
    <tr>
        <td>        	
            <label for="responseadjust">
    	    <br /><%= rfqNLS.get("rfqpriceadjustment") %>:<br />
    	    <input type="text" name="responseadjust" id="responseadjust" size="15" maxlength="15" /> &nbsp;<%=rfqNLS.get("percentagemark")%>&nbsp;<%=rfqNLS.get("rfqpercentagemarkdown")%>
            </label>
        </td>
    </tr>
       
    <tr>    
		<td>		
        	<label for="rfqcatalogsynchronized">
		<br /><%= rfqNLS.get("rfqcatalogsynchronized") %>:<br />	
			<script type="text/javascript">	
				document.write('<select name="rfqcatalogsynchronized" id="rfqcatalogsynchronized">');  	
	    		if(ppsynchonInfoRes == null || isEmpty(ppsynchonInfoRes)) 
	    		{
		    		document.write("<option value=\"true\" selected=\"selected\"><%= (String)rfqNLS.get("yes") %></option>");
	    			document.write("<option value=\"false\"><%= (String)rfqNLS.get("no") %></option>");    		
	    		} else if(ppsynchonInfoRes=='true') {	    		
	    			document.write("<option value=\"true\" selected=\"selected\"><%= (String)rfqNLS.get("yes") %></option>");
	    			document.write("<option value=\"false\"><%= (String)rfqNLS.get("no") %></option>");
	    		} else if(ppsynchonInfoRes=='false') {	
	    			document.write("<option value=\"true\"><%= (String)rfqNLS.get("yes") %></option>");    		
	    			document.write("<option value=\"false\" selected=\"selected\"><%= (String)rfqNLS.get("no") %></option>");	
	    			    		
	    		}	    		
	    		document.write('</select>');
	    	</script>    
	    	</label>  
		</td>
    </tr>   
      
</table>
</form>

<script type="text/javascript">
    retrievePanelData();
    initializeState();
</script>

</body>
</html>
