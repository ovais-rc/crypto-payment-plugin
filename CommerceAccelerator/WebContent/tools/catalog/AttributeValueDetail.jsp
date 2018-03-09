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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">

<HTML>
<HEAD>
 
<%@page import="java.util.*,
		com.ibm.commerce.beans.*,
                com.ibm.commerce.tools.catalog.beans.*,
                com.ibm.commerce.tools.util.*,
                com.ibm.commerce.tools.catalog.util.*"
%>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  Hashtable attributeResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.AttributeNLS", jLocale);
%>


<% 
   try {
   
   
   String languageId = cmdContext.getLanguageId().toString();  
   languageId = (languageId != null ? UIUtil.toJavaScript(languageId) : "");
   
   // get parameters from URL
    String product_id = request.getParameter(ECConstants.EC_PRODUCT_NUMBER);
    String attrVal_id = request.getParameter("attrValueId");
    String attr_id = request.getParameter("attributeId");

   AttributeValueDataBean attrValueBean = new AttributeValueDataBean();
   
   String attributeName = null;
   String attributeType = null;
   String image = null;
   String attributeValue = null;

   if(attrVal_id != null){
   	attrValueBean.setAttributeValueId(new Long(attrVal_id));
	DataBeanManager.activate(attrValueBean, request);
   	image = attrValueBean.getImage1();
  	attributeValue = attrValueBean.getAttributeValue();
   }
   image = (image != null ? UIUtil.toJavaScript(image) : "");
   attributeValue = (attributeValue != null ? UIUtil.toJavaScript(attributeValue) : "");


   AttributeDataBean attrBean = new AttributeDataBean();
   if(attr_id != null){
   	attrBean.setAttributeId(new Long(attr_id));
   	DataBeanManager.activate(attrBean, request);
   	attributeName = attrBean.getAttributeName();
   	attributeType = attrBean.getAttributeType();
   }
   attributeName = (attributeName != null ? UIUtil.toJavaScript(attributeName) : "");
   attributeType = (attributeType != null ? UIUtil.toJavaScript(attributeType) : "");


%>

<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)attributeResource.get("Description"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<%@include file="../common/NumberFormat.jsp" %>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

function DescriptionData(attributeValue, image) 
{
    this.attributeValue = attributeValue;
    this.image = image;
    
}    
 


Description.ID = "attributevaluedetails";

function Description(attributeValue, image) 
{
    this.data = new DescriptionData(attributeValue, image);
    this.id = Description.ID;
    this.formref = null;

}    

  

function load()
{

    var objValue = this.formref.attributeValue.value;


    if("<%=attributeType%>" == "AttributeFloatValueBean" || "<%=attributeType%>" == "AttributeIntegerValueBean"){

    	this.data.attributeValue = strToNumber(objValue, "<%=languageId%>");

    }else{
  
    	this.data.attributeValue = parent.cutspace(this.formref.attributeValue.value);
    }

    var re = /(\r\n)/gi;
    this.data.image = parent.cutspace((this.formref.image.value).replace(re, " "));
    
     
}


function display() 
{
    if("<%=attributeType%>" == "AttributeIntegerValueBean"){
     
    	var formatted = numberToStr(this.data.attributeValue, "<%=languageId%>", null);
    	
        if (formatted != "NaN" && formatted != null){
          	this.formref.attributeValue.value = formatted;
        }else{
                this.formref.attributeValue.value = this.data.attributeValue;
        }
               
    }else if("<%=attributeType%>" == "AttributeFloatValueBean"){
           
        var numDecimal = numberOfDecimalPlaces(this.data.attributeValue);
           
    	var formatted = numberToStr(this.data.attributeValue, "<%=languageId%>", numDecimal);
      	if (formatted != "NaN" && formatted != null){
   
           	this.formref.attributeValue.value  = formatted;   
   
       	}else{
             	this.formref.attributeValue.value  = this.data.attributeValue;
      	}
        
    }else{

    	this.formref.attributeValue.value = this.data.attributeValue;
    }
    
    this.formref.image.value = this.data.image;
    
}



function getData() {

    return this.data;
    
}
 

Description.prototype.load = load;
Description.prototype.display = display;
Description.prototype.getData = getData;

var desc = null;

function savePanelData()
{

   if (desc != null)
   {
       desc.formref = document.attributevaluedetails;
       desc.load();
       parent.put(Description.ID, desc.getData());

   }
    
}


function validatePanelData(){

    if(document.attributevaluedetails.attributeValue.value == ""){
	document.attributevaluedetails.attributeValue.select();
	alertDialog("<%=UIUtil.toJavaScript((String)attributeResource.get("attributeValueRequiredMessage"))%>");
	return false;
    }
    
    var val = document.attributevaluedetails.attributeValue.value;
    var langId = "<%=languageId%>";
    
    if("<%=attributeType%>" == "AttributeIntegerValueBean"){
    	
   	if (!isValidInteger(val , langId)){
		document.attributevaluedetails.attributeValue.select();
   		alertDialog("<%=UIUtil.toJavaScript((String)attributeResource.get("integerRequiredMessage"))%>");
   		return false;
   	}

	var integerVal = strToInteger(val, langId);

	if ( !isValidIntegerLength(integerVal)){
		document.attributevaluedetails.attributeValue.select();
		alertDialog("<%=UIUtil.toJavaScript((String)attributeResource.get("fieldSizeExceeded_attributeValue"))%>");     	 
   		return false;
    	}
   		
    }else if("<%=attributeType%>" == "AttributeFloatValueBean"){

   	if(!isValidNumber(val , langId)){
		document.attributevaluedetails.attributeValue.select();
   		alertDialog("<%=UIUtil.toJavaScript((String)attributeResource.get("floatRequiredMessage"))%>");
   		return false;
   	}

    }else{
    // if string value

	if ( !isValidUTF8length(val, 254)  ){
		document.attributevaluedetails.attributeValue.select();
		alertDialog("<%=UIUtil.toJavaScript((String)attributeResource.get("fieldSizeExceeded_attributeValue"))%>");     	 
   		return false;
    	}

    }

    var attrValueImage = document.attributevaluedetails.image.value;

    if ( !isValidUTF8length(attrValueImage, 254)  ){
	document.attributevaluedetails.image.select();
	alertDialog("<%=UIUtil.toJavaScript((String)attributeResource.get("fieldSizeExceeded_attributeValueImage"))%>");     	 
   	return false;
    }

    if (numOfOccur(attrValueImage, ' ') > 0) {
	document.attributevaluedetails.image.select();
	alertDialog("<%=UIUtil.toJavaScript((String)attributeResource.get("noSpaceForImageLocation"))%>");     	 
   	return false;
    }

    return true;
}


function isValidIntegerLength(integerNum){

	if(integerNum > -2147483648 && integerNum < 2147483647){
		return true;
	}else{
		return false;
	}

}

function initForm() {

    var dataObject = parent.get(Description.ID);
  
    if (dataObject == null) {
        
        desc = new Description("<%=attributeValue%>",
        		    "<%=image%>");
			    
        desc.formref = document.attributevaluedetails;
      
        desc.display();
        
    } 
    else 
    {

        desc = new Description();
        desc.data = dataObject;
        desc.formref = document.attributevaluedetails;
        desc.display();
    
    }
    parent.setContentFrameLoaded(true);
}    



</SCRIPT>

</HEAD>

    
<BODY class="content" onLoad="initForm()">
<H1>&nbsp;&nbsp;&nbsp;&nbsp;<%=UIUtil.toHTML((String)attributeResource.get("attrValueGeneralInfo"))%></H1> 
<FORM name="attributevaluedetails">
<TABLE>
    <TH></TH>   
    <TR>
    	<TD COLSPAN="5">
	    &nbsp;&nbsp;&nbsp;
    	    <%=UIUtil.toHTML(((String)attributeResource.get("attrname")) + ":")%>&nbsp;<I><%=UIUtil.toHTML(attributeName)%></I><BR><BR>
    	</TD>
    </TR>
    <TR>
    	<TD COLSPAN="5">
	    &nbsp;&nbsp;&nbsp;
    	    <label for='requiredAttrvalue'><%=UIUtil.toHTML((String)attributeResource.get("requiredAttrvalue"))%></label>
    	</TD>
    </TR>
    <TR>
    	<TD COLSPAN="5">
	    &nbsp;&nbsp;&nbsp;
    	    <INPUT id='requiredAttrvalue' size="30" maxlength="254" type="text" name="attributeValue"><BR><BR>
    	</TD>
    </TR> 
    <TR>
    	<TD COLSPAN=5>
	    &nbsp;&nbsp;&nbsp;
    	    <label for='attrImage'><%=UIUtil.toHTML((String)attributeResource.get("attrImage"))%></label>
    	</TD>
    </TR>
    <TR>
        <TD COLSPAN=5>
	    &nbsp;&nbsp;&nbsp;
            <INPUT id='attrImage' size="58" maxlength="254" type="text" name="image"><BR><BR>
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


