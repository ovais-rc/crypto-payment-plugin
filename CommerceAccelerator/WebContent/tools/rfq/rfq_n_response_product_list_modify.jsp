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
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.beans.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.util.UIUtil" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>

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
    if (langId == null) 
    {
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
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",aLocale);      
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
    productObjList = parent.parent.get("<%= RFQConstants.EC_OFFERING_FIXPRICEPRODUCT %>");
    if (productObjList == undefined) 
    {
	productObjList = new Array();
<%
        String reqProdType = "";
        String resProdType = "";

        Integer[] negotiationTypes = new Integer[1];
        negotiationTypes[0] = new Integer (1);
	RFQResNewProd[] ResPros = RFQResProdHelper.getResAllProdsForNegotiationType(RequestId, ResponseId, langId, negotiationTypes);
	int i=0;
	for(; ResPros != null && i < ResPros.length; i++) 
   	{
            reqProdType = "";
            resProdType = "";
%>
	    var PC<%= i %> = new Array(), PA<%= i %> = new Array();	    
<%
   	    if (ResPros[i].getHasResponse() != RFQConstants.EC_OFFERING_HAS_RESPONSE_NO)
   	    {
	    	RFQResProdAttributes[] resAttrs=RFQResProdHelper.getResAllAttributesForProduct(ResPros[i].getProduct_id(), langId, RFQConstants.EC_ATTR_VALUEDELIM_VALUE);
	    	int m=0,n=0;
	    	for (int j=0;resAttrs != null && j<resAttrs.length;j++) 
	    	{
		    if (resAttrs[j].getType().equalsIgnoreCase(UTFConstants.EC_ATTRTYPE_FREEFORM)) 
	    	    {
%>
	    	        PC<%= i %>[<%= m++ %>] = new productComments(
		    	    "<%= resAttrs[j].getReqPAttrValueId()%>",
		    	    "<%= resAttrs[j].getMandatory()%>",
			    "<%= resAttrs[j].getChangeable()%>",
			    "<%= UIUtil.toJavaScript((String)resAttrs[j].getName())%>",
			    "<%= resAttrs[j].getPAttribute_id() %>",
			    "<%= resAttrs[j].getReq_tc_id()%>",
			    "<%= UIUtil.toJavaScript((String)resAttrs[j].getReq_value())%>",
			    "<%= resAttrs[j].getRes_tc_id()%>",
			    "<%= UIUtil.toJavaScript((String)resAttrs[j].getRes_value())%>");
<%
		    } 
		    else 
		    {
	    	    	String res_filename = null;
		    	String req_filename = null;
		    	if (resAttrs[j].getType().equalsIgnoreCase(UTFConstants.EC_ATTRTYPE_ATTACHMENT)) 
		    	{
		     	    AttachmentAccessBean attachment = new AttachmentAccessBean();
		     	    if (resAttrs[j].getReq_value().length() > 0 && resAttrs[j].getReq_value() != null)  
			    { 
		            	attachment.setInitKey_attachmentId((String)resAttrs[j].getReq_value());
			    	req_filename = attachment.getFilename();
	     		    } 
			    else 
			    {
	        	    	req_filename = "";
			    }
			    if (resAttrs[j].getRes_value().length() > 0 && resAttrs[j].getRes_value() != null) 
			    {
			    	AttachmentAccessBean attachment1 = new AttachmentAccessBean();
			    	attachment1.setInitKey_attachmentId((String)resAttrs[j].getRes_value());
			    	res_filename = attachment1.getFilename();
	   		    } 
			    else 
			    {
		            	res_filename = "";
		     	    }			     
 	  	    	} 
		    	else 
		    	{
	    		    req_filename ="";
			    res_filename="";
 		    	}
%>
    		    	PA<%= i %>[<%= n++ %>] = new ProductAttribute(
			    "<%= resAttrs[j].getResPAttrValueId()%>",
			    "<%= resAttrs[j].getReqPAttrValueId()%>",
			    "<%= resAttrs[j].getMandatory()%>",
			    "<%= resAttrs[j].getChangeable()%>",
			    "<%= resAttrs[j].getType()%>",
			    "",
			    "<%= resAttrs[j].getPAttribute_id()%>",
			    "<%= UIUtil.toJavaScript((String)resAttrs[j].getName())%>",
			    "<%= resAttrs[j].getReq_operator_id()%>",
			    "<%= resAttrs[j].getReq_operator_des()%>",
			    "<%= resAttrs[j].getReq_unit()%>",
			    "<%= resAttrs[j].getReq_unitDesc()%>",
			    "<%= UIUtil.toJavaScript((String)resAttrs[j].getReq_value())%>",
			    "<%= req_filename %>",
			    "<%= resAttrs[j].getOperator_id()%>",
			    "<%= resAttrs[j].getOperator_des()%>",
			    "<%= resAttrs[j].getUnit()%>",
			    "<%= resAttrs[j].getUnitDesc()%>",
			    "<%= UIUtil.toJavaScript((String)resAttrs[j].getRes_value())%>",
			    "<%= res_filename %>",
			    "<%= resAttrs[j].getRes_tc_id()%>","<%= resAttrs[j].getReq_tc_id()%>");
<% 
	 	    } 
	        }
            }
            else
            {
                RFQProductAttributes[] reqAttrs = null;
		Long prodId = ResPros[i].getReq_productId();
                
                int m = 0;               
      		reqAttrs = RFQProductHelper.getProductCommentsForProduct(prodId,langId); 
	    	for (int j=0; reqAttrs != null && j<reqAttrs.length; j++) 
	    	{
%>
	    	    PC<%= i %>[<%= m %>] = new productComments(
		        "<%= reqAttrs[j].getPAttrValueId() %>",
		        "<%= reqAttrs[j].getMandatory()%>",
			"<%= reqAttrs[j].getChangeable()%>",
		    	"<%= UIUtil.toJavaScript((String)reqAttrs[j].getName())%>",
		   	"<%= reqAttrs[j].getPattribute_id() %>",
			"<%= reqAttrs[j].getTc_id()%>",
			"<%= UIUtil.toJavaScript((String)reqAttrs[j].getValue())%>",
			"",
			"");
		    if (PC<%= i %>[<%= m %>].<%=RFQConstants.EC_ATTR_MANDATORY%> == 1) 
		    {
			PC<%= i %>[<%= m %>].<%= RFQConstants.EC_ATTR_RES_COMMENTS_VALUE %> = PC<%= i %>[<%= m %>].<%= RFQConstants.EC_ATTR_REQ_COMMENTS_VALUE %>;
			PC<%= i %>[<%= m %>].<%= RFQConstants.EC_ATTR_VALUE %> = PC<%= i %>[<%= m %>].<%= RFQConstants.EC_ATTR_REQ_COMMENTS_VALUE %>;
		    }				
<%
		    m++;    	
		}

		int n = 0;
      		reqAttrs = RFQProductHelper.getAllAttributesWithValuesForProduct(prodId, langId,";"); 
      		for (int j=0; reqAttrs != null && j<reqAttrs.length; j++) 
	    	{ 
	    	    if (reqAttrs[j].getAttribute_id() == null)
	    	    {
		    	String req_filename = null;
		    	if (reqAttrs[j].getAttrtype().equalsIgnoreCase(UTFConstants.EC_ATTRTYPE_ATTACHMENT)) 
		    	{
		     	    AttachmentAccessBean attachment = new AttachmentAccessBean();
		     	    if (reqAttrs[j].getValue().length() > 0 && reqAttrs[j].getValue() != null)  
			    { 
		                attachment.setInitKey_attachmentId((String)reqAttrs[j].getValue());
			        req_filename = attachment.getFilename();
	     		    } 
			    else 
			    {
	        	        req_filename = "";
			    }
 	  	        } 
		        else 
		        {
	    		    req_filename ="";
 		        }
 		    
		        String attr_operatorName = "";
 		        Integer attr_operatorId = reqAttrs[j].getOperator_id();
 		        if (attr_operatorId != null)  
        	        {
			    OperatorDescriptionDataBean oddbeanA = null;
			    oddbeanA = new OperatorDescriptionDataBean();
			    oddbeanA.setInitKey_operatorId(attr_operatorId.toString());
			    oddbeanA.setInitKey_languageId(langId.toString());
			    attr_operatorName = oddbeanA.getDescription();
        	        } 
         	    
         	        String attr_unitId	= reqAttrs[j].getUnit(); 
         	        String attr_unitDesc = "";   
        	        if (attr_unitId != null && !attr_unitId.equals("")) 
        	        {
            		    QuantityUnitDescriptionAccessBean quab = new QuantityUnitDescriptionAccessBean();
            		    quab.setInitKey_language_id(langId.toString());
            		    quab.setInitKey_quantityUnitId(attr_unitId);
            		    attr_unitDesc = quab.getDescription();
        	        } 
        	        else  
        	        {
          		    attr_unitDesc = "";
          		    attr_unitId = "";
        	        }
      		      
      		        String attr_type = UIUtil.toJavaScript(reqAttrs[j].getAttrtype());	    	  
%>
    		        PA<%= i %>[<%= n %>] = new ProductAttribute(
			    "",
			    "<%= reqAttrs[j].getPAttrValueId()%>",
			    "<%= reqAttrs[j].getMandatory()%>",
			    "<%= reqAttrs[j].getChangeable()%>",
			    "<%= attr_type%>",
			    "",
			    "<%= reqAttrs[j].getPattribute_id()%>",
			    "<%= UIUtil.toJavaScript((String)reqAttrs[j].getName())%>",
			    "<%= attr_operatorId %>",
			    "<%= attr_operatorName %>",
			    "<%= attr_unitId %>",
			    "<%= attr_unitDesc %>",
			    "<%= UIUtil.toJavaScript((String)reqAttrs[j].getValue())%>",
			    "<%= req_filename %>",
			    "",
			    "",
			    "",
			    "",
			    "",
			    "",
			    "",
			    "<%= reqAttrs[j].getTc_id()%>");
	  	        if (PA<%= i %>[<%= n %>].<%=RFQConstants.EC_ATTR_MANDATORY%> == 1) 
	  	        {	  	    	    
	  		    PA<%= i %>[<%= n %>].<%= RFQConstants.EC_ATTR_OPERATOR %> 	  = PA<%= i %>[<%= n %>].<%= RFQConstants.EC_ATTR_REQ_OPERATOR %>;	  
	  		    PA<%= i %>[<%= n %>].<%= RFQConstants.EC_ATTR_OPERATOR_DES %> = PA<%= i %>[<%= n %>].<%= RFQConstants.EC_ATTR_REQ_OPERATOR_DES %>;
			    PA<%= i %>[<%= n %>].<%= RFQConstants.EC_ATTR_UNIT%> 	  = PA<%= i %>[<%= n %>].<%= RFQConstants.EC_ATTR_REQ_UNIT %>;
			    PA<%= i %>[<%= n %>].<%= RFQConstants.EC_ATTR_UNIT_DESC %>	  = PA<%= i %>[<%= n %>].<%= RFQConstants.EC_ATTR_REQ_UNIT_DESC %>;
	  		    PA<%= i %>[<%= n %>].<%= RFQConstants.EC_ATTR_VALUE %> 	  = PA<%= i %>[<%= n %>].<%= RFQConstants.EC_ATTR_REQ_VALUE %>;
	  		    PA<%= i %>[<%= n %>].res_filename 				  = PA<%= i %>[<%= n %>].req_filename;
	  	        }
<% 	
		        n++;
		    }    	
	    	}
            }	        
%>
	    if (PC<%= i %>.length == 0) 
	    {
		PC<%= i %>=null;
	    }
	    if (PA<%= i %>.length == 0) 
	    { 
	        PA<%= i %>=null;
	    }
<%
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
	    	    "<%=ResPros[i].getReq_price() %>",
	    	    "<%=ResPros[i].getReq_quantity() %>",
	    	    "<%=ResPros[i].getReq_currency() %>",
	    	    "<%=ResPros[i].getReq_unit() %>",
	    	    "<%=ResPros[i].getReq_productChangeable() %>",
	    	    "<%=ResPros[i].getProduct_id() %>",
	    	    "<%=ResPros[i].getCatentry_id() %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getPartNumber()) %>",
		    "<%=UIUtil.toJavaScript(resProdType) %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getName()) %>",
	    	    "<%=UIUtil.toJavaScript((String)ResPros[i].getProductDesc()) %>",	
	    	    "<%=ResPros[i].getPrice() %>",
	    	    "<%=ResPros[i].getQuantity() %>",
	    	    "<%=ResPros[i].getCurrency() %>",
	    	    "<%=ResPros[i].getUnit() %>",
	    	    "<%=ResPros[i].getUnitDesc() %>",	    	
	    	    PC<%= i %>,
	    	    PA<%= i %>);
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
	    	    "<%=ResPros[i].getReq_price() %>",
	    	    "<%=ResPros[i].getReq_quantity() %>",
	    	    "<%=ResPros[i].getReq_currency() %>",
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
	    	    "<%=ResPros[i].getCurrency() %>",
	    	    "",
	    	    "",	    	
	    	    PC<%= i %>,
	    	    PA<%= i %>);
	    	productObjList[<%= i %>].<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_NO %>";
<%
	    }
	}
%>
        if (productObjList.length == 0) 
        { 
	    productObjList = null;
        }
        parent.parent.put("<%= RFQConstants.EC_OFFERING_FIXPRICEPRODUCT %>", productObjList);
    }  // end of if ..

    function productComments(reqPAttrValId, mandatory,changeable,Name,pattributeId,req_tc_id,req_comments,res_tc_id,res_comments) 
    {
	this.<%= RFQConstants.EC_PATTRVALUE_ID %>=reqPAttrValId;
	this.<%= RFQConstants.EC_ATTR_MANDATORY %>=mandatory;
	this.<%= RFQConstants.EC_ATTR_CHANGEABLE %>=changeable;
	this.<%= RFQConstants.EC_ATTR_NAME %> = Name;
	this.<%= RFQConstants.EC_ATTR_PATTRID %> = pattributeId;
	this.<%= RFQConstants.EC_ATTR_REQ_TCID %>=req_tc_id;
	this.<%= RFQConstants.EC_ATTR_REQ_COMMENTS_VALUE %> = req_comments;
	this.<%= RFQConstants.EC_ATTR_RES_TCID %>=res_tc_id;
	this.<%= RFQConstants.EC_ATTR_RES_COMMENTS_VALUE %>=res_comments;
	this.<%= RFQConstants.EC_ATTR_VALUE %>=res_comments;
	this.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_FALSE %>";
    }

    function ProductAttribute(resPAttrValId, reqPAttrValId, mandatory,changeable,type,Attribute_id,Pattribute_id,Name,req_Operator,req_op_des,req_Unit,req_UnitDesc,req_Value,req_filename,Operator,opdes,Unit,UnitDesc,Value,res_filename,res_tcid,req_tcid) 
    {
	this.<%= RFQConstants.EC_ATTR_RES_VALUE_ID %>=resPAttrValId;
	this.<%= RFQConstants.EC_PATTRVALUE_ID %>=reqPAttrValId;
	this.<%= RFQConstants.EC_ATTR_MANDATORY %>=mandatory;
	this.<%= RFQConstants.EC_ATTR_CHANGEABLE %>=changeable;
	this.<%= RFQConstants.EC_ATTR_TYPE %> = type;
	this.<%= RFQConstants.EC_ATTR_ATTRID %>=Attribute_id;
	this.<%= RFQConstants.EC_ATTR_PATTRID %>=Pattribute_id;
	this.<%= RFQConstants.EC_ATTR_NAME %> = Name;
	this.<%= RFQConstants.EC_ATTR_OPERATOR %> = Operator;
	this.<%= RFQConstants.EC_ATTR_OPERATOR_DES %> = opdes;
	this.<%= RFQConstants.EC_ATTR_UNIT %>=Unit;
	this.<%= RFQConstants.EC_ATTR_UNIT_DESC %>=UnitDesc;
	this.<%= RFQConstants.EC_ATTR_VALUE %>=Value;
	this.res_filename = res_filename;
	this.<%= RFQConstants.EC_ATTR_REQ_OPERATOR %> = req_Operator;
	this.<%= RFQConstants.EC_ATTR_REQ_OPERATOR_DES %> = req_op_des;
	this.<%= RFQConstants.EC_ATTR_REQ_UNIT %>=req_Unit;
	this.<%= RFQConstants.EC_ATTR_REQ_UNIT_DESC %>=req_UnitDesc;
	this.<%= RFQConstants.EC_ATTR_REQ_VALUE %>=req_Value;
	this.req_filename = req_filename;
	this.<%= RFQConstants.EC_ATTR_RES_TCID %>=res_tcid;
	this.<%= RFQConstants.EC_ATTR_REQ_TCID %>=req_tcid;
	this.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_FALSE %>";
    }
	
    function product(reqProductId,reqCatentryid,reqPartNumber,reqProdType,reqName,reqProdDesc,reqCategoryName,reqprice,reqquantity,reqCurrency,reqUnit,reqProdChangeable,productId,catentryid,partNumber,prodType,name,prodDesc,price,quantity,currency,unit,unitDesc,prodComment,prodAttribute) 
    {   
	this.<%= RFQConstants.EC_RFQ_OFFERING_PRODUCTID %>=reqProductId;
	if (reqCatentryid == null || reqCatentryid == "null") 
	{
	    reqCatentryid = "";
	}
	this.<%= RFQConstants.EC_RFQ_OFFERING_CATENTRYID %>=reqCatentryid;
	this.<%= RFQConstants.EC_RFQ_OFFERING_PARTNUMBER %>=reqPartNumber;
	this.<%= RFQConstants.EC_RFQ_OFFERING_PRODUCT_TYPE %> = reqProdType;
	this.<%= RFQConstants.EC_RFQ_OFFERING_NAME %>=reqName;
	this.<%= RFQConstants.EC_RFQ_OFFERING_PRODUCT_DESC %>=reqProdDesc;
	this.<%= RFQConstants.EC_RFQ_OFFERING_CATEGORYNAME %>=reqCategoryName;	
	this.<%= RFQConstants.EC_RFQ_OFFERING_PRICE %>=reqprice;
	this.<%= RFQConstants.EC_RFQ_OFFERING_QUANTITY %>=reqquantity;
	this.<%= RFQConstants.EC_RFQ_OFFERING_CURRENCY %> = reqCurrency;
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
	this.<%= RFQConstants.EC_OFFERING_PRICE %>=price;
	this.<%= RFQConstants.EC_OFFERING_QUANTITY %>=quantity;
	this.<%= RFQConstants.EC_OFFERING_CURRENCY %> = currency;
	this.<%= RFQConstants.EC_OFFERING_UNIT %> = unit;
	this.<%= RFQConstants.EC_OFFERING_UNIT_DESC %> = unitDesc;
	this.<%= RFQConstants.EC_ATTR_PRODUCT_COMMENTS %>=prodComment;
	this.<%= RFQConstants.EC_OFFERING_PRODATTRLIST %>=prodAttribute;
	this.<%= RFQConstants.EC_ATTR_VALUEDELIM %> = "<%= RFQConstants.EC_ATTR_VALUEDELIM_VALUE %>";
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
	var form = document.rfqProdListForm;
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
	parent.parent.put("<%= RFQConstants.EC_OFFERING_FIXPRICEPRODUCT %>", productObjList );
	return true;
    }
    
    function validatePanelData()  
    {
	return true;
    }
    
    function ChangePriceAndQuan()   
    {
	var index=getCheckedProducts()[0].split(',');
	var url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqresponseproductpriceqtmodify";
    	if ( productObjList[index[0]].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCT_CHANGEABLE%> == '<%=RFQConstants.EC_RFQ_PRODUCT_CHANGEABLE_YES%>') 
    	{
	    var rfqId = '<%= RequestId %>';
	    url = "/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseProductChangeablePriceQtRespondModify&amp;requestId=" + rfqId;
        }
	top.saveModel(parent.parent.model);
	top.saveData(productObjList,"allFixedPricingProducts");
	top.saveData(productObjList[index[0]],"<%= RFQConstants.EC_OFFERING_PRODITEM %>");
	top.setReturningPanel("rfqProductFixedPricing");
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
          	    productObjList[i].<%=RFQConstants.EC_OFFERING_PRICE%>= "";        	
        	    productObjList[i].product_res_price= "";            	          	      
	  	    productObjList[i].<%=RFQConstants.EC_OFFERING_QUANTITY%>="";
	  	    productObjList[i].product_res_quantity="";
	  	    productObjList[i].<%=RFQConstants.EC_OFFERING_CURRENCY%>= productObjList[i].<%=RFQConstants.EC_RFQ_OFFERING_CURRENCY%>;  
	  	    productObjList[i].<%=RFQConstants.EC_OFFERING_UNIT%>="";  
	  	    productObjList[i].<%= RFQConstants.EC_OFFERING_UNIT_DESC%>="";	
	  	    if (productObjList[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%> != null)
	  	    {	
	  	    	for (var k=0; k<productObjList[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>.length; k++) 
	  	    	{
		    	    if (productObjList[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[k].<%=RFQConstants.EC_ATTR_MANDATORY%>==1) 
		     	    {
				productObjList[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[k].<%=RFQConstants.EC_ATTR_RES_COMMENTS_VALUE%> = productObjList[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[k].<%= RFQConstants.EC_ATTR_REQ_COMMENTS_VALUE %>;
				productObjList[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[k].<%=RFQConstants.EC_ATTR_VALUE%> = productObjList[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[k].<%= RFQConstants.EC_ATTR_REQ_COMMENTS_VALUE %>;
		    	    } 
		    	    else 
		    	    {
				productObjList[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[k].<%=RFQConstants.EC_ATTR_RES_COMMENTS_VALUE%> = "";
				productObjList[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>[k].<%=RFQConstants.EC_ATTR_VALUE%> = "";
		    	    }	  	    	
	  	    	}
	  	    }
	  	    if (productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%> != null)
	  	    {
         		for (var k=0; k<productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length; k++) 
         		{ 	  	        
	  	    	    if (productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%=RFQConstants.EC_ATTR_MANDATORY%> == 0) 
	  	    	    {
	  			productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_OPERATOR %> = "";	  
				productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_OPERATOR_DES %> = "";
				productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_UNIT%>  = "";
	  			productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_UNIT_DESC %> = "";
	  			productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_VALUE %> = "";
	  			productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].res_filename = "";
	  	    	    } 
	  	    	    else 
	  	    	    {	
				productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_OPERATOR %> 	 = productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_REQ_OPERATOR %>;	  
	  		    	productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_OPERATOR_DES %> = productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_REQ_OPERATOR_DES %>;
			    	productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_UNIT%> 	 = productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_REQ_UNIT %>;
			    	productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_UNIT_DESC %>	 = productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_REQ_UNIT_DESC %>;
	  		    	productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_VALUE %> 	 = productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].<%= RFQConstants.EC_ATTR_REQ_VALUE %>;
	  		    	productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].res_filename 				 = productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>[k].req_filename;
	  	    	    }
	  	    	}      
  	  	    }
  	  	    parent.removeEntry(aList[j]);
      		    break;
		}
	    }
	}
	top.saveData(productObjList,"allFixedPricingProducts");
	top.saveModel(parent.parent.model);
	parent.document.forms[0].submit();
    }	
        
    function CommentsEntry() 
    {
	if(isButtonDisabled(parent.buttons.buttonForm.commentsButton)) {
	    return;
	}
	var index=getCheckedProducts()[0].split(',');
	var url = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=rfq.rfqresponseproductcommentsmodify&amp;cmd=RFQResponseProductCommentsModify"
	top.saveModel(parent.parent.model);
	top.saveData(productObjList[index[0]].<%= RFQConstants.EC_ATTR_PRODUCT_COMMENTS %>,"<%= RFQConstants.EC_ATTR_PRODUCT_COMMENTS %>");
	top.setReturningPanel("rfqProductFixedPricing");
	top.setContent(getNewBCT2(), url, true);
    }
    
    function getNewBCT2() 
    {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("resproductcomments")) %>";
    }
    
    function attributeEntry() 
    {
	if(isButtonDisabled(parent.buttons.buttonForm.rfqAttributesButton)) 
	{
	    return;
	}
	var index=getCheckedProducts()[0].split(',');
	top.saveModel(parent.parent.model);		
	top.saveData(productObjList[index[0]].<%= RFQConstants.EC_OFFERING_PRODATTRLIST %>,"<%= RFQConstants.EC_OFFERING_PRODATTRLIST %>");
	var url = "/webapp/wcs/tools/servlet/NewDynamicListView?ActionXMLFile=rfq.rfqresponseproductattributelistmodify&amp;cmd=RFQResponseProudctAttributeListModify"
	top.setReturningPanel("rfqProductFixedPricing");
	top.setContent(getNewBCT3(),url,true);
    }
    
    function getNewBCT3() 
    {
	return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_ProductAtt")) %>";
    }

    function myRefreshButtons()  
    {
	parent.setChecked();
	var aList=new Array();
	aList = parent.getChecked();
	if (aList.length == 0) {
		return;
	}
	var tmpArray=new Array();
	tmpArray=aList[0].split(',');
	var isOwnSpecs = false;
	var isOwnComments = false;
	var hasResponse = false;
	if (tmpArray[1]== 1) {
		isOwnSpecs = true;
	}
	if (tmpArray[2]== 1) {
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
	if (parent.buttons.buttonForm.rfqAttributesButton && !isOwnSpecs) {
	    parent.buttons.buttonForm.rfqAttributesButton.className='disabled';
	    parent.buttons.buttonForm.rfqAttributesButton.disabled=true;
	    parent.buttons.buttonForm.rfqAttributesButton.id='disabled';
	}
	if (parent.buttons.buttonForm.commentsButton && !isOwnComments) {
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
        for (var i=0; i<document.rfqProdListForm.elements.length; i++)
        {
            var e = document.rfqProdListForm.elements[i];
            if (e.name != 'select_deselect')
            {
                e.checked = document.rfqProdListForm.select_deselect.checked;
            }
        }
        myRefreshButtons();
    }

    function setSelectDeselectFalse()
    {
        document.rfqProdListForm.select_deselect.checked = false;
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

<script type="text/javascript">
<!--
//For IE
if (document.all) { onLoad(); }
//-->
</script>

<%= rfqNLS.get("instruction_Products_modify") %>

<form name="rfqProdListForm" action="">
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

<%= comm.startDlistTable((String)rfqNLS.get("rfqfixedpriceonproducts")) %>
<%= comm.startDlistRowHeading() %>
<%= comm.addDlistCheckHeading(true,"selectDeselectAll()") %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("requestproductname"),"null",false,"10%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestproducttype"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("resrequestprice"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("resrequestquantity"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqrequestunits"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("productcanbesubstituted"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("productsubstituted"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("responseproductname"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("responseprice"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("responsequantity"),"null",false,"9%",wrap ) %>
<%= comm.addDlistColumnHeading((String)rfqNLS.get("rfqresponseunits"),"null",false,"9%",wrap ) %>
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
 	    var OwnSpecs,OwnComments;
 	    
	    var reqProdName;		
	    var reqProdType;    
	    var reqPrice;
	    var reqQuantity;
	    var reqUnits;
	    var resProdName;
 	    var resPrice;
 	    var resQuantity;
	    var resUnits;		
 	    var prodChangeable;       
	    var prodSubstituted; 

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
	    reqPrice = numberToCurrency(productObjList[i].<%= RFQConstants.EC_REQ_OFFERING_PRICE %>,productObjList[i].<%= RFQConstants.EC_RFQ_OFFERING_CURRENCY %>,<%= langId %>);
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
		    
	    resProdName = productObjList[i].<%= RFQConstants.EC_OFFERING_NAME %>;
	    if (resProdName == null || resProdName =="" || resProdName == undefined) 
	    {
		resProdName ="<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>";
	    }
	    if (productObjList[i].<%= RFQConstants.EC_OFFERING_PRICE %> == null || 
	        productObjList[i].<%= RFQConstants.EC_OFFERING_PRICE %> == ""   || 
	        productObjList[i].<%= RFQConstants.EC_OFFERING_PRICE %> == undefined) 
	    {
		resPrice = "";
	    }	
	    else
	    {			
 	        resPrice = numberToCurrency(productObjList[i].<%= RFQConstants.EC_OFFERING_PRICE %>,productObjList[i].<%= RFQConstants.EC_OFFERING_CURRENCY %>,<%= langId %>);
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
            } else {
		prodSubstituted="<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
            }		

 	    checkvalue = i;
 	    if (productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%> != null && productObjList[i].<%=RFQConstants.EC_OFFERING_PRODATTRLIST%>.length > 0) 
 	    {
  	        checkvalue = checkvalue +"," + "1";
  	        OwnSpecs="<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";
	    } 
	    else 
	    {
        	checkvalue = checkvalue +"," + "0";
        	OwnSpecs="<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
	    }  

    	    if (productObjList[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%> != null && productObjList[i].<%=RFQConstants.EC_ATTR_PRODUCT_COMMENTS%>.length > 0) 
    	    {
  		checkvalue = checkvalue +"," + "1";
  		OwnComments="<%= UIUtil.toJavaScript(rfqNLS.get("yes")) %>";	
	    } 
	    else 
	    {
        	checkvalue = checkvalue +"," + "0";
        	OwnComments="<%= UIUtil.toJavaScript(rfqNLS.get("no")) %>";
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
	    addDlistColumn(ToHTML(reqProdType));
	    addDlistColumn(ToHTML(reqPrice));
	    addDlistColumn(ToHTML(reqQuantity));
	    addDlistColumn(ToHTML(reqUnits));
	    addDlistColumn(ToHTML(prodChangeable));
	    addDlistColumn(ToHTML(prodSubstituted));
	    addDlistColumn(ToHTML(resProdName));
	    addDlistColumn(ToHTML(resPrice));
	    addDlistColumn(ToHTML(resQuantity));
	    addDlistColumn(ToHTML(resUnits));
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
    } else 
    {
	parent.setResultssize(0);
    }
</script>

</body>
</html>
