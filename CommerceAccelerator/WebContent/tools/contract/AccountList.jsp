<!-- ========================================================================
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
 ===========================================================================-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">

<%@page language="java"
import="com.ibm.commerce.tools.util.UIUtil,
	com.ibm.commerce.tools.common.ui.taglibs.*,
	com.ibm.commerce.utils.TimestampHelper,
	com.ibm.commerce.beans.DataBeanManager,
	com.ibm.commerce.contract.helper.ECContractConstants,
	com.ibm.commerce.contract.util.ECContractCmdConstants,
	com.ibm.commerce.contract.util.ECContractErrorCode,
	com.ibm.commerce.account.util.ECAccountErrorCode,	
	com.ibm.commerce.tools.contract.beans.AccountListDataBean,
	com.ibm.commerce.tools.contract.beans.AccountDataBean, 
	com.ibm.commerce.common.beans.StoreDataBean" %>

<%@include file="../common/common.jsp" %>
<%@include file="ContractCommon.jsp" %>

<%
    CommandContext cmdContextLocale = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
    String orderByParm = request.getParameter("orderby");
    Integer storeId = cmdContextLocale.getStoreId();
    StoreDataBean  storeBean = new StoreDataBean();
    storeBean.setStoreId(storeId.toString());
    com.ibm.commerce.beans.DataBeanManager.activate(storeBean, request);
    
	//search parameters
	String accountSearchNameParm = request.getParameter("accountSearchName");
	String accountNameFilterParm = request.getParameter("accountNameFilter");

      // handle errors from the controller commands
      String errorStatus = request.getParameter(ECContractCmdConstants.SUBMIT_ERROR_STATUS);
      String errorMessage = null;
      if (errorStatus.length() != 0) {
      	if (errorStatus.equals(ECAccountErrorCode.EC_ERR_ACCOUNT_MARK_FOR_DELETE))
        	errorMessage = (String)contractsRB.get("accountDeleteWithActiveContractsError");      
        else
		errorMessage = (String)contractsRB.get("contractGenericActionError");
      }

	AccountListDataBean accountList;
	AccountDataBean accounts[] = null;
	int numberOfAccounts = 0;
	//set up the total number of accounts found
	int totalNumberOfAccounts = 0;
	accountList = new AccountListDataBean();

	//set parameters for  search
	if (accountSearchNameParm != null && accountSearchNameParm.trim().length() > 0) {		
		accountList.setSearchName (accountSearchNameParm);
	}
	if (accountNameFilterParm != null && accountNameFilterParm.trim().length() > 0) {
		accountList.setSearchNameFilter (accountNameFilterParm);
	}

	//get the start and list sizes from the xml file
	int startIndex = Integer.parseInt(request.getParameter("startindex"));
	int listSize = Integer.parseInt(request.getParameter("listsize"));
	int endIndex = startIndex + listSize;

	//initialize the start and end indicies
	accountList.setIndexEnd("" + endIndex);
	accountList.setIndexBegin("" + startIndex);

	DataBeanManager.activate(accountList, request);
	accounts = accountList.getAccountList();
	if (accounts != null)
	 {
	  numberOfAccounts = accounts.length;
	  totalNumberOfAccounts = accountList.getResultSetSize();
	 }

	//set up paging
	int rowselect = 1;
	int totalpage = 0;
	if (listSize != 0) {
		totalpage = totalNumberOfAccounts/listSize;
	}
%>

      <script type="text/javascript" src="/wcs/javascript/tools/common/Util.js">
</script>
      <script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js">
</script>

    <head>
      <%= fHeader %>
      <link rel="stylesheet" href="<%= UIUtil.getCSSFile(fLocale) %>" type="text/css" />

      <title><%= UIUtil.toHTML((String)contractsRB.get("accountListTitle")) %></title>

      <script type="text/javascript">

        function onLoad()
        {
          parent.loadFrames();
        }

        function getResultsSize() {
            return <%= totalNumberOfAccounts %>;
        }

        function newAccount()
        {
          top.setContent("<%=UIUtil.toJavaScript((String)contractsRB.get("accountWizardTitle"))%>",
          		 "/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.AccountNotebook&accountEdit=true", true);
        }

        function changeAccount()
        {
		var checked = parent.getChecked().toString();
		if (checked.length > 0) {
         		var parms = checked.split(',');
         		var accountId = parms[0];			
		        top.setContent("<%=UIUtil.toJavaScript((String)contractsRB.get("accountNotebookTitle"))%>",
          				"/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.AccountNotebook&accountEdit=true&accountId=" + accountId,
					true);
		}
        }

        function newContract()
        {
		var checked = parent.getChecked().toString();
		if (checked.length > 0) {
         		var parms = checked.split(',');
         		var accountId = parms[0];
         		var isBaseContract = parms[1];
         		if (isBaseContract == "true") {
		        	top.setContent("<%=UIUtil.toJavaScript((String)contractsRB.get("contractWizardTitle"))%>",
          				"/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.ContractNotebook&accountId=" + accountId + '&baseContract=true',
					true);
			} else {
		        	top.setContent("<%=UIUtil.toJavaScript((String)contractsRB.get("contractWizardTitle"))%>",
          				"/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.ContractNotebook&accountId=" + accountId + '&baseContract=false',
					true);			
			}
		}
        }

        function listContracts()
        {
		var checked = parent.getChecked().toString();
		if (checked.length > 0) {
         		var parms = checked.split(',');
         		var accountId = parms[0];
		        top.setContent("<%=UIUtil.toJavaScript((String)contractsRB.get("contractListTitle"))%>",
          				"/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=contract.ContractList&cmd=ContractListView&accountId=" + accountId,
					true);
		}
        }

        function listOrders()
        {
		var checked = parent.getChecked().toString();
		if (checked.length > 0) {
         		var parms = checked.split(',');
         		var accountId = parms[0];
		            top.setContent("<%=UIUtil.toJavaScript((String)contractsRB.get("listOrders"))%>",
          				"/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=order.csOrderListB2B&cmd=OrderListViewB2B&orderType=ORD&orderState=all&orderBy=orderId&accountId=" + accountId,
					true);
		}
        }

        function viewAccount()
        {
		var checked = parent.getChecked().toString();
		if (checked.length > 0) {
         		var parms = checked.split(',');
         		var accountId = parms[0];
			top.setContent("<%=UIUtil.toJavaScript((String)contractsRB.get("summaryBCT")) %>",
				"/webapp/wcs/tools/servlet/DialogView?XMLFile=contract.AccountSummary" +
				"&accountId=" + accountId,
				true);
		}
        }

        function reportAccount()
        {
		var checked = parent.getChecked().toString();
		if (checked.length > 0) {
         		var parms = checked.split(',');
         		var accountId = parms[0];
          		top.setContent("<%=UIUtil.toJavaScript((String)contractsRB.get("reports"))%>",
					 "/webapp/wcs/tools/servlet/ShowContextList?context=account&contextConfigXML=contract.brmReportContext&ActionXMLFile=contract.rptAccountContextList" +
					 "&accountId=" + accountId,
					 true);
		}
        }
        

	function getaccountSearchName() {
		return trim("<%= UIUtil.toJavaScript(accountSearchNameParm)%>");
	}	
	function getaccountNameFilter() {
		return trim("<%= UIUtil.toJavaScript(accountNameFilterParm)%>");
	}	
	
	function findAccount() {
		if (getaccountNameFilter() != null && getaccountNameFilter().length > 0) {		
			top.goBack();
		} else {	
			top.setContent("<%=UIUtil.toJavaScript(contractsRB.get("accountSearchTitle"))%>",
				"/webapp/wcs/tools/servlet/SearchDialogView?ActionXMLFile=contract.AccountSearchDialog",
				true);
		}
	}

        function deleteAccount()
        {
		var checked = parent.getChecked();
		if (checked.length > 0) {
			if (confirmDialog("<%= UIUtil.toJavaScript((String)contractsRB.get("accountListDeleteConfirmation")) %>")) {
            			var parms = checked[0].split(',');
           			var accountId = parms[0];
				var url = "/webapp/wcs/tools/servlet/AccountDelete?accountId=" + accountId;
				for (var i = 1; i < checked.length; i++) {
               				parms = checked[i].split(',');
               				accountId = parms[0];
					url += "&accountId=" + accountId;
				}
				url+="&redirecturl=NewDynamicListView&ActionXMLFile=contract.AccountList&cmd=AccountListView";
				//alert(url);
				parent.location.replace(url);
			}
		}
        }

        function changeAccountById(checked)
        {
		if (checked.length > 0) {
         		var parms = checked.split(',');
         		var accountId = parms[0];
		        top.setContent("<%=UIUtil.toJavaScript((String)contractsRB.get("accountNotebookTitle"))%>",
          				"/webapp/wcs/tools/servlet/NotebookView?XMLFile=contract.AccountNotebook&accountEdit=true&accountId=" + accountId,
					true);
		}
        }

        function listContractsById(checked)
        {
		if (checked.length > 0) {
         		var parms = checked.split(',');
         		var accountId = parms[0];
		        top.setContent("<%=UIUtil.toJavaScript((String)contractsRB.get("contractListTitle"))%>",
          				"/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=contract.ContractList&cmd=ContractListView&accountId=" + accountId,
					true);
		}
        }

      
</script>

    </head>

    <body class="content_list">

      <script type="text/javascript">
        <!--
        // For IE
        if (document.all) {
          onLoad();
        }
        //-->
      
</script>

      <%= comm.addControlPanel("contract.AccountList", listSize, totalNumberOfAccounts, fLocale) %>

      <form action="" name="AccountListFORM" id="AccountListFORM">
        <%= comm.startDlistTable((String)contractsRB.get("accountListSummary")) %>
        <%= comm.startDlistRowHeading() %>
        <%= comm.addDlistCheckHeading() %>
        <%= comm.addDlistColumnHeading((String)contractsRB.get("accountListCustomerColumn"),AccountListDataBean.ORDER_BY_CUSTOMER,orderByParm.equals(AccountListDataBean.ORDER_BY_CUSTOMER) ) %>
        <%= comm.addDlistColumnHeading((String)contractsRB.get("accountListRepresentativeColumn"),null, false ) %>
        <%= comm.addDlistColumnHeading((String)contractsRB.get("accountListNumberOfContractsColumn"),null,false ) %>
        <%= comm.endDlistRow() %>

          <%
	//make sure the endIndex is greater than the number of accounts
	if (endIndex > totalNumberOfAccounts) {
		endIndex = totalNumberOfAccounts;
	}
	int indexFrom = startIndex;
	for (int i = 0; i < numberOfAccounts; i++) {

	    AccountDataBean account = accounts[i];
	    String isBaseAccount = "false";
	    String accountName = account.getAccountName();
	    if (accountName != null && accountName.indexOf("BaseContracts") >= 0) {
         	isBaseAccount = "true";
	    }
          %>
        <%= comm.startDlistRow(rowselect) %>
        <%= comm.addDlistCheck( account.getAccountId() + ',' + isBaseAccount, "none" ) %>
        <%= comm.addDlistColumn( account.getCustomerName(), "javascript: changeAccountById('"+ account.getAccountId() + "')" ) %>
        <%= comm.addDlistColumn( account.getRepresentativeName(), "none" ) %>
        <%= comm.addDlistColumn( account.getNumberOfContracts(), "javascript: listContractsById('"+ account.getAccountId() + "')" ) %>
        <%= comm.endDlistRow() %>
          <%
            if (rowselect == 1) {
               rowselect = 2;
            } else {
               rowselect = 1;
            }
          }
    %>
        <%= comm.endDlistTable() %>

<% if (numberOfAccounts == 0)
   {
%>
<br /><br />
<%= contractsRB.get("accountListEmpty") %>
<%
  }
%>

      </form>

      <script type="text/javascript">
        <!--
          parent.afterLoads();
          parent.setResultssize(getResultsSize());
	  <% if (errorMessage != null) { %>
		alertDialog('<%= UIUtil.toJavaScript(errorMessage) %>');
	  <% } %>
        //-->
      
</script>

    </body>

  </html>



