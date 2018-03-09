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
    var productObjList = top.getData("allPercentagePricingProducts", 1);    
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
	var resName = '<%= UIUtil.toJavaScript(prodName) %>';
	var resProdType = '<%= UIUtil.toJavaScript(prodType) %>';
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
	
	if (endresult_to_contract == false) 
	{
	    var unitInfo = document.rfqProductPPForm.unit[document.rfqProductPPForm.unit.selectedIndex].value.split(",");
	    if (unitInfo[0] != undefined && unitInfo[0]!=null) 
	    {
	   	productObj.<%=RFQConstants.EC_OFFERING_UNIT%> = unitInfo[0];
	    }
	    if (unitInfo[1] != undefined && unitInfo[1]!=null) 
	    {
	   	productObj.UnitDsc = unitInfo[1];
	    }
	    
		
	    productObj.<%=RFQConstants.EC_OFFERING_QUANTITY%> = strToNumber(document.rfqProductPPForm.quantity.value,"<%= langId %>");
	    	    
	    
	    productObj.product_res_quantity = document.rfqProductPPForm.quantity.value;
	    
	    
	} 
	
	productObj.<%= RFQConstants.EC_RFQ_CHANGE_STATUS %> = "<%= RFQConstants.EC_RFQ_CHANGE_TRUE %>";
	productObj.<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %>=strToNumber('-' + document.rfqProductPPForm.priceAdjustment.value,<%= langId %>);
	productObj.<%= RFQConstants.EC_OFFERING_RESPOND_TO_PRODUCT %> = "<%= RFQConstants.EC_RFQ_RESPOND_TO_PRODUCT_YES %>";
    }
    
    function validatePanelData0() 
    {
	var form = document.rfqProductPPForm;
	var flag = true;
	var quant = false, quant=false, curr=false, priceleng=false;
	
        if (endresult_to_contract == false) 
	{  
	    //validates quantity
	    if ((form.quantity.value == null)||(form.quantity.value =="")) 
	    {
	    	alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgEmptyResponseValue")) %>");
	    	return false;
	    }	
	    if (form.quantity.value!= null && form.quantity.value!="") 
	    {
	    	if (!parent.isValidNumber(form.quantity.value,"<%=langId%>",false)) 
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
	    if (quant) 
	    {
	    	alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidNumber")) %>");
	    }
	}  	
	
	if ((form.priceAdjustment.value == null)||(form.priceAdjustment.value =="")) 
	{
	    alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgEmptyResponseValue")) %>");
	    return false;
	}	
    	if (form.priceAdjustment.value!= null && form.priceAdjustment.value!="") 
    	{
    	    if (!parent.isValidNumber(form.priceAdjustment.value,"<%= langId %>",false)) 
    	    {
    		form.priceAdjustment.focus();
    		alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidNumber")) %>");
    		return false;
    	    }		    
    	    if (form.priceAdjustment.value < 0 || form.priceAdjustment.value > 99) 
    	    {	
    		form.priceAdjustment.focus();
    		alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgInvalidNumber")) %>");
    		return false;
    	    }	        
    	    if (form.priceAdjustment.value.charAt(0) == '-') 
    	    {
    		form.priceAdjustment.focus();
    		alertDialog("<%= UIUtil.toJavaScript(rfqNLS.get("msgNegativeNumber")) %>");
    		return false;
    	    }
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
        var priceAdjustment = productObj.<%= RFQConstants.EC_OFFERING_PRICEADJUSTMENT %>;
       	if (priceAdjustment != null && priceAdjustment != "" && priceAdjustment != undefined) 
       	{
       	    document.rfqProductPPForm.priceAdjustment.value = numberToStr((priceAdjustment * -1), <%= langId %>, null);
        }
        if (endresult_to_contract == false) 
	{	
            var quantity;
            quantity = productObj.<%=RFQConstants.EC_OFFERING_QUANTITY%>;
            if (quantity != null && quantity != "" && quantity != undefined) 
       	    {
        	document.rfqProductPPForm.quantity.value = productObj.<%=RFQConstants.EC_OFFERING_QUANTITY%>;
            }
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
<h1><%= rfqNLS.get("rfqresponsepercentageprice") %></h1>
<%= rfqNLS.get("instruction_PDresponse_percentageprice") %>

<form name="rfqProductPPForm" action="">
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
    	<td><%= rfqNLS.get("productname") %>: 
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
    	<td><%= rfqNLS.get("ProdDisp_Text2") %>
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
            
<script type="text/javascript">					
	if (endresult_to_contract == false) 
	{
            document.writeln("    <tr>");
            document.writeln("        <td>");	
	    document.write('<%= rfqNLS.get("quantity") %>:');
	    document.write(productObj.<%=RFQConstants.EC_RFQ_OFFERING_QUANTITY%>);
	    document.write('<i>  '+productObj.<%=RFQConstants.EC_RFQ_OFFERING_UNIT%> +'</i>');
            document.writeln("    </td>");
            document.writeln("        </tr>");
	} 
</script>

    <tr>
    	<td><%= rfqNLS.get("rfqpriceadjustment") %>:
<script type="text/javascript">
	    document.write(ToHTML(productObj.<%=RFQConstants.EC_RFQ_OFFERING_PRICEADJUSTMENT%>));
	    document.write('<%=rfqNLS.get("percentagemark")%>');
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
        <td><%= rfqNLS.get("productname") %>:
<script type="text/javascript">
  	if (prodName == null || prodName == "") 
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
    	<td><%= rfqNLS.get("ProdDisp_Text2") %>
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
	    <label for="priceAdjustment"><%= rfqNLS.get("rfqpriceadjustment") %>:<br />
            <input type="text" name="priceAdjustment" id="priceAdjustment" size="20" maxlength="200" /> &nbsp;<%=rfqNLS.get("percentagemark")%>&nbsp;<%=rfqNLS.get("rfqpercentagemarkdown")%>
	    </label>
	</td>
    </tr> 
<script type="text/javascript">	
					
	if (endresult_to_contract == false) 
	{

          
            document.writeln("    <tr>");
            document.writeln("        <td>");
            document.writeln("            <label for=\"quantity\">");
	    document.write('<%= rfqNLS.get("quantity") %>:');
	    document.write('<br />');
	    document.write('<input type=\"text\" name=\"quantity\" id=\"quantity\" size=\"20\" maxlength=\"200\" /> &nbsp;');
            document.writeln("            </label>");
            document.writeln("        </td>");
            document.writeln("    </tr>");

            document.writeln("    <tr>");
            document.writeln("        <td>");
            document.writeln("            <label for=\"units\">");
	    document.write('<%= rfqNLS.get("rfqunits") %>:');
	    document.write('<br />');
	    document.write('<select name=\"unit\" id=\"units\">');	 
	    document.write('<option value=\",\" selected=\"selected\"></option>');	
<%
	  try
	  {
	    QuantityUnitDescriptionAccessBean quab = new QuantityUnitDescriptionAccessBean();
	    java.util.Enumeration enumeration = quab.findByLanguage(langId);
	    while ( enumeration != null && enumeration.hasMoreElements() ) 
	    {
	    	QuantityUnitDescriptionAccessBean quab2 =  (QuantityUnitDescriptionAccessBean)enumeration.nextElement();
	    	String unit_id = quab2.getQuantityUnitId();
	    	String unit_desc = quab2.getDescription();
%>
	    	if (productObj.<%=RFQConstants.EC_OFFERING_UNIT%> == "<%=UIUtil.toJavaScript(unit_id)%>") 
	    	{
	            document.write("<option value=\"<%=UIUtil.toJavaScript(unit_id)%>, <%=UIUtil.toJavaScript(unit_desc)%>\" selected=\"selected\" >");
	            document.write("<%=UIUtil.toJavaScript(unit_desc)%>");
	            document.write("</option>");
	    	} 
	    	else 
	    	{
	            document.write("<option value=\"<%=UIUtil.toJavaScript(unit_id)%>, <%=UIUtil.toJavaScript(unit_desc)%>\" >");
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
            document.writeln("                </select>");
            document.writeln("            </label>");
            document.writeln("        </td>");
            document.writeln("    </tr>");
         }
        
</script>

   
</table>
</form>

<script type="text/javascript">
    initializeState();
    retrievePanelData();
</script>

</body>
</html>
