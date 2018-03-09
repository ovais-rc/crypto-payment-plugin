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

<%@  page import="java.math.*" %>
<%@  page import="java.text.*" %>
<%@  page import="java.util.*" %>
<%@  page import="com.ibm.commerce.catalog.objects.*" %>
<%@  page import="com.ibm.commerce.command.*" %>
<%@  page import="com.ibm.commerce.common.objects.*" %>
<%@  page import="com.ibm.commerce.contract.beans.*" %>
<%@  page import="com.ibm.commerce.contract.objects.*" %>
<%@  page import="com.ibm.commerce.contract.util.*" %>
<%@  page import="com.ibm.commerce.rfq.beans.*" %>
<%@  page import="com.ibm.commerce.rfq.objects.*" %>
<%@  page import="com.ibm.commerce.rfq.utils.*" %>
<%@  page import="com.ibm.commerce.utf.beans.*" %>
<%@  page import="com.ibm.commerce.utf.objects.*" %>
<%@  page import="com.ibm.commerce.utf.utils.*" %>
<%@  page import="com.ibm.commerce.price.utils.*"  %>
<%@  page import="com.ibm.commerce.price.*"  %>
<%@  page import="com.ibm.commerce.server.*" %>
<%@  page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@  page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@  page import="com.ibm.commerce.tools.util.*" %>

<%@  include file="../common/common.jsp" %>

<%
    //*** GET LOCALE FROM COMANDCONTEXT ***//
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    Locale locale = null;
    if( aCommandContext!= null )
    {
   	locale = aCommandContext.getLocale();
    }
    if (locale == null)
    {
	locale = new Locale("en","US");
    }

    //*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",locale);
    String strPercentage = (String)rfqNLS.get("percentagemark");

    JSPHelper jsphp=new JSPHelper(request);
    String resId = jsphp.getParameter("resId");
    
        
    RFQResponseDataBean RFQres = new RFQResponseDataBean();
    RFQres.setInitKey_rfqResponseId(Long.valueOf(resId));
    String responseName = UIUtil.toHTML(RFQres.getName());

    String RequestId = RFQres.getRfqId();
    RFQDataBean rfq = new RFQDataBean();
    rfq.setRfqId(RequestId);
    
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

    String reqCategoryId = jsphp.getParameter("rfqCategoryId");   
    
    String reqCategoryName = "";
    if (reqCategoryId != null && reqCategoryId.length() > 0)
    {
        RFQCategryDataBean rfqCategry = new RFQCategryDataBean();
        rfqCategry.setRfqCategryId(reqCategoryId);

        reqCategoryName = UIUtil.toHTML(rfqCategry.getName());
    }
    if (reqCategoryName == null || reqCategoryName =="")
    {
        reqCategoryName = UIUtil.toHTML((String)rfqNLS.get("RFQExtra_NotCategorized"));
    }
%>

<!-- Product List for RFQ  -->
<jsp:useBean id="rfqProdList" class="com.ibm.commerce.utf.beans.RFQProdListBean" >
<jsp:setProperty property="*" name="rfqProdList" />
</jsp:useBean>
<%
    rfqProdList.setRFQId(RequestId);
    if (reqCategoryId != null && reqCategoryId.length() > 0)
    {
        rfqProdList.setRFQCategoryId(reqCategoryId);
    }
    else
    {
        rfqProdList.setRFQCategoryId("null");
    }
    com.ibm.commerce.beans.DataBeanManager.activate(rfqProdList, request);
    com.ibm.commerce.utf.beans.RFQProdDataBean [] pList = rfqProdList.getRFQProds();
%>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript">
    function initializeState()
    {
        parent.setContentFrameLoaded(true);
    }

    function product(productId,price,quantity,currency,unit,catentryid,name,reqCatentryid,reqName,reqCategoryId,reqCategoryName, reqProductId,req_type,type,partnum,description,pprice)
    {
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
	if (productId == null || productId == "null" || productId == "" || productId == undefined) 
	{
	    this.<%= RFQConstants.EC_OFFERING_NAME %>=name;
	}
	else
	{
	    if (name == null || name =="" || name == undefined) 
	    {
	    	this.<%= RFQConstants.EC_OFFERING_NAME %>="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
	    }
            else
	    {
	    	this.<%= RFQConstants.EC_OFFERING_NAME %>=name;
	    }
	}
	this.<%= RFQConstants.EC_RFQ_OFFERING_CATENTRYID %>=reqCatentryid;
        this.<%= RFQConstants.EC_RFQ_OFFERING_NAME %>=reqName;
        this.<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYID %>=reqCategoryId;
        this.<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYNAME %>=reqCategoryName;
        this.<%= RFQConstants.EC_RFQ_OFFERING_PRODUCTID %>=reqProductId;
    }
	function goToConfigurationReport(rfqid, rfqProdId){
		top.setContent(getConfigurationReportBCT(), "DialogView?XMLFile=rfq.rfqRequestSummaryDynamicKitConfigReport&amp;rfqid="+rfqid+"&amp;rfqProdId="+rfqProdId, true);
	}
	function getConfigurationReportBCT() {
  		return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_ConfigReport")) %>";
	}

    function initData()
    {
<%
	int numOfFPP = 0;
	int numOfPPP = 0;
	int numOfFPDK = 0;
	int numOfPPDK = 0;
        for (int i = 0;pList != null && i < pList.length;i++)
        {
            RFQProdDataBean abRfqProd = (RFQProdDataBean) pList[i];
	    Integer rfqNegotiationType = abRfqProd.getNegotiationType();
            String rfqProdCatentryId = abRfqProd.getCatentryId();
            String rfqProdId = abRfqProd.getRfqprodId();
            String rfqProdName = null;
                      
	    String rfqProdType = "";
            CatalogEntryAccessBean abCatentry1 = null;
	    CatalogEntryDescriptionAccessBean abCatentryDes1 = null;
	    if ((rfqProdCatentryId != null) && !rfqProdCatentryId.equals(""))
	    {
		abCatentry1 = new CatalogEntryAccessBean();
		abCatentry1.setInitKey_catalogEntryReferenceNumber(rfqProdCatentryId);					
	
		rfqProdType = abCatentry1.getType();	
		if (rfqProdType.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) 
		{
		    rfqProdType = (String)rfqNLS.get("rfqproductrequesttypeitem");
		}
		if (rfqProdType.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) 
		{
		    rfqProdType = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
		}
		if (rfqProdType.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) 
		{
		    rfqProdType = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");	
		}
		if (rfqProdType.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) 
		{
		    rfqProdType = (String)rfqNLS.get("rfqproductrequesttypedynamickit");  
		}        	

		abCatentryDes1 = new CatalogEntryDescriptionAccessBean();
          	abCatentryDes1.setInitKey_catalogEntryReferenceNumber(rfqProdCatentryId);
	  	abCatentryDes1.setInitKey_language_id(langId.toString());
		rfqProdName = UIUtil.toJavaScript(abCatentryDes1.getName());
	    } 
	    else 
	    {
		rfqProdName = UIUtil.toJavaScript(abRfqProd.getRfqProductName());
	    }
            if (rfqProdName == null)
            {
                rfqProdName = "";
            }

            RFQResponseProductAccessBean abTemp = new RFQResponseProductAccessBean();
	    Enumeration enu = abTemp.findByRfqResponseIdAndRfqProductId(Long.valueOf(resId),Long.valueOf(rfqProdId));
	     
            RFQResponseProductAccessBean abResponseProd = null;
	    if (enu != null && enu.hasMoreElements()) 
	    {
	    	abResponseProd = (RFQResponseProductAccessBean) enu.nextElement();
	    }
	    String resProdId = null;
	    String resProdCatentryId = null;
	    String resProdUnitId = null;
	    String resProdCurrency = null;
	    Double quantity_ejb = null;
	    BigDecimal price_ejb = null;
	    Double priceAdjustment_ejb = null;
	    if (abResponseProd != null)
	    {
	        resProdId = abResponseProd.getRfqResponseProdId();
	        resProdCatentryId = abResponseProd.getCatentryId();
	        resProdUnitId = abResponseProd.getQuantityUnitId();
		resProdCurrency = abResponseProd.getCurrency();
	        price_ejb=abResponseProd.getPriceInEntityType();
		quantity_ejb = abResponseProd.getQuantityInEntityType();
		priceAdjustment_ejb=abResponseProd.getPriceAdjustmentInEntityType();
            }

            String resProdName = null;
	    String resProdType = "";	    
	    String resPartnum = "";
	    String resProdDescription = "";
            CatalogEntryAccessBean abCatentry2 = null;
            CatalogEntryDescriptionAccessBean abCatentryDes2 = null;
	    if ((resProdCatentryId != null) && !resProdCatentryId.equals(""))
	    {
		abCatentry2 = new CatalogEntryAccessBean();
		abCatentry2.setInitKey_catalogEntryReferenceNumber(resProdCatentryId);					
		resPartnum = abCatentry2.getPartNumber();	
			
		resProdType = abCatentry2.getType();	
		if (resProdType.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_ITEMBEAN)) 
		{
		    resProdType = (String)rfqNLS.get("rfqproductrequesttypeitem");
		}
		if (resProdType.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PRODUCTBEAN)) 
		{
		    resProdType = (String)rfqNLS.get("rfqproductrequesttypeproduct");	
		}
		if (resProdType.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_PACKAGEBEAN)) 
		{
		    resProdType = (String)rfqNLS.get("rfqproductrequesttypeprebuiltkit");	
		}
		if (resProdType.equals(com.ibm.commerce.rfq.utils.RFQConstants.EC_OFFERING_DYNAMICKITBEAN)) 
		{
		    resProdType = (String)rfqNLS.get("rfqproductrequesttypedynamickit");  
		}        	

          	abCatentryDes2 = new CatalogEntryDescriptionAccessBean();
          	abCatentryDes2.setInitKey_catalogEntryReferenceNumber(resProdCatentryId);
	  	abCatentryDes2.setInitKey_language_id(langId.toString());
		resProdName = UIUtil.toJavaScript(abCatentryDes2.getName());
		resProdDescription = UIUtil.toHTML(abCatentryDes2.getShortDescription());
	    } 
	    else 
	    {
		resProdName = rfqProdName;
	    }
            if (resProdName == null)
            {
                resProdName = "";
            }
            if (resPartnum == null)
            {
                resPartnum = "";
            }
            if (resProdDescription == null)
            {
                resProdDescription = "";
            }

	    String resProdUnitDesc = "";
	    if (resProdUnitId != null) 
	    {
                QuantityUnitDescriptionAccessBean abQtyUnit = new QuantityUnitDescriptionAccessBean();
          	abQtyUnit.setInitKey_language_id(langId.toString());
          	abQtyUnit.setInitKey_quantityUnitId(resProdUnitId);
          	resProdUnitDesc = abQtyUnit.getDescription();
      	    }
      	    else 
	    {
      		resProdUnitId="";
      		resProdUnitDesc="";
      	    }

	    String price="";
	    if (price_ejb!=null && price_ejb.doubleValue() >= 0 ) 
	    {
		fmt = cm.getFormattedMonetaryAmount( new MonetaryAmount(price_ejb, currencyCode), storeAB, langId);
		price = fmt.getFormattedValue();	// price without prefix and postfix
	    }
	    	  

	    if (quantity_ejb == null)
	    {
                quantity_ejb = new Double(0.0);
            }
            java.text.NumberFormat numberFormatter = java.text.NumberFormat.getNumberInstance(locale);
	    String resProdQuantity = numberFormatter.format(quantity_ejb);
	    	    

	    if (priceAdjustment_ejb == null)
	    {
                priceAdjustment_ejb = new Double(0.0);
            }
	    String resProdPriceAdjustment = numberFormatter.format(priceAdjustment_ejb);

	    if (abResponseProd == null)
	    {
		resProdName = "";
		price = "";
		resProdQuantity = "";
		resProdCurrency = "";
		resProdPriceAdjustment = "";
	    }

	    if (rfqNegotiationType.intValue() == 1)
	    {
%>	    
	    	productArrayFPP[<%= numOfFPP %>]=new product(
		    "<%=resProdId %>",
		    "<%=price %>",
		    "<%=resProdQuantity %>",
		    "<%=resProdCurrency %>",
		    "<%=UIUtil.toJavaScript(resProdUnitDesc) %>",
		    "<%=resProdCatentryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(resProdName)) %>",
		    "<%=rfqProdCatentryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(rfqProdName)) %>",
		    "<%=reqCategoryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(reqCategoryName)) %>",
		    "<%=rfqProdId %>",
	    	    "<%=rfqProdType %>",
	    	    "<%=resProdType %>",
	    	    "<%=resPartnum %>",    
	    	    "<%=resProdDescription %>",
	    	    "<%=resProdPriceAdjustment %>");
<%
	    	numOfFPP++ ;	    	        
	    }
	    
	    if (rfqNegotiationType.intValue() == 2)
	    {
%>	    
	    	productArrayPPP[<%= numOfPPP %>]=new product(
		    "<%=resProdId %>",
		    "<%=price %>",
		    "<%=resProdQuantity %>",
		    "<%=resProdCurrency %>",
		    "<%=UIUtil.toJavaScript(resProdUnitDesc) %>",
		    "<%=resProdCatentryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(resProdName)) %>",
		    "<%=rfqProdCatentryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(rfqProdName)) %>",
		    "<%=reqCategoryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(reqCategoryName)) %>",
		    "<%=rfqProdId %>",
	    	    "<%=rfqProdType %>",
	    	    "<%=resProdType %>",
	    	    "<%=resPartnum %>",    
	    	    "<%=resProdDescription %>",
	    	    "<%=resProdPriceAdjustment %>");
<%
	    	numOfPPP++ ;	    	        
	    }	    

	    if (rfqNegotiationType.intValue() == 3)
	    {
%>	    
	    	productArrayFPDK[<%= numOfFPDK %>]=new product(
		    "<%=resProdId %>",
		    "<%=price %>",
		    "<%=resProdQuantity %>",
		    "<%=resProdCurrency %>",
		    "<%=UIUtil.toJavaScript(resProdUnitDesc) %>",
		    "<%=resProdCatentryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(resProdName)) %>",
		    "<%=rfqProdCatentryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(rfqProdName)) %>",
		    "<%=reqCategoryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(reqCategoryName)) %>",
		    "<%=rfqProdId %>",
	    	    "<%=rfqProdType %>",
	    	    "<%=resProdType %>",
	    	    "<%=resPartnum %>",    
	    	    "<%=resProdDescription %>",
	    	    "<%=resProdPriceAdjustment %>");
<%
	    	numOfFPDK++ ;	    	        
	    }

	    if (rfqNegotiationType.intValue() == 4)
	    {
%>	    
	    	productArrayPPDK[<%= numOfPPDK %>]=new product(
		    "<%=resProdId %>",
		    "<%=price %>",
		    "<%=resProdQuantity %>",
		    "<%=resProdCurrency %>",
		    "<%=UIUtil.toJavaScript(resProdUnitDesc) %>",
		    "<%=resProdCatentryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(resProdName)) %>",
		    "<%=rfqProdCatentryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(rfqProdName)) %>",
		    "<%=reqCategoryId %>",
		    "<%=UIUtil.toHTML(UIUtil.toJavaScript(reqCategoryName)) %>",
		    "<%=rfqProdId %>",
	    	    "<%=rfqProdType %>",
	    	    "<%=resProdType %>",
	    	    "<%=resPartnum %>",    
	    	    "<%=resProdDescription %>",
	    	    "<%=resProdPriceAdjustment %>");
<%
	    	numOfPPDK++ ;
	    }	    
	}
%>
    }

    function getNewBCT() 
    {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfqProduct")) %>";
    }

    function printAction()
    {
    	window.print();
    }

    function goToProductFPP(Id)
    {
	top.saveData(productArrayFPP[Id],"anProduct");
   	var productId = productArrayFPP[Id].<%= RFQConstants.EC_OFFERING_PRODUCTID %>;
   	var url = "DialogView?XMLFile=rfq.resSummaryProduct&amp;ProductId="+productId;
   	top.setContent(getNewBCT(), url, true);
    }
    
    function goToProductPPP(Id)
    {
	top.saveData(productArrayPPP[Id],"anProduct");
   	var productId = productArrayPPP[Id].<%= RFQConstants.EC_OFFERING_PRODUCTID %>;
   	var url = "DialogView?XMLFile=rfq.resSummaryProduct&amp;ProductId="+productId;
   	top.setContent(getNewBCT(), url, true);
    }

    function savePanelData()
    {
	return true;
    }

    function validatePanel()
    {
	return true;
    }

    function getResId()
    {            
	return  "<%=UIUtil.toJavaScript((String)request.getParameter("resId"))%>";
    }

    var productArrayFPP = new Array();
    var productArrayPPP = new Array();
    var productArrayFPDK = new Array();
    var productArrayPPDK = new Array();
    initData();

</script>
</head>

<body class="content" >

<br /><h1><%= rfqNLS.get("prodcategoryinfo") %>: <i><%=reqCategoryName%></i></h1>

<form name="SummaryForm" action="">

<table>
    <tr>
	<td><%= rfqNLS.get("modifyresponsename") %>: <i><%=responseName%></i></td>
    </tr>
    
</table>
<br />

<%		
    if (numOfPPP > 0 ) 
    {  
%> 
	<!-- start Percentage Pricing on Products -->	
	<b><%= rfqNLS.get("rfqproductpercentagepriceinfo") %></b>
        <%= comm.startDlistTable((String)rfqNLS.get("rfqproductpercentagepriceinfo")) %>
    	<%= comm.startDlistRowHeading() %>    
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("requestproductname"),"none",false,"15%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestproducttype"),"none",false,"15%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("responseproductname"),"none",false,"15%" ) %>	
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepartnumber"),"none",false,"15%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponseproddescription"),"none",false,"15%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponseprodtype"),"none",false,"15%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepercentageadjustment"),"none",false,"10%" ) %>    
	
<%
	if (!endresult_to_contract) {   
%> 	    	
	 		<%= comm.addDlistColumnHeading((String)rfqNLS.get("responsequantity"),"none",false,"8%" ) %>
	    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("resresponseunit"),"none",false,"8%" ) %>	    	
<% } %>		
	
	<%= comm.endDlistRowHeading() %>
<script type="text/javascript">
    	var rowselect=1;
  	for (var i = 0 ;i < productArrayPPP.length; i++)
  	{   
      	    var reqName = productArrayPPP[i].<%= RFQConstants.EC_RFQ_OFFERING_NAME %>;
	    if (reqName == null || reqName =="" || reqName == undefined) {
		reqName ="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
	    }

 	    startDlistRow(rowselect);
	    addDlistColumn(reqName);
	    addDlistColumn(productArrayPPP[i].req_type);  			
	    addDlistColumn(productArrayPPP[i].<%= RFQConstants.EC_OFFERING_NAME %>,"javascript:goToProductPPP("+ i +")");		  	      
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

    if (numOfFPP > 0 ) 
    {  
%>
	<!-- Start Fixed Pricing on Products table -->
	<br />
	<b><%= rfqNLS.get("rfqproductfixedpriceinfo") %></b>    
    
    	<%= comm.startDlistTable((String)rfqNLS.get("rfqproductfixedpriceinfo")) %>    
    	<%= comm.startDlistRowHeading() %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("requestproductname"),"none",false,"10%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestproducttype"),"none",false,"10%" ) %>    
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("responseproductname"),"none",false,"10%" ) %>      
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepartnumber"),"none",false,"10%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponseproddescription"),"none",false,"10%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponseprodtype"),"none",false,"10%" ) %>   
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("responseprice"),"none",false,"10%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("currency"),"none",false,"10%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("responsequantity"),"none",false,"10%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("resresponseunit"),"none",false,"10%" ) %>
    	<%= comm.endDlistRowHeading() %>
<script type="text/javascript">
	var rowselect=1;
  	for (var i =0 ;i <productArrayFPP.length;i++) 
  	{  	        	
	    var reqName = productArrayFPP[i].<%= RFQConstants.EC_RFQ_OFFERING_NAME %>;
	    if (reqName == null || reqName =="" || reqName == undefined) {
		reqName ="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
	    }

 	    startDlistRow(rowselect);
	    addDlistColumn(reqName);
	    addDlistColumn(productArrayFPP[i].req_type);
	    addDlistColumn(productArrayFPP[i].<%= RFQConstants.EC_OFFERING_NAME %>,"javascript:goToProductFPP("+ i +")");    	    	
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

    if (numOfPPDK > 0 ) 
    {  
%>
	<!-- Start Percentage Pricing on Dynamic kits -->
	<br />
	<b><%= rfqNLS.get("rfqdynamickitpercentagepriceinfo") %></b>    
    
    	<%= comm.startDlistTable((String)rfqNLS.get("rfqdynamickitpercentagepriceinfo")) %>    
    	<%= comm.startDlistRowHeading() %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqdynamickitname"),"none",false,"20%" ) %>
 	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsedynamickitname"),"none",false,"20%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepartnumber"),"none",false,"20%" ) %>	
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsedynamickitdescription"),"none",false,"20%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepercentageadjustment"),"none",false,"20%" ) %>    
     	<%= comm.endDlistRowHeading() %>
<script type="text/javascript">
	var rowselect=1;
  	for (var i =0 ;i <productArrayPPDK.length;i++) 
  	{ 
  	    var reqName = productArrayPPDK[i].<%= RFQConstants.EC_RFQ_OFFERING_NAME %>;
	    if (reqName == null || reqName =="" || reqName == undefined) {
		reqName ="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
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

            addDlistColumn(productArrayPPDK[i].<%= RFQConstants.EC_OFFERING_NAME %>);
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

    if (numOfFPDK > 0 ) 
    {  
%>
	<!-- Start Fixed Pricing on Dynamic Kits -->
	<br />
	<b><%= rfqNLS.get("rfqdynamickitfixedpriceinfo") %></b>    
    
    	<%= comm.startDlistTable((String)rfqNLS.get("rfqdynamickitfixedpriceinfo")) %>    
    	<%= comm.startDlistRowHeading() %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqdynamickitname"),"none",false,"15%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsedynamickitname"),"none",false,"15%" ) %>      
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepartnumber"),"none",false,"10%" ) %>
	<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsedynamickitdescription"),"none",false,"20%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("responseprice"),"none",false,"10%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("currency"),"none",false,"10%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("responsequantity"),"none",false,"10%" ) %>
    	<%= comm.addDlistColumnHeading((String)rfqNLS.get("resresponseunit"),"none",false,"10%" ) %>
    	<%= comm.endDlistRowHeading() %>
<script type="text/javascript"> 
	var rowselect=1;
  	for (var i =0 ;i <productArrayFPDK.length;i++) 
  	{     	  	    	
	    var reqName = productArrayFPDK[i].<%= RFQConstants.EC_RFQ_OFFERING_NAME %>;
	    if (reqName == null || reqName =="" || reqName == undefined) {
		reqName ="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
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

	    addDlistColumn(productArrayFPDK[i].<%= RFQConstants.EC_OFFERING_NAME %>);
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
%> 

<script type="text/javascript">
    initializeState();
</script>
</form>

<br /> <br />

</body>

</html>
