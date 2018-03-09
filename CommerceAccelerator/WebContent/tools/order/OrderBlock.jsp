<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.xml.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.utils.TimestampHelper" %>
<%@ page import="com.ibm.commerce.datatype.TypedProperty" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@ include file="../common/common.jsp" %>

<%!
   public String getBlockCode(OrderBlockDataBean aBlockBean){
     String result = "";
     try{
         result = aBlockBean.getBlkRsnCodeId().toString(); 
     }catch(Exception e){
         result = "";
     }
     return result;
   }
   
   public String isResolved(OrderBlockDataBean aBlockBean){
     String result = "";
     try{
         result = aBlockBean.getResolved().toString(); 
     }catch(Exception e){
         result = "";
     }
     return result;
   }
   public String getBlockCodeType(OrderBlockDataBean aBlockBean){
     String result = "";
     try{
         result = aBlockBean.getBlockReasonCodeDB().getBlockReasonType(); 
     }catch(Exception e){
         result = "";
     }
     return result;
   }
   public String getBlockCodeDescription(OrderBlockDataBean aBlockBean){
     String result = "";
     try{
         result = aBlockBean.getBlockReasonCodeDB().getDescription(); 
     }catch(Exception e){
         result = "";
     }
     return result;
   }
   public String getComments(OrderBlockDataBean aBlockBean){
     String result = "";
     try{
         result = aBlockBean.getBlkComment(); 
     }catch(Exception e){
         result = "";
     }
     return result;
   }
%>

<%

   CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
   Locale localeUsed = cmdContext.getLocale();
   String storeId = cmdContext.getStoreId().toString();

   int numberOfList = 0; 
   // obtain the resource bundle for display
   Hashtable orderLabels = (Hashtable) ResourceDirectory.lookup("order.orderLabels", localeUsed);

   String  orderId = request.getParameter("orderId");
   
   OrderBlockListDataBean orderBlockList = new OrderBlockListDataBean();
   orderBlockList.setOrderId(orderId);
      	 
   DataBeanManager.activate(orderBlockList, request);
   
   OrderBlockDataBean[] orderBlockDBs = orderBlockList.getOrderBlockDBs();
   
   numberOfList = orderBlockDBs.length;

      
%>

<html>
<head>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(localeUsed) %>" type="text/css"/>
<script src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script src="/wcs/javascript/tools/common/Util.js"></script>
<title></title>
<script type="text/javascript">

  var list = new Array(<%=numberOfList%>);
  <%for (int i = 0; i < numberOfList; i++) {%>
	list[<%=i%>] = {orderBlockId:"<%=orderBlockDBs[i].getOrderBlockId()%>",blockCodeId:"<%=getBlockCode(orderBlockDBs[i])%>", resolved:"<%=isResolved(orderBlockDBs[i])%>"};
  <%}%>
  
  var orderId =  <%=(orderId == null ? null : UIUtil.toJavaScript(orderId))%>;
  
  function getResultsize(){
    return <%=numberOfList%>; 
  }


  function loadPages(){
    parent.loadFrames();
    if (parent.parent.setContentFrameLoaded) {
      parent.parent.setContentFrameLoaded(true);
    }
  //getSearchCriteria();
  }
  
  function add(){
     top.setContent("<%=UIUtil.toJavaScript((String) orderLabels.get("addBlockBCT"))%>",'/webapp/wcs/tools/servlet/DialogView?XMLFile=order.BlockAddDialog&amp;orderId='+orderId,true);
  }
  function comments(){
     var checkeds = new Array;
	 checkeds = parent.getChecked();
	 top.setContent("<%=UIUtil.toJavaScript((String) orderLabels.get("blockCommentBCT"))%>",'/webapp/wcs/tools/servlet/DialogView?XMLFile=order.BlockCommentsDialog&amp;orderId='+orderId + '&amp;orderBlockId=' +checkeds[0],true);
  }
  //here need to add more
  function unblock() {
    var checkeds = new Array;
    checkeds = parent.getChecked();
    top.setContent("<%=UIUtil.toJavaScript((String) orderLabels.get("unBlockBCT"))%>",'/webapp/wcs/tools/servlet/DialogView?XMLFile=order.OrderUnBlockDialog&amp;orderId='+orderId + '&amp;orderBlockId=' +checkeds[0],true);
	return true;
  }
  
  function blockSelected() {
    parent.refreshButtons();
    var checkeds = new Array;
    checkeds = parent.getChecked();
    if (checkeds.length > 1) {
      disableButton(parent.buttons.buttonForm.unblockButton);
      return;
    }
    for (var j=0; j<list.length; j++) {
      if (checkeds[0] == list[j].orderBlockId) {
         if (list[j].resolved == "1"){
	        disableButton(parent.buttons.buttonForm.unblockButton);
	     }else {
	        enableButton(parent.buttons.buttonForm.unblockButton);
	     }
	     return;
      }
    }
  }
 // code for disbling the button
  function disableButton(b) {
	if (defined(b)) {
		b.disabled=true;
		b.className='disabled';
		b.id='disabled';
	}
  }

// code for enabling the button
  function enableButton(b) {
	if (defined(b)) {
		b.disabled=false;
		b.className='enabled';
		b.id='enabled';
	}
  } 

</script>
</head>


<body class="content">



<%
          int startIndex = Integer.parseInt(request.getParameter("startindex"));
          int listSize = Integer.parseInt(request.getParameter("listsize"));
          int endIndex = startIndex + listSize;
          int rowselect = 1;
          int totalsize = numberOfList;
          int totalpage = totalsize/listSize;
     	
%>

<%=comm.addControlPanel("order.orderBlockView", totalpage, totalsize, localeUsed )%>

<form name="orderBlockForm" id="orderBlockForm1">


				
<%=comm.startDlistTable((String)orderLabels.get("orderBlockSummary")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"parent.selectDeselectAll();blockSelected();") %>

<%= comm.addDlistColumnHeading((String)orderLabels.get("blockCode"), null, false )%>

<%= comm.addDlistColumnHeading((String)orderLabels.get("blockDescription"), null, false )%>

<%= comm.addDlistColumnHeading((String)orderLabels.get("isBlockResolved"), null, false )%>

<%= comm.addDlistColumnHeading((String)orderLabels.get("blockTime"), null, false )%>

<%= comm.addDlistColumnHeading((String)orderLabels.get("blockComments"), null, false )%>

<%= comm.endDlistRow() %>

<%
    if (endIndex > numberOfList){
      endIndex = numberOfList;
    }
    for (int i=startIndex; i<endIndex ; i++){
%>

    <%
       
    %>

<%= comm.startDlistRow(rowselect) %>

<%= comm.addDlistCheck ( orderBlockDBs[i].getOrderBlockId(), "parent.setChecked();blockSelected();")%>

<%= comm.addDlistColumn( getBlockCode(orderBlockDBs[i]), "none" ) %> 

<%= comm.addDlistColumn( getBlockCodeDescription(orderBlockDBs[i]), "none" ) %> 

<%= comm.addDlistColumn( isResolved(orderBlockDBs[i]).equals("1") ? (String)orderLabels.get("orderResolved"):(String)orderLabels.get("orderNotResolved"), "none" ) %> 

<%= comm.addDlistColumn( orderBlockDBs[i].getFormattedBlockedTime(), "none" ) %> 

<%= comm.addDlistColumn( UIUtil.toHTML(getComments(orderBlockDBs[i])), "none" ) %> 

<%= comm.endDlistRow() %>


<%
  if(rowselect==1){
    rowselect = 2;
  }else{
    rowselect = 1;
  }
%>

<%
}
%>
 <%=comm.endDlistTable()%> 
<%
   if ( numberOfList < 1 ){
%>
    <br/>
<%
   String noBlock = (String)orderLabels.get("noBlockedReason");
   noBlock = noBlock.replaceFirst("%1",orderId);
%>
    <%=UIUtil.toHTML(noBlock)%>
<%
   }
%>



</form>
<script language="JavaScript">
	<!-- <![CDATA[
        <!--
        // For IE
        if (document.all) {
          loadPages();
        }
          parent.afterLoads();
          parent.setResultssize(getResultsize());
        //[[>-->

  // -->
</script>

</body>
</html>
