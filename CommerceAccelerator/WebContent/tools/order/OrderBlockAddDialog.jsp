
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%> 
<%@ page language="java"%>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@include file="../common/common.jsp" %>
<%!
  public String getDescription(BlockReasonCodeDataBean bldCodeBean){
     String result="";
     try{
       result = bldCodeBean.getBlkRsnCodeId().toString();
       String description = bldCodeBean.getDescription();
       result += " ";
       if (description != null){
          result += description;
       }
     }catch(Exception e){
       result = "";
     }
     return result;
  }
%>
<!-- Get the resource bundle with all the NLS strings -->
<%
  CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
  Locale jLocale = cmdContextLocale.getLocale();
  Hashtable orderLabels = (Hashtable) ResourceDirectory.lookup("order.orderLabels", jLocale);
  String  orderId = request.getParameter("orderId");
  
  BlockReasonCodeDataBean aBlkCodeBean = new BlockReasonCodeDataBean();
  com.ibm.commerce.beans.DataBeanManager.activate(aBlkCodeBean, request);

  BlockReasonCodeDataBean[] blkCodeDBs = aBlkCodeBean.getAllManualBlockReasonCode();
  OrderBlockListDataBean anOrderBlockDB = new OrderBlockListDataBean();
  anOrderBlockDB.setOrderId(orderId);
  com.ibm.commerce.beans.DataBeanManager.activate(anOrderBlockDB, request);
  OrderBlockDataBean[] blkedCodeDBs = anOrderBlockDB.getOrderBlockDBs();
  HashMap availBlockCodeMap = new HashMap();
  for (int i=0; i<blkCodeDBs.length; i++){
      availBlockCodeMap.put(blkCodeDBs[i].getBlkRsnCodeId(),getDescription(blkCodeDBs[i]));
  }
  for (int i=0; i<blkedCodeDBs.length; i++){
    if (availBlockCodeMap.containsKey(blkedCodeDBs[i].getBlkRsnCodeId())){
      availBlockCodeMap.remove(blkedCodeDBs[i].getBlkRsnCodeId().toString()); 
    }
  }
%>


<html>
<head>
<script src="/wcs/javascript/tools/common/Util.js"></script>

<link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"/>
<script language="JavaScript">
<!-- <![CDATA[
  var orderId=<%=(orderId == null ? null : UIUtil.toJavaScript(orderId))%>;
  
  function onLoad(){
    parent.setContentFrameLoaded(true);
  }
  
  function addBlock(){
    var blockCode = document.orderBlock.orderBlockReason.value;
    if (blockCode == null || blockCode == ""){
         alertDialog("<%=UIUtil.toJavaScript((String) orderLabels.get("noBlockReason"))%>");
        return false;
    }
    var urlParams = new Object();
    var url = "/webapp/wcs/tools/servlet/BlockNotify";
    urlParams.orderId=<%=(orderId == null ? null : UIUtil.toJavaScript(orderId))%>;
    urlParams.notifyBlock = 'true';
    urlParams.reasonCodeId = blockCode;
    urlParams.blockOrUnblockComments = document.orderBlock.commentsField.value;
    urlParams.URL = "/webapp/wcs/tools/servlet/OrderBlockRedirect";
    top.setContent("",url,false,urlParams);
  }
  
  	function closeDialog()
	{
  		top.goBack();
	}
       function submitFinishHandler (finishMessage)
   {
        alertDialog(convertFromTextToHTML(finishMessage));
	submitCancelHandler();
   }

   function submitCancelHandler()
   {
     if (top.goBack) {
       top.goBack();
     } 
   }          
// -->
//[[>-->
</script>
</head>

<body class="content" onload="onLoad();">

<h1><%= UIUtil.toHTML((String)orderLabels.get("addBlockTitle")) %> </h1>

<table>
		<tr>
			<td align="left"><%= UIUtil.toHTML((String)orderLabels.get("orderBlockOrderNumber")) %><%= UIUtil.toHTML((String)orderLabels.get("orderSummaryDetLabelTextSeparator")) %></td>
			<td><i><%= UIUtil.toHTML(orderId) %></i></td>
		</tr>
</table>


<form name="orderBlock" id="orderBlock">
  <table>
      <tr>
        <td><label for="orderBlockReason1"><%= orderLabels.get("orderBlcokDescription") %></label></td>
      </tr>
      <tr>
        <td>
            <select name="orderBlockReason" id="orderBlockReason1">
      		    <!-- here need use new listdatabean -->
  <%
    Integer tempBlockCode;
    for (Iterator ite = availBlockCodeMap.keySet().iterator();ite.hasNext();){
       tempBlockCode = (Integer)ite.next();
  %>    		   
      	   <option value=<%= tempBlockCode %>><%= (String)availBlockCodeMap.get(tempBlockCode) %></option>
  <%}%>
      	    </select>	
        </td>
    </tr>
  </table> 
  <p/>
  <label for="commentsField"><%= orderLabels.get("orderBlockComments") %></label><br /><br />
  <textarea name="commentField" rows="7" cols="60" id="commentsField"></textarea>
</form>
</body>
</html>

