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
<?xml version="1.0"?>
<html>
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.beans.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.catalog.beans.*" %>
<%@page import="com.ibm.commerce.tools.catalog.util.*" %>
<%@page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>
   
<%
     CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
     Locale jLocale = cmdContext.getLocale();
     
     // obtain the resource bundle for display
     Hashtable itemResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ItemNLS", jLocale);
%>
 
<%
    try {
        String languageId = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);
        String storeId = request.getParameter(com.ibm.commerce.server.ECConstants.EC_STORE_ID); 
	String itemRefNum = request.getParameter(ECConstants.EC_ITEM_NUMBER); 
        
        CalculationCodeSBBean shippingtaxData = null;
        shippingtaxData = new CalculationCodeSBBean(storeId, itemRefNum, CatalogUtil.SHIPPINGTAX_USAGE_ID);      

	int size = shippingtaxData.getAllSize();
      
        String[] shippingtax_id = shippingtaxData.getAllCode_id();
        String[] shippingtax_name = shippingtaxData.getAllCode_name();

        int selectedSize = shippingtaxData.getSelectedSize();

	String[] selectedShippingTax_id = shippingtaxData.getSelectedCode_id();
	String[] selectedShippingTax_name = shippingtaxData.getSelectedCode_name();
	
        int availableSize = shippingtaxData.getAvailableSize();
	String[] availableShippingTax_id = shippingtaxData.getAvailableCode_id();
	String[] availableShippingTax_name = shippingtaxData.getAvailableCode_name();	
	
	int SBsize = 10;
	if (SBsize < size) 
	    SBsize = size;
	
%>
 
<head>

<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<TITLE><%=UIUtil.toHTML((String)itemResource.get("ShippingTaxTitle"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
 
    
<style type='text/css'>
.selectWidth {width: 250px;}
</style>

<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>

<SCRIPT>
function ShippingTaxData() {
    
    this.availableSize = null;
    this.selectedSize = null;
    this.defaultSize = null;
    this.default_shippingtax = new Object();
    this.available_shippingtax = new Object();
    this.selected_shippingtax = new Object();
     
}  

ShippingTax.ID = "shippingtax";

function ShippingTax() {

    this.data = new ShippingTaxData();
    this.id = ShippingTax.ID;
    this.formref = null;

}    
 
function ShippingTaxInfo(id, name) {

    this.id = id;
    this.name = name;

}
 
 
function load() {
 
    <% if (size != 0) {%>
    	var len1 = this.formref.availableshippingtax.length;
    	var len2 = this.formref.selectedshippingtax.length;
    
    	var m = this.formref.availableshippingtax;
        var n = this.formref.selectedshippingtax;
         
        newSTData = new ShippingTaxData(); 
        
        newSTInfo1 = new Array();
        newSTInfo2 = new Array();
       
	for(i = 0; i < len1; i++) { 
	    
	    newSTInfo1[i] = new ShippingTaxInfo(getShippingTaxId(m.options[i].value), m.options[i].value);
	    newSTData.available_shippingtax["st" + i] = newSTInfo1[i];
	     
	}
	
        for(j = 0; j < len2; j++) { 
	
	    newSTInfo2[j] = new ShippingTaxInfo(getShippingTaxId(n.options[j].value), n.options[j].value);
	    newSTData.selected_shippingtax["st" + j] = newSTInfo2[j];
	}
	
	newSTData.availableSize = len1;
	newSTData.selectedSize = len2;
        newSTData.defaultSize = this.data.defaultSize;
        newSTData.default_shippingtax = this.data.default_shippingtax;
        this.data = newSTData;
         
    <%}%>  
}

function getShippingTaxId(name) {

   <% for (int i = 0; i < size; i++) { %>
       if (name == "<%=shippingtax_name[i]%>")
           return <%=shippingtax_id[i]%>;
   <%}%>

}

function display() {  
    
    var availablesize = this.data.availableSize;
    var selectedsize = this.data.selectedSize;
    var allsize = availablesize + selectedsize;
     
    if ( availablesize == 0 && selectedsize == allsize) {
        <% for (int i = 0; i < size; i++) {%>
            this.formref.selectedshippingtax.options[<%=i%>] = new Option("<%=shippingtax_name[i]%>",
            							 "<%=shippingtax_name[i]%>",
            							 false,
            							 false);
            this.formref.selectedshippingtax.options[<%=i%>].selected = false;
        <%}%>
         
    } else {
            
    	for (i = 0; i < availablesize; i++) {
            this.formref.availableshippingtax.options[i] = new Option(this.data.available_shippingtax["st" + i].name,
        	  		  			         this.data.available_shippingtax["st" + i].name,
        							 false,
                                	                         false);
            this.formref.availableshippingtax.options[i].selected = false;
    	}
    	
    	for (i = 0; i < selectedsize; i++) { 
            this.formref.selectedshippingtax.options[i] = new Option(this.data.selected_shippingtax["st" + i].name,
        						       this.data.selected_shippingtax["st" + i].name,
        						       false,
        						       false);
            this.formref.selectedshippingtax.options[i].selected = false;
        }
    }
   
}

function getData() {

    return this.data;
    
}


ShippingTax.prototype.load = load;
ShippingTax.prototype.display = display;
ShippingTax.prototype.getData = getData;

var st = null;

function savePanelData() {

   if (st != null) {
   
       st.formref = document.shippingtax;
       st.load();
       parent.put(ShippingTax.ID, st.getData());
   
   }
  
}


function initForm() {

    st = parent.get(ShippingTax.ID);
    
    if (st == null) {
 
        st = new ShippingTax();
         
        stData = new ShippingTaxData(); 
       
        stData.availableSize = <%=availableSize%>;
        stData.selectedSize = <%=selectedSize%>;
        stData.defaultSize = <%=selectedSize%>;
         
        stInfo1 = new Array();
        stInfo2 = new Array();
       
	<% for(int i = 0; i < availableSize; i++) { %>
	
	    stInfo1[<%=i%>] = new ShippingTaxInfo("<%=availableShippingTax_id[i]%>", "<%=availableShippingTax_name[i]%>");
	    stData.available_shippingtax["st<%=i%>"] = stInfo1[<%=i%>];
	
	<%}%>
	
        <% for(int i = 0; i < selectedSize; i++) { %>
	
	    stInfo2[<%=i%>] = new ShippingTaxInfo("<%=selectedShippingTax_id[i]%>", "<%=selectedShippingTax_name[i]%>");
	    stData.selected_shippingtax["st<%=i%>"] = stInfo2[<%=i%>];
	    stData.default_shippingtax["st<%=i%>"] = stInfo2[<%=i%>];
	<%}%>
	
	<% if (selectedSize == 0) {%>
	    stData.default_shippingtax = null;
	<%}%>
	  
        st.data = stData;
        
    } else {
     
        st = new ShippingTax();
        st.data = parent.get(ShippingTax.ID);
        
    }
    st.formref = document.shippingtax;
    st.display();
    
    <% if (size != 0) {%>
        initializeSloshBuckets(document.shippingtax.availableshippingtax, document.shippingtax.addButton, document.shippingtax.selectedshippingtax, document.shippingtax.removeButton);
    <%}%>
    
    parent.setContentFrameLoaded(true);
}    
 
function addToSelectedShippingTax(allst) {

    move(document.shippingtax.availableshippingtax, document.shippingtax.selectedshippingtax);
    updateSloshBuckets(document.shippingtax.availableshippingtax, document.shippingtax.addButton, document.shippingtax.selectedshippingtax, document.shippingtax.removeButton);        
}

function removeFromSelectedShippingTax() {      
   move(document.shippingtax.selectedshippingtax, document.shippingtax.availableshippingtax);
   updateSloshBuckets(document.shippingtax.selectedshippingtax, document.shippingtax.removeButton, document.shippingtax.availableshippingtax, document.shippingtax.addButton);
}





</SCRIPT>
 
</HEAD>

<BODY onload="initForm()" class="content">
  
  <H1><%=UIUtil.toHTML((String)itemResource.get("ShippingTaxTitle"))%></H1>
  <FORM NAME='shippingtax'>
  <% if (size == 0) { %>
    <%=itemResource.get("noshippingtax")%>
  <% } else {%>
    <TABLE BORDER='0'>     
    <TH colspan="3"></TH>   
      <TR>
        <TD><LABEL for="selectedShippingTaxesID"><%=UIUtil.toHTML((String)itemResource.get("selectedShippingTaxes"))%></LABEL></TD>
	<TD WIDTH='20'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
	<TD><LABEL for="availableShippingTaxesID"><%=UIUtil.toHTML((String)itemResource.get("availableShippingTaxes"))%></LABEL></TD>
      </TR>

	  <!-- all shippingtax -->
       <TR>
        <TD>
           <SELECT NAME='selectedshippingtax' id="selectedShippingTaxesID" CLASS='selectWidth' MULTIPLE SIZE='<%=SBsize%>' onchange="updateSloshBuckets(this, document.shippingtax.removeButton, document.shippingtax.availableshippingtax, document.shippingtax.addButton)">
      	   </SELECT>
	</TD>
	<TD WIDTH='20' VALIGN='TOP'><BR>
	     <INPUT TYPE='button' NAME='addButton' VALUE='<%=UIUtil.toHTML((String)itemResource.get("buttonAdd"))%>' onClick="addToSelectedShippingTax('<%=UIUtil.toHTML((String)itemResource.get("allshippingtaxes"))%>')"><BR>    
	    <INPUT TYPE='button' NAME='removeButton' VALUE='<%=UIUtil.toHTML((String)itemResource.get("buttonRemove"))%>' onClick="removeFromSelectedShippingTax()">
	</TD>
	<TD>
      	   <SELECT NAME='availableshippingtax' id="availableShippingTaxesID" CLASS='selectWidth' MULTIPLE SIZE='<%=SBsize%>' onchange="updateSloshBuckets(this, document.shippingtax.addButton, document.shippingtax.selectedshippingtax, document.shippingtax.removeButton)">
			     <!-- all available shippingtax groups for merchant -->
	   </SELECT>
	</TD>
       </TR>

   </TABLE> 
   <%}%>
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


