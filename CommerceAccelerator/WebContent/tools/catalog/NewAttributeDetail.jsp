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
                com.ibm.commerce.tools.catalog.beans.*,
                com.ibm.commerce.catalog.objects.*,
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
   
   // get parameters from URL
    String product_id = request.getParameter(ECConstants.EC_PRODUCT_NUMBER);
    String attr_id = request.getParameter(ECConstants.EC_ATTR_NUMBER);
    


   AttributeDataBean attrBean = new AttributeDataBean();
   String attributeName = null;
   String attributeDesc = null;   

   if(attr_id != null){
   	attrBean.setAttributeId(new Long(attr_id));
	DataBeanManager.activate(attrBean, request);

   	attributeName = attrBean.getAttributeName();
   	attributeDesc = attrBean.getAttributeDescription();

   }
   

   attributeName = (attributeName != null ? UIUtil.toJavaScript(attributeName) : "");
   attributeDesc = (attributeDesc != null ? UIUtil.toJavaScript(attributeDesc) : "");


   String attributeType = "STRING";
   
   // check if there are items for that product...If Yes, then prompt message that all skus will be deleted if we create a new attribute.
   
   Enumeration itemList = null;

   itemList = new ItemAccessBean().findByProduct(new Long(product_id));

   Vector itemRefNum = new Vector();
   int numberOfItems = 0;
	
   if(itemList != null){
   	
	while (itemList.hasMoreElements())
	{
		ItemAccessBean iab = (ItemAccessBean) itemList.nextElement();
		itemRefNum.addElement(iab.getCatalogEntryReferenceNumber());
		numberOfItems++;
		
		//If there are Sku, then exit the loop...
		if(numberOfItems > 0) break;

	}
	
   }
   
   
          

%>

<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)attributeResource.get("Description"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

function DescriptionData(attributeName, attributeDesc, attributeType) 
{
    this.attributeName = attributeName;
    this.attributeDesc = attributeDesc;
    this.attributeType = attributeType;
    
}    
 


Description.ID = "attributedetails";

function Description(attributeName, attributeDesc, attributeType) 
{
    this.data = new DescriptionData(attributeName, attributeDesc, attributeType);
    this.id = Description.ID;
    this.formref = null;

}    

  

function load()
{
  
    this.data.attributeName = parent.cutspace(this.formref.attributeName.value);
    var re = /(\r\n)/gi;
    this.data.attributeDesc = parent.cutspace((this.formref.attributeDesc.value).replace(re, " "));
    this.data.attributeType = getType();

   
     
}


function display() 
{
    this.formref.attributeName.value = this.data.attributeName;
    this.formref.attributeDesc.value = this.data.attributeDesc;
    
    
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
    
       desc.formref = document.attributedetails;
       desc.load();
       parent.put(Description.ID, desc.getData());

   }
    
}

function initForm() {

    var dataObject = parent.get(Description.ID);
  
    if (dataObject == null) {
        

        desc = new Description("<%=attributeName%>",
        		    "<%=attributeDesc%>", "<%=attributeType%>");
			    
        desc.formref = document.attributedetails;
      
        desc.display();
        
    } 
    else 
    {
     
        desc = new Description();
        desc.data = dataObject;
        desc.formref = document.attributedetails;
        desc.display();
    
    }
    parent.setContentFrameLoaded(true);
}    



function getType(){

    if(document.attributedetails.attrRadioType[0].checked == true){
	return "STRING";
    } else if(document.attributedetails.attrRadioType[1].checked == true){
	return "INTEGER";
    } else if(document.attributedetails.attrRadioType[2].checked == true){
	return "FLOAT";
    }

}


function validatePanelData(){

    var objAttributeName = document.attributedetails.attributeName.value;
    var objAttributeDesc = document.attributedetails.attributeDesc.value;

    if(document.attributedetails.attributeName.value == ""){
	document.attributedetails.attributeName.select();
	alertDialog("<%=UIUtil.toJavaScript((String)attributeResource.get("attributeNameRequiredMessage"))%>");
	return false;
    }

    if ( !isValidUTF8length(objAttributeName, 254)  ){
	document.attributedetails.attributeName.select();
	alertDialog("<%=UIUtil.toJavaScript((String)attributeResource.get("fieldSizeExceeded_attributeName"))%>");     	 
   	return false;
    }

    if ( !isValidUTF8length(objAttributeDesc, 254)  ){
	document.attributedetails.attributeDesc.select();
	alertDialog("<%=UIUtil.toJavaScript((String)attributeResource.get("fieldSizeExceeded_attributeDesc"))%>");
   	return false;
    }

    if(<%=numberOfItems%> > 0){

    	if(!confirmDialog("<%=UIUtil.toJavaScript((String)attributeResource.get("attributeCreateConfirm"))%>")){
    		return false;
    	}
    } 


    return true;
}


</SCRIPT>
</HEAD>

    
<BODY class="content" onload="initForm()">
<H1>&nbsp;&nbsp;&nbsp;&nbsp;<%=UIUtil.toHTML((String)attributeResource.get("attrgeneralinfo"))%></H1> 
<FORM name="attributedetails">
<TABLE>
    <TH colspan="5"></TH>   
    <TR>
    	<TD COLSPAN="5">
	    &nbsp;&nbsp;&nbsp;
    	    <label for='requiredAttrname'><%=UIUtil.toHTML((String)attributeResource.get("requiredAttrname"))%></label>
    	</TD>
    </TR>
    <TR>
    	<TD COLSPAN="5">
	    &nbsp;&nbsp;&nbsp;
    	    <INPUT id='requiredAttrname' size="58" maxlength="254" type="text" name="attributeName"><BR><BR>
    	</TD>
    </TR> 
    <TR>
    	<TD COLSPAN=5>
	    &nbsp;&nbsp;&nbsp;
    	    <label for='attrdesc'><%=UIUtil.toHTML((String)attributeResource.get("attrdesc"))%></label>
    	</TD>
    </TR>
    <TR>
        <TD COLSPAN=5>
	    &nbsp;&nbsp;&nbsp;
            <TEXTAREA id='attrdesc' name="attributeDesc" value='' rows="5" cols="50" WRAP="HARD"></TEXTAREA><BR><BR>
        </TD>
    </TR>




    <TR>
    	<TD COLSPAN=5>
	    &nbsp;&nbsp;&nbsp;
    	    <%=UIUtil.toHTML((String)attributeResource.get("attrType"))%>
    	</TD>
    </TR>
    <TR>
        <TD COLSPAN=5>
	    &nbsp;&nbsp;&nbsp;
            <INPUT TYPE="radio" NAME="attrRadioType" id="attrRadioTypeId1" VALUE= "STRING" CHECKED><label for="attrRadioTypeId1"><%=UIUtil.toHTML((String)attributeResource.get("string"))%></label><br>
	    &nbsp;&nbsp;&nbsp;
	    <INPUT TYPE="radio" NAME="attrRadioType" id="attrRadioTypeId2" VALUE= "INTEGER"><label for="attrRadioTypeId2"><%=UIUtil.toHTML((String)attributeResource.get("integer"))%></label><br>
	    &nbsp;&nbsp;&nbsp;
	    <INPUT TYPE="radio" NAME="attrRadioType" id="attrRadioTypeId3" VALUE= "FLOAT"><label for="attrRadioTypeId3"><%=UIUtil.toHTML((String)attributeResource.get("float"))%></label>
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


