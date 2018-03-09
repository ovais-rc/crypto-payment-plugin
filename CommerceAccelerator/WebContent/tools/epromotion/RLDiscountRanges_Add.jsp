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
  String calCodeId =  request.getParameter("calcodeId");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=RLPromotionNLS.get("RLAddRangeWindowTitle")%></title>
<meta name="GENERATOR" content="IBM WebSphere Studio" />

<%= fPromoHeader%> 
<script src="/wcs/javascript/tools/common/Util.js">
</script>

<script language="JavaScript">
var calCodeId = null;
var fCurr=top.getData("RLDiscCurr");
var newRange= new Array();
var whichDiscountType = top.getData("RLRangeType");
var ranges=top.getData("RLDiscountRanges");
var values=top.getData("RLDiscountValues");


</script>

<%
if(calCodeId != null && !(calCodeId.equals("")))
{
%>
<script language="JavaScript">
	calCodeId = <%=(calCodeId == null ? null : UIUtil.toJavaScript(calCodeId))%>;

</script>
<%
}
%>

</head>
<body class="content" onload="document.f1.rangefrom.focus();">
<script>
//global var to get the selected currency

function discountType()
{
  if((whichDiscountType == "OrderLevelPercentDiscount")||(whichDiscountType == "OrderLevelValueDiscount"))
    document.write("("+fCurr+")");
  else
    document.write('<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("byUnit"))%>');
}


function cancelAction()
{
	if( calCodeId != null && calCodeId != '')
	{
		parent.location.replace("NotebookView?XMLFile=RLPromotion.RLPromotionNotebook&startingPage=RLDiscountWizardRanges&calcodeId="+calCodeId);
	}else
	{
		parent.location.replace("WizardView?XMLFile=RLPromotion.RLPromotionWizard&startingPage=RLDiscountWizardRanges");
	}
}

////////////////////////////////////////////////////////////
// Add new range to the state of info
////////////////////////////////////////////////////////////
function savePanelData() 
{     
 var addedRange=0;
 var addedValue=0;
 if(validatePanelData())
 {
  if((whichDiscountType == "OrderLevelPercentDiscount")||(whichDiscountType == "OrderLevelValueDiscount"))
  {
  addedRange = parent.currencyToNumber(trim(document.f1.rangefrom.value),fCurr,"<%=fLanguageId%>");
	}
  else
  {
  // could be product level
  addedRange = parent.strToInteger(trim(document.f1.rangefrom.value),"<%=fLanguageId%>");	
  }

  if(whichDiscountType == "OrderLevelPercentDiscount")
  {
  	//percent discount
  	addedValue=parent.strToNumber(trim(document.f1.discount.value),"<%=fLanguageId%>");
  
  }
  else if(whichDiscountType == "OrderLevelValueDiscount")
  {
  	//currency discount
  	addedValue = parent.currencyToNumber(trim(document.f1.discount.value),fCurr,"<%=fLanguageId%>");
  }
  
  if((ranges.length==0)&&(eval(addedRange)>0))
   {
    ranges[0]=0;
    values[0]=0;
  }
  
   ranges[ranges.length]=addedRange;
   values[values.length]=addedValue;
   
   //sorting
  for(var i=0;i<ranges.length-1;i++)
     for(var j=i+1;j<ranges.length;j++)
      if(eval(ranges[i])>eval(ranges[j]))
      {
      var temp=ranges[j];
      ranges[j]=ranges[i];
      ranges[i]=temp;
        
      temp=values[j];
      values[j]=values[i];
      values[i]=temp;
      } 
  
	top.saveData(ranges,"RLDiscountRanges");
    top.saveData(values,"RLDiscountValues");
	if( calCodeId != null && calCodeId != '')
	{
		parent.location.replace("NotebookView?XMLFile=RLPromotion.RLPromotionNotebook&startingPage=RLDiscountWizardRanges&calcodeId="+calCodeId);
	}else
	{
		parent.location.replace("WizardView?XMLFile=RLPromotion.RLPromotionWizard&startingPage=RLDiscountWizardRanges");
	}
  }
}

function showFormatRange(range){
  if ((whichDiscountType == "OrderLevelPercentDiscount")||(whichDiscountType == "OrderLevelValueDiscount")) {
	return parent.numberToCurrency(range.toString(),fCurr,"<%=fLanguageId%>");
	   // This is the value
	}
  else {
  // this may be a quantity
  return parent.numberToStr(range.toString(),"<%=fLanguageId%>",0);	   
  }
}

function showFormatDiscount(d){
 if (whichDiscountType == "OrderLevelPercentDiscount")
 	  // Changed for defect 179712
      return d.toString();
 else
      return parent.numberToCurrency(d.toString(),fCurr,"<%=fLanguageId%>");
}

function isValidPercentage(pValue, languageId)
{	// Changed for defect 179712
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

  // check for value of 'range from', the value of range from should be larger than
  // the value of range to in the previous range (row)
  newRange = formatRanges(ranges,values);
  
  if ((whichDiscountType == "OrderLevelPercentDiscount")||(whichDiscountType == "OrderLevelValueDiscount"))
  {
  	//this is a $ value range
  	if(!parent.isValidCurrency(trim(document.f1.rangefrom.value),fCurr,"<%=fLanguageId%>"))
  	{
        // range from must be a currency value
   	  parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeFromNotNumber").toString())%>');
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
  else 
  {
	   // If this is the quantity range

     if ( !parent.isValidInteger(trim(document.f1.rangefrom.value), "<%=fLanguageId%>"))
     {
        // range from must be a integer
   	  parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeFromNotNumber").toString())%>');
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
    
  for(var i=0;i<newRange.length;i++)
  {
  
  	if(eval(parseFloat(parent.strToNumber(trim(document.f1.rangefrom.value), "<%=fLanguageId%>")))
  	==newRange[i].rangeFrom){
  		parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeFromSame").toString())%>');
  		document.f1.rangefrom.select();
	  return false;
  	}
  }
  
  // check in cell "discount"
  if (whichDiscountType == "OrderLevelPercentDiscount")
  {
    if ( !isValidPercentage(trim(document.f1.discount.value),"<%=fLanguageId%>")) 
      {
	 parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("percentageInvalid").toString())%>'); 
	 document.f1.discount.select();
	 return false;
     }
  }
  else if (whichDiscountType == "OrderLevelValueDiscount")
  {
    if(!parent.isValidCurrency(trim(document.f1.discount.value),fCurr,"<%=fLanguageId%>"))
    {
	 parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("discountNotNumber").toString())%>'); 
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
   
   if(parent.currencyToNumber(trim(document.f1.discount.value), "<%=fLanguageId%>")>eval(parseFloat(parent.strToNumber(trim(document.f1.rangefrom.value), "<%=fLanguageId%>"))))
   {
    parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("discountOverRange").toString())%>');
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
  if ( whichDiscountType == "OrderLevelPercentDiscount" ) {
    var ninfo = parent.getNumericInfo(fCurr,"<%=fLanguageId%>");
    increValue = 1 / Math.pow(10,ninfo["minFrac"]);
    // increValue = 1 / Math.pow(10,parent.numericInfo[fCurr]["<%=fLanguageId%>"]["currency"]["minFrac"]);   
  } 
  if(ranges.length>1)      
    for(var i=0; i<ranges.length-1;i++)
       aRangeDisplay[i].rangeTo=eval(parseFloat(aRangeDisplay[i+1].rangeFrom) - parseFloat(increValue)); 
  
  return aRangeDisplay;
}

</script>
<h1><%=RLPromotionNLS.get("RLAddRangeWindowTitle")%></h1>

	   <p><%=RLPromotionNLS.get("rangeToMsg")%></p>

<form name="f1" id="f1">
 	<label for="WC_RLDiscountRanges_Add_FormInput_rangefrom_In_f1_1"><%=RLPromotionNLS.get("discountRangeFrom")%> <script language="JavaScript">discountType()</script></label>
<br />
<input type="text" name='rangefrom' value="" size="10" maxlength="14" id="WC_RLDiscountRanges_Add_FormInput_rangefrom_In_f1_1" /><br /><br />
<label for="WC_RLDiscountRanges_Add_FormInput_discount_In_f1_1">
<script language="JavaScript">
if(whichDiscountType == "OrderLevelPercentDiscount")
{
	    // label should represent the percentage value for discount
		document.write("<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("discountInPercent"))%>");
}
else if (whichDiscountType == "OrderLevelValueDiscount")
{
   	 	document.write("<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("discountRate"))%>"+"("+fCurr+")");
}
</script>
</label>
<br />
<input type="text" name='discount' value="" size="10" id="WC_RLDiscountRanges_Add_FormInput_discount_In_f1_1" /><br /><br />
</form>
<p><%=RLPromotionNLS.get("currentRange")%></p>
<form name="rangeForm" id="rangeForm">
<table cellpadding="1" cellspacing="0" border="0" width="60%" bgcolor="#6D6D7C">
<tr>
<td>
<table class="list" border="0" cellpadding="0" cellspacing="0" summary='<%=RLPromotionNLS.get("discountRangeTblMsg")%>' border="1">
<tr>
   <th width="20%" id="t1" class="list_header" nowrap="nowrap">
		<%= RLPromotionNLS.get("discountRangeFrom") %>
   		<script language="JavaScript">discountType()
		</script>
   </th>
   <th width="20%" id="t2" class="list_header" nowrap="nowrap">
		<%= RLPromotionNLS.get("discountRangeTo") %>
   		<script language="JavaScript">discountType()
		</script>
   </th>

   <script language="JavaScript">
  if (whichDiscountType == "OrderLevelPercentDiscount")
   {
      document.write('<th width="20%" id="t3" class="list_header" nowrap="nowrap">'+'<%= UIUtil.toJavaScript((String)RLPromotionNLS.get("discountInPercent"))%>');
      document.write('</th>')
   }
   else if (whichDiscountType == "OrderLevelValueDiscount")
   {
      document.write('<th width="20%" id="t3" class="list_header" nowrap="nowrap">'+'<%= UIUtil.toJavaScript((String)RLPromotionNLS.get("discountRate"))%>');
      document.write("("+fCurr+")");
      document.write('</th>')
   }
       
   
</script>
</tr>

<script>  
	newRange = formatRanges(ranges,values);

   if(newRange.length>0) {
    var classId = "list_row1";
   
    for (var i=0; i < newRange.length; i++)  
      if(eval(newRange[i].rangeTo)>0)     
      {	
      
         document.writeln('<tr class='+classId+'>');
         document.writeln('<td class="list_info1" headers="t1">'  + showFormatRange(newRange[i].rangeFrom)+ '</td>');
         if(newRange[i].rangeTo==<%=RLConstants.EC_RANGE_MAX%> ) 
              document.writeln('<td class="list_info1" headers="t2">' + '<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("andUp"))%>' + '</td>');
         else	 
              document.writeln('<td class="list_info1" headers="t2">' + showFormatRange(newRange[i].rangeTo) + '</td>');
         document.writeln('<td class="list_info1" headers="t3">' + showFormatDiscount(newRange[i].discount) + '</td>');
         document.writeln('</tr>');

         if (classId == "list_row1")
            classId = "list_row2";
         else
            classId = "list_row1"
      }
   }
   
   if(newRange.length==0)
   	document.write('<p><%=UIUtil.toJavaScript((String)RLPromotionNLS.get("discountNoRanges"))%></p>');

   parent.setContentFrameLoaded(true);
   
</script>

</table></td></tr></table>
</form>
</body>
</html>

