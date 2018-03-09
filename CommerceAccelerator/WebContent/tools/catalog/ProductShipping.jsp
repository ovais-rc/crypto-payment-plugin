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
<%@page import="com.ibm.commerce.command.CommandContext" %>

<%@include file="../common/common.jsp" %>    
<%
     CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
     Locale jLocale = cmdContext.getLocale();
     // obtain the resource bundle for display
     Hashtable productResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ProductNLS", jLocale);
%>
 
<%
    try {
        String languageId = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);
        String storeId = request.getParameter(com.ibm.commerce.server.ECConstants.EC_STORE_ID); 
   	String product_id = request.getParameter(ECConstants.EC_PRODUCT_NUMBER); 
        
        CalculationCodeSBBean shippingData = new CalculationCodeSBBean(storeId, product_id, CatalogUtil.SHIPPING_USAGE_ID);
        int size = shippingData.getAllSize();
      
        String[] shipping_id = shippingData.getAllCode_id();
        String[] shipping_name = shippingData.getAllCode_name();

        int selectedSize = shippingData.getSelectedSize();

	String[] selectedShipping_id = shippingData.getSelectedCode_id();
	String[] selectedShipping_name = shippingData.getSelectedCode_name();
	
        int availableSize = shippingData.getAvailableSize();
	String[] availableShipping_id = shippingData.getAvailableCode_id();
	String[] availableShipping_name = shippingData.getAvailableCode_name();	
	
	int SBsize = 10;
	if (SBsize < size) 
	    SBsize = size;
	
%>
 
<head>

<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<TITLE><%=UIUtil.toHTML((String)productResource.get("ShippingTitle"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
 
    
<style type='text/css'>
.selectWidth {width: 250px;}
</style>

<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>

<SCRIPT>
function ShippingData() {
    
    this.availableSize = null;
    this.selectedSize = null;
    this.defaultSize = null;
    this.default_shipping = new Object();
    this.available_shipping = new Object();
    this.selected_shipping = new Object();
     
}  

Shipping.ID = "shipping";

function Shipping() {

    this.data = new ShippingData();
    this.id = Shipping.ID;
    this.formref = null;

}    
 
function ShippingInfo(id, name) {

    this.id = id;
    this.name = name;

}
 
 
function load() {
    
    <% if (size != 0) { %>
    	var len1 = this.formref.availableshipping.length;
    	var len2 = this.formref.selectedshipping.length;
    
        var m = this.formref.availableshipping;
        var n = this.formref.selectedshipping;
       
        newSTData = new ShippingData(); 
        
        newSTInfo1 = new Array();
        newSTInfo2 = new Array();
       
        for(i = 0; i < len1; i++) { 
	    
	    newSTInfo1[i] = new ShippingInfo(getShippingId(m.options[i].value), m.options[i].value);
	    newSTData.available_shipping["st" + i] = newSTInfo1[i];
	     
	}
	
        for(j = 0; j < len2; j++) { 
	
	    newSTInfo2[j] = new ShippingInfo(getShippingId(n.options[j].value), n.options[j].value);
	    newSTData.selected_shipping["st" + j] = newSTInfo2[j];
	}
	
	newSTData.availableSize = len1;
	newSTData.selectedSize = len2;
	newSTData.defaultSize = this.data.defaultSize;
        newSTData.default_shipping = this.data.default_shipping;
        this.data = newSTData;
         
    <%}%>
}

function getShippingId(name) {

   <% for (int i = 0; i < size; i++) { %>
       if (name == "<%=shipping_name[i]%>")
           return <%=shipping_id[i]%>;
   <%}%>

}

function display() {  
    
    var availablesize = this.data.availableSize;
    var selectedsize = this.data.selectedSize;
    var allsize = availablesize + selectedsize;
     
    if ( availablesize == 0 && selectedsize == allsize) {
        <% for (int i = 0; i < size; i++) {%>
            this.formref.selectedshipping.options[<%=i%>] = new Option("<%=shipping_name[i]%>",
            							 "<%=shipping_name[i]%>",
            							 false,
            							 false);
            this.formref.selectedshipping.options[<%=i%>].selected = false;
        <%}%>
         
    } else {
            
    	for (i = 0; i < availablesize; i++) {
            this.formref.availableshipping.options[i] = new Option(this.data.available_shipping["st" + i].name,
        	  		  			         this.data.available_shipping["st" + i].name,
        							 false,
                                	                         false);
            this.formref.availableshipping.options[i].selected = false;
    	}
    	 
    	for (i = 0; i < selectedsize; i++) { 
            this.formref.selectedshipping.options[i] = new Option(this.data.selected_shipping["st" + i].name,
        						       this.data.selected_shipping["st" + i].name,
        						       false,
        						       false);
            this.formref.selectedshipping.options[i].selected = false;
        }
    }
   
}

function getData() {

    return this.data;
    
}


Shipping.prototype.load = load;
Shipping.prototype.display = display;
Shipping.prototype.getData = getData;

var st = null;

function savePanelData() {

   if (st != null) {
   
       st.formref = document.shipping;
       st.load();
       parent.put(Shipping.ID, st.getData());
   
   }
}


function initForm() {

    st = parent.get(Shipping.ID);
    
    if (st == null) {
 
        st = new Shipping();
         
        stData = new ShippingData(); 
       
        stData.availableSize = <%=availableSize%>;
        stData.selectedSize = <%=selectedSize%>;
        stData.defaultSize = <%=selectedSize%>; 
         
        stInfo1 = new Array();
        stInfo2 = new Array();
                 
	<% for(int i = 0; i < availableSize; i++) { %>
	
	    stInfo1[<%=i%>] = new ShippingInfo("<%=availableShipping_id[i]%>", "<%=availableShipping_name[i]%>");
	    stData.available_shipping["st<%=i%>"] = stInfo1[<%=i%>];
	    
	<%}%>
	
        <% for(int i = 0; i < selectedSize; i++) { %>
	
	    stInfo2[<%=i%>] = new ShippingInfo("<%=selectedShipping_id[i]%>", "<%=selectedShipping_name[i]%>");
	    stData.selected_shipping["st<%=i%>"] = stInfo2[<%=i%>];
	    stData.default_shipping["st<%=i%>"] = stInfo2[<%=i%>];
	<%}%>
	 	 
        st.data = stData;
        
    } else {
     
        st = new Shipping();
        st.data = parent.get(Shipping.ID);
        
    }
    st.formref = document.shipping;
    st.display();
    
    <% if (size != 0) {%>
        initializeSloshBuckets(document.shipping.availableshipping, document.shipping.addButton, document.shipping.selectedshipping, document.shipping.removeButton);
    <%}%>
    
    parent.setContentFrameLoaded(true);
}    
 
function addToSelectedShipping(allst) {

    move(document.shipping.availableshipping, document.shipping.selectedshipping);
    updateSloshBuckets(document.shipping.availableshipping, document.shipping.addButton, document.shipping.selectedshipping, document.shipping.removeButton);        
}

function removeFromSelectedShipping() {      
   move(document.shipping.selectedshipping, document.shipping.availableshipping);
   updateSloshBuckets(document.shipping.selectedshipping, document.shipping.removeButton, document.shipping.availableshipping, document.shipping.addButton);
}





</SCRIPT>
 
</HEAD>

<BODY onload="initForm()" class="content">
  
  <H1><%=UIUtil.toHTML((String)productResource.get("ShippingTitle"))%></H1>
  <FORM NAME='shipping'>
  <% if (size == 0) { %>
    <%=productResource.get("noshipping")%>
  <% } else {%>
    <TABLE BORDER='0'>     
    <TH colspan="3"></TH>   
      <TR>
        <TD><label for='selectedshipping'><%=UIUtil.toHTML((String)productResource.get("selectedShipping"))%></label></TD>
	<TD WIDTH='20'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
	<TD><label for='availableShipping'><%=UIUtil.toHTML((String)productResource.get("availableShipping"))%></label></TD>
      </TR>

	  <!-- all shipping -->
       <TR>
        <TD>
           <SELECT id='selectedshipping' NAME='selectedshipping' CLASS='selectWidth' MULTIPLE SIZE='<%=SBsize%>' onchange="updateSloshBuckets(this, document.shipping.removeButton, document.shipping.availableshipping, document.shipping.addButton)">
      	   </SELECT>
	</TD>
	<TD WIDTH='20' VALIGN='TOP'><BR>
	     <INPUT TYPE='button' NAME='addButton' VALUE='<%=UIUtil.toHTML((String)productResource.get("buttonAdd"))%>' onClick="addToSelectedShipping('<%=UIUtil.toHTML((String)productResource.get("allshipping"))%>')"><BR>     
	    <INPUT TYPE='button' NAME='removeButton' VALUE='<%=UIUtil.toHTML((String)productResource.get("buttonRemove"))%>' onClick="removeFromSelectedShipping()">
	</TD>
	<TD>
      	   <SELECT id='availableShipping' NAME='availableshipping' CLASS='selectWidth' MULTIPLE SIZE='<%=SBsize%>' onchange="updateSloshBuckets(this, document.shipping.addButton, document.shipping.selectedshipping, document.shipping.removeButton)">
			     <!-- all available shipping groups for merchant -->
	   </SELECT>
	</TD>
       </TR>

   </TABLE> 
   <% }%>
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


