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
<%@ page import="com.ibm.commerce.catalog.beans.*"%>
<%@ page import="com.ibm.commerce.catalog.objects.*"%>
<%@ page import="com.ibm.commerce.contract.beans.*"%>
<%@ page import="com.ibm.commerce.contract.objects.*"%>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.beans.*" %>
<%@ page import="com.ibm.commerce.common.objects.*"%>
<%@ page import="com.ibm.commerce.price.utils.*"  %>
<%@ page import="com.ibm.commerce.rfq.objects.*"%>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.utf.beans.*"%>
<%@ page import="com.ibm.commerce.utf.objects.*"%>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.utils.*" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="../common/List.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>

<jsp:useBean id="rfqProdList" class="com.ibm.commerce.utf.beans.RFQProdListBean"></jsp:useBean>
<%
    String StoreId = null;
    Locale aLocale = null;
    Integer languageId = null; 
    boolean wrap = true;
    
    //***Get storeId from CommandContext
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    String ErrorMessage = request.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
    if (ErrorMessage == null) 
    {
	ErrorMessage = "";
    }
    if ( aCommandContext != null ) 
    {
        StoreId = aCommandContext.getStoreId().toString();
        aLocale = aCommandContext.getLocale();
        languageId = aCommandContext.getLanguageId();
    
        //no wrapping for the asian languages
        if(languageId != null && languageId.intValue() <= -7 && languageId.intValue() >= -10) 
        { 
            wrap = false; 
        }
    }
    // obtain the resource bundle for display
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", aLocale);
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
    var isFirstTimeLogonPanel7;
    isFirstTimeLogonPanel7=top.getData("isFirstTimeLogonPanel7");
    if (isFirstTimeLogonPanel7 != "0") 
    {
    	isFirstTimeLogonPanel7="1";  //"1" means first time logon Panel7.
    	top.saveData("0","isFirstTimeLogonPanel7");
    }    
    var ProductsArray = new Array();
    
    function setPD() 
    {
    	if (isFirstTimeLogonPanel7 == "0") 
    	{   //NOT first time log on panel7
    	    ProductsArray = top.getData("allPercentagePricingDynamicKits");
    	} 
    	else 
    	{					
<%   
            String rfqId = jspHelper.getParameter("requestId");
 %>
<jsp:useBean id="rfq" class="com.ibm.commerce.utf.beans.RFQDataBean" >
<jsp:setProperty property="*" name="rfq" />
</jsp:useBean>
<%
    	    boolean endresult_to_contract = false;
    	    String endresult = null;
    	    if (rfqId != null && rfqId.length() > 0) 
    	    {
       	 	rfq.setRfqId(rfqId);
        	com.ibm.commerce.beans.DataBeanManager.activate(rfq, request);
        	endresult = rfq.getEndResult();
        	if (endresult.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_UTF_ENDRESULT_CONTRACT.toString())) 
        	{
            	    endresult_to_contract = true;
    		}
    	    }
    	           
	    Integer[] negotiationTypes = new Integer[1];
	    negotiationTypes[0] = new Integer (4);
            rfqProdList.setRFQId(rfqId);
    	    rfqProdList.setNegotiationTypes(negotiationTypes);
	    com.ibm.commerce.beans.DataBeanManager.activate(rfqProdList, request);
	    RFQProdDataBean[] rfqProds = rfqProdList.getRFQProds();
	    
	    String catentryid_in_prod = null;
	    String prodChangeable = null;
	    String prodId         = null;
	    String prodName       = null;	    
	    String prodType       = null;	    
	    String prodCategoryId = null;
	    String prodPartNumber = null;
	    String prodDesc     = null;
    	    String prodPriceAdjustment  = null;
    	    String priceAdjustment_ds   = null;

            String prodUnitId     = null;
            String prodUnit       = null;
            String prodQuantity   = null;
            String quantity_ds    = null;
    	        
    	    // Get currency, currency prefix and suffix for the store and language      
	    for(int i=0; i<rfqProds.length; i++) 
	    {
          	RFQProdDataBean aRfqProd = rfqProds[i];
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
          	    java.text.NumberFormat numberFormatter;
          	    if (itemp.intValue() <= 0) 
          	    {
          		numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
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
          	    	java.text.NumberFormat numberFormatter;
          	    	if (itemp.intValue() >= 0) 
          	    	{
          		    numberFormatter = java.text.NumberFormat.getNumberInstance(aLocale);
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
          	ProductsArray[<%=i%>] = new Object();
          	ProductsArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%>="<%=prodId%>";
	  	ProductsArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>="<%=aRfqProd.getCatentryId()%>";
		
		var catentryDes = '<%=catentryDes%>';
	  	ProductsArray[<%=i%>].product_req_name="<%=prodName%>";
		ProductsArray[<%=i%>].product_req_type="<%= prodType %>"; 
                ProductsArray[<%=i%>].product_req_partnumber="<%=prodPartNumber%>"; 
		ProductsArray[<%=i%>].product_req_description="<%=prodDesc%>";
		
		var rfqCategoryName = "<%=rfqCategoryName%>";
		if (rfqCategoryName != "null" && !isEmpty(rfqCategoryName)) 
		{
	  	    ProductsArray[<%=i%>].product_req_categoryName=rfqCategoryName;
		} 
		else 
		{
	  	    ProductsArray[<%=i%>].product_req_categoryName="";
		}			
			
		ProductsArray[<%=i%>].product_req_priceAdjustment = "<%= priceAdjustment_ds %>";
          	ProductsArray[<%=i%>].product_req_changeable="<%=prodChangeable%>";	
          	  	
	  	if (ProductsArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%> != null && !isEmpty(ProductsArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>)) 
	  	{
	  	    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_CATENTRYID%> = ProductsArray[<%=i%>].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>;
                    ProductsArray[<%=i%>].product_partnumber=ProductsArray[<%=i%>].product_req_partnumber;
		    ProductsArray[<%=i%>].product_name=ProductsArray[<%=i%>].product_req_name;
                    ProductsArray[<%=i%>].product_type=ProductsArray[<%=i%>].product_req_type;
                    ProductsArray[<%=i%>].product_description=ProductsArray[<%=i%>].product_req_description;
		} 
		else 
		{
	  	    ProductsArray[<%=i%>].product_name="";
                    ProductsArray[<%=i%>].product_partnumber="";
                    ProductsArray[<%=i%>].product_type="";
                    ProductsArray[<%=i%>].product_description="";
		}
		
          	ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRICEADJUSTMENT%>= "<%=prodPriceAdjustment%>";
		ProductsArray[<%=i%>].product_res_priceAdjustment = "<%=priceAdjustment_ds%>"; 
<%
		if (!endresult_to_contract) 
		{   
%>		
		    ProductsArray[<%=i%>].product_req_quantity="<%=quantity_ds%>";
          	    ProductsArray[<%=i%>].product_req_unit="<%=prodUnit%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_QUANTITY%>=<%=prodQuantity%>;
	  	    ProductsArray[<%=i%>].product_res_quantity=ProductsArray[<%=i%>].product_req_quantity;
	  	    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_UNIT%>="<%=prodUnitId%>";  
	  	    ProductsArray[<%=i%>].UnitDsc=ProductsArray[<%=i%>].product_req_unit;	
<%
	        }
%>		
		ProductsArray[<%=i%>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_YES %>"; 		
<%  		
  	    }	
%>	    
   	    top.saveData(ProductsArray,"allPercentagePricingDynamicKits");
   	}
    }
    
    setPD();

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
	if (tmpArray[1]== 1) {
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
<%
    int startIndex = Integer.parseInt(jspHelper.getParameter("startindex"));
    int listSize = Integer.parseInt(jspHelper.getParameter("listsize"));
    int endIndex = startIndex + listSize;
%>
    listSize = <%= listSize %>;
    startIndex = <%= startIndex %>;
    endIndex   = <%= endIndex %>;
    if ((ProductsArray!=null)&&( ProductsArray.length > 0)) 
    {
	if (endIndex > ProductsArray.length) 
	{
	    endIndex = ProductsArray.length;
	}
    }
    if (startIndex < 0) 
    {
	startIndex=0;
    }
    if (ProductsArray==null || ProductsArray.length < 1 ) 
    {
	endIndex = 0;
	parent.set_t_item(0);
	parent.set_t_page(1);
    } 
    else 
    {
	numpage  = Math.ceil(ProductsArray.length / listSize);
	parent.set_t_item(ProductsArray.length);
	parent.set_t_page(numpage);
    }
    
    function getProductByID(productID) 
    {
  	var anProduct = new Object();
  	for (var i=0;i < ProductsArray.length ;i++) 
  	{
	    if(ProductsArray[i].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%> == productID) 
	    {
      		anProduct = ProductsArray[i];
      		break;
	    }
  	}
  	return anProduct;
    }
    function getAnProduct() 
    { 
      	var anProduct = new Object();
      	var productID;
      	var t = new Array();
      	t = parent.getChecked();
      	if (t.length == 1) 
      	{
    	    productID = t[0].split(',')[0];
    	    anProduct = getProductByID(productID);  
      	}
      	return anProduct;
    }
    
    function savePanelData() 
    { 
    	parent.parent.put("<%= RFQConstants.EC_OFFERING_PERCENTPRICEDYNAMICKIT %>", ProductsArray );
    	return true;
    }
    
    function validatePanelData() 
    {
    	return true;
    }
    
    function saveData() 
    {
    	var anProduct = new Object;
    	anProduct = getAnProduct();
    	top.saveData(anProduct,"anProduct");
    	top.saveData(ProductsArray,"allPercentagePricingDynamicKits");
    	top.saveData("<%= endresult_to_contract %>", "endresult_to_contract");
    	top.saveModel(parent.parent.model);
    }
    
    function ResponseEntry() 
    {
    	var anProduct = new Object;
    	anProduct = getAnProduct();
    	top.saveData(anProduct,"anProduct");
    	top.saveData(ProductsArray,"allPercentagePricingDynamicKits");
    	top.saveData("<%= endresult_to_contract %>", "endresult_to_contract");
    	top.saveModel(parent.parent.model);
    	
    	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseDynamicKitPercentagePricingRespond";
    	if (anProduct.product_req_changeable == '<%=RFQConstants.EC_RFQ_PRODUCT_CHANGEABLE_YES%>') 
    	{
    		var rfqId = '<%= jspHelper.getParameter("requestId")%>';
    		url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseDynamicKitChangeablePercentagePricingRespond&amp;requestId=" + rfqId;
    	}
    	
    	if (top.setReturningPanel) 
    	{
    	    top.setReturningPanel("rfqDynamicKitPercentagePricing");
    	} 	
    	if (top.setContent) 
    	{
    	    top.setContent(getNewBCT1(), url, true);
    	} 
    	else 
    	{
    	    parent.parent.location.replace(url);
    	} 
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

	var productID;
	var aList = parent.getChecked();
	for (var i=0; i<ProductsArray.length; i++) 
	{
	    for (var j=0; j<aList.length; j++)
	    {
		productID = aList[0].split(',')[0];
		if (ProductsArray[i].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%> == productID) 
		{
                    ProductsArray[i].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>";
	  	    ProductsArray[i].product_name=ProductsArray[i].product_req_name;
                    ProductsArray[i].product_partnumber=ProductsArray[i].product_req_partnumber;
	  	    ProductsArray[i].product_description=ProductsArray[i].product_req_description;	
		    ProductsArray[i].product_type=ProductsArray[i].product_req_type; 
	  	    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRICEADJUSTMENT%>= "";
		    ProductsArray[i].product_res_priceAdjustment = ""; 
<%
		    if (!endresult_to_contract) 
		    {   
%>		
	  	        ProductsArray[i].<%=RFQConstants.EC_OFFERING_QUANTITY%>="";
	  	        ProductsArray[i].product_res_quantity="";
	  	        ProductsArray[i].<%=RFQConstants.EC_OFFERING_UNIT%>="";  
	  	        ProductsArray[i].UnitDsc="";
<%
                    }
%>	  	    
  	  	    parent.removeEntry(aList[j]);
      		    break;
		}
	    }
	}
	top.saveData(ProductsArray,"allPercentagePricingDynamicKits");
	top.saveModel(parent.parent.model);
	parent.document.forms[0].submit();
    }	
        
    function configReport() 
    {
    	if (isButtonDisabled(parent.buttons.buttonForm.rfqconfigreportButton)) 
    	{
    		return;
    	}
    	var anProduct = new Object;
    	anProduct = getAnProduct();
    	top.saveData(anProduct,"anProduct");
    	top.saveData(ProductsArray,"allPercentagePricingDynamicKits");
    	top.saveModel(parent.parent.model);
    	
    	var rfqId = '<%= jspHelper.getParameter("requestId")%>';  
    	var rfqProdId = anProduct.<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%>;
    	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqRequestSummaryDynamicKitConfigReport&amp;rfqid="+rfqId+"&amp;rfqProdId="+rfqProdId;
    	if (top.setReturningPanel) 
    	{
    	    top.setReturningPanel("rfqDynamicKitPercentagePricing");
    	}
    	if (top.setContent) 
    	{	
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
    
    function initializeState() 
    {
    	skipPages(parent.parent.pageArray);
    	parent.parent.reloadFrames();
    	parent.parent.setContentFrameLoaded(true);
    }
</script>

</head>

<body class="content" onload="initializeState()">

<%= rfqNLS.get("instruction_DynamicKits_PercentagePrice") %>

<form name="rfqDynamickitPPListForm" method="get" action="">

<%= comm.startDlistTable((String)rfqNLS.get("rfqdynamickitpercentagepricing")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"selectDeselectAll()") %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestdynamickitname"),"null",false,"18%",wrap ) %>
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
    var checkname;
    var checkvalue;
    var s, changeable, mandatory;
    var rowselect = 1;
    s ="";
    changeable="";
    mandatory ="";  
    for (var i=startIndex; i<endIndex; i++) 
    { 
    	checkname = "checkname_" + i;
        var reqName, reqCategoryName;
    	var prodChangeable,prodSubstituted;
    	checkvalue = ProductsArray[i].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%>;

	if (ProductsArray[i].product_req_changeable == '<%=RFQConstants.EC_RFQ_PRODUCT_CHANGEABLE_YES%>') 
	{
	    prodChangeable="<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
	} 
	else 
	{
	    prodChangeable="<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
	}
	
	if (ProductsArray[i].<%=RFQConstants.EC_OFFERING_CATENTRYID%> != null && !isEmpty(ProductsArray[i].<%=RFQConstants.EC_OFFERING_CATENTRYID%>) && ProductsArray[i].<%=RFQConstants.EC_OFFERING_CATENTRYID%> != ProductsArray[i].<%=RFQConstants.EC_RFQ_OFFERING_CATENTRYID%>) 
	{
	    prodSubstituted="<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
	} 
	else 
	{
	    prodSubstituted="<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
	}
	
	if (ProductsArray[i].product_req_type == '<%= (String)rfqNLS.get("rfqproductrequesttypedynamickit") %>') 
	{
	    checkvalue = checkvalue +"," + "1";
	} 
	else 
	{
	    checkvalue = checkvalue +"," + "0";
	}
		
	if (ProductsArray[i].<%=RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT%> == "<%=RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO%>") 
	{
	    checkvalue = checkvalue +"," + "0";
	} 
	else 
	{
	    checkvalue = checkvalue +"," + "1";
	}
			  
	startDlistRow(rowselect);
	addDlistCheck(checkvalue, "setSelectDeselectFalse();myRefreshButtons();", null);
	addDlistColumn(ToHTML(ProductsArray[i].product_req_name));
        if (ProductsArray[i].product_req_priceAdjustment == null   || 
	    isEmpty(ToHTML(ProductsArray[i].product_req_priceAdjustment)))
        {
	    addDlistColumn(ToHTML(ProductsArray[i].product_req_priceAdjustment));
        }
        else
        {
	    addDlistColumn(ToHTML(ProductsArray[i].product_req_priceAdjustment + '<%=(String)rfqNLS.get("percentagemark")%>'));
        }
<%
	if (!endresult_to_contract) 
	{   
%> 
 	    addDlistColumn(ToHTML(ProductsArray[i].product_req_quantity));   
 	    addDlistColumn(ToHTML(ProductsArray[i].product_req_unit));   
<% 
 	}
%>
	addDlistColumn(ToHTML(prodChangeable));
	addDlistColumn(ToHTML(prodSubstituted));
    	if (ProductsArray[i].product_name == null || isEmpty(ProductsArray[i].product_name)) 
    	{
    	    addDlistColumn(ToHTML("<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>"));
    	} 
    	else 
    	{
	    addDlistColumn(ToHTML(ProductsArray[i].product_name));
    	}
        if (ProductsArray[i].product_res_priceAdjustment == null   || 
	    isEmpty(ToHTML(ProductsArray[i].product_res_priceAdjustment)))
        {
	    addDlistColumn(ToHTML(ProductsArray[i].product_res_priceAdjustment));
        }
        else
        {
	    addDlistColumn(ToHTML(ProductsArray[i].product_res_priceAdjustment + '<%=(String)rfqNLS.get("percentagemark")%>'));
        }
<%
	if (!endresult_to_contract) 
	{   
%> 
 	    addDlistColumn(ToHTML(ProductsArray[i].product_res_quantity));   
 	    addDlistColumn(ToHTML(ProductsArray[i].UnitDsc));   
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
</script>

<%= comm.endDlistTable() %>

</form>

<script type="text/javascript">
    parent.afterLoads();
    if (ProductsArray != null) 
    {
      	parent.setResultssize(ProductsArray.length);
    }    
    else 
    {
      	parent.setResultssize(0);
    }
    
    function retrievePanelData() 
    {
    	if (top.getData("anProduct") != undefined && top.getData("anProduct") != null) 
    	{
    	    parent.parent.model=top.getModel();
    	}
    }
    
    retrievePanelData();
</script>

</body>
</html>
