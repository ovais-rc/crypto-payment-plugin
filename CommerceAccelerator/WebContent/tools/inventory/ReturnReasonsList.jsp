<!--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2005
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================-->
<!--       
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2001, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>

<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.ReturnReasonDataBean" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.ReturnReasonDescriptionDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.common.objects.StoreAccessBean" %>
<%@ include file="../common/common.jsp" %>


<jsp:useBean id="returnReasonsList" scope="request" class="com.ibm.commerce.ordermanagement.beans.ReturnReasonListDataBean">
</jsp:useBean>

<%
   Hashtable vendorPurchaseListNLS = null;
   ReturnReasonDataBean returnReasons[] = null; 
   int numberOfreturnReasons = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localUsed = cmdContext.getLocale();

   Integer langId = cmdContext.getLanguageId();
   String strLangId = langId.toString(); 

   // obtain the resource bundle for display
   vendorPurchaseListNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localUsed  );

   Integer store_id = cmdContext.getStoreId();
   String storeId = store_id.toString(); 
   returnReasonsList.setStoreId(storeId); 

   DataBeanManager.activate(returnReasonsList, request);
   returnReasons = returnReasonsList.getReturnReasonDataBeans();

   if (returnReasons != null)
   {
     numberOfreturnReasons = returnReasons.length;
   }
   
   StoreAccessBean sa = cmdContext.getStore();
   String StoreType = sa.getStoreType();
   if (StoreType == null) {
     StoreType = "";
   }
   
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localUsed) %>" type="text/css">
<TITLE></TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers




function newReturnReasonCode()
{
  var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.ReturnReasonDetail";
  url += "&status=" + "new";
  url += "&rtnRsnId=";
  if (top.setContent){
    top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("returnReasonDetailTitleNew"))%>',
                       url,
                       true);

  } else {
    parent.location.replace(url);
  }
}

function changeReturnReasonCode(rowId)
{

  if (rowId == null) {
    var rowNum = parent.getChecked();
    var tokens = rowNum[0].split(",");
    var rtnRsnId = tokens[0];
  } else {
    var rtnRsnId = rowId;
  }

 
  var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=inventory.ReturnReasonDetailChange";
    url += "&status=" + "change";
    url += "&rtnRsnId=" + rtnRsnId;
  if (top.setContent){
    top.setContent('<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("returnReasonDetailTitleChange"))%>',
                       url,
                       true);

  } else {
    parent.location.replace(url);
  }

}

function deleteReturnReasons() 
{

  var checked = parent.getChecked();

  if (checked.length > 0) {
    //Set up the close list
    var rtnrsnList = "";
    
    for (var i = 0; i< checked.length; i++) {
      var tokens = checked[i].split(",");
      var rtnreasonId = tokens[0];

      rtnrsnList += "&rtnreasonId=" + rtnreasonId;
    }
      
    var confirmDelete = "<%=UIUtil.toJavaScript((String)vendorPurchaseListNLS.get("deleteReturnReason")) %>";

    if (parent.confirmDialog(confirmDelete)) {
      //delete Return Reasons
      var redirectURL = "<%="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=inventory.ReturnReasonsList&amp;cmd=ReturnReasonsListView"%>";
      var url = "/webapp/wcs/tools/servlet/ReturnReasonCodeDelete?"
                    + rtnrsnList
                    + "&URL=" + redirectURL;
      if (top.setContent) {
        top.showContent(url);
        top.refreshBCT();
      } else {
        parent.location.replace(url);
      }
    }
  }

} 

function getResultsize()
{
 return <%=numberOfreturnReasons%>; 
}

function onLoad()
{
  parent.loadFrames()
}

function getRefNum() 
{
      
}
// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content">


<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfreturnReasons;
          int totalpage = totalsize/listSize;
%>


<%=comm.addControlPanel("inventory.ReturnReasonsList", totalpage, totalsize, localUsed )%>


<FORM NAME="returnReasonsListForm">

<%=comm.startDlistTable((String)vendorPurchaseListNLS.get("vendorPurchaseTableSum")) %>

<%= comm.startDlistRowHeading() %>

<%-- //Checkbox row is automatically included --%>
<%= comm.addDlistCheckHeading() %>

<%-- //BR 13MAR2001 These next few rows get the header name from the vendorPurchaseNLS file --%>
<%--//"VendorName should be the orderby variable  if orderbyParm = true, it sorts by this--%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("reasonName"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("returnReasonColumnHeading"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("returnReasonTypeColumnHeading"), null, false  )%>


<%= comm.endDlistRow() %>

<!-- Need to have a for loop to look for all the member groups -->
<%
    ReturnReasonDataBean returnReason;
  
    if (endIndex > numberOfreturnReasons)
    {
      endIndex = numberOfreturnReasons;
    }

    for (int i=startIndex; i<endIndex ; i++)
    {
      returnReason = returnReasons[i];
      
      String rtnrsnId = returnReason.getRtnReasonId();

      String rtnrsnType = returnReason.getReasonType();
      if (rtnrsnType == null)
      {
        rtnrsnType = "";
      }
         
      if (rtnrsnType.equalsIgnoreCase("B")) {
        rtnrsnType = (String)vendorPurchaseListNLS.get("returnBoth");
      }
      if (rtnrsnType.equalsIgnoreCase("C")) {
        rtnrsnType = (String)vendorPurchaseListNLS.get("returnCustomer");
      }
      
      if (rtnrsnType.equalsIgnoreCase("M")) {
        if (StoreType.equalsIgnoreCase("B2C") || StoreType.equalsIgnoreCase("RHS") || StoreType.equalsIgnoreCase("MHS")){
          rtnrsnType = (String)vendorPurchaseListNLS.get("returnMerchant");
        } else {
          rtnrsnType = (String)vendorPurchaseListNLS.get("returnSeller");
        }
      }
            
      String code = returnReason.getCode();
      if (code == null)
      {
        code = "";
      }
      
      ReturnReasonDescriptionDataBean returnReasonDescription = new ReturnReasonDescriptionDataBean();
      
      returnReasonDescription.setDataBeanKeyLanguageId(strLangId);
      returnReasonDescription.setDataBeanKeyRtnReasonId(rtnrsnId);
      String description = null;
	  try {
      	  DataBeanManager.activate(returnReasonDescription, request);
          description = returnReasonDescription.getDescription();
      } catch (Exception ex){
      }
      
      if (description == null) {
        description = code;
      }      
      //description = UIUtil.toHTML(description) ;
%>

<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck(returnReason.getRtnReasonId(), "none" ) %>

<%= comm.addDlistColumn( UIUtil.toHTML(code), "javascript:changeReturnReasonCode('"+rtnrsnId+"');" ) %> 

<%= comm.addDlistColumn( UIUtil.toHTML(description) , "none" ) %> 

<%= comm.addDlistColumn( rtnrsnType, "none" ) %> 


<%= comm.endDlistRow() %>

<%
if(rowselect==1)
   {
     rowselect = 2;
   }else{
     rowselect = 1;
   }
%>

<%
}
%>
<%= comm.endDlistTable() %>


<%
   if ( numberOfreturnReasons == 0 ){
%>
<SCRIPT>
  document.writeln('<P>');
  document.writeln('<%= UIUtil.toJavaScript(vendorPurchaseListNLS.get("returnReasonsNoRows")) %>');
</SCRIPT>
<%
   }
%>

</FORM>
<SCRIPT>
  parent.afterLoads();
  parent.setResultssize(getResultsize());
</SCRIPT>

</BODY>
</HTML>
