<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2000, 2016 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.math.*" %>
<%@ page import="com.ibm.commerce.beans.*"  %>
<%@ page import="com.ibm.commerce.datatype.*" %>
<%@ page import="com.ibm.commerce.contract.beans.*" %>
<%@ page import="com.ibm.commerce.contract.commands.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.contract.helper.ECContractConstants" %>
<%@ page import="com.ibm.commerce.tools.contract.beans.PriceTCMasterCatalogWithFilteringDataBean" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.price.*" %>
<%@ page import="com.ibm.commerce.rfq.beans.*" %>
<%@ page import="com.ibm.commerce.rfq.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.objimpl.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.utf.helper.*" %>
<%@ page import="com.ibm.commerce.utf.objects.*" %>
<%@ page import="com.ibm.commerce.utf.objimpl.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.user.beans.UserRegistrationDataBean" %>
<%@ page import="com.ibm.commerce.rfq.utils.RFQPriceAdjustmentOnCategory" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>

<%
    Locale aLocale = null;
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");  
    String ErrorMessage = request.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
    if (ErrorMessage == null) {
		ErrorMessage = "";
    }
    if( aCommandContext!= null ) {
    	aLocale = aCommandContext.getLocale();
    }
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", aLocale);
    String lang = aCommandContext.getLanguageId().toString();
    Integer langId = aCommandContext.getLanguageId();
    String StoreId = aCommandContext.getStoreId().toString();
    StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));
    if (lang == null) {
  		lang =  "-1";
    }
    String rfqid = request.getParameter("rfqid"); 
	String hasPP = "";   
	boolean hashasPriceAdjustmentOnCategory = RFQProductHelper.hasPriceAdjustmentOnCategory(new Long(rfqid));				
	if (hashasPriceAdjustmentOnCategory) {
		hasPP = "pp";				
	}    
    int rowselect=1;
    String tcman_status = null;
    String tcchange_status = null;
    String allProductsSelected = request.getParameter("allProductsSelected");
    if (allProductsSelected == null || allProductsSelected.length() == 0) {
   		allProductsSelected = "1";
    } 
     
       
%>

<!-- General and Duration page data  -->
<jsp:useBean id="rfq" class="com.ibm.commerce.utf.beans.RFQDataBean" >
<jsp:setProperty property="*" name="rfq" />
<jsp:setProperty property="rfqId" name="rfq" value="<%= rfqid %>" />
</jsp:useBean>
<%

    com.ibm.commerce.beans.DataBeanManager.activate(rfq, request);
    String name = UIUtil.toHTML(rfq.getName());
    String status = rfq.getState();
    if (status.equals(com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_DRAFT.toString())) {
		status = (String)rfqNLS.get("draft");
    } else if (status.equals(com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_ACTIVE.toString())) {
		status = (String)rfqNLS.get("active");
    } else if (status.equals(com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_CANCELED.toString())) {
		status = (String)rfqNLS.get("canceled");
    } else if (status.equals(com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_CLOSED.toString())) {
		status = (String)rfqNLS.get("closed");
    } else if (status.equals(com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_REJECTED.toString())) {
		status = (String)rfqNLS.get("rejected");
    } else if (status.equals(com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_RETRACTED.toString())) {
		status = (String)rfqNLS.get("retracted");
    } else if (status.equals(com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_INEVAL.toString())) {
		status = (String)rfqNLS.get("inevaluation");
    } else if (status.equals(com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_COMPLETED.toString())) {
		status = (String)rfqNLS.get("complete");
    } else if (status.equals(com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_FUTURE.toString())) {
		status = (String)rfqNLS.get("future");
    } else if (status.equals(com.ibm.commerce.utf.helper.UTFOtherConstants.EC_STATE_NEXT_ROUND.toString())) {
		status = (String)rfqNLS.get("nextround");
    }
    String endresult = rfq.getEndResult();
    if (endresult.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_UTF_ENDRESULT_ORDER.toString())) {
		endresult = (String)rfqNLS.get("order");
    } else {
		endresult = (String)rfqNLS.get("contract");
    }
    /* get the closing rule */
    String closeRule = rfq.getRuleType();
    if (closeRule.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_CLOSE_RULE1)) {
        closeRule = (String)rfqNLS.get("RFQDisplay_Rule1");
    } else if (closeRule.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_CLOSE_RULE2)) {
        closeRule = (String)rfqNLS.get("RFQDisplay_Rule2");
    } else if (closeRule.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_CLOSE_RULE3)) {
       closeRule = (String)rfqNLS.get("RFQDisplay_Rule3");
    } else if (closeRule.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_CLOSE_RULE4)) {
       closeRule = (String)rfqNLS.get("RFQDisplay_Rule4");
    }
    /* get the minumum number of responses */
    String numResponses = rfq.getNumOfResponses();
    /* get and format the date and time as per local/language */
    String rfq_start = null;
    if (rfq.getStartTimeInEntityType() !=null) {
		DateFormat df_date = DateFormat.getDateInstance(DateFormat.SHORT, aLocale);
		DateFormat df_time = DateFormat.getTimeInstance(DateFormat.SHORT, aLocale);
		rfq_start = df_date.format(rfq.getStartTimeInEntityType()) + " " + df_time.format(rfq.getStartTimeInEntityType());
    } else {
		rfq_start = "";
    }
    String rfq_end = null;
    if (rfq.getEndTimeInEntityType() !=null) {
		DateFormat df_enddate = DateFormat.getDateInstance(DateFormat.SHORT, aLocale);
		DateFormat df_endtime = DateFormat.getTimeInstance(DateFormat.SHORT, aLocale);
		rfq_end = df_enddate.format(rfq.getEndTimeInEntityType()) + " " + df_endtime.format(rfq.getEndTimeInEntityType());
    } else {
		rfq_end ="";
    }

    String rfq_close = null;
    if (rfq.getCloseTimeInEntityType() !=null) {
		DateFormat df_closedate = DateFormat.getDateInstance(DateFormat.SHORT, aLocale);
		DateFormat df_closetime = DateFormat.getTimeInstance(DateFormat.SHORT, aLocale);
		rfq_close = df_closedate.format(rfq.getCloseTimeInEntityType()) + " " + df_closetime.format(rfq.getCloseTimeInEntityType());
    } else {
		rfq_close ="";
    }

    String shortdesc;
    try {
  		shortdesc = UIUtil.toHTML(rfq.getDescription(Integer.valueOf(lang)).getShortDescription());		
    } catch (Exception eSDesc) { 
		shortdesc="";
    }	
    String longdesc;
    try {
		longdesc = UIUtil.toHTML(rfq.getDescription(Integer.valueOf(lang)).getLongDescription());		
    } catch (Exception eSDesc) { 
		longdesc="";
    }    
	String memberId = rfq.getMemberId();	
	UserRegistrationDataBean urdb = new UserRegistrationDataBean();	
	urdb.setDataBeanKeyMemberId(memberId);
	urdb.setCommandContext(aCommandContext);
	//as we only need to get the username for the owner of the RFQ
	//and we have already check for access control on the RFQ object.
	//com.ibm.commerce.beans.DataBeanManager.activate(urdb, request);
	urdb.populate();
	String logonId = urdb.getLogonId();
%> 

<!-- RFQ Level Attachments List for RFQ  -->
<jsp:useBean id="attachmentList" class="com.ibm.commerce.rfq.beans.RFQAttachmentListBean" >
<jsp:setProperty property="*" name="attachmentList" />
</jsp:useBean>
<%
    attachmentList.setTradingId(Long.valueOf(rfqid));
    com.ibm.commerce.beans.DataBeanManager.activate(attachmentList, request);
    com.ibm.commerce.contract.beans.AttachmentDataBean [] attachList = attachmentList.getAttachments();
%>
<!-- Product List for RFQ  -->
<jsp:useBean id="prodList" class="com.ibm.commerce.utf.beans.RFQProdListBean" >
<jsp:setProperty property="*" name="prodList" />
</jsp:useBean>
<%
    prodList.setRFQId(rfqid);
    com.ibm.commerce.beans.DataBeanManager.activate(prodList, request);
    com.ibm.commerce.utf.beans.RFQProdDataBean [] pList = prodList.getRFQProds();
%>
<!-- TermandCond for RFQ  -->
<jsp:useBean id="rfqtc" class="com.ibm.commerce.utf.beans.OrderCommentList" >
<jsp:setProperty property="*" name="rfqtc" />
</jsp:useBean>
<%
    OrderCommentList tclist = new OrderCommentList();
    tclist.setRfqId(rfqid);
    tclist.populate();
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title><%= rfqNLS.get("RFQSummTitle") %></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript">

function printAction() {
	window.print();
}
function initializeState() {
  	parent.setContentFrameLoaded(true);
}
function savePanelData() {
	return true;
}
function validatePanelData() {
	return true;
}

function goToAttachment(attachId) {
	var url = "RFQAttachmentView?<%= com.ibm.commerce.server.ECConstants.EC_ATTACH_ID %>=" + attachId + "&<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_RFQ_REQUEST_ID %>=<%= UIUtil.toJavaScript(rfqid) %>";
	var windowTitle = "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_Attachment")) %>";
	var attributes = 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes';
	var attachmentWindow = top.openChildWindow(url, windowTitle, attributes);
}
function goToCategory(rfqid, rfqCategoryId) {
	var tmpCategoryId = ""; 
	if (rfqCategoryId != null) {
	    tmpCategoryId = rfqCategoryId;
	}     
	top.setContent(getCategoryAttBCT(), "DialogView?XMLFile=rfq.requestSummaryCategory&amp;rfqid="+rfqid+"&amp;rfqCategoryId="+tmpCategoryId, true);
}
function getCategoryAttBCT() {
  	return "<%= UIUtil.toJavaScript(rfqNLS.get("category")) %>";
}
function goToProduct(rfqid, rfqProdId) {
	top.setContent(getProductAttBCT(), "DialogView?XMLFile=rfq.requestSummaryProduct&amp;rfqid="+rfqid+"&amp;rfqProdId="+rfqProdId, true);
}
function getProductAttBCT() {
  	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_ProductAtt")) %>";
}
function createResponse() {
	var rfqId = "<%=UIUtil.toJavaScript(rfqid)%>";	
	top.setContent(getRespondBCT(), '/webapp/wcs/tools/servlet/NotebookView?XMLFile=rfq.rfqResponseCreateNotebook&amp;requestId='+rfqId, true);
}
function getRespondBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqresponsenew")) %>";
}
function getSummRFQBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("summary")) %>";
}
function showCategoryOnly() {
	var urlParams = new Object();
	urlParams.rfqid = <%= (rfqid == null ? null : UIUtil.toJavaScript(rfqid)) %>;	
	urlParams.allProductsSelected = "0";
	var temp_status = "<%= UIUtil.toJavaScript(status) %>";
    var active="<%= UIUtil.toJavaScript(rfqNLS.get("active")) %>";
    if (temp_status != active ) {
	    var url = '/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.requestSummaryShowCategoryOnly';
    } else {
	    var url = '/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.requestSummaryShowCategoryOnly_active';
    }
	top.setContent(getSummRFQBCT(), url, false, urlParams);
}
function showAllProducts() {
	var urlParams = new Object();
	urlParams.rfqid = <%= (rfqid == null ? null : UIUtil.toJavaScript(rfqid)) %>;
	urlParams.allProductsSelected = "1";
	var temp_status = "<%= UIUtil.toJavaScript(status) %>";
	var active="<%= UIUtil.toJavaScript(rfqNLS.get("active")) %>";
	if ( temp_status != active ) {
	    var url = '/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.requestSummary';
	} else {
	    var url = '/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.requestSummary_active';
	}
	top.setContent(getSummRFQBCT(), url, false, urlParams);
}
function customerSummary(rfqId) {
	var url = "DialogView?XMLFile=rfq.rfqRequestCustomerSummary&amp;rfqId="+rfqId;		
	if (top.setContent) {
	    top.setContent(getCustomerSummaryBCT(), url, true);
	} else {
	    parent.parent.location.replace(url);
	} 
}
function getCustomerSummaryBCT() {
  	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_CustomerSumm")) %>";
}
function categorySummary(categoryId) {

	var url = "DialogView?XMLFile=rfq.rfqAdjustmentCategorySummary&amp;categoryId="+categoryId+"&amp;rfqId=<%=UIUtil.toJavaScript(rfqid)%>";
			
	if (top.setContent) {
	    top.setContent(getCategorySummaryBCT(), url, true);
	} else {
	    parent.parent.location.replace(url);
	} 
}
function getCategorySummaryBCT() {
  	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_CategorySumm")) %>";
}
function goToConfigurationReport(rfqid, rfqProdId){
	top.setContent(getConfigurationReportBCT(), "DialogView?XMLFile=rfq.rfqRequestSummaryDynamicKitConfigReport&amp;rfqid="+rfqid+"&amp;rfqProdId="+rfqProdId, true);
}
function getConfigurationReportBCT() {
  	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_ConfigReport")) %>";
}
</script>
</head>

<body class="content" onload="initializeState();">

<br /><h1><%= rfqNLS.get("RFQSummTitle") %></h1>

<form name="SummaryForm" action="">

<b><%= rfqNLS.get("generalinfo") %></b><br />

<table>
    <tr>
		<td> <%= rfqNLS.get("name") %>: <i><%= name %></i><br /></td>
    </tr>
    <tr>
		<td> <%= rfqNLS.get("rfqcustomerlogonid") %>: <a href="javascript:customerSummary(<%=UIUtil.toHTML(rfqid)%>)"><i><%= UIUtil.toHTML(logonId) %></i></a><br /></td>
    </tr>
    <tr>
		<td><%= rfqNLS.get("shortDescription") %>:  <i><%= shortdesc %></i><br /></td>
    </tr>
    <tr>
		<td><%= rfqNLS.get("longDescription") %>:  <i><%= longdesc %></i><br /></td>
    </tr>
    <tr>
		<td><%= rfqNLS.get("status") %>: <i><%= status %></i><br /></td>
    </tr>
<%
    if (rfq_close.trim().length() > 0) {
%>
    <tr>
  		<td><%= rfqNLS.get("rfqClosedDate") %>: <i><%= rfq_close %></i><br /></td>
    </tr>
<%
    }
%>
    <tr>
		<td><%= rfqNLS.get("contractororder") %>  <i><%= endresult %></i><br /></td>
    </tr>
</table>

<br /><b><%= rfqNLS.get("durationinfo") %></b>

<table>
    <tr>
  		<td><%= rfqNLS.get("startdate") %>: <i><%= rfq_start %></i><br /></td>
    </tr>
<%
    if (closeRule.equals(rfqNLS.get("RFQDisplay_Rule1"))) {
%>
    <tr>
		<td><%= rfqNLS.get("enddate") %>: <i><%= rfq_end %></i><br /></td>
    </tr>
<%
    } else {
%>
    <tr>
		<td><%= rfqNLS.get("RFQDisplay_CloseRule") %>  <i><%= closeRule %></i><br /></td>
    </tr>
    <tr>
		<td><%= rfqNLS.get("enddate") %>: <i><%= rfq_end %></i><br /></td>
    </tr>
    <tr>
		<td><%= rfqNLS.get("RFQDisplay_MinResponse") %>  <i><%= numResponses %></i><br /></td>
    </tr>
<%
    }
%>
</table>

<br /><b><%= rfqNLS.get("rfqattachments") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("rfqattachments")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("filename"),"none",false,"30%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"none",false,"40%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("filesize"),"none",false,"30%" ) %>
    <%= comm.endDlistRowHeading() %>

<%	
    rowselect=1;
    for (int i = 0; attachList != null && i < attachList.length; i++) {
		AttachmentDataBean dbAttachment = attachList[i];
		String strAttachmentId = dbAttachment.getAttachmentId();
		String attachFilename = UIUtil.toHTML(dbAttachment.getFilename());
		String attachDescription = UIUtil.toHTML(dbAttachment.getDescription());
		Long filesize = dbAttachment.getFilesize();
		String attachFilesize = "";
		if (filesize != null) {
	    	attachFilesize = filesize.toString();
		}
%>
    	<%= comm.startDlistRow(rowselect) %>
    	<%= comm.addDlistColumn( "<a href=\"javascript:goToAttachment('" + strAttachmentId + "');\"> " + attachFilename + "</a>","none") %>
    	<%= comm.addDlistColumn( attachDescription,"none") %>
    	<%= comm.addDlistColumn( attachFilesize,"none") %>
    	<%= comm.endDlistRow() %>
<%
    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
	}//end for
%>
    <%= comm.endDlistTable() %>
<%
    if ( attachList== null || attachList.length < 1 ) {
%>
    	<%=  rfqNLS.get("msgnoattach") %><br />
<%
    } //end if
%>




<br />
 <b><%= rfqNLS.get("tcinfo") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("tcinfo")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("mandatory"),"none",false,"40%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqchangeable"),"none",false,"20%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("termsandconditions"),"none",false,"40%" ) %>
    <%= comm.endDlistRowHeading() %>
<%	
    OrderCommentData aComment = new OrderCommentData();
    OrderCommentData [] aList = tclist.getComments();
    rowselect=1;
    for (int i = 0; i < aList.length; i++) {
		aComment = aList[i];
		String tccomment = UIUtil.toHTML(aComment.getComment());
		String tcmandatory = aComment.getMandatoryFlag();
		if (tcmandatory.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_UTF_MANDATORY.toString())) {
	    	tcman_status = (String)rfqNLS.get("yes"); 
		} else if (tcmandatory.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_UTF_OPTIONAL.toString())) {
	    	tcman_status = (String)rfqNLS.get("no"); 
        }
        String tcchange = aComment.getChangeableFlag();
        if (tcchange.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_UTF_NON_CHANGEABLE.toString())) {
	    	tcchange_status = (String)rfqNLS.get("no"); 
    	} else if (tcchange.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_UTF_CHANGEABLE.toString())) {
	    	tcchange_status = (String)rfqNLS.get("yes"); 
		}
%>
    	<%= comm.startDlistRow(rowselect) %>
    	<%= comm.addDlistColumn( tcman_status,"none") %>
    	<%= comm.addDlistColumn( tcchange_status,"none") %>
    	<%= comm.addDlistColumn( tccomment,"none") %>
    	<%= comm.endDlistRow() %>
<%
    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
    } //end for
%>
    <%= comm.endDlistTable() %>
<%
    if ( aList== null || aList.length < 1 ) {
%>
    <%= rfqNLS.get("msgnotcs") %><br />
<%
    }//end if
%>


<%    
if ( hasPP.equals("pp")) {
%>
<br />
 <b><%= rfqNLS.get("rfqadjustoncategories") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("rfqadjustoncategories")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("RFQCreateCategoryDisplay_Name"),"none",false,"25%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqcategorydescription"),"none",false,"27%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqpriceadjustment"),"none",false,"23%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqcatalogsynchronized"),"none",false,"25%" ) %>
    <%= comm.endDlistRowHeading() %>
<jsp:useBean id="catalogBean" class="com.ibm.commerce.catalog.beans.CatalogDataBean" scope="page">
</jsp:useBean>	
<%	
    String requestCatalogId = RFQProductHelper.getCatalogIdFromXmlFragment(new Long(rfqid));
	catalogBean.setCatalogId(requestCatalogId); 
	com.ibm.commerce.beans.DataBeanManager.activate(catalogBean, request); 
	
	RFQPriceAdjustmentOnCategory[] rfqPaArray = RFQProductHelper.getPriceAdjustmentsOnCategory(new Long(rfqid), catalogBean);

	String percentagePriceAttr = "";
	String categoryName = "";	
	String synchronize = "";
	String ppDescription = "";
	String categoryId = "";
    rowselect=1; 
	if( rfqPaArray != null || rfqPaArray.length !=0 ) {		
		for (int i = 0; i<rfqPaArray.length; i++) {			
			RFQPriceAdjustmentOnCategory rfqPAObj = new RFQPriceAdjustmentOnCategory();					
			rfqPAObj = rfqPaArray[i];			
			if (rfqPAObj.getSynchronize().equals("true"))	{
				synchronize = (String)rfqNLS.get("yes");		
			} else if (rfqPAObj.getSynchronize().equals("false"))  {
				synchronize = (String)rfqNLS.get("no");			
			}
								
			percentagePriceAttr = rfqPAObj.getPercentagePrice().toString();
			if (percentagePriceAttr.length() > 0) 
			{
            	    	    Double ptemp = Double.valueOf(percentagePriceAttr);
            		    java.text.NumberFormat numberFormatter;
            		    if (ptemp != null && ptemp.doubleValue() <= 0) 
            		    {
          		    	numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
          		    	percentagePriceAttr = numberFormatter.format(ptemp);
			    }		
			}  	
							
			categoryName = rfqPAObj.getCatName();	
			ppDescription = rfqPAObj.getDescription();
			categoryId = rfqPAObj.getCategory_id().toString();					
%>
			<%= comm.startDlistRow(rowselect) %>
			<%= comm.addDlistColumn(categoryName,"javascript:categorySummary("+categoryId+")") %>
			<%= comm.addDlistColumn(ppDescription,"none") %>
			<%= comm.addDlistColumn(percentagePriceAttr + " " + (String)rfqNLS.get("percentagemark"),"none") %>
			<%= comm.addDlistColumn(synchronize,"none") %>
			<%= comm.endDlistRow() %>
<%	
			if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
		}  // end for ..
%>
    <%= comm.endDlistTable() %>    
<%					
	} else {
%>		
    	<%= rfqNLS.get("msgnocategoryadjust") %><br />		
<%		
	}
}
%>

<br />
 <b><%= rfqNLS.get("prodcategoryinfo") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("prodcategoryinfo")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("category"),"none",false,"20%" ) %>
    <%= comm.endDlistRowHeading() %>	
<%	
    RFQCategryAccessBean abRFQCategry = new RFQCategryAccessBean();
    Enumeration enu = abRFQCategry.findByRFQId(Long.valueOf(rfqid));
    rowselect=1;
    while (enu.hasMoreElements()) {
		RFQCategryAccessBean rfqCategry = (RFQCategryAccessBean)enu.nextElement();
		String rfqCategoryId = rfqCategry.getRfqCategryId();
		String rfqCategoryName = UIUtil.toHTML(rfqCategry.getName());
%>
    	<%= comm.startDlistRow(rowselect) %>
    	<%= comm.addDlistColumn( rfqCategoryName,"javascript:goToCategory("+rfqid+","+rfqCategoryId+")") %>
    	<%= comm.endDlistRow() %>
<%
    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
    }
%>
    <%= comm.startDlistRow(rowselect) %>
    <%= comm.addDlistColumn( (String)rfqNLS.get("RFQExtra_NotCategorized"),"javascript:goToCategory("+rfqid+")") %>
    <%= comm.endDlistRow() %>
    <%= comm.endDlistTable() %>        
       
      
<%

if (allProductsSelected.equals("1")) {
	Vector prodPPVect = new Vector();
	Vector prodFPVect = new Vector();
	Vector dkPPVect = new Vector(); 
	Vector dkFPVect = new Vector();
	
	
	for (int i = 0; pList != null && i < pList.length; i++) {
		Hashtable temphash = new Hashtable();                  
		RFQProdDataBean aPList = pList[i];
		String catid = aPList.getCatentryId();
		String negotiationType = aPList.getNegotiationType().toString().trim();
		
			    	
		String percentagePrice = "";			
		if (aPList.getPriceAdjustment()!=null) {
			percentagePrice = aPList.getPriceAdjustment();
		}
		if (percentagePrice.length() > 0) 
		{
            	    Double ptemp = Double.valueOf(percentagePrice);
            	    java.text.NumberFormat numberFormatter;
            	    if (ptemp != null && ptemp.doubleValue() <= 0) 
            	    {
          	    	numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
          	    	percentagePrice = numberFormatter.format(ptemp);
		    }		
		}  		
		
		String quantity = aPList.getQuantity();
		String price = aPList.getPrice();			
		BigDecimal price_ejb = aPList.getPriceInEntityType();
		String currency = aPList.getCurrency();
		String unitid = aPList.getQtyUnitId();
		
		
		String prodName = UIUtil.toHTML(aPList.getRfqProductName());
		String prodCategoryId = UIUtil.toHTML(aPList.getRfqCategryId());
			
		String rfqProdId = aPList.getRfqprodId();
		String prodChangeable = aPList.getChangeable();
		String unit = "";
		FormattedMonetaryAmount fmt = null;
		CurrencyManager cm = CurrencyManager.getInstance();
		String currencyCode = cm.getDefaultCurrency(storeAB, langId);
		String rfqCategoryName = "";		
		if (prodCategoryId != null && prodCategoryId.length() > 0) {
            RFQCategryDataBean rfqCategry = new RFQCategryDataBean();
            rfqCategry.setRfqCategryId(prodCategoryId);
            rfqCategoryName = UIUtil.toHTML(rfqCategry.getName());
		}		
		

		if (rfqCategoryName == null || rfqCategoryName =="") {
            rfqCategoryName = UIUtil.toHTML((String)rfqNLS.get("RFQExtra_NotCategorized"));
		} 
		
				
		if ( !price.equals("") && price != null ) {
	    	price_ejb = new BigDecimal(price);
	    	if (price_ejb.doubleValue() >= 0 ) {
		    	fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(price_ejb, currencyCode), storeAB, langId);
		    	price = fmt.getFormattedValue();  // price without prefix and postfix
	        }
		}				
		if (quantity != null && quantity.length() > 0) {
            Double dtemp = Double.valueOf(quantity);
            java.text.NumberFormat numberFormatter;
            if (dtemp != null && dtemp.doubleValue() >= 0) {
          	    numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
          	    quantity = numberFormatter.format(dtemp);
			}
		}		
		if (unitid != null && !unitid.equals("")) {
            QuantityUnitDescriptionAccessBean unitA = new QuantityUnitDescriptionAccessBean();
            unitA.setInitKey_language_id(lang);
            unitA.setInitKey_quantityUnitId(unitid);
            unit = unitA.getDescription();           
		}
		String prodCanBeSubstituted = "";
		if (prodChangeable.equals(RFQConstants.EC_RFQ_PRODUCT_CHANGEABLE_YES.toString())) {
            prodCanBeSubstituted = (String)rfqNLS.get("yes");
		} else {
            prodCanBeSubstituted = (String)rfqNLS.get("no");
		}       	    
		String catname = prodName;
		String catdescription = ""; 
	    	          
		String prodType = "";  
		String partNum = "";          
		if( (catid != null) && !catid.equals("null") && !catid.equals("")) {  
            CatalogEntryDescriptionAccessBean catalogAB = new CatalogEntryDescriptionAccessBean();
            catalogAB.setInitKey_catalogEntryReferenceNumber(catid);
            catalogAB.setInitKey_language_id(lang);
            
            
            catname = UIUtil.toHTML(catalogAB.getName());
            catdescription = UIUtil.toHTML(catalogAB.getShortDescription());            	
            CatalogEntryAccessBean dbCatentry = new CatalogEntryAccessBean();            	
			dbCatentry.setInitKey_catalogEntryReferenceNumber(catid);
			
			partNum = dbCatentry.getPartNumber();
			                
		    String catType = dbCatentry.getType().trim(); 
			if (catType.equals(RFQConstants.EC_OFFERING_ITEMBEAN)) {
				prodType = (String)rfqNLS.get("rfqproductrequesttypeitem");											
			}
			if (catType.equals(RFQConstants.EC_OFFERING_PRODUCTBEAN)) {
				prodType = (String)rfqNLS.get("rfqproductrequesttypeproduct");					
			}	
			if (catType.equals(RFQConstants.EC_OFFERING_PACKAGEBEAN)) {
				prodType = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");					
			}				
			if (catType.equals(RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) {
				prodType = (String)rfqNLS.get("rfqproductrequesttypedynamickit");
			}							 
		} 		
		
		temphash.put("prodname", catname);
		temphash.put("desc", catdescription);
		temphash.put("category", rfqCategoryName);        		
		temphash.put("type", prodType);        		
		temphash.put("price", price);
		temphash.put("partNum", partNum);
		temphash.put("priceadjust", percentagePrice );
		temphash.put("currency", currency);
		temphash.put("quantity", quantity);		
		temphash.put("units", unit);
		temphash.put("substituted", prodCanBeSubstituted); 		
		temphash.put("rfqprodid", rfqProdId); 
		temphash.put("prodcategoryid", prodCategoryId); 
		temphash.put("categoryname", rfqCategoryName); 
		temphash.put("substituted", prodCanBeSubstituted);	
		
		if (negotiationType.equals("4")) {
			dkPPVect.add( temphash );
		} else if (negotiationType.equals("3")) {
			dkFPVect.add( temphash );
		} else if (negotiationType.equals("2")) {
			prodPPVect.add( temphash );
		} else if (negotiationType.equals("1")) {
			prodFPVect.add( temphash );
		} 			
 
		        
	}	
		
	
	if (prodPPVect.size()>0) {		
%>	
		<br /><b><%= rfqNLS.get("rfqproductpercentagepriceinfo") %></b>
		<%= comm.startDlistTable((String)rfqNLS.get("rfqproductpercentagepriceinfo")) %>
		<%= comm.startDlistRowHeading() %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqprodname"),"none",false,"18%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("product_partno"),"none",false,"10%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"none",false,"18%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("category"),"none",false,"16%" ) %> 
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqproducttype"),"none",false,"12%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqpercentageajust"),"none",false,"14%" ) %>
<%    if (endresult.equals((String)rfqNLS.get("order"))) { %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("quantity"),"none",false,"10%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqunits"),"none",false,"10%" ) %>			
<% } %>		
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("productcanbesubstituted"),"none",false,"24%" ) %>
		<%= comm.endDlistRowHeading() %>
<% 
		rowselect=1;	
		for (int i = 0; i < prodPPVect.size(); i++) {	
			Hashtable tempH = (Hashtable)prodPPVect.elementAt(i);	
%>
			<%= comm.startDlistRow(rowselect) %> 
    		<%= comm.addDlistColumn((String)tempH.get("prodname"), "javascript:goToProduct("+rfqid+","+ tempH.get("rfqprodid")+")") %>
    		<%= comm.addDlistColumn((String)tempH.get("partNum"), "none") %>	
    		<%= comm.addDlistColumn((String)tempH.get("desc"), "none") %>	
<%
			String anId = (String)tempH.get("prodcategoryid");	
								
			if (anId != null && anId.length()> 0 ) {
%>
				<%= comm.addDlistColumn((String)tempH.get("categoryname"), "javascript:goToCategory("+rfqid+","+ tempH.get("prodcategoryid")+")") %>
<%
			} else {
%>
				<%= comm.addDlistColumn((String)tempH.get("categoryname"), "javascript:goToCategory("+rfqid+")") %>
<%
			}
%>		
			<%= comm.addDlistColumn((String)tempH.get("type"), "none") %>  
			<%= comm.addDlistColumn((String)tempH.get("priceadjust") + " " + (String)rfqNLS.get("percentagemark"), "none") %>
  	
<%    if (endresult.equals((String)rfqNLS.get("order"))) { %>
			<%= comm.addDlistColumn((String)tempH.get("quantity"), "none") %>
    		<%= comm.addDlistColumn((String)tempH.get("units"), "none") %>				
<% 	} %>			
			<%= comm.addDlistColumn((String)tempH.get("substituted"),"none") %>
<%
			if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
		}		
%>		
		    <%= comm.endDlistTable() %>  
<%			 
	}	
	if (prodFPVect.size()>0) {	
%>
		<br /><b><%= rfqNLS.get("rfqproductfixedpriceinfo") %></b>
		
		<%= comm.startDlistTable((String)rfqNLS.get("rfqproductfixedpriceinfo")) %>
		<%= comm.startDlistRowHeading() %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqprodname"),"none",false,"15%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("product_partno"),"none",false,"10%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"none",false,"10%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("category"),"none",false,"10%" ) %> 
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqproducttype"),"none",false,"10%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("price"),"none",false,"8%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("currency"),"none",false,"8%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("quantity"),"none",false,"8%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqunits"),"none",false,"8%" ) %>	
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("productcanbesubstituted"),"none",false,"24%" ) %>
		<%= comm.endDlistRowHeading() %>
<%
		rowselect=1;	
		for (int i = 0; i < prodFPVect.size(); i++) {	
			Hashtable tempH = (Hashtable)prodFPVect.elementAt(i);	
%>
			<%= comm.startDlistRow(rowselect) %> 
    		<%= comm.addDlistColumn((String)tempH.get("prodname"), "javascript:goToProduct('"+rfqid+"','"+ tempH.get("rfqprodid")+"')") %>
    		<%= comm.addDlistColumn((String)tempH.get("partNum"), "none") %>	
    		<%= comm.addDlistColumn((String)tempH.get("desc"), "none") %>	
<%
			String anId = (String)tempH.get("prodcategoryid");
			if (anId != null && anId.length()> 0 ) {
%>
				<%= comm.addDlistColumn((String)tempH.get("categoryname"), "javascript:goToCategory("+rfqid+","+ tempH.get("prodcategoryid")+")") %>
<%
			} else {
%>
				<%= comm.addDlistColumn((String)tempH.get("categoryname"), "javascript:goToCategory("+rfqid+")") %>
<%
			}
%>		
			<%= comm.addDlistColumn((String)tempH.get("type"), "none") %>
    		<%= comm.addDlistColumn((String)tempH.get("price"), "none") %>
    		<%= comm.addDlistColumn((String)tempH.get("currency"), "none") %>
    		<%= comm.addDlistColumn((String)tempH.get("quantity"), "none") %>
    		<%= comm.addDlistColumn((String)tempH.get("units"), "none") %>			
			<%= comm.addDlistColumn((String)tempH.get("substituted"),"none") %>
<%
			if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
		}
%>		
		    <%= comm.endDlistTable() %>  
<%	
	}	
	if (dkPPVect.size()>0) {
%> 
		<br /><b><%= rfqNLS.get("rfqdynamickitpercentagepriceinfo") %></b>
		<%= comm.startDlistTable((String)rfqNLS.get("rfqdynamickitpercentagepriceinfo")) %>
		<%= comm.startDlistRowHeading() %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqdynamickitname"),"none",false,"20%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("product_partno"),"none",false,"12%" ) %>		
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"none",false,"20%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("category"),"none",false,"20%" ) %> 
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqpercentageajust"),"none",false,"16%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("productcanbesubstituted"),"none",false,"24%" ) %>
		<%= comm.endDlistRowHeading() %>
<%
		rowselect=1;	
		for (int i = 0; i < dkPPVect.size(); i++) {	
			Hashtable tempH = (Hashtable)dkPPVect.elementAt(i);	
%>
			<%= comm.startDlistRow(rowselect) %> 
    		<%= comm.addDlistColumn((String)tempH.get("prodname"), "javascript:goToConfigurationReport("+rfqid+","+ tempH.get("rfqprodid")+")") %>
    		<%= comm.addDlistColumn((String)tempH.get("partNum"), "none") %>
    		<%= comm.addDlistColumn((String)tempH.get("desc"), "none") %>	
<%
			String anId = (String)tempH.get("prodcategoryid");
			if (anId != null && anId.length()> 0 ) {
%>
			<%= comm.addDlistColumn((String)tempH.get("categoryname"), "javascript:goToCategory("+rfqid+","+ tempH.get("prodcategoryid")+")") %>
<%
			} else {
%>
				<%= comm.addDlistColumn((String)tempH.get("categoryname"), "javascript:goToCategory("+rfqid+")") %>
<%
			}
%>
			<%= comm.addDlistColumn((String)tempH.get("priceadjust") + " " + (String)rfqNLS.get("percentagemark"), "none") %>		
			<%= comm.addDlistColumn((String)tempH.get("substituted"), "none") %>
<%
			if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
		}
%>		
		    <%= comm.endDlistTable() %>  
<%
	
	}	
	if (dkFPVect.size()>0) {
%>	
		<br /><b><%= rfqNLS.get("rfqdynamickitfixedpriceinfo") %></b>		
		<%= comm.startDlistTable((String)rfqNLS.get("rfqdynamickitfixedpriceinfo")) %>
		<%= comm.startDlistRowHeading() %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqdynamickitname"),"none",false,"15%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("product_partno"),"none",false,"12%" ) %>		
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"none",false,"15%" ) %>
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("category"),"none",false,"12%" ) %> 
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("price"),"none",false,"12%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("currency"),"none",false,"12%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("quantity"),"none",false,"10%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqunits"),"none",false,"12%" ) %>	
		<%= comm.addDlistColumnHeading((String)rfqNLS.get("productcanbesubstituted"),"none",false,"12%" ) %>
		<%= comm.endDlistRowHeading() %>
<%
		rowselect=1;	
		for (int i = 0; i < dkFPVect.size(); i++) {	
			Hashtable tempH = (Hashtable)dkFPVect.elementAt(i);	
%>
			<%= comm.startDlistRow(rowselect) %> 
    		<%= comm.addDlistColumn((String)tempH.get("prodname"), "javascript:goToConfigurationReport("+(rfqid == null ? null : UIUtil.toJavaScript(rfqid))+","+ tempH.get("rfqprodid")+")") %>
    		<%= comm.addDlistColumn((String)tempH.get("partNum"), "none") %>
    		<%= comm.addDlistColumn((String)tempH.get("desc"), "none") %>	
<%
			String anId = (String)tempH.get("prodcategoryid");
			if (anId != null && anId.length()> 0 ) {
%>
				<%= comm.addDlistColumn((String)tempH.get("categoryname"), "javascript:goToCategory("+rfqid+","+ tempH.get("prodcategoryid")+")") %>
<%
			} else {
%>
				<%= comm.addDlistColumn((String)tempH.get("categoryname"), "javascript:goToCategory("+rfqid+")") %>
<%
			}
%>
    		<%= comm.addDlistColumn((String)tempH.get("price"), "none") %>
    		<%= comm.addDlistColumn((String)tempH.get("currency"), "none") %>
    		<%= comm.addDlistColumn((String)tempH.get("quantity"), "none") %>
    		<%= comm.addDlistColumn((String)tempH.get("units"), "none") %>			
			<%= comm.addDlistColumn((String)tempH.get("substituted"),"none") %>
<%
			if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
		}
%>		
		    <%= comm.endDlistTable() %>  
<%		    
	}
} // end if all Products...


%>

<br /><br />

</form>

</body>
</html>

