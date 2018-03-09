<!--
//********************************************************************
//*-------------------------------------------------------------------
//*Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright International Business Machines Corporation. 2002
//*     All rights reserved.
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*--------------------------------------------------------------------
-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<!-- Generic JSP for all components -->

<%@ page import="com.ibm.commerce.utils.*" %>

<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.*" %>

<%@ page import="javax.servlet.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.lang.reflect.*" %>

<%@include file="epromotionCommon.jsp" %>
<head>
<script src="/wcs/javascript/tools/common/dynamiclist.js">
</script>

<!-- Get user bean -->
<%
     String xmlfile = request.getParameter("ActionXMLFile");
     Hashtable actionXML = (Hashtable)ResourceDirectory.lookup(xmlfile);
     Hashtable action = (Hashtable)actionXML.get("action");
%>

<!-- user javascript function include here -->
<!-- javascript function defined in XML will be included in parent frame -->


<title><%= UIUtil.toHTML(RLPromotionNLS.get("RLDiscountRangeTitle").toString())%></title>
<%= fPromoHeader %>

<script language="JavaScript">
//global var to get the selected currency
var fCurr=parent.parent.getCurrency();
var discountNothingDefinedMsg="<%= UIUtil.toJavaScript((String)RLPromotionNLS.get("discountNothingDefined"))%>";
var newRange=new Array();
var ranges=new Array();
var values=new Array();
var whichDiscountType = null;
var calCodeId = null;
var o = parent.parent.get("<%= RLConstants.RLPROMOTION %>", null);
if (o != null) {
	whichDiscountType = o.<%= RLConstants.RLPROMOTION_TYPE %>;
	calCodeId = o.<%= RLConstants.EC_CALCODE_ID %>;
}

function initializeState()
{
   // check if comes from add or modify page or delete cmd
   if(top.getData("RLDiscountRanges") && top.getData("RLDiscountValues"))
   {
    ranges=top.getData("RLDiscountRanges");
    values=top.getData("RLDiscountValues");
    top.saveData(null,"RLDiscountRanges");
    top.saveData(null,"RLDiscountValues");
    var o = parent.parent.get("<%= RLConstants.RLPROMOTION %>", null);
    if (o != null) {
	   o.<%= RLConstants.RLPROMOTION_RANGES %> = ranges;
	   o.<%= RLConstants.RLPROMOTION_VALUES %> = values;
    }	
   }else if(parent.parent.get("<%= RLConstants.RLPROMOTION %>"))
   {
	var o = parent.parent.get("<%= RLConstants.RLPROMOTION %>", null);
	if (o != null) {
	   ranges = o.<%= RLConstants.RLPROMOTION_RANGES %>;
	   values = o.<%= RLConstants.RLPROMOTION_VALUES %>;
	}	
   }
   
    // check range start from 0
	var hasMin = false;
	//if(ranges.length >=2)
	if(ranges.length >=2 && eval(values[0]) == 0)
	{
		hasMin = true;
	}

   if (eval(ranges[0])>0)
   {
    hasMin = true;
    for(var i=ranges.length;i>0;i--)
    {
      ranges[i]=ranges[i-1];
      values[i]=values[i-1];
    }
    ranges[0]=0;
    values[0]=0;    
   }
   // check ranges after remove
   if (ranges.length == 1)
   {
    hasMin = false;
   }
   
   // initialize ranges and values, these values are always existing if come from previous entry page.
   newRange=formatRanges(ranges,values);
     
  //save the current info
  parent.parent.put("oldPromType",o.<%= RLConstants.RLPROMOTION_TYPE %>);
  
   //update panel tab
if( calCodeId == null || calCodeId == '')
{
	  if(parent.parent.getPanelAttribute("RLDiscountWizardRanges","hasTab")=="NO")
	  {
	    parent.parent.pageArray=top.getData("RLRangePageArray");
	  } 

	  if ((hasMin && (ranges.length >2)) || (!hasMin && (ranges.length>1)) ) {
	    parent.parent.setPreviousPanel("RLPromotionProperties");
	      parent.parent.setPanelAttribute( "RLDiscountPercentType", "hasTab", "NO" );
	      parent.parent.setPanelAttribute( "RLDiscountFixedType", "hasTab", "NO" );
	  } else if (whichDiscountType == "OrderLevelPercentDiscount") {
	      parent.parent.setPanelAccess("RLDiscountPercentType", true);
	      parent.parent.setPanelAttribute( "RLDiscountPercentType", "hasTab", "YES" );
	      parent.parent.setPanelAttribute( "RLDiscountFixedType", "hasTab", "NO" );
	      parent.parent.setPreviousPanel("RLDiscountPercentType");
	  } else if (whichDiscountType == "OrderLevelValueDiscount") {
	      parent.parent.setPanelAttribute( "RLDiscountPercentType", "hasTab", "NO" );
	      parent.parent.setPanelAccess("RLDiscountFixedType", true);
	      parent.parent.setPanelAttribute( "RLDiscountFixedType", "hasTab", "YES" );
  	      parent.parent.setPreviousPanel("RLDiscountFixedType");
	  }
	  parent.parent.setPanelAttribute( "RLDiscountWizardRanges", "hasTab", "YES" );
	  parent.parent.TABS.location.reload();

}  //end of if calCodeId
else
{
	 if ((hasMin && (ranges.length >2)) || (!hasMin && (ranges.length>1)))
	 {
	   if (whichDiscountType == "OrderLevelPercentDiscount")
	   {
	      parent.parent.setPanelAttribute( "RLDiscountPercentType", "hasTab", "NO" );
	   }  else if (whichDiscountType == "OrderLevelValueDiscount")
	   {
	      parent.parent.setPanelAttribute( "RLDiscountFixedType", "hasTab", "NO" );
	   }	
	 }
	 else
	 { 
	   if (whichDiscountType == "OrderLevelPercentDiscount")
	   {
	      parent.parent.setPanelAttribute( "RLDiscountPercentType", "hasTab", "YES" );
	   }  else if (whichDiscountType == "OrderLevelValueDiscount")
	   {
	      parent.parent.setPanelAttribute( "RLDiscountFixedType", "hasTab", "YES" );
	   }	
	 }
	 parent.parent.setPanelAttribute( "RLDiscountWizardRanges", "hasTab", "YES" );
	 parent.parent.TABS.location.reload();
}

	if (parent.parent.get("discountNotDefined", false)) {
		parent.parent.remove("discountNotDefined");
		parent.alertDialog(discountNothingDefinedMsg);
		return;
	}
}

// This is function is to detemine if the user have navigate back to previous
// panel and change the promotion type which may affect the range. -- 5.1
// This function may not be used because if the range changed, the user has to go through the previous
// Fixed or Percent page anyway. -- rule based
function rangeChange()
{
	var rlPromotionType = null;
	var o = parent.parent.get("<%= RLConstants.RLPROMOTION %>", null);
	if (o != null) {
	rlPromotionType = o.<%= RLConstants.RLPROMOTION_TYPE %>;
	}

   if(parent.parent.get("oldPromType"))
    	if(eval(parent.parent.get("oldPromType"),"")!=eval(rlPromotionType))
    		return true;
   return false;
}

function addRangeAction()
{
  if(ranges.length<=15){
	top.saveModel(parent.parent.model);
	top.saveData(ranges,"RLDiscountRanges");
	top.saveData(values,"RLDiscountValues");
	top.saveData(whichDiscountType,"RLRangeType");
	top.saveData(fCurr,"RLDiscCurr");
	if( calCodeId == null || calCodeId == '')
	{
	top.saveData(parent.parent.pageArray, "RLRangePageArray");
	}
	top.showContent("/webapp/wcs/tools/servlet/DialogView?XMLFile=RLPromotion.RLRangeAdd&calcodeId="+calCodeId);
		
   	parent.parent.setContentFrameLoaded(true);
    	
    }
    else
    	parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("rangeTooManyMsg").toString())%>');
}


function performDelete() {

	var index= parent.getChecked();
  
  if(eval(ranges[index])==0){
	// can not delete first row a time
		parent.alertDialog('<%= UIUtil.toJavaScript(RLPromotionNLS.get("cannotRemove").toString())%>');
	 	return;
	}
	 
	var tempRange=new Array();
	var tempValue=new Array();
	// rebuild ranges
	for(var i=0;i<eval(index.toString());i++)
  	tempRange[i]=ranges[i];
	for(var i=eval(index.toString())+1;i<ranges.length;i++)
	 	tempRange[i-1]=ranges[i];
	// rebuild values
	for(var i=0;i<eval(index.toString());i++)
  	tempValue[i]=values[i];
	for(var i=eval(index.toString())+1;i<values.length;i++)
	 	tempValue[i-1]=values[i];
	 	
	 	parent.removeEntry(index);
	
	top.saveData(tempRange,"RLDiscountRanges");
	top.saveData(tempValue,"RLDiscountValues");
    parent.basefrm.location.href="/webapp/wcs/tools/servlet/RLDiscountWizRangesView?ActionXMLFile=RLPromotion.RLDiscountRange&calcodeId="+calCodeId;  
  
}

function modifyRangeAction()
{
  if (parent.parent.isInsideMC()) { 
	var index=parent.getChecked();
	top.saveModel(parent.parent.model);
	
	top.saveData(ranges,"RLDiscountRanges");
	top.saveData(values,"RLDiscountValues");
	top.saveData(whichDiscountType,"RLRangeType");
	top.saveData(fCurr,"RLDiscCurr");
	top.saveData(eval(index.toString()),"RLModifyRangeIndex");
	if( calCodeId == null || calCodeId == '')
	{
	top.saveData(parent.parent.pageArray, "RLRangePageArray");
	}
	top.showContent("/webapp/wcs/tools/servlet/DialogView?XMLFile=RLPromotion.RLRangeModify&calcodeId="+calCodeId);
		
   	parent.parent.setContentFrameLoaded(true);
}
  
}

//format the ranges in the frame 
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
  if ((whichDiscountType == "OrderLevelPercentDiscount")||(whichDiscountType == "OrderLevelValueDiscount")) 
  {
    // increValue = 1 / Math.pow(10,parent.parent.numericInfo[fCurr]["<%=fLanguageId%>"]["currency"]["minFrac"]);    
    var ninfo = parent.parent.getNumericInfo(fCurr,"<%=fLanguageId%>");
    increValue = 1 / Math.pow(10,ninfo["minFrac"]);
  } 
    if(ranges.length>1)      
    {
	    for(var i=0; i<ranges.length-1;i++)
	    {
	       aRangeDisplay[i].rangeTo=eval(parseFloat(aRangeDisplay[i+1].rangeFrom) - parseFloat(increValue)); 
	    }
	}    
  return aRangeDisplay;
}


function onLoad() {
  parent.loadFrames()
}

function pageTop(){
  if ((whichDiscountType == "OrderLevelPercentDiscount")||(whichDiscountType == "OrderLevelValueDiscount")) {
	  // rate type is quantity
	  document.write('<P><%=UIUtil.toJavaScript((String)RLPromotionNLS.get("discountRangesInstruction2"))%>&nbsp;');
	} else
	{
	  // rate type is dolloar
	  document.write('<P><%=UIUtil.toJavaScript((String)RLPromotionNLS.get("discountRangesInstruction1"))%>&nbsp;');
	} 
	
	document.write('<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("discountRangesInstruction3"))%></P>');
}

function discountType()
{
  // var whichDiscountType = parent.parent.get("<%= RLConstants.RLPROMOTION_TYPE %>");
  if((whichDiscountType == "OrderLevelPercentDiscount")||(whichDiscountType == "OrderLevelValueDiscount"))
    return "("+fCurr+")";
  else
    return '<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("byUnit"))%>';
}

function showFormatRange(range){
  if ((whichDiscountType == "OrderLevelPercentDiscount")||(whichDiscountType == "OrderLevelValueDiscount")) {
	   // This is the order level pricing
	   return parent.parent.numberToCurrency(range.toString(),fCurr,"<%=fLanguageId%>");
	}
  else {
  // this is a product level quantity
  return parent.parent.numberToStr(range.toString(),"<%=fLanguageId%>",0);	   
  }
}

function showFormatDiscount(d){
	var o = parent.parent.get("<%= RLConstants.RLPROMOTION %>", null);
	if (o != null) {
		if (o.<%= RLConstants.RLPROMOTION_TYPE %>=="OrderLevelPercentDiscount")
			  // Changed for defect 179712
		      return d.toString();
		else if (o.<%= RLConstants.RLPROMOTION_TYPE %>=="OrderLevelValueDiscount")
		      return parent.parent.numberToCurrency(d.toString(),fCurr,"<%=fLanguageId%>");
		else 
		      return d;
	}
}

//added by murali.
function validatePanelData()
{
    var o = parent.parent.get("<%= RLConstants.RLPROMOTION %>", null);
    if (o != null) {
	   ranges=o.<%= RLConstants.RLPROMOTION_RANGES %>;
	    if(ranges.length==0)
	    {
		  parent.alertDialog(discountNothingDefinedMsg);
	        return false;
    	    }
	    else
	    {
		return true;
	    }
	}
}


</script>
<script src="/wcs/javascript/tools/common/Util.js">
</script>
<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>
<body class="content">
<script language="JavaScript">
<!--
//For IE
if (document.all) {
    onLoad();
}
//-->

</script>

<h1><%=RLPromotionNLS.get("RLDiscountRangeTitle")%></h1>

<script language="JavaScript">
initializeState();
pageTop();

</script>
<form name='<%=(String)action.get("formName")%>'><script
	language="JavaScript">
  startDlistTable('<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("discountRangeTblMsg"))%>');
  startDlistRowHeading();
  addDlistCheckHeading(false);
  addDlistColumnHeading(""+'<%= UIUtil.toJavaScript((String)RLPromotionNLS.get("discountRangeFrom")) %>'+"&nbsp;"+discountType(),false,"35%");
  addDlistColumnHeading(""+'<%= UIUtil.toJavaScript((String)RLPromotionNLS.get("discountRangeTo")) %>'+"&nbsp;"+discountType(),false,"35%");
    
  var o = parent.parent.get("<%= RLConstants.RLPROMOTION %>", null);
  if (o != null) {
	  if (o.<%= RLConstants.RLPROMOTION_TYPE %>=="OrderLevelPercentDiscount")
	  {
      	addDlistColumnHeading('<%= UIUtil.toJavaScript((String)RLPromotionNLS.get("discountInPercent"))%>',false,"30%");
	  }
	  else if (o.<%= RLConstants.RLPROMOTION_TYPE %>=="OrderLevelValueDiscount")
	  {
      	addDlistColumnHeading(""+'<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("discountRate"))%>'+"&nbsp;("+fCurr+")",false,"30%");
	  }
  }	
	  endDlistRow();
  
  if(newRange.length>0)
  {
      var rowColor = 1;

      for (var i=0; i < newRange.length; i++)
      if(eval(newRange[i].rangeTo)>0)      
      {
         startDlistRow(rowColor);
         addDlistCheck(i);
         addDlistColumn(showFormatRange(newRange[i].rangeFrom));
         
         if(newRange[i].rangeTo==<%=RLConstants.EC_RANGE_MAX%> )
           addDlistColumn('<%=UIUtil.toJavaScript((String)RLPromotionNLS.get("andUp"))%>');           
         else
           addDlistColumn(showFormatRange(newRange[i].rangeTo));
         addDlistColumn(showFormatDiscount(newRange[i].discount)); 
         
         endDlistRow();

         if (rowColor == 1)
            rowColor = 2;
         else
            rowColor = 1         
      }
      
   }
   endDlistTable();

</script></form>
<script>   
   if(newRange.length=0)
   	document.write('<p><%=UIUtil.toJavaScript((String)RLPromotionNLS.get("discountNoRanges"))%></p>');
      
  //parent.parent.put("visitedWizRange",true);
		
   parent.parent.setContentFrameLoaded(true);
    parent.afterLoads();
    parent.setButtonPos('0px','85px');

</script>

</body>
</html>
