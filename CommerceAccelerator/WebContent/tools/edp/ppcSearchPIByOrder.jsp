<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<%//---------------------------------------------------------------------
    //- Import and Include Section
    //---------------------------------------------------------------------
%>

<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.math.*"%>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*"%>
<%@ page import="com.ibm.commerce.server.*"%>
<%@ page import="com.ibm.commerce.command.CommandContext"%>
<%@ page import="com.ibm.commerce.tools.util.UIUtil"%>
<%@ page import="com.ibm.commerce.payment.ppc.beans.*"%>
<%@ page import="com.ibm.commerce.payments.plugincontroller.PaymentInstruction"%>
<%@include file="../common/common.jsp"%>
<%@include file="../common/NumberFormat.jsp"%>
<%@include file="ppcUtil.jsp"%>


<%--
//---------------------------------------------------------------------
//- Logic Section
//---------------------------------------------------------------------
--%>
<%// obtain the resource bundle for display
    CommandContext cmdContextLocale = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    Locale jLocale = cmdContextLocale.getLocale();
    Integer langId = cmdContextLocale.getLanguageId();
    String storeId = cmdContextLocale.getStoreId().toString();
    String currency = cmdContextLocale.getCurrency();
    Hashtable ppcLabels = (Hashtable) ResourceDirectory.lookup("edp.ppcLabels", jLocale);
	
	//d200239: refer to order msg
	Hashtable orderLabels = (Hashtable)ResourceDirectory.lookup("order.orderLabels", jLocale);
	
    JSPHelper jspHelper = new JSPHelper(request);

    String searchOrderId = request.getParameter("orderId").trim();
    // get standard list parameters
    PPCListPIsForOrderDataBean piList = new PPCListPIsForOrderDataBean();

    if (searchOrderId.length() > 1) {
        piList.setOrderId(searchOrderId);
        piList.setStoreId(storeId);
        com.ibm.commerce.beans.DataBeanManager.activate(piList, request);
    } else {

        piList.setPaymentInstructionList(new ArrayList());
    }

    String xmlFile = "edp.ppcSearchPIDialog";

    %>
<html>
<head>
<link rel="stylesheet" href="<%=UIUtil.getCSSFile(jLocale)%>"
	type="text/css" />
<title><%=ppcLabels.get("title")%></title>

<script src="/wcs/javascript/tools/common/Util.js"></script>
<script src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script language="JavaScript" type="text/javascript">
<!-- <![CDATA[	
	
//---------------------------------------------------------------------
//  Required javascript function for dynamic list
//---------------------------------------------------------------------
    function onLoad()
    {
    	
      parent.loadFrames();
    }

	function getResultsSize() {
		return <%=piList.getPaymentInstructionList().size()%>;
	}
//---------------------------------------------------------------------
//  user defined javascript functions 
//---------------------------------------------------------------------

	function isNumber(word)
	{
	   	var numbers="0123456789";
	   	var word=trim(word);
		for (var i=0; i < word.length; i++)
		{
			if (numbers.indexOf(word.charAt(i)) == -1) 
			return false;
		}
		return true;
	}

     function findAction() {
     		
     			//validate order number
			if (!isEmpty(document.ppcListPIsForOrder.orderId.value)) {
				if (!isNumber(document.ppcListPIsForOrder.orderId.value)) {
					alertDialog ('<%=UIUtil.toJavaScript((String)orderLabels.get("findDialogInvalidNumber"))%>');
					return false;
				}   
			}else{
				alertDialog('<%=UIUtil.toJavaScript((String)orderLabels.get("findDialogNoCriteria"))%>');
				return false;
			}
     		
			var url = "/webapp/wcs/tools/servlet/NewDynamicListView";
			url+="?ActionXMLFile=edp.ppcSearchPIDialog&amp;cmd=ppcSearchPIByOrderView&amp;orderId=";
			url+= document.ppcListPIsForOrder.orderId.value;
			
			parent.location.replace(url);
	}
	
	function findPayment(){
    	
    	var tokens = parent.getSelected().split(",");
		var piId = tokens[0];
	
      	var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=edp.ppcListPaymentsForPI&amp;cmd=ppcListPaymentsForPIView";
        
    	url += "&piId=" + piId;
          	
      if (top.setContent)
      { 	 
         top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("ListPaymentTitle"))%>", url, true);

      }else{
      	
        parent.location.replace(url);
      }
    }

//[[>-->
</script>
</head>

<body onload="onLoad()" class="content">
<!--JSP File name :ppcListPIsForOrder.jsp -->
<%
	int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
    int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
    int endIndex = startIndex + listSize;
    int rowselect = 1;

    int totalsize = piList.getPaymentInstructionList().size();
    int totalpage = totalsize / listSize;

    int actualSize = listSize;
    if (totalsize < listSize) {
        actualSize = totalsize;
    }
%>
<script language="JavaScript" type="text/javascript">
	
	
	var orderId = <%=(searchOrderId == null ? null : UIUtil.toJavaScript(searchOrderId))%>;
    
     function findCredit(){
        var tokens = parent.getSelected().split(",");
		var piId = tokens[0];	
	
      	var url="/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=edp.ppcListCreditsForPI&amp;cmd=ppcListCreditsForPIView";
        
    	url += "&piId=" + piId;
          	
      if (top.setContent)
      { 	 
         top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("ListCreditTitle"))%>", url, true);

      }else{      	
        parent.location.replace(url);
      }
     }
  
	function showExtendedData(){
     	
     	var tokens = parent.getSelected().split(",");
		var piId = tokens[0];
	
      	var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=edp.ppcPIExtendedDialog";
        
    	url += "&orderId="+orderId + "&piId=" + piId;
        	
      	if (top.setContent)
      	{ 	 
       	  top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("extendedData"))%>", url, true);
	
      	}else{      	
      	  parent.location.replace(url);
      	}
     
     }
     
     	function editExtendedData(){
     	
     	var tokens = parent.getSelected().split(",");
		var piId = tokens[0];
	
      	var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=edp.ppcEditPIExtDataDialog";
        
    	url += "&orderId="+orderId + "&piId=" + piId;
        	
      	if (top.setContent)
      	{ 	 
       	  top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("extendedData"))%>", url, true);
	
      	}else{      	
      	  parent.location.replace(url);
      	}
     
     }


	function viewPI(){
		
		var tokens = parent.getSelected().split(",");
		var piId = tokens[0];
	
      	var url="/webapp/wcs/tools/servlet/DialogView?XMLFile=edp.ppcPISummary";
        
    	url += "&piId=" + piId+"&orderId="+orderId;
        
      if (top.setContent)
      {
         top.setContent("<%=UIUtil.toHTML((String) ppcLabels.get("PISummary"))%>", url, true);

      }else{
      	
        parent.location.replace(url);
      }
	}
</script>

<%=comm.addControlPanel(xmlFile, totalpage, totalsize, jLocale)%>
<form name='ppcListPIsForOrder'><label for='orderId'><%=UIUtil.toHTML((String) ppcLabels.get("orderId"))%></label>
<input name="orderId" id="orderId" type="text" maxlength="256" onkeypress='if(event.keyCode==13) return false;'></input>
<button name="search" type="button" onclick="findAction();">
<%=(String) ppcLabels.get("findButton")%></button>
<br/><br/>
<%=comm.startDlistTable("OrderPIListTableSummary")%> <%=comm.startDlistRowHeading()%>
<%=comm.addDlistCheckHeading()%> <%=comm.addDlistColumnHeading((String) ppcLabels.get("payInstId"), null, false, null, false)%>
<%=comm.addDlistColumnHeading((String) ppcLabels.get("state"), null, false, null, false)%>
<%=comm.addDlistColumnHeading((String) ppcLabels.get("amount"), null, false, null, false)%>
<%=comm.addDlistColumnHeading((String) ppcLabels.get("approvedAmount"), null, false, null, false)%>
<%=comm.addDlistColumnHeading((String) ppcLabels.get("approvingAmount"), null, false, null, false)%>
<%=comm.addDlistColumnHeading((String) ppcLabels.get("depositedAmount"), null, false, null, false)%>
<%=comm.addDlistColumnHeading((String) ppcLabels.get("depositingAmount"), null, false, null, false)%>
<%=comm.addDlistColumnHeading((String) ppcLabels.get("creditedAmount"), null, false, null, false)%>
<%=comm.addDlistColumnHeading((String) ppcLabels.get("creditingAmount"), null, false, null, false)%>

<%=comm.endDlistRow()%>
<%
	if (endIndex > piList.getListSize()) {
        endIndex = piList.getListSize();
    }

    // TABLE CONTENT

    for (int i = startIndex; i < endIndex; i++) {
        int state = piList.getPIListData(i).getState();
        String statue = (String) ppcLabels.get(converterStateOfPI(state));
        String amount = getFormattedAmount(piList.getPIListData(i).getAmount(), currency, langId, storeId);
        String approvedAmount = getFormattedAmount(piList.getPIListData(i).getApprovedAmount(), currency, langId, storeId);
        String approvingAmount = getFormattedAmount(piList.getPIListData(i).getApprovingAmount(), currency, langId, storeId);
        String depositedAmount = getFormattedAmount(piList.getPIListData(i).getDepositedAmount(), currency, langId, storeId);
        String depositingAmount = getFormattedAmount(piList.getPIListData(i).getDepositingAmount(), currency, langId, storeId);
        String creditedAmount = getFormattedAmount(piList.getPIListData(i).getCreditedAmount(), currency, langId, storeId);
        String creditingAmount = getFormattedAmount(piList.getPIListData(i).getCreditingAmount(), currency, langId, storeId);

        %>
<%=comm.startDlistRow(rowselect)%>
<%=comm.addDlistCheck(piList.getPIListData(i).getId().toString(), "none")%>
<%=comm.addDlistColumn(piList.getPIListData(i).getId(), "none")%>
<%=comm.addDlistColumn(statue, "none")%>
<%=comm.addDlistColumn(amount, "none")%>
<%=comm.addDlistColumn(approvedAmount, "none")%>
<%=comm.addDlistColumn(approvingAmount, "none")%>
<%=comm.addDlistColumn(depositedAmount, "none")%>
<%=comm.addDlistColumn(depositingAmount, "none")%>
<%=comm.addDlistColumn(creditedAmount, "none")%>
<%=comm.addDlistColumn(creditingAmount, "none")%>
<%=comm.endDlistRow()%>
<%
	if (rowselect == 1) {
    	rowselect = 2;
    } else {
    	rowselect = 1;
    }

}%> 
<%=comm.endDlistTable()%> 
<%
	if (piList.getListSize() == 0) {
%>

<p></p>
<p></p>
<table cellspacing="0" cellpadding="3" border="0">
	<tr>
		<td colspan="7"><%=(String) ppcLabels.get("noPaymentInstructionToList")%></td>
	</tr>
</table>
<%
	}
%></form>

<script>
   parent.afterLoads();
   parent.setResultssize(<%=totalsize%>);
	parent.setButtonPos("0px", "40px");
</script>

</body>
</html>


