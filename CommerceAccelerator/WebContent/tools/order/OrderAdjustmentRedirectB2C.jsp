<%--
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
//*
--%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<%@ page language="java" import="java.util.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.order.beans.*" %>
<%@ page import="com.ibm.commerce.order.objects.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.optools.order.commands.ECOptoolsConstants" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 

<%@include file="../common/common.jsp" %>


<%-- 
//---------------------------------------------------------------------
//- Method Declarion
//---------------------------------------------------------------------
--%>
<%! 
	
	

	

	
%>





<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Hashtable orderMgmtNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
String langId = cmdContextLocale.getLanguageId().toString();

TypedProperty requestProperty = (TypedProperty) request.getAttribute(ECConstants.EC_REQUESTPROPERTIES);

OrderDataBean orderBean = new OrderDataBean ();

String firstOrderId;
boolean firstOrderExist = false;
try {
	firstOrderId = (String)requestProperty.getString(ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID);
	firstOrderExist = true;
} catch (Exception ex)
{
	// first order id is not defined
	firstOrderId = "";	

}
	

String secondOrderId;
boolean secondOrderExist = false;
try {
	secondOrderId = (String)requestProperty.getString(ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID);
	secondOrderExist = true;
} catch (Exception ex)
{
	// second order id is not defined
	secondOrderId = "";	
}

if ((firstOrderId != null) && !(firstOrderId.equals(""))) {
	orderBean.setSecurityCheck(false);
	orderBean.setOrderId(firstOrderId);
	com.ibm.commerce.beans.DataBeanManager.activate(orderBean, request);
} else {
	orderBean.setSecurityCheck(false);
	orderBean.setOrderId(secondOrderId);
	com.ibm.commerce.beans.DataBeanManager.activate(orderBean, request);
}

CommandContext cmdContext = (CommandContext)request.getAttribute("CommandContext");
String localeUsed = cmdContext.getLocale().toString();
%>

<html>
<head>
  <title><%= orderMgmtNLS.get("wizardConfirmTitle") %></title>
  <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" />
    
  <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
  <script type="text/javascript" src="/wcs/javascript/tools/order/OrderMgmtUtil.js"></script>
  <script type="text/javascript" src="/wcs/javascript/tools/common/FieldEntryUtil.js"></script>
  <script type="text/javascript" src="/wcs/javascript/tools/common/Vector.js"></script>
  <script type="text/javascript">
	<!-- <![CDATA[

     var dirtyBit = false;
     var langId = <%=UIUtil.toJavaScript(langId)%>;
     
     var order = parent.get("order");
     if (!defined(order)) {
     	 order = new Object();
     	 parent.put("order", order);
      }
     
     updateEntry(order, "dirtyBit", "false");
     
      
     var currency = "<%=UIUtil.toJavaScript(orderBean.getCurrency())%>"; 
     
     
     function initializeState() {
        parent.setContentFrameLoaded(true);
     }

     function setDirtyBit(flag)
     {
        dirtyBit = flag;
     }

     function getDirtyBit()
     {
        return(dirtyBit);
     }
     
      //****************************************************************************
      //* Validate the currency that was just entered into a text box in the items
      //* table.
      //*
      //* fieldName - The name of the text field being validated.
      //*
      //* Returns a primative numeric value or "null" if the number is invalid
      //****************************************************************************~/
      function validateTotalAdjustment(fieldName)
      {
        setDirtyBit(true);
        var itemSummaryForm = orderAdjustmentContent.document.itemSummary;
        var num = itemSummaryForm[fieldName].value;
            
        if(!parent.isValidCurrency(num, currency, langId))
        {
          var str = "<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("invalidDiscountTotalMsg")) %>";
          alertDialog(str);
          return(null);
        }
        
        var number = parent.currencyToNumber(num, currency, langId);
    
        if(number < 0)
        {
          var str = "<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("discountTotalMustBePosMsg")) %>";
          alertDialog(str);
          return(null);
        }
    
        return(number);
    
      }// END validateTotalAdjustment


      //****************************************************************************
      //* Validate the shipping charge that was just entered into a text box in the
      //* items table.
      //*
      //* fieldName - The name of the text field being validated.
      //*
      //* Returns a primative numeric value or "null" if the number is invalid
      //****************************************************************************~/
      function validateShippingCharge(fieldName)
      {
        setDirtyBit(true);
        var itemSummaryForm = orderAdjustmentContent.document.itemSummary;
        var num = itemSummaryForm[fieldName].value;
    
        if(!parent.isValidCurrency(num, currency, langId))
        {
          alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("invalidShippingChargeMsg")) %>");
          return(null);
        }
        
        var number = parent.currencyToNumber(num, currency, langId);
    
        if(number < 0)
        {
          alertDialog("<%= UIUtil.toJavaScript( (String)orderMgmtNLS.get("shippingChargeMustBePosMsg")) %>");
          return(null);
        }
    
        return(number);
    
      }// END validateShippingCharge


      var isCorrect = true;
      
      //**********************************************************************
      //* Save all entries into the model.
      //*
      //* return true, if successfull; false, otherwise.
      //*********************************************************************~/
      function savePanelData()
      {
         isCorrect = orderAdjustmentContent.saveEntries();
         var authToken = parent.get("authToken");
	 if (defined(authToken)) {
		parent.addURLParameter("authToken", authToken);
	 }
         
      }// END savePanelData()
      
      function validatePanelData()
      {
         if (!isCorrect)
            return false;
            
         return true;
      }  
      //[[>-->
  </script>
</head>
<frameset rows="10%, *">
  <frame name="orderAdjustmentTitle"
    src="OrderAdjustmentTitle"
    title='<%= orderMgmtNLS.get("title") %>'
    frameborder="0"
    noresize="noresize"
    scrolling="no"
    marginwidth="15"
    marginheight="15" />
  <frame name="orderAdjustmentContent" title="<%= orderMgmtNLS.get("AdjustmentPage") %>"
	<% if (firstOrderExist && secondOrderExist) { %>
    	src="OrderAdjustmentContentB2C?<%= ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID %>=<%= firstOrderId %>&amp;<%= ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID %>=<%= secondOrderId %>"
	<% } else if (firstOrderExist) { %>
		src="OrderAdjustmentContentB2C?<%= ECOptoolsConstants.EC_OPTOOL_FIRSTORDER_ID %>=<%= firstOrderId %>"
	<% } else {%>
		src="OrderAdjustmentContentB2C?<%= ECOptoolsConstants.EC_OPTOOL_SECONDORDER_ID %>=<%= secondOrderId %>"
    <% } %>
	
    frameborder="0" 
    noresize="noresize"
    scrolling="auto" 
    marginwidth="15" 
    marginheight="0" />
  </frameset>
</html>


