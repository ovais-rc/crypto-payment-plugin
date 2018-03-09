<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>


<%@page import="java.util.*,
		com.ibm.commerce.beans.*,
		com.ibm.commerce.catalog.objects.*,
		com.ibm.commerce.tools.util.*,
		com.ibm.commerce.utils.*,
		com.ibm.commerce.command.*,
                com.ibm.commerce.tools.catalog.beans.*,
                com.ibm.commerce.tools.catalog.util.*"
%>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  Hashtable itemResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ItemNLS", jLocale);
%>

<% 
   try {
    // get parameters from URL
    String productRefNum = request.getParameter(ECConstants.EC_PRODUCT_NUMBER);
    String langId = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);
    String itemRefNum = request.getParameter(ECConstants.EC_ITEM_NUMBER);
    
    ItemDataBean bnItem = null;
    ProductDataBean bnProduct = null;

    if(itemRefNum != null){
    	bnItem = new ItemDataBean();
    	bnItem.setItemRefNum(itemRefNum);

	DataBeanManager.activate(bnItem, request);
    }else{

	bnProduct = new ProductDataBean();
	bnProduct.setProductRefNum(productRefNum);
	
	DataBeanManager.activate(bnProduct, request);
    }

    String aurl = null;


    if(itemRefNum != null){
    
    	aurl = bnItem.getUrl();
    	
    }else{
	if(productRefNum != null){

    		aurl = bnProduct.getUrl();
	}
    }
    
    // prevent errors caused by double quotation and back slash
    if (aurl != null)
    	aurl = UIUtil.toJavaScript(aurl);
    else
        aurl = "";


    
%>


<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)itemResource.get("Advanced"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

function AdvancedData(aurl) {
    
    this.aurl = aurl;
 
}  

Advanced.ID = "advanced";

function Advanced(aurl) {
    
    this.data = new AdvancedData(aurl);
    this.id = Advanced.ID;
    this.formref = null;
     
}    
 
function load() {
     
    var re = /(\r\n)/gi;
    this.data.aurl = parent.cutspace(this.formref.aurl.value);

}


function display() {
    this.formref.aurl.value = this.data.aurl;
  
}

function getData() {
    return this.data;
}

Advanced.prototype.load = load;
Advanced.prototype.display = display;
Advanced.prototype.getData = getData;

var adv = null;

function savePanelData() {

   if (adv != null) {
        
       adv.formref = document.advanced;
       adv.load();        
       parent.put(Advanced.ID, adv.getData());
   }
   
}

function initForm() {

    var dataObject = parent.get(Advanced.ID);
    
    if (dataObject == null) {
        
        adv = new Advanced("<%=aurl%>");
        
        adv.formref = document.advanced;
    	adv.display();
        
    } else {
    
        adv = new Advanced();
        adv.data = dataObject;
        adv.formref = document.advanced;
        adv.display();
    }
    
    
    if (parent.get("fieldSizeExceeded_aurl", false))
       {
        parent.remove("fieldSizeExceeded_aurl");
	document.advanced.aurl.select();
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>");
               
       }

    if (parent.get("aurlSpace_aurl", false))
       {
        parent.remove("aurlSpace_aurl");
	document.advanced.aurl.select();
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("aurlSpace"))%>");
               
       }

      
    parent.setContentFrameLoaded(true);
}    



function validatePanelData(){

    var objAurl = document.advanced.aurl.value;

    if ( !isValidUTF8length(objAurl, 254)  ){
	document.advanced.aurl.select();
	alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>");     	 
   	return false;
    }

    if (numOfOccur(objAurl, ' ') > 0) {
	document.advanced.aurl.select();
	alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("aurlSpace"))%>");     	 
   	return false;
    }

    return true;
}

</SCRIPT>
</HEAD>

    
<BODY class="content" onload="initForm()">
<H1><%=UIUtil.toHTML((String)itemResource.get("Advanced"))%></H1> 

<FORM name="advanced">

<TABLE cols=6>   
    <TH colspan="6"></TH>   
    <TR>
    	<TD colspan="6">
    	    <LABEL for="urlID"><%=UIUtil.toHTML((String)itemResource.get("aurl"))%></LABEL>
    	</TD>
    </TR>
    <TR>
    	<TD colspan="6">
	    <INPUT id="urlID" size="58" maxlength="254" type="text" name="aurl"><BR><BR>
	</TD>
    </TR>
    
     
</TABLE>

</FORM>
 
<%
}
catch (Exception e) 
{
        
       com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
}

%>

</BODY>
</HTML>


