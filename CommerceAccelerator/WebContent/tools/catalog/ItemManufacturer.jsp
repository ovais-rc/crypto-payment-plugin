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
		com.ibm.commerce.tools.util.*,
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
    
    String productRefNum = request.getParameter(ECConstants.EC_PRODUCT_NUMBER);
    String languageId = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);
    String itemRefNum = request.getParameter(ECConstants.EC_ITEM_NUMBER);

    ProductDataBean mftProduct = new ProductDataBean();
    ItemDataBean mftItem = new ItemDataBean();

    String manPartNumber = null;
    String manName = null;

    if(itemRefNum != null){
    	mftItem.setItemRefNum(itemRefNum);
	DataBeanManager.activate(mftItem, request);
	manPartNumber = mftItem.getMfPartNumber();
	manName = mftItem.getMfName();

    }else{

	if(productRefNum != null){
		mftProduct.setProductRefNum(productRefNum);
		DataBeanManager.activate(mftProduct, request);
		manName = mftProduct.getMfName();


	}
    }
	


    
    


    manPartNumber = (manPartNumber != null) ? UIUtil.toJavaScript(manPartNumber) : "";
    manName = (manName != null ) ? UIUtil.toJavaScript(manName) : "";

     
%>





<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)itemResource.get("manufacturer"))%></TITLE>
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
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>");
               
       }

    if (parent.get("fieldSizeExceeded_mftname", false))
       {
        parent.remove("fieldSizeExceeded_mftname");
	document.manufacturer.mftname.select();
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>");
               
       }
    
    
    parent.setContentFrameLoaded(true);
}    


function validatePanelData(){

    var objMftnum = document.manufacturer.mftnum.value;
    var objMftname = document.manufacturer.mftname.value;

    if ( !isValidUTF8length(objMftnum, 64)  ){
	document.manufacturer.mftnum.select();
	alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>");     	 
   	return false;
    }

    if ( !isValidUTF8length(objMftname, 64)  ){
	document.manufacturer.mftname.select();
	alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("fieldSizeExceeded"))%>");     	 
   	return false;
    }

    return true;
}

</SCRIPT>
</HEAD>
 
<BODY class="content" onload="initForm()">

<H1><%=UIUtil.toHTML((String)itemResource.get("manufacturerinfo"))%></H1>
 
<FORM name="manufacturer">

<TABLE width=500>   
    <TH></TH>   
     <TR>
    	<TD>
    	    <LABEL for="manufacturerPartNumberID"><%=UIUtil.toHTML((String)itemResource.get("manufacturerPartNumber"))%></LABEL>
    	</TD>
    </TR>
    <TR>
        <TD>
            <INPUT id="manufacturerPartNumberID" size="32" maxlength="64" type="text" name="mftnum"><BR><BR>
        </TD>
    </TR>
    <TR>
    	<TD>
    	    <LABEL for="manufacturerNameID"><%=UIUtil.toHTML((String)itemResource.get("manufacturerName"))%></LABEL>
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


