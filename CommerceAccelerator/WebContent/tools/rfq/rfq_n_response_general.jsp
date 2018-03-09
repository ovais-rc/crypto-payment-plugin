<%--==========================================================================
Licensed Materials - Property of IBM

WebSphere Commerce

(c) Copyright IBM Corp.  2006, 2017
All Rights Reserved

US Government Users Restricted Rights - Use, duplication or
disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
===========================================================================--%>

<%@ page import="java.util.*" %>
<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.rfq.beans.*" %>
<%@ page import="com.ibm.commerce.rfq.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.utf.objects.*" %>
<%@ page import="com.ibm.commerce.utf.utils.RFQProductHelper" %>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.FulfillmentJDBCHelperBean" %>
<%@ include file="../common/common.jsp" %>



<%
    //*** GET LOCALE FROM COMANDCONTEXT ***//
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    Locale locale = null;
    if( aCommandContext!= null ) {
   		locale = aCommandContext.getLocale();
    }
    if (locale == null) {
		locale = new Locale("en","US");
    }
    //*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",locale);
    JSPHelper jsphelper = new JSPHelper(request);	
    String ResponseId = jsphelper.getParameter("offerId" );	
    RFQResponseDataBean  RFQres = new RFQResponseDataBean();	
    RFQres.setInitKey_rfqResponseId(Long.valueOf(ResponseId));
    String RequestId =RFQres.getRfqId();
    String ResponseAcceptAllProd = RFQres.getAcceptaction();
    String ResponseFfmcenterTCId = "-1";
    String ResponseFfmcenterId = "-1";
    RFQResFulfillmentTC ResponseFfmcenterTC = RFQResProdHelper.getRFQLevelFfmcenterTC(ResponseId);
    if (ResponseFfmcenterTC != null) {
        ResponseFfmcenterTCId = ResponseFfmcenterTC.getRes_TC_ID().toString();
        ResponseFfmcenterId = ResponseFfmcenterTC.getRes_Ffmcenter_ID().toString();
    }
    
    Integer store_id = aCommandContext.getStoreId();
	FulfillmentJDBCHelperBean bFulfillmentCenter = SessionBeanHelper.lookupSessionBean(FulfillmentJDBCHelperBean.class);
    Vector vecFulfillmentCenterList = bFulfillmentCenter.findFfmcenterNameAndIdByStoreId(store_id,"N");			
    
    int hasCatPP = 0;
    boolean hasCategoryPP = RFQProductHelper.hasPriceAdjustmentOnCategory(new Long(RequestId));
    if (hasCategoryPP)
    {
	hasCatPP = 1;
    }

    Integer[] negotiationTypes = new Integer[1];
%>
<jsp:useBean id="prodFPList" class="com.ibm.commerce.utf.beans.RFQProdListBean">
<jsp:setProperty property="*" name="prodFPList" />
</jsp:useBean>
<%
    int hasProdFP = 0;
    negotiationTypes[0] = new Integer (1);
    prodFPList.setNegotiationTypes(negotiationTypes);
    prodFPList.setRFQId(RequestId);	
    com.ibm.commerce.beans.DataBeanManager.activate(prodFPList, request);
    RFQProdDataBean [] pFPList = prodFPList.getRFQProds();
    if (pFPList != null && pFPList.length > 0)
    {		               
    	hasProdFP = 1;
    }
%>
<jsp:useBean id="prodPPList" class="com.ibm.commerce.utf.beans.RFQProdListBean">
<jsp:setProperty property="*" name="prodPPList" />
</jsp:useBean>
<%
    int hasProdPP = 0;
    negotiationTypes[0] = new Integer (2);
    prodPPList.setNegotiationTypes(negotiationTypes);
    prodPPList.setRFQId(RequestId);	
    com.ibm.commerce.beans.DataBeanManager.activate(prodPPList, request);
    RFQProdDataBean [] pPPList = prodPPList.getRFQProds();
    if (pPPList != null && pPPList.length > 0)
    {		               
    	hasProdPP = 1;
    }
%>
<jsp:useBean id="dKitFPList" class="com.ibm.commerce.utf.beans.RFQProdListBean">
<jsp:setProperty property="*" name="dKitFPList" />
</jsp:useBean>
<%
    int hasDKitFP = 0;
    negotiationTypes[0] = new Integer (3);
    dKitFPList.setNegotiationTypes(negotiationTypes);
    dKitFPList.setRFQId(RequestId);	
    com.ibm.commerce.beans.DataBeanManager.activate(dKitFPList, request);
    RFQProdDataBean [] dFPList = dKitFPList.getRFQProds();
    if (dFPList != null && dFPList.length > 0)
    {		               
    	hasDKitFP = 1;
    }
%>
<jsp:useBean id="dKitPPList" class="com.ibm.commerce.utf.beans.RFQProdListBean">
<jsp:setProperty property="*" name="dKitPPList" />
</jsp:useBean>
<%
    int hasDKitPP = 0;
    negotiationTypes[0] = new Integer (4);
    dKitPPList.setNegotiationTypes(negotiationTypes);
    dKitPPList.setRFQId(RequestId);	
    com.ibm.commerce.beans.DataBeanManager.activate(dKitPPList, request);
    RFQProdDataBean [] dPPList = dKitPPList.getRFQProds();
    if (dPPList != null && dPPList.length > 0)
    {		               
    	hasDKitPP = 1;
    }
%>

<jsp:useBean id="rfq" class="com.ibm.commerce.utf.beans.RFQDataBean" >
<jsp:setProperty property="*" name="rfq" />
<jsp:setProperty property="rfqId" name="rfq" value="<%= RequestId %>" />
</jsp:useBean>
<%
    boolean endresult_to_contract = false;
    String endresult = null;
    com.ibm.commerce.beans.DataBeanManager.activate(rfq, request);
    String requestName = UIUtil.toHTML(rfq.getName());    
    endresult = rfq.getEndResult();
    if (endresult.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_UTF_ENDRESULT_CONTRACT.toString())) 
    {
        endresult_to_contract = true;
    } 
    
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/res_common.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfq_skippage.js"></script>
<script type="text/javascript">
var msgMandatoryField = '<%= UIUtil.toJavaScript((String)rfqNLS.get("msgMandatoryField")) %>';
var msgInvalidSize = '<%= UIUtil.toJavaScript((String)rfqNLS.get("msgInvalidSize")) %>';

    var hasProdFP = "<%= hasProdFP %>";
    var hasProdPP = "<%= hasProdPP %>";
    var hasDKitFP = "<%= hasDKitFP %>";
    var hasDKitPP = "<%= hasDKitPP %>";

    function initData() 
    {
    	parent.setContentFrameLoaded(false);
    	first = parent.get("<%= RFQConstants.EC_RFQ_REQUEST_ID %>");	
    	
    	top.saveData("<%= endresult_to_contract %>", "endresult_to_contract");

    	if (first == undefined )
    	{
	    var skipPagesArray = new Array();
            var hasCatPP = "<%= hasCatPP %>";
	    var i = 0;
            if (hasCatPP != "1") 
    	    {
	    	skipPagesArray[i] = "rfqadjustoncategories";
	    	i = i + 1;
            }
            if (hasProdFP != "1") 
    	    {
	    	skipPagesArray[i] = "rfqProductFixedPricing";
	    	i = i + 1;
            }
            if (hasProdPP != "1") 
    	    {
	    	skipPagesArray[i] = "rfqProductPercentagePricing";
	    	i = i + 1;
            }
            if (hasDKitFP != "1") 
    	    {
	    	skipPagesArray[i] = "rfqDynamicKitFixedPricing";
	    	i = i + 1;
            }
            if (hasDKitPP != "1") 
    	    {
	    	skipPagesArray[i] = "rfqDynamicKitPercentagePricing";
	    	i = i + 1;
            }

	    top.saveData(skipPagesArray, "skipPages");

	    if (skipPagesArray != null && skipPagesArray.length > 0) 
	    {
        	skipPages(parent.pageArray);
        	parent.reloadFrames();
	    }

	    top.saveData("<%= RequestId %>","requestId");
	    parent.put("<%= RFQConstants.EC_RFQ_REQUEST_ID %>", "<%= RequestId %>");
	    parent.put("<%= RFQConstants.EC_RFQ_RESPONSE_ID %>", "<%= ResponseId %>");
	    parent.put("<%= RFQConstants.EC_RFQ_RESPONSE_NAME %>", "<%= UIUtil.toJavaScript((String)RFQres.getName())%>");
	    parent.put("<%= RFQConstants.EC_RFQ_RESPONSE_REMARK%>", "<%= UIUtil.toJavaScript((String)RFQres.getRemarks())%>");

	    var acceptProducts = "<%= ResponseAcceptAllProd %>";
	    parent.put("<%=RFQConstants.EC_RFQ_RESPONSE_ACCEPTALLPRODUCTS%>", acceptProducts);

	    var ffmcenterObj = new Object();
	    ffmcenterObj.<%= RFQConstants.EC_RFQ_RESPONSE_FFMCENTER_ID %> = "<%= ResponseFfmcenterId %>";
	    ffmcenterObj.<%= RFQConstants.EC_RESPONSE_TC_ID %> = "<%= ResponseFfmcenterTCId %>";
	    ffmcenterObj.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_FALSE %>";
		parent.put("<%=RFQConstants.EC_RFQ_RESPONSE_FFMCENTER%>", ffmcenterObj);
	    parent.put("redirecturl", "<%= RFQConstants.EC_TOOL_NOTEBOOK_VIEW_CMD%>");
    	}
	retrievePanelData();	
	parent.setContentFrameLoaded(true);
    }

function retrievePanelData() {
	var form=document.rfqModifyForm;
	form.response_name.value = parent.get("<%= RFQConstants.EC_RFQ_RESPONSE_NAME%>");
	form.response_remark.value = parent.get("<%= RFQConstants.EC_RFQ_RESPONSE_REMARK%>");

        if (hasProdFP == '1' || hasProdPP == '1' || 
            hasDKitFP == '1' || hasDKitPP == '1') 
        {
	    var acceptProducts = parent.get("<%=RFQConstants.EC_RFQ_RESPONSE_ACCEPTALLPRODUCTS%>","");
	    if (acceptProducts == "<%= RFQConstants.EC_RESPONSE_ACCEPTACTION_PARTIAL %>") {
		document.rfqModifyForm.response_acceptAllProducts[1].checked = true;
	    } else if (acceptProducts == "<%= RFQConstants.EC_RESPONSE_ACCEPTACTION_ALL %>") {
		document.rfqModifyForm.response_acceptAllProducts[0].checked = true;
	    } else {	
		document.rfqModifyForm.response_acceptAllProducts[1].checked = true;
	    }
        }
	
	var ffmcenterObj = parent.get("<%=RFQConstants.EC_RFQ_RESPONSE_FFMCENTER%>","");
	form.response_ffmcenter.value = ffmcenterObj.<%=RFQConstants.EC_RFQ_RESPONSE_FFMCENTER_ID%>;
}
function savePanelData() {
  	parent.put("<%= RFQConstants.EC_RFQ_RESPONSE_NAME %>", self.rfqModifyForm.response_name.value);          
  	parent.put("<%= RFQConstants.EC_RFQ_RESPONSE_REMARK%>", self.rfqModifyForm.response_remark.value); 

        if (hasProdFP == '1' || hasProdPP == '1' || 
            hasDKitFP == '1' || hasDKitPP == '1') 
        {
	    if (self.rfqModifyForm.response_acceptAllProducts[1].checked) {	
		parent.put("<%=RFQConstants.EC_RFQ_RESPONSE_ACCEPTALLPRODUCTS%>", "<%=RFQConstants.EC_RESPONSE_ACCEPTACTION_PARTIAL%>");
	    } else {
		parent.put("<%=RFQConstants.EC_RFQ_RESPONSE_ACCEPTALLPRODUCTS%>", "<%=RFQConstants.EC_RESPONSE_ACCEPTACTION_ALL%>");
	    }
	}

	var ffmcenterObj = new Object();
	ffmcenterObj.<%= RFQConstants.EC_RFQ_RESPONSE_FFMCENTER_ID %> = document.rfqModifyForm.response_ffmcenter.value;
	ffmcenterObj.<%= RFQConstants.EC_RESPONSE_TC_ID %> = "<%= ResponseFfmcenterTCId %>";
	if (ffmcenterObj.<%= RFQConstants.EC_RFQ_RESPONSE_FFMCENTER_ID %> == "<%= ResponseFfmcenterId %>") {
	    ffmcenterObj.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_FALSE %>";
  	} else {
	    ffmcenterObj.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_TRUE %>";
	}
	parent.put("<%=RFQConstants.EC_RFQ_RESPONSE_FFMCENTER%>", ffmcenterObj);
  	parent.put("<%=BusinessFlowConstants.EC_FLOWID%>","<%=RFQConstants.EC_FLOW_RESPONSE_ID%>");
  	parent.put("<%=BusinessFlowConstants.EC_BUSINESS_FLOW_EVENT_IDENTIFIER%>","modifyRFQResponse");
  	parent.put("<%=BusinessFlowConstants.EC_ENTITY_ID%>","<%= ResponseId%>");
  	parent.put("<%=BusinessFlowConstants.EC_FLOWTYPE_IDENTIFIER%>","<%= RFQConstants.EC_FLOW_TYPE_RESPONSE%>");
}
function validateNoteBookPanel() {
  	var form=document.rfqModifyForm;  
  	if (form.response_name.value == "") {
  	    reprompt(form.response_name, msgMandatoryField);
	    form.response_name.focus();
  	    return false;
  	}
  	if (!isValidUTF8length(form.response_name.value,200)) {
  	    reprompt(form.response_name, msgInvalidSize);
  	    form.response_name.focus();
  	    return false;
  	}
  	if (!isValidUTF8length(form.response_remark.value,254)) {
  	    reprompt(form.response_remark, msgInvalidSize);
  	    form.response_remark.focus();
  	    return false;
  	}
  	return true;
}
   
    function trapKeyPress()
    {
        //Disable ENTER key
        if (window.event && window.event.keyCode == 13)
        {
            validateNoteBookPanel();
            window.event.keyCode = 0;
        }
    }
    
</script>
	
</head>

<body class="content" onload="initData()">
<br />
<h1> <%= rfqNLS.get("general") %> </h1>

<table>
    <tr>
		<td><%= rfqNLS.get("rfq_name") %>:  <i><%= requestName %></i><br /></td>
    </tr>
    <tr><td>&nbsp;</td></tr>     
    <tr>
		<td><%= rfqNLS.get("instruction_General") %><br /></td>
    </tr>
</table>


<form name="rfqModifyForm" action="">
<table width="100%">

    <tr>
        <td>
	    <label for="responseName">
	    <%= rfqNLS.get("name") %><br />
	    <input type="text" name="response_name" id="responseName" onkeypress="trapKeyPress()" />
            </label>
        </td>
    </tr>
    <tr>
        <td>
	    <label for="responseRemark">
	    <br /><%= rfqNLS.get("remark") %><br />
       	    <textarea rows="4" cols="40" name="response_remark" id="responseRemark"></textarea>
            </label>
	</td>
    </tr>
    <tr>
        <td>
	    <label for="ffmcenter">
            <br /><%= rfqNLS.get("ffmcenter") %><br />
            </label>
            <select name="response_ffmcenter" id="ffmcenter">
<%
    int firsttime = 1;
    if (firsttime == 1)
    {
%>
               <option value="-1" selected="selected">
               </option>
<%
    }
    else
    {
%>
               <option value="-1">
               </option>
<%
    }
    firsttime = 0;
  
    
     for (int i=0; i < vecFulfillmentCenterList.size() ; i++) {
        Vector fulfillmentCenter = (Vector) vecFulfillmentCenterList.elementAt(i);
	String ffmcenterId = ((Integer)fulfillmentCenter.elementAt(1)).toString();
   	String ffmcenterName = (String) fulfillmentCenter.elementAt(0);
      	if (ffmcenterName == null) {
            ffmcenterName = ffmcenterId;
        }
%>
                <option value="<%= ffmcenterId %>">
                <%= UIUtil.toHTML(ffmcenterName) %>
                </option>
<%
    }
%>
            </select>
        </td>
    </tr>
<%
    if (hasProdFP == 1 || hasProdPP == 1 || 
        hasDKitFP == 1 || hasDKitPP == 1) 
    {
%>
    <tr>
        <td>
	<br /><%= rfqNLS.get("acceptallproducts") %><br />
        <label for="responseAcceptAllProductsYes">
        <input type="radio" name="response_acceptAllProducts" id="responseAcceptAllProductsYes" value="yes" />
        <%=UIUtil.toHTML((String)rfqNLS.get("yes"))%>
        </label>
	<br />
        <label for="responseAcceptAllProductsNo">
        <input type="radio" name="response_acceptAllProducts" id="responseAcceptAllProductsNo" value="no" />
        <%=UIUtil.toHTML((String)rfqNLS.get("no"))%>
        </label>
        </td>
    </tr>
<%
    }
%>
</table>
</form>

</body>
</html>
