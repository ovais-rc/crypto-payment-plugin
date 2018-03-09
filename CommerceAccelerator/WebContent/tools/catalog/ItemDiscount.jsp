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
     Hashtable itemResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ItemNLS", jLocale);
%>
 
<%
    try {
        String languageId = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);
        String storeId = request.getParameter(com.ibm.commerce.server.ECConstants.EC_STORE_ID); 
	String itemRefNum = request.getParameter(ECConstants.EC_ITEM_NUMBER); 
 
	CalculationCodeSBBean discountData = null;
        discountData = new CalculationCodeSBBean(storeId, itemRefNum, CatalogUtil.DISCOUNT_USAGE_ID);

	int size = discountData.getAllSize();
      
        String[] discount_id = discountData.getAllCode_id();
        String[] discount_name = discountData.getAllCode_name();

        int selectedSize = discountData.getSelectedSize();

	String[] selectedDiscount_id = discountData.getSelectedCode_id();
	String[] selectedDiscount_name = discountData.getSelectedCode_name();
	
        int availableSize = discountData.getAvailableSize();
	String[] availableDiscount_id = discountData.getAvailableCode_id();
	String[] availableDiscount_name = discountData.getAvailableCode_name();	
	
	int SBsize = 10;
	if (SBsize < size) 
	    SBsize = size;
	
%>
 



<head>

<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)itemResource.get("Discounts"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">
 
    
<style type='text/css'>
.selectWidth {width: 250px;}
</style>

<script LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/SwapList.js"></script>

<SCRIPT>
function DiscountData() {
    
    this.availableSize = null;
    this.selectedSize = null;
    this.defaultSize = null;
    this.default_discount = new Object();
    this.available_discount = new Object();
    this.selected_discount = new Object();
      
}  

Discount.ID = "discount";

function Discount() {

    this.data = new DiscountData();
    this.id = Discount.ID;
    this.formref = null;

}    
 
function DiscountInfo(id, name) {

    this.id = id;
    this.name = name;

}
 
 
function load() {
 
    <% if (size != 0) { %>
        var len1 = this.formref.availablediscount.length;
    	var len2 = this.formref.selecteddiscount.length;
     
        var m = this.formref.availablediscount;
        var n = this.formref.selecteddiscount;
        
        newDisctData = new DiscountData(); 
        
        newDisctInfo1 = new Array();
        newDisctInfo2 = new Array();
       
	for(i = 0; i < len1; i++) { 
	    
	     newDisctInfo1[i] = new DiscountInfo(getDiscountId(m.options[i].value), m.options[i].value);
	     newDisctData.available_discount["disct" + i] = newDisctInfo1[i];
	    
	}
	
        for(j = 0; j < len2; j++) { 
	
	    newDisctInfo2[j] = new DiscountInfo(getDiscountId(n.options[j].value), n.options[j].value);
	    newDisctData.selected_discount["disct" + j] = newDisctInfo2[j];
	}
	
	newDisctData.availableSize = len1;
	newDisctData.selectedSize = len2;
	newDisctData.defaultSize = this.data.defaultSize;
        newDisctData.default_discount = this.data.default_discount;
        this.data = newDisctData;
         
    <%}%>  
}

function getDiscountId(name) {

   <% for (int i = 0; i < size; i++) { %>
       if (name == "<%=discount_name[i]%>")
           return <%=discount_id[i]%>;
   <%}%>

}

function display() {  
    
    var availablesize = this.data.availableSize;
    var selectedsize = this.data.selectedSize;
    var allsize = availablesize + selectedsize;
     
    if ( availablesize == 0 && selectedsize == allsize) {
        <% for (int i = 0; i < size; i++) {%>
            this.formref.selecteddiscount.options[<%=i%>] = new Option("<%=discount_name[i]%>",
            							 "<%=discount_name[i]%>",
            							 false,
            							 false);
            this.formref.selecteddiscount.options[<%=i%>].selected = false;
        <%}%>
        
    } else {
            
    	for (i = 0; i < availablesize; i++) {
            this.formref.availablediscount.options[i] = new Option(this.data.available_discount["disct" + i].name,
        	  		  			         this.data.available_discount["disct" + i].name,
        							 false,
                                	                         false);
            this.formref.availablediscount.options[i].selected = false;
    	}
	 
    	for (i = 0; i < selectedsize; i++) { 
            this.formref.selecteddiscount.options[i] = new Option(this.data.selected_discount["disct" + i].name,
        						       this.data.selected_discount["disct" + i].name,
        						       false,
        						       false);
            this.formref.selecteddiscount.options[i].selected = false;
        }
    }
   
}

function getData() {

    return this.data;
    
}


Discount.prototype.load = load;
Discount.prototype.display = display;
Discount.prototype.getData = getData;

var disct = null;

function savePanelData() {

   if (disct != null) {
   
       disct.formref = document.discount;
       disct.load();
       parent.put(Discount.ID, disct.getData());
   }
   
}


function initForm() {

    disct = parent.get(Discount.ID);
    
    if (disct == null) {
 
        disct = new Discount();
         
        disctData = new DiscountData(); 
       
        disctData.availableSize = <%=availableSize%>;
        disctData.selectedSize = <%=selectedSize%>;
        disctData.defaultSize = <%=selectedSize%>;
         
        disctInfo1 = new Array();
        disctInfo2 = new Array();
       
	<% for(int i = 0; i < availableSize; i++) { %>
	
	    disctInfo1[<%=i%>] = new DiscountInfo("<%=availableDiscount_id[i]%>", "<%=availableDiscount_name[i]%>");
	    disctData.available_discount["disct<%=i%>"] = disctInfo1[<%=i%>];
	    
	<%}%>
	
        <% for(int i = 0; i < selectedSize; i++) { %>
	
	    disctInfo2[<%=i%>] = new DiscountInfo("<%=selectedDiscount_id[i]%>", "<%=selectedDiscount_name[i]%>");
	    disctData.selected_discount["disct<%=i%>"] = disctInfo2[<%=i%>];
	    disctData.default_discount["disct<%=i%>"] = disctInfo2[<%=i%>];
	    
	<%}%>
	 	 
        disct.data = disctData;
       
    } else {
     
        disct = new Discount();
        disct.data = parent.get(Discount.ID);
        
    }
    
    disct.formref = document.discount;
    disct.display();
    
    <% if (size != 0) { %>
        initializeSloshBuckets(document.discount.availablediscount, document.discount.addButton, document.discount.selecteddiscount, document.discount.removeButton);
    <%}%>
    parent.setContentFrameLoaded(true);
}    
 
function addToAppliedDiscount(alldisct) {

    move(document.discount.availablediscount, document.discount.selecteddiscount);
    updateSloshBuckets(document.discount.availablediscount, document.discount.addButton, document.discount.selecteddiscount, document.discount.removeButton);        
}

function removeFromAppliedDiscount() {      
   move(document.discount.selecteddiscount, document.discount.availablediscount);
   updateSloshBuckets(document.discount.selecteddiscount, document.discount.removeButton, document.discount.availablediscount, document.discount.addButton);
}


</SCRIPT>
 
</HEAD>

<BODY onload="initForm()" class="content">
  
  <H1><%=UIUtil.toHTML((String)itemResource.get("Discounts"))%></H1>
  <FORM NAME='discount'>
  <% if (size == 0) { %>
    <%=itemResource.get("nodiscount")%>
  <% } else {%>
    <TABLE BORDER='0'>     
    <TH colspan="6"></TH>   
      <TR>
        <TD><LABEL for="selectedDiscountsID"><%=UIUtil.toHTML((String)itemResource.get("selectedDiscounts"))%></LABEL></TD>
	<TD WIDTH='20'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
	<TD><LABEL for="availableDiscountsID"><%=UIUtil.toHTML((String)itemResource.get("availableDiscounts"))%></LABEL></TD>
      </TR>

	  <!-- all discount -->
       <TR>
        <TD>
           <SELECT NAME='selecteddiscount' id="selectedDiscountsID" CLASS='selectWidth' MULTIPLE SIZE='<%=SBsize%>' onchange="updateSloshBuckets(this, document.discount.removeButton, document.discount.availablediscount, document.discount.addButton)">
      	   </SELECT>
	</TD>
	<TD WIDTH='20' VALIGN='TOP'><BR><BR>
	     <INPUT TYPE='button' NAME='addButton' VALUE='<%=UIUtil.toHTML((String)itemResource.get("buttonAdd"))%>' onClick="addToAppliedDiscount('<%=UIUtil.toHTML((String)itemResource.get("alldiscounts"))%>')"><BR>     
	    <INPUT TYPE='button' NAME='removeButton' VALUE='<%=UIUtil.toHTML((String)itemResource.get("buttonRemove"))%>' onClick="removeFromAppliedDiscount()">
	</TD>
	<TD>
      	   <SELECT NAME='availablediscount' id="availableDiscountsID" CLASS='selectWidth' MULTIPLE SIZE='<%=SBsize%>' onchange="updateSloshBuckets(this, document.discount.addButton, document.discount.selecteddiscount, document.discount.removeButton)">
			     <!-- all available discount groups for merchant -->
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


