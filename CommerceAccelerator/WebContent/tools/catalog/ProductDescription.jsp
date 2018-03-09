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
                com.ibm.commerce.tools.util.*,
                com.ibm.commerce.tools.catalog.util.*"
%>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  Hashtable productResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ProductNLS", jLocale);
%>


<% 
   try {
   
   // get parameters from URL
    String product_id = request.getParameter(ECConstants.EC_PRODUCT_NUMBER);
    String lang_id = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);

    // activate the catEntDesc
    CatalogEntryDescriptionDataBean catEntDesc = new CatalogEntryDescriptionDataBean();

    String shortDesc = null;
    String longDesc1 = null;
    String longDesc2 = null;
    String longDesc3 = null;

    if(product_id != null){
 	catEntDesc.setInitKey_catalogEntryReferenceNumber(product_id);
    	catEntDesc.setInitKey_language_id(lang_id);
	DataBeanManager.activate(catEntDesc, request); 

    	shortDesc = catEntDesc.getShortDescription();
    	longDesc1 = catEntDesc.getLongDescription();
    	longDesc2 = catEntDesc.getAuxDescription1();
    	longDesc3 = catEntDesc.getAuxDescription2();
    }

    shortDesc = (shortDesc != null ? UIUtil.toJavaScript(shortDesc) : "");
    longDesc1 = (longDesc1 != null ? UIUtil.toJavaScript(longDesc1) : "");
    longDesc2 = (longDesc2 != null ? UIUtil.toJavaScript(longDesc2) : "");    	    
    longDesc3 = (longDesc3 != null ? UIUtil.toJavaScript(longDesc3) : "");     

%>

<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)productResource.get("Description"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

function DescriptionData(shortDesc, longDesc, auxDesc1, auxDesc2) 
{
    this.shortDesc = shortDesc;
    this.longDesc = longDesc;
    this.auxDesc1 = auxDesc1;
    this.auxDesc2 = auxDesc2;
}    
 


Description.ID = "description";

function Description(shortDesc, longDesc1, auxDesc1, auxDesc2) 
{
    this.data = new DescriptionData(shortDesc, longDesc1, auxDesc1, auxDesc2);
    this.id = Description.ID;
    this.formref = null;

}    

  

function load()
{
  
    this.data.shortDesc = parent.cutspace(this.formref.shortDesc.value);
    var re = /(\r\n)/gi;
    this.data.longDesc = parent.cutspace((this.formref.longDesc.value).replace(re, " "));
    this.data.auxDesc1 = parent.cutspace((this.formref.auxDesc1.value).replace(re, " "));
    this.data.auxDesc2 = parent.cutspace((this.formref.auxDesc2.value).replace(re, " "));
     
}


function display() 
{
    this.formref.shortDesc.value = this.data.shortDesc;
    this.formref.longDesc.value = this.data.longDesc;
    this.formref.auxDesc1.value = this.data.auxDesc1;
    this.formref.auxDesc2.value = this.data.auxDesc2;
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
       desc.formref = document.description;
       desc.load();
       parent.put(Description.ID, desc.getData());
   }
    
}

function initForm() {

    var dataObject = parent.get(Description.ID);
  
    if (dataObject == null) {
        


        desc = new Description("<%=shortDesc%>",
        		    "<%=longDesc1%>",
          		    "<%=longDesc2%>",
			    "<%=longDesc3%>");
			    
        desc.formref = document.description;
      
        desc.display();
        
    } 
    
    
    else 
    {

     
        desc = new Description();
        desc.data = dataObject;
        desc.formref = document.description;
        desc.display();
    
    }



    if (parent.get("fieldSizeExceeded_shortDesc", false))
       {
        parent.remove("fieldSizeExceeded_shortDesc");
	document.description.shortDesc.select();
        alertDialog("<%= UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");
               
       }

	// commented out due to defect 67374
	//	if (parent.get("fieldSizeExceeded_longDesc", false))
	//	{
	//		parent.remove("fieldSizeExceeded_longDesc");
	//		document.description.longDesc.select();
	//		alertDialog("<%//=UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");
	//	}

    if (parent.get("fieldSizeExceeded_auxDesc1", false))
       {
        parent.remove("fieldSizeExceeded_auxDesc1");
	document.description.auxDesc1.select();
        alertDialog("<%= UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");
               
       }

    if (parent.get("fieldSizeExceeded_auxDesc2", false))
       {
        parent.remove("fieldSizeExceeded_auxDesc2");
	document.description.auxDesc2.select();
        alertDialog("<%= UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");
               
       }

    parent.setContentFrameLoaded(true);
}    




function validatePanelData(){

    var objShortDesc = document.description.shortDesc.value;
    var objLongDesc = document.description.longDesc.value;
    var objAuxDesc1 = document.description.auxDesc1.value;
    var objAuxDesc2 = document.description.auxDesc2.value;


    if ( !isValidUTF8length(objShortDesc, 254)  ){
	document.description.shortDesc.select();
	alertDialog("<%=UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");     	 
   	return false;
    }

	// commented out due to defect 67374
    //	if ( !isValidUTF8length(objLongDesc, 32700)  ){
	//		document.description.longDesc.select();
	//		alertDialog("<%//=UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");     	 
	//		return false;
	//	}

    if ( !isValidUTF8length(objAuxDesc1, 4000)  ){
	document.description.auxDesc1.select();
	alertDialog("<%=UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");     	 
   	return false;
    }

    if ( !isValidUTF8length(objAuxDesc2, 4000)  ){
	document.description.auxDesc2.select();
	alertDialog("<%=UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");     	 
   	return false;
    }

    return true;
}


</SCRIPT>
</HEAD>

    
<BODY class="content" onload="initForm()">
<H1><%=UIUtil.toHTML((String)productResource.get("Description"))%></H1> 
<FORM name="description">
<TABLE>
    <TH colspan="5"></TH>   
    <TR>
    	<TD COLSPAN="5">
    	    <LABEL for="shortDescID"><%=UIUtil.toHTML((String)productResource.get("shortDesc"))%></LABEL>
    	</TD>
    </TR>
    <TR>
    	<TD COLSPAN="5">
    	    <INPUT size="58" id="shortDescID" maxlength="254" type="text" name="shortDesc"><BR><BR>
    	</TD>
    </TR> 
    <TR>
    	<TD COLSPAN=5>
    	    <LABEL for="longDescID"><%=UIUtil.toHTML((String)productResource.get("longDesc"))%></LABEL>
    	</TD>
    </TR>
    <TR>
        <TD COLSPAN=5>
            <TEXTAREA name="longDesc"  id="longDescID" value='' rows="3" cols="50" WRAP="HARD"></TEXTAREA><BR><BR>
        </TD>
    </TR>
    <TR>
    	<TD COLSPAN=5>
    	    <LABEL for="auxDesc1ID"><%=UIUtil.toHTML((String)productResource.get("auxDesc1"))%></LABEL>
    	</TD>
    </TR>
    <TR>
        <TD COLSPAN=5>
            <TEXTAREA name="auxDesc1" id="auxDesc1ID" value='' rows="3" cols="50" WRAP="HARD"></TEXTAREA><BR><BR>
        </TD>
    </TR>

    <TR>
    	<TD COLSPAN=5>
    	    <LABEL for="auxDesc2ID"><%=UIUtil.toHTML((String)productResource.get("auxDesc2"))%></LABEL>
    	</TD>
    </TR>
    <TR>
        <TD COLSPAN=5>
            <TEXTAREA name="auxDesc2" id="auxDesc2ID" value='' rows="3" cols="50" WRAP="HARD"></TEXTAREA><BR><BR>
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


