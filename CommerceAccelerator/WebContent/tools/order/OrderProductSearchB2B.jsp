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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java"
	 import="java.util.*,
	         com.ibm.commerce.server.*,
	         com.ibm.commerce.beans.*,
	         com.ibm.commerce.order.beans.*,
	         com.ibm.commerce.order.objects.*,
	         com.ibm.commerce.catalog.beans.*,
	         com.ibm.commerce.catalog.objects.*,
	         com.ibm.commerce.user.beans.*,
	         com.ibm.commerce.user.objects.*,
	         com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %> 

<%@include file="../common/common.jsp" %>

<!-- Get the resource bundle with all the NLS strings and find OrdeDataBean with order_rn -->
<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Hashtable orderMgmtNLS 	= (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("order.orderMgmtNLS", jLocale);
JSPHelper jspHelper 	= new JSPHelper(request);
String customerId	= jspHelper.getParameter("customerId");

%>

<html>
  <head>
    <link rel="stylesheet" href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css" /> 
    <title><%= orderMgmtNLS.get("addProductTitle") %></title>
  </head>
  <body class="content" onload="initializeState();">
  <h1><%=orderMgmtNLS.get("addProductTitle")%></h1>
  <p><%=orderMgmtNLS.get("findProductInst")%>    
      <script type="text/javascript" src="/wcs/javascript/tools/common/ConvertToXML.js"></script>
      <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
      <script type="text/javascript">
	  <!-- <![CDATA[
     	function trim(inString) {
		var retString = inString;
		var ch = retString.substring(0,1);
 		while(ch == " "){
 			retString=retString.substring(1,retString.length);
 			ch=retString.substring(0,1);
 		}
 		ch=retString.substring(retString.length-1,retString.length)
 		while(ch == " "){
 			retString=retString.substring(0,retString.length-1);
 			ch=retString.substring(retString.length-1,retString.length);	
		}
		return retString;
	} 	
	
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
	
      function initializeState() {
         parent.setContentFrameLoaded(true);
      }
      
      function findAllProducts()
      {
        document.itemsSearch.searchCriteria.value = 0;
        document.itemsSearch.searchString.value   = "";
        document.itemsSearch.submit();
      }
      function openDynamicList()
      {
      	var productName = document.itemsSearch.searchProductName.value;
      	var skuNumber	= document.itemsSearch.searchSKUNumber.value;
      	var searchMaxMatches = document.itemsSearch.searchMaxMatches.value;
      	
      	if ((productName == null || productName.length == 0) && (skuNumber == null || skuNumber.length == 0)) {
      		alertDialog("<%=UIUtil.toJavaScript((String)orderMgmtNLS.get("productSearchNoCriteria"))%>");
	} else {
		if ( !isNumber(searchMaxMatches) || searchMaxMatches == "0") {
			alertDialog ('<%=UIUtil.toJavaScript((String)orderMgmtNLS.get("addProductPageInvalidMaxMatches"))%>');
		} else {
	
			var searchResultURL 		= "/webapp/wcs/tools/servlet/DialogView"
			var URLParam = new Object();
			URLParam.XMLFile		="order.orderProductListDialogB2B";
			URLParam.ActionXMLFile 		="order.orderProductListB2B";
			URLParam.cmd			="OrderProductInterimB2B";
			URLParam.customerId		= "<%=customerId%>";
			URLParam.searchProductName	= productName;
			URLParam.searchSKUNumber	= skuNumber;
			URLParam.searchMaxMatches 	= searchMaxMatches;
	
			top.saveData(URLParam,"OrderProductSearchURLParam");
			top.mccmain.submitForm(searchResultURL,URLParam);
      			top.refreshBCT();
      		}
	}
	}

	function replaceField(source, pattern, replacement) {
    	    returnString = "";

    	    index1 = source.indexOf(pattern);
    	    index2 = index1 + pattern.length;
	
	    returnString += source.substring(0, index1) + replacement + source.substring(index2);
	
    	    return returnString;
	}	
	//[[>-->
    </script>
    </p><form name="itemsSearch"
          method="post"
          action="openDynamicList()"
          target="ItemsSearch">
      <table>
        
        <tr>
          <td valign="bottom" align="left">
            <label for="prodName"><%= orderMgmtNLS.get("searchForProductName") %></label><br />
            <input id="prodName" type="text" maxlength="64" name="searchProductName" />
          </td>
          
        </tr>
        <tr>
          <td valign="bottom" align="left">
            <label for="skuNum"><%= orderMgmtNLS.get("searchForSKUNumber") %></label><br />
            <input id="skuNum" type="text" maxlength="64" name="searchSKUNumber" />
         
          </td>
        </tr>
        
        <tr>
          <td valign="bottom" align="left">
            <label for="maxDisplay"><%= UIUtil.toHTML((String)orderMgmtNLS.get("addProductPageSearchMaxMatches")) %></label><br />
            <input id="maxDisplay" type="text" maxlength="6" name="searchMaxMatches" value="100" />
          </td>
        </tr>        
        
        </table> 
        
      <!--input type="hidden" name="DISPLAY" value="CTorder_mgmt.order_plcmt.SelectItemsMiddle" -->
      <input type="hidden" name="itemsSelected" value="false" />
      <script type="text/javascript">
	  <!-- <![CDATA[
        var now = new Date();
        document.writeln("<input type=hidden name='CTS' value = '" + now.getTime() + "'>");
      //[[>-->
      </script>
    </form>
  </body>
  </html>

