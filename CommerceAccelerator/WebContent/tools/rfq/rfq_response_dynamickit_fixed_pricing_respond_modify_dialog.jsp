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
<%@ page import="com.ibm.commerce.exception.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>

<%@ include file="../common/common.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>

<%
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    Locale locale = null;
    Integer langId = null;	
    if( aCommandContext!= null ) 
    {
	locale = aCommandContext.getLocale();
	langId = aCommandContext.getLanguageId();
    }   	
    if (locale == null) 
    {
	locale = new Locale("en","US");
    }
    if (langId == null) 
    {
	langId = new Integer("-1");
    }
    
    //*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", locale);
    Hashtable priceNLS=(Hashtable)ResourceDirectory.lookup("catalog.PricingNLS", locale);
    
    JSPHelper jspHelper = new JSPHelper(request);
    String rfqId = jspHelper.getParameter("requestId");
    String prodCatentryId = jspHelper.getParameter("catentryId");
    String prodPartNumber = jspHelper.getParameter("partNumber");
    String prodName = jspHelper.getParameter("prodName");
    String prodType = jspHelper.getParameter("prodType");
    String prodDesc = jspHelper.getParameter("prodDesc");
%>

<jsp:useBean id="rfq" class="com.ibm.commerce.utf.beans.RFQDataBean" >
<jsp:setProperty property="*" name="rfq" />
</jsp:useBean>
<%
    boolean endresult_to_contract = false;
    if (rfqId != null && rfqId.length() > 0) {
        rfq.setRfqId(rfqId);
        com.ibm.commerce.beans.DataBeanManager.activate(rfq, request);
        String endresult = rfq.getEndResult();
        if (endresult.equals(com.ibm.commerce.utf.utils.UTFConstants.EC_UTF_ENDRESULT_CONTRACT.toString())) 
        {
            endresult_to_contract = true;
        }
    }
%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>  
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(locale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>

<script type="text/javascript">
    var prodCatentryId = '<%= prodCatentryId %>';
    var prodPartNumber = '<%= UIUtil.toJavaScript(prodPartNumber) %>';
    var prodName = '<%= UIUtil.toJavaScript(prodName) %>';    
    var prodType = '<%= UIUtil.toJavaScript(prodType) %>';
    var prodDesc = '<%= UIUtil.toJavaScript(prodDesc) %>';
    var endresult_to_contract = top.getData("endresult_to_contract");
    if (endresult_to_contract == undefined) 
    {
        endresult_to_contract = <%= endresult_to_contract %>;
        top.saveData(endresult_to_contract,"endresult_to_contract");
    }
    var productObj = new Object();
    productObj = top.getData("<%= RFQConstants.EC_OFFERING_PRODITEM %>", 1);
    var productObjList = top.getData("allFixedPricingDynamicKits", 1);    
    if (prodCatentryId == 'undefined' || prodCatentryId == 'null' || isEmpty(prodCatentryId)) 
    {
        prodCatentryId = productObj.<%=RFQConstants.EC_OFFERING_CATENTRYID%>;
    }
    if (prodPartNumber == 'undefined' || prodPartNumber == 'null' || isEmpty(prodPartNumber)) 
    {
        prodPartNumber = productObj.<%=RFQConstants.EC_OFFERING_PARTNUMBER%>;
    }
    if (prodName == 'undefined' || prodName == 'null' || isEmpty(prodName)) 
    {
        prodName = productObj.<%=RFQConstants.EC_OFFERING_NAME%>;
    }   
    if (prodType == 'undefined' || prodType == 'null' || isEmpty(prodType)) 
    {
        prodType = productObj.<%=RFQConstants.EC_OFFERING_PRODUCT_TYPE%>;
    }
    if (prodDesc == undefined || prodDesc == null || isEmpty(prodDesc)) 
    {
    	prodDesc = productObj.<%=RFQConstants.EC_OFFERING_PRODUCT_DESC%>;
    }
    var VPDResult;

    function savePanelData() 
    {
	VPDResult = validatePanelData0();
	if(!VPDResult) 
	{
	    return;
	}
	var resCatentryId = '<%= prodCatentryId %>';
	var resPartNumber = '<%= UIUtil.toJavaScript(prodPartNumber) %>';
        var resProdType = '<%= UIUtil.toJavaScript(prodType) %>';
	var resName = '<%= UIUtil.toJavaScript(prodName) %>';
	var resProdDesc = '<%= UIUtil.toJavaScript(prodDesc) %>';
	if (resCatentryId != 'null' && !isEmpty(resCatentryId)) 
	{
	    productObj.<%=RFQConstants.EC_OFFERING_CATENTRYID%> = resCatentryId;
	}
	if (resPartNumber != 'null' && resPartNumber != "") 
	{
	    productObj.<%= RFQConstants.EC_OFFERING_PARTNUMBER %> = resPartNumber;
	}
	if (resName != 'null' && resName != "") 
	{
	    productObj.<%= RFQConstants.EC_OFFERING_NAME %> = resName;
	}
        if (resProdType != 'null' && resProdType != "")
        {
            productObj.<%= RFQConstants.EC_OFFERING_PRODUCT_TYPE %> = resProdType;
        }
	if (resProdDesc != 'null' && resProdDesc != "") 
	{
	    productObj.<%= RFQConstants.EC_OFFERING_PRODUCT_DESC %> = resProdDesc;
	}
	productObj.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_TRUE %>";
	productObj.<%= RFQConstants.EC_OFFERING_PRICE %> = strToNumber(document.rfqDynamicKitFPForm.price.value,<%= langId %>);
	productObj.<%= RFQConstants.EC_OFFERING_QUANTITY %>=strToNumber( document.rfqDynamicKitFPForm.quantity.value,<%= langId %>);
	productObj.<%= RFQConstants.EC_OFFERING_UNIT %>= document.rfqDynamicKitFPForm.unit.options[document.rfqDynamicKitFPForm.unit.selectedIndex].value;
	productObj.<%= RFQConstants.EC_OFFERING_UNIT_DESC %>= document.rfqDynamicKitFPForm.unit.options[document.rfqDynamicKitFPForm.unit.selectedIndex].text;
	productObj.<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_YES %>";
    }
    
    function validatePanelData0() 
    {
	if (!isValidCurrency(document.rfqDynamicKitFPForm.price.value,productObj.<%= RFQConstants.EC_OFFERING_CURRENCY %>, <%= langId %>)) 
	{
	    alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidPrice")) %>");
	    document.rfqDynamicKitFPForm.price.focus();
	    return false;
	}
  	var cur2num = "";
	cur2num = parent.currencyToNumber(document.rfqDynamicKitFPForm.price.value, productObj.<%= RFQConstants.EC_OFFERING_CURRENCY %>, <%= langId %>);
    	cur2numstr = new String(cur2num);
    	if (cur2numstr.length > 14) 
    	{
   	    document.rfqDynamicKitFPForm.price.focus();
      	    parent.alertDialog("<%=UIUtil.toJavaScript(priceNLS.get("priceTooLongMessage"))%>");
	    return false;
    	}
	if (!isValidNumber(document.rfqDynamicKitFPForm.quantity.value,<%= langId %>, false)) 
	{
	    alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidNumber")) %>");
	    document.rfqDynamicKitFPForm.quantity.focus();
	    return false;
	}
    	var resCatentryId = '<%= prodCatentryId %>';
    	if (resCatentryId != 'null' && !isEmpty(resCatentryId) && endresult_to_contract == true) 
    	{
	    for (var i = 0;i < productObjList.length;i++) 
	    {
		if (productObjList[i].<%=RFQConstants.EC_OFFERING_PRODUCTID%> != productObj.<%=RFQConstants.EC_OFFERING_PRODUCTID%> && productObjList[i].<%=RFQConstants.EC_OFFERING_CATENTRYID%> == resCatentryId) 
		{  
		    alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("RFQ_DUPLICATE_CATENTRY3"))%>");
		    return false;
        	}
            }
        }
        return true;
    }  
    
    function validatePanelData()
    {
        return VPDResult;
    }

    function retrievePanelData() 
    {
        var price, quantity;
        price = productObj.<%= RFQConstants.EC_OFFERING_PRICE %>;
        quantity = productObj.<%= RFQConstants.EC_OFFERING_QUANTITY %>;
    	if (price != null && price != "" && price != undefined) 
    	{
    	    document.rfqDynamicKitFPForm.price.value = numberToCurrency(price, productObj.<%= RFQConstants.EC_OFFERING_CURRENCY %>, <%= langId %>);
        }
       	if (quantity != null && quantity != "" && quantity != undefined) 
       	{
       	    document.rfqDynamicKitFPForm.quantity.value = numberToStr(quantity, <%= langId %>, null);
        }
    }
                 		
    function initializeState() 
    {
    	parent.setContentFrameLoaded(true);
    }

    function getFindBCT()
    {
        return "<%= UIUtil.toJavaScript(rfqNLS.get("rfq_bct_find_product")) %>";
    }

    function findCatalogEntries()
    {
        var redirectURL = "/webapp/wcs/tools/servlet/NewDynamicListView" ;
        var redirectXML = "rfq.rfqResponseCatentrySearchResult";
        var redirectCmd = "RFQResponseCatentrySearchResult";

        url="/webapp/wcs/tools/servlet/DialogView?XMLFile=rfq.rfqResponseCatentrySearch&amp;catentry_id="+ prodCatentryId + "&amp;redirectURL=" + redirectURL + "&amp;redirectCmd=" + redirectCmd + "&amp;redirectXML=" + redirectXML;
        top.setContent(getFindBCT(), url, true);
    } 
</script>
</head>

<body class="content" >
<h1><%= rfqNLS.get("rfqRespondtodynamickitfixedpricing") %></h1>
<%= rfqNLS.get("instruction_PDresponse_dk_fp") %>

<form name="rfqDynamicKitFPForm" action="">
<table border="0" width="100%">
    <tr>
        <td><b><%= rfqNLS.get("resrequest") %></b></td>
    </tr>
    <tr>
        <td><%= rfqNLS.get("product_partno") %>:
<script type="text/javascript">
   	    document.write(ToHTML(productObj.<%= RFQConstants.EC_RFQ_OFFERING_PARTNUMBER %>));
</script>
    	</td>
    </tr>
    <tr>
    	<td><%= rfqNLS.get("product_name") %>: 
<script type="text/javascript">
    if (productObj.<%= RFQConstants.EC_RFQ_OFFERING_NAME %> == "" || productObj.<%= RFQConstants.EC_RFQ_OFFERING_NAME %> == null) 
    {
      	document.write("<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>");
    } 
    else 
    {
    	document.write(ToHTML(productObj.<%= RFQConstants.EC_RFQ_OFFERING_NAME %>));
    }
</script>
    	</td>
    </tr>
    
    <tr>
    	<td><%= rfqNLS.get("Description") %>:
<script type="text/javascript">		
            document.write(ToHTML(productObj.<%= RFQConstants.EC_RFQ_OFFERING_PRODUCT_DESC %>));
</script>
    	</td>
    </tr>     
       
    <tr>
        <td><%= rfqNLS.get("rfqproducttype") %>:
<script type="text/javascript">
            document.write(ToHTML(productObj.<%= RFQConstants.EC_RFQ_OFFERING_PRODUCT_TYPE %>));
</script>
        </td>
    </tr>

    <tr>
    	<td><%= rfqNLS.get("quantity") %>:
<script type="text/javascript">
    	    document.write(numberToStr(productObj.<%= RFQConstants.EC_REQ_OFFERING_QUANTITY %>,<%= langId %>,null));
    	    document.write("<i>  ");
    	    document.write(productObj.<%= RFQConstants.EC_RFQ_OFFERING_UNIT %>);
    	    document.write("</i>");
</script>
    	</td>
    </tr>
    <tr>
 	<td><%= rfqNLS.get("price") %>:
<script type="text/javascript">
    	    document.write(numberToCurrency(productObj.<%= RFQConstants.EC_REQ_OFFERING_PRICE %>,productObj.<%= RFQConstants.EC_RFQ_OFFERING_CURRENCY %>,<%= langId %>));
</script>
  	</td>
    </tr>
	<tr>
 	    <td><%= rfqNLS.get("currency") %>:
<script type="text/javascript">
    		document.write("<i>");
    		document.write(productObj.<%= RFQConstants.EC_RFQ_OFFERING_CURRENCY %>);
    		document.write("</i>");
</script>
 	    </td>
    </tr>    
    <tr>
  	<td><br /><b><%= rfqNLS.get("resresponse") %></b></td>
    </tr>
    <tr>
        <td><%= rfqNLS.get("product_partno") %>:
<script type="text/javascript">
    		document.write(ToHTML(prodPartNumber));
</script>
        </td>
    </tr>
    <tr>
        <td><%= rfqNLS.get("product_name") %>:
<script type="text/javascript">
  	if (prodName == null || prodName == "") {
      	    document.write("<%= UIUtil.toJavaScript(rfqNLS.get("RFQModifyDisplay_MadeToOrder")) %>");
    	} 
    	else 
    	{
    	    document.write(ToHTML(prodName));
    	}
</script>
        </td>
    </tr>    
    
    <tr>
    	<td><%= rfqNLS.get("Description") %>:
<script type="text/javascript">
            document.write(ToHTML(prodDesc));
</script>
    	</td>
    </tr>     

    <tr>
        <td><%= rfqNLS.get("rfqproducttype") %>:
<script type="text/javascript">
            document.write(ToHTML(prodType));
</script>
        </td>
    </tr>
    
    <tr><td>&nbsp;</td></tr> 
     
    <tr>
  	<td>
	    <label for="quantity"><%= rfqNLS.get("quantity") %>
	    <br />
  	    <input type="text" name="quantity" id="quantity" size="20" maxlength="200" />
	    </label>
	</td>
    </tr>
    <tr>
    	<td>
	    <label for="units"><%= rfqNLS.get("rfqunits") %>
	    <br />	  
	    <script type="text/javascript">
	    document.write('<select name="unit" id="units">');
		document.write('<option value=""><%= UIUtil.toJavaScript(rfqNLS.get("none")) %></option>'); 	
<% 
    QuantityUnitAccessBean QAB = new QuantityUnitAccessBean();
    QuantityUnitDescriptionAccessBean qtUnitDesAB = new QuantityUnitDescriptionAccessBean();
    Hashtable h = new Hashtable();
    Enumeration enumDesc = qtUnitDesAB.findByLanguage(langId);
    while (enumDesc.hasMoreElements()) 
    {
	qtUnitDesAB=(QuantityUnitDescriptionAccessBean)enumDesc.nextElement();
	h.put(qtUnitDesAB.getQuantityUnitId(), qtUnitDesAB.getDescription());
    }
    String qtUnit, qtUnitDesc;
    Enumeration enum1 = QAB.findAll();
    while (enum1.hasMoreElements()) 
    {
	QAB= (QuantityUnitAccessBean)enum1.nextElement();
	qtUnit = QAB.getQuantityUnitId();					
	qtUnitDesc= (String)h.get(qtUnit);
	if (qtUnitDesc == null) 
	{
	    qtUnitDesc = qtUnit;
       	}
%>	
	if (productObj.<%= RFQConstants.EC_OFFERING_UNIT %> == "<%= UIUtil.toJavaScript(qtUnit) %>" ) 
	{
	    document.write("<option value=\"<%= UIUtil.toJavaScript(qtUnit) %>\" selected=\"selected\" >");
	    document.write("<%= UIUtil.toJavaScript(qtUnitDesc) %>");
	    document.write("</option>");
	} 
	else 
	{
	    document.write("<option value=\"<%= UIUtil.toJavaScript(qtUnit) %>\" >");
	    document.write("<%= UIUtil.toJavaScript(qtUnitDesc) %>");
	    document.write("</option>");
	}	
<%
    }
%>
	    document.write('</select>');
	    </script>   
	    </label>
	</td>
    </tr>
    <tr>
        <td>
            <label for="price">
  	    	<%= rfqNLS.get("price") %><br />
    	    <input type="text" name="price" id="price" size="20" />
<script type="text/javascript">
    		document.write(productObj.<%= RFQConstants.EC_OFFERING_CURRENCY %>);
</script>			
            </label>
      	</td>
    </tr>
</table>
</form>

<script type="text/javascript">
    initializeState();
    retrievePanelData();
</script>

</body>
</html>
