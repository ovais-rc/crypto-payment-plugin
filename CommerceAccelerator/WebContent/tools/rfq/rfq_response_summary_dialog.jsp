

<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2016
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.DataBeanManager" %> 
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.contract.beans.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.contract.util.*" %>
<%@ page import="com.ibm.commerce.fulfillment.beans.*" %>
<%@ page import="com.ibm.commerce.rfq.beans.*" %>
<%@ page import="com.ibm.commerce.rfq.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.price.utils.*"  %>
<%@ page import="com.ibm.commerce.price.*"  %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.utf.objects.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.RFQPriceAdjustmentOnCategory" %> 
<%@ page import="com.ibm.commerce.catalog.beans.*" %>

<%@ include file="../common/common.jsp" %>

<%
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    Locale locale = null;
    boolean wrap = true;
    if( aCommandContext!= null ) {
       	locale = aCommandContext.getLocale();
    }
    if (locale == null) {
	locale = new Locale("en","US");
    }
    
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", locale);
    String strPercentage = (String)rfqNLS.get("percentagemark");

    JSPHelper jsphp=new JSPHelper(request);
    String resId = jsphp.getParameter("resId");  
        
    RFQResponseDataBean RFQres = new RFQResponseDataBean();
    RFQres.setInitKey_rfqResponseId(Long.valueOf(resId));
    String resName = RFQres.getName();
   
    String lang = aCommandContext.getLanguageId().toString();
    
    if (resName == null) { 
    	resName = " ";
    }
    String resRemark = RFQres.getRemarks();
    if (resRemark == null) {
    	resRemark = " ";
    }    
    
    String RequestId =RFQres.getRfqId();
    RFQDataBean rfq=new RFQDataBean();
    rfq.setRfqId(RequestId);    
    String reqName= rfq.getName(); 
	if (reqName == null) {
    	reqName = " ";
    }      
    
    
    boolean endresult_to_contract = false;
    String endresult = null;    
    endresult = rfq.getEndResult();
    if (endresult.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_UTF_ENDRESULT_CONTRACT.toString())) 
    {
        endresult_to_contract = true;
    }
   
    
    Integer langId = aCommandContext.getLanguageId();
    String StoreId = aCommandContext.getStoreId().toString();
    if ("0".equalsIgnoreCase(StoreId))
    {
   	StoreId = rfq.getStoreId();
    }
    StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(StoreId));
    CurrencyManager cm = CurrencyManager.getInstance();
    String currencyCode = cm.getDefaultCurrency(storeAB, langId);   
    FormattedMonetaryAmount fmt = null;

    String strResponseAcceptAllProd;
    if (RFQres.getAcceptaction().equals(RFQConstants.EC_RESPONSE_ACCEPTACTION_ALL.toString())) {
        strResponseAcceptAllProd = (String)rfqNLS.get("yes");
    } else {
        strResponseAcceptAllProd = (String)rfqNLS.get("no");
    }
    
    String ffmcenterName = " ";
    RFQResFulfillmentTC ResponseFfmcenterTC = RFQResProdHelper.getRFQLevelFfmcenterTC(resId);
    if (ResponseFfmcenterTC != null) {
        String ResponseFfmcenterId = ResponseFfmcenterTC.getRes_Ffmcenter_ID().toString();
        FulfillmentCenterDescriptionDataBean abFulfillmentCenterDesc = new FulfillmentCenterDescriptionDataBean();
        abFulfillmentCenterDesc.setDataBeanKeyLanguageId(lang);
        abFulfillmentCenterDesc.setDataBeanKeyFulfillmentCenterId(ResponseFfmcenterId);
        ffmcenterName = abFulfillmentCenterDesc.getDisplayName();
        if (ffmcenterName == null) {
            ffmcenterName = ResponseFfmcenterId;
    	}
    }
    
    String resState = RFQres.getState().toString().trim();
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_DRAFT.toString())) {
         resState = rfqNLS.get("draft").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_ACTIVE.toString())) {
         resState = rfqNLS.get("active").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_CANCELLED.toString())) {
         resState = rfqNLS.get("canceled").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_IN_EVALUATION.toString())) {
         resState = rfqNLS.get("inevaluation").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_PENDING_APPROVAL.toString())) {
         resState = rfqNLS.get("pendingapproval").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_REJECTED.toString())) {
         resState = rfqNLS.get("rejected").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_RETRACTED.toString())) {
         resState = rfqNLS.get("retracted").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_WON.toString())) {
         resState = rfqNLS.get("won").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_LOST.toString())) {
         resState = rfqNLS.get("lost").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_WON_COMPLETED.toString())) {
         resState = rfqNLS.get("wonCompleted").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_LOST_COMPLETED.toString())) {
         resState = rfqNLS.get("lostCompleted").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_WON_NEXTROUND.toString())) {
         resState = rfqNLS.get("wonnextround").toString();
    }
    if (resState != null && resState.equals(RFQConstants.EC_RESPONSE_STATE_LOST_NEXTROUND.toString())) {
         resState = rfqNLS.get("lostnextround").toString();
    }


    String allProductsSelected = request.getParameter("allProductsSelected");
    if (allProductsSelected == null || allProductsSelected.length() == 0) {
        allProductsSelected = "1";
    }    
    //no wrapping for the asian languages
    if(langId.intValue() <= -7 && langId.intValue() >= -10) { wrap = false; } 

    // Need logic for contract account:    
	boolean inContractList = true;
	inContractList = ! inContractList;
	
    boolean hasFPP = false;
    boolean hasPPP = false;
    boolean hasFPDK = false;
    boolean hasPPDK = false;

    java.text.NumberFormat numberFormatter;
    numberFormatter = java.text.NumberFormat.getNumberInstance(locale);   
%>

<!-- RFQ Level Attachments List for RFQ response -->
<jsp:useBean id="attachmentList" class="com.ibm.commerce.rfq.beans.RFQAttachmentListBean" >
<jsp:setProperty property="*" name="attachmentList" />
</jsp:useBean>
<%
    attachmentList.setTradingId(Long.valueOf(resId));
    DataBeanManager.activate(attachmentList, request);
    AttachmentDataBean[] attachList = attachmentList.getAttachments();
%> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2008, 2013 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript">
function initializeState() {
	parent.setContentFrameLoaded(true);
}
function CommentsTC(res_tc_id,mandatory,changeable,res_comments) {
	this.<%= RFQConstants.EC_RESPONSE_TC_ID %>=res_tc_id;
	this.<%= RFQConstants.EC_ATTR_MANDATORY %>=mandatory;
	this.<%= RFQConstants.EC_ATTR_CHANGEABLE %>=changeable;
	this.<%= RFQConstants.EC_ATTR_RES_CMMENTS_VALUE %>=res_comments;
}
function product(productId, price, type, req_type, description, pprice, partnum, quantity, currency, unit, catentryid, name, reqCatentryid, reqName, reqCategoryId, reqCategoryName, reqProductId) {
	this.<%= RFQConstants.EC_OFFERING_PRODUCTID %>=productId;
	this.<%= RFQConstants.EC_OFFERING_PRICE %>=price;
	this.type=type;
	this.req_type=req_type;
	this.description=description;
	this.<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %>=pprice;
	this.partnum=partnum;
	this.<%= RFQConstants.EC_OFFERING_QUANTITY %>=quantity;
	this.<%= RFQConstants.EC_OFFERING_CURRENCY %> = currency;
	this.<%= RFQConstants.EC_OFFERING_UNIT %> = unit;
	this.<%= RFQConstants.EC_OFFERING_CATENTRYID %>=catentryid;
	if (name == null || name =="" || name == undefined) {
		this.<%= RFQConstants.EC_OFFERING_NAME %>="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
	} else {
		this.<%= RFQConstants.EC_OFFERING_NAME %>=name;
	}
	this.<%= RFQConstants.EC_RFQ_OFFERING_CATENTRYID %>=reqCatentryid;
	this.<%= RFQConstants.EC_RFQ_OFFERING_NAME %>=reqName;
	this.<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYID %>=reqCategoryId;
	this.<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYNAME %>=reqCategoryName;
	this.<%= RFQConstants.EC_RFQ_OFFERING_PRODUCTID %>=reqProductId;
	
	
	
	
}
function getNewSummaryBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("ressummary")) %>";
}
function showCategoryOnly() {
	var url = '/webapp/wcs/tools/servlet/DialogView';
	var resState = '<%= UIUtil.toJavaScript(resState) %>';
	var draft = '<%= UIUtil.toJavaScript(rfqNLS.get("draft"))%>';
	if (resState == draft) {
	    url = url + '?XMLFile=rfq.responseSummaryShowCategoryOnly_draft';
	} else {
	    url = url + '?XMLFile=rfq.responseSummaryShowCategoryOnly';
	}
    var urlParams = new Object();
    urlParams.resId = <%= resId %>;
    urlParams.allProductsSelected = "0";
	top.setContent(getNewSummaryBCT(), url, false, urlParams);
}
function showAllProducts() {
	var url = '/webapp/wcs/tools/servlet/DialogView';
	var resState = '<%= UIUtil.toJavaScript(resState) %>';
	var draft = '<%= UIUtil.toJavaScript(rfqNLS.get("draft"))%>';
	if (resState == draft) {
	    url = url + '?XMLFile=rfq.responseSummaryShowAllProducts_draft';
    } else {
	    url = url + '?XMLFile=rfq.responseSummary';
	}
    var urlParams = new Object();
    urlParams.resId = <%= resId %>;
    urlParams.allProductsSelected = "1";
	top.setContent(getNewSummaryBCT(), url, false, urlParams);
}
function submitResponse() {
    var resId = "<%= resId %>";
    var rfqId = "<%= RequestId %>";
    var eventid="<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_SUBMIT_RFQ_RESPONSE_EVENT_IDENTIFIER %>";
	if (!confirmDialog("<%= UIUtil.toJavaScript(rfqNLS.get("submitRsp")) %>")) {
		return;
	}
    var url = "/webapp/wcs/tools/servlet/RFQResponseSubmit?redirecturl=NewDynamicListView&ActionXMLFile=rfq.rfqresponselist&cmd=RFQResponseList&selected=SELECTED&listsize=15&startindex=0&rfqId="+rfqId+"&<%=BusinessFlowConstants.EC_ENTITY_ID%>=" + resId + "&flowType=RFQResponse&event="+eventid;
	top.mccbanner.counter --;
    top.mccbanner.showbct();
    top.showContent(url);
}
function getNewBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqProduct")) %>";
}
function printAction() {
	window.print();
}
function goToAttachment(attachId) {
	var url = "RFQAttachmentView?<%= com.ibm.commerce.server.ECConstants.EC_ATTACH_ID %>=" + attachId + "&<%= com.ibm.commerce.rfq.utils.RFQConstants.EC_RFQ_RESPONSE_ID %>=<%= resId %>";
    var windowTitle = "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_Attachment")) %>";
    var attributes = 'left=0,top=0,width=1014,height=710,scrollbars=no,toolbar=no,directories=no,status=no,menubar=no,copyhistory=no,resizable=yes';
    var attachmentWindow = top.openChildWindow(url, windowTitle, attributes);
}
function getCategoryAttBCT() {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("category")) %>";
}

function categorySummary(categoryId) {

	var url = "DialogView?XMLFile=rfq.rfqAdjustmentCategorySummary&amp;categoryId="+categoryId+"&amp;rfqId=<%= RequestId %>";
			
	if (top.setContent) {
	    top.setContent(getCategorySummaryBCT(), url, true);
	} else {
	    parent.parent.location.replace(url);
	} 
}
function getCategorySummaryBCT() {
  	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_CategorySumm")) %>";
}

function goToCategory(responseId, rfqCategoryId) {
	var tmpCategoryId = "";
    if (rfqCategoryId != null) {
		tmpCategoryId = rfqCategoryId;
    }
    top.setContent(getCategoryAttBCT(), "DialogView?XMLFile=rfq.responseSummaryCategory&amp;resId="+responseId+"&amp;rfqCategoryId="+tmpCategoryId, true);
}
function goToProductFPP(Id) {
    top.saveData(productArrayFPP[Id],"anProduct");
   	var productId = productArrayFPP[Id].<%= RFQConstants.EC_OFFERING_PRODUCTID %>;
   	var url = "DialogView?XMLFile=rfq.resSummaryProduct&amp;ProductId="+productId;
   	top.setContent(getNewBCT(), url, true);
}
function goToProductPPP(Id) {
    top.saveData(productArrayPPP[Id],"anProduct");
   	var productId = productArrayPPP[Id].<%= RFQConstants.EC_OFFERING_PRODUCTID %>;
   	var url = "DialogView?XMLFile=rfq.resSummaryProduct&amp;ProductId="+productId;
   	top.setContent(getNewBCT(), url, true);
}
function goToConfigurationReport(rfqid, rfqProdId){
	top.setContent(getConfigurationReportBCT(), "DialogView?XMLFile=rfq.rfqRequestSummaryDynamicKitConfigReport&amp;rfqid="+rfqid+"&amp;rfqProdId="+rfqProdId, true);
}
function getConfigurationReportBCT() {
  	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_ConfigReport")) %>";
}
function savePanelData() {
	return true;
}
function validatePanel() {
	return true;
}
function getResId() {            
	return  "<%=UIUtil.toJavaScript((String)request.getParameter("resId"))%>";
}

    function initData() 
    {
<%
	RFQResCommentsPair[] commentsPair = RFQResProdHelper.getRFQLevelCommentsPair(RequestId, resId, null);
	for (int index=0; commentsPair  != null && index <commentsPair.length; index++) {
%>
	    TCs[<%= index %>] = new CommentsTC(
		<%= commentsPair[index].getRFQ_TC_ID() %>,
		"<%= commentsPair[index].getMandatory() %>",
		"<%= commentsPair[index].getChangeable()%>",
		"<%= UIUtil.toHTML(UIUtil.toJavaScript((String)commentsPair[index].getRes_value())) %>");
<%
    	}
     
        Integer[] negotiationTypes = new Integer[1];
        negotiationTypes[0] = new Integer (1);
        RFQResNewProd[] ResProsFPP = RFQResProdHelper.getResAllProdsForNegotiationType(RequestId, resId, langId, negotiationTypes);
	if (ResProsFPP != null && ResProsFPP.length > 0)
	{
	    hasFPP = true;
	}

	for (int i = 0;ResProsFPP != null && i < ResProsFPP.length;i++) 
	{
	    String req_productId = ResProsFPP[i].getReq_productId().toString();	     
	    
	    BigDecimal price_ejb=ResProsFPP[i].getPrice();
	    String price="";
	    if (price_ejb!=null && price_ejb.doubleValue() >= 0 ) 
	    {
		fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(price_ejb, currencyCode), storeAB, langId);
		price = fmt.getFormattedValue();	// price without prefix and postfix
	    } 
	    String type = "";
	    String req_type = "";
	    String partnum = "";
	    String description = "";
	    String res_catid = "";
	    String req_catid = "";

	    if (ResProsFPP[i].getReq_catentryId() != null) 
	    {
		req_catid = ResProsFPP[i].getReq_catentryId().toString();

	    }
			
	    if (ResProsFPP[i].getCatentry_id() != null) 
	    {	  
	  	res_catid = ResProsFPP[i].getCatentry_id().toString();
		partnum = ResProsFPP[i].getPartNumber();
		description = ResProsFPP[i].getProductDesc();

		type = ResProsFPP[i].getProductType().trim();
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeitem");
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");				
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				
		
		req_type = ResProsFPP[i].getReq_productType().trim();
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeitem");
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");			
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				
	    }

	    if (ResProsFPP[i].getHasResponse() != RFQConstants.EC_OFFERING_HAS_RESPONSE_NO)
            {
%>	
	    	productArrayFPP[<%= i %>]=new product(
	    	    "<%=ResProsFPP[i].getProduct_id() %>",
	    	    "<%=price %>",
	    	    "<%=type %>",
	    	    "<%=req_type %>",
	    	    "<%=description %>",
	    	    "<%= ResProsFPP[i].getPriceAdjustment() %>",	
	    	    "<%=partnum %>",    	
	    	    "<%=numberFormatter.format(ResProsFPP[i].getQuantity()) %>",
	    	    "<%=ResProsFPP[i].getCurrency() %>",
	    	    "<%=UIUtil.toJavaScript(ResProsFPP[i].getUnitDesc()) %>",	
	    	    "<%=res_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsFPP[i].getName())) %>",
		    "<%=req_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsFPP[i].getReq_name())) %>",
	   	    "<%=ResProsFPP[i].getReq_categoryId() %>",	    	
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsFPP[i].getReq_categoryName())) %>",
	    	    "<%=req_productId %>");
	        productArrayFPP[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_YES %>";
<%
	    }
	    else
	    {
%>	
	    	productArrayFPP[<%= i %>]=new product(
	    	    "",
	    	    "",
	    	    "",
	    	    "<%=req_type %>",
	    	    "",
	    	    "",	
	    	    "",    	
	    	    "",
	    	    "",
	    	    "",	
	    	    "",
	    	    "",
		    "<%=req_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsFPP[i].getReq_name())) %>",
	   	    "<%=ResProsFPP[i].getReq_categoryId() %>",	    	
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsFPP[i].getReq_categoryName())) %>",
	    	    "<%=req_productId %>");
	        productArrayFPP[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>";
<%
	    }
	}
 
        negotiationTypes[0] = new Integer (2);
        RFQResNewProd[] ResProsPPP = RFQResProdHelper.getResAllProdsForNegotiationType(RequestId, resId, langId, negotiationTypes);	
	if (ResProsPPP != null && ResProsPPP.length > 0)
	{
	    hasPPP = true;
	}

	for (int i = 0;ResProsPPP != null && i < ResProsPPP.length;i++) 
	{
	    String req_productId = ResProsPPP[i].getReq_productId().toString();
	    
	    BigDecimal price_ejb=ResProsPPP[i].getPrice();
	    String price="";
	    if (price_ejb!=null && price_ejb.doubleValue() >= 0 ) 
	    {
		fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(price_ejb, currencyCode), storeAB, langId);
		price = fmt.getFormattedValue();	// price without prefix and postfix
	    } 
	    String type = "";
	    String req_type = "";
	    String partnum = "";
	    String description = "";
	    String res_catid = "";
	    String req_catid = "";

	    if (ResProsPPP[i].getReq_catentryId() != null) 
	    {
		req_catid = ResProsPPP[i].getReq_catentryId().toString();

	    }
			
	    if (ResProsPPP[i].getCatentry_id() != null) 
	    {	  
	  	res_catid = ResProsPPP[i].getCatentry_id().toString();
		partnum = ResProsPPP[i].getPartNumber();
		description = ResProsPPP[i].getProductDesc();

		type = ResProsPPP[i].getProductType().trim();
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeitem");
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");			
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				

		req_type = ResProsPPP[i].getReq_productType().trim();
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeitem");
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");				
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				
	    }
		 
	    if (ResProsPPP[i].getHasResponse() != RFQConstants.EC_OFFERING_HAS_RESPONSE_NO)
            {
%>	
	    	productArrayPPP[<%= i %>]=new product(
	    	    "<%=ResProsPPP[i].getProduct_id() %>",
	    	    "<%=price %>",
	    	    "<%=type %>",
	    	    "<%=req_type %>",
	    	    "<%=description %>",
	    	    "<%= numberFormatter.format(ResProsPPP[i].getPriceAdjustment()) %>",	
	    	    "<%=partnum %>",    	
	    	    "<%=numberFormatter.format(ResProsPPP[i].getQuantity()) %>",
	    	    "<%=ResProsPPP[i].getCurrency() %>",
	    	    "<%=UIUtil.toJavaScript(ResProsPPP[i].getUnitDesc()) %>",	
	    	    "<%=res_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsPPP[i].getName())) %>",
		    "<%=req_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsPPP[i].getReq_name())) %>",
	   	    "<%=ResProsPPP[i].getReq_categoryId() %>",	    	
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsPPP[i].getReq_categoryName())) %>",
	    	    "<%=req_productId %>"	    	
	    	    );
	        productArrayPPP[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_YES %>";
<%
	    }
	    else
	    {
%>	
	    	productArrayPPP[<%= i %>]=new product(
	    	    "",
	    	    "",
	    	    "",
	    	    "<%=req_type %>",
	    	    "",
	    	    "",	
	    	    "",    	
	    	    "",
	    	    "",
	    	    "",	
	    	    "",
	    	    "",
		    "<%=req_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsPPP[i].getReq_name())) %>",
	   	    "<%=ResProsPPP[i].getReq_categoryId() %>",	    	
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsPPP[i].getReq_categoryName())) %>",
	    	    "<%=req_productId %>");
	        productArrayPPP[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>";
<%
	    }
	}

        negotiationTypes[0] = new Integer (3);
        RFQResNewProd[] ResProsFPDK = RFQResProdHelper.getResAllProdsForNegotiationType(RequestId, resId, langId, negotiationTypes);
	if (ResProsFPDK != null && ResProsFPDK.length > 0)
	{
	    hasFPDK = true;
	}

	for (int i = 0;ResProsFPDK != null && i < ResProsFPDK.length;i++) 
	{
	    String req_productId = ResProsFPDK[i].getReq_productId().toString();
	    
	    BigDecimal price_ejb=ResProsFPDK[i].getPrice();
	    String price="";
	    if (price_ejb!=null && price_ejb.doubleValue() >= 0 ) 
	    {
		fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(price_ejb, currencyCode), storeAB, langId);
		price = fmt.getFormattedValue();	// price without prefix and postfix
	    } 
	    String type = "";
	    String req_type = "";
	    String partnum = "";
	    String description = "";
	    String res_catid = "";
	    String req_catid = "";

	    if (ResProsFPDK[i].getReq_catentryId() != null) 
	    {
		req_catid = ResProsFPDK[i].getReq_catentryId().toString();

	    }
			
	    if (ResProsFPDK[i].getCatentry_id() != null) 
	    {	  
	  	res_catid = ResProsFPDK[i].getCatentry_id().toString();
		partnum = ResProsFPDK[i].getPartNumber();
		description = ResProsFPDK[i].getProductDesc();

		type = ResProsFPDK[i].getProductType().trim();
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeitem");
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");			
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				

		req_type = ResProsFPDK[i].getReq_productType().trim();
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeitem");
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");			
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				
	    }
		 
	    if (ResProsFPDK[i].getHasResponse() != RFQConstants.EC_OFFERING_HAS_RESPONSE_NO)
            {
%>	
	    	productArrayFPDK[<%= i %>]=new product(
	    	    "<%=ResProsFPDK[i].getProduct_id() %>",
	    	    "<%=price %>",
	    	    "<%=type %>",
	    	    "<%=req_type %>",
	    	    "<%=description %>",
	    	    "<%= ResProsFPDK[i].getPriceAdjustment() %>",	
	    	    "<%=partnum %>",    	
	    	    "<%=numberFormatter.format(ResProsFPDK[i].getQuantity()) %>",
	    	    "<%=ResProsFPDK[i].getCurrency() %>",
	    	    "<%=UIUtil.toJavaScript(ResProsFPDK[i].getUnitDesc()) %>",	
	    	    "<%=res_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsFPDK[i].getName())) %>",
		    "<%=req_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsFPDK[i].getReq_name())) %>",
	   	    "<%=ResProsFPDK[i].getReq_categoryId() %>",	    	
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsFPDK[i].getReq_categoryName())) %>",
	    	    "<%=req_productId %>");
	        productArrayFPDK[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_YES %>";
<%
	    }
	    else
	    {
%>	
	    	productArrayFPDK[<%= i %>]=new product(
	    	    "",
	    	    "",
	    	    "",
	    	    "<%=req_type %>",
	    	    "",
	    	    "",	
	    	    "",    	
	    	    "",
	    	    "",
	    	    "",	
	    	    "",
	    	    "",
		    "<%=req_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsFPDK[i].getReq_name())) %>",
	   	    "<%=ResProsFPDK[i].getReq_categoryId() %>",	    	
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsFPDK[i].getReq_categoryName())) %>",
	    	    "<%=req_productId %>");
	        productArrayFPDK[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>";
<%
	    }
	}

        negotiationTypes[0] = new Integer (4);
        RFQResNewProd[] ResProsPPDK = RFQResProdHelper.getResAllProdsForNegotiationType(RequestId, resId, langId, negotiationTypes);
	if (ResProsPPDK != null && ResProsPPDK.length > 0)
	{
	    hasPPDK = true;
	}
    
	for (int i = 0;ResProsPPDK != null && i < ResProsPPDK.length;i++) 
	{
	    String req_productId = ResProsPPDK[i].getReq_productId().toString();
	    
	    BigDecimal price_ejb=ResProsPPDK[i].getPrice();
	    String price="";
	    if (price_ejb!=null && price_ejb.doubleValue() >= 0 )
	    {
		fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(price_ejb, currencyCode), storeAB, langId);
		price = fmt.getFormattedValue();	// price without prefix and postfix
	    } 
	    String type = "";
	    String req_type = "";
	    String partnum = "";
	    String description = "";
	    String res_catid = "";
	    String req_catid = "";

	    if (ResProsPPDK[i].getReq_catentryId() != null) 
	    {
		req_catid = ResProsPPDK[i].getReq_catentryId().toString();

	    }
			
	    if (ResProsPPDK[i].getCatentry_id() != null) 
	    {	  
	  	res_catid = ResProsPPDK[i].getCatentry_id().toString();
		partnum = ResProsPPDK[i].getPartNumber();
		description = ResProsPPDK[i].getProductDesc();

		type = ResProsPPDK[i].getProductType().trim();
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeitem");
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");			
		if (type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				
	
		req_type = ResProsPPDK[i].getReq_productType().trim();
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeitem");
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");				
		if (req_type.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) req_type = (String)rfqNLS.get("rfqproductrequesttypedynamickit");				
	    }
		 
	    if (ResProsPPDK[i].getHasResponse() != RFQConstants.EC_OFFERING_HAS_RESPONSE_NO)
            {
%>	
	    	productArrayPPDK[<%= i %>]=new product(
	    	    "<%=ResProsPPDK[i].getProduct_id() %>",
	    	    "<%=price %>",
	    	    "<%=type %>",
	    	    "<%=req_type %>",
	    	    "<%=description %>",
	    	    "<%= numberFormatter.format(ResProsPPDK[i].getPriceAdjustment()) %>",	
	    	    "<%=partnum %>",    	
	    	    "<%=numberFormatter.format(ResProsPPDK[i].getQuantity()) %>",
	    	    "<%=ResProsPPDK[i].getCurrency() %>",
	    	    "<%=UIUtil.toJavaScript(ResProsPPDK[i].getUnitDesc()) %>",	
	    	    "<%=res_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsPPDK[i].getName())) %>",
		    "<%=req_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsPPDK[i].getReq_name())) %>",
	   	    "<%=ResProsPPDK[i].getReq_categoryId() %>",	    	
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsPPDK[i].getReq_categoryName())) %>",
	    	    "<%=req_productId %>");
	        productArrayPPDK[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_YES %>";
<%
	    }
	    else
	    {
%>	
	    	productArrayPPDK[<%= i %>]=new product(
	    	    "",
	    	    "",
	    	    "",
	    	    "<%=req_type %>",
	    	    "",
	    	    "",	
	    	    "",    	
	    	    "",
	    	    "",
	    	    "",	
	    	    "",
	    	    "",
		    "<%=req_catid %>",
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsPPDK[i].getReq_name())) %>",
	   	    "<%=ResProsPPDK[i].getReq_categoryId() %>",	    	
	    	    "<%=UIUtil.toHTML(UIUtil.toJavaScript((String)ResProsPPDK[i].getReq_categoryName())) %>",
	    	    "<%=req_productId %>");
	        productArrayPPDK[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>";
<%
	    }
	}
%> 
    }

    var TCs = new Array();
    var productArrayFPP = new Array();
    var productArrayPPP = new Array();
    var productArrayFPDK = new Array();
    var productArrayPPDK = new Array();
    initData();
</script>
</head>

<body class="content" >

<br /><h1><%= rfqNLS.get("resresponsesummary") %></h1>

<form name="ResponseSummaryForm" action="">

<table> 
    <tr>
	<td align="center"><b><%= rfqNLS.get("General") %></b></td>
    </tr>
</table>
<table>
    <tr>
	<td> <%= rfqNLS.get("modifyresponsename") %>: <i><%=UIUtil.toHTML(resName)%></i></td>
    </tr>
    <tr>
	<td><%= rfqNLS.get("modifyresponseremark") %>: <i><%=UIUtil.toHTML(resRemark)%></i></td>
    </tr>
    <tr>
        <td><%= rfqNLS.get("ffmcenter") %>: <i><%=UIUtil.toHTML(ffmcenterName)%></i></td>
    </tr>
    <tr>
        <td><%= rfqNLS.get("acceptallproducts") %>: <i><%=UIUtil.toHTML(strResponseAcceptAllProd)%></i></td>
    </tr>
    <tr>
	<td><%= rfqNLS.get("status") %>: <i><%=UIUtil.toHTML(resState)%></i></td>
    </tr>    
    <tr>
	<td><%= rfqNLS.get("rfqname") %>: <i><%=UIUtil.toHTML(reqName)%></i></td>
    </tr>    

</table>

<br />
 <b><%= rfqNLS.get("rfqresponseattachments") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("rfqresponseattachments")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("filename"),"none",false,"30%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("description"),"none",false,"50%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("filesize"),"none",false,"20%" ) %>
    <%= comm.endDlistRowHeading() %>

<%
    int rowselect=1;
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
      
   
<br />
<b><%= rfqNLS.get("resTermsandConditions") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("resTermsandConditions")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("mandatory"),"none",false,"32%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqchangeable"),"none",false,"32%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("responsetc"),"none",false,"36%" ) %>
    <%= comm.endDlistRowHeading() %>

<script type="text/javascript">
temp="";
var rowselect=1;  
if (TCs.length > 0) {  
  	for (var i =0 ;i <TCs.length;i++) {
  	
  	    if (TCs[i].<%= RFQConstants.EC_ATTR_RES_CMMENTS_VALUE %>==null || TCs[i].<%= RFQConstants.EC_ATTR_RES_CMMENTS_VALUE %>=="") {
  			continue;
	    } 
	    
 	    startDlistRow(rowselect);
	    if(TCs[i].<%= RFQConstants.EC_ATTR_MANDATORY %> == 1) {
	   		temp = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
	    } else {
	   		temp = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
	    }
	    
	    addDlistColumn(temp);
	    if(TCs[i].<%= RFQConstants.EC_ATTR_CHANGEABLE %> == 1) {
	   		temp = "<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
	    } else {
	   		temp = "<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
	    }
	    
	    addDlistColumn(temp);
	    addDlistColumn(TCs[i].<%= RFQConstants.EC_ATTR_RES_CMMENTS_VALUE %>);
	    endDlistRow();
	    
	    if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
    }
}
</script>
    <%= comm.endDlistTable() %>  
   
<%
    boolean hasPriceAdjustmentOnCategory = RFQProductHelper.hasPriceAdjustmentOnCategory(new Long(RequestId));				
    if(hasPriceAdjustmentOnCategory) 
    {	
%>
<jsp:useBean id="catalogBean" class="com.ibm.commerce.catalog.beans.CatalogDataBean" scope="page">
</jsp:useBean>
<% 
	rowselect=1;  
    	//String requestCatalogId = requestCatalogId = RFQProductHelper.getCatalogIdFromXmlFragment(new Long(RequestId));
	String requestCatalogId =  RFQProductHelper.getCatalogIdFromXmlFragment(new Long(RequestId));
	catalogBean.setCatalogId(requestCatalogId);   
	DataBeanManager.activate(catalogBean, request); 	
	
	//RFQPriceAdjustmentOnCategory[] rfqResPaArray = RFQResProdHelper.getAllResPriceAdjustmentOnCategory( new Long(RequestId), new Long(resId), catalogBean);
        String hasResponse = "";
	RFQResPriceAdjustmentOnCategory[] rfqResPaArray = RFQResProdHelper.getResAllPriceAdjustmentOnCategory( resId, lang);
		
	if (rfqResPaArray != null) 
	{
%>
<br />
 <b><%= rfqNLS.get("rfqadjustoncategories") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("rfqadjustoncategories")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("RFQCreateCategoryDisplay_Name"), "none", false, "25%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqcategorydescription"), "none", false, "30%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepriceadjustment_s"), "none", false, "20%" ) %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsecatalogsynchronized_s"), "none", false, "25%" ) %>
    <%= comm.endDlistRowHeading() %>	
<%	
	    String categoryName = "";		
	    String ppResposeAdjust = "";
	    String responseSynchronize = ""; 
	    String ppDescription = "";
	    String categoryId = "";
	    if( rfqResPaArray != null || rfqResPaArray.length !=0 ) 
	    {	
		for (int i = 0; i<rfqResPaArray.length; i++) 
		{	
		    RFQResPriceAdjustmentOnCategory rfqResPaObj = new RFQResPriceAdjustmentOnCategory();					
		    rfqResPaObj = rfqResPaArray[i];
		    hasResponse = rfqResPaObj.getHasResponse();
    		
    		    categoryName = rfqResPaObj.getCategoryName();
		    ppDescription = rfqResPaObj.getCategoryDescription();					
		    categoryId = rfqResPaObj.getCategoryId().toString();

		    ppResposeAdjust = rfqResPaObj.getResPriceAdjustment();
		    if (ppResposeAdjust != null && ppResposeAdjust.length() > 0) 
		    {
            	        Double ptemp = Double.valueOf(ppResposeAdjust);
            		if (ptemp != null && ptemp.doubleValue() <= 0) 
            		{
          		    ppResposeAdjust = numberFormatter.format(ptemp);
			}		
		    }
		    								
		    if (rfqResPaObj.getResSynchronize().equals("true"))	
 		    {
			responseSynchronize = (String)rfqNLS.get("yes");			
		    } 
		    else if (rfqResPaObj.getResSynchronize().equals("false")) 
		    {
			responseSynchronize = (String)rfqNLS.get("no");				
		    } 

		    if (hasResponse.equals(RFQConstants.EC_RFQ_RESPOND_TO_CATEGORY_NO))
		    {
			ppResposeAdjust = "";
			responseSynchronize = "";
		    }
		    else
		    {
			ppResposeAdjust = ppResposeAdjust + " " + strPercentage;
		    }		    
%>			
		    <%= comm.startDlistRow(rowselect) %>
		    <%= comm.addDlistColumn(categoryName, "javascript:categorySummary("+categoryId+")") %>			
		    <%= comm.addDlistColumn(ppDescription, "none") %>			
	  	    <%= comm.addDlistColumn(ppResposeAdjust, "none") %>
		    <%= comm.addDlistColumn(responseSynchronize,"none") %>
		    <%= comm.endDlistRow() %>
<%					
		    if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
		}  // end of for...		
%>			
    		<%= comm.endDlistTable() %>			
<%		
	    } 
	    else
	    {
%>		
    	   	<%= rfqNLS.get("msgnocategoryadjust") %>		
<%			
	    }
	}
    }
%> 
   
<br />
 <b><%= rfqNLS.get("prodcategoryinfo") %></b>
    <%= comm.startDlistTable((String)rfqNLS.get("prodcategoryinfo")) %>
    <%= comm.startDlistRowHeading() %>
    <%= comm.addDlistColumnHeading((String)rfqNLS.get("category"),"none",true,"20%" ) %>
    <%= comm.endDlistRowHeading() %>	
<%	
    rowselect = 1;
    RFQCategryAccessBean abRFQCategry = new RFQCategryAccessBean();
    Enumeration enu = abRFQCategry.findByRFQId(Long.valueOf(RequestId));
    while (enu.hasMoreElements()) {
		RFQCategryAccessBean rfqCategry = (RFQCategryAccessBean)enu.nextElement();
		String rfqCategoryId = rfqCategry.getRfqCategryId();		
		String rfqCategoryName = UIUtil.toHTML(rfqCategry.getName());
%>
    	<%= comm.startDlistRow(rowselect) %>
    	<%= comm.addDlistColumn( rfqCategoryName,"javascript:goToCategory("+resId+","+rfqCategoryId+")") %>
    	<%= comm.endDlistRow() %>
<%
		if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
    }
%>
    <%= comm.startDlistRow(rowselect) %>
    <%= comm.addDlistColumn( (String)rfqNLS.get("RFQExtra_NotCategorized"),"javascript:goToCategory("+resId+")") %>
    <%= comm.endDlistRow() %>
    <%= comm.endDlistTable() %>
   
    
<br />

<%
    if (allProductsSelected.equals("1")) 
    {
      	if (hasPPP) 
	{
%>	    
	    <!-- Start Percentage Pricing on Products table -->
	    <b><%= rfqNLS.get("rfqproductpercentagepriceinfo") %></b>    
    
    	    <%= comm.startDlistTable((String)rfqNLS.get("rfqproductpercentagepriceinfo")) %>    
    	    <%= comm.startDlistRowHeading() %>
    	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("requestproductname"),"none",false,"15%", wrap ) %>
    	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("category"),"none",true,"10%", wrap ) %>
    	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestproducttype"),"none",false,"10%" ) %>
    	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("responseproductname"),"none",false,"15%", wrap ) %>	
	    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepartnumber"),"none",false,"15%", wrap ) %>
	    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponseproddescription"),"none",false,"15%", wrap ) %>
	    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponseprodtype"),"none",false,"10%", wrap ) %>
	    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepercentageadjustment"),"none",false,"10%", wrap ) %>    
<%
	if (!endresult_to_contract) {   
%> 	    	
	 		<%= comm.addDlistColumnHeading((String)rfqNLS.get("responsequantity"),"none",false,"8%", wrap ) %>
	    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("resresponseunit"),"none",false,"8%", wrap ) %>	    	
<% } %>	    	
    	    <%= comm.endDlistRowHeading() %>
<script type="text/javascript">
	    var rowselect=1;
  	    for (var i = 0 ; i < productArrayPPP.length; i++) 
	    { 
		var reqName = productArrayPPP[i].<%= RFQConstants.EC_RFQ_OFFERING_NAME %>;
		if (reqName == null || reqName =="" || reqName == undefined) {
			reqName ="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
		}
		var reqCategoryId = productArrayPPP[i].<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYID %>;
		var reqCategoryName = productArrayPPP[i].<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYNAME %>;
		if (reqCategoryName == null || reqCategoryName =="" || reqCategoryName == undefined) {
			reqCategoryName = "<%= UIUtil.toJavaScript(rfqNLS.get("RFQExtra_NotCategorized")) %>";
		}

	    	startDlistRow(rowselect);
	    	addDlistColumn(reqName);
		if (reqCategoryId == null || reqCategoryId == "null" || reqCategoryId =="" || reqCategoryId == undefined) {
	    	  	addDlistColumn(reqCategoryName,"javascript:goToCategory("+<%= resId %>+")");
		} else {
		   	addDlistColumn(reqCategoryName,"javascript:goToCategory("+<%= resId %>+","+reqCategoryId+")");
		}					
		addDlistColumn(productArrayPPP[i].req_type);  
		if (productArrayPPP[i].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> == "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>")
		{			
		    addDlistColumn("");
		}
		else
		{			
		    addDlistColumn(productArrayPPP[i].<%= RFQConstants.EC_OFFERING_NAME %>,"javascript:goToProductPPP("+ i +")");
		}
		addDlistColumn(productArrayPPP[i].partnum);
		addDlistColumn(productArrayPPP[i].description);
		addDlistColumn(productArrayPPP[i].type);
		if (productArrayPPP[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> == null ||
		    productArrayPPP[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> == "")
		{		  	    	  	    
		    addDlistColumn("");   	     	
	    	}
		else
		{			  	    
		    addDlistColumn(productArrayPPP[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> + " " + "<%= strPercentage %>");
		}
<%
	if (!endresult_to_contract) {   
%>	   
	   addDlistColumn(productArrayPPP[i].<%= RFQConstants.EC_OFFERING_QUANTITY %>);
	   addDlistColumn(productArrayPPP[i].<%= RFQConstants.EC_OFFERING_UNIT %>);
<% } %>	   
	   	endDlistRow();
	    	
	    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }	    	
  	    }
</script>
    	    <%= comm.endDlistTable() %>
	    <!-- end Percentage Pricing on Products -->	
<%
        }

      	if (hasFPP) 
	{ 	
%>
	    <!-- Start Fixed Pricing on Products table -->
	    <br />
	    <b><%= rfqNLS.get("rfqproductfixedpriceinfo") %></b>    
    
	    <%= comm.startDlistTable((String)rfqNLS.get("rfqproductfixedpriceinfo")) %>    
	    <%= comm.startDlistRowHeading() %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("requestproductname"),"none",false,"10%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("category"),"none",true,"8%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestproducttype"),"none",false,"10%" ) %>    
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("responseproductname"),"none",false,"10%", wrap ) %>      
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepartnumber"),"none",false,"10%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponseproddescription"),"none",false,"10%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponseprodtype"),"none",false,"10%", wrap ) %>   
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("responseprice"),"none",false,"8%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("currency"),"none",false,"8%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("responsequantity"),"none",false,"8%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("resresponseunit"),"none",false,"8%", wrap ) %>
	    <%= comm.endDlistRowHeading() %>
<script type="text/javascript">
	    var rowselect=1;
  	    for (var i =0 ;i <productArrayFPP.length;i++) 
	    {   	
		var reqName = productArrayFPP[i].<%= RFQConstants.EC_RFQ_OFFERING_NAME %>;
		if (reqName == null || reqName =="" || reqName == undefined) {
			reqName ="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
		}
		var reqCategoryId = productArrayFPP[i].<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYID %>;
		var reqCategoryName = productArrayFPP[i].<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYNAME %>;
		if (reqCategoryName == null || reqCategoryName =="" || reqCategoryName == undefined) {
			reqCategoryName = "<%= UIUtil.toJavaScript(rfqNLS.get("RFQExtra_NotCategorized")) %>";
		}

	    	startDlistRow(rowselect);
	    	addDlistColumn(reqName);
		if (reqCategoryId == null || reqCategoryId == "null" || reqCategoryId =="" || reqCategoryId == undefined) {
	    	    	addDlistColumn(reqCategoryName,"javascript:goToCategory("+<%= resId %>+")");
		} else {
	    	    	addDlistColumn(reqCategoryName,"javascript:goToCategory("+<%= resId %>+","+reqCategoryId+")");
		}
				
		addDlistColumn(productArrayFPP[i].req_type);
		if (productArrayFPP[i].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> == "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>")
		{			
		    addDlistColumn("");
		}
		else
		{
		    addDlistColumn(productArrayFPP[i].<%= RFQConstants.EC_OFFERING_NAME %>,"javascript:goToProductFPP("+ i +")");   
		} 	    	
		addDlistColumn(productArrayFPP[i].partnum);
		addDlistColumn(productArrayFPP[i].description);
		addDlistColumn(productArrayFPP[i].type);  		
		addDlistColumn(productArrayFPP[i].<%= RFQConstants.EC_OFFERING_PRICE %>);
	    	addDlistColumn(productArrayFPP[i].<%= RFQConstants.EC_OFFERING_CURRENCY %>);
	    	addDlistColumn(productArrayFPP[i].<%= RFQConstants.EC_OFFERING_QUANTITY %>);
	    	addDlistColumn(productArrayFPP[i].<%= RFQConstants.EC_OFFERING_UNIT %>);
	    	endDlistRow();
	    	
	    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
	    }
</script>
	    <%= comm.endDlistTable() %>
	    <!-- end Fixed Pricing on Products -->
<%
    	}    

      	if (hasPPDK) 
	{ 	
%>
	    <!-- Start Percentage Pricing on Dynamic kits -->
	    <br />
	    <b><%= rfqNLS.get("rfqdynamickitpercentagepriceinfo") %></b>    
    
	    <%= comm.startDlistTable((String)rfqNLS.get("rfqdynamickitpercentagepriceinfo")) %>    
	    <%= comm.startDlistRowHeading() %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqdynamickitname"),"none",false,"15%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("category"),"none",true,"15%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsedynamickitname"),"none",false,"15%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepartnumber"),"none",false,"15%", wrap ) %>	
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsedynamickitdescription"),"none",false,"25%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepercentageadjustment"),"none",false,"15%", wrap ) %>    
	    <%= comm.endDlistRowHeading() %>
<script type="text/javascript">
	    var rowselect=1;
  	    for (var i =0 ;i <productArrayPPDK.length;i++) 
	    { 
		var reqName = productArrayPPDK[i].<%= RFQConstants.EC_RFQ_OFFERING_NAME %>;
		if (reqName == null || reqName =="" || reqName == undefined) {
			reqName ="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
		}
		var reqCategoryId = productArrayPPDK[i].<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYID %>;
		var reqCategoryName = productArrayPPDK[i].<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYNAME %>;
		if (reqCategoryName == null || reqCategoryName =="" || reqCategoryName == undefined) {
					reqCategoryName = "<%= UIUtil.toJavaScript(rfqNLS.get("RFQExtra_NotCategorized")) %>";
		}

 	    	startDlistRow(rowselect);

	    	var reqType = productArrayPPDK[i].req_type;
                if (reqType == '<%= (String)rfqNLS.get("rfqproductrequesttypedynamickit") %>')
                {
                    var productId = productArrayPPDK[i].<%= RFQConstants.EC_RFQ_OFFERING_PRODUCTID %>;
                    addDlistColumn(reqName,"javascript:goToConfigurationReport("+<%=RequestId%>+", "+productId+")");
                }
                else
                {
                    addDlistColumn(reqName);
                }
                    
		if (reqCategoryId == null || reqCategoryId == "null" || reqCategoryId =="" || reqCategoryId == undefined) {
	    	  	 addDlistColumn(reqCategoryName,"javascript:goToCategory("+<%= resId %>+")");
		} else {
	    	    	addDlistColumn(reqCategoryName,"javascript:goToCategory("+<%= resId %>+","+reqCategoryId+")");
		}

		if (productArrayPPDK[i].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> == "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>")
		{			
		    addDlistColumn("");
		}
		else
		{    	    	
                    addDlistColumn(productArrayPPDK[i].<%= RFQConstants.EC_OFFERING_NAME %>);
		}

		addDlistColumn(productArrayPPDK[i].partnum);
		addDlistColumn(productArrayPPDK[i].description);
		if (productArrayPPDK[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> == null ||
		    productArrayPPDK[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> == "")
		{		  	    	  	    
		    addDlistColumn("");   	     	
	    	}
		else
		{		  	    	  	    
		    addDlistColumn(productArrayPPDK[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> + " " + "<%= strPercentage %>");   	     	
	    	}
	    	endDlistRow();
	    	
	    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
	    }
</script>
    	    <%= comm.endDlistTable() %>
	    <!-- end Percentage Pricing on Dynamic Kits -->	
<%
	}    

      	if (hasFPDK) 
	{ 	
%>
	    <!-- Start Fixed Pricing on Dynamic Kits -->
	    <br />
	    <b><%= rfqNLS.get("rfqdynamickitfixedpriceinfo") %></b>     
    
	    <%= comm.startDlistTable((String)rfqNLS.get("rfqdynamickitfixedpriceinfo")) %>    
	    <%= comm.startDlistRowHeading() %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqdynamickitname"),"none",false,"10%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("category"),"none",true,"10%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsedynamickitname"),"none",false,"10%", wrap ) %>      
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepartnumber"),"none",false,"10%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsedynamickitdescription"),"none",false,"20%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("responseprice"),"none",false,"10%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("currency"),"none",false,"10%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("responsequantity"),"none",false,"10%", wrap ) %>
	    <%= comm.addDlistColumnHeading((String)rfqNLS.get("resresponseunit"),"none",false,"10%", wrap ) %>
	    <%= comm.endDlistRowHeading() %>

<script type="text/javascript">
	    var rowselect=1;
  	    for (var i =0 ;i <productArrayFPDK.length;i++) 
	    { 
		var reqName = productArrayFPDK[i].<%= RFQConstants.EC_RFQ_OFFERING_NAME %>;
		if (reqName == null || reqName =="" || reqName == undefined) {
			reqName ="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
		}
		var reqCategoryId = productArrayFPDK[i].<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYID %>;
		var reqCategoryName = productArrayFPDK[i].<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYNAME %>;
		if (reqCategoryName == null || reqCategoryName =="" || reqCategoryName == undefined) {
			reqCategoryName = "<%= UIUtil.toJavaScript(rfqNLS.get("RFQExtra_NotCategorized")) %>";
		}

 	    	startDlistRow(rowselect);
 	    	
 	        var reqType = productArrayFPDK[i].req_type;
                if (reqType == '<%= (String)rfqNLS.get("rfqproductrequesttypedynamickit") %>')
                {
                    var productId = productArrayFPDK[i].<%= RFQConstants.EC_RFQ_OFFERING_PRODUCTID %>;
                    addDlistColumn(reqName,"javascript:goToConfigurationReport("+<%=RequestId%>+", "+productId+")");
                }
                else
                {
                    addDlistColumn(reqName);
                }
                
		if (reqCategoryId == null || reqCategoryId == "null" || reqCategoryId =="" || reqCategoryId == undefined) {
	    	    	addDlistColumn(reqCategoryName,"javascript:goToCategory("+<%= resId %>+")");
		} else {
	    	    	addDlistColumn(reqCategoryName,"javascript:goToCategory("+<%= resId %>+","+reqCategoryId+")");
		}

		if (productArrayFPDK[i].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> == "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>")
		{			
		    addDlistColumn("");
		}
		else
		{
                    addDlistColumn(productArrayFPDK[i].<%= RFQConstants.EC_OFFERING_NAME %>);
		}

	    	addDlistColumn(productArrayFPDK[i].partnum);
		addDlistColumn(productArrayFPDK[i].description);	    		
	    	addDlistColumn(productArrayFPDK[i].<%= RFQConstants.EC_OFFERING_PRICE %>);
	    	addDlistColumn(productArrayFPDK[i].<%= RFQConstants.EC_OFFERING_CURRENCY %>);
	    	addDlistColumn(productArrayFPDK[i].<%= RFQConstants.EC_OFFERING_QUANTITY %>);
	    	addDlistColumn(productArrayFPDK[i].<%= RFQConstants.EC_OFFERING_UNIT %>);
	    		
	    	endDlistRow();
	    	
	    	if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }
  	    }
</script>
	    <%= comm.endDlistTable() %>
	    <!-- end Fixed Pricing on Dynamic Kits -->	  
<%
	}
    }
%>     
  
<br /><br />
<script type="text/javascript">
    initializeState();
</script>

</form>

</body>
</html>
