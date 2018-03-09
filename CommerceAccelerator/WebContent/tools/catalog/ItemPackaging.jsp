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
  Hashtable itemResource = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("catalog.ItemNLS", jLocale);
  Integer storeId = cmdContext.getStoreId();
%>

<% 
     
  try {

    
    
    
   String productRefNum = request.getParameter(com.ibm.commerce.tools.catalog.util.ECConstants.EC_PRODUCT_NUMBER);
   String itemRefNum = request.getParameter(com.ibm.commerce.tools.catalog.util.ECConstants.EC_ITEM_NUMBER); 
   String lang_id = request.getParameter(com.ibm.commerce.server.ECConstants.EC_LANGUAGE_ID);


   String catEntryRefNum = null;

   if(itemRefNum != null){
	catEntryRefNum = itemRefNum;
   }else{
	catEntryRefNum = productRefNum;
   }

   
   String strWeight = null;
   String strWeightMeasure = null;
   String strQuantityOfMeasure = null;
   String strQuantityMultiple = null;
   String strNominalQuantity = null;
   
   
   try{

   	if(catEntryRefNum != null){
   		CatalogEntryShippingAccessBean cesAB = new CatalogEntryShippingAccessBean ();
   		cesAB.setInitKey_catalogEntryId( catEntryRefNum );
   	
   		strWeight = cesAB.getWeight();
   		strWeightMeasure = cesAB.getWeightMeasure();
   		strQuantityOfMeasure = cesAB.getQuantityMeasure();
   		strQuantityMultiple = cesAB.getQuantityMultiple();
  		strNominalQuantity = cesAB.getNominalQuantity();  	
   	}

   } catch(javax.persistence.NoResultException e1) {

   }

   lang_id = (lang_id != null ? UIUtil.toJavaScript(lang_id) : "");
   strWeight = (strWeight != null ? UIUtil.toJavaScript(strWeight) : "");
   strWeightMeasure = (strWeightMeasure != null ? UIUtil.toJavaScript(strWeightMeasure) : "");
   strQuantityOfMeasure = (strQuantityOfMeasure != null ? UIUtil.toJavaScript(strQuantityOfMeasure) : "");
   strQuantityMultiple = (strQuantityMultiple != null ? UIUtil.toJavaScript(strQuantityMultiple) : "");
   strNominalQuantity = (strNominalQuantity != null ? UIUtil.toJavaScript(strNominalQuantity) : "");
   
   
   
   
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
<TITLE><%=UIUtil.toHTML((String)itemResource.get("listPriceTitle"))%></TITLE>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css">

<%@include file="../common/NumberFormat.jsp" %>
<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT> 
 
<SCRIPT>
 
function CatEntShipData(){

   this.langid = "<%=lang_id%>";
   this.weight = "<%=strWeight%>"; 
   this.weightmeasure = "<%=strWeightMeasure%>"; 
   this.quantitymeasure = "<%=strQuantityOfMeasure%>";
   this.quantitymultiple = "<%=strQuantityMultiple%>";
   this.nominalquantity = "<%=strNominalQuantity%>";
}


CatEntShip.ID = "catentship";


function CatEntShip () {

   this.data = new CatEntShipData();
   this.id = CatEntShip.ID;
   this.formref = null;

}




function load() {

   var weight_load = this.formref.weight.value;
   var quantitymultiple_load = this.formref.quantitymultiple.value;
   var nominalquantity_load = this.formref.nominalquantity.value;

   this.data.weightmeasure = parent.cutspace ( this.formref.weightmeasure.value );
   this.data.quantitymeasure = parent.cutspace ( this.formref.quantitymeasure.value );

   if(weight_load != null && weight_load != ""){

   	this.data.weight = strToNumber(weight_load, "<%=lang_id%>");
   
   }else{
   
   	this.data.weight = weight_load;
   	
   }
   

   if(quantitymultiple_load != null && quantitymultiple_load != ""){

   	this.data.quantitymultiple = strToNumber(quantitymultiple_load, "<%=lang_id%>");
   
   }else{
   
   	this.data.quantitymultiple = quantitymultiple_load;
   	
   }
      
   
   if(nominalquantity_load != null && nominalquantity_load != ""){

   	this.data.nominalquantity = strToNumber(nominalquantity_load, "<%=lang_id%>");
   
   }else{
   
   	this.data.nominalquantity = nominalquantity_load;
   	
   }
   
}

function display() {

    var _weight = this.data.weight;
    var _qtymultiple = this.data.quantitymultiple;
    var _nominalquantity = this.data.nominalquantity;
    
    this.formref.weightmeasure.value =   this.data.weightmeasure;
    this.formref.quantitymeasure.value =   this.data.quantitymeasure;

    if(_weight != null && _weight != ""){

    	this.formref.weight.value =   displayValue(_weight, "AttributeFloatValueBean");
    	
    }else{
    
    	this.formref.weight.value =   _weight;
    }
    
    
    if(_qtymultiple != null && _qtymultiple != ""){

    	this.formref.quantitymultiple.value =   displayValue(_qtymultiple, "AttributeFloatValueBean");
    	
    }else{
    
    	this.formref.quantitymultiple.value = _qtymultiple;
    }
    	

    if(_nominalquantity != null && _nominalquantity != ""){

    	this.formref.nominalquantity.value =   displayValue(_nominalquantity, "AttributeFloatValueBean");
    	
    }else{
    
    	this.formref.nominalquantity.value = _nominalquantity;
    }    
    
       
   

 
}


function getData() {

    return this.data;
    
}


CatEntShip.prototype.load = load;
CatEntShip.prototype.display = display;
CatEntShip.prototype.getData = getData;


var sti = null;

function savePanelData() {

   if (sti != null)   {
       sti.formref = document.catentship;
       sti.load();
       if (isFormDataNotEmpty(sti.getData()) ){
       	  parent.put( CatEntShip.ID, sti.getData());
       };
   }
     
}

function isFormDataNotEmpty(myData) {
	isNotEmpty = true;
        if (  myData.weight == "" &&  myData.weightmeasure == "" &&  myData.quantitymeasure == "" && myData.quantitymultiple == "" && myData.nominalquantity == "" )
        {
        	isNotEmpty = false;
        }
        return isNotEmpty;
}

 
function initForm() {

  
    var dataObject = parent.get( CatEntShip.ID );
    
    if (dataObject == null) {
        
        sti = new CatEntShip ();
        sti.formref = document.catentship;
          
        sti.display();
        
    } else {

        sti = new CatEntShip();
        sti.data = dataObject;
        sti.formref = document.catentship;
        sti.display();
         
    }

    if (parent.get("weightSelectNumberMessage", false))
       {
        parent.remove("weightSelectNumberMessage");
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("weightSelectNumberMessage"))%>");
        
       }

    if (parent.get("quantityMultipleSelectNumberMessage", false))
       {
        parent.remove("quantityMultipleSelectNumberMessage");
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("quantityMultipleSelectNumberMessage"))%>");
               
       }

    if (parent.get("nominalQuantitySelectNumberMessage", false))
       {
        parent.remove("nominalQuantitySelectNumberMessage");
        alertDialog("<%= UIUtil.toJavaScript((String)itemResource.get("nominalQuantitySelectNumberMessage"))%>");
        
       }

    parent.setContentFrameLoaded(true);
}    



function validatePanelData() {


	var objWeight = document.catentship.weight.value;
	var objQuantityMultiple = document.catentship.quantitymultiple.value;
	var objNominalQuantity = document.catentship.nominalquantity.value;
    	var langId = "<%=lang_id%>";

	if(objWeight != "" && !isValidNumber(objWeight , langId)){
   		alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("weightSelectNumberMessage"))%>");
   		return false;
   	}

	if(objQuantityMultiple != "" && !isValidNumber(objQuantityMultiple , langId)){
   		alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("quantityMultipleSelectNumberMessage"))%>");
   		return false;
   	}

	if(objNominalQuantity != "" && !isValidNumber(objNominalQuantity , langId)){
   		alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("nominalQuantitySelectNumberMessage"))%>");
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

function checkWeight()
{
	if (!isInputStringEmpty("<%=strWeight%>") && isInputStringEmpty(catentship.weight.value))
	{
		alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("weightSelectNumberMessage"))%>");
		catentship.weight.focus();
	}
}

function checkMultiple()
{
	if (!isInputStringEmpty("<%=strQuantityMultiple%>") && isInputStringEmpty(catentship.quantitymultiple.value))
	{
		alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("quantityMultipleSelectNumberMessage"))%>");
		catentship.quantitymultiple.focus();
	}
}

function checkNominal()
{
	if (!isInputStringEmpty("<%=strQuantityOfMeasure%>") && isInputStringEmpty(catentship.nominalquantity.value))
	{
		alertDialog("<%=UIUtil.toJavaScript((String)itemResource.get("nominalQuantitySelectNumberMessage"))%>");
		catentship.nominalquantity.focus();
	}
}
       
</SCRIPT>
</HEAD>

<BODY onload="initForm()" class="content">
<H1><%=UIUtil.toHTML((String)itemResource.get("catentShipTitle"))%></H1>

<FORM name="catentship">

<TABLE cols=6>   
    <TH colspan="6"></TH>   
    
    
    <TR>
           <TD colspan="4">
               <BR><label for='weight'><%=UIUtil.toHTML((String)itemResource.get("weight"))%></label>
           </TD>
    </TR>
    <TR>
           <TD colspan="4">
           <INPUT id='weight' size="16" maxlength="16" type="text" name="weight" ONBLUR=checkWeight()><BR><BR>
       	   </TD>
    </TR>
    
    <TR>
           <TD colspan="4">
               <label for='weightmeasure'><%=UIUtil.toHTML((String)itemResource.get("weightmeasure"))%></label>
           </TD>
    </TR>
    <TR>
           <TD colspan="4">
           
           <SELECT id='weightmeasure' name="weightmeasure">
    		<%
 				
    		for (int i = 0; i < qomId.length; i++){
					
			if (strWeightMeasure.equals(qomId[i])){ 
    		%>	   			
				<OPTION value= <%= UIUtil.toHTML((String) qomId[i]) %>  selected> <%= (String) qomDesc[i] %> </OPTION>
   	 	<%
   	 		}else{   				
		%>
				<OPTION value= <%= UIUtil.toHTML((String) qomId[i]) %>> <%= (String) qomDesc[i] %> </OPTION>
    		<%
    			}
					
					
		}
				
		%>
		
	</SELECT>
           
                
           
           
       </TD>
    </TR>
    
    
    
    
    
    

    
    
    
    
    <TR>
           <TD colspan="4">
           <BR><label for='quantitymultiple_unitofmeasure'><%=UIUtil.toHTML((String)itemResource.get("quantitymultiple_unitofmeasure"))%></label>
           </TD>
    </TR>
    <TR>
           <TD colspan="4">
           <INPUT id='quantitymultiple_unitofmeasure' size="16" maxlength="16" type="text" name="quantitymultiple" ONBLUR=checkMultiple()><BR>
       	   </TD>
    </TR>
    
    
    <TR>
           <TD colspan="4">
               <BR><label for='nominalquantity'><%=UIUtil.toHTML((String)itemResource.get("nominalquantity"))%></label>
           </TD>
    </TR>
    <TR>
           <TD colspan="4">
           <INPUT id='nominalquantity' size="16" maxlength="16" type="text" name="nominalquantity" ONBLUR=checkNominal()>
           </TD>
       
    </TR>   


   <TR>
           <TD colspan="4">
           <BR><label for='quantitymeasure_unitofmeasure'><%=UIUtil.toHTML((String)itemResource.get("quantitymeasure_unitofmeasure"))%></label>
           </TD>
    </TR>
    <TR>
           <TD colspan="4">
           
           <SELECT id='quantitymeasure_unitofmeasure' name="quantitymeasure">
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


