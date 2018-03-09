

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<HTML>
<HEAD>

<%@page import="java.util.*,
		com.ibm.commerce.beans.*,
                com.ibm.commerce.tools.catalog.beans.*,
                com.ibm.commerce.catalog.objects.*,
                com.ibm.commerce.tools.util.*,
                com.ibm.commerce.inventory.objects.*,
                com.ibm.commerce.common.objects.*,
                com.ibm.commerce.fulfillment.objects.*,
                com.ibm.commerce.tools.catalog.util.*"
%>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@include file="../common/common.jsp" %>

<%
  CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContext.getLocale();
  String jCurrency = cmdContext.getCurrency();
  Hashtable productResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ProductNLS", jLocale);
  Integer storeId = cmdContext.getStoreId();
%>

<% 
     
  try {

    
    
    
 
   String productRefNum = request.getParameter(com.ibm.commerce.tools.catalog.util.ECConstants.EC_PRODUCT_NUMBER); 
   String lang_id = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);
   lang_id = (lang_id != null ? UIUtil.toJavaScript(lang_id) : "");

   String strBaseItemId = null;
   String strTrackInventory = null;
   String strBackOrderable  = null;
   String strForceBackOrder = null;
   String strReleaseSeparately = null;
   String strReturnNotDesired = null;
   String strQuantityOfMeasure = null;
   String strQuantityMultiple = null;
   String strCreditable = null;
   


   if(productRefNum != null){
   
   	try{
   		CatalogEntryAccessBean ceAB = new CatalogEntryAccessBean();
   		ceAB.setInitKey_catalogEntryReferenceNumber( productRefNum );
   		strBaseItemId = ceAB.getBaseItemId ();
   		
   	}catch(javax.persistence.NoResultException e1){

   	}

	if( (strBaseItemId != null) &&(strBaseItemId.length()>0))
	{
	
		try{
   			StoreItemAccessBean siAB = new StoreItemAccessBean();
   			siAB.setInitKey_baseItemId( strBaseItemId );
   			siAB.setInitKey_storeentId( storeId.toString () );
  
   			strTrackInventory = siAB.getTrackInventory();
   			strBackOrderable  = siAB.getBackOrderable();
   			strForceBackOrder = siAB.getForceBackOrder();
   			strReleaseSeparately = siAB.getReleaseSeparately();
   			strReturnNotDesired = siAB.getReturnNotDesired();
   			strCreditable = siAB.getCreditable();
   			
   		}catch(javax.persistence.NoResultException e2){

   		}
   		
   		try{
   	  		BaseItemAccessBean biAB = new BaseItemAccessBean ();
   			biAB.setInitKey_baseItemId( strBaseItemId );
   			strQuantityOfMeasure = biAB.getQuantityMeasure();
   			strQuantityMultiple = biAB.getQuantityMultiple(); 
   			
   		}catch(javax.persistence.NoResultException e){
   		
   		}			
   	
   	}
   	
   }

   strTrackInventory = (strTrackInventory != null ? UIUtil.toJavaScript(strTrackInventory) : "Y");
   strBackOrderable = (strBackOrderable != null ? UIUtil.toJavaScript(strBackOrderable) : "Y");
   strForceBackOrder = (strForceBackOrder != null ? UIUtil.toJavaScript(strForceBackOrder) : "N");
   strReleaseSeparately = (strReleaseSeparately != null ? UIUtil.toJavaScript(strReleaseSeparately) : "N");	
   strReturnNotDesired = (strReturnNotDesired != null ? UIUtil.toJavaScript(strReturnNotDesired) : "N");
   strQuantityOfMeasure = (strQuantityOfMeasure != null ? UIUtil.toJavaScript(strQuantityOfMeasure) : "");
   strQuantityMultiple = (strQuantityMultiple != null ? UIUtil.toJavaScript(strQuantityMultiple) : "");
   strCreditable = (strCreditable != null ? UIUtil.toJavaScript(strCreditable) : "Y");
   
   
   
   
   Vector qtyDescriptions = new Vector ();
   Vector qtyIds   = new Vector ();
   QuantityUnitDescriptionAccessBean qudAB = new QuantityUnitDescriptionAccessBean ();
   Enumeration e = qudAB.findByLanguage ( new Integer ( lang_id ));
   while ( e.hasMoreElements() ) {
     qudAB = ( QuantityUnitDescriptionAccessBean ) e.nextElement ();
     String strQtyId = qudAB.getQuantityUnitId (); 
     String strQtyDesc   = qudAB.getDescription ();
     qtyDescriptions.addElement ( strQtyDesc );
     qtyIds.addElement ( strQtyId );
   }
   
   String qomId[] = null;
   String qomDesc[] = null;
 
   qomId = new String[qtyIds.size()];
   qtyIds.copyInto(qomId);
   
   qomDesc = new String[qtyDescriptions.size()];
   qtyDescriptions.copyInto(qomDesc);
   
   
   
%>


<META name="GENERATOR" content="IBM WebSphere Page Designer V3.0.2 for Windows">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE><%=UIUtil.toHTML((String)productResource.get("listPriceTitle"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<%@include file="../common/NumberFormat.jsp" %>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT> 
 
<SCRIPT>
 
function StoreItemData(){

   this.langid = "<%=lang_id%>";
   this.trackinventory = "<%=strTrackInventory%>"; 
   this.backorderable = "<%=strBackOrderable%>";
   this.forcebackorder = "<%=strForceBackOrder%>"; 
   this.releaseseparately = "<%=strReleaseSeparately%>";
   this.returnnotdesired = "<%=strReturnNotDesired%>";
   this.quantitymeasure = "<%=strQuantityOfMeasure%>";
   this.quantitymultiple = "<%=strQuantityMultiple%>";
   this.creditable = "<%=strCreditable%>";
}

StoreItem.ID = "storeitem";


function StoreItem () {

   this.data = new StoreItemData();
   this.id = StoreItem.ID;
   this.formref = null;

}



function load() {

   var quantitymultiple_load = parent.cutspace ( this.formref.quantitymultiple.value );
   
   if(quantitymultiple_load != null && quantitymultiple_load != ""){

   	this.data.quantitymultiple = strToNumber(quantitymultiple_load, "<%=lang_id%>");
   
   }else{
   
   	this.data.quantitymultiple = quantitymultiple_load;
   	
   }   

   this.data.quantitymeasure = parent.cutspace ( this.formref.quantitymeasure.value );
   

   if (this.formref.trackinventory.value == "Y") {
	   this.data.trackinventory = "Y";
   } else if (this.formref.trackinventory.value == "N"){
           this.data.trackinventory = "N";
   } else {
           this.data.trackinventory = "E"; 
   }

   if (this.formref.backorderable.checked == true) {
	   this.data.backorderable = "Y";
   } else {
           this.data.backorderable = "N";
   }

   if (this.formref.forcebackorder.checked == true) {
	   this.data.forcebackorder = "Y";
   } else {
           this.data.forcebackorder = "N";
   }

   if (this.formref.releaseseparately.checked == true) {
	   this.data.releaseseparately = "Y";
   } else {
           this.data.releaseseparately = "N";
   }

   if (this.formref.returnnotdesired.checked == true) {
	   this.data.returnnotdesired = "N";
   } else {
           this.data.returnnotdesired = "Y";
   }
   
   if (this.formref.creditable.checked == true) {
	   this.data.creditable = "Y";
   } else {
           this.data.creditable = "N";
   }

   
}

function display() {

    var _qtymultiple = this.data.quantitymultiple;

    if(_qtymultiple != null && _qtymultiple != ""){

    	this.formref.quantitymultiple.value =   displayValue(_qtymultiple, "AttributeFloatValueBean");
    	
    }else{
    
    	this.formref.quantitymultiple.value = _qtymultiple;
    }    

    
    this.formref.quantitymeasure.value =   this.data.quantitymeasure;

    

    if (this.data.trackinventory == "Y") {
        this.formref.trackinventory.options[0].selected = true;
    } else if (this.data.trackinventory == "N") {
        this.formref.trackinventory.options[1].selected = true;
    } else {
		this.formref.trackinventory.options[2].selected = true;
	}

    if (this.data.backorderable == "Y") {
        this.formref.backorderable.checked = true;
    } else {
        this.formref.backorderable.checked = false;
    }

    if (this.data.forcebackorder == "Y") {
        this.formref.forcebackorder.checked = true;
    } else {
        this.formref.forcebackorder.checked = false;
    }

    if (this.data.releaseseparately == "Y") {
        this.formref.releaseseparately.checked = true;
    } else {
        this.formref.releaseseparately.checked = false;
    }

    if (this.data.returnnotdesired == "Y") {
        this.formref.returnnotdesired.checked = false;
    } else {
        this.formref.returnnotdesired.checked = true;
    }
    
    if (this.data.creditable == "Y") {
        this.formref.creditable.checked = true;
    } else {
        this.formref.creditable.checked = false;
    }

 
}


function getData() {

    return this.data;
    
}


StoreItem.prototype.load = load;
StoreItem.prototype.display = display;
StoreItem.prototype.getData = getData;

var sti = null;

function savePanelData() {

   if (sti != null)   {
       sti.formref = document.storeitem;
       sti.load();
       parent.put( StoreItem.ID, sti.getData());
   }
     
}
 
function initForm() {

  
    var dataObject = parent.get( StoreItem.ID );
    var detailsObject = parent.get("details");
    var catentryType = detailsObject.type;
    if (catentryType == "PackageBean" || catentryType == "ProductBean")
    {
    	trackinventory0.style.display="block";
    	trackinventory1.style.display="block";
    }
    
    if (dataObject == null) {
        
        sti = new StoreItem ();
        if (catentryType == "DynamicKitBean")
        {
        	sti.data.trackinventory="N";
        }
        sti.formref = document.storeitem;
          
        sti.display();
        
    } else {

        sti = new StoreItem();
        sti.data = dataObject;
        sti.formref = document.storeitem;
        sti.display();
         
    }

    if (parent.get("quantityMultipleSelectNumberMessage", false))
       {
        parent.remove("quantityMultipleSelectNumberMessage");
	document.storeitem.quantitymultiple.select();
        alertDialog("<%= UIUtil.toJavaScript((String)productResource.get("quantityMultipleSelectNumberMessage"))%>");
               
       }

    if (parent.get("fieldSizeExceeded", false))
       {
        parent.remove("fieldSizeExceeded");
	document.storeitem.quantitymultiple.select();
        alertDialog("<%= UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");
               
       }

    parent.setContentFrameLoaded(true);
}    



function validatePanelData() {

	var objQuantityMultiple = document.storeitem.quantitymultiple.value;
    	var langId = "<%=lang_id%>";

	if(objQuantityMultiple != "" && !isValidNumber(objQuantityMultiple , langId)){
		document.storeitem.quantitymultiple.select();
   		alertDialog("<%=UIUtil.toJavaScript((String)productResource.get("quantityMultipleSelectNumberMessage"))%>");
   		return false;
   	}    	

    	if ( !isValidUTF8length(objQuantityMultiple, 8)  ){
		document.storeitem.quantitymultiple.select();
		alertDialog("<%=UIUtil.toJavaScript((String)productResource.get("fieldSizeExceeded"))%>");     	 
   		return false;
    	}

	return true;
}


function displayValue(value, valueType) {   
	        
        if(valueType == "AttributeIntegerValueBean") 
        {
             	var formatted = numberToStr(value, "<%=lang_id%>", null);
             	if (formatted != "NaN" && formatted != null){
                 	return formatted;   
             	}else{             
                 	return value;                 
             	}
         
        }else if(valueType  == "AttributeFloatValueBean"){
  
             	var numDecimal = numberOfDecimalPlaces(value);
           
             	var formatted = numberToStr(value, "<%=lang_id%>", numDecimal);
             	if (formatted != "NaN" && formatted != null){ 
                 	return formatted;     
             	}else{
                 	return value;
             	}
        
        }else{
            	return value;                                         
        }
        
}

       
</SCRIPT>
</HEAD>

<BODY onload="initForm()" class="content">
<H1><%=UIUtil.toHTML((String)productResource.get("Fulfillment"))%></H1>

<FORM name="storeitem">

<TABLE cols=6>   
    <TH colspan="6"></TH>   
    <TR ID=trackinventory0 style="display:none">
           <TD colspan="4">
	      	   <LABEL for="trackinventoryID"><%=UIUtil.toHTML((String)productResource.get("trackinventory"))%></LABEL>
           </TD>
    </TR>
    <TR ID=trackinventory1 style="display:none">
			<TD colspan="4">
           
	   <SELECT id="trackinventoryID" name="trackinventory">
	   		<OPTION value= "Y" > <%=UIUtil.toHTML((String)productResource.get("trackinventory"))%> </OPTION>
	   		<OPTION value= "N" > <%=UIUtil.toHTML((String)productResource.get("donottrackinventory"))%> </OPTION>
	   		<OPTION value= "E" > <%=UIUtil.toHTML((String)productResource.get("externallytrackinventory"))%> </OPTION>
	   	</SELECT>
		<BR><BR>
	</TD>
    </TR>

    <TR>
	<TD>
	   <LABEL for="backorderableID"><INPUT type="checkbox" id="backorderableID" name="backorderable"> &nbsp;<%=UIUtil.toHTML((String)productResource.get("backorderable"))%></LABEL><BR><BR>
	</TD>
    </TR>
    <TR>
	<TD>
	   <LABEL for="forcebackorderID"><INPUT type="checkbox" id="forcebackorderID" name="forcebackorder"> &nbsp;<%=UIUtil.toHTML((String)productResource.get("forcebackorder"))%></LABEL><BR><BR>
	</TD>
    </TR>
    <TR>
	<TD>
	   <LABEL for="releaseseparatelyID"><INPUT type="checkbox" id="releaseseparatelyID" name="releaseseparately"> &nbsp;<%=UIUtil.toHTML((String)productResource.get("releaseseparately"))%></LABEL><BR><BR>
	</TD>
    </TR>
    <TR>
	<TD>
	   <LABEL for="returnnotdesiredID"><INPUT type="checkbox" id="returnnotdesiredID" name="returnnotdesired"> &nbsp;<%=UIUtil.toHTML((String)productResource.get("returnable"))%></LABEL><BR><BR>
	</TD>
    </TR>
    
    <TR>
	<TD>
	   <LABEL for="creditableID"><INPUT type="checkbox" id="creditableID" name="creditable"> &nbsp;<%=UIUtil.toHTML((String)productResource.get("creditable"))%></LABEL><BR><BR>
	</TD>
    </TR>    
    
    
    <TR>
           <TD colspan="4">
               <BR><LABEL for="quantitymultipleID"><%=UIUtil.toHTML((String)productResource.get("fulfillment_smallestAmountMeasured"))%></LABEL>
           </TD>
    </TR>
    <TR>
           <TD colspan="4">
           <INPUT id="quantitymultipleID" size="16" maxlength="16" type="text" name="quantitymultiple"><BR><BR>
       </TD>
    </TR>    
    
   <TR>
           <TD colspan="4">
               <LABEL for="quantitymeasureID"><%=UIUtil.toHTML((String)productResource.get("quantitymeasure_fulfillment"))%></LABEL>
           </TD>
    </TR>
    <TR>
           <TD colspan="4">
           
           <SELECT id="quantitymeasureID" name="quantitymeasure">
    		<%
 				
    		for (int j = 0; j < qomId.length; j++){
					
			if (strQuantityOfMeasure.equals(qomId[j])){ 
    		%>	   			
				<OPTION value= <%= UIUtil.toHTML((String) qomId[j]) %>  selected> <%= (String) qomDesc[j] %> </OPTION>
   	 	<%
   	 		}else{   				
		%>
				<OPTION value= <%= UIUtil.toHTML((String) qomId[j]) %>> <%= (String) qomDesc[j] %> </OPTION>
    		<%
    			}
					
					
		}
				
		%>
		
	</SELECT>
           
                
           
           
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


