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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page language="java"
	 import="java.util.*,
	         com.ibm.commerce.server.*,
	         com.ibm.commerce.beans.*,
	         com.ibm.commerce.common.beans.*,
	         com.ibm.commerce.order.beans.*,
	         com.ibm.commerce.order.objects.*,
	         com.ibm.commerce.catalog.beans.*,
	         com.ibm.commerce.catalog.objects.*,
	         com.ibm.commerce.user.beans.*,
	         com.ibm.commerce.user.objects.*,
	         com.ibm.commerce.tools.contract.beans.*,
	         com.ibm.commerce.fulfillment.objects.*" %>
<%@ page import="com.ibm.commerce.command.CommandContext" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.user.beans.UserRegistrationDataBean" %>

<%@include file="../common/common.jsp" %>
<%@include file="../common/NumberFormat.jsp" %>

<!-- Get the resource bundle with all the NLS strings and find OrdeDataBean with order_rn -->
<%
CommandContext cmdContextLocale = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
Locale jLocale = cmdContextLocale.getLocale();
Hashtable returnsNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
String jLanguageID = cmdContextLocale.getLanguageId().toString();
JSPHelper jspHelper = new JSPHelper(request);

	String memberId = jspHelper.getParameter("memberId");
	String preCustomerLogonId = "";
	if ( memberId != null && !memberId.equals("") && !memberId.equals("null"))
	{
		UserRegistrationDataBean userReg = new UserRegistrationDataBean();
		userReg.setDataBeanKeyMemberId(memberId);
		com.ibm.commerce.beans.DataBeanManager.activate(userReg, request);
		preCustomerLogonId = userReg.getLogonId();
	}
	
	StoreDataBean store = new StoreDataBean();
	store.setStoreId(cmdContextLocale.getStoreId().toString());
	com.ibm.commerce.beans.DataBeanManager.activate(store, request);
	boolean isB2B = store.getStoreType() != null && (store.getStoreType().equals("B2B") || store.getStoreType().equals("BRH") || store.getStoreType().equals("BMH"));

%>

<HTML>
  <head>
      <link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 
  </head>
  <BODY CLASS=content ONLOAD="initializeState();">
  <H1><%=returnsNLS.get("addProductTitle")%></H1>
  <P><%=returnsNLS.get("ordItemAndProductSearchPageInst")%>    
      <script src="/wcs/javascript/tools/common/ConvertToXML.js"></script>
      <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
      <script>
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
	var searchResultURL 		= "/webapp/wcs/tools/servlet/DialogView"
	var URLParam = new Object();
	URLParam.XMLFile		="returns.returnItemListDialog";
	URLParam.ActionXMLFile 		="returns.returnItemList";
	URLParam.cmd			="ReturnItemSearchInterim";
	URLParam.itemsSelected		="false";

        if ( document.itemsSearch.searchOrdersOrCatalog[0].checked ) {
           URLParam.searchOrdersOrCatalog = document.itemsSearch.searchOrdersOrCatalog[0].value;
           if ((document.itemsSearch.searchOrderNumber.value == "") && (document.itemsSearch.searchCustomerLogonId.value == "") && (document.itemsSearch.searchAccountId.value == "")) {
              alertDialog("<%= UIUtil.toJavaScript(returnsNLS.get("searchNoCriteria")) %>");
              return;
           } 
           else if ((document.itemsSearch.searchOrderNumber.value != "") && !isNumber(document.itemsSearch.searchOrderNumber.value)) { 
	         alertDialog("<%= UIUtil.toJavaScript((String)returnsNLS.get("orderNumberNotValidNumber")) %>");
             return;
           }
        } 
        else if ( document.itemsSearch.searchOrdersOrCatalog[1].checked ) {
           URLParam.searchOrdersOrCatalog = document.itemsSearch.searchOrdersOrCatalog[1].value;
           if ((document.itemsSearch.searchProductName.value == "") && (document.itemsSearch.searchSKUNumber.value == "") && (document.itemsSearch.searchShortDesc.value == "")) {
              alertDialog("<%= UIUtil.toJavaScript(returnsNLS.get("searchNoCriteria")) %>");
              return;
           }
        } 
        else {
           alertDialog("<%= UIUtil.toJavaScript(returnsNLS.get("searchNoSelection")) %>");
           return;
        }

	if (validateLength(document.itemsSearch.searchProductName.value, 64))
		URLParam.searchProductName	= document.itemsSearch.searchProductName.value;
	else {
		document.itemsSearch.searchProductName.focus();
		return;
	}
		
	if (validateLength(document.itemsSearch.searchSKUNumber.value, 64))
		URLParam.searchSKUNumber	= document.itemsSearch.searchSKUNumber.value;
	else {
		document.itemsSearch.searchSKUNumber.focus();
		return;
	}
		
	if (validateLength(document.itemsSearch.searchShortDesc.value, 254))
		URLParam.searchShortDesc	= document.itemsSearch.searchShortDesc.value;
	else {
		document.itemsSearch.searchShortDesc.focus();
		return;
	}

	URLParam.searchOrderNumber	= document.itemsSearch.searchOrderNumber.value;
	if (validateLength(document.itemsSearch.searchCustomerLogonId.value, 31))
		URLParam.searchCustomerLogonId	= document.itemsSearch.searchCustomerLogonId.value;
	else {
		document.itemsSearch.searchCustomerLogonId.focus();
		return;
	}
	URLParam.searchAccountId	= document.itemsSearch.searchAccountId.value;
	
	URLParam.listsize		="11";
	URLParam.startindex		="0";
	URLParam.refnum			="0";
	
	top.saveData(URLParam,"OrderProductSearchURLParam");
	top.mccmain.submitForm(searchResultURL,URLParam);
      	top.refreshBCT();
      }
      
      function clearFields(id) {
	if (id == "searchOrdersFields") {
       	   document.itemsSearch.searchProductName.value = "";
       	   document.itemsSearch.searchSKUNumber.value = "";
       	   document.itemsSearch.searchShortDesc.value = "";
       	} else if (id == "searchCatalogFields") {
       	   document.itemsSearch.searchOrderNumber.value = "";
       	   document.itemsSearch.searchCustomerLogonId.value = "";
       	   document.itemsSearch.searchAccountId.value = "";       	          	   
       	}       	
      }
      
      function clickRadioButton(id) {      	
      	if (id == "searchOrdersFields") {
       	   document.itemsSearch.searchOrdersOrCatalog[0].checked = "true";
       	} else if (id == "searchCatalogFields") {
       	   document.itemsSearch.searchOrdersOrCatalog[1].checked = "true";
       	}
       	
       	clearFields(id);       	
      }
      function isNumber(word) {
	    var numbers="0123456789";
	    for (var i=0; i < word.length; i++)
	    {
		  if (numbers.indexOf(word.charAt(i)) == -1) 
		  return false;
	    }
	    return true;
      }
      function validateLength(text, size) {	
	if (!isValidUTF8length(text, size))
	{
		alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("TextExceedMaxLengthMsg")) %>");
		return false;		
	}
	return true;
      }
      
    </script>
    <form name="itemsSearch"
          method=post
          action="openDynamicList()"
          target="ItemsSearch">

      <table>
        <tr>
          <td valign="bottom" align="left">
            <input type="radio" name="searchOrdersOrCatalog" id="searchOrdersOrCatalog" value="searchOrders" onclick="clearFields('searchOrdersFields')" CHECKED>
            <label for="searchOrdersOrCatalog"><%= returnsNLS.get("searchOrders") %></label><br>
          </td>          
        </tr>
      </table>
<DIV ID="searchOrdersArea" STYLE="display:block;">
      <table>
        <tr>
          <td valign="bottom" align="left">
            &nbsp;&nbsp;&nbsp;&nbsp;<label for="searchOrderNumber"><%= returnsNLS.get("orderItemSearchOrderNumber") %></label><br>
            &nbsp;&nbsp;&nbsp;&nbsp;<input type="text" maxlength="19" name="searchOrderNumber" id="searchOrderNumber" onclick="clickRadioButton('searchOrdersFields')">
          </td>
        </tr>
        <tr>
          <td valign="bottom" align="left">
            &nbsp;&nbsp;&nbsp;&nbsp;<label for="searchCustomerLogonId"><%= returnsNLS.get("searchCustomerLogonId") %></label><br>
            &nbsp;&nbsp;&nbsp;&nbsp;<input type="text" maxlength="31" name="searchCustomerLogonId" id="searchCustomerLogonId" value="<%=preCustomerLogonId%>" onclick="clickRadioButton('searchOrdersFields')">
          </td>
        </tr>
<% if (isB2B) { %>
        <tr>
          <td valign="bottom" align="left">
            &nbsp;&nbsp;&nbsp;&nbsp;<label for="searchAccountId"><%= returnsNLS.get("searchAccountName") %></label><br>
            &nbsp;&nbsp;&nbsp;&nbsp;<select name="searchAccountId" id="searchAccountId" onclick="clickRadioButton('searchOrdersFields')">
            &nbsp;&nbsp;&nbsp;&nbsp;<option value="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%
	// find all accounts
	AccountListDataBean accountListDB = new AccountListDataBean();
	com.ibm.commerce.beans.DataBeanManager.activate(accountListDB, request);
	AccountDataBean[] accountDBArray = accountListDB.getAccountList();
	for (int i=0; i < accountDBArray.length; i++) {
		AccountDataBean anAccount = (AccountDataBean) accountDBArray[i];
		String anAccountName = anAccount.getAccountName();
%>
	&nbsp;&nbsp;&nbsp;&nbsp;<option value="<%=anAccount.getAccountId()%>"><%=anAccountName%>
<%		
	}
%>
          </td>
        </tr>
<% } else { %>
	<INPUT TYPE=hidden name="searchAccountId" value="">
<% } %>
      </table>
</DIV>
      <table>
        <tr>
          <td valign="bottom" align="left">
            <input type="radio" name="searchOrdersOrCatalog" id="searchOrdersOrCatalog" value="searchCatalog" onclick="clearFields('searchCatalogFields')">
            <label for="searchOrdersOrCatalog"><%= returnsNLS.get("searchCatalog") %></label><br>
            <SCRIPT>
              var returnWizardModel = top.getModel(1);
              if (returnWizardModel.customerId == "" || returnWizardModel.customerId == null) {
                document.itemsSearch.searchOrdersOrCatalog[1].disabled = true;
              }
	    </SCRIPT>
          </td>          
        </tr>
      </table>
<DIV ID="searchCatalogArea" STYLE="display:none;">
      <table>
        <tr>
          <td valign="bottom" align="left">
            &nbsp;&nbsp;&nbsp;&nbsp;<label for="searchProductName"><%= returnsNLS.get("searchProductName") %></label><br>
            &nbsp;&nbsp;&nbsp;&nbsp;<input type="text" maxlength="64" name="searchProductName" id="searchProductName" onclick="clickRadioButton('searchCatalogFields')">
          </td>
          
        </tr>
        <tr>
          <td valign="bottom" align="left">
            &nbsp;&nbsp;&nbsp;&nbsp;<label for="searchSKUNumber"><%= returnsNLS.get("searchSKUNumber") %></label><br>
            &nbsp;&nbsp;&nbsp;&nbsp;<input type="text" maxlength="64" name="searchSKUNumber" id="searchSKUNumber" onclick="clickRadioButton('searchCatalogFields')">
          </td>
        </tr>
        <tr>
          <td valign="bottom" align="left">
            &nbsp;&nbsp;&nbsp;&nbsp;<label for="searchShortDesc"><%= returnsNLS.get("searchShortDesc") %></label><br>
            &nbsp;&nbsp;&nbsp;&nbsp;<input type="text" maxlength="254" name="searchShortDesc" id="searchShortDesc" onclick="clickRadioButton('searchCatalogFields')">
          </td>
        </tr>
      </table> 
</DIV>

<SCRIPT>
  if (returnWizardModel.customerId != "" && returnWizardModel.customerId != null) {
	document.all["searchCatalogArea"].style.display = "block";
  }
</SCRIPT>
        
      <input type="hidden" name="itemsSelected" value="false">
      <script>
        var now = new Date();
        document.writeln("<input type=hidden name='CTS' value = '" + now.getTime() + "'>");
      </script>
    </form>
  </body>
  </html>

