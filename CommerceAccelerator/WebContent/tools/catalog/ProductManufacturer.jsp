<%
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
//*-------------------------------------------------------------------
//*
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryAccessBean" %>

<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  Hashtable productResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ProductNLS", jLocale);
%>

<% 
   try {
    
    String product_id = request.getParameter(ECConstants.EC_PRODUCT_NUMBER);
    String languageId = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);

    String manPartNumber = null;
    String manName = null;

    CatalogEntryAccessBean mftProduct = new CatalogEntryAccessBean();
    if(product_id != null){
    	mftProduct.setInitKey_catalogEntryReferenceNumber(product_id) ;
	//DataBeanManager.activate(mftProduct, request);

	manPartNumber = mftProduct.getManufacturerPartNumber();
	manName = mftProduct.getManufacturerName();
    }

    manPartNumber = ((manPartNumber != null) ? UIUtil.toJavaScript(manPartNumber) : "");
    manName = ((manName != null ) ? UIUtil.toJavaScript(manName) : "");

     
%>





<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)productResource.get("manufacturer"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT>

function ManufacturerData(mftnum, mftname) {

    this.mftnum = mftnum;
    this.mftname = mftname;
       
}  

Manufacturer.ID = "manufacturer";

function Manufacturer(mftnum, mftname) {

    this.data = new ManufacturerData(mftnum, mftname);
    this.id = Manufacturer.ID;
    this.formref = null;

}    

function load() {
     
    this.data.mftnum = parent.cutspace(this.formref.mftnum.value);
    this.data.mftname = parent.cutspace(this.formref.mftname.value);
 
}

function display() {

    this.formref.mftnum.value = this.data.mftnum;
    this.formref.mftname.value = this.data.mftname;
       
}

function getData() {

    return this.data;
    
}

Manufacturer.prototype.load = load;
Manufacturer.prototype.display = display;
Manufacturer.prototype.getData = getData;

var mft = null;

function savePanelData()
{

   if (mft != null) {
       mft.formref = document.manufacturer;
       mft.load();
       parent.put(Manufacturer.ID, mft.getData());
   }
 
}

function initForm() {

    mft = parent.get(Manufacturer.ID);
    
    if (mft == null) {
        
        mft = new Manufacturer("<%=manPartNumber%>", "<%=manName%>");
        
    } else {
        
        mft = new Manufacturer();
        mft.data = parent.get(Manufacturer.ID);
        
    }
    mft.formref = document.manufacturer;
    mft.display();

    if (parent.get("fieldSizeExceeded_mftnum", false))
       {
        parent.remove("fieldSizeExceeded_mftnum");
	document.manufacturer.mftnum.select();
        alertDialog("<%= UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");
               
       }

    if (parent.get("fieldSizeExceeded_mftname", false))
       {
        parent.remove("fieldSizeExceeded_mftname");
	document.manufacturer.mftname.select();
        alertDialog("<%= UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");
               
       }

    parent.setContentFrameLoaded(true);
}    


function validatePanelData(){

    var objMftnum = document.manufacturer.mftnum.value;
    var objMftname = document.manufacturer.mftname.value;

    if ( !isValidUTF8length(objMftnum, 64)  ){
	document.manufacturer.mftnum.select();
	alertDialog("<%=UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");     	 
   	return false;
    }

    if ( !isValidUTF8length(objMftname, 64)  ){
	document.manufacturer.mftname.select();
	alertDialog("<%=UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");     	 
   	return false;
    }

    return true;
}


</SCRIPT>
</HEAD>
 
<BODY class="content" onload="initForm()">

<H1><%=UIUtil.toHTML((String)productResource.get("manufacturerinfo"))%></H1>
 
<FORM name="manufacturer">

<TABLE width=500>   
    <TH></TH>   
     <TR>
    	<TD>
    	    <LABEL for="manufacturerPartNumberID"><%=UIUtil.toHTML((String)productResource.get("manufacturerPartNumber"))%></LABEL>
    	</TD>
    </TR>
    <TR>
        <TD>
            <INPUT id="manufacturerPartNumberID" size="32" maxlength="64" type="text" name="mftnum"><BR><BR>
        </TD>
    </TR>
    <TR>
    	<TD>
    	    <LABEL for="manufacturerNameID"><%=UIUtil.toHTML((String)productResource.get("manufacturerName"))%></LABEL>
    	</TD>
    </TR>
    <TR>
        <TD>
            <INPUT id="manufacturerNameID" size="32" maxlength="64" type="text" name="mftname"><BR>
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


