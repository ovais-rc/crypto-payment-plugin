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
        
	CalculationCodeSBBean salestaxData = null;
        salestaxData = new CalculationCodeSBBean(storeId, itemRefNum, CatalogUtil.SALESTAX_USAGE_ID);      
        
        int size = salestaxData.getAllSize();
      
        String[] salestax_id = salestaxData.getAllCode_id();
        String[] salestax_name = salestaxData.getAllCode_name();

        int selectedSize = salestaxData.getSelectedSize();

	String[] selectedSalesTax_id = salestaxData.getSelectedCode_id();
	String[] selectedSalesTax_name = salestaxData.getSelectedCode_name();
	
        int availableSize = salestaxData.getAvailableSize();
	String[] availableSalesTax_id = salestaxData.getAvailableCode_id();
	String[] availableSalesTax_name = salestaxData.getAvailableCode_name();	
	
	int SBsize = 10;
	if (SBsize < size) 
	    SBsize = size;
%>
 
<head>

<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<TITLE><%=UIUtil.toHTML((String)itemResource.get("SalesTaxTitle"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
 
    
<style type='text/css'>
.selectWidth {width: 250px;}
</style>

<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>

<SCRIPT>
function SalesTaxData() {
    
    this.availableSize = null;
    this.selectedSize = null;
    this.defaultSize = null;
    this.default_salestax = new Object();
    this.available_salestax = new Object();
    this.selected_salestax = new Object();
     
}  

SalesTax.ID = "salestax";

function SalesTax() {

    this.data = new SalesTaxData();
    this.id = SalesTax.ID;
    this.formref = null;

}    
 
function SalesTaxInfo(id, name) {

    this.id = id;
    this.name = name;

}
 
 
function load() {

    <% if (size != 0) {%>
 
    	var len1 = this.formref.availablesalestax.length;
    	var len2 = this.formref.selectedsalestax.length;
    
        var m = this.formref.availablesalestax;
        var n = this.formref.selectedsalestax;
        
        newSTData = new SalesTaxData(); 
        
        newSTInfo1 = new Array();
        newSTInfo2 = new Array();
       
        for(i = 0; i < len1; i++) { 
	    
	    newSTInfo1[i] = new SalesTaxInfo(getSalesTaxId(m.options[i].value), m.options[i].value);
	    newSTData.available_salestax["st" + i] = newSTInfo1[i];
	      
	}
	
        for(j = 0; j < len2; j++) { 
	
	    newSTInfo2[j] = new SalesTaxInfo(getSalesTaxId(n.options[j].value), n.options[j].value);
	    newSTData.selected_salestax["st" + j] = newSTInfo2[j];
	}
	
	newSTData.availableSize = len1;
	newSTData.selectedSize = len2;
	newSTData.defaultSize = this.data.defaultSize;
        newSTData.default_salestax = this.data.default_salestax;
        this.data = newSTData;
         
    <%}%>  
}

function getSalesTaxId(name) {

   <% for (int i = 0; i < size; i++) { %>
       if (name == "<%=salestax_name[i]%>")
           return <%=salestax_id[i]%>;
   <%}%>

}

function display() {  
    
    var availablesize = this.data.availableSize;
    var selectedsize = this.data.selectedSize;
    var allsize = availablesize + selectedsize;
     
    if ( availablesize == 0 && selectedsize == allsize) {
        <% for (int i = 0; i < size; i++) {%>
            this.formref.selectedsalestax.options[<%=i%>] = new Option("<%=salestax_name[i]%>",
            							 "<%=salestax_name[i]%>",
            							 false,
            							 false);
            this.formref.selectedsalestax.options[<%=i%>].selected = false;
        <%}%>
        
    } else {
            
    	for (i = 0; i < availablesize; i++) {
            this.formref.availablesalestax.options[i] = new Option(this.data.available_salestax["st" + i].name,
        	  		  			         this.data.available_salestax["st" + i].name,
        							 false,
                                	                         false);
            this.formref.availablesalestax.options[i].selected = false;
    	}
    	 
    	for (i = 0; i < selectedsize; i++) { 
            this.formref.selectedsalestax.options[i] = new Option(this.data.selected_salestax["st" + i].name,
        						       this.data.selected_salestax["st" + i].name,
        						       false,
        						       false);
            this.formref.selectedsalestax.options[i].selected = false;
        }
    }
   
}

function getData() {

    return this.data;
    
}


SalesTax.prototype.load = load;
SalesTax.prototype.display = display;
SalesTax.prototype.getData = getData;

var st = null;

function savePanelData() {

   if (st != null) {
   
       st.formref = document.salestax;
       st.load();
       parent.put(SalesTax.ID, st.getData());
   
   }
}


function initForm() {

    st = parent.get(SalesTax.ID);
    
    if (st == null) {
 
        st = new SalesTax();
         
        stData = new SalesTaxData(); 
       
        stData.availableSize = <%=availableSize%>;
        stData.selectedSize = <%=selectedSize%>;
        stData.defaultSize = <%=selectedSize%>; 
         
        stInfo1 = new Array();
        stInfo2 = new Array();
       
	<% for(int i = 0; i < availableSize; i++) { %>
	
	    stInfo1[<%=i%>] = new SalesTaxInfo("<%=availableSalesTax_id[i]%>", "<%=availableSalesTax_name[i]%>");
	    stData.available_salestax["st<%=i%>"] = stInfo1[<%=i%>];
	
	<%}%>
	
        <% for(int i = 0; i < selectedSize; i++) { %>
	
	    stInfo2[<%=i%>] = new SalesTaxInfo("<%=selectedSalesTax_id[i]%>", "<%=selectedSalesTax_name[i]%>");
	    stData.selected_salestax["st<%=i%>"] = stInfo2[<%=i%>];
	    stData.default_salestax["st<%=i%>"] = stInfo2[<%=i%>];
	    
	<%}%>
	 	 
        st.data = stData;
        
    } else {
     
        st = new SalesTax();
        st.data = parent.get(SalesTax.ID);
        
    }
    st.formref = document.salestax;
    st.display();
    
    <% if (size != 0) { %>
    	initializeSloshBuckets(document.salestax.availablesalestax, document.salestax.addButton, document.salestax.selectedsalestax, document.salestax.removeButton);
    <%}%>
    
    parent.setContentFrameLoaded(true);
}    
 
function addToSelectedSalesTax(allst) {

    move(document.salestax.availablesalestax, document.salestax.selectedsalestax);
    updateSloshBuckets(document.salestax.availablesalestax, document.salestax.addButton, document.salestax.selectedsalestax, document.salestax.removeButton);        
}

function removeFromSelectedSalesTax() {      
   move(document.salestax.selectedsalestax, document.salestax.availablesalestax);
   updateSloshBuckets(document.salestax.selectedsalestax, document.salestax.removeButton, document.salestax.availablesalestax, document.salestax.addButton);
}


</SCRIPT>
 
</HEAD>

<BODY onload="initForm()" class="content">
  
  <H1><%=UIUtil.toHTML((String)itemResource.get("SalesTaxTitle"))%></H1>
  <FORM NAME='salestax'>
  <% if (size == 0) { %>
    <%=itemResource.get("nosalestax")%>
  <% } else {%>
    <TABLE BORDER='0'>     
    <TH colspan="3"></TH>   
      <TR>
        <TD><LABEL for="selectedSalesTaxesID"><%=UIUtil.toHTML((String)itemResource.get("selectedSalesTaxes"))%></LABEL></TD>
	<TD WIDTH='20'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
	<TD><LABEL for="availableSalesTaxesID"><%=UIUtil.toHTML((String)itemResource.get("availableSalesTaxes"))%></LABEL></TD>
      </TR>

	  <!-- all salestax -->
       <TR>
        <TD>
           <SELECT NAME='selectedsalestax' id="selectedSalesTaxesID" CLASS='selectWidth' MULTIPLE SIZE='<%=SBsize%>' onchange="updateSloshBuckets(this, document.salestax.removeButton, document.salestax.availablesalestax, document.salestax.addButton)">
           </SELECT>
	 </TD>
	<TD WIDTH='20' VALIGN='TOP'><BR>
	     <INPUT TYPE='button' NAME='addButton' VALUE='<%=UIUtil.toHTML((String)itemResource.get("buttonAdd"))%>' onClick="addToSelectedSalesTax('<%=UIUtil.toHTML((String)itemResource.get("allsalestaxes"))%>')"><BR>     
	    <INPUT TYPE='button' NAME='removeButton' VALUE='<%=UIUtil.toHTML((String)itemResource.get("buttonRemove"))%>' onClick="removeFromSelectedSalesTax()">
	</TD>
	<TD>
      	   <SELECT NAME='availablesalestax' id="availableSalesTaxesID" CLASS='selectWidth' MULTIPLE SIZE='<%=SBsize%>' onchange="updateSloshBuckets(this, document.salestax.addButton, document.salestax.selectedsalestax, document.salestax.removeButton)">
			     <!-- all available salestax groups for merchant -->
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


