<%
//<!--==========================================================================
//Licensed Materials - Property of IBM
//
//WebSphere Commerce
//
//(c)  Copyright  IBM Corp.  2000      All Rights Reserved
//
//US Government Users Restricted Rights - Use, duplication or
//disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//===========================================================================-->
//
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ page import="com.ibm.commerce.utils.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.tools.ecoupon.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>

<%@include file="../common/common.jsp" %>

<script src="/wcs/javascript/tools/common/dynamiclist.js">
</script>
<script src="/wcs/javascript/tools/common/Util.js">
</script>
<%
	 CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
         Locale fLocale = cmdContext.getLocale();

         String xmlfile = request.getParameter("ActionXMLFile");
         Hashtable actionXML = (Hashtable)ResourceDirectory.lookup(xmlfile);
         Hashtable action = (Hashtable)actionXML.get("action");
	 String resourcefile = (String)action.get("resourceBundle");

         Hashtable eCouponWizardNLS = (Hashtable) ResourceDirectory.lookup(resourcefile, fLocale);
   	 String feCouponHeader =
     		"<meta http-equiv='Cache-Control' content='no-cache'>" +
     		"<meta http-equiv=expires content='fri,31 Dec 1990 10:00:00 GMT'>" +
     		"<LINK rel='stylesheet' href='" +
		UIUtil.getCSSFile(fLocale) +
     		"' type='text/css'>";
%>


<%= feCouponHeader %>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css" />

<%

	   Hashtable scrollcontrol = (Hashtable) action.get("scrollcontrol");
	   if (scrollcontrol != null){
	       String title = (String) scrollcontrol.get("title");
%>
           <title><%= UIUtil.toHTML(eCouponWizardNLS.get(title).toString())%></title>
<%
	   }
%>
<script language="JavaScript">
//global var to get the selected currency
var fCurr=parent.parent.get("eCouponCurr");

function initializeState()
{
	//
	// initialize states of the tabs of the wizard branch
	//
	if (top.getData("eCouponPageArray") != null) {
		parent.parent.pageArray = top.getData("eCouponPageArray");
		parent.parent.TABS.location.reload();
		top.saveData(null, "eCouponPageArray");
	}

  if(top.getData("category")) {
    if(purchaseConditionChange()) {
      parent.parent.put("category","");
      top.saveData("","category");
    }
    else {
      parent.parent.put("category",top.getData("category"));
    }
  }
  parent.parent.put("oldPurchaseConditionType",parent.parent.get("purchaseConditionType",null));
}

// This is function is to detemine if the user have navigate back to previous
//panel and change anything which may affect the range.
function purchaseConditionChange()
{
   if(parent.parent.get("oldPurchaseConditionType"))
   {
   	if(parent.parent.get("oldPurchaseConditionType") != parent.parent.get("purchaseConditionType")) {
	return true;
	}
   }
   return false;
}

function addCategoryAction()
{
  var categorys=new Array();
  categorys=parent.parent.get("category","");
  if(categorys.length<=15) {
     top.saveModel(parent.parent.model);
     top.saveData(categorys,"category");
     top.saveData(parent.parent.get("purchaseConditionType"),"purchaseConditionType");
     top.saveData(parent.parent.get("eCouponCurr"),"eCouponCurr");

	//
	// save the panel settings
	//
	top.saveData(parent.parent.get("storeCurrArray"), "storeCurrArray");
	top.saveData(parent.parent.get("eCouponCurrSelectedIndex"), "eCouponCurrSelectedIndex");
	top.setReturningPanel("eCouponCategoryPurchaseCondition");

	//
	// save the states of the tabs of the wizard branch
	//
	top.saveData(parent.parent.pageArray, "eCouponPageArray");

	//
	// go to the add products panels
	//
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponCategoryAdd";
	top.setContent("<%= eCouponWizardNLS.get("eCouponCategoryPurchaseCondition_title") %>", url, true);

     //parent.parent.location.replace("/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponCategoryAdd");
     parent.parent.put("visitedCategoryPurchaseForm",true);
     parent.parent.setContentFrameLoaded(true);
  }
  else {
     	parent.alertDialog('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponCategoryListTooManyMsg").toString())%>');
  }
}
function performDelete() {
	var checkedCategorys = new Array();
	checkedCategorys = parent.getChecked();

	var categorys = parent.parent.get("category","");
	var index=checkedCategorys[0];
	var newCategorys=new Array();
	for(var i=0;i<index;i++)
		newCategorys[i]=categorys[i];
	for(var i=eval(index)+1;i<categorys.length;i++)
		newCategorys[i-1]=categorys[i];

	top.saveData(newCategorys,"category");
	parent.removeEntry(index);

        parent.basefrm.location.href= "/webapp/wcs/tools/servlet/eCouponWizCategoryView?ActionXMLFile=eCoupon.eCouponCategory";
}
function onLoad() {
  parent.loadFrames();
}


</script>
<script src="/wcs/javascript/tools/common/Util.js">

</script>
<meta name="GENERATOR" content="IBM WebSphere Studio" />
</head>
<body class="content_list" onload="onLoad();">
<h1><%=eCouponWizardNLS.get("eCouponCategoryPurchaseCondition_title")%></h1>
<script language="JavaScript">
initializeState();

</script>

<form name='<%=(String)action.get("formName")%>'>
<script language="JavaScript">
startDlistTable('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryTblMsg"))%>');
startDlistRowHeading();
addDlistColumnHeading("",false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategorySKU"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMinQty"))%>'+'<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("byUnit"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMaxQty"))%>'+'<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("byUnit"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMinAmt"))%>'+'<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("byAmount"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategoryShortMaxAmt"))%>'+'<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("byAmount"))%>', null, false);
endDlistRow();
  if(eval(parent.parent.get("purchaseConditionType"))==2)
   {
      var categorys=new Array();
      var rowColor = 1;
      if(parent.parent.get("category")!=null)
      {
	categorys=parent.parent.get("category");
      	for (var i=0; i < categorys.length; i++)
      	{
		startDlistRow(rowColor);
         	addDlistCheck(i);
         	addDlistColumn(categorys[i].categorySKU);

		if ( (categorys[i].minCatQty != null) && (categorys[i].minCatQty != ""))
         	{
			addDlistColumn(categorys[i].minCatQty);
		}
		else
		{
			addDlistColumn("");
		}
		if ( (categorys[i].maxCatQty!= null) && (categorys[i].maxCatQty!= ""))
         	{
			addDlistColumn(categorys[i].maxCatQty);
		}
		else
		{
			addDlistColumn("");
		}
		if ( (categorys[i].minCatAmt!= null) && (categorys[i].minCatAmt!= ""))
         	{
			addDlistColumn(categorys[i].minCatAmt);
		}
		else
		{
			addDlistColumn("");
		}
		if ( (categorys[i].maxCatAmt!= null) && (categorys[i].maxCatAmt!= ""))
         	{
			addDlistColumn(categorys[i].maxCatAmt);
		}
		else
		{
			addDlistColumn("");
		}

		endDlistRow();
		if (rowColor == 1)
            		rowColor = 2;
         	else
            		rowColor = 1
      }
    }
  }
 endDlistTable();

</script>
</form>
<script>
var categorys=parent.parent.get("category");
if(!categorys || categorys.length==0) {
   	document.write('<p><%= UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponNoCategory")) %></p>');
     }
   parent.parent.put("visitedCategoryPurchaseForm",true);
   parent.parent.setContentFrameLoaded(true);
   parent.loadFrames();
   parent.afterLoads();
   parent.setButtonPos('0px', '44px');

</script>
</body>
</html>
