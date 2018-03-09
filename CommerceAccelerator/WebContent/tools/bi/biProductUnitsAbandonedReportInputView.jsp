<!-- ========================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (c) Copyright IBM Corp. 2001, 2016

  US Government Users Restricted Rights - Use, duplication or12/8/2004
  disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 ===========================================================================-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@page import="com.ibm.commerce.catalog.objects.CatalogEntryAccessBean" %>
<%@page import="com.ibm.commerce.catalog.objects.StoreCatalogEntryAccessBean" %>
<%@page import="com.ibm.commerce.catalog.objects.CatalogEntryRelationAccessBean" %>
<%@page import="com.ibm.commerce.catalog.objects.CatalogGroupCatalogEntryRelationAccessBean" %>
<%@page import="com.ibm.commerce.catalog.objects.CatalogGroupDescriptionAccessBean" %>
<%@page import="com.ibm.commerce.catalog.objects.CatalogGroupAccessBean" %>
<%@page import="com.ibm.commerce.catalog.objects.CatalogEntryDescriptionAccessBean" %>
<%@page import="com.ibm.commerce.catalog.objects.AttributeValueAccessBean" %>

<%@page import="com.ibm.commerce.catalogmanagement.commands.CatalogManagementHelper" %>
<%@page import="com.ibm.commerce.command.CommandContext" %>


<%@include file="/tools/common/common.jsp" %>
<%@include file="/tools/reporting/ReportStartDateEndDateHelper.jspf" %>
<%@include file="/tools/reporting/ReportFrameworkHelper.jsp" %>

<%
	String catGrpID = "";
	String catEntryID = "";
	String isCategoryDisabled=null;

	CommandContext biCommandContext = (CommandContext) request.getAttribute(ECConstants.EC_COMMANDCONTEXT);
	Locale biLocale = biCommandContext.getLocale();
	Hashtable biNLS = (Hashtable)com.ibm.commerce.tools.util.ResourceDirectory.lookup("bi.biNLS", biLocale);

    isCategoryDisabled = request.getParameter("isCategoryDisabled");
	catGrpID = request.getParameter("catgrpid");
	catEntryID = request.getParameter("catentryid");
	// CatalogGroupID & Description Retrive part
	CommandContext cmdContext = (CommandContext)request.getAttribute(com.ibm.commerce.server.ECConstants.EC_COMMANDCONTEXT);
	
	
/*******
	CatalogEntryAccessBean catlogEntryAccBean = new CatalogEntryAccessBean();
	Long catalogEntryID;
	Enumeration e = catlogEntryAccBean.findByMemberId(CatalogManagementHelper.getOwnerId(cmdContext.getStoreId(),   cmdContext.getUserId()));
	ArrayList catEntryIDList = new ArrayList();
	while (e.hasMoreElements()) {
		catlogEntryAccBean = (CatalogEntryAccessBean) e.nextElement();
		if ((catlogEntryAccBean.getType().equals("ProductBean"))) {
			catalogEntryID = catlogEntryAccBean.getCatalogEntryReferenceNumberInEntityType();
			catEntryIDList.add(catalogEntryID);
		}
	}
******/

	StoreCatalogEntryAccessBean abStoreCatentry = new StoreCatalogEntryAccessBean();
	Long catalogEntryID;
	Enumeration e= abStoreCatentry.findByStoreId(new Long(cmdContext.getStoreId().toString()));
	ArrayList catEntryIDList = new ArrayList();
	while(e.hasMoreElements()){
		abStoreCatentry = (StoreCatalogEntryAccessBean)e.nextElement();
		CatalogEntryAccessBean abCatentry = new CatalogEntryAccessBean ();
		abCatentry.setInitKey_catalogEntryReferenceNumber(abStoreCatentry.getCatalogEntryReferenceNumber());
		if(abCatentry.getType().equals("ProductBean"))
		{
			catalogEntryID = abCatentry.getCatalogEntryReferenceNumberInEntityType();
			catEntryIDList.add(catalogEntryID);
		}
	}




	//Getting CatalogGroupId
	CatalogGroupCatalogEntryRelationAccessBean catgrpentryRelAccessbean = new CatalogGroupCatalogEntryRelationAccessBean();
	String catalogGroupId = "";

	ArrayList catalogGroupIDList = new ArrayList();
	//Set catalogGroupIDList;

	for(int i=0; i<catEntryIDList.size(); i++) {
		Enumeration egrp = catgrpentryRelAccessbean.findByCatalogEntryIdAndStore((Long)catEntryIDList.get(i),cmdContext.getStoreId());
		while (egrp.hasMoreElements()) {
			catgrpentryRelAccessbean = (CatalogGroupCatalogEntryRelationAccessBean) egrp.nextElement();
			catalogGroupId =(String) catgrpentryRelAccessbean.getCatalogGroupId();
			if (!catalogGroupIDList.contains(catalogGroupId)) {
				catalogGroupIDList.add(catalogGroupId);
			}
		}
	}

 	//Getting CatalogGroupDesc
	ArrayList catalogGroupDescList = new ArrayList();
	String catalogGroupDesc ="";
	for(int i=0; i<catalogGroupIDList.size(); i++) {
		CatalogGroupAccessBean catgrpaccbean  = new CatalogGroupAccessBean();
		catgrpaccbean.setlanguage_id(cmdContext.getLanguageId());
		catgrpaccbean.setInitKey_catalogGroupReferenceNumber((String)catalogGroupIDList.get(i));
		catalogGroupDescList.add(catgrpaccbean.getIdentifier());
	}

	//  CatalogEntryID & Description retrive Part
	ArrayList catalogEntryIDList = new ArrayList();
	ArrayList catalogEntryNameList = new ArrayList();

	if(catGrpID != null) {
		String catalogStringEntryID ="";
		Enumeration egrp = catgrpentryRelAccessbean.findByCatalogGroupId( new Long(catGrpID));
		while (egrp.hasMoreElements()) {
			CatalogEntryDescriptionAccessBean  catEntryDescAccBean = new CatalogEntryDescriptionAccessBean();
			CatalogGroupCatalogEntryRelationAccessBean catGrpCatEntryRelAccessbean = (CatalogGroupCatalogEntryRelationAccessBean) egrp.nextElement();
			catalogStringEntryID =(String) catGrpCatEntryRelAccessbean.getCatalogEntryId();
			
			CatalogEntryAccessBean abCatentry = new CatalogEntryAccessBean ();
			abCatentry.setInitKey_catalogEntryReferenceNumber(catalogStringEntryID);
			if(abCatentry.getType().equals("ProductBean"))
			{
				catalogEntryIDList.add(catalogStringEntryID);
				catEntryDescAccBean.setInitKey_language_id(String.valueOf(cmdContext.getLanguageId()));
				catEntryDescAccBean.setInitKey_catalogEntryReferenceNumber(catalogStringEntryID);
				catalogEntryNameList.add(catEntryDescAccBean.getName());
			}	
		}
	}

	//  CatalogEntryItemsID & Description retrive Part
	ArrayList itemSKUList = new ArrayList();
	ArrayList itemIDList = new ArrayList();
	boolean flag = true;

	if(catEntryID !=null) 
	{
		CatalogEntryRelationAccessBean abCatenRel = new CatalogEntryRelationAccessBean();
		Enumeration enCatenrel=abCatenRel.findByCatalogEntryParentIdAndTypeAndStore(new Long(catEntryID),"PRODUCT_ITEM",cmdContext.getStoreId());
		while(enCatenrel.hasMoreElements())
		{
			abCatenRel = (CatalogEntryRelationAccessBean)enCatenrel.nextElement();
			CatalogEntryAccessBean abCatentry = new CatalogEntryAccessBean ();
			abCatentry.setInitKey_catalogEntryReferenceNumber(abCatenRel.getCatalogEntryIdChild());
			itemIDList.add(abCatentry.getCatalogEntryReferenceNumber());
			itemSKUList.add(abCatentry.getPartNumber());
		 	
		}

		if( itemSKUList.size() == 0) {
			flag = false;
		}
	}

%>

<HTML>
<HEAD>
<link rel=stylesheet href="<%= UIUtil.getCSSFile(biLocale) %>" type="text/css">
	<%=fHeader%>

	<title><LABEL><%=biNLS.get("productUnitsAbandoned")%></LABEL></title>

	<script src="/wcs/javascript/tools/common/Util.js"></script>
	<script src="/wcs/javascript/tools/common/DateUtil.js"></script>
	<script src="/wcs/javascript/tools/common/SwapList.js"></script>
	<script src="/wcs/javascript/tools/reporting/ReportHelpers.js"></script>

	<SCRIPT>

	/////////////////////////////////////////////////////
	// Call the initialize routines for the various elements of the page
	/////////////////////////////////////////////////////
	function initializeValues() {
		//ResetValues();
		onLoadStatOption("myHelperProductUnitsAbandoned");
		if (parent.setContentFrameLoaded) {
			parent.setContentFrameLoaded(true);
		}
		if(document.all.isCategoryDisabled.value != "null"
			&& document.all.isCategoryDisabled.value != ""
			&& document.all.isCategoryDisabled.value == "true" ) {
			retriveResetValues();
		}
		if(document.all.catgrpid.value != "null") {
			catgrpintValue = document.all.catgrpid.value;
			retriveResetValues();
		}
	}

	/////////////////////////////////////////////////////
	// Call the getGrpIDOptions for the various categories of the ProductBean Group
	/////////////////////////////////////////////////////
	function setResetValues(){
		top.put("timeval",document.all.time[document.all.time.selectedIndex].value);

		top.put("stryear",document.enquiryPeriod.StartDateEndDateHelperYearSD.value);
		top.put("strmon",document.enquiryPeriod.StartDateEndDateHelperMonthSD.value);
		top.put("strday",document.enquiryPeriod.StartDateEndDateHelperDaySD.value);

		top.put("endyear",document.enquiryPeriod.StartDateEndDateHelperYearED.value);
		top.put("endmon",document.enquiryPeriod.StartDateEndDateHelperMonthED.value);
		top.put("endday",document.enquiryPeriod.StartDateEndDateHelperDayED.value);
	}

	function retriveResetValues() {
		var timeLength = document.all.time.options.length;

		var stryear = top.get("stryear");
		var strmon = top.get("strmon");
		var strday = top.get("strday");

		var endyear = top.get("endyear");
		var endmon = top.get("endmon");
		var endday = top.get("endday");

		var timeval = top.get("timeval");

		document.all.time.value=timeval;

		document.enquiryPeriod.StartDateEndDateHelperYearSD.value=stryear;
		document.enquiryPeriod.StartDateEndDateHelperMonthSD.value= strmon;
		document.enquiryPeriod.StartDateEndDateHelperDaySD.value= strday;

		document.enquiryPeriod.StartDateEndDateHelperYearED.value  = endyear;
		document.enquiryPeriod.StartDateEndDateHelperMonthED.value = endmon;
		document.enquiryPeriod.StartDateEndDateHelperDayED.value   = endday;
	}

	function getGrpIDOptions(catgrpidVal) {
		if (catgrpidVal == "pleaseSelect") {
			 document.all.catenty.value = "pleaseSelect";
             document.all.isCategoryDisabled.value="true";
			 setResetValues();
  			 this.location.replace("/webapp/wcs/tools/servlet/BIProductUnitsAbandonedReportInputView?isCategoryDisabled=true");
			 return;
		}
		var catGrpID = eval(catgrpidVal);
		setResetValues();
		parent.setContentFrameLoaded(false);
		this.location.replace("/webapp/wcs/tools/servlet/BIProductUnitsAbandonedReportInputView?catgrpid=" + catGrpID);
	}


	function getGrpEntryIDOptions()	{
		catgrpidentryVal = document.all.catenty[document.all.catenty.selectedIndex].value;
		catgrpidVal = document.all.catgrpid.value;
		catGrpID = eval(catgrpidVal);
		if (catgrpidentryVal == "pleaseSelect") {
			this.location.replace("/webapp/wcs/tools/servlet/BIProductUnitsAbandonedReportInputView?catgrpid=" + catGrpID);
			return;
		}
		var catGrpEntryID = eval(catgrpidentryVal);
		setResetValues();
		parent.setContentFrameLoaded(false);
		this.location.replace("/webapp/wcs/tools/servlet/BIProductUnitsAbandonedReportInputView?catgrpid=" + catGrpID +"&catentryid=" +catGrpEntryID);
	}

	/////////////////////////////////////////////////////
	// Call the save routines for the various elements of the page
	/////////////////////////////////////////////////////
	function savePanelData() {
		saveStatOption("myHelperProductUnitsAbandoned");
		setReportFrameworkOutputView("DialogView");
		setReportFrameworkParameter("XMLFile","bi.biProductUnitsAbandonedReportOutputDialog");
		setReportFrameworkReportXML("bi.biProductUnitsAbandonedReport");

		if (document.forms["myHelperProductUnitsAbandoned"].rbsort[0].checked) {
			setReportFrameworkParameter("sortOrder","DESC");
		} else {
			setReportFrameworkParameter("sortOrder","ASC");
		}

		if (document.forms["myHelperProductUnitsAbandoned"].rbname[0].checked) {
			setReportFrameworkParameter("sortBy","1");
		} else if (document.forms["myHelperProductUnitsAbandoned"].rbname[1].checked) {
			setReportFrameworkParameter("sortBy","2");
		}

		if (document.all.time.selectedIndex != 0) {
			var startDate = getPreselectedStartDate(document.all.time.value);
			var endDate = getPreselectedEndDate(document.all.time.value);
			setReportFrameworkParameter("StartDate", startDate);
		 	setReportFrameworkParameter("EndDate", endDate);
		} else {
			saveStartDateEndDate("enquiryPeriod");
			setEndDate();
		 	setReportFrameworkParameter("StartDate", returnStartDateAsTimestamp("enquiryPeriod"));
			setReportFrameworkParameter("EndDate", returnEndDateAsTimestamp("enquiryPeriod"));
		}

		if(document.all.catgrp.selectedIndex==0) {
			setReportFrameworkReportName("biProductAbandonedAllCategoriesReport");
			//alert("looking for biProductAbandonedAllCategoriesReport");
		} else if (document.all.catenty.selectedIndex==0) {
			setReportFrameworkReportName("biProductAbandonedAllProductsReport");
			//aji 2 line
			var catgrpitemid = document.all.catgrp.options[document.all.catgrp.selectedIndex].value;
			setReportFrameworkParameter("catgrp_id", catgrpitemid);
		} else if (document.all.catitem.selectedIndex==0) {
			setReportFrameworkReportName("biProductAbandonedAllSKUsReport");
			//aji 2 line 
			//alert(catenty_id);
			var catentyitemid = document.all.catenty.options[document.all.catenty.selectedIndex].value;
			setReportFrameworkParameter("catenty_id", catentyitemid);
		} else {
			setReportFrameworkReportName("biProductAbandonedReport");
			catentitemid = document.all.catitem.options[document.all.catitem.selectedIndex].value;
			setReportFrameworkParameter("item_id", catentitemid);
			
		}

	 	setReportFrameworkParameter("ReportType", "UserInput");
		saveReportFramework();
		top.saveModel(parent.model);
		return true;
	}

	/////////////////////////////////////////////////////
	// Call the validate routines for the various elements of the page
	/////////////////////////////////////////////////////
	function validatePanelData() {
		if(document.all.time.selectedIndex != 0 &&
		  (document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" ||
		   document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" || document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" )) {
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("SelectAnyOneOption"))%>");
			ResetValues();
			return false;
		}

		if(document.all.time.selectedIndex == 0) {
			if (validateStartDateEndDate("enquiryPeriod") == false) {
				return false;
			}
		}

	/*	//Catalog Cattegory Checking
		if(document.all.flag.value =="true") {
			if(document.all.choose_category.selectedIndex == 0) {
				parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("SelectCatOption"))%>");
				return false;
			}
			if (document.all.choose_category.selectedIndex > 0 && document.all.catenty.selectedIndex == 0) {
				parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("SelectCatEntryOption"))%>");
				return false;
			}
			if (document.all.choose_category.selectedIndex > 0 && document.all.catenty.selectedIndex > 0 && document.all.catitem.length > 1 && document.all.catitem.selectedIndex == 0) {
				parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("SelectCatnEntItemOption"))%>");
				return false;
			}
		} else if(document.all.choose_category.selectedIndex == 0 && document.all.catenty.selectedIndex == 0) {
			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("SelectCatnEntItemOption"))%>");
			return false;
		}
  */
		return true;
	}



	function ResetValues() {
		document.enquiryPeriod.StartDateEndDateHelperYearSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDaySD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperYearED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDayED.value = "";
		document.all.time.selectedIndex = 0;
	}


	function setEndDate() {
		if((document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" &&
		    document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" && document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ) &&
		   (document.enquiryPeriod.StartDateEndDateHelperYearED.value == "" &&
			document.enquiryPeriod.StartDateEndDateHelperMonthED.value == "" && document.enquiryPeriod.StartDateEndDateHelperDayED.value == "" )) {

			parent.alertDialog("<%=UIUtil.toJavaScript(biNLS.get("EndDateIsCurrentDate"))%>");
			document.enquiryPeriod.StartDateEndDateHelperYearED.value = getCurrentYear();
			document.enquiryPeriod.StartDateEndDateHelperMonthED.value = getCurrentMonth();
			document.enquiryPeriod.StartDateEndDateHelperDayED.value = getCurrentDay();
		}
	}


	/////////////////////////////////////////////////////
	// Validate is done by the HTML radio button
	/////////////////////////////////////////////////////
	function validateStatOption(container) {
	   return true;
	}


	/////////////////////////////////////////////////////
	// initialize function for the status dates
	/////////////////////////////////////////////////////

	function onLoadStatOption(container) {
		var myContainer = parent.get(container, null);
		// If this is the first time set it to the default.
		if (myContainer == null) {
			myContainer = new Object();
			myContainer.StatusChosen = 1;
			with (document.forms[container]) {
				rbname[0].checked = true;
				rbsort[0].checked = true;
			}
			parent.put(container, myContainer);
			return;
		} else {
	   		// If it is not the first time set it to the last selected.
			if(myContainer.StatusChosen == 4){
				document.forms[container].rbname[1].checked = true;
				document.forms[container].rbsort[1].checked = true;
			}
			 else if(myContainer.StatusChosen == 3){
				document.forms[container].rbname[1].checked = true;
				document.forms[container].rbsort[0].checked = true;
			}
			 else if(myContainer.StatusChosen == 2){
				document.forms[container].rbname[0].checked = true;
				document.forms[container].rbsort[1].checked = true;
			}
			 else {
				document.forms[container].rbname[0].checked = true;
				document.forms[container].rbsort[0].checked = true;
			}
			parent.put(container, myContainer);
	   		return;
		}
	}



	/////////////////////////////////////////////////////
	// save function for the Staus selected
	/////////////////////////////////////////////////////
	function saveStatOption(container) {
		myContainer = parent.get(container,null);
		if (myContainer == null) {
			return;
		}

		with (document.forms[container]) {
			if (rbname[1].checked){
				if(rbsort[1].checked) {
					myContainer.StatusChosen = 4;
				} else {
					myContainer.StatusChosen = 3;
				}
			} else {
	      	 	if(rbsort[1].checked) {
	      	 		myContainer.StatusChosen = 2;
	      	 	} else {
					myContainer.StatusChosen = 1;
				}
			}
		}
		parent.put(container, myContainer);
	}


	/////////////////////////////////////////////////////
	// Return the Status Chosen
	/////////////////////////////////////////////////////
	function returnStatOptionProduct(container) {
	   return document.forms[container].rbname[0].checked;
	}


	function returnStatOptionCount(container) {
	   return document.forms[container].rbname[1].checked;
	}


	/////////////////////////////////////////////////////
	// Return the Orderby Status Chosen
	/////////////////////////////////////////////////////
	 function returnOrderbyDesc(container) {
	   return document.forms[container].rbsort[0].checked;
	}


	 function returnOrderbyAsc(container) {
	   return document.forms[container].rbsort[1].checked;
	}

</SCRIPT>
</head>

<body onload="initializeValues()" class="content">

	<h1><LABEL><%=biNLS.get("productUnitsAbandoned") %></LABEL></h1>
	<LABEL><%=biNLS.get("productUnitsAbandonedDescription") %></LABEL>
	<p>

<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="400">
<tr>
	<td>
	 <DIV ID=pageBody STYLE="display: block; margin-left: 0">
	 <label for="time"><%=biNLS.get("lableviewreportfor")%></label><br>
	<select id="time">
		<option value="pleaseSelect" selected><LABEL><%=biNLS.get("pleaseSelect")%></LABEL></option>
		<option value="Yesterday"><LABEL><%=biNLS.get("yesterdayTitle")%></LABEL></option>
		<option value="Weekly"><LABEL><%=biNLS.get("thisWeekTitle")%></LABEL></option>
		<option value="Monthly"><LABEL><%=biNLS.get("thisMonthTitle")%></LABEL></option>
		<option value="Quarterly"><LABEL><%=biNLS.get("thisQuarterTitle")%></LABEL></option>
		<option value="Yearly"><LABEL><%=biNLS.get("thisYearTitle")%></LABEL></option>
	</select>
  </DIV>

  <DIV ID=pageBody STYLE="display: block; margin-left: 0">
  <B><LABEL><%=biNLS.get("or")%></LABEL></B>
  </DIV>
  <DIV ID=pageBody STYLE="display: block; margin-left: 0">
	   <%=generateStartDateEndDate("enquiryPeriod", biNLS, null)%>
	</DIV>
	</td>
</tr>
<tr>
<td>
  <DIV ID=pageBody STYLE="display: block; margin-left: 0">
  <B><LABEL><%=biNLS.get("and")%></LABEL></B>
  </DIV>
  </td>
</tr>
</table>

<!--  Categary Group   -->

<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="400">
	<tr>
		<DIV ID=pageBody STYLE="display: block; margin-left: 0">
			<td><LABEL><%=biNLS.get("catgrp")%></LABEL></td>
			<td><LABEL><%=biNLS.get("catgrpentry")%></LABEL></td>
			<td><LABEL><%=biNLS.get("catitems")%></LABEL></td>
		</div>
	</tr>
	<br>
	<tr>
		<DIV ID=pageBody STYLE="display: block; margin-left: 0">
<%
if(catGrpID == null){
%>
	<td>
	<select name="choose_category" id=catgrp onChange="getGrpIDOptions(window.document.all.choose_category.options[selectedIndex].value);">
	<option value="pleaseSelect" selected><LABEL for="catgrp"><%=biNLS.get("allcatgroup")%></LABEL></option>

	<%
	for(int j = 0 ; j < catalogGroupDescList.size(); j ++){
	%>
	<option value='<%=catalogGroupIDList.get(j)%>'><%=catalogGroupIDList.get(j)%> - <%=catalogGroupDescList.get(j)%></option>
	<%}%>
		</select>
	</td>
<%
} else {
%>

<td>
	<select name="choose_category" id=catgrp onChange="getGrpIDOptions(window.document.all.choose_category.options[selectedIndex].value);">
	<option value="pleaseSelect" ><LABEL for="catgrp"><%=biNLS.get("Allcategory")%></LABEL></option>
	<%
	for(int j = 0 ; j < catalogGroupDescList.size(); j ++){
		if(catGrpID.equals(catalogGroupIDList.get(j))){
	%>
	<option value='<%=catalogGroupIDList.get(j)%>' selected ><%=catalogGroupIDList.get(j)%> - <%=catalogGroupDescList.get(j)%></option>
	<%
		} else {
	%>
	<option value='<%=catalogGroupIDList.get(j)%>'><%=catalogGroupIDList.get(j)%> - <%=catalogGroupDescList.get(j)%></option>
	<%
		}
	} //For loop close
	%>
	</select>
	</td>

<%
}

if(catGrpID == null) {
%>

	<td>
		<select id="catenty" onChange="getGrpEntryIDOptions();">
			<option value="pleaseSelect" selected><LABEL for="catenty"><%=biNLS.get("Allcategory")%></LABEL></option>
		</select>
	</td>
<%
} else if((catGrpID != null) && (catEntryID == null)) {
%>
	<td>
		<select id="catenty" onChange="getGrpEntryIDOptions();">
			<option value="pleaseSelect" selected ><LABEL for="catenty"><%=biNLS.get("Allcategory")%></LABEL></option>
	<%
	for(int j = 0 ; j < catalogEntryNameList.size(); j ++){
	%>
			<option value='<%=catalogEntryIDList.get(j)%>'><%=catalogEntryIDList.get(j)%> - <%=catalogEntryNameList.get(j)%></option>
	<%
	}
	%>
		</select>
	</td>
<%
} else if((catGrpID != null) && (catEntryID != null)) {
%>
	<td>
		<select id="catenty" onChange="getGrpEntryIDOptions();">
	<option value="pleaseSelect"><LABEL for="catenty"><%=biNLS.get("Allcategory")%></LABEL></option>
	<%
	for(int z = 0 ; z < catalogEntryNameList.size(); z ++) {
		if(catEntryID.equals(catalogEntryIDList.get(z))) {
		%>
	<option value='<%=catalogEntryIDList.get(z)%>'selected ><%=catalogEntryIDList.get(z)%> - <%=catalogEntryNameList.get(z)%></option>
		<%
		} else {
		%>
	<option value='<%=catalogEntryIDList.get(z)%>'><%=catalogEntryIDList.get(z)%> - <%=catalogEntryNameList.get(z)%></option>
		<%
		}
	}
	%>
		</select>
	</td>
<%
}

if(catEntryID == null) {
%>
<td>
<select id="catitem">
			<option value="pleaseSelect" selected><LABEL for="catitem"><%=biNLS.get("Allsku")%></LABEL></option>
		</select>
	</td>
<%
} else {
	if(flag) {
%>
<td>
<select id="catitem">
			<option value="pleaseSelect" selected><LABEL for="catitem"><%=biNLS.get("Allsku")%></LABEL></option>

			<%
		for(int z = 0 ; z < itemSKUList.size(); z ++){
	%>
	<option value='<%=String.valueOf(itemIDList.get(z))%>'><%=String.valueOf(itemIDList.get(z))%> - <%=String.valueOf(itemSKUList.get(z))%></option>
	<%
		}
	%>
	</select>
	</td>

<%
	} else {
%>
	<td>
	<select id="catitem" disabled>
			<option value="pleaseSelect" selected><LABEL for="catitem"><%=biNLS.get("Allsku")%></LABEL></option>
	</select>
	</td>
<%
	}
}
%>
</div>

</tr>
</table>

<br>
<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0">
	<tr>

		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
		<tr>
			<td align="left">
				<B><LABEL><%=biNLS.get("sortby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>

		<td>
		<table border="0" bordercolor="black" CELLPADDING="0" CELLSPACING="0" width="210">
		<tr>
			<td align="left">
			  <B><LABEL><%=biNLS.get("orderby")%></LABEL></B>
			</td>
		</tr>
		</table>
		</td>

		</tr>
</table>
	<DIV ID=pageBody STYLE="display: block; margin-left:0">
		<FORM NAME=myHelperProductUnitsAbandoned>
			<TABLE border=0 bordercolor=red CELLPADDING=0 CELLSPACING=0 width=400>
				<TR>
					<TD ALIGN=left VALIGN=TOP>
						<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
							<TR HEIGHT=5>
								<TD ALIGN=left VALIGN=TOP>
									<INPUT TYPE=RADIO id="s1" NAME=rbname VALUE=All>
										<label for="s1">
											<%=biNLS.get("product")%>
										</label>
									</INPUT>
									<BR>
									<BR>
									<INPUT TYPE=RADIO id="s2" NAME=rbname VALUE=PayA>
										<label for="s2">
											<%=biNLS.get("noofitems")%>
										</label>
									</INPUT>
									<BR>
								</TD>
							</TR>
						</TABLE>
					</TD>
					<TD>&nbsp;</TD>
					<TD ALIGN=left VALIGN=TOP>
						<TABLE border=0 bordercolor=black CELLPADDING=0 CELLSPACING=0 width=200>
							<TR HEIGHT=5>
								<TD ALIGN=left VALIGN=TOP>
									<INPUT TYPE=RADIO  id="ord1" NAME=rbsort VALUE=All>
										<label for="ord1">
											<%=biNLS.get("descend")%>
										</label>
									</INPUT>
									<BR>
									<BR>
									<INPUT TYPE=RADIO id="ord2" NAME=rbsort VALUE=PayA>
										<label for="ord2">
											<%=biNLS.get("ascend")%>
										</label>
									</INPUT>
									<BR>
								</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
		</FORM>
	 </DIV>

<input type="hidden" name="catentryid" value=<%=UIUtil.toHTML(catEntryID)%> >
<input type="hidden" name="catgrpid" value=<%=UIUtil.toHTML(catGrpID)%> >
<input type="hidden" name="flag" value=<%=flag%> >
<input type="hidden" name="isCategoryDisabled" value="<%=UIUtil.toHTML(isCategoryDisabled)%>" >


</BODY>
</HTML>
