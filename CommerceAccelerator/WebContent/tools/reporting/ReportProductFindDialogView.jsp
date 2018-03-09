<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*-------------------------------------------------------------------
//*
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java"
import="com.ibm.commerce.marketingcenter.campaign.beans.SearchDataBean,
        com.ibm.commerce.marketingcenter.search.helpers.SearchProductDataBean,
        com.ibm.commerce.inventory.beans.ItemSpecSearchResultListDataBean,
        com.ibm.commerce.tools.util.ResourceDirectory,
        com.ibm.commerce.tools.util.UIUtil,
        java.util.Hashtable" %>

<%@include file="common.jsp" %>

<HTML>

<HEAD>
<%= fHeader%>

<TITLE><%= reportsRB.get("reportsFindTitle") %></TITLE>

<SCRIPT LANGUAGE="JavaScript1.2" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">

function loadPanelData() {

   var srSku   = parent.get("findPartNumberSearchString");
   var srShort = parent.get("findShortSearchString");

   var srSkuType   = parent.get("findPartNumberTypeSearchString");
   var srShortType = parent.get("findShortTypeSearchString");


   if (srSku != null)   document.productSearchForm.srSku.value   = srSku;
   if (srShort != null) document.productSearchForm.srShort.value = srShort;

   if (srSkuType != null)   document.productSearchForm.srSkuType.options[srSkuType].selected     = true;
   if (srShortType != null) document.productSearchForm.srShortType.options[srShortType].selected = true;

   if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);

}

function validateSearchSKU(s1, s2) {
   if (isEmpty(s1) && isEmpty(s2)) {
      alert("<%=UIUtil.toJavaScript((String)reportsRB.get("skuSearchCannotBeEmpty"))%>");
      return false;
   }
   return true;
}

function findProducts() {
  // get the search strings from the fields
  var srSku   = document.productSearchForm.srSku.value;
  var srShort = document.productSearchForm.srShort.value;

  var srSkuType   = document.productSearchForm.srSkuType.value;
  var srShortType = document.productSearchForm.srShortType.value;

  // put the search string back into the model in case we come back.
  parent.put("findPartNumberSearchString", srSku);
  parent.put("findShortSearchString", srShort);

  parent.put("findPartNumberTypeSearchString", srSkuType);
  parent.put("findShortTypeSearchString", srShortType);

  if (validateSearchSKU(srSku, srShort)) this.document.productSearchForm.submit();
}

function goBackToRefererURL() {
   top.goBack();
}

</SCRIPT>

</HEAD>

<BODY onload="loadPanelData()" class="content">

<FORM NAME="productSearchForm" action="NewDynamicListView" target="mcccontent" method="POST">

  <INPUT TYPE="hidden" NAME="cmd"           VALUE="ReportProductSearchView">
  <INPUT TYPE="hidden" NAME="srDir"         VALUE="1">
  <INPUT TYPE="hidden" NAME="listsize"      VALUE="10">
  <INPUT TYPE="hidden" NAME="startindex"    VALUE="0">
  <INPUT TYPE="hidden" NAME="refnum"        VALUE="0">
  <INPUT TYPE="hidden" NAME="store_rn"      VALUE="<%=reportsCommandContext.getStoreId().toString()%>">
  <INPUT TYPE="hidden" NAME="ActionXMLFile" VALUE="reporting.ProductSearchMultiple">
  <INPUT TYPE="hidden" NAME="srLocation"    VALUE="<%=SearchProductDataBean.LOCATION_WHICH%>">

  <H1><%= reportsRB.get("productFindPrompt") %></H1>

  <P><%= reportsRB.get("productFindDescription") %>
  <TABLE border=0 cellpadding=0 cellspacing=0>
     <TR>
       <TD width="75" align="left" nowrap>&nbsp;</TD>
       <TD width="210" align="left">&nbsp;</TD>
       <TD align="left">&nbsp;</TD>
     </TR>

      <TR>
         <TD></TD>
         <TD nowrap>
            <%= reportsRB.get("productFindSkuSearchString") %>
         </TD>
         <TD></TD>
      </TR>
      <TR>
         <TD></TD>
         <TD>
           <LABEL> <INPUT type=text name=srSku size=20 maxlength=64></LABEL>
         </TD>
         <TD>
            <LABEL for="srSkuType"><SELECT NAME="srSkuType" id="srSkuType">
               <OPTION VALUE="<%= ItemSpecSearchResultListDataBean.TYPE_LIKE_IGNORE_CASE %>"><%= reportsRB.get("productFindMatchesContaining") %></OPTION>
               <OPTION VALUE="<%= ItemSpecSearchResultListDataBean.TYPE_IGNORE_CASE %>"><%= reportsRB.get("productFindExactPhrase") %></OPTION>
            </SELECT></LABEL>
        </TD>
     </TR>

     <TR><TD colspan=3>&nbsp;</TD></TR>

      <TR>
         <TD></TD>
         <TD nowrap>
            <%= reportsRB.get("productFindShortDesc") %>
         </TD>
         <TD></TD>
      </TR>
      <TR>
         <TD></TD>
         <TD>
           <LABEL> <INPUT type=text name=srShort size=20 maxlength=64></LABEL>
         </TD>
         <TD>
            <LABEL for="srShortType"><SELECT NAME="srShortType" id="srShortType">
               <OPTION VALUE="<%= ItemSpecSearchResultListDataBean.TYPE_LIKE_IGNORE_CASE %>"><%= reportsRB.get("productFindMatchesContaining") %></OPTION>
               <OPTION VALUE="<%= ItemSpecSearchResultListDataBean.TYPE_IGNORE_CASE %>"><%= reportsRB.get("productFindExactPhrase") %></OPTION>
            </SELECT></LABEL>
        </TD>
     </TR>

  </TABLE>

</FORM>

</BODY>
</HTML>
