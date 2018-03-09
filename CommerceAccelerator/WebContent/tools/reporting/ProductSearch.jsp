<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2002

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
   -------------------------------------------------------------------

 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page language="java"
        contentType="text/html;charset=utf-8"
        import="javax.servlet.*,
                java.util.Locale,
                com.ibm.commerce.tools.util.*,
		com.ibm.commerce.inventory.beans.ItemSearchResultDataBean,
		com.ibm.commerce.server.JSPHelper,
                com.ibm.commerce.tools.common.ui.taglibs.*,
                com.ibm.commerce.command.CommandContext,
                com.ibm.commerce.inventory.beans.ItemSpecSearchResultListDataBean,
                com.ibm.commerce.server.ECConstants" %>

<%@include file="common.jsp" %>

   <%-- Drop the search databean on the page --%>
   <jsp:useBean id="mySearchDataBean" scope="request" class="com.ibm.commerce.inventory.beans.ItemSpecSearchResultListDataBean">
      <jsp:setProperty name="mySearchDataBean" property="*" />
      <%-- com.ibm.commerce.beans.DataBeanManager.activate(mySearchDataBean, request); --%>
   </jsp:useBean>

   <%
     CommandContext commandContext = (CommandContext)request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
     try {
       String partNumber = request.getParameter("srSku");
       String shortDesc = request.getParameter("srShort");
       String partNumberType = request.getParameter("srSkuType");
       String shortDescType = request.getParameter("srShortType");
       Locale userLocale = commandContext.getLocale();
       mySearchDataBean.setLocale(userLocale);
       mySearchDataBean.setLanguageId(commandContext.getLanguageId().toString());
       mySearchDataBean.setStoreentId(commandContext.getStoreId().toString());
       mySearchDataBean.setShortDescription(shortDesc);
       mySearchDataBean.setShortDescriptionType(shortDescType);
       mySearchDataBean.setPartNumber(partNumber);
       mySearchDataBean.setPartNumberType(partNumberType);

       mySearchDataBean.populate();
       ItemSearchResultDataBean[] mySPLB;
       mySPLB = mySearchDataBean.getItemSearchResultList();
       int totalMatches=0;
       if (mySPLB != null) totalMatches = mySPLB.length;
   %>

<HTML lang="<%=userLocale.getLanguage()%>">
<HEAD>
   <%= fHeader %>

   <TITLE><%= reportsRB.get("ProductSearchBrowserTitle") %></TITLE>


</HEAD>

<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">

   function onLoad() {
      parent.loadFrames()
   }

   function performAdd() {

      var currElement;
      var skuArray = new Array();
      var idArray = new Array();
      for (var i=0; i<document.productSearchForm.elements.length; i++) {
         currElement = document.productSearchForm.elements[i];
         if (currElement.type == 'checkbox' && currElement.checked && currElement.name != 'select_deselect') {
	    var hiddenSku = document.productSearchForm.elements[i+1];
            skuArray[skuArray.length] = hiddenSku.value;
            idArray[idArray.length] = currElement.name;
         }
      }

      var topModel = top.getModel(1);
      topModel["productSearchSkuArray"] = skuArray;
      topModel["productSearchIdArray"] = idArray;
      top.goBack();
   }

   function performCancel() {
      var url = '/webapp/wcs/tools/servlet/DialogView?XMLFile=reporting.ProductFindDialog';
      parent.location.replace(url);
   }

</SCRIPT>

<BODY onload="JavaScript:onLoad();" class="content">

<%
   JSPHelper jspHelper = new JSPHelper(request);
   int colourIndex=1;
   int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
   int listSize   = Integer.parseInt(jspHelper.getParameter("listsize"));
   int endIndex   = startIndex + listSize;
   int totalpage  = totalMatches/listSize;

   if (endIndex >= totalMatches) endIndex = totalMatches;
%>

<%= comm.addControlPanel("reporting.ProductSearchMultiple",totalpage,totalMatches,reportsCommandContext.getLocale()) %>

<FORM NAME="productSearchForm" action="ProductSearchView" method="POST">
  <%= comm.startDlistTable((String)reportsRB.get("ProductSearchSummary")) %>

    <%= comm.startDlistRowHeading() %>
      <%= comm.addDlistCheckHeading() %>
      <%= comm.addDlistColumnHeading((String)reportsRB.get("productFindSkuSearchString"), null, false, "30%") %>
      <%= comm.addDlistColumnHeading((String)reportsRB.get("productFindShortDesc"), null, false, "70%") %>
    <%= comm.endDlistRow() %>


    <%
       for (int i=startIndex; i < endIndex; i++) {
          ItemSearchResultDataBean mySPDB = mySPLB[i];
    %>
    <%= comm.startDlistRow(colourIndex) %>
      <%= comm.addDlistCheck(UIUtil.toHTML(mySPDB.getItemSpcId()),"none") %>
      <INPUT TYPE=HIDDEN NAME="Sku" VALUE="<%=UIUtil.toHTML(mySPDB.getPartNumber())%>"> </INPUT>
      <%= comm.addDlistColumn(UIUtil.toHTML(mySPDB.getPartNumber()), "none") %>
      <%= comm.addDlistColumn(UIUtil.toHTML(mySPDB.getShortDescription()), "none") %>
    <%= comm.endDlistRow() %>


    <%
      if(colourIndex==1) {
         colourIndex = 2;
      }  else {
         colourIndex = 1;
      }
   
    %>

    <%
      } // end for
    %>


  <%= comm.endDlistTable() %>

<%
     if (totalMatches == 0) {
%>
  <P><P>
  <%= reportsRB.get("ProductSearchEmpty") %>
<%
      } // end if
%>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  parent.afterLoads();
  parent.setResultssize(<%=totalMatches%>);
  // -->
</SCRIPT>

<%
   } // endtry
   catch (Exception e) {
      out.println(e);
%>
      e.printStackTrace();
<%
   }
%>

</FORM>

<SCRIPT LANGUAGE="JavaScript">
<!--
//For IE
if (document.all) {
  onLoad();
}
//-->
</SCRIPT>

</BODY>
</HTML>
