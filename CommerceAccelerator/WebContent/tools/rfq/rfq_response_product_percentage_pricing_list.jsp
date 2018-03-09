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
    var isFirstTimeLogonPanel4;
    isFirstTimeLogonPanel4=top.getData("isFirstTimeLogonPanel4");
    if (isFirstTimeLogonPanel4 != "0") 
    {
    	isFirstTimeLogonPanel4="1";  //"1" means first time logon Panel4.
    	top.saveData("0","isFirstTimeLogonPanel4");
    }    
    var ProductsArray = new Array();
    
    function setPD() 
    {
    	if (isFirstTimeLogonPanel4 == "0") 
    	{   //NOT first time log on panel4
    	    ProductsArray = top.getData("allPercentagePricingProducts");
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
	    negotiationTypes[0] = new Integer (2);
            rfqProdList.setRFQId(rfqId);
    	    rfqProdList.setNegotiationTypes(negotiationTypes);
	    com.ibm.commerce.beans.DataBeanManager.activate(rfqProdList, request);
	    RFQProdDataBean[] rfqProds = rfqProdList.getRFQProds();
	    
	    String catentryid_in_prod = null;
	    String prodChangeable = null;
	    String prodId         = null;
	    String prodName       = null;	    
	    String prodCategoryId = null;
	    String prodPartNumber = null;
	    String prodType    = null;	    
	    String prodDesc    = null;
	    String prodPriceAdjustment = null;  
	    String priceAdjustment_ds = null;  	    
	    
	    String prodUnitId     = null;
    	    String prodUnit       = null;    	
    	    String prodQuantity   = null;    	
    	    String quantity_ds	  = null;
    	        
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
		
	  	ProductsArray[<%=i%>].product_req_name="<%=prodName%>";
	  	ProductsArray[<%=i%>].product_req_type="<%=prodType%>";
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
	  	ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>=new Array();  
  	  	ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>=new Array(); 
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
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>] = new Object;
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_PATTRVALUE_ID%> = "<%=pAttrValId %>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_PATTRID%> = "<%=com_id%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_NAME%> = "<%=com_name%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_DESCRIPTION%> = "<%=com_desc%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_VALUE%> = "<%=com_value%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].product_req_comments= "<%=com_value%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_MANDATORY%> = "<%=com_mandatory%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_CHANGEABLE%> = "<%=com_changeable%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_REQUEST_TC_ID%> = "<%=com_tc_id%>";
		    
		    if (ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_MANDATORY%>==1) 
		    {
			ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_VALUE%> = "<%=com_value%>";
		    } 
		    else 
		    {
			ProductsArray[<%=i%>].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[<%=j%>].<%=RFQConstants.EC_ATTR_VALUE%> = "";
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
	  	    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>] = new Object;
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_PATTRVALUE_ID%> = "<%=pAttrValId_PA %>";
	  	    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_PATTRID%> ="<%=attr_id%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_NAME%> ="<%=attr_name%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_DESCRIPTION%> ="<%=attr_desc%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_value = "<%=attr_value%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_filename = "<%= attr_filename %>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_operatorId = "<%=attr_operatorId%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_operator = "<%=attr_operatorName%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUE%> = "";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUEDELIM%> = "<%=RFQConstants.EC_ATTR_VALUEDELIM_VALUE%>";
	  	    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_unitId = "<%=attr_unitId%>";
	  	    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_unit = "<%=attr_unitDesc%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].req_userDefined = "<%=attr_userdefined%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_UNIT%> = "";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_MANDATORY%> = "<%=attr_mandatory%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_CHANGEABLE%> = "<%=attr_changeable%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_REQUEST_TC_ID%> = "<%=attr_tc_id%>";
		    ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_TYPE%> = "<%= attr_type%>";
	  
	  	    if (ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_MANDATORY%> == 0)
		    {
	  		ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUE%> = "";	  
			ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].res_filename = "";
			ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_UNIT%> = "";
	  		ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_OPERATOR%> = "";
	  		ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].operatorName = "";
	  		ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].UnitDsc = "";
	  	    } 
	  	    else 
	  	    {
	  		ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_VALUE%> = "<%=attr_value%>";	  
	  		ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].res_filename = "<%= attr_filename %>";
			ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_UNIT%> = "<%=attr_unitId%>";
	  		ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].<%=RFQConstants.EC_ATTR_OPERATOR%> = "<%=attr_operatorId%>";
	  		ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].operatorName = "<%=attr_operatorName%>";
	  		ProductsArray[<%=i%>].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[<%=k%>].UnitDsc = "<%=attr_unitDesc%>";
	  	    }
<%
	  	}	  		
  	    }	
%>
   	    top.saveData(ProductsArray, "allPercentagePricingProducts");
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
	
	var isOwnSpecs = false;
	var isOwnComments = false;
	var hasResponse = false;
	if (tmpArray[1]== 1) 
	{
	    isOwnSpecs = true;
	}    
	if (tmpArray[2]== 1) 
	{
	    isOwnComments = true;
	}
	if (tmpArray[3] == 1)
        {
            hasResponse = true;
        }
        else
        {
            isOwnSpecs = false;
            isOwnComments = false;
        }
	if (parent.buttons.buttonForm.rfqAttributesButton && !isOwnSpecs) 
	{
	    parent.buttons.buttonForm.rfqAttributesButton.className='disabled';
	    parent.buttons.buttonForm.rfqAttributesButton.disabled=true;
	    parent.buttons.buttonForm.rfqAttributesButton.id='disabled';
	}
	if (parent.buttons.buttonForm.commentsButton && !isOwnComments) 
	{
	    parent.buttons.buttonForm.commentsButton.className='disabled';
	    parent.buttons.buttonForm.commentsButton.disabled=true;
	    parent.buttons.buttonForm.commentsButton.id='disabled';
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
        for (var i=0; i<document.rfqProductPPListForm.elements.length; i++)
        {
            var e = document.rfqProductPPListForm.elements[i];
            if (e.name != 'select_deselect')
            {
                e.checked = document.rfqProductPPListForm.select_deselect.checked;
            }
        }
        myRefreshButtons();
    }

    function setSelectDeselectFalse()
    {
        document.rfqProductPPListForm.select_deselect.checked = false;
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
    	parent.parent.put("<%= RFQConstants.EC_OFFERING_PERCENTPRICEPRODUCT %>", ProductsArray ); 	    	    	
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
    	top.saveData(anProduct, "anProduct");
    	top.saveData(ProductsArray, "allPercentagePricingProducts");
    	top.saveData("<%= endresult_to_contract %>", "endresult_to_contract");
    	top.saveModel(parent.parent.model);
    	
    }
    
    function ResponseEntry() 
    {
    	var anProduct = new Object;
    	anProduct = getAnProduct();
    	top.saveData(anProduct,"anProduct");
    	top.saveData(ProductsArray,"allPercentagePricingProducts");
    	top.saveData("<%= endresult_to_contract %>", "endresult_to_contract");
    	top.saveModel(parent.parent.model);
    	
    	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseProductPercentagePricingRespond";
	if (anProduct.product_req_changeable == '<%=RFQConstants.EC_RFQ_PRODUCT_CHANGEABLE_YES%>') 
	{
	    var rfqId = '<%= jspHelper.getParameter("requestId")%>';
	    url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseProductChangeablePercentagePricingRespond&amp;requestId=" + rfqId;
	}
	    	
    	if (top.setReturningPanel) 
    	{
    	    top.setReturningPanel("rfqProductPercentagePricing");
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
	  	        ProductsArray[i].<%=RFQConstants.EC_OFFERING_CURRENCY%>= ProductsArray[i].<%=RFQConstants.EC_RFQ_OFFERING_CURRENCY%>;  
	  	        ProductsArray[i].<%=RFQConstants.EC_OFFERING_UNIT%>="";  
	  	        ProductsArray[i].UnitDsc="";
<%
	            }
%>	  	    	
	  	    if (ProductsArray[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%> != null)
	  	    {	
	  	    	for (var k=0; k<ProductsArray[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>.length; k++) 
	  	    	{
		    	    if (ProductsArray[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[k].<%=RFQConstants.EC_ATTR_MANDATORY%>==1) 
		     	    {
				ProductsArray[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[k].<%=RFQConstants.EC_ATTR_VALUE%> = ProductsArray[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[k].product_req_comments;
		    	    } 
		    	    else 
		    	    {
				ProductsArray[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[k].<%=RFQConstants.EC_ATTR_VALUE%> = "";
		    	    }	  	    	
	  	    	}
	  	    }
	  	    if (ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%> != null)
	  	    {
         		for (var k=0; k<ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length; k++) 
         		{ 	
                            if (ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].req_userDefined == "Y")
                            {  	        
	  	    	        if (ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%=RFQConstants.EC_ATTR_MANDATORY%> == 0) 
	  	    	    	{
	  			    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%=RFQConstants.EC_ATTR_VALUE%> = "";	  
				    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].res_filename = "";
				    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%=RFQConstants.EC_ATTR_UNIT%> = "";
	  			    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%=RFQConstants.EC_ATTR_OPERATOR%> = "";
	  			    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].operatorName = "";
	  			    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].UnitDsc = "";
	  	    	    	} 
	  	    	    	else 
	  	    	    	{	  	    	    
	  			    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%=RFQConstants.EC_ATTR_VALUE%> = ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].req_value;	  
	  			    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].res_filename = ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].req_filename;
				    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%=RFQConstants.EC_ATTR_UNIT%> = ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].req_operatorId;
	  			    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%=RFQConstants.EC_ATTR_OPERATOR%> = ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].req_unitId;
	  			    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].operatorName = ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].req_operator;
	  			    ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].UnitDsc = ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].req_unit;
	  	    	        }
	  	    	    }
	  	    	}      
  	  	    }
  	  	    parent.removeEntry(aList[j]);
      		    break;
		}
	    }
	}
	top.saveData(ProductsArray,"allPercentagePricingProducts");
	top.saveData("<%= endresult_to_contract %>", "endresult_to_contract");
	top.saveModel(parent.parent.model);
	parent.document.forms[0].submit();
    }	
         
    function CommentsEntry() 
    {
    	if(isButtonDisabled(parent.buttons.buttonForm.commentsButton)) 
    	{ 
    	    return;
    	} 
    	saveData();
    	
    	var url = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=rfq.rfqresponseproductcomments&amp;cmd=RFQResponseProductCommentsList";
    	if (top.setReturningPanel) 
    	{
    	    top.setReturningPanel("rfqProductPercentagePricing");
    	} 	
    	if (top.setContent) 
    	{
    	    top.setContent(getNewBCT2(), url, true);
    	} 
    	else 
    	{
    	    parent.parent.location.replace(url);
    	} 
    }
    
    function getNewBCT2() 
    {
    	return "<%= UIUtil.toJavaScript(rfqNLS.get("resproductcomments")) %>";
    }
    
    function newCatEntry() 
    {
    	if (isButtonDisabled(parent.buttons.buttonForm.rfqAttributesButton)) 
    	{
    	    return;
    	}
    	saveData();
    	var url = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=rfq.rfqresponseproductattributelist&amp;cmd=RFQResponseProudctAttributeList";
    	if (top.setReturningPanel) 
    	{
    	    top.setReturningPanel("rfqProductPercentagePricing");
    	}	
    	if (top.setContent) 
    	{
    	    top.setContent(getNewBCT3(), url, true);
    	} 
    	else 
    	{
    	    parent.parent.location.replace(url);
    	} 
    }
    
    function getNewBCT3() 
    {
    	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_ProductAtt")) %>";
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

<%= rfqNLS.get("instruction_Products_PercentagePrice") %>

<form name="rfqProductPPListForm" method="get" action="">

<%= comm.startDlistTable((String)rfqNLS.get("rfqpercentagepricingonproducts")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"selectDeselectAll()") %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("requestproductname"),"null",false,"15%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestproducttype"),"null",false,"13%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestpriceadjustment"),"null",false,"15%",wrap ) %>
<%
    if (!endresult_to_contract) 
    {   
%>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("resrequestquantity"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestunits"),"null",false,"9%",wrap ) %>
<% 
    } 
%>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("productcanbesubstituted"),"null",false,"14%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("productsubstituted"),"null",false,"13%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("responseproductname"),"null",false,"15%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponsepriceadjustment"),"null",false,"15%",wrap ) %>
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

	if (ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%> != null && ProductsArray[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length > 0) 
	{
	    checkvalue = checkvalue +"," + "1";
	} 
	else 
	{
            checkvalue = checkvalue +"," + "0";
	}
	
  	if (ProductsArray[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%> != null && ProductsArray[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>.length > 0) 
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
	addDlistColumn(ToHTML(ProductsArray[i].product_req_type));
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
            addDlistColumn(ProductsArray[i].product_req_quantity);
            addDlistColumn(ProductsArray[i].product_req_unit);
<% 
 	}
%>
	addDlistColumn(ToHTML(prodChangeable));
	addDlistColumn(ToHTML(prodSubstituted));
	addDlistColumn(ToHTML(ProductsArray[i].product_name));    	
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
