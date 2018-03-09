<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page
	import="java.util.*,com.ibm.commerce.tools.common.*,
	com.ibm.commerce.command.*,
	com.ibm.commerce.server.*,
	com.ibm.commerce.tools.util.*,
	com.ibm.commerce.tools.xml.*,
	com.ibm.commerce.datatype.*,
	com.ibm.commerce.beans.*"%>
<%@ page language="java"
	import="com.ibm.commerce.tools.common.ui.taglibs.*,
			com.ibm.commerce.utils.TimestampHelper" %>
	
<%@page import="com.ibm.commerce.tools.resourcebundle.*"%>

<%
	CommandContext cmdContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale locale = cmdContext.getLocale();
	ResourceBundleProperties taxNLS = (ResourceBundleProperties) ResourceDirectory.lookup("taxation.taxationNLS", locale);
	
%>

<%@include file="../common/common.jsp"%>


<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%=UIUtil.getCSSFile(locale)%>"
	TYPE="text/css">
<STYLE TYPE='text/css'>
.selectWidth {width: 230px;}
.selectWidth2 {width: 260px;}
.selectWidth3 {width: 260px;}
</STYLE>
</HEAD>
<SCRIPT SRC="/wcs/javascript/tools/common/Vector.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/wcs/javascript/tools/common/Util.js"></SCRIPT>
<SCRIPT language="JavaScript"
	src="/wcs/javascript/tools/common/dynamiclist.js"></SCRIPT>
<script>
	var jurstlist = new Array();
	var taxCategoryId =0;
	if (top.getData("taxCategoryId") != null){
		taxCategoryId = top.getData("taxCategoryId");
	}
	var taxCategory;
	var taxes = parent.parent.get("TaxInfoBean1");
	var categories = taxes.taxcgry;
	var jur = taxes.jurst;
	for (var i=0;i<size(jur);i++){
		jurstlist[i]=elementAt(i,jur);
		
	}
	// This jurislist is used by TaxRateInfoPanel to get the list of jurisdictions.
	top.saveData(jurstlist,"jurstlist");
	if(categories != null ){
		var topC= top.getData("taxCategoryId");
		if (topC == null || topC == undefined){
			taxCategoryId = elementAt(0,categories).categoryId;
			taxCategory = elementAt(0,categories).name;
			top.saveData(taxCategoryId,"taxCategoryId");
			top.saveData(taxCategory,"taxCategory");
		}	
	}
	
   	
	function loadPanelData(){
		//loadPanel
		initializeSelect();	
	}
	
	
	
	function loadSelectValue (select, value) {
		for (var i=0; i<select.length; i++) {
			if (select.options[i].value == value) {
				select.options[i].selected = true;
				return;
			}
		}
	}
	
	<%--
		- Initialize the selection 
	--%>
	function initializeSelect(){
	
    	var count = 0;
    	for (var i=0; i < size(categories); i++){
    		var category = elementAt(i,categories);
    		if( (category != "<%=taxNLS.getJSProperty("CategoriesDefaultTax")%>") &&
          		(category != "<%=taxNLS.getJSProperty("CategoriesShippingTax")%>") ) {
          		var displayName = category.name;
          		if (category.displayUsage != 0){
          			displayName += ' (<%=taxNLS.getJSProperty("VATCheckboxDesc")%>)';
          		} 
          		var id = category.categoryId;
          		document.TaxRatesListForm.taxCategoriesList.options[count] = new Option(displayName, id, false, false);
          		document.TaxRatesListForm.taxCategoriesList.options[count].selected=false;
          		count++;
          	}

    	}
    	// if selected existing
    	if (taxCategoryId != null){
    		loadSelectValue(document.getElementById("taxCategoriesList"), taxCategoryId);	
    	}
    	parent.parent.setContentFrameLoaded(true);
	}
	
	<%--
		- When user select different tax cateogry, save the parameters to top and reload the list frame.
	--%>
	function dochange(value){
		// load list data
		var index =  window.document.getElementById("taxCategoriesList").selectedIndex;
		taxCategory = window.document.getElementById("taxCategoriesList").options[index].text;
		taxCategoryId = window.document.getElementById("taxCategoriesList").options[index].value;

		top.saveData(taxCategoryId,"taxCategoryId");
		top.saveData(taxCategory,"taxCategory");
		TaxrateslistContent.window.location.reload();
	}
</script>

<body onload="loadPanelData()" class="content">
<FORM name="TaxRatesListForm" >
<DIV ID=taxCategorySelect>
<TABLE CELLPADDING=0 BORDER=0 cellspacing="0" id="taxCategorySelectTab">
	<TR>
		<TD id="taxCategorySelectTab_Cell_1"><label for="taxCategoriesList"><%=taxNLS.getProperty("taxCategories")%></label></TD>
		<TD id="taxCategorySelectTab_Cell_2"><SELECT NAME=taxCategoriesList ID=taxCategoriesList
			CLASS='selectWidth3'  onchange="dochange(this.options[this.options.selectedIndex].value)">
		</SELECT></TD>
	</TR>
</TABLE>
</DIV>

<P></P>
<iframe id=TaxrateslistContent title= frameborder=0 scrolling=no src=<%= UIUtil.getWebappPath(request) %>NewDynamicListView?ActionXMLFile=taxation.taxRatesList&amp;cmd=TaxRatesListContentView&amp; width=100% height=100%></iframe>
</FORM>


</BODY>

</HTML>

