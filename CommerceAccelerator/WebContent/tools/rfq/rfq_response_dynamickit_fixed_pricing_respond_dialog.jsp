<!-- 
========================================================================
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* WebSphere Commerce
//*
//* (c) Copyright IBM Corp. 2000, 2002, 2003, 2008
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
========================================================================
--> 
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.price.utils.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.server.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>

<%@ include file="../common/common.jsp" %>

<%
    //*** GET LOCALE FROM COMANDCONTEXT ***//
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");    
    Locale locale = null;
    Integer languageId = null; 
    String lang = null;
    String storeId = null;
    if ( aCommandContext!= null ) 
    {
   	locale = aCommandContext.getLocale();
   	languageId = aCommandContext.getLanguageId();	
    }
    if (locale == null) 
    {
	locale = new Locale("en","US");
    }
    if (languageId == null) 
    {
	languageId = new Integer(-1);
    }
    lang = languageId.toString();
    storeId = aCommandContext.getStoreId().toString();
    
    //*** GET THE RESOURCE BUNDLE BASED ON LOCALE ***//
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS",locale);
    Hashtable priceNLS=(Hashtable)ResourceDirectory.lookup("catalog.PricingNLS", locale);		
    StoreAccessBean storeAB = com.ibm.commerce.registry.StoreRegistry.singleton().find(new Integer(storeId));
    
    //*** GET CURRENCY ***//	     
    CurrencyManager cm = CurrencyManager.getInstance();
    String defaultCurrency = cm.getDefaultCurrency(storeAB, languageId);    
    
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
    var anProduct = new Object();
    anProduct = top.getData("anProduct", 1);
    var allProducts = new Array();
    allProducts = top.getData("allFixedPricingDynamicKits", 1);
    if (prodCatentryId == undefined || prodCatentryId == null || isEmpty(prodCatentryId)) 
    {
	prodCatentryId = anProduct.<%=RFQConstants.EC_OFFERING_CATENTRYID%>;
    }
    if (prodPartNumber == undefined || prodPartNumber == null || isEmpty(prodPartNumber)) 
    {
    	prodPartNumber = anProduct.product_partnumber;
    }
    if (prodName == undefined || prodName == null || isEmpty(prodName)) 
    {
    	prodName = anProduct.product_name;
    }
    if (prodType == undefined || prodType == null || isEmpty(prodType)) 
    {
    	prodType = anProduct.product_type;
    }
    if (prodDesc == undefined || prodDesc == null || isEmpty(prodDesc)) 
    {
    	prodDesc = anProduct.product_description;
    }

    var VPDResult;

    function savePanelData() 
    {
	VPDResult = validatePanelData0();
	if (!VPDResult) 
	{
	    return;
	}
	var form = document.rfqDynamicKitFPForm;
	var unitInfo = form.unit[form.unit.selectedIndex].value.split(",");
	var resCatentryId = '<%= prodCatentryId %>';
	if (resCatentryId != null && !isEmpty(resCatentryId)) 
	{
	    anProduct.<%=RFQConstants.EC_OFFERING_CATENTRYID%> = resCatentryId;
	}
	var resPartNumber = '<%= UIUtil.toJavaScript(prodPartNumber) %>';
	if (resPartNumber != null && !isEmpty(resPartNumber)) 
	{
	    anProduct.product_partnumber = resPartNumber;
	}
        var resProdType = '<%= UIUtil.toJavaScript(prodType) %>';
        if (resProdType != null && !isEmpty(resProdType))
        {
            anProduct.product_type = resProdType;
        }
        var resProdDesc = '<%= UIUtil.toJavaScript(prodDesc) %>';
        if (resProdDesc != null && !isEmpty(resProdDesc)) {
            anProduct.product_description = resProdDesc;
        }
	var resName = '<%= UIUtil.toJavaScript(prodName) %>';
	if (resName != null && !isEmpty(resName)) {
	    anProduct.product_name = resName;
	} 
	if (unitInfo[0] != undefined && unitInfo[0]!=null) 
	{
	    anProduct.<%=RFQConstants.EC_OFFERING_UNIT%> = unitInfo[0];
	}
	if (unitInfo[1] != undefined && unitInfo[1]!=null) 
	{
	    anProduct.UnitDsc = unitInfo[1];
	}
	anProduct.<%=RFQConstants.EC_OFFERING_QUANTITY%> = parent.strToNumber(form.quantity.value,"<%=lang%>");
	anProduct.product_res_quantity = form.quantity.value;
	anProduct.<%=RFQConstants.EC_OFFERING_PRICE%> = parent.currencyToNumber(form.price.value, form.CurrencyType.value, "<%=lang%>");
	anProduct.product_res_price=form.price.value;
	anProduct.<%=RFQConstants.EC_OFFERING_CURRENCY%> = form.CurrencyType.value;
	anProduct.<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_YES %>";
	
	for(var i = 0;i < allProducts.length;i++) 
	{
	    if (allProducts[i].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%> == anProduct.<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%>) 
	    {
		allProducts[i].<%=RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT%> = anProduct.<%=RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT%>;
		allProducts[i].<%=RFQConstants.EC_OFFERING_PRICE%> = anProduct.<%=RFQConstants.EC_OFFERING_PRICE%>;
		allProducts[i].product_res_price = anProduct.product_res_price;
		allProducts[i].<%=RFQConstants.EC_OFFERING_UNIT%> = anProduct.<%=RFQConstants.EC_OFFERING_UNIT%>;
		allProducts[i].UnitDsc = anProduct.UnitDsc;              
		allProducts[i].<%=RFQConstants.EC_OFFERING_QUANTITY%> = anProduct.<%=RFQConstants.EC_OFFERING_QUANTITY%>;
		allProducts[i].product_res_quantity = anProduct.product_res_quantity;
		break; 
	    }
	}
	top.sendBackData(allProducts, "allFixedPricingDynamicKits");
    }
    
    function validatePanelData0() 
    {
	var form = document.rfqDynamicKitFPForm;
	var flag = true, quant=false, curr=false, priceleng=false;
	
	//validates quantity
	if ((form.quantity.value == null)||(form.quantity.value =="")||(form.price.value == null)||(form.price.value == "")) 
	{
	    alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgEmptyResponseValue")) %>");
	    return false;
	}	
	if (form.quantity.value!= null && form.quantity.value!="") 
	{
	    if (!parent.isValidNumber(form.quantity.value,"<%=lang%>",false)) 
	    {
		quant=true;
		flag=false;
	    }
	    if (form.quantity.value.charAt(0) == '-') 
	    {
		form.quantity.focus();
		alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgNegativeNumber")) %>");
		return false;
	    }
	}
	
	//validates currency
	if (form.price.value != null && form.price.value != "") 
	{
	    if (!parent.isValidCurrency(form.price.value, form.CurrencyType.value, "<%=lang%>")) 
	    {
		curr=true;
		flag=false;			
	    }
	}	
  	var cur2num = "";
	cur2num = parent.currencyToNumber(form.price.value, form.CurrencyType.value, "<%=lang%>");
    	cur2numstr = new String(cur2num);
    	if (cur2numstr.length > 14) 
    	{
	    form.price.focus();
      	    priceleng=true;
      	    flag= false;
    	}
    
	// spits out error message
	if (quant) 
	{
	    alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidNumber")) %>");
	} 
	else if (curr) 
	{
	    alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidPrice")) %>");
	} 
	else if (priceleng) 
	{
      	    parent.alertDialog("<%=UIUtil.toJavaScript(priceNLS.get("priceTooLongMessage"))%>");
	}
    
        var resCatentryId = '<%= prodCatentryId %>';
        if (resCatentryId != null && !isEmpty(resCatentryId) && endresult_to_contract == true) 
        {
	    // check if this product included more than once if the RFQ will
	    // result to contract.
            for (var i = 0;i < allProducts.length;i++) 
            {
        	if (allProducts[i].<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%> != anProduct.<%=RFQConstants.EC_RFQ_OFFERING_PRODUCTID%> && allProducts[i].<%=RFQConstants.EC_OFFERING_CATENTRYID%> == resCatentryId) 
        	{    
	    	    alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("RFQ_DUPLICATE_CATENTRY3"))%>");
		    	flag = false;
		    	break;
       	    	}
       	    }
    	}
	return flag;
    }

    function validatePanelData()
    {
        return VPDResult;
    }
    
    function retrievePanelData() 
    {
      	document.rfqDynamicKitFPForm.price.value = anProduct.product_res_price;
      	document.rfqDynamicKitFPForm.quantity.value = anProduct.product_res_quantity;
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

<body class="content">

<h1><%= rfqNLS.get("rfqRespondtodynamickitfixedpricing") %></h1>
<%= rfqNLS.get("instruction_PDresponse_dk_fp") %>

<form name="rfqDynamicKitFPForm" action="">
<input type="hidden" name="CurrencyType" value="<%= defaultCurrency %>" /> 
<table border="0" width="100%">
    <tr>
  	<td><b><%= rfqNLS.get("resrequest") %></b></td>
    </tr>
    <tr>
    	<td><%= rfqNLS.get("product_partno") %>:
<script type="text/javascript">
	    document.write(ToHTML(anProduct.product_req_partnumber));
</script>
    	</td>
    </tr>
    <tr>
    	<td><%= rfqNLS.get("product_name") %>:
<script type="text/javascript">
   	    document.write(ToHTML(anProduct.product_req_name));
</script>
    	</td>
    </tr> 
    
    <tr>
    	<td><%= rfqNLS.get("Description") %>:
<script type="text/javascript">
            document.write(ToHTML(anProduct.product_req_description));
</script>
    	</td>
    </tr>      
   
    <tr>
    	<td><%= rfqNLS.get("rfqproducttype") %>:
<script type="text/javascript">
            document.write(ToHTML(anProduct.product_req_type));
</script>
    	</td>
    </tr>      
   
    <tr>
    	<td><%= rfqNLS.get("quantity") %>:
<script type="text/javascript">
	    document.write(anProduct.product_req_quantity);
	    document.write('<i>  '+anProduct.product_req_unit +'</i>');
</script>
 	</td>
    </tr>
    <tr>
    	<td><%= rfqNLS.get("price") %>:
<script type="text/javascript">
	    document.write(anProduct.product_req_price);
</script>
    	</td>
    </tr>
    <tr>
    	<td><%= rfqNLS.get("currency") %>:
<script type="text/javascript">
    	    document.write(anProduct.product_req_currency);
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
    	if (prodName == null || isEmpty(prodName)) 
    	{
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
            <label for="quantity">
    	    <%= rfqNLS.get("quantity") %><br />
    	    <input type="text" name="quantity" id="quantity" size="20" maxlength="200" />
            </label>
        </td>
    </tr>
    <tr>
	<td>
            <label for="units"><%= rfqNLS.get("rfqunits") %><br />      
            <script type="text/javascript">   
            document.write('<select name="unit" id="units">');
			document.write('<option value="," selected="selected"></option>');  
<%
  try 
  {
	QuantityUnitDescriptionAccessBean quab = new QuantityUnitDescriptionAccessBean();
	java.util.Enumeration enumeration = quab.findByLanguage(languageId);
	while ( enumeration != null && enumeration.hasMoreElements() ) 
	{
	    QuantityUnitDescriptionAccessBean quab2 =  (QuantityUnitDescriptionAccessBean)enumeration.nextElement();
	    String unit_id = quab2.getQuantityUnitId();
	    String unit_desc = quab2.getDescription();
%>
	    if (anProduct.<%=RFQConstants.EC_OFFERING_UNIT%> == "<%=UIUtil.toJavaScript(unit_id)%>") 
	    {
	        document.write("<option value=\"<%=UIUtil.toJavaScript(unit_id)%>, <%=UIUtil.toJavaScript(unit_desc)%>\" selected=\"selected\" >");
	        document.write("<%=UIUtil.toJavaScript(unit_desc)%>");
	        document.write("</option>");
	    } 
	    else 
	    {
	        document.write("<option value=\"<%= UIUtil.toJavaScript(unit_id)%>, <%= UIUtil.toJavaScript(unit_desc)%>\" >");
	        document.write("<%= UIUtil.toJavaScript(unit_desc)%>");
	        document.write("</option>");
	    }
<%
	} //end while
  } 
  catch (Exception e) 
  {
	out.println("Error - " + e.toString());
  }
%>
	    	document.write('</select>');
	    	</script>
	    	</label>
		</td>
    </tr>
    <tr>
        <td>
            <label for="price"><%= rfqNLS.get("price") %><br />
  	    	<input type="text" name="price" id="price" size="20" /> 
	    	<%= defaultCurrency %>
            </label>
  	</td>
    </tr>
</table>
</form>

<script type="text/javascript">
    retrievePanelData();
    initializeState();
</script>

</body>
</html>
