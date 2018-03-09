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
         Integer fStoreId = cmdContext.getStoreId();
         String fLanguageId = cmdContext.getLanguageId().toString();
   	 String feCouponHeader =
     		"<meta http-equiv='Cache-Control' content='no-cache'>" +
     		"<meta http-equiv=expires content='fri,31 Dec 1990 10:00:00 GMT'>" +
     		"<link rel='stylesheet' href='" +
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

  if(top.getData("product")) {
    if(purchaseConditionChange()) {
      parent.parent.put("product","");
      top.saveData("","product");
    }
    else {
      parent.parent.put("product",top.getData("product"));
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

function addProductAction()
{
  var products=new Array();
  products=parent.parent.get("product","");
  if(products.length<=15) {
     top.saveModel(parent.parent.model);
     top.saveData(products,"product");
     top.saveData(parent.parent.get("purchaseConditionType"),"purchaseConditionType");
     top.saveData(parent.parent.get("eCouponCurr"),"eCouponCurr");

	//
	// save the panel settings
	//
	top.setReturningPanel("eCouponProductPurchaseCondition");

	//
	// save the states of the tabs of the wizard branch
	//
	top.saveData(parent.parent.pageArray, "eCouponPageArray");

	//
	// go to the add products panels
	//
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponProductAdd";
	top.setContent("<%= eCouponWizardNLS.get("eCouponProductPurchaseCondition_title") %>", url, true);

     parent.parent.put("visitedProductPurchaseForm",true);
     parent.parent.setContentFrameLoaded(true);
  }
  else {
     	parent.alertDialog('<%= UIUtil.toJavaScript(eCouponWizardNLS.get("eCouponProductListTooManyMsg").toString())%>');
  }
}
function performDelete() {
	var checkedProducts = new Array();
	checkedProducts = parent.getChecked();

	var products = parent.parent.get("product","");
	var index=checkedProducts[0];
	var newProducts=new Array();
	for(var i=0;i<index;i++)
		newProducts[i]=products[i];
	for(var i=eval(index)+1;i<products.length;i++)
		newProducts[i-1]=products[i];

	top.saveData(newProducts,"product");
	parent.removeEntry(index);

        parent.basefrm.location.href= "/webapp/wcs/tools/servlet/eCouponWizProductView?ActionXMLFile=eCoupon.eCouponProduct";
}
function onLoad() {
  parent.loadFrames();
}


</script>
<script src="/wcs/javascript/tools/common/Util.js">
</script>
</head>
<body class="content_list" onload="onLoad();">
<h1><%=eCouponWizardNLS.get("eCouponProductPurchaseCondition_title")%></h1>
<script language="JavaScript">
initializeState();

</script>

<form name='<%=(String)action.get("formName")%>'>
<script language="JavaScript">
startDlistTable('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponProductTblMsg"))%>');
startDlistRowHeading();
addDlistColumnHeading("",false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponProductSKU"))%>', null, false);
addDlistColumnHeading('<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponProductQty"))%>'+'<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("byUnit"))%>', null, false);
endDlistRow();
  if(eval(parent.parent.get("purchaseConditionType"))==0)
   {
      var products=new Array();
      var rowColor = 1;
      if(parent.parent.get("product")!=null)
      {
	products=parent.parent.get("product");
      	for (var i=0; i < products.length; i++)
      	{
	 	startDlistRow(rowColor);
         	addDlistCheck(i);
         	addDlistColumn(products[i].productSKU);
         	addDlistColumn(products[i].qty);
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
var products=parent.parent.get("product");
if(!products || products.length==0) {
   	document.write('<p><%= UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponNoProduct")) %></p>');
     }
   parent.parent.put("visitedProductPurchaseForm",true);
   parent.parent.setContentFrameLoaded(true);
   parent.loadFrames();
   parent.afterLoads();
   parent.setButtonPos('0px', '44px');

</script>
</body>
</html>
