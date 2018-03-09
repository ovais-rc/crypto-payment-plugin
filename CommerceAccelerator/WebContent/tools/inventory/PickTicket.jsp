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
//* ES 7/25/01 - beans integrated and working
//*-------------------------------------------------------------------
-->
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.common.beans.StoreDataBean" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.inventory.beans.PickTicketDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.PickTicketDetailDataBean" %>
<%@ page import="com.ibm.commerce.inventory.beans.PickTicketPickbatchItemDataBean" %>

<%@ include file="../common/common.jsp" %>

<%
   Hashtable FulfillmentNLS = null;

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Long userId = cmdContext.getUserId();
   Locale localeUsed = cmdContext.getLocale();
   Integer storeId = cmdContext.getStoreId();
   StoreDataBean  storeBean = new StoreDataBean();
   storeBean.setStoreId(storeId.toString());
   com.ibm.commerce.beans.DataBeanManager.activate(storeBean, request);
//   String complexOrder = "";
//   try {
//      complexOrder = storeBean.getComplexOrderStatus();
//   }catch(Exception e){
//   }

   // obtain the resource bundle for display
   FulfillmentNLS = (Hashtable)ResourceDirectory.lookup("inventory.FulfillmentNLS", localeUsed);

   String pickBatchId = request.getParameter("pickId");

   PickTicketDataBean pickTicket = new PickTicketDataBean(); 
   int numberOfPickTicketItems = 0; 
   
   //Change by wzh for defect 72373, to assign commandContext to pickTicketDataBean
   pickTicket.setCommandContext(cmdContext);
   pickTicket.setDataBeanKeyPickBatchId(pickBatchId); 

   DataBeanManager.activate(pickTicket, request);
   PickTicketDetailDataBean pickTicketDetail = pickTicket.parsePickSlipXml();

   String storeName = pickTicketDetail.getStoreName();
   String fulfillmentCenter = pickTicketDetail.getFulfillmentCenter();
   String isExpedited = pickTicketDetail.getIsExpedited();
   String expediteNLV = "";
   if (isExpedited != null && isExpedited.equals("Y")){
     	expediteNLV = (String)FulfillmentNLS.get("PSExpeditY");
   }else{
       	expediteNLV = (String)FulfillmentNLS.get("PSExpeditN");
   }

   PickTicketPickbatchItemDataBean[] pickTicketItemList = pickTicketDetail.getPickTicketPickbatchItemList();
   if (pickTicketItemList != null)
   {
     numberOfPickTicketItems = pickTicketItemList.length;
   }

   String pageTitle = UIUtil.toHTML((String)FulfillmentNLS.get("PickTicket"));

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML>
<HEAD>
<%= fHeader%>
<LINK rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css">
<TITLE></TITLE>
<H1><%=pageTitle%></H1>

<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers

 
    function onLoad()
    {
      //parent.loadFrames();

      if (parent.parent.setContentFrameLoaded) {
          parent.parent.setContentFrameLoaded(true);
      }
    }


// -->
</script>

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>

</HEAD>
<BODY ONLOAD="onLoad()" CLASS="content">



<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfPickTicketItems;
          int totalpage = totalsize/listSize;
	
%>


<FORM NAME="PickTicket">

<BR>
<b><%= UIUtil.toHTML((String)FulfillmentNLS.get("StoreName")) %></b> <%=storeName%>
<BR>
<BR>
<b><%= UIUtil.toHTML((String)FulfillmentNLS.get("FFCName")) %></b>  <%=fulfillmentCenter%>
<BR>
<BR>
<b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PickBatchID")) %></b>  <%=UIUtil.toHTML(pickBatchId)%>
<BR>
<BR>   
<b><%= UIUtil.toHTML((String)FulfillmentNLS.get("PSExpedite")) %></b>  <%=expediteNLV%> 
<BR>
<BR>


<%=comm.startDlistTable((String)FulfillmentNLS.get("PickTicket")) %>

<%= comm.startDlistRowHeading() %>

<%--//These next few rows get the header name from FulfillmentNLS file --%>
<%--//"pick batch ID should be the orderby variable  if orderbyParm = true, it sorts by this--%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PTSKU"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PTQuantity"), null, false )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PTProduct"), null, false  )%>
<%= comm.addDlistColumnHeading((String)FulfillmentNLS.get("PTDescription"), null, false  )%>

<%= comm.endDlistRow() %>


<!-- Need to have a for loop to look for all pick batches -->
<%
   PickTicketPickbatchItemDataBean pickTicketItem;
   for (int i=0; i<numberOfPickTicketItems ; i++)
   {
      pickTicketItem = pickTicketItemList[i];
      String SKU = pickTicketItem.getSKU();
      String productName = pickTicketItem.getProductName();
      String productDescription = pickTicketItem.getProductDescription();
      String quantity = pickTicketItem.getQuantity();


%>
<%=  comm.startDlistRow(rowselect) %>

<%= comm.addDlistColumn(SKU, "none" ) %>
<%= comm.addDlistColumn(quantity, "none" ) %>
<%= comm.addDlistColumn(productName, "none" ) %>
<%= comm.addDlistColumn(productDescription, "none" ) %>

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
   if ( numberOfPickTicketItems == 0 ){
%>
<br>
<%= UIUtil.toHTML((String)FulfillmentNLS.get("PTNoRows")) %>
<%
   }
%>

</FORM>
<SCRIPT LANGUAGE="JavaScript">
<!---- hide script from old browsers
  parent.afterLoads();
  // -->
</SCRIPT>

</BODY>
</HTML>
