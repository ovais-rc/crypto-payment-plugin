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
<%@ page import="com.ibm.commerce.inventory.beans.ExpectedInventoryRecordReceiptDataBean" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ include file="../common/common.jsp" %>


<jsp:useBean id="vendorPOReceivedList" scope="request" class="com.ibm.commerce.inventory.beans.ExpectedInventoryRecordReceiptListDataBean">
</jsp:useBean>

<%
   Hashtable vendorPurchaseListNLS = null;
   
   ExpectedInventoryRecordReceiptDataBean vendorPOs[] = null; 
   int numberOfReceivedPOs = 0; 

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();

   // obtain the resource bundle for display
   vendorPurchaseListNLS = (Hashtable)ResourceDirectory.lookup("inventory.VendorPurchaseNLS", localeUsed  );

   
   String strRaDetailId = request.getParameter("raDetailId");
   vendorPOReceivedList.setRaDetailId(strRaDetailId);
   
   DataBeanManager.activate(vendorPOReceivedList, request);
   vendorPOs = vendorPOReceivedList.getExpectedInventoryRecordReceiptList();

   if (vendorPOs != null)
   {
     numberOfReceivedPOs = vendorPOs.length;
   }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>

<HEAD>

<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<TITLE></TITLE>


<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
function getResultsize(){
     return <%=numberOfReceivedPOs%>; 
}

   function onLoad()
    {
      parent.loadFrames()
    }

    
// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>



</HEAD>

<BODY onload="onLoad()" CLASS="content">


<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfReceivedPOs;
          int totalpage = totalsize/listSize;
%>


<%-- // Building Menu  --%>
<%=comm.addControlPanel("inventory.VendorPurchase", totalpage,totalsize,localeUsed)%>


<FORM NAME="ReceivedPOForm">

<%=comm.startDlistTable((String)vendorPurchaseListNLS.get("vendorPurchaseTableSum")) %>

<%= comm.startDlistRowHeading() %>


<%-- //AF 3APRIL2001 These next few rows get the header name from the vendorPurchaseNLS file --%>

<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("receiptNumber"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("receiptDate"), null, false  )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("qtyReceived"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("comment1"), null, false )%>
<%= comm.addDlistColumnHeading((String)vendorPurchaseListNLS.get("comment2"), null, false )%>


<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all the member groups -->
<%
    ExpectedInventoryRecordReceiptDataBean vendorPO;
  
    if (endIndex > numberOfReceivedPOs)
      {endIndex = numberOfReceivedPOs;
      }

    for (int i=startIndex; i<endIndex ; i++) 
    {
      vendorPO = vendorPOs[i];
      String ReceiptDate = vendorPO.getReceiptDate();
            String formattedReceiptDate = null;
            if (ReceiptDate == null){
               formattedReceiptDate = "";
            }else{
               Timestamp tmp_ReceiptDate = Timestamp.valueOf(ReceiptDate);
               formattedReceiptDate = TimestampHelper.getDateFromTimestamp(tmp_ReceiptDate, localeUsed );
	}

      
%>

<%=  comm.startDlistRow(rowselect) %>


<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getReceiptId()), "none" ) %> 
<%= comm.addDlistColumn( UIUtil.toHTML(formattedReceiptDate), "none" ) %> 
<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getQtyReceived()), "none" ) %> 
<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getComment1()), "none" ) %> 
<%= comm.addDlistColumn( UIUtil.toHTML(vendorPO.getComment2()), "none" ) %> 

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
   if ( numberOfReceivedPOs == 0 ){
%>
<br>
<%= UIUtil.toHTML((String)vendorPurchaseListNLS.get("vendorReceivedPONoRows")) %>
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
