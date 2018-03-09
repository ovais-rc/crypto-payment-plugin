<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2006, 2017 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>


<%@ page import="com.ibm.commerce.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryAccessBean" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.contract.beans.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.inventory.beans.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.utf.utils.UTFConstants" %>
<%@ page import="com.ibm.commerce.utf.beans.RFQProdDataBean" %>
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.utf.helper.RFQSortingAttribute" %>
<%@ page import="com.ibm.commerce.utf.utils.RFQProductHelper" %>
<%@ page import="com.ibm.commerce.catalog.objects.CatalogEntryDescriptionAccessBean"%>
<%@ page import="com.ibm.commerce.rfq.objects.*" %>
<%@ page import="com.ibm.commerce.contract.objects.AttachmentAccessBean" %>
<%@ page import="com.ibm.commerce.catalog.beans.OperatorDescriptionDataBean" %>
<%@ page import="com.ibm.commerce.ejb.helpers.SessionBeanHelper" %>
<%@ page import="com.ibm.commerce.fulfillment.objects.FulfillmentJDBCHelperBean" %>
<%@ include file="../common/common.jsp" %> 
<%@ include file="../common/NumberFormat.jsp" %>



<%
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    Locale locale = null;
    Integer languageId = null; 
    if (aCommandContext != null) {
		locale = aCommandContext.getLocale();
		languageId = aCommandContext.getLanguageId(); 
    }
    if (locale == null) {
    	locale = new Locale("en", "US");
    }
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", locale);
    JSPHelper jspHelper1 = new JSPHelper(request);
    
    Integer store_id = aCommandContext.getStoreId();   
	FulfillmentJDBCHelperBean bFulfillmentCenter = SessionBeanHelper.lookupSessionBean(FulfillmentJDBCHelperBean.class);
    Vector vecFulfillmentCenterList = bFulfillmentCenter.findFfmcenterNameAndIdByStoreId(store_id,"N"); 

    String rfqId = (String)jspHelper1.getParameter("requestId");

    int hasCatPP = 0;
    boolean hasCategoryPP = RFQProductHelper.hasPriceAdjustmentOnCategory(new Long(rfqId));
    if (hasCategoryPP)
    {
	hasCatPP = 1;
    }
 	String requestCatalogId = null; 
    Integer[] negotiationTypes = new Integer[1];
    
    java.text.NumberFormat numberFormatter = java.text.NumberFormat.getNumberInstance(locale);
%>


<jsp:useBean id="prodFPList" class="com.ibm.commerce.utf.beans.RFQProdListBean">
<jsp:setProperty property="*" name="prodFPList" />
</jsp:useBean>
<%
    int hasProdFP = 0;
    negotiationTypes[0] = new Integer (1);
    prodFPList.setNegotiationTypes(negotiationTypes);
    prodFPList.setRFQId(rfqId);	
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
    prodPPList.setRFQId(rfqId);	
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
    dKitFPList.setRFQId(rfqId);	
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
    dKitPPList.setRFQId(rfqId);	
    com.ibm.commerce.beans.DataBeanManager.activate(dKitPPList, request);
    RFQProdDataBean [] dPPList = dKitPPList.getRFQProds();
    if (dPPList != null && dPPList.length > 0)
    {		               
    	hasDKitPP = 1;
    }
%>


<%
    boolean endresult_to_contract = false;
    RFQDataBean rfq=new RFQDataBean();
    rfq.setRfqId(rfqId);
    String endresult = null;
    //com.ibm.commerce.beans.DataBeanManager.activate(rfq, request);
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

    var VPDResult;
    var isFirstTimeLogonCreateNotebook;
    var endresult_to_contract;

    var hasProdFP = "<%= hasProdFP %>";
    var hasProdPP = "<%= hasProdPP %>";
    var hasDKitFP = "<%= hasDKitFP %>";
    var hasDKitPP = "<%= hasDKitPP %>";

    isFirstTimeLogonCreateNotebook = top.getData("isFirstTimeLogonCreateNotebook");
    if (isFirstTimeLogonCreateNotebook != "0") 
    {
	isFirstTimeLogonCreateNotebook = "1";    //"1" means first time logon 
	top.saveData("0", "isFirstTimeLogonCreateNotebook");	
	top.saveData("<%= rfqId %>", "requestId");	
	top.saveData("<%= endresult_to_contract %>", "endresult_to_contract");

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
	top.saveData(skipPagesArray,"skipPages");
   
    	// Initialize the RFQ level attachments data object
    	var isFirstTimeLogonPanel1;
    	isFirstTimeLogonPanel1 = top.getData("isFirstTimeLogonPanel1");
    	if (isFirstTimeLogonPanel1 != "0")
    	{
            isFirstTimeLogonPanel1 = "1"; //"1" means first time logon Panel1.
            top.saveData("0","isFirstTimeLogonPanel1");
    	}    	    	
        var allAttachmentsArray  = new Array();
	var rfqAttachmentsArray  = new Array();

<jsp:useBean id="attachmentList" class="com.ibm.commerce.rfq.beans.RFQAttachmentListBean" >
<jsp:setProperty property="*" name="attachmentList" />
</jsp:useBean>
<%
    	attachmentList.setTradingId(Long.valueOf(rfqId));
    	com.ibm.commerce.beans.DataBeanManager.activate(attachmentList, request);
	AttachmentDataBean [] attachList = attachmentList.getAttachments();
	int numberOfAttachments = 0;
	if (attachList != null) 
	{
    	    numberOfAttachments = attachList.length;
	}
	    
 	String strAttachCopyFromRequest = RFQConstants.EC_RFQ_ATTACHMENT_COPYFROMREQUEST_YES;
	String strAttachOrigFromResponse = RFQConstants.EC_RFQ_ATTACHMENT_ORIGFROMRESPONSE_NO;
	for (int i = 0; i < numberOfAttachments; i++)
	{
            AttachmentDataBean dbAttachment = attachList[i];
%> 
            rfqAttachmentsArray[<%=i%>] = new Object();
	    rfqAttachmentsArray[<%=i%>].identity = <%=i%>;
	    rfqAttachmentsArray[<%=i%>].attachmentId = "<%= dbAttachment.getAttachmentId()%>";
	    rfqAttachmentsArray[<%=i%>].attachOwnerId = <%= dbAttachment.getOwnerId()%>;
            rfqAttachmentsArray[<%=i%>].attachFilename = "<%= UIUtil.toJavaScript(dbAttachment.getFilename()) %>";
            rfqAttachmentsArray[<%=i%>].attachDescription = "<%= UIUtil.toJavaScript(dbAttachment.getDescription()) %>";
	    rfqAttachmentsArray[<%=i%>].attachFilesize = <%= dbAttachment.getFilesize()%>;
	    rfqAttachmentsArray[<%=i%>].attachCopyFromRequest = "<%= strAttachCopyFromRequest %>";
	    rfqAttachmentsArray[<%=i%>].attachOrigFromResponse = "<%= strAttachOrigFromResponse %>";
	    rfqAttachmentsArray[<%=i%>].attachMarkForDelete = "<%= RFQConstants.EC_RFQ_ATTACHMENT_MARKFORDELETE_NO %>";
	    rfqAttachmentsArray[<%=i%>].attachUpdateDesc = "<%= RFQConstants.EC_RFQ_ATTACHMENT_UPDATEDESC_NO %>";
<%
        }
%>
      	allAttachmentsArray = rfqAttachmentsArray;
  	top.saveData(allAttachmentsArray,"allAttachments");
  	parent.put("allAttachments",allAttachmentsArray );

    	// Initialize the terms and conditions data object
    	var isFirstTimeLogonPanel2;
    	isFirstTimeLogonPanel2 = top.getData("isFirstTimeLogonPanel2");
    	if (isFirstTimeLogonPanel2 != "0") 
    	{
    	    isFirstTimeLogonPanel2 = "1"; //"1" means first time logon Panel2.
    	    top.saveData("0","isFirstTimeLogonPanel2");
    	} 

	var rfqCommentsArrary  = new Array();
<%   
	TermConditionAccessBean tcAb = new TermConditionAccessBean();
     	java.util.Enumeration enu = tcAb.findByTradingAndTCSubType(new Long(rfqId),"OrderTCOrderComment");
     	int tcIndex=0;
     	TermConditionAccessBean aTcAb = null;
     	while (enu != null && enu.hasMoreElements()) 
     	{
	    aTcAb = (TermConditionAccessBean)enu.nextElement();
	    OrderTCOrderCommentAccessBean a = new OrderTCOrderCommentAccessBean();
	    a.setInitKey_referenceNumber(aTcAb.getReferenceNumber());
%> 
	    rfqCommentsArrary[<%=tcIndex%>] = new Object();
	    rfqCommentsArrary[<%=tcIndex%>].<%=RFQConstants.EC_REQUEST_TC_ID%>=<%=aTcAb.getReferenceNumber()%>;
	    rfqCommentsArrary[<%=tcIndex%>].<%=RFQConstants.EC_TC_RFQ_LEVEL_COMMENTS%>="<%= UIUtil.toJavaScript(a.getComments()) %>";
	    rfqCommentsArrary[<%=tcIndex%>].display_rfq="<%= UIUtil.toHTML(UIUtil.toJavaScript(a.getComments())) %>";
	    rfqCommentsArrary[<%=tcIndex%>].<%=RFQConstants.EC_ATTR_MANDATORY%>= "<%=aTcAb.getMandatoryFlag()%>";
	    rfqCommentsArrary[<%=tcIndex%>].<%=RFQConstants.EC_ATTR_CHANGEABLE%>= "<%=aTcAb.getChangeableFlag()%>";
	    if(rfqCommentsArrary[<%=tcIndex%>].<%=RFQConstants.EC_ATTR_MANDATORY%> == 1) 
	    {
		rfqCommentsArrary[<%=tcIndex%>].<%=RFQConstants.EC_ATTR_RES_CMMENTS_VALUE%>=rfqCommentsArrary[<%=tcIndex%>].<%=RFQConstants.EC_TC_RFQ_LEVEL_COMMENTS%>;
		rfqCommentsArrary[<%=tcIndex%>].display=rfqCommentsArrary[<%=tcIndex%>].display_rfq;
            } else {
            	rfqCommentsArrary[<%=tcIndex%>].<%=RFQConstants.EC_ATTR_RES_CMMENTS_VALUE%>="";
            	rfqCommentsArrary[<%=tcIndex%>].display="";
            }
<%	  	
	    tcIndex++;
        }
%>
	top.saveData(rfqCommentsArrary,"allTC");
	parent.put("rfq_tc_comments",rfqCommentsArrary );

    	// Initialize the adjustment on categories data object
    	var isFirstTimeLogonPanel3;
    	isFirstTimeLogonPanel3 = top.getData("isFirstTimeLogonPanel3");
    	if (isFirstTimeLogonPanel3 != "0") 
    	{
	    isFirstTimeLogonPanel3 = "1";  //"1" means first time logon Panel3.
	    top.saveData("0","isFirstTimeLogonPanel3");
    	}    
    	var CatalogPPArray = new Array();
 
<jsp:useBean id="catalogBean" class="com.ibm.commerce.catalog.beans.CatalogDataBean" scope="page">
<% 
	if(hasCatPP == 1)
	{
	    requestCatalogId = RFQProductHelper.getCatalogIdFromXmlFragment(new Long(rfqId));
	    catalogBean.setCatalogId(requestCatalogId);     
	    DataBeanManager.activate(catalogBean, request); 
	}	
%>
</jsp:useBean>		
<%		
	if(hasCatPP == 1)
	{
	    String categoryIDreferenceNumberAttr = null;
	    String percentagePriceAttr = "";
	    String categoryName = "";				
	    String categoryDesc = "";
	    String requestSynchronize = "";
	    String ppResposeAdjust = "";
	    String responseSynchronize = "";
	    String tcId = "";		
	    String synchronizeAttr = "";			
			
	    RFQPriceAdjustmentOnCategory[] rfqPaArray = RFQProductHelper.getPriceAdjustmentsOnCategory(new Long(rfqId), catalogBean);		
	    if( rfqPaArray != null || rfqPaArray.length !=0 ) 
	    {		
		for (int i = 0; i<rfqPaArray.length; i++) 
		{			
		    RFQPriceAdjustmentOnCategory rfqPAObj = new RFQPriceAdjustmentOnCategory();					
		    rfqPAObj = rfqPaArray[i];			
		    tcId = rfqPAObj.getTc_id().toString();
								
		    requestSynchronize = rfqPAObj.getSynchronize();	
		    responseSynchronize = requestSynchronize;	
		    percentagePriceAttr = rfqPAObj.getPercentagePrice().toString();
		    ppResposeAdjust = percentagePriceAttr;
		    String ppResposeAdjust_ds = "";
		    if (percentagePriceAttr != null && percentagePriceAttr.length() != 0 )
		    {
			Double ptemp = Double.valueOf(percentagePriceAttr);
            		if (ptemp != null && ptemp.doubleValue() <= 0) 
            		{
          		    percentagePriceAttr = numberFormatter.format(ptemp);
			}
			ppResposeAdjust_ds = percentagePriceAttr;		
		    }
		    categoryDesc = rfqPAObj.getDescription();
		    categoryIDreferenceNumberAttr = rfqPAObj.getCategory_id().toString();			
		    categoryName = rfqPAObj.getCatName();	
%>			
		    CatalogPPArray[<%= i %>] = new Object();				
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_RFQ_CATEGORY_PRICE_ADJUST_REQUEST_ID %>="<%= rfqId %>";			
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_CATALOGID %>="<%= requestCatalogId %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_CATEGORYID %>="<%= categoryIDreferenceNumberAttr %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_CATEGORYNAME %>="<%= categoryName %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_CATEGORYDESCRIPTION %>="<%= categoryDesc %>";							
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_REQUEST_TC_ID %>="<%= tcId %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_RFQ_OFFERING_PRICEADJUSTMENT %>="<%= percentagePriceAttr %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_RFQ_OFFERING_SYNCHRONIZE %>="<%= requestSynchronize %>"; 		
   		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %>="<%= ppResposeAdjust %>";
   		    CatalogPPArray[<%= i %>].res_priceAdjustment="<%= ppResposeAdjust_ds %>";			    	
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_SYNCHRONIZE %>="<%= responseSynchronize %>";
		    CatalogPPArray[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_CATEGORY %> ="<%= RFQConstants.EC_RFQ_RESPOND_TO_CATEGORY_YES %>"; 	
<%		
		}	
	    } 
	}
%>	
 	top.saveData(CatalogPPArray,"allCatalogPP");
	parent.put("<%= RFQConstants.EC_RFQ_CATEGORY_PRICE_ADJUST_ITEM %>", CatalogPPArray ); 

	// Initialize the percentage pricing on products data object
   	var isFirstTimeLogonPanel4;
    	isFirstTimeLogonPanel4 = top.getData("isFirstTimeLogonPanel4");
    	if (isFirstTimeLogonPanel4 != "0") 
    	{
    	    isFirstTimeLogonPanel4 = "1";  //"1" means first time logon Panel4.
    	    top.saveData("0","isFirstTimeLogonPanel4");
    	}        
    	var ProductsPPArray = new Array();					
<% 
	String catentryid_in_prod = null;
	String prodChangeable = null;
	String prodId         = null;
	String prodName       = null;	    
	String prodType       = null;	    
	String prodCategoryId = null; 
	String prodPartNumber = null;
	String prodUnitId     = null;
    	String prodUnit       = null;
    	String prodQuantity   = null;   	   		
    	String quantity_ds    = null;
    	String prodDesc       = null;
    	String prodPriceAdjustment  = null; 
    	String priceAdjustment_ds   = null;  
    	   	        
    	// Get currency, currency prefix and suffix for the store and language      
	for(int i=0; i<pPPList.length; i++) 
	{  
          	RFQProdDataBean aRfqProd = pPPList[i];
          	catentryid_in_prod = aRfqProd.getCatentryId();
          	 
		CatalogEntryAccessBean dbCatentry = null;
          	CatalogEntryDescriptionAccessBean catentryDes = null;
		if ((catentryid_in_prod != null) && !catentryid_in_prod.equals("")) 
		{
		    dbCatentry = new CatalogEntryAccessBean();
                    dbCatentry.setInitKey_catalogEntryReferenceNumber(catentryid_in_prod);
                    prodPartNumber = UIUtil.toJavaScript(dbCatentry.getPartNumber());
          	    
          	    catentryDes = new CatalogEntryDescriptionAccessBean();
          	    catentryDes.setInitKey_catalogEntryReferenceNumber(catentryid_in_prod);
	  	    catentryDes.setInitKey_language_id(languageId.toString());
	  	    prodName = UIUtil.toJavaScript(catentryDes.getName());  	    	
	  	    prodDesc = UIUtil.toJavaScript(catentryDes.getShortDescription());
 	    		  	    	
		    String _type = dbCatentry.getType().trim();		
		    if (_type.equals(RFQConstants.EC_OFFERING_ITEMBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypeitem");											
		    }
		    if (_type.equals(RFQConstants.EC_OFFERING_PRODUCTBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypeproduct");					
		    }	
       		    if (_type.equals(RFQConstants.EC_OFFERING_PACKAGEBEAN)) 
       		    {
       			prodType = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");					
       		    }				
       		    if (_type.equals(RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) 
       		    {
       			prodType = (String)rfqNLS.get("rfqproductrequesttypedynamickit"); 					
       		    }		    	
		} 
		else 
		{
		    prodName = UIUtil.toJavaScript(aRfqProd.getRfqProductName());
                    prodPartNumber = "";
                    prodType = "";
		    prodDesc = "";
		}
                if (prodName == null) 
                {
                    prodName = "";
                }
            	if (prodPartNumber == null) 
            	{
                    prodPartNumber = "";
                }
                if (prodType == null) 
                {
                    prodType = "";
                }
                if (prodDesc == null) 
                {
                    prodDesc = "";
                }
                             
          	RFQCategryAccessBean rfqCategry = null;
	 	prodCategoryId = aRfqProd.getRfqCategryId();
	  	String rfqCategoryName = null;
		if (prodCategoryId != null && prodCategoryId.length() > 0) 
		{
          	    Long rfqCategryId = Long.valueOf(prodCategoryId);
          	    rfqCategry = new RFQCategryAccessBean();
          	    rfqCategry.setInitKey_rfqCategryId(rfqCategryId);
	  	    rfqCategoryName = UIUtil.toJavaScript(rfqCategry.getName());
		}
		
          	prodChangeable = aRfqProd.getChangeable();
	 	prodId = aRfqProd.getRfqprodId();	     	  	
      	  	
      	  	//Price adjustment
      	  	prodPriceAdjustment = aRfqProd.getPriceAdjustment();      	  	
      	  	if (prodPriceAdjustment!= null && prodPriceAdjustment.length() > 0) 
      	  	{
          	    Double dtemp = Double.valueOf(prodPriceAdjustment);
          	    Integer itemp = new Integer(dtemp.intValue());
          	    if (itemp.intValue() <= 0) 
          	    {
          		priceAdjustment_ds = numberFormatter.format(dtemp);
           	    }
           	} 
           	else 
           	{
          	    prodPriceAdjustment = "0";
          	    priceAdjustment_ds = "0";
          	}	
          	
          	if (!endresult_to_contract) 
          	{   		     		
    		    prodUnitId = aRfqProd.getQtyUnitId(); 
      	  	    prodQuantity = aRfqProd.getQuantity(); 
      	  	
      	  	    if (prodQuantity != null && prodQuantity.length() > 0) 
      	  	    {
          	    	Double dtemp = Double.valueOf(prodQuantity);
          	    	Integer itemp = new Integer(dtemp.intValue());
          	    	if (itemp.intValue() >= 0) 
          	    	{
          		    quantity_ds = numberFormatter.format(dtemp);
           	    	}
           	    } 
           	    else 
           	    {
          	    	prodQuantity = "0";
          	    	quantity_ds ="0";
          	    }
          		
          	    //unit
	 	    if (prodUnitId != null && !prodUnitId.equals("")) 
	 	    {
          	    	QuantityUnitDescriptionAccessBean pquab = new QuantityUnitDescriptionAccessBean();
          	    	pquab.setInitKey_language_id(languageId.toString());
          	    	pquab.setInitKey_quantityUnitId(prodUnitId);
          	    	prodUnit = pquab.getDescription();
      		    } 
      		    else 
      		    {
      		    	prodUnit = "";
      		    	prodUnitId="";
      		    }
          	
          	} 
%>
          	ProductsPPArray[<%=i%>] = new Object();
          	ProductsPPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%>="<%=prodId%>";
	  	ProductsPPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>="<%=aRfqProd.getCatentryId()%>";
		
	  	ProductsPPArray[<%=i%>].product_req_name="<%=prodName%>";
	  	ProductsPPArray[<%=i%>].product_req_type="<%=prodType%>";
                ProductsPPArray[<%=i%>].product_req_partnumber="<%=prodPartNumber%>"; 
		ProductsPPArray[<%=i%>].product_req_description="<%=prodDesc%>";	

		var rfqCategoryName = "<%=rfqCategoryName%>";
		if (rfqCategoryName != "null" && !isEmpty(rfqCategoryName)) 
		{
	  	    ProductsPPArray[<%=i%>].product_req_categoryName=rfqCategoryName;
		} 
		else 
		{
	  	    ProductsPPArray[<%=i%>].product_req_categoryName="";
		}
					
		ProductsPPArray[<%=i%>].product_req_priceAdjustment = "<%= priceAdjustment_ds %>";
          	ProductsPPArray[<%=i%>].product_req_changeable="<%=prodChangeable%>";           	  	
          	
<%
		if (!endresult_to_contract) 
		{   
%>
	       	    ProductsPPArray[<%=i%>].product_req_quantity="<%=quantity_ds%>";
          	    ProductsPPArray[<%=i%>].product_req_unit="<%=prodUnit%>";
<%
		}
%>	          	
          	          	
		if (ProductsPPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%> != null && !isEmpty(ProductsPPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>)) 
		{
	    	    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_CATENTRYID%> = ProductsPPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>;
		    ProductsPPArray[<%=i%>].product_partnumber=ProductsPPArray[<%=i%>].product_req_partnumber;		
		    ProductsPPArray[<%=i%>].product_name=ProductsPPArray[<%=i%>].product_req_name;
		    
		    ProductsPPArray[<%=i%>].product_type=ProductsPPArray[<%=i%>].product_req_type;
		    ProductsPPArray[<%=i%>].product_description=ProductsPPArray[<%=i%>].product_req_description;
		} 
		else 
		{		    
		    ProductsPPArray[<%=i%>].product_name="";
		    ProductsPPArray[<%=i%>].product_partnumber="";
		    ProductsPPArray[<%=i%>].product_type="";
		    ProductsPPArray[<%=i%>].product_description="";
		}     		

		ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRICEADJUSTMENT%>= "<%=prodPriceAdjustment%>";
		ProductsPPArray[<%=i%>].product_res_priceAdjustment = "<%=priceAdjustment_ds%>";   
<%
		if (!endresult_to_contract) 
		{   
%>		
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_QUANTITY%>=<%=prodQuantity%>;
	  	    ProductsPPArray[<%=i%>].product_res_quantity=ProductsPPArray[<%=i%>].product_req_quantity;
	  	    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_UNIT%>="<%=prodUnitId%>";  
	  	    ProductsPPArray[<%=i%>].UnitDsc=ProductsPPArray[<%=i%>].product_req_unit;	
<%
		}
%>	  	
	  	ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>=new Array();  
  	  	ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>=new Array(); 
  	  		
<%
      		// Get comments for the products 
      		Long	com_id		= null;
      		String	com_name	= "";
      		String	com_desc	= "";
      		String	com_value	= "";
      		Integer	com_mandatory	= null;
      		Integer	com_changeable	= null;
      		Long 	com_tc_id	= null;
      		
      		RFQProductAttributes[] abc2 = null;
      		abc2 = RFQProductHelper.getProductCommentsForProduct(Long.valueOf(prodId),languageId); 
      		for (int j=0; abc2 != null && j<abc2.length; j++) 
      		{
        	    com_id = null;
        	    com_name = "";
        	    com_desc = "";
        	    com_value = "";
        	    com_mandatory = null;
  		    com_changeable = null;
    		    com_tc_id = null;
    		    
   		    com_id = abc2[j].getPattribute_id();
   		    com_name = UIUtil.toJavaScript(abc2[j].getName());
   		    com_desc = UIUtil.toJavaScript(abc2[j].getDescription());
		    if (com_desc == null || com_desc.length() < 1) 
		    {
   		        com_desc = com_name;
		    }
    		    com_value = UIUtil.toJavaScript(abc2[j].getValue());
    		    com_mandatory = abc2[j].getMandatory();
    		    com_changeable = abc2[j].getChangeable();
      		    com_tc_id = abc2[j].getTc_id();
      		    Long pAttrValId = abc2[j].getPAttrValueId();
%>	  
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>] = new Object;
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_PATTRVALUE_ID%> = "<%=pAttrValId %>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_PATTRID%> = "<%=com_id%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_NAME%> = "<%=com_name%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_DESCRIPTION%> = "<%=com_desc%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_VALUE%> = "<%=com_value%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].product_req_comments= "<%=com_value%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_MANDATORY%> = "<%=com_mandatory%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_CHANGEABLE%> = "<%=com_changeable%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_REQUEST_TC_ID%> = "<%=com_tc_id%>";
		    
		    if (ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_MANDATORY%>==1) 
		    {
			ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_VALUE%> = "<%=com_value%>";
		    } 
		    else 
		    {
			ProductsPPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_VALUE%> = "";
		    }
<%    
		}
		
      		/* Now get attribute data for each product */
      		String	attr_name	= "";
      		String	attr_desc	= "";
      		Long	attr_id		= null;
      		Long	attr_tc_id	= null;
      		String	attr_type	= "";
      		String  attr_filename   = "";
      		String	attr_value	= "";
      		Integer	attr_mandatory	= null;
      		Integer	attr_changeable	= null;
      		Integer	attr_operatorId	= null;
      		String	attr_operatorName = "";
      		String	attr_unitId	= "";
      		String	attr_unitDesc	= "";
      		String	attr_userdefined = "";
      		String  attrType        = "";
      		String	yyyy 		= "";
      		String	mm 		= "";
      		String	dd 		= "";
      		
      		RFQProductAttributes[] abc = null;
      		abc = RFQProductHelper.getAllAttributesWithValuesForProduct(Long.valueOf(prodId), languageId,";"); 
      		for (int k=0; abc != null && k<abc.length; k++) 
      		{
        	    attr_name		= "";
        	    attr_desc		= "";
        	    attr_id		= null;
        	    attr_tc_id		= null;
        	    attr_type		= "";
        	    attr_filename       = "";
        	    attr_value		= "";
        	    attr_mandatory	= null;
    		    attr_changeable	= null;
     		    attr_operatorId	= null;
   		    attr_operatorName	= "";
    		    attr_unitId		= "";
		    attr_unitDesc	= "";
        	    attr_userdefined	= "";
        	    attrType            = "";
        	    yyyy = "";
        	    mm	= "";
        	    dd = "";
        	    
        	    attr_tc_id = abc[k].getTc_id();
        	    attr_name  = UIUtil.toJavaScript(abc[k].getName());
        	    attr_desc  = UIUtil.toJavaScript(abc[k].getDescription());
		    if (attr_desc == null || attr_desc.length() < 1) 
		    {
        	        attr_desc = attr_name;
        	    } 
        	    if (abc[k].getAttribute_id() != null)  
        	    {
          		attr_id = abc[k].getAttribute_id();
          		attr_userdefined = "N";
        	    } 
        	    else 
        	    {
          		attr_id = abc[k].getPattribute_id();
          		attr_userdefined = "Y";
        	    }
        	    attr_type	= UIUtil.toJavaScript(abc[k].getAttrtype());
        	    attr_value	= UIUtil.toJavaScript(abc[k].getValue());
        	    attr_mandatory	= abc[k].getMandatory();
     		    attr_changeable	= abc[k].getChangeable();
    		    attr_operatorId	= abc[k].getOperator_id();
    		    attr_unitId	= abc[k].getUnit();

                    if (abc[k].getAttrtype().equals(com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT)) 
                    {
                	if (abc[k].getValue().length() >0 && abc[k].getValue() != null) 
                	{
			    AttachmentAccessBean attachment = new AttachmentAccessBean();
			    attachment.setInitKey_attachmentId(abc[k].getValue());
			    attr_filename = UIUtil.toJavaScript(attachment.getFilename());
			} 
			else 
			{
			    attr_filename = "";
			}
                    }
        	    if (attr_operatorId != null)  
        	    {
			OperatorDescriptionDataBean oddbeanA = null;
			oddbeanA = new OperatorDescriptionDataBean();
			oddbeanA.setInitKey_operatorId(attr_operatorId.toString());
			oddbeanA.setInitKey_languageId(languageId.toString());
			attr_operatorName = oddbeanA.getDescription();
        	    } 
        	    else 
        	    {
          		attr_operatorName = "";
         	    }
         	    
        	    if (attr_unitId != null && !attr_unitId.equals("")) 
        	    {
            		QuantityUnitDescriptionAccessBean quab = new QuantityUnitDescriptionAccessBean();
            		quab.setInitKey_language_id(languageId.toString());
            		quab.setInitKey_quantityUnitId(attr_unitId);
            		attr_unitDesc = quab.getDescription();
        	    } 
        	    else  
        	    {
          		attr_unitDesc = "";
          		attr_unitId = "";
        	    }
        	    
      		    Long pAttrValId_PA = abc[k].getPAttrValueId();
        	    if (attr_type.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_DATETIME.toString())) 
        	    {
          		attr_type = "D";	// date type attribute
		    }
%>
	  	    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>] = new Object;
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_PATTRVALUE_ID%> = "<%=pAttrValId_PA %>";
	  	    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_PATTRID%> ="<%=attr_id%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_NAME%> ="<%=attr_name%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_DESCRIPTION%> ="<%=attr_desc%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_value = "<%=attr_value%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_filename = "<%= attr_filename %>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_operator = "<%=attr_operatorName%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUE%> = "";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUEDELIM%> = "<%=RFQConstants.EC_ATTR_VALUEDELIM_VALUE%>";
	  	    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_unit = "<%=attr_unitDesc%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_userDefined = "<%=attr_userdefined%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_UNIT%> = "";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_MANDATORY%> = "<%=attr_mandatory%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_CHANGEABLE%> = "<%=attr_changeable%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_REQUEST_TC_ID%> = "<%=attr_tc_id%>";
		    ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_TYPE%> = "<%= attr_type%>";
	  
	  	    if (ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_MANDATORY%> == 0)
		    {
	  		ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUE%> = "";	  
			ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].res_filename = "";
			ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_UNIT%> = "";
	  		ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_OPERATOR%> = "";
	  		ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].operatorName = "";
	  		ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].UnitDsc = "";
	  	    } 
	  	    else 
	  	    {
	  		ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUE%> = "<%=attr_value%>";	  
	  		ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].res_filename = "<%= attr_filename %>";
			ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_UNIT%> = "<%=attr_unitId%>";
	  		ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_OPERATOR%> = "<%=attr_operatorId%>";
	  		ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].operatorName = "<%=attr_operatorName%>";
	  		ProductsPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].UnitDsc = "<%=attr_unitDesc%>";
	  	    }
<%
	  	}	  		
  	}
%>
   	top.saveData(ProductsPPArray, "allPercentagePricingProducts");
	parent.put("<%= RFQConstants.EC_OFFERING_PERCENTPRICEPRODUCT %>", ProductsPPArray ); 	

    	// Initialize the fixed pricing on products data object 
        var isFirstTimeLogonPanel5;
        isFirstTimeLogonPanel5 = top.getData("isFirstTimeLogonPanel5");
    	if (isFirstTimeLogonPanel5 != "0") 
    	{
	    isFirstTimeLogonPanel5 = "1";  //"1" means first time logon Panel5.
	    top.saveData("0","isFirstTimeLogonPanel5");
    	}   
    	var ProductsFPArray = new Array();			
<%   
	catentryid_in_prod = null;
	prodChangeable = null;
	prodId         = null;
	prodName       = null;
	prodType       = null;	    
	prodCategoryId = null;
	prodPartNumber = null;
    	prodUnitId     = null;
    	prodUnit       = null;    	
    	prodQuantity   = null;    	
    	quantity_ds    = null;		    
	prodDesc       = null;
	String prodCurrency   = null;  
    	String prodPrice      = null;     	    
    	java.math.BigDecimal price = null;	
	    
    	// Get currency, currency prefix and suffix for the store and language      
	for (int i=0; i<pFPList.length; i++) 
	{	    	
          	RFQProdDataBean aRfqProd = pFPList[i];
          	catentryid_in_prod = aRfqProd.getCatentryId();
          	
		CatalogEntryAccessBean dbCatentry = null;
          	CatalogEntryDescriptionAccessBean catentryDes = null;
		if ((catentryid_in_prod != null) && !catentryid_in_prod.equals("")) 
		{
		    dbCatentry = new CatalogEntryAccessBean();
                    dbCatentry.setInitKey_catalogEntryReferenceNumber(catentryid_in_prod);
                    prodPartNumber = UIUtil.toJavaScript(dbCatentry.getPartNumber());
                    
          	    catentryDes = new CatalogEntryDescriptionAccessBean();
          	    catentryDes.setInitKey_catalogEntryReferenceNumber(catentryid_in_prod);
	  	    catentryDes.setInitKey_language_id(languageId.toString());
		    prodName = UIUtil.toJavaScript(catentryDes.getName());
		    prodDesc = UIUtil.toJavaScript(catentryDes.getShortDescription());
		   
		    String _type = dbCatentry.getType().trim();		
		    if (_type.equals(RFQConstants.EC_OFFERING_ITEMBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypeitem");											
		    }
		    if (_type.equals(RFQConstants.EC_OFFERING_PRODUCTBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypeproduct");					
		    }	
		    if (_type.equals(RFQConstants.EC_OFFERING_PACKAGEBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");					
		    }			
		    if (_type.equals(RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypedynamickit"); 					
		    }								    	
		} 
		else 
		{
		    prodName = UIUtil.toJavaScript(aRfqProd.getRfqProductName());
                    prodPartNumber = "";
                    prodType = "";
                    prodDesc = "";
		}
                if (prodName == null) 
                {
                    prodName = "";
                }
            	if (prodPartNumber == null) 
            	{
                    prodPartNumber = "";
                }
                if (prodType == null) 
                {
                    prodType = "";
                }
                if (prodDesc == null) 
                {
                    prodDesc = "";
                }
                	             
          	RFQCategryAccessBean rfqCategry = null;
	 	prodCategoryId = aRfqProd.getRfqCategryId();
	  	String rfqCategoryName = null;
		if (prodCategoryId != null && prodCategoryId.length() > 0) 
		{
          	    Long rfqCategryId = Long.valueOf(prodCategoryId);
          	    rfqCategry = new RFQCategryAccessBean();
          	    rfqCategry.setInitKey_rfqCategryId(rfqCategryId);
	  	    rfqCategoryName = UIUtil.toJavaScript(rfqCategry.getName());
		}
		
          	prodChangeable = aRfqProd.getChangeable();
	  	prodCurrency = aRfqProd.getCurrency();
	 	prodId = aRfqProd.getRfqprodId(); 
      	  	prodUnitId = aRfqProd.getQtyUnitId(); 
      	  	prodQuantity = aRfqProd.getQuantity(); 
      	  	prodPrice = aRfqProd.getPrice();
      	  	     	  	     	   
		// quantity
      	  	if (prodQuantity != null && prodQuantity.length() > 0) 
      	  	{
          	    Double dtemp = Double.valueOf(prodQuantity);
          	    Integer itemp = new Integer(dtemp.intValue());
          	    if (itemp.intValue() >= 0) 
          	    {
          		quantity_ds = numberFormatter.format(dtemp);
           	    }
           	} 
           	else  
           	{
          	    prodQuantity = "0";
          	    quantity_ds ="0";
          	}
          	
		//unit
	 	if (prodUnitId != null && !prodUnitId.equals("")) 
	 	{
          	    QuantityUnitDescriptionAccessBean pquab = new QuantityUnitDescriptionAccessBean();
          	    pquab.setInitKey_language_id(languageId.toString());
          	    pquab.setInitKey_quantityUnitId(prodUnitId);
          	    prodUnit = pquab.getDescription();
      		} 
      		else 
      		{
      		    prodUnit = "";
      		    prodUnitId="";
      		}
      		
		//price
         	if ( !prodPrice.equals("") && prodPrice != null ) 
         	{	
        	    price = new java.math.BigDecimal(prodPrice);
        	    if (price.doubleValue() >= 0 ) 
        	    { 
%>
			priceJS=numberToCurrency(<%=prodPrice%>, "<%=prodCurrency%>", <%=languageId%>);
<%
        	    }
      	 	}
      	 	else 
		{
      	   	    prodPrice = "0";
%>
		    priceJS=numberToCurrency(0,"<%=prodCurrency%>",<%=languageId%>);
<%
      	 	}        	    
%>  
		ProductsFPArray[<%=i%>] = new Object();
		ProductsFPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%>="<%=prodId%>";
		ProductsFPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>="<%=aRfqProd.getCatentryId()%>";

	  	ProductsFPArray[<%=i%>].product_req_name="<%=prodName%>";
		ProductsFPArray[<%=i%>].product_req_partnumber="<%=prodPartNumber%>"; 
	  	ProductsFPArray[<%=i%>].product_req_description="<%=prodDesc%>";
		ProductsFPArray[<%=i%>].product_req_type="<%=prodType%>";
				 			
		var rfqCategoryName = "<%=rfqCategoryName%>";
		if (rfqCategoryName != "null" && !isEmpty(rfqCategoryName)) 
		{
	  	    ProductsFPArray[<%=i%>].product_req_categoryName=rfqCategoryName;
		} 
		else 
		{
	  	    ProductsFPArray[<%=i%>].product_req_categoryName="";
		}
									
          	ProductsFPArray[<%=i%>].product_req_price=priceJS;
	  	ProductsFPArray[<%=i%>].product_req_currency="<%=prodCurrency%>";         
          	ProductsFPArray[<%=i%>].product_req_quantity="<%=quantity_ds%>";
          	ProductsFPArray[<%=i%>].product_req_unit="<%=prodUnit%>";
          	ProductsFPArray[<%=i%>].product_req_changeable="<%=prodChangeable%>";	  	
	  		
	  	if (ProductsFPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%> != null && !isEmpty(ProductsFPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>)) 
	  	{
	  	    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_CATENTRYID%> = ProductsFPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>;
                    ProductsFPArray[<%=i%>].product_partnumber=ProductsFPArray[<%=i%>].product_req_partnumber;
		    ProductsFPArray[<%=i%>].product_name=ProductsFPArray[<%=i%>].product_req_name;
	  	    ProductsFPArray[<%=i%>].product_description="<%=prodDesc%>";	
		    ProductsFPArray[<%=i%>].product_type="<%=prodType%>";
		} 
		else 
		{
	  	    ProductsFPArray[<%=i%>].product_name="";
                    ProductsFPArray[<%=i%>].product_partnumber="";
	  	    ProductsFPArray[<%=i%>].product_description="";	
		    ProductsFPArray[<%=i%>].product_type="";
		}

          	ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRICE%>= "<%=prodPrice%>";        	
          	ProductsFPArray[<%=i%>].product_res_price= priceJS;            	          	      
	  	ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_QUANTITY%>=<%=prodQuantity%>;
	  	ProductsFPArray[<%=i%>].product_res_quantity=ProductsFPArray[<%=i%>].product_req_quantity;
	  	ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_CURRENCY%>= ProductsFPArray[<%=i%>].product_req_currency;  
	  	ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_UNIT%>="<%=prodUnitId%>";  
	  	ProductsFPArray[<%=i%>].UnitDsc=ProductsFPArray[<%=i%>].product_req_unit;	  			
	  	ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>=new Array();  
  	  	ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>=new Array(); 
<%
      		/* Now get comments for the products */
      		Long	com_id		= null;
      		String	com_name	= "";
      		String	com_desc	= "";
      		String	com_value	= "";
      		Integer	com_mandatory	= null;
      		Integer	com_changeable	= null;
      		Long 	com_tc_id	= null;
      		    
      		RFQProductAttributes[] abc2 = null;
      		abc2 = RFQProductHelper.getProductCommentsForProduct(Long.valueOf(prodId),languageId); 
      		for (int j=0; abc2 != null && j<abc2.length; j++) 
      		{
        	    com_id = null;
        	    com_name = "";
        	    com_desc = "";
        	    com_value = "";
        	    com_mandatory = null;
  		    com_changeable = null;
    		    com_tc_id = null;
    		    
   		    com_id = abc2[j].getPattribute_id();
   		    com_name = UIUtil.toJavaScript(abc2[j].getName());
   		    com_desc = UIUtil.toJavaScript(abc2[j].getDescription());
		    if (com_desc == null || com_desc.length() < 1) 
		    {
   		        com_desc = com_name;
		    }
    		    com_value = UIUtil.toJavaScript(abc2[j].getValue());
    		    com_mandatory = abc2[j].getMandatory();
    		    com_changeable = abc2[j].getChangeable();
      		    com_tc_id = abc2[j].getTc_id();
      		    Long pAttrValId = abc2[j].getPAttrValueId();
%>	  
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>] = new Object;
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_PATTRVALUE_ID%> = "<%=pAttrValId %>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_PATTRID%> = "<%=com_id%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_NAME%> = "<%=com_name%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_DESCRIPTION%> = "<%=com_desc%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_VALUE%> = "<%=com_value%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].product_req_comments= "<%=com_value%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_MANDATORY%> = "<%=com_mandatory%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_CHANGEABLE%> = "<%=com_changeable%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_REQUEST_TC_ID%> = "<%=com_tc_id%>";
		    
		    if (ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_MANDATORY%>==1) 
		    {
			ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_VALUE%> = "<%=com_value%>";
		    } 
		    else 
		    {
			ProductsFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_VALUE%> = "";
		    }
<%    
		}
		    
      		/* Now get attribute data for each product */
      		String	attr_name	= "";
      		String	attr_desc	= "";
      		Long	attr_id		= null;
      		Long	attr_tc_id	= null;
      		String	attr_type	= "";
      		String  attr_filename   = "";
      		String	attr_value	= "";
      		Integer	attr_mandatory	= null;
      		Integer	attr_changeable	= null;
      		Integer	attr_operatorId	= null;
      		String	attr_operatorName = "";
      		String	attr_unitId	= "";
      		String	attr_unitDesc	= "";
      		String	attr_userdefined = "";
      		String  attrType        = "";
      		String	yyyy 		= "";
      		String	mm 		= "";
      		String	dd 		= "";
      		
      		RFQProductAttributes[] abc = null;
      		abc = RFQProductHelper.getAllAttributesWithValuesForProduct(Long.valueOf(prodId), languageId,";"); 
      		for (int k=0; abc != null && k<abc.length; k++) 
      		{
        	    attr_name		= "";
        	    attr_desc		= "";
        	    attr_id		= null;
        	    attr_tc_id		= null;
        	    attr_type		= "";
        	    attr_filename       = "";
        	    attr_value		= "";
        	    attr_mandatory	= null;
    		    attr_changeable	= null;
     		    attr_operatorId	= null;
   		    attr_operatorName	= "";
    		    attr_unitId		= "";
		    attr_unitDesc	= "";
        	    attr_userdefined	= "";
        	    attrType            = "";
        	    yyyy = "";
        	    mm	= "";
        	    dd = "";
        	    	
        	    attr_tc_id = abc[k].getTc_id();
        	    attr_name  = UIUtil.toJavaScript(abc[k].getName());
        	    attr_desc  = UIUtil.toJavaScript(abc[k].getDescription());
		    if (attr_desc == null || attr_desc.length() < 1) 
		    {
        	        attr_desc = attr_name;
        	    } 
        	    if (abc[k].getAttribute_id() != null)  
        	    {
          		attr_id = abc[k].getAttribute_id();
          		attr_userdefined = "N";
        	    } 
        	    else 
        	    {
          		attr_id = abc[k].getPattribute_id();
          		attr_userdefined = "Y";
        	    }
        	    attr_type	= UIUtil.toJavaScript(abc[k].getAttrtype());
        	    attr_value	= UIUtil.toJavaScript(abc[k].getValue());
        	    attr_mandatory	= abc[k].getMandatory();
     		    attr_changeable	= abc[k].getChangeable();
    		    attr_operatorId	= abc[k].getOperator_id();
    		    attr_unitId	= abc[k].getUnit();

                    if (abc[k].getAttrtype().equals(com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_ATTACHMENT)) 
                    {
                	if (abc[k].getValue().length() >0 && abc[k].getValue() != null) 
                	{
			    AttachmentAccessBean attachment = new AttachmentAccessBean();
			    attachment.setInitKey_attachmentId(abc[k].getValue());
			    attr_filename = UIUtil.toJavaScript(attachment.getFilename());
			} 
			else 
			{
			    attr_filename = "";
			}
                    }
        	        
        	    if (attr_operatorId != null)  
        	    {
			OperatorDescriptionDataBean oddbeanA = null;
			oddbeanA = new OperatorDescriptionDataBean();
			oddbeanA.setInitKey_operatorId(attr_operatorId.toString());
			oddbeanA.setInitKey_languageId(languageId.toString());
			attr_operatorName = oddbeanA.getDescription();
        	    } 
        	    else 
        	    {
          		attr_operatorName = "";
         	    }
         	        
        	    if (attr_unitId != null && !attr_unitId.equals("")) 
        	    {
            		QuantityUnitDescriptionAccessBean quab = new QuantityUnitDescriptionAccessBean();
            		quab.setInitKey_language_id(languageId.toString());
            		quab.setInitKey_quantityUnitId(attr_unitId);
            		attr_unitDesc = quab.getDescription();
        	    } 
        	    else  
        	    {
          		attr_unitDesc = "";
          		attr_unitId = "";
        	    }
      		        
      		    Long pAttrValId_PA = abc[k].getPAttrValueId();
        	    if (attr_type.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_ATTRTYPE_DATETIME.toString())) 
        	    {
          		attr_type = "D";	// date type attribute
		    }
%>
	  	    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>] = new Object;
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_PATTRVALUE_ID%> = "<%=pAttrValId_PA %>";
	  	    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_PATTRID%> ="<%=attr_id%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_NAME%> ="<%=attr_name%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_DESCRIPTION%> ="<%=attr_desc%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_value = "<%=attr_value%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_filename = "<%= attr_filename %>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_operator = "<%=attr_operatorName%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUE%> = "";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUEDELIM%> = "<%=RFQConstants.EC_ATTR_VALUEDELIM_VALUE%>";
	  	    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_unit = "<%=attr_unitDesc%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_userDefined = "<%=attr_userdefined%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_UNIT%> = "";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_MANDATORY%> = "<%=attr_mandatory%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_CHANGEABLE%> = "<%=attr_changeable%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_REQUEST_TC_ID%> = "<%=attr_tc_id%>";
		    ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_TYPE%> = "<%= attr_type%>";
	  
	  	    if (ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_MANDATORY%> == 0) 
	  	    {
	  		ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUE%> = "";	  
			ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].res_filename = "";
			ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_UNIT%> = "";
	  		ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_OPERATOR%> = "";
	  		ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].operatorName = "";
	  		ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].UnitDsc = "";
	  	    } 
	  	    else 
	  	    {
	  		ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUE%> = "<%=attr_value%>";	  
	  		ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].res_filename = "<%= attr_filename %>";
			ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_UNIT%> = "<%=attr_unitId%>";
	  		ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_OPERATOR%> = "<%=attr_operatorId%>";
	  		ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].operatorName = "<%=attr_operatorName%>";
	  		ProductsFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].UnitDsc = "<%=attr_unitDesc%>";
	  	    }
<%
	  	}  		
	}
%>
   	top.saveData(ProductsFPArray,"allFixedPricingProducts");  
	parent.put("fixPriceProduct", ProductsFPArray );

    	// Initialize the percentage pricing on dynamic kits data object    		
    	var isFirstTimeLogonPanel7;
    	isFirstTimeLogonPanel7 = top.getData("isFirstTimeLogonPanel7");
    	if (isFirstTimeLogonPanel7 != "0") 
    	{
    	    isFirstTimeLogonPanel7 = "1";  //"1" means first time logon Panel7.
    	    top.saveData("0","isFirstTimeLogonPanel7");
    	} 
    	var DynamicKitPPArray = new Array();      	
<%   
	catentryid_in_prod = null;
	prodChangeable = null;
	prodId         = null;
	prodName       = null;	    
	prodType       = null;	    
	prodCategoryId = null;
	prodPartNumber = null;
	prodDesc     = null;
    	prodPriceAdjustment  = null; 
    	priceAdjustment_ds   = null;
    	
    	prodUnitId     = null;
        prodUnit       = null;
        prodQuantity   = null;
        quantity_ds    = null;
    	        
    	// Get currency, currency prefix and suffix for the store and language      
	for(int i=0; i<dPPList.length; i++) 
	{
          	RFQProdDataBean aRfqProd = dPPList[i];
          	catentryid_in_prod = aRfqProd.getCatentryId();
		
		CatalogEntryAccessBean dbCatentry = null;
          	CatalogEntryDescriptionAccessBean catentryDes = null;
		if ((catentryid_in_prod != null) && !catentryid_in_prod.equals("")) 
		{
		    dbCatentry = new CatalogEntryAccessBean();
                    dbCatentry.setInitKey_catalogEntryReferenceNumber(catentryid_in_prod);
                    prodPartNumber = UIUtil.toJavaScript(dbCatentry.getPartNumber());
                    
          	    catentryDes = new CatalogEntryDescriptionAccessBean();
          	    catentryDes.setInitKey_catalogEntryReferenceNumber(catentryid_in_prod);
	  	    catentryDes.setInitKey_language_id(languageId.toString());
		    prodName = UIUtil.toJavaScript(catentryDes.getName());
		    prodDesc = UIUtil.toJavaScript(catentryDes.getShortDescription());
		    		
		    String _type = dbCatentry.getType().trim();		
		    if (_type.equals(RFQConstants.EC_OFFERING_ITEMBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypeitem");											
		    }
		    if (_type.equals(RFQConstants.EC_OFFERING_PRODUCTBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypeproduct");					
		    }	
		    if (_type.equals(RFQConstants.EC_OFFERING_PACKAGEBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");					
		    }		
		    if (_type.equals(RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypedynamickit"); 					
		    }			    	
		} 
		else 
		{
		    prodName = UIUtil.toJavaScript(aRfqProd.getRfqProductName());
                    prodPartNumber = "";
                    prodType = "";
                    prodDesc = "";
		}
                if (prodName == null) 
                {
                    prodName = "";
                }
            	if (prodPartNumber == null) 
            	{
                    prodPartNumber = "";
                }
                if (prodType == null) 
                {
                    prodType = "";
                }
                if (prodDesc == null) 
                {
                    prodDesc = "";
                }
                	             
          	RFQCategryAccessBean rfqCategry = null;
	 	prodCategoryId = aRfqProd.getRfqCategryId();
	  	String rfqCategoryName = null;
		if (prodCategoryId != null && prodCategoryId.length() > 0) 
		{
          	    Long rfqCategryId = Long.valueOf(prodCategoryId);
          	    rfqCategry = new RFQCategryAccessBean();
          	    rfqCategry.setInitKey_rfqCategryId(rfqCategryId);
	  	    rfqCategoryName = UIUtil.toJavaScript(rfqCategry.getName());
		}
		
          	prodChangeable = aRfqProd.getChangeable();
	 	prodId = aRfqProd.getRfqprodId();	 
 
      	  	//Price adjustment
      	  	prodPriceAdjustment = aRfqProd.getPriceAdjustment();      	  	
      	  	if (prodPriceAdjustment!= null && prodPriceAdjustment.length() > 0) 
      	  	{
          	    Double dtemp = Double.valueOf(prodPriceAdjustment);
          	    Integer itemp = new Integer(dtemp.intValue());
          	    if (itemp.intValue() <= 0) 
          	    {
          		priceAdjustment_ds = numberFormatter.format(dtemp);
           	    }
           	} 
           	else 
           	{
          	    prodPriceAdjustment = "0"; 
          	    priceAdjustment_ds = "0";
          	}
          	
          	if (!endresult_to_contract) 
          	{
    		    // quantity
      	  	    prodQuantity = aRfqProd.getQuantity(); 
      	  	    if (prodQuantity != null && prodQuantity.length() > 0) 
      	  	    {
          	    	Double dtemp = Double.valueOf(prodQuantity);
          	    	Integer itemp = new Integer(dtemp.intValue());
          	    	if (itemp.intValue() >= 0) 
          	    	{
          		    quantity_ds = numberFormatter.format(dtemp);
           	    	}
           	    } 
           	    else 
           	    {
          	    	prodQuantity = "0";
          	    	quantity_ds ="0";
          	    }
          		
          	    //unit
          	    prodUnitId = aRfqProd.getQtyUnitId(); 
	 	    if (prodUnitId != null && !prodUnitId.equals("")) 
	 	    {
          	    	QuantityUnitDescriptionAccessBean pquab = new QuantityUnitDescriptionAccessBean();
          	    	pquab.setInitKey_language_id(languageId.toString());
          	    	pquab.setInitKey_quantityUnitId(prodUnitId);
          	    	prodUnit = pquab.getDescription();
      		    } 
      		    else 
      		    {
      		    	prodUnit = "";
      		    	prodUnitId="";
      		    }
          	}
%>
          	DynamicKitPPArray[<%=i%>] = new Object();
          	DynamicKitPPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%>="<%=prodId%>";
	  	DynamicKitPPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>="<%=aRfqProd.getCatentryId()%>";
		
		var catentryDes = '<%=catentryDes%>';
	  	DynamicKitPPArray[<%=i%>].product_req_name="<%=prodName%>";
		DynamicKitPPArray[<%=i%>].product_req_type="<%= prodType %>"; 
                DynamicKitPPArray[<%=i%>].product_req_partnumber="<%=prodPartNumber%>"; 
		DynamicKitPPArray[<%=i%>].product_req_description="<%=prodDesc%>";
		
		var rfqCategoryName = "<%=rfqCategoryName%>";
		if (rfqCategoryName != "null" && !isEmpty(rfqCategoryName)) 
		{
	  	    DynamicKitPPArray[<%=i%>].product_req_categoryName=rfqCategoryName;
		} 
		else 
		{
	  	    DynamicKitPPArray[<%=i%>].product_req_categoryName="";
		}			
			
		DynamicKitPPArray[<%=i%>].product_req_priceAdjustment = "<%= priceAdjustment_ds %>";
          	DynamicKitPPArray[<%=i%>].product_req_changeable="<%=prodChangeable%>";	
          	  	
	  	if (DynamicKitPPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%> != null && !isEmpty(DynamicKitPPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>)) 
	  	{
	  	    DynamicKitPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_CATENTRYID%> = DynamicKitPPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>;
                    DynamicKitPPArray[<%=i%>].product_partnumber=DynamicKitPPArray[<%=i%>].product_req_partnumber;
		    DynamicKitPPArray[<%=i%>].product_name=DynamicKitPPArray[<%=i%>].product_req_name;
                    DynamicKitPPArray[<%=i%>].product_type=DynamicKitPPArray[<%=i%>].product_req_type;
                    DynamicKitPPArray[<%=i%>].product_description=DynamicKitPPArray[<%=i%>].product_req_description;
		} 
		else 
		{
	  	    DynamicKitPPArray[<%=i%>].product_name="";
                    DynamicKitPPArray[<%=i%>].product_partnumber="";
                    DynamicKitPPArray[<%=i%>].product_type="";
                    DynamicKitPPArray[<%=i%>].product_description="";
		}
		
          	DynamicKitPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRICEADJUSTMENT%>= "<%=prodPriceAdjustment%>";
		DynamicKitPPArray[<%=i%>].product_res_priceAdjustment = "<%=priceAdjustment_ds%>";   		
<%
		if (!endresult_to_contract) 
		{   
%>		
		    DynamicKitPPArray[<%=i%>].product_req_quantity="<%=quantity_ds%>";
          	    DynamicKitPPArray[<%=i%>].product_req_unit="<%=prodUnit%>";
		    DynamicKitPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_QUANTITY%>=<%=prodQuantity%>;
	  	    DynamicKitPPArray[<%=i%>].product_res_quantity=DynamicKitPPArray[<%=i%>].product_req_quantity;
	  	    DynamicKitPPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_UNIT%>="<%=prodUnitId%>";  
	  	    DynamicKitPPArray[<%=i%>].UnitDsc=DynamicKitPPArray[<%=i%>].product_req_unit;	
<%
	        }
%>		
		DynamicKitPPArray[<%=i%>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_YES %>";
<%  		
  	}	  	    
%>
   	top.saveData(DynamicKitPPArray,"allPercentagePricingDynamicKits");
	parent.put("<%= RFQConstants.EC_OFFERING_PERCENTPRICEDYNAMICKIT %>", DynamicKitPPArray );

    	// Initialize the fixed pricing on dynamic kits data object
    	var isFirstTimeLogonPanel6;
    	isFirstTimeLogonPanel6 = top.getData("isFirstTimeLogonPanel6");
    	if (isFirstTimeLogonPanel6 != "0") 
    	{
	    isFirstTimeLogonPanel6 = "1";  //"1" means first time logon Panel8.
	    top.saveData("0","isFirstTimeLogonPanel6");
    	}        
    	var DynamicKitFPArray = new Array();    	
<%      	    
	catentryid_in_prod = null;
	prodChangeable = null;
	prodId         = null;
	prodName       = null;	    
	prodType       = null;	    
	prodCategoryId = null; 
	prodPartNumber = null;
	prodUnitId     = null;
    	prodUnit       = null;
    	prodCurrency   = null;
    	prodQuantity   = null;   	
    	prodPrice      = null;    	
    	quantity_ds    = null;
    	prodDesc       = null;    	    
    	price = null;
    	        
    	// Get currency, currency prefix and suffix for the store and language      
	for(int i=0; i<dFPList.length; i++) 
	{
            RFQProdDataBean aRfqProd = dFPList[i];
            catentryid_in_prod = aRfqProd.getCatentryId();
          	
	    CatalogEntryAccessBean dbCatentry = null;
            CatalogEntryDescriptionAccessBean catentryDes = null;
	    if ((catentryid_in_prod != null) && !catentryid_in_prod.equals("")) 
	    {
		    dbCatentry = new CatalogEntryAccessBean();
                    dbCatentry.setInitKey_catalogEntryReferenceNumber(catentryid_in_prod);
                    prodPartNumber = UIUtil.toJavaScript(dbCatentry.getPartNumber());
                    
          	    catentryDes = new CatalogEntryDescriptionAccessBean();
          	    catentryDes.setInitKey_catalogEntryReferenceNumber(catentryid_in_prod);
	  	    catentryDes.setInitKey_language_id(languageId.toString());
		    prodName = UIUtil.toJavaScript(catentryDes.getName());
		    prodDesc = UIUtil.toJavaScript(catentryDes.getShortDescription());
		 		    		
		    String _type = dbCatentry.getType().trim();		
		    if (_type.equals(RFQConstants.EC_OFFERING_ITEMBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypeitem");											
		    }
		    if (_type.equals(RFQConstants.EC_OFFERING_PRODUCTBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypeproduct");					
		    }	
		    if (_type.equals(RFQConstants.EC_OFFERING_PACKAGEBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");					
		    }			
		    if (_type.equals(RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) 
		    {
			prodType = (String)rfqNLS.get("rfqproductrequesttypedynamickit"); 					
		    }				    	
	    } 
	    else 
	    {
		    prodName = UIUtil.toJavaScript(aRfqProd.getRfqProductName());
                    prodPartNumber = "";
                    prodType = "";
                    prodDesc = "";
	    }
            if (prodName == null) 
            {
                    prodName = "";
            }
            if (prodPartNumber == null) 
            {
                    prodPartNumber = "";
            }
            if (prodType == null) 
            {
                    prodType = "";
            }
            if (prodDesc == null) 
            {
                    prodDesc = "";
            }
                           		             
          	RFQCategryAccessBean rfqCategry = null;
	 	prodCategoryId = aRfqProd.getRfqCategryId();
	  	String rfqCategoryName = null;
		if (prodCategoryId != null && prodCategoryId.length() > 0) 
		{
          	    Long rfqCategryId = Long.valueOf(prodCategoryId);
          	    rfqCategry = new RFQCategryAccessBean();
          	    rfqCategry.setInitKey_rfqCategryId(rfqCategryId);
	  	    rfqCategoryName = UIUtil.toJavaScript(rfqCategry.getName());
		}
		
          	prodChangeable = aRfqProd.getChangeable();
	  	prodCurrency = aRfqProd.getCurrency();
	 	prodId = aRfqProd.getRfqprodId();
      	  	prodUnitId = aRfqProd.getQtyUnitId(); 
      	  	prodQuantity = aRfqProd.getQuantity();   
      	  	prodPrice = aRfqProd.getPrice();       	  	
      	  	     	   
		// quantity
      	  	if (prodQuantity != null && prodQuantity.length() > 0) 
      	  	{
          	    Double dtemp = Double.valueOf(prodQuantity);
          	    Integer itemp = new Integer(dtemp.intValue());
          	    if (itemp.intValue() >= 0) 
          	    {
          		quantity_ds = numberFormatter.format(dtemp);
           	    }
           	} 
           	else 
           	{
          	    prodQuantity = "0";
          	    quantity_ds ="0";
          	}
			
		//unit
	 	if (prodUnitId != null && !prodUnitId.equals("")) 
	 	{
          	    QuantityUnitDescriptionAccessBean pquab = new QuantityUnitDescriptionAccessBean();
          	    pquab.setInitKey_language_id(languageId.toString());
          	    pquab.setInitKey_quantityUnitId(prodUnitId);
          	    prodUnit = pquab.getDescription();
      		} 
      		else 
      		{
      		    prodUnit = "";
      		    prodUnitId="";
      		}
		
		//price
         	if ( !prodPrice.equals("") && prodPrice != null ) 
         	{
        	    price = new java.math.BigDecimal(prodPrice);
        	    if (price.doubleValue() >= 0 ) 
        	    {
%>
 			priceJS=numberToCurrency(<%=prodPrice%>,"<%=prodCurrency%>",<%=languageId%>);
<%
        	    }
      	 	} 
      	 	else 
      	 	{
      	   	    prodPrice = "0";
%>
		    priceJS=numberToCurrency(0,"<%=prodCurrency%>",<%=languageId%>);
<%
      	 	} 
%>
            DynamicKitFPArray[<%=i%>] = new Object();
            DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%>="<%=prodId%>";
	    DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>="<%=aRfqProd.getCatentryId()%>";
	  	
	    var catentryDes = '<%=catentryDes%>';
	    DynamicKitFPArray[<%=i%>].product_req_name="<%=prodName%>";
	    DynamicKitFPArray[<%=i%>].product_req_type="<%= prodType %>"; 
            DynamicKitFPArray[<%=i%>].product_req_partnumber="<%=prodPartNumber%>"; 
	    DynamicKitFPArray[<%=i%>].product_req_description="<%=prodDesc%>";
		
	    var rfqCategoryName = "<%=rfqCategoryName%>";
	    if (rfqCategoryName != "null" && !isEmpty(rfqCategoryName)) 
	    {
	  	DynamicKitFPArray[<%=i%>].product_req_categoryName=rfqCategoryName;
	    } else 
	    {
	  	DynamicKitFPArray[<%=i%>].product_req_categoryName="";
	    }			
				
            DynamicKitFPArray[<%=i%>].product_req_price=priceJS;         	         	
	    DynamicKitFPArray[<%=i%>].product_req_currency="<%=prodCurrency%>";         
            DynamicKitFPArray[<%=i%>].product_req_quantity="<%=quantity_ds%>";
            DynamicKitFPArray[<%=i%>].product_req_unit="<%=prodUnit%>";
            DynamicKitFPArray[<%=i%>].product_req_changeable="<%=prodChangeable%>";	
          	
	    if (DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%> != null && !isEmpty(DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>)) 
	    {
	  	DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_CATENTRYID%> = DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>;
		DynamicKitFPArray[<%=i%>].product_name=DynamicKitFPArray[<%=i%>].product_req_name;
        	DynamicKitFPArray[<%=i%>].product_partnumber=DynamicKitFPArray[<%=i%>].product_req_partnumber;
        	DynamicKitFPArray[<%=i%>].product_type=DynamicKitFPArray[<%=i%>].product_req_type;
        	DynamicKitFPArray[<%=i%>].product_description=DynamicKitFPArray[<%=i%>].product_req_description;
	    } 
	    else 
	    {
	  	DynamicKitFPArray[<%=i%>].product_name="";
         	DynamicKitFPArray[<%=i%>].product_partnumber="";
         	DynamicKitFPArray[<%=i%>].product_type="";
         	DynamicKitFPArray[<%=i%>].product_description="";
	    }
		
            DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRICE%>= "<%=prodPrice%>";
            DynamicKitFPArray[<%=i%>].product_res_price= priceJS;         
	    DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_QUANTITY%>=<%=prodQuantity%>;
	    DynamicKitFPArray[<%=i%>].product_res_quantity=DynamicKitFPArray[<%=i%>].product_req_quantity;
	    DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_CURRENCY%>= DynamicKitFPArray[<%=i%>].product_req_currency;  
	    DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_UNIT%>="<%=prodUnitId%>";  
	    DynamicKitFPArray[<%=i%>].UnitDsc=DynamicKitFPArray[<%=i%>].product_req_unit;
	    DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>=new Array();  
  	    DynamicKitFPArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>=new Array(); 
<%
	} 
	  
%>
   	top.saveData(DynamicKitFPArray,"allFixedPricingDynamicKits"); 
	parent.put("fixPriceDynamicKit", DynamicKitFPArray );
    }

    function initializeState() 
    {
    	skipPages(parent.pageArray);
    	parent.reloadFrames();
    	
    	retrievePanelData();
	parent.setContentFrameLoaded(true); 
    }

    function savePanelData() 
    {
	if (isFirstTimeLogonCreateNotebook == "1") 
	{
	    parent.put("<%=RFQConstants.EC_RFQ_REQUEST_ID%>", "<%= rfqId %>");
	}
	parent.put("<%=RFQConstants.EC_RFQ_RESPONSE_NAME%>", document.rfqCreateForm.response_name.value);   
	parent.put("<%=RFQConstants.EC_RFQ_RESPONSE_REMARK%>", document.rfqCreateForm.response_remark.value);   

        if (hasProdFP == '1' || hasProdPP == '1' || 
            hasDKitFP == '1' || hasDKitPP == '1') 
    	{
    	    if (document.rfqCreateForm.response_acceptAllProducts[1].checked) 
	    {
	    	parent.put("<%=RFQConstants.EC_RFQ_RESPONSE_ACCEPTALLPRODUCTS%>", "<%=RFQConstants.EC_RESPONSE_ACCEPTACTION_PARTIAL%>");
            } 
	    else 
	    {
	    	parent.put("<%=RFQConstants.EC_RFQ_RESPONSE_ACCEPTALLPRODUCTS%>", "<%=RFQConstants.EC_RESPONSE_ACCEPTACTION_ALL%>");
	    }
	}
	else 
	{
	    parent.put("<%=RFQConstants.EC_RFQ_RESPONSE_ACCEPTALLPRODUCTS%>", "<%=RFQConstants.EC_RESPONSE_ACCEPTACTION_ALL%>");
	}

	if (document.rfqCreateForm.response_ffmcenter.value == "-1") 
	{       
	    if (parent.get("<%=RFQConstants.EC_RFQ_RESPONSE_FFMCENTER%>", false)) 
	    {
		parent.remove("<%=RFQConstants.EC_RFQ_RESPONSE_FFMCENTER%>");
	    }
    	} 
	else  
	{
	    var ffmcenterObj = new Object();
	    ffmcenterObj.<%= RFQConstants.EC_RFQ_RESPONSE_FFMCENTER_ID %> = document.rfqCreateForm.response_ffmcenter.value;
	    ffmcenterObj.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_TRUE %>";
	    parent.put("<%=RFQConstants.EC_RFQ_RESPONSE_FFMCENTER%>", ffmcenterObj);
	}

	parent.put("<%=BusinessFlowConstants.EC_FLOWID%>","<%=RFQConstants.EC_FLOW_RESPONSE_ID%>");
	parent.put("<%=BusinessFlowConstants.EC_BUSINESS_FLOW_EVENT_IDENTIFIER%>","createRFQResponse");
	parent.put("endresult_to_contract", "<%= endresult_to_contract %>");	 
    } 
    
    function validateNoteBookPanel() 
    {   
        var form=document.rfqCreateForm;
        if (form.response_name.value == "") 
	{
            reprompt(form.response_name, msgMandatoryField);
            form.response_name.focus();
            return false;
        }
        if (!isValidUTF8length(form.response_name.value,200)) 
	{
            reprompt(form.response_name, msgInvalidSize);
            form.response_name.focus();
            return false;
        }
        if (!isValidUTF8length(form.response_remark.value,254)) 
	{
            reprompt(form.response_remark, msgInvalidSize);
            form.response_remark.focus();
            return false;
        }
        return true;
    }

    function retrievePanelData() 
    {
	var form = document.rfqCreateForm;
	form.response_name.value = parent.get("<%=RFQConstants.EC_RFQ_RESPONSE_NAME%>","");
	form.response_remark.value = parent.get("<%=RFQConstants.EC_RFQ_RESPONSE_REMARK%>","");
	
        if (hasProdFP == '1' || hasProdPP == '1' || 
            hasDKitFP == '1' || hasDKitPP == '1') 
    	{
    	    var acceptAllProducts = parent.get("<%=RFQConstants.EC_RFQ_RESPONSE_ACCEPTALLPRODUCTS%>","");
    	    if (acceptAllProducts == "<%= RFQConstants.EC_RESPONSE_ACCEPTACTION_PARTIAL %>") 
	    {
    	        document.rfqCreateForm.response_acceptAllProducts[1].checked = true;
    	    } 
	    else if (acceptAllProducts == "<%= RFQConstants.EC_RESPONSE_ACCEPTACTION_ALL %>") 
	    {
    	        document.rfqCreateForm.response_acceptAllProducts[0].checked = true;
    	    } 
	    else 
	    {    
    	        document.rfqCreateForm.response_acceptAllProducts[1].checked = true;
    	    }   
    	}
    
    	var ffmcenterObj = parent.get("<%=RFQConstants.EC_RFQ_RESPONSE_FFMCENTER%>");
	if (ffmcenterObj != null) 
	{
     	    form.response_ffmcenter.value = ffmcenterObj.<%=RFQConstants.EC_RFQ_RESPONSE_FFMCENTER_ID%>;
    	}
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

<body class="content" onload="initializeState()">
<br /><h1><%= rfqNLS.get("general") %></h1>

<table>
    <tr>
	<td><%= rfqNLS.get("rfq_name") %>:  <i><%= requestName %></i><br /></td>
    </tr>
</table>

<br /><%= rfqNLS.get("instruction_General") %>

<form name="rfqCreateForm" action="">
<table width="100%">
    <tr>
	<td>
	    <label for="responseName">
	    	<%= rfqNLS.get("name") %>&nbsp;<%= rfqNLS.get("required") %><br />  
	    	<input type="text" name="response_name" id="responseName" maxlength="100" onkeypress="trapKeyPress()" />
	    </label>
	</td>
    </tr>
    <tr>
  	<td>
	    <label for="responseRemark">
	    	<br /><%= rfqNLS.get("remark") %><br />
  	    	<textarea rows="4" cols="40"  name="response_remark" id="responseRemark"></textarea>
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
