<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2001, 2016
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.ibm.commerce.command.*"%>
<%@ page import="com.ibm.commerce.tools.util.ResourceDirectory" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ordermanagement.beans.*" %>
<%@ page import="com.ibm.commerce.server.JSPHelper" %>
<%@ page import="com.ibm.commerce.tools.common.ECToolsConstants" %>
<%@ page import="com.ibm.commerce.ordermanagement.objects.ReturnReasonAccessBean" %>
<%@ page import="com.ibm.commerce.ordermanagement.commands.ReturnEditBeginCmd" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@include file="../common/common.jsp" %>

<HTML>
<HEAD>
<%!
  public boolean availbleReturnCode(Integer storeId, Integer storeGroupId){
    Enumeration defaultReason = null;
    try {
    	defaultReason = new ReturnReasonDataBean().findByStoreentIdsForCustomer(storeId, storeGroupId);
    }catch (Exception e) {
    	    defaultReason = null;
    }
    if (defaultReason == null || !defaultReason.hasMoreElements()){
        return false;
    }
    return true;
  }
%>

<%
    try {
        CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
        Locale jLocale = cmdContext.getLocale();
      	Hashtable returnsNLS = (Hashtable)ResourceDirectory.lookup("returns.ReturnsNLS", jLocale);
      	
      	Integer storeId= cmdContext.getStoreId();
      	Integer storeGroupId = cmdContext.getStore().getStoreGroupIdInEntityType();
      	
	    JSPHelper jspHelper = new JSPHelper(request);
	    String inUse = "N";
	    String policyId = "";
	    String edit = jspHelper.getParameter("edit");
	    String rmaMemberId = "";
	    if ((edit != null) && (edit.equals("true"))) {
		    String returnId = jspHelper.getParameter("returnId");
      	 	RMADataBean RMADB = new RMADataBean();
      		RMADB.setRmaId(returnId);
		    com.ibm.commerce.beans.DataBeanManager.activate(RMADB, request);
		    if (RMADB.isLocked()){
			    inUse = "Y";
			}
		    policyId = RMADB.getPolicyId();
		
		    rmaMemberId = RMADB.getMemberId();
	    }
	
%>

<link rel=stylesheet href="<%= UIUtil.getCSSFile(jLocale) %>" type="text/css"> 

<SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT src="/wcs/javascript/tools/common/FieldEntryUtil.js"></SCRIPT>
<SCRIPT>

var prev = parent.get("prev");
var next = parent.getCurrentPanelAttribute("name");

function getXML() {
	return parent.modelToXML("XML");
}

function getRedirectURL() {
	if (next == "ReturnItemsPage") {
		return "/webapp/wcs/tools/servlet/RMANewDynamicListView?ActionXMLFile=returns.returnItemsPage&cmd=ReturnItemsPage&edit=" + parent.get("edit") + "&returnId=" + getReturnId() + "&customerId=" + getCustomerId();
	} else if (next == "ReturnCommentsPage") {
		return "/webapp/wcs/tools/servlet/ReturnComments?returnId="+getReturnId();
	} else if (next == "ReturnCreditMethodPage") {
		return "/webapp/wcs/tools/servlet/ReturnCreditMethod?returnId="+getReturnId();
	} else if (next == "ReturnConfAndAdjustPage") {
		return "/webapp/wcs/tools/servlet/ReturnConfirmation?returnId="+getReturnId() + "&returnPolicyId="+ getReturnPolicyId();
		
	}
}

function getReturnPolicyId()
{
   var policyId = parent.get("refundPolicyId");
   return policyId;
}


function getReturnId()
{
	var returnId = parent.get("returnId");
	if (!defined(returnId))
	{
	   returnId = "";
	}
	return returnId;
}

function getOrderIds()
{
	var orderIds = parent.get("selectedOrders");
	if (!defined(orderIds))
   		return null;
	return orderIds;
}


function getCustomerId()
{
	var customerId = parent.get("customerId");
	if (!defined(customerId))
   		return null;
	return customerId;
}



function callCSRReturnItemUpdate() 
{
        var preCommand = "/webapp/wcs/tools/servlet/CSRReturnItemUpdate";

	document.formToSubmit.action=preCommand;
	document.formToSubmit.URL.value = getRedirectURL();
	document.formToSubmit.XML.value = getXML();
	document.formToSubmit.submit();
}


function callCSRReturnPrepare() 
{
	var preCommand = "/webapp/wcs/tools/servlet/CSRReturnPrepare";

	document.formToSubmit.action=preCommand;
	document.formToSubmit.URL.value = getRedirectURL();
	document.formToSubmit.XML.value = getXML();
	document.formToSubmit.submit();
}


function callCSRReturnUpdate() 
{
	var preCommand = "/webapp/wcs/tools/servlet/CSRReturnUpdate";
	
	document.formToSubmit.action=preCommand;
	document.formToSubmit.URL.value = getRedirectURL();
	document.formToSubmit.XML.value = getXML();
	document.formToSubmit.submit();
}


function setInUseInModel()
{
	parent.put("inUse","<%=inUse%>");
}

function setCustomerIdInModel()
{
	var memberIdForCustomerInCSAContext = parent.get("memberIdForCustomerInCSAContext");
	
	
	if ( memberIdForCustomerInCSAContext != null && memberIdForCustomerInCSAContext != "" )
	{
		//edit return launched from Find Customer -> Customer List -> Returns -> Find Returns -> Returns List
		//return changes on behalf of customer selected in Customer List
		parent.put("customerId", memberIdForCustomerInCSAContext);
	}
	else
	{
		//edit return launched from Find Returns -> Returns List
		//return changes on behalf of owner of the rma
		parent.put("customerId", "<%=rmaMemberId%>");
	}
}


function setPolicyIdInModel()
{
	parent.put("refundPolicyId","<%=policyId%>");
}


function callCSRReturnCreateCopy() 
{
	var preCommand = "/webapp/wcs/tools/servlet/CSRReturnCreateCopy";

	document.formToSubmit.action=preCommand;
	document.formToSubmit.URL.value = getRedirectURL();
	document.formToSubmit.XML.value = getXML();
	document.formToSubmit.submit();
}


function determineFirstPage() 
{
    if (<%=availbleReturnCode(storeId, storeGroupId)%> != true){
	    alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("noRtnReasonExceptionMsg")) %>");
	    top.goBack().goBack();
	}
    if ( (getOrderIds() != null) && !parent.get("OrderIdsProcessedAlready"))
    {
    	var URLParam = new Object();
	URLParam.XMLFile		="returns.returnItemListDialog";
	URLParam.ActionXMLFile 		="returns.returnItemList";
	URLParam.cmd			="ReturnItemSearchInterim";
	URLParam.itemsSelected		="false";

	URLParam.searchOrdersOrCatalog = "searchOrder";

	URLParam.searchProductName	= "";
	URLParam.searchSKUNumber	= "";

	URLParam.searchOrderNumber	= getOrderIds();
	URLParam.searchCustomerLogonId	= "";
	URLParam.searchAccountId	= "";
	
	URLParam.listsize		="11";
	URLParam.startindex		="0";
	URLParam.refnum			="0";

	parent.put("OrderProductSearchURLParam", URLParam); //GK1
	parent.put("OrderIdsProcessedAlready", "true");

	top.saveModel(parent.model);
	top.setReturningPanel(parent.getCurrentPanelAttribute("name"));
	top.setContent("<%=returnsNLS.get("addProductBCT")%>", 
	               "/webapp/wcs/tools/servlet/DialogView?XMLFile=returns.returnItemListDialog&ActionXMLFile=returns.returnItemList&cmd=ReturnItemSearchInterim&searchOrdersOrCatalog=searchOrder&searchOrderNumber="+getOrderIds(), true);
    }
    else
    {
	this.location.replace(getRedirectURL());
    }
}



// main function
function executeOnLoad()
{
	if (defined(parent.getErrorParams())) {
		errorCode = parent.getErrorParams();
		if (errorCode == "policyIdMissing") {
			alertDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("noRefundPaymentPolicy")) %>");
		}
	}
	
	parent.remove("preCmdChain");

	// *** new return ***
	if (!defined(prev)) 
	{
        	if (parent.get("edit") == "true") {
            		parent.put("<%=ECToolsConstants.EC_XMLFILE%>","returns.EditReturn");
            		<%if (inUse.equals("Y")){%>
	            		if (confirmDialog("<%= UIUtil.toJavaScript( (String)returnsNLS.get("inUseWarning")) %>") == false){	            		
	            		   top.goBack().goBack();
	            		}
	            	<%}%>
            		setCustomerIdInModel();
        		setInUseInModel();
        		setPolicyIdInModel();
            		callCSRReturnCreateCopy();
            	} else {
            		parent.put("<%=ECToolsConstants.EC_XMLFILE%>","returns.CreateReturn");
			determineFirstPage();
		}
	} 
		
	// *** moving from ReturnItemsPage to another panel ***
	else if ((prev == "ReturnItemsPage") && (next == "ReturnItemsPage")) 
	{
		this.location.replace(getRedirectURL());
	} 
	else if ((prev == "ReturnItemsPage") && (next == "ReturnCommentsPage")) 
	{
		callCSRReturnItemUpdate();
	}
	else if ((prev == "ReturnItemsPage") && (next == "ReturnCreditMethodPage")) 
	{
		callCSRReturnItemUpdate();
	}
	else if ((prev == "ReturnItemsPage") && (next == "ReturnConfAndAdjustPage")) 
	{
		var preCmdChain = new Object();
		var preCommand = new Vector();
		var aCmd = new Object();
		aCmd.name = "CSRReturnItemUpdate"
		addElement(aCmd, preCommand);
		preCmdChain.preCommand = preCommand;
		parent.put("preCmdChain",preCmdChain);
		callCSRReturnPrepare();
	}
	

	// *** moving from ReturnCommentsPage to another panel ***
	else if ((prev == "ReturnCommentsPage") && (next == "ReturnItemsPage")) 
	{
		callCSRReturnUpdate();
	}
	else if ((prev == "ReturnCommentsPage") && (next == "ReturnCommentsPage")) 
	{
		this.location.replace(getRedirectURL());
	}
	else if ((prev == "ReturnCommentsPage") && (next == "ReturnCreditMethodPage")) 
	{
		callCSRReturnUpdate();
	}
	else if ((prev == "ReturnCommentsPage") && (next == "ReturnConfAndAdjustPage")) 
	{
		var preCmdChain = new Object();
		var preCommand = new Vector();
		var aCmd = new Object();
		aCmd.name = "CSRReturnUpdate"
		addElement(aCmd, preCommand);
		preCmdChain.preCommand = preCommand;
		parent.put("preCmdChain",preCmdChain);
		callCSRReturnPrepare();
	}


	// *** moving from ReturnCreditMethodPage to another panel ***
	else if ((prev == "ReturnCreditMethodPage") && (next == "ReturnItemsPage")) 
	{
		this.location.replace(getRedirectURL());
	}
	else if ((prev == "ReturnCreditMethodPage") && (next == "ReturnCommentsPage")) 
	{
		this.location.replace(getRedirectURL());
	}
	else if ((prev == "ReturnCreditMethodPage") && (next == "ReturnCreditMethodPage")) 
	{
		this.location.replace(getRedirectURL());
	}
	else if ((prev == "ReturnCreditMethodPage") && (next == "ReturnConfAndAdjustPage")) 
	{
		callCSRReturnPrepare();
	}		

	// *** moving from ReturnConfAndAdjustPage to another panel ***
	else if ((prev == "ReturnConfAndAdjustPage") && (next == "ReturnItemsPage")) 
	{
		this.location.replace(getRedirectURL());
	}
	else if ((prev == "ReturnConfAndAdjustPage") && (next == "ReturnCommentsPage")) 
	{
		this.location.replace(getRedirectURL());
	}
	else if ((prev == "ReturnConfAndAdjustPage") && (next == "ReturnCreditMethodPage")) 
	{
		this.location.replace(getRedirectURL());
	}
	else if ((prev == "ReturnConfAndAdjustPage") && (next == "ReturnConfAndAdjustPage")) 
	{
		this.location.replace(getRedirectURL());
	}
}

</SCRIPT>
</HEAD>

<BODY onload="executeOnLoad();" class="content">
<FORM NAME="formToSubmit" ACTION="" method="post">
	<INPUT TYPE='hidden' NAME="URL" VALUE="">
	<INPUT TYPE='hidden' NAME="XML" VALUE="">
</FORM>
</BODY>

<% 	
    } catch (Exception e) {
        com.ibm.commerce.exception.ExceptionHandler.displayJspException(request, response, e);
    }
%>

</HTML>
