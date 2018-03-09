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
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.ibm.commerce.catalog.beans.*" %>
<%@ page import="com.ibm.commerce.catalog.objects.*" %>
<%@ page import="com.ibm.commerce.command.*" %>
<%@ page import="com.ibm.commerce.common.objects.*" %>
<%@ page import="com.ibm.commerce.rfq.utils.*" %>
<%@ page import="com.ibm.commerce.rfq.beans.*" %>
<%@ page import="com.ibm.commerce.tools.common.ui.taglibs.*" %>
<%@ page import="com.ibm.commerce.tools.test.*" %>
<%@ page import="com.ibm.commerce.tools.util.*" %>
<%@ page import="com.ibm.commerce.utf.beans.*" %>
<%@ page import="com.ibm.commerce.utf.commands.*" %>
<%@ page import="com.ibm.commerce.utf.helper.*" %>
<%@ page import="com.ibm.commerce.utf.objects.*" %>
<%@ page import="com.ibm.commerce.utf.utils.*" %>
<%@ page import="com.ibm.commerce.ubf.util.*" %>
<%@ page import="com.ibm.commerce.contract.objects.*" %>
<%@ include file="../common/common.jsp" %>
<%@ include file="../common/NumberFormat.jsp" %>

<jsp:useBean id="rfq" class="com.ibm.commerce.utf.beans.RFQDataBean"></jsp:useBean>  
<jsp:useBean id="rfqProdCompList" class="com.ibm.commerce.rfq.beans.RFQProductComponentListBean"></jsp:useBean>  

<%
    Locale aLocale = null;
    String storeId= null;
    CommandContext aCommandContext = (CommandContext)request.getAttribute("CommandContext");  
    String ErrorMessage = request.getParameter(com.ibm.commerce.tools.common.ui.UIProperties.SUBMIT_ERROR_MESSAGE);
    if (ErrorMessage == null) {
	ErrorMessage = "";
    }
    if( aCommandContext!= null ) {
       	aLocale = aCommandContext.getLocale();
       	storeId = aCommandContext.getStoreId().toString();
    }
    Hashtable rfqNLS = (Hashtable)ResourceDirectory.lookup("rfq.rfqNLS", aLocale);
    String lang = aCommandContext.getLanguageId().toString();
    if (lang == null) {
   		lang =  "-1";
    }        
    String rfqProdId = request.getParameter("rfqProdId");  

	String rfqId = request.getParameter("rfqid");        
	rfq.setRfqId(rfqId);
    com.ibm.commerce.beans.DataBeanManager.activate(rfq, request);
    String rfqName = UIUtil.toHTML(rfq.getName());
    
    int rowselect=1;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="<%= UIUtil.getCSSFile(aLocale)%>" type="text/css" />
<title></title>
<script type="text/javascript" src="/wcs/javascript/tools/common/Util.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/rfq/rfqUtile.js"></script>
<script type="text/javascript" src="/wcs/javascript/tools/common/dynamiclist.js"></script>
<script type="text/javascript">
function initializeState() {
  	parent.setContentFrameLoaded(true);
}
function savePanelData() {
	return true;
}
function validatePanelData() {
	return true;
}
function printAction() {
	window.print();
}
</script>
</head>

<body class="content" onload="initializeState();">

<br /><h1><%= rfqNLS.get("rfqdynamickitconfigreport") %></h1>

<table>
    <tr>
		<td><b><%= rfqNLS.get("rfqname") %>: <i><%= rfqName %></i></b></td>
    </tr>
</table>

<form name="ConfigurationReportForm" action="">

<script type="text/javascript">
    startDlistTable("<%= UIUtil.toJavaScript(rfqNLS.get("rfqconfigreport")) %>","100%");
    startDlistRowHeading();
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("rfqprodname")) %>",true,"30%",null);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("description")) %>",true,"40%",null);
    addDlistColumnHeading("<%= UIUtil.toJavaScript(rfqNLS.get("AdvSer_Text6")) %>",true,"30%",null);
    

    
    endDlistRowHeading();
    
<%			
		rfqProdCompList.setRfqProductId(rfqProdId);
    	com.ibm.commerce.beans.DataBeanManager.activate(rfqProdCompList, request);
    	RFQProductComponentDataBean[] productComponets = rfqProdCompList.getRFQProductComponents();
%>     
    var rowselect = 1;     
<%           
		for ( int k = 0; k < productComponets.length; k++ ) {
			RFQProductComponentDataBean prodComp = productComponets[k];
        	String catEntryId = prodComp.getCatalogEntryId().toString();                
        	CatalogEntryDescriptionAccessBean catentryDes = new CatalogEntryDescriptionAccessBean();
			catentryDes.setInitKey_catalogEntryReferenceNumber(catEntryId);
			catentryDes.setInitKey_language_id(lang);
			CatalogEntryAccessBean dbCatentry = new CatalogEntryAccessBean();			
			dbCatentry.setInitKey_catalogEntryReferenceNumber(catEntryId);
%>
			var prodName = "<%= UIUtil.toJavaScript(catentryDes.getName()) %>";
			var prodDesc = "<%= UIUtil.toJavaScript(catentryDes.getShortDescription()) %>";
			var prodPartNumber = "<%= UIUtil.toJavaScript(dbCatentry.getPartNumber()) %>";
			var prodQuantity = numberToStr( "<%= prodComp.getCatalogQuantity().toString() %>", <%= lang %>, null );
			var ProdUnitPrice = numberToCurrency( "<%= prodComp.getUnitPrice().toString() %>", <%= lang %>, null );
				
			startDlistRow(rowselect);			
			addDlistColumn(ToHTML(prodName));
			addDlistColumn(ToHTML(prodDesc));
			addDlistColumn(ToHTML(prodPartNumber));
	
				
    		endDlistRow();
    	
    		if ( rowselect == 1 ) { rowselect = 2; } else { rowselect = 1; }  
<%
		}
%>	
	endDlistTable();

</script>
</form>

<br /><br />

</body>
</html>
















