<!-- ==========================================================================
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
 ===========================================================================-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page language="java"
import="com.ibm.commerce.tools.ecoupon.ECECouponConstant,
	com.ibm.commerce.tools.util.ResourceDirectory,
	com.ibm.commerce.tools.util.UIUtil,
	java.util.Hashtable" %>

<%@include file="eCouponCommon.jsp" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<%= feCouponHeader%>

<title><%= eCouponWizardNLS.get("eCouponCategoryFind") %></title>

<script language="JavaScript1.2" src="/wcs/javascript/tools/common/Util.js">
</script>
<script language="JavaScript">

function loadPanelData() {
	// prefill the find input box if the user entered
	// something on the previous screen.
	document.categorySearchForm.srSku.value = "<%=UIUtil.toJavaScript( request.getParameter("srSku") )%>";
	document.categorySearchForm.srName.value = "<%=UIUtil.toJavaScript( request.getParameter("srName") )%>";
	document.categorySearchForm.srShort.value = "<%=UIUtil.toJavaScript( request.getParameter("srShort") )%>";
	if ("<%=UIUtil.toJavaScript( request.getParameter("srSkuType") )%>" != "") {
		document.categorySearchForm.srSkuType.options["<%=UIUtil.toJavaScript( request.getParameter("srSkuType") )%>"].selected = true;
	}
	if ("<%=UIUtil.toJavaScript( request.getParameter("srNameType") )%>" != "") {
		document.categorySearchForm.srNameType.options["<%=UIUtil.toJavaScript( request.getParameter("srNameType") )%>"].selected = true;
	}
	if ("<%=UIUtil.toJavaScript( request.getParameter("srShortType") )%>" != "") {
		document.categorySearchForm.srShortType.options["<%=UIUtil.toJavaScript( request.getParameter("srShortType") )%>"].selected = true;
	}
	document.categorySearchForm.srSku.focus();

   if (parent.setContentFrameLoaded) {
      parent.setContentFrameLoaded(true);
   }
}

function validateSearchSKU(s1, s2, s3) {
   if (isEmpty(s1) && isEmpty(s2) && isEmpty(s3)) {
      alertDialog("<%=UIUtil.toJavaScript((String)eCouponWizardNLS.get("eCouponCategorySearchEmpty"))%>");
      return false;
   }
   return true;
}

function findCategorys() {
  // get the search strings from the fields
  //alertDialog(" inside find categorys");
  var skuSearchString   = document.categorySearchForm.srSku.value;
  var nameSearchString  = document.categorySearchForm.srName.value;
  var shortSearchString = document.categorySearchForm.srShort.value;

  var skuSearchStringType   = document.categorySearchForm.srSkuType.value;
  var nameSearchStringType  = document.categorySearchForm.srNameType.value;
  var shortSearchStringType = document.categorySearchForm.srShortType.value;

  // create the base url
  if (validateSearchSKU(skuSearchString, nameSearchString, shortSearchString)) {
		var url = "/webapp/wcs/tools/servlet/NewDynamicListView";
		var urlparm = new Object();
		urlparm.ActionXMLFile = "eCoupon.eCouponCategorySearch";
		urlparm.cmd = "eCouponCategorySearchView";
		urlparm.store_rn = "<%= commContext.getStoreId().toString() %>";
		urlparm.srLocation = "2";
		urlparm.srSku = skuSearchString;
		urlparm.srName = nameSearchString;
		urlparm.srShort = shortSearchString;
		urlparm.srSkuType = skuSearchStringType;
		urlparm.srNameType = nameSearchStringType;
		urlparm.srShortType = shortSearchStringType;
		top.setContent("<%= eCouponWizardNLS.get("eCouponCategorySearchBrowserTitle") %>", url, false, urlparm);
  }
  //alertDialog("done with findCategorys");
}

function goBackToRefererURL() {
  // get the return URL
//  var goBackURL = top.getData("finderReturnURL");

//  if (goBackURL != null) {
//      parent.location.replace(goBackURL);
//  }
//  else {
      // if we don't have a URL, send an alert
      // alertDialog("Referer URL not specified- Throwing back to Category Add");
//      parent.location.replace("/webapp/wcs/tools/servlet/DialogView?XMLFile=eCoupon.eCouponCategoryAdd");
//  }

	top.goBack();
}


</script>

</head>

<body onload="loadPanelData()" class="content">

<form name="categorySearchForm" id="categorySearchForm">

  <h1><%= eCouponWizardNLS.get("eCouponCategoryFindPrompt") %></h1>

  <p><%= eCouponWizardNLS.get("eCouponCategoryFindDescription") %>
  </p><table border="0" cellpadding="0" cellspacing="0" id="WC_eCouponCategoryFindPanel_Table_1">
     <tr>
       <td width="75" align="left" nowrap ="nowrap"id="WC_eCouponCategoryFindPanel_TableCell_1">&nbsp;</td>
       <td width="210" align="left" id="WC_eCouponCategoryFindPanel_TableCell_2">&nbsp;</td>
     </tr>


     <tr valign="bottom">
       <td id="WC_eCouponCategoryFindPanel_TableCell_3"></td>
       <td width="210" align="left" nowrap ="nowrap"id="WC_eCouponCategoryFindPanel_TableCell_4">
          <label for="srSku"><%= eCouponWizardNLS.get("eCouponCategoryFindSkuSearchString") %></label><br />
          <input type="text" name="srSku" size="20" maxlength="64" id="srSku" />
       </td>
	<td id="WC_eCouponCategoryFindPanel_TableCell_5">
	  <label for="srSkuType"></label>
	  <select name="srSkuType" id="srSkuType">
	    <option value="<%= ECECouponConstant.TYPE_LIKE_IGNORE_CASE %>"><%= eCouponWizardNLS.get("eCouponCategoryFindMatchesContaining") %></option>
	    <option value="<%= ECECouponConstant.TYPE_IGNORE_CASE %>"><%= eCouponWizardNLS.get("eCouponCategoryFindExactPhrase") %></option>
	  </select>
	</td>
     </tr>

     <tr><td colspan="4" id="WC_eCouponCategoryFindPanel_TableCell_6">&nbsp;</td></tr>

     <tr valign="bottom">
       <td id="WC_eCouponCategoryFindPanel_TableCell_7"></td>
       <td width="210" align="left" nowrap ="nowrap"id="WC_eCouponCategoryFindPanel_TableCell_8">
          <label for="srName"><%= eCouponWizardNLS.get("eCouponCategoryFindName") %></label><br />
          <input type="text" name="srName" size="20" maxlength="64" id="srName" />
       </td>
	<td id="WC_eCouponCategoryFindPanel_TableCell_9">
	  <label for="srNameType"></label>
	  <select name="srNameType" id="srNameType">
	    <option value="<%= ECECouponConstant.TYPE_LIKE_IGNORE_CASE %>"><%= eCouponWizardNLS.get("eCouponCategoryFindMatchesContaining") %></option>
	    <option value="<%= ECECouponConstant.TYPE_IGNORE_CASE %>"><%= eCouponWizardNLS.get("eCouponCategoryFindExactPhrase") %></option>
	  </select>
	</td>
     </tr>

     <tr><td colspan="4" id="WC_eCouponCategoryFindPanel_TableCell_10">&nbsp;</td></tr>

     <tr valign="bottom">
       <td id="WC_eCouponCategoryFindPanel_TableCell_11"></td>
       <td width="210" align="left" nowrap ="nowrap"id="WC_eCouponCategoryFindPanel_TableCell_12">
          <label for="srShort"><%= eCouponWizardNLS.get("eCouponCategoryFindShortDesc") %></label><br />
          <input type="text" name="srShort" size="20" maxlength="64" id="srShort" />
       </td>
	<td id="WC_eCouponCategoryFindPanel_TableCell_13">
	  <label for="srShortType"></label>
	  <select name="srShortType" id="srShortType">
	    <option value="<%= ECECouponConstant.TYPE_LIKE_IGNORE_CASE %>"><%= eCouponWizardNLS.get("eCouponCategoryFindMatchesContaining") %></option>
	    <option value="<%= ECECouponConstant.TYPE_IGNORE_CASE %>"><%= eCouponWizardNLS.get("eCouponCategoryFindExactPhrase") %></option>
	  </select>
	</td>
     </tr>
  </table>

</form>
<script>
parent.setContentFrameLoaded(true);

</script>
</body>
</html>
