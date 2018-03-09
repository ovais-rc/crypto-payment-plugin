<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 

<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.beans.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>

<%
    Locale aLocale = null;
    Integer langId = null;
    boolean wrap = true;
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");  
    JSPHelper jsphelper = new JSPHelper(request);  
    if( aCommandContext!= null ) 
    {
        aLocale = aCommandContext.getLocale();
        langId = aCommandContext.getLanguageId();
    }
    if (aLocale==null) 
    {
    	aLocale = new Locale("en","US");
    }
    if (langId == null) {
	langId = new Integer(-1);
    }
    //no wrapping for the asian languages
    if(langId.intValue() <= -7 && langId.intValue() >= -10) { 
    	wrap = false; 
    }
    String ResponseId = jsphelper.getParameter("offerId" );
        
    RFQResponseDataBean	RFQres = new RFQResponseDataBean();
    RFQres.setInitKey_rfqResponseId(Long.valueOf(ResponseId));
    String RequestId =RFQres.getRfqId();    
        
    // obtain the resource bundle for display
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", aLocale);    
%>
<jsp:useBean id="rfq" class="com.ibm.commerce.utf.beans.RFQDataBean" >
<jsp:setProperty property="*" name="rfq" />
</jsp:useBean>
<%
    boolean endresult_to_contract = false;
    String endresult = null;
    if (RequestId != null && RequestId.length() > 0) 
    {
       	rfq.setRfqId(RequestId);
        com.ibm.commerce.beans.DataBeanManager.activate(rfq, request);
        endresult = rfq.getEndResult();
        if (endresult.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_UTF_ENDRESULT_CONTRACT.toString())) 
        {
            endresult_to_contract = true;
    	}
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfq_skippage.js"></script>

<script type="text/javascript">
    var productObjList;
    productObjList = parent.parent.get("<%= RFQConstants.EC_OFFERING_PERCENTPRICEDYNAMICKIT  %>");
    if (productObjList == undefined) 
    {
	productObjList = new Array();
<%
	Long reqProductId = null;
	Long reqCatentryId = null;
	Long reqCategoryId = null;
	String reqPartNumber = "";
	String reqProdName = "";
	String reqCategoryName = "";
	Integer reqProductChangeable = null;
	Long resProductId = null;
	Long resCatentryId = null;
	String resPartNumber = "";
	String resProdName = "";
	String prodDesc = "";
        String reqProdType = "";
        String resProdType = "";

        Integer[] negotiationTypes = new Integer[1];
        negotiationTypes[0] = new Integer (4);
	RFQResNewProd[] ResPros = RFQResProdHelper.getResAllProdsForNegotiationType(RequestId, ResponseId, langId, negotiationTypes);
	int i=0;
	for(; ResPros != null && i < ResPros.length; i++)
	{    
            reqProdType = "";
            resProdType = "";    
            String prodType = ResPros[i].getReq_productType().trim();
            if ((prodType != null) && !prodType.equals(""))
	    {	
		if (prodType.equals(RFQConstants.EC_OFFERING_ITEMBEAN)) 
		{
		    reqProdType = (String)rfqNLS.get("rfqproductrequesttypeitem");						
		}
		if (prodType.equals(RFQConstants.EC_OFFERING_PRODUCTBEAN)) 
		{
		    reqProdType = (String)rfqNLS.get("rfqproductrequesttypeproduct");
		}	
		if (prodType.equals(RFQConstants.EC_OFFERING_PACKAGEBEAN)) 
		{
		    reqProdType = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");
		}
		if (prodType.equals(RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) 
		{
		    reqProdType = (String)rfqNLS.get("rfqproductrequesttypedynamickit"); 
		}						
	    }

   	    if (ResPros[i].getHasResponse() != RFQConstants.EC_OFFERING_HAS_RESPONSE_NO)
   	    { 
            	prodType = ResPros[i].getProductType().trim();
            	if ((prodType != null) && !prodType.equals(""))
    	    	{
		    if (prodType.equals(RFQConstants.EC_OFFERING_ITEMBEAN)) 
		    {
		    	resProdType = (String)rfqNLS.get("rfqproductrequesttypeitem");						
		    }
		    if (prodType.equals(RFQConstants.EC_OFFERING_PRODUCTBEAN)) 
		    {
		    	resProdType = (String)rfqNLS.get("rfqproductrequesttypeproduct");
		    }	
		    if (prodType.equals(RFQConstants.EC_OFFERING_PACKAGEBEAN)) 
		    {
		     	resProdType = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");
		    }
		    if (prodType.equals(RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) 
		    {
		    	resProdType = (String)rfqNLS.get("rfqproductrequesttypedynamickit"); 
		    }					
	    	}
%>	    
	    	productObjList[<%= i %>] = new product (
	    	    "<%=ResPros[i].getReq_productId() %>",
	    	    "<%=ResPros[i].getReq_catentryId() %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getReq_partNumber()) %>",
		    "<%=UIUtil.toJavaScript(reqProdType) %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getReq_name()) %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getReq_productDesc()) %>",	    	
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getReq_categoryName()) %>",
	    	    "<%=ResPros[i].getReq_priceAdjustment() %>",
	    	    "<%=ResPros[i].getReq_quantity() %>",
	    	    "<%=ResPros[i].getReq_unit() %>",
	    	    "<%=ResPros[i].getReq_productChangeable() %>",
	    	    "<%=ResPros[i].getProduct_id() %>",
	    	    "<%=ResPros[i].getCatentry_id() %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getPartNumber()) %>",
		    "<%=UIUtil.toJavaScript(resProdType) %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getName()) %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getProductDesc()) %>",	
	    	    "<%=ResPros[i].getPriceAdjustment() %>",
	    	    "<%=ResPros[i].getQuantity() %>",
	    	    "<%=ResPros[i].getUnit() %>", 
	    	    "<%=ResPros[i].getUnitDesc() %>"); 
	    	productObjList[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_YES %>";
<%
	    } 
	    else
	    {
%>	    
	    	productObjList[<%= i %>] = new product (
	    	    "<%=ResPros[i].getReq_productId() %>",
	    	    "<%=ResPros[i].getReq_catentryId() %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getReq_partNumber()) %>",
		    "<%=UIUtil.toJavaScript(reqProdType) %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getReq_name()) %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getReq_productDesc()) %>",	    	
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getReq_categoryName()) %>",
	    	    "<%=ResPros[i].getReq_priceAdjustment() %>",
	    	    "<%=ResPros[i].getReq_quantity() %>",
	    	    "<%=ResPros[i].getReq_unit() %>",
	    	    "<%=ResPros[i].getReq_productChangeable() %>",
	    	    "",
	    	    "<%=ResPros[i].getCatentry_id() %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getPartNumber()) %>",
		    "<%=UIUtil.toJavaScript(reqProdType) %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getName()) %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getProductDesc()) %>",	
	    	    "",
	    	    "",
	    	    "",
	    	    "");
	    	productObjList[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>";
<%
	    }
	}
%>
        if (productObjList.length == 0) 
        { 
	    productObjList = null;
        }
        parent.parent.put("<%= RFQConstants.EC_OFFERING_PERCENTPRICEDYNAMICKIT %>", productObjList);
	top.saveData("<%= endresult_to_contract %>", "endresult_to_contract");
    }
           
    function product(reqProductId,reqCatentryid,reqPartNumber,reqProdType,reqName,reqProdDesc,reqCategoryName,reqPriceAdjustment,reqquantity,reqUnit,reqProdChangeable,productId,catentryid,partNumber,prodType,name,prodDesc,resPriceAdjustment,resQuantity,resQtyUnit,unitDesc) 
    {   
    	this.<%= RFQConstants.EC_RFQ_OFFERING_PRODUCTID %>=reqProductId;
    	if (reqCatentryid == null || reqCatentryid == "null") 
    	{
    	    reqCatentryid = "";
    	}
    	this.<%= RFQConstants.EC_RFQ_OFFERING_CATENTRYID %>=reqCatentryid;
    	this.<%= RFQConstants.EC_RFQ_OFFERING_PARTNUMBER %>=reqPartNumber;
    	this.<%= RFQConstants.EC_RFQ_OFFERING_PRODUCT_TYPE %>=reqProdType;
    	this.<%= RFQConstants.EC_RFQ_OFFERING_NAME %>=reqName;
	this.<%= RFQConstants.EC_RFQ_OFFERING_PRODUCT_DESC %>=reqProdDesc;
    	this.<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYNAME %>=reqCategoryName;	
    	if (reqPriceAdjustment == null || reqPriceAdjustment == "null") 
    	{
    	    reqPriceAdjustment = "";
    	}
    	this.<%= RFQConstants.EC_RFQ_OFFERING_PRICEADJUSTMENT %> = reqPriceAdjustment;
    	this.<%= RFQConstants.EC_RFQ_OFFERING_QUANTITY %>=reqquantity;
    	this.<%= RFQConstants.EC_RFQ_OFFERING_UNIT %> = reqUnit;  
    	this.<%= RFQConstants.EC_RFQ_OFFERING_PRODUCT_CHANGEABLE %> = reqProdChangeable;
    	this.<%= RFQConstants.EC_OFFERING_PRODUCTID %>=productId;
    	if (catentryid == null || catentryid == "null") 
    	{
    	    catentryid = "";
    	}
    	this.<%= RFQConstants.EC_OFFERING_CATENTRYID %>=catentryid;
    	this.<%= RFQConstants.EC_OFFERING_PARTNUMBER %>=partNumber;
        this.<%= RFQConstants.EC_OFFERING_PRODUCT_TYPE %> = prodType;
        this.<%= RFQConstants.EC_OFFERING_NAME %>=name;
        this.<%= RFQConstants.EC_OFFERING_PRODUCT_DESC %>=prodDesc;
    	this.<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %>=resPriceAdjustment;
    	this.<%= RFQConstants.EC_OFFERING_QUANTITY %> = resQuantity;
    	this.<%= RFQConstants.EC_OFFERING_UNIT %> = resQtyUnit;   
        this.<%= RFQConstants.EC_OFFERING_UNIT_DESC %> = unitDesc;
    	this.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_FALSE %>";
    }  
    
    function onLoad() 
    {
    	skipPages(parent.parent.pageArray);
    	parent.parent.reloadFrames();
    	parent.loadFrames();
    	parent.parent.setContentFrameLoaded(true);
    }
    
    function doNothing() 
    { 
    	; 
    }
    
    function getCheckedProducts()  
    {
    	var temp;
    	var theArray = new Array();
    	var form = document.rfqDynamickitPPListForm;
    	for (var i=0;i< form.elements.length;i++) 
    	{
    	    if (form.elements[i].type == 'checkbox' && form.elements[i].checked) 
    	    {
    		theArray[theArray.length] = form.elements[i].name;
            }
      	}
    	return theArray;
    }
    
    function savePanelData() 
    { 
    	parent.parent.put("<%= RFQConstants.EC_OFFERING_PERCENTPRICEDYNAMICKIT %>", productObjList );
	top.saveData("<%= endresult_to_contract %>", "endresult_to_contract");
    	return true;
    }
    
    function validatePanelData()  
    {
    	return true;
    }
    
    function ChangePriceAdjustment()   
    {
    	var index=getCheckedProducts()[0].split(',');
    	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseDynamicKitPercentagePricingRespondModify";
        if ( productObjList[index[0]].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCT_CHANGEABLE%> == '<%=RFQConstants.EC_RFQ_PRODUCT_CHANGEABLE_YES%>') 
        {
    		var rfqId = '<%= RequestId %>';
    		url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseDynamicKitChangeablePercentagePricingRespondModify&amp;requestId=" + rfqId;
        }
    	top.saveModel(parent.parent.model);
    	top.saveData(productObjList,"allPercentagePricingDynamicKits");
    	top.saveData(productObjList[index[0]],"<%= RFQConstants.EC_OFFERING_PRODITEM %>");
    	top.setReturningPanel("rfqDynamicKitPercentagePricing");
    	top.setContent(getNewBCT1(), url, true);	
    } 
    
    function getNewBCT1()  
    {
    	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqresponse")) %>";
    }

    function deleteEntry() 
    {
	if(isButtonDisabled(parent.buttons.buttonForm.deleteResponseButton))
	{
	    return;
	}

	var productIndex;
	var aList = parent.getChecked();
	for (var i=0; i<productObjList.length; i++) 
	{
	    for (var j=0; j<aList.length; j++)
	    {
		productIndex = aList[0].split(',')[0];
		if (i == productIndex) 
		{
                    productObjList[i].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>";
	  	    productObjList[i].product_name=productObjList[i].product_req_name;
                    productObjList[i].product_partnumber=productObjList[i].product_req_partnumber;
	  	    productObjList[i].product_description=productObjList[i].product_req_description;	
		    productObjList[i].product_type=productObjList[i].product_req_type;
          	    productObjList[i].<%=RFQConstants.EC_OFFERING_PRICEADJUSTMENT%>= "";                	          	      
	  	    productObjList[i].<%=RFQConstants.EC_OFFERING_QUANTITY%>="";
	  	    productObjList[i].product_res_quantity=""; 
	  	    productObjList[i].<%=RFQConstants.EC_OFFERING_UNIT%>=""; 
	  	    productObjList[i].<%=RFQConstants.EC_OFFERING_UNIT_DESC%>=""; 
  	  	    parent.removeEntry(aList[j]);
      		    break;
		}
	    }
	}
	top.saveData(productObjList,"allFixedPricingProducts");
	top.saveData("<%= endresult_to_contract %>", "endresult_to_contract");
	top.saveModel(parent.parent.model);
	parent.document.forms[0].submit();
    }	
    
    function configReport() 
    {
	if (isButtonDisabled(parent.buttons.buttonForm.rfqconfigreportButton)) 
	{
	    return;
	}

	var index=getCheckedProducts()[0].split(',');
	top.saveModel(parent.parent.model);
	top.saveData(productObjList,"allPercentagePricingDynamicKits");
	top.saveData(productObjList[index[0]],"<%= RFQConstants.EC_OFFERING_PRODITEM %>");
	var rfqId = '<%= RequestId %>';  
	var rfqProdId = productObjList[index[0]].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%>;
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqRequestSummaryDynamicKitConfigReport&amp;rfqid="+rfqId+"&amp;rfqProdId="+rfqProdId;
 
	if (top.setReturningPanel) 
	{
	    top.setReturningPanel("rfqDynamicKitPercentagePricing");
	}
	if (top.setContent) {
		
	    top.setContent(getNewBCT4(), url, true);   
	} 
	else 
	{
	    parent.parent.location.replace(url);
	}
    }
    
    function getNewBCT4() 
    {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_ConfigReport")) %>";
    }
       
    function myRefreshButtons()  
    {
    	parent.setChecked();
    	var aList=new Array();
    	aList = parent.getChecked();
    	if (aList.length == 0) 
    	{
    	    return;
    	}
	var tmpArray= new Array();
	tmpArray=aList[0].split(',');
	
	var isConfigReport = false;
	var hasResponse = false;
	if (tmpArray[1]== 1) 
	{
	    isConfigReport = true;
	}
	if (tmpArray[2] == 1)
        {
            hasResponse = true;
        }
	if (parent.buttons.buttonForm.rfqconfigreportButton && !isConfigReport) 
	{
	    parent.buttons.buttonForm.rfqconfigreportButton.className='disabled';
	    parent.buttons.buttonForm.rfqconfigreportButton.disabled=true;
	    parent.buttons.buttonForm.rfqconfigreportButton.id='disabled';
	}
        if (parent.buttons.buttonForm.deleteResponseButton && !hasResponse)
        {
            parent.buttons.buttonForm.deleteResponseButton.className='disabled';
            parent.buttons.buttonForm.deleteResponseButton.disabled=true;
            parent.buttons.buttonForm.deleteResponseButton.id='disabled';
        }
    }
  
    function selectDeselectAll()
    {
        for (var i=0; i<document.rfqDynamickitPPListForm.elements.length; i++)
        {
            var e = document.rfqDynamickitPPListForm.elements[i];
            if (e.name != 'select_deselect')
            {
                e.checked = document.rfqDynamickitPPListForm.select_deselect.checked;
            }
        }
        myRefreshButtons();
    }

    function setSelectDeselectFalse()
    {
        document.rfqDynamickitPPListForm.select_deselect.checked = false;
    }
    
    function isButtonDisabled(b) 
    {
    	if (b.className =='disabled' ) 
    	{
    	    return true;
    	}    
    	return false;
    }    
</script>

</head>

<body class="content_list" >

<%= rfqNLS.get("instruction_DynamicKits_PercentagePrice_modify") %>

<script type="text/javascript">
<!--
//For IE
    if (document.all) { onLoad(); }
//-->
</script>

<form name="rfqDynamickitPPListForm" action="">
<script type="text/javascript">
<%
    int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
    int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
    int endIndex = startIndex + listSize;
%>
    listSize = <%= listSize %>;
    startIndex = <%= startIndex %>;
    endIndex   = <%= endIndex %>;
    if ((productObjList!=null)&&( productObjList.length > 0) ) 
    {
	if (endIndex > productObjList.length) 
	{
	    endIndex = productObjList.length;
	}
    }
    if (startIndex < 0) 
    {
	startIndex=0;
    }
    if (productObjList == null || productObjList.length < 1 ) 
    {
	endIndex = 0;
	parent.set_t_item(0);
	parent.set_t_page(1);
    } 
    else  
    {
	numpage  = Math.ceil(productObjList.length / listSize);
	parent.set_t_item(productObjList.length);
	parent.set_t_page(numpage);
    }
</script>

<%= comm.startDlistTable((String)rfqNLS.get("rfqdynamickitpercentagepricing")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading() %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqdynamickitname"),"null",false,"18%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestpriceadjustment"),"null",false,"16%",wrap ) %>
<%
    if (!endresult_to_contract) 
    {   
%>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("resrequestquantity"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestunits"),"null",false,"9%",wrap ) %>
<% 
    } 
%>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqdynamickitcanbesubstituted"),"null",false,"16%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqdynamickitsubstitutedinresponse"),"null",false,"16%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsedynamickitname"),"null",false,"18%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepriceadjustment"),"null",false,"16%",wrap ) %>
<%
    if (!endresult_to_contract) 
    {   
%>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("responsequantity"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponseunits"),"null",false,"9%",wrap ) %>
<% 
    }
%>
<%= comm.endDlistRow() %>

<script type="text/javascript">

    function output() 
    {
  	var checkvalue;
  	var rowselect = 1;
  	if (productObjList == null || productObjList == undefined) 	
  	{ 
	    return ;
  	} 
  	for (var i =startIndex ;i <endIndex;i++)	
  	{  
 	    var reqCategoryName;

	    var reqProdName;		
	    var reqProdType;    
	    var reqPriceAdjustment;
	    var reqQuantity;
	    var reqUnits;
	    var prodChangeable;       
	    var prodSubstituted; 
	    var resProdName;
 	    var resPriceAdjustment;
 	    var resQuantity;
	    var resUnits;	
 	    
 	    reqCategoryName = productObjList[i].<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYNAME %>;
    	    if (reqCategoryName == null || reqCategoryName =="" || reqCategoryName == undefined) 
	    {
		reqCategoryName ="<%= UIUtil.toJavaScript(rfqNLS.get("none")) %>";
	    }
 	    				
	    reqProdType = productObjList[i].<%= RFQConstants.EC_RFQ_OFFERING_PRODUCT_TYPE %>;
	    reqProdName = productObjList[i].<%= RFQConstants.EC_RFQ_OFFERING_NAME %>;
	    if (reqProdName == null || reqProdName =="" || reqProdName == undefined) 
	    {
		reqProdName ="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
	    }	
 	    if (productObjList[i].<%= RFQConstants.EC_RFQ_OFFERING_PRICEADJUSTMENT %> == null || 
	        productObjList[i].<%= RFQConstants.EC_RFQ_OFFERING_PRICEADJUSTMENT %> == ""   || 
	        productObjList[i].<%= RFQConstants.EC_RFQ_OFFERING_PRICEADJUSTMENT %> == undefined) 
	    {
		reqPriceAdjustment = "";
	    }	
	    else
	    {		
	        reqPriceAdjustment = numberToStr(productObjList[i].<%= RFQConstants.EC_RFQ_OFFERING_PRICEADJUSTMENT %>, <%= langId %>, null);
 	    }
 	    if (productObjList[i].<%= RFQConstants.EC_REQ_OFFERING_QUANTITY %> == null || 
	        productObjList[i].<%= RFQConstants.EC_REQ_OFFERING_QUANTITY %> == ""   || 
	        productObjList[i].<%= RFQConstants.EC_REQ_OFFERING_QUANTITY %> == undefined) 
	    {
		reqQuantity = "";
	    }	
	    else
	    {		
	        reqQuantity = numberToStr(productObjList[i].<%= RFQConstants.EC_REQ_OFFERING_QUANTITY %>, <%= langId %>, null);
 	    }	    
	    reqUnits = productObjList[i].<%= RFQConstants.EC_RFQ_OFFERING_UNIT %>;
		
	    if (productObjList[i].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCT_CHANGEABLE%> == '<%=RFQConstants.EC_RFQ_PRODUCT_CHANGEABLE_YES%>') 
	    {
		prodChangeable="<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
            } 
            else 
            {
		prodChangeable="<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
            }
                            
            if (productObjList[i].<%=RFQConstants.EC_OFFERING_CATENTRYID%> == productObjList[i].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>) 
            {
		prodSubstituted="<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
            } 
            else 
            {
		prodSubstituted="<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
            }
            		
	    resProdName = productObjList[i].<%= RFQConstants.EC_OFFERING_NAME %>;
	    if (resProdName == null || resProdName =="" || resProdName == undefined) 
	    {
		resProdName ="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
	    }
 	    if (productObjList[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> == null || 
	        productObjList[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> == ""   || 
	        productObjList[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %> == undefined) 
	    {
		resPriceAdjustment = "";
	    }	
	    else
	    {		
	        resPriceAdjustment = numberToStr(productObjList[i].<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %>, <%= langId %>, null);
 	    }
 	    if (productObjList[i].<%= RFQConstants.EC_OFFERING_QUANTITY %> == null || 
	        productObjList[i].<%= RFQConstants.EC_OFFERING_QUANTITY %> == ""   || 
	        productObjList[i].<%= RFQConstants.EC_OFFERING_QUANTITY %> == undefined) 
	    {
		resQuantity = "";
	    }	
	    else
	    {		
 	        resQuantity = numberToStr(productObjList[i].<%= RFQConstants.EC_OFFERING_QUANTITY %>, <%= langId %>, null); 
 	    }
 	    resUnits = productObjList[i].<%= RFQConstants.EC_OFFERING_UNIT_DESC %>;
 	    
 	    checkvalue = i;
	    if (reqProdType == '<%= (String)rfqNLS.get("rfqproductrequesttypedynamickit") %>') 
	    {
	    	checkvalue = checkvalue +"," + "1";
	    } 
	    else 
	    {
	    	checkvalue = checkvalue +"," + "0";
	    }	        
	    
            if (productObjList[i].<%=RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT%> ==  "<%=RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO%>")
            {
            	checkvalue = checkvalue +"," + "0";
            }
            else
            {
            	checkvalue = checkvalue +"," + "1";
            }
        	    
	    startDlistRow(rowselect);
	    addDlistCheck(checkvalue, "setSelectDeselectFalse();myRefreshButtons();", null);
	    addDlistColumn(ToHTML(reqProdName));
            if (reqPriceAdjustment == null || isEmpty(ToHTML(reqPriceAdjustment)))
	    {
	        addDlistColumn(ToHTML(reqPriceAdjustment));
	    }
	    else
	    {
	        addDlistColumn(ToHTML(reqPriceAdjustment+'<%=(String)rfqNLS.get("percentagemark")%>'));
	    }
<%
	    if (!endresult_to_contract) 
	    {   
%> 
	    	addDlistColumn(ToHTML(reqQuantity));
	    	addDlistColumn(ToHTML(reqUnits));
<% 
 	    }
%>	    
	    addDlistColumn(ToHTML(prodChangeable));
	    addDlistColumn(ToHTML(prodSubstituted));
	    addDlistColumn(ToHTML(resProdName));
            if (resPriceAdjustment == null || isEmpty(ToHTML(resPriceAdjustment)))
	    {
	        addDlistColumn("");
	    }
	    else
	    {
	        addDlistColumn(ToHTML(resPriceAdjustment+'<%=(String)rfqNLS.get("percentagemark")%>'));
	    }
<%
	    if (!endresult_to_contract) 
	    {   
%> 
 	    	addDlistColumn(ToHTML(resQuantity));   
 	    	addDlistColumn(ToHTML(resUnits));   
<% 
	    }
%>	 	
	    endDlistRow();
		
    	    if ( rowselect == 1 ) 
    	    { 
    	    	rowselect = 2; 
    	    } 
    	    else 
    	    { 
    		rowselect = 1; 
    	    }
  	}
  	endDlistTable();
  	return ;
    }
    
    output();
</script>

</form>

<script type="text/javascript">
    parent.afterLoads();
    if (productObjList != null) 
    {
    	parent.setResultssize(productObjList.length);
    } 
    else 
    {
    	parent.setResultssize(0);
    }
</script>

</body>
</html>
