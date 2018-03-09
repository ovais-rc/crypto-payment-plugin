<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2002, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@include file="epromotionCommon.jsp" %>

<%
  String calcodeId = request.getParameter("calcodeId");
%>


<html xmlns="http://www.w3.org/1999/xhtml"><head>
<title><%=RLPromotionNLS.get("RLModifyRangeWindowTitle")%></title>
<meta name="GENERATOR" content="IBM WebSphere Studio" />

<%= fPromoHeader%>
<script src="/wcs/javascript/tools/common/Util.js">
</script>

<script language="JavaScript">

//global var to get the selected currency
var calCodeId = null;

var fCurr=top.getData("RLDiscCurr");
var newRange= new Array();
var whichDiscountType = top.getData("RLRangeType");
var ranges=top.getData("RLDiscountRanges");
var values=top.getData("RLDiscountValues");
var index=top.getData("RLModifyRangeIndex");

</script>

<%
if(calcodeId != null && !(calcodeId.equals("")))
{
%>
<script language="JavaScript">
	calCodeId = <%=(calcodeId == null ? null : UIUtil.toJavaScript(calcodeId))%>;

</script>
<%
}
%>


</head>
<body class="content" onload="initializeState();">
<script language="JavaScript">

//////////////////////////////////////////////////////////
// Load data and initialize the data from state of info
//////////////////////////////////////////////////////////
function initializeState()
{   
  // init
  var modifyEntryOfRangeFrom    = ranges[index];
  
  var modifyEntryOfRangeDiscount= values[index];
  // add them to GUI
  if ((whichDiscountType == "ItemLevelPercentDiscount")||(whichDiscountType == "ItemLevelValueDiscount")||(whichDiscountType == "ItemLevelPerItemValueDiscount") || (whichDiscountType == "ProductLevelPercentDiscount")||(whichDiscountType == "ProductLevelValueDiscount")||(whichDiscountType == "ProductLevelPerItemValueDiscount") || (whichDiscountType == "CategoryLevelPercentDiscount")||(whichDiscountType == "CategoryLevelValueDiscount")||(whichDiscountType == "CategoryLevelPerItemValueDiscount")) 
  {
  	document.f1.rangefrom.value= parent.numberToStr(modifyEntryOfRangeFrom.toString(),"<%=fLanguageId%>",0);
  }
  else
  	document.f1.rangefrom.value= parent.numberToCurrency(modifyEntryOfRangeFrom.toString(),fCurr,"<%=fLanguageId%>");
  
  if(whichDiscountType == "ItemLevelPercentDiscount" || whichDiscountType == "ProductLevelPercentDiscount" || whichDiscountType == "CategoryLevelPercentDiscount")
  {
  	//percent discount
  	// Changed for defect 179712
     document.f1.discount.value = trim(modifyEntryOfRangeDiscount.toString());
  }
  else if((whichDiscountType == "ItemLevelValueDiscount")||(whichDiscountType == "ItemLevelPerItemValueDiscount") || (whichDiscountType == "ProductLevelValueDiscount")||(whichDiscountType == "ProductLevelPerItemValueDiscount") || (whichDiscountType == "CategoryLevelValueDiscount")||(whichDiscountType == "CategoryLevelPerItemValueDiscount"))
  {
       document.f1.discount.value = parent.numberToCurrency(modifyEntryOfRangeDiscount.toString(),fCurr,"<%=fLanguageId%>");
  }
  
  document.f1.rangefrom.focus();
  document.f1.rangefrom.select();
  
}


function discountType()
{
	  if((whichDiscountType == "ItemLevelPercentDiscount")||(whichDiscountType == "ItemLevelValueDiscount")||(whichDiscountType == "ItemLevelPerItemValueDiscount") || (whichDiscountType == "ProductLevelPercentDiscount")||(whichDiscountType == "ProductLevelValueDiscount")||(whichDiscountType == "ProductLevelPerItemValueDiscount") || (whichDiscountType == "CategoryLevelPercentDiscount")||(whichDiscountType == "CategoryLevelValueDiscount")||(whichDiscountType == "CategoryLevelPerItemValueDiscount"))
	    document.write('<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("byUnit"))%>');
	  else
	    document.write("("+fCurr+")");
}

function cancelAction()
{
	if( calCodeId == null || calCodeId == '')
	{
		parent.location.replace("WizardView?XMLFile=RLPromotion.RLPromotionWizard&startingPage=RLProdPromoWizardRanges");
	}else
	{
		parent.location.replace("NotebookView?XMLFile=RLPromotion.RLPromotionNotebook&startingPage=RLProdPromoWizardRanges&calcodeId="+calCodeId);
	}
}

////////////////////////////////////////////////////////////
// Add new range to the state of info
////////////////////////////////////////////////////////////
function savePanelData() 
{  
if(validatePanelData())
{
	  if ((whichDiscountType == "ItemLevelPercentDiscount")||(whichDiscountType == "ItemLevelValueDiscount")||(whichDiscountType == "ItemLevelPerItemValueDiscount") || (whichDiscountType == "ProductLevelPercentDiscount")||(whichDiscountType == "ProductLevelValueDiscount")||(whichDiscountType == "ProductLevelPerItemValueDiscount") || (whichDiscountType == "CategoryLevelPercentDiscount")||(whichDiscountType == "CategoryLevelValueDiscount")||(whichDiscountType == "CategoryLevelPerItemValueDiscount"))
	  { 
		// quantity
	  ranges[index] = parent.strToInteger(trim(document.f1.rangefrom.value),"<%=fLanguageId%>");
	  }
	  else
	  {
	  ranges[index] = parent.currencyToNumber(trim(document.f1.rangefrom.value),fCurr,"<%=fLanguageId%>");
	  }
	  if(whichDiscountType == "ItemLevelPercentDiscount" || whichDiscountType == "ProductLevelPercentDiscount"  || whichDiscountType == "CategoryLevelPercentDiscount")
	  {
	  	//percent discount
	  	// Changed for defect 179712
	  	values[index] = parent.strToNumber(trim(document.f1.discount.value),"<%=fLanguageId%>");
	  }
	  else if((whichDiscountType == "ItemLevelValueDiscount")||(whichDiscountType == "ItemLevelPerItemValueDiscount") || (whichDiscountType == "ProductLevelValueDiscount")||(whichDiscountType == "ProductLevelPerItemValueDiscount") || (whichDiscountType == "CategoryLevelValueDiscount")||(whichDiscountType == "CategoryLevelPerItemValueDiscount"))
	  {
	  	//currency discount
	  	values[index] = parent.currencyToNumber(trim(document.f1.discount.value),fCurr,"<%=fLanguageId%>");
	  }	
  top.saveData(ranges,"RLDiscountRanges");
  top.saveData(values,"RLDiscountValues");
	if( calCodeId == null || calCodeId == '')
	{
		parent.location.replace("WizardView?XMLFile=RLPromotion.RLPromotionWizard&startingPage=RLProdPromoWizardRanges");
	}else
	{
		parent.location.replace("NotebookView?XMLFile=RLPromotion.RLPromotionNotebook&startingPage=RLProdPromoWizardRanges&calcodeId="+calCodeId);
	}
  }
}

function showFormatRange(range){
	  if ((whichDiscountType == "ItemLevelPercentDiscount")||(whichDiscountType == "ItemLevelValueDiscount")||(whichDiscountType == "ItemLevelPerItemValueDiscount") || (whichDiscountType == "ProductLevelPercentDiscount")||(whichDiscountType == "ProductLevelValueDiscount")||(whichDiscountType == "ProductLevelPerItemValueDiscount") || (whichDiscountType == "CategoryLevelPercentDiscount")||(whichDiscountType == "CategoryLevelValueDiscount")||(whichDiscountType == "CategoryLevelPerItemValueDiscount")) {
		   // This is the quantity
		return parent.numberToStr(range.toString(),"<%=fLanguageId%>",0);	   
	  }
	  else{
	  // this is a $ value
	  	return parent.numberToCurrency(range.toString(),fCurr,"<%=fLanguageId%>");
	  }
}

function showFormatDiscount(d){
	 if (whichDiscountType == "ItemLevelPercentDiscount" || whichDiscountType == "ProductLevelPercentDiscount" || whichDiscountType == "CategoryLevelPercentDiscount")
	       // Changed for defect 179712
	      return d.toString();
	 else
	      return parent.numberToCurrency(d.toString(),fCurr,"<%=fLanguageId%>");
}

function isValidPercentage(pValue, languageId)
{
	// Changed for defect 179712
	if ( !parent.isValidNumber(pValue, languageId))
	{
		return false;
	}
	else if( ! (eval(pValue) <= 100))
	{
		return false;
	}
	else if (! (eval(pValue) >= 0) )
	{
		return false;
	}
	return true;
}
/////////////////////////////////////////////////////////////////////////////
// This function will validate the entry fields for this page before wizard
// goes to the next or previous page. This function will also be used to
// restore the user changes to the state of info
/////////////////////////////////////////////////////////////////////////////
function validatePanelData() {
	  //check in cell "range Start"
	  if ((whichDiscountType == "OrderLevelPercentDiscount")||(whichDiscountType == "OrderLevelValueDiscount"))
	  {
	  	//this is a $ value range
	  	if(!parent.isValidCurrency(trim(document.f1.rangefrom.value),fCurr,"<%=fLanguageId%>"))
	  	{
	        // range from must be a currency value
	   	  parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeFromNotNumber").toString())%>');
	   	  document.f1.rangefrom.focus();
	   	  document.f1.rangefrom.select();
	   	  return false;
	    }
	     
	    if(parent.currencyToNumber(trim(document.f1.rangefrom.value), "<%=fLanguageId%>")<0)
	    {
	        // range from must >=0
	   	  parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeFromNotNumber").toString())%>');
	   	  document.f1.rangefrom.select();
	   	  return false;
	    }
	     		
	    if((parent.currencyToNumber(trim(document.f1.rangefrom.value), "<%=fLanguageId%>")).toString().length >14)
	    {
	   	parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeTooLong").toString())%>');
	   	document.f1.rangefrom.focus();
	   	document.f1.rangefrom.select();
	   	return false;
	    }
	  }  
	  else if ((whichDiscountType == "ItemLevelPercentDiscount")||(whichDiscountType == "ItemLevelValueDiscount")||(whichDiscountType == "ItemLevelPerItemValueDiscount") || (whichDiscountType == "ProductLevelPercentDiscount")||(whichDiscountType == "ProductLevelValueDiscount")||(whichDiscountType == "ProductLevelPerItemValueDiscount")|| (whichDiscountType == "CategoryLevelPercentDiscount")||(whichDiscountType == "CategoryLevelValueDiscount")||(whichDiscountType == "CategoryLevelPerItemValueDiscount")) 
	  {
	  // If this is the quantity range
	     if ( !parent.isValidInteger(trim(document.f1.rangefrom.value), "<%=fLanguageId%>"))
	     {
	        // range from must be a integer
	   	  parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeFromNotNumber").toString())%>');
	   	  document.f1.rangefrom.focus();
	   	  document.f1.rangefrom.select();
	   	  return false;
	     }
	     
	     if(parent.strToInteger(trim(document.f1.rangefrom.value), "<%=fLanguageId%>")< 0)
	     {
	   	  parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeFromNotNumber").toString())%>');
	   	  document.f1.rangefrom.select();
	   	  return false;
	     }
	     
	   if((parent.strToInteger(trim(document.f1.rangefrom.value), "<%=fLanguageId%>")).toString().length >14)
	   {
	   	parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeTooLong").toString())%>');
	   	document.f1.rangefrom.focus();
	   	document.f1.rangefrom.select();
	   	return false;
	   }
	  }
  if(ranges.length>1)
  {
      if(eval(index)<ranges.length-1)
      {
         if(eval(parseFloat(parent.strToNumber(trim(document.f1.rangefrom.value), "<%=fLanguageId%>")))>= eval(parseFloat(parent.strToNumber(ranges[eval(index)+1]), "<%=fLanguageId%>" )))
         {
            parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeFromBig").toString())%>');
            document.f1.rangefrom.focus();
            document.f1.rangefrom.select();
            return false;
         }
       }
      if(eval(index)>0)
      { 
      	if(eval(parseFloat(parent.strToNumber(trim(document.f1.rangefrom.value), "<%=fLanguageId%>")))<= eval(parseFloat(parent.strToNumber(ranges[eval(index)-1]), "<%=fLanguageId%>" )))
      	{
         	parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeFromSmall").toString())%>');
         	document.f1.rangefrom.focus();
        	document.f1.rangefrom.select();
        	return false;
      	}
      }
   
  }	 
  
	  // check in cell "discount"
	
	  if (whichDiscountType == "ItemLevelPercentDiscount" || whichDiscountType == "ProductLevelPercentDiscount" || whichDiscountType == "CategoryLevelPercentDiscount")
	  {
	     if ( !isValidPercentage(trim(document.f1.discount.value),"<%=fLanguageId%>")) 
	     {
		 parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("percentageInvalid").toString())%>'); 
		 document.f1.discount.focus();
		 document.f1.discount.select();
		 return false;
	     }
	  }
	  else if((whichDiscountType == "ItemLevelValueDiscount")||(whichDiscountType == "ItemLevelPerItemValueDiscount") || (whichDiscountType == "ProductLevelValueDiscount")||(whichDiscountType == "ProductLevelPerItemValueDiscount") || (whichDiscountType == "CategoryLevelValueDiscount")||(whichDiscountType == "CategoryLevelPerItemValueDiscount"))
	  {
	    if(!parent.isValidCurrency(trim(document.f1.discount.value),fCurr,"<%=fLanguageId%>"))
	    {
		 parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("discountNotNumber").toString())%>'); 
		 document.f1.discount.focus();
		 document.f1.discount.select();
		 return false;
	    }
	    
	    if(parent.currencyToNumber(trim(document.f1.discount.value), "<%=fLanguageId%>") <0)
	    {
		 parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("discountNotNumber").toString())%>'); 
		 document.f1.discount.select();
		 return false;
	    }
	    
	   if((parent.currencyToNumber(trim(document.f1.discount.value), "<%=fLanguageId%>")).toString().length >14)
	   {
	   	parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("currencyTooLong").toString())%>');
	   	document.f1.discount.focus();
	   	document.f1.discount.select();
	   	return false;
	   }
	  }
  return true;
}   

//format the ranges in the frame, convert to from and to object 
function formatRanges(ranges,values)
{  
  var aRangeDisplay = new Array();
     
  for(var i=0;i<ranges.length;i++) {
    var aRange=new Object;
    aRange.rangeFrom = ranges[i];
    aRange.rangeTo = <%=RLConstants.EC_RANGE_MAX%>;
    aRange.discount= values[i];
    aRangeDisplay[i]=aRange;   	
  }
  
  //format RangeTo
  var increValue= 1;      
  if ( whichDiscountType == "OrderLevelPercentDiscount" ) 
    increValue = 1 / Math.pow(10,parent.numericInfo[fCurr]["<%=fLanguageId%>"]["currency"]["minFrac"]);    
  if(ranges.length>1)      
    for(var i=0; i<ranges.length-1;i++)
       aRangeDisplay[i].rangeTo=eval(parseFloat(aRangeDisplay[i+1].rangeFrom) - parseFloat(increValue)); 
  
  return aRangeDisplay;
}

</script>
<h1><%=RLPromotionNLS.get("RLModifyRangeWindowTitle")%></h1>
	   <p><%=RLPromotionNLS.get("rangeToMsg")%></p>
   <form name="f1" id="f1">
     <label for="WC_RLProdPromoRanges_Modify_FormInput_rangefrom_In_f1_1"><%=RLPromotionNLS.get("prodPromoRangeFrom")%><script language="JavaScript">discountType()
</script></label>
     <br />
     <input type='text' name='rangefrom' value="" size="10" maxlength="18" id="WC_RLProdPromoRanges_Modify_FormInput_rangefrom_In_f1_1" /><br /><br />
	<label for="WC_RLProdPromoRanges_Modify_FormInput_discount_In_f1_1">
	<script language="JavaScript">
	   if(whichDiscountType == "ItemLevelPercentDiscount" || whichDiscountType == "ProductLevelPercentDiscount" || whichDiscountType == "CategoryLevelPercentDiscount")
	   {
	      document.write('<%=UIUtil.toJavaScript((String) RLPromotionNLS.get("discountInPercent"))%> ')
	   }
	   else if((whichDiscountType == "ItemLevelValueDiscount")||(whichDiscountType == "ItemLevelPerItemValueDiscount") || (whichDiscountType == "ProductLevelValueDiscount")||(whichDiscountType == "ProductLevelPerItemValueDiscount") || (whichDiscountType == "CategoryLevelValueDiscount")||(whichDiscountType == "CategoryLevelPerItemValueDiscount"))
	   {
	      document.write('<%=UIUtil.toJavaScript((String) RLPromotionNLS.get("discountRate"))%>');
	      document.write("("+fCurr+")");
	   }
   	
	
</script></label>
	 <br />
    <input type='text' name='discount' value="" size="10" id="WC_RLProdPromoRanges_Modify_FormInput_discount_In_f1_1" /><br /><br />

   </form>
 <p><%=RLPromotionNLS.get("currentRange")%></p>
<form name="rangeForm" id="rangeForm">
<table cellpadding="1" cellspacing="0" border="0" width="60%" bgcolor="#6D6D7C">
<tr>
<td>
<table class="list" border="0" cellpadding="0" cellspacing="0" summary='<%=RLPromotionNLS.get("discountRangeTblMsg")%>'>
<tr>
   <th width="20%" id="t1" class="list_header" nowrap="nowrap">
		<%= RLPromotionNLS.get("prodPromoRangeFrom") %>
   		<script language="JavaScript">discountType()
		</script>
   </th>
   <th width="20%" id="t2" class="list_header" nowrap="nowrap">
		<%= RLPromotionNLS.get("prodPromoRangeTo") %>
   		<script language="JavaScript">discountType()
		</script>
   </th>

   <script language="JavaScript">
  if ((whichDiscountType == "ItemLevelPercentDiscount") || (whichDiscountType == "ProductLevelPercentDiscount") || (whichDiscountType == "CategoryLevelPercentDiscount"))
   {
      document.write('<th width="20%" id="t3" class="list_header" nowrap="nowrap">'+'<%= UIUtil.toJavaScript((String)RLPromotionNLS.get("discountInPercent"))%>');
      document.write('</th>');
   }
   else if((whichDiscountType == "ItemLevelValueDiscount")||(whichDiscountType == "ItemLevelPerItemValueDiscount") || (whichDiscountType == "ProductLevelValueDiscount")||(whichDiscountType == "ProductLevelPerItemValueDiscount") || (whichDiscountType == "CategoryLevelValueDiscount")||(whichDiscountType == "CategoryLevelPerItemValueDiscount"))
   {
      document.write('<th width="20%" id="t3" class="list_header" nowrap="nowrap">'+'<%= UIUtil.toJavaScript((String)RLPromotionNLS.get("discountRate"))%>');
      document.write("("+fCurr+")");
      document.write('</th>')
   }
       
   
</script>
</tr>

<script>
  newRange = formatRanges(ranges,values);

   if(newRange.length>0)
   {
      var classId = "list_row1";

      for (var i=0; i < newRange.length; i++)
      if(eval(newRange[i].rangeTo)>0)      
      {
         document.writeln('<tr class='+classId+'>');
         document.writeln('<td headers="t1" class="list_info1">'  + showFormatRange(newRange[i].rangeFrom)+ '</td>');
         if(newRange[i].rangeTo==<%=RLConstants.EC_RANGE_MAX%> ) 
              document.writeln('<td headers="t2" class="list_info1">'  + '<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("andUp"))%>' + '</td>');
         else	 
              document.writeln('<td headers="t2" class="list_info1">'  + showFormatRange(newRange[i].rangeTo) + '</td>');
         document.writeln('<td headers="t3" class="list_info1">' + showFormatDiscount(newRange[i].discount) + '</td>');
         document.writeln('</tr>');

         if (classId == "list_row1")
            classId = "list_row2";
         else
            classId = "list_row1"
         
      }
   }
   
   if(newRange.length=0)
   	document.write('<p><%=UIUtil.toJavaScript((String)RLPromotionNLS.get("discountNoRanges"))%></p>');

   parent.setContentFrameLoaded(true);
   

</script>

</table></td></tr></table></form></body>
</html>

