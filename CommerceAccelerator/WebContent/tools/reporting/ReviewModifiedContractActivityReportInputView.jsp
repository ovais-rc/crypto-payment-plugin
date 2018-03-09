<%
//********************************************************************
//*-------------------------------------------------------------------
//* Licensed Materials - Property of IBM
//*
//* 5697-D24
//*
//* (c) Copyright IBM Corp. 2000, 2002
//*
//* US Government Users Restricted Rights - Use, duplication or
//* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//*
//*-------------------------------------------------------------------
//*
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<%@page import="java.util.*" %>
<%@page import="com.ibm.commerce.tools.util.*" %>
<%@page import="com.ibm.commerce.tools.xml.*" %>

<%@include file="common.jsp" %>
<%@include file="ReportStartDateEndDateHelper.jspf" %>
<%@include file="ReportFrameworkHelper.jsp" %>

<HTML>
<HEAD>
   <%=fHeader%>

   <TITLE><%=reportsRB.get("ModifiedContractActivityReportWindowTitle")%></TITLE>

   <SCRIPT SRC="/wcs/javascript/tools/common/Util.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/DateUtil.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/common/SwapList.js"></SCRIPT>
   <SCRIPT SRC="/wcs/javascript/tools/reporting/ReportHelpers.js"></SCRIPT>

   <SCRIPT>

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the initialize routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function initializeValues()
      {
         onLoadStartDateEndDate("enquiryPeriod");
		 ResetValues();
         if (parent.setContentFrameLoaded) parent.setContentFrameLoaded(true);
      }


      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the save routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function savePanelData()
      {
      	////////////////////////////////////////////////////////////////////////////////////////////////////
        // Specify the report framework particulars
        ////////////////////////////////////////////////////////////////////////////////////////////////////
        setReportFrameworkOutputView("DialogView");
	setReportFrameworkParameter("XMLFile","reporting.ReviewModifiedContractActivityOutputDialog");
        setReportFrameworkReportXML("reporting.ReviewModifiedContractActivityReport");

	////////////////////////////////////////////////////////////////////////////////////////////////////
        // Specify the report framework particulars
        ////////////////////////////////////////////////////////////////////////////////////////////////////
	if ( document.getElementById("ContractStatus").selectedIndex == 0 ) {
		if ( document.getElementById("ContractType").selectedIndex == 0 ) { 
			if ( document.getElementById("ContractBuyer").value == "" ) {
		 		setReportFrameworkReportName("AllCustomerContractActivityReport");
			} else {
				setReportFrameworkParameter("buyerinput",document.getElementById("ContractBuyer").value.toUpperCase());
		 		setReportFrameworkReportName("AllCustomerContractWithBuyerActivityReport");
			}
		} else {
		 	setReportFrameworkReportName("AllBaseContractActivityReport");
		}		 		 
	} else {
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

		if ( document.getElementById("ContractStatus").selectedIndex == 1 ) {
			if ( document.getElementById("ContractType").selectedIndex == 0 ) {
				if ( document.getElementById("ContractBuyer").value == "" ) {
		 			setReportFrameworkReportName("NewCustomerContractActivityReport");
				} else {
					setReportFrameworkParameter("buyerinput",document.getElementById("ContractBuyer").value.toUpperCase());
		 			setReportFrameworkReportName("NewCustomerContractWithBuyerActivityReport");
				}
			} else {
		 		setReportFrameworkReportName("NewBaseContractActivityReport");
			}		 		 
		} else {
			if ( document.getElementById("ContractType").selectedIndex == 0 ) {
				if ( document.getElementById("ContractBuyer").value == "" ) {
		 			setReportFrameworkReportName("ModifiedCustomerContractActivityReport");
				} else {
					setReportFrameworkParameter("buyerinput",document.getElementById("ContractBuyer").value.toUpperCase());
		 			setReportFrameworkReportName("ModifiedCustomerContractWithBuyerActivityReport");
				}
			} else {
		 		setReportFrameworkReportName("ModifiedBaseContractActivityReport");
			}		 		 
		}	
	}
 	setReportFrameworkParameter("ReportType", "UserInput");
	 	
        saveReportFramework();
        top.saveModel(parent.model);
        return true;
      }

      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      // Call the validate routines for the various elements of the page
      ///////////////////////////////////////////////////////////////////////////////////////////////////////
      function validatePanelData()
      {
      	if ( document.getElementById("ContractStatus").selectedIndex != 0 ) {
      		if(document.all.time.selectedIndex != 0 &&
		  (document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" ||
			document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" || document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ))
		{
			parent.alertDialog("<%=UIUtil.toJavaScript(reportsRB.get("SelectAnyOneOption"))%>");
			ResetValues();
			return false;

		 }
		 if(document.all.time.selectedIndex == 0)
		 {
			 if (validateStartDateEndDate("enquiryPeriod") == false) return false;
		 }
	}
        return true;
      }

	function ResetValues()
	{
		document.enquiryPeriod.StartDateEndDateHelperYearSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthSD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDaySD.value = "";
		document.enquiryPeriod.StartDateEndDateHelperYearED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperMonthED.value = "";
		document.enquiryPeriod.StartDateEndDateHelperDayED.value = "";
		document.all.time.selectedIndex = 0;
	}
	function setEndDate()
	{
    	  if((document.enquiryPeriod.StartDateEndDateHelperYearSD.value != "" &&
			document.enquiryPeriod.StartDateEndDateHelperMonthSD.value != "" && document.enquiryPeriod.StartDateEndDateHelperDaySD.value != "" ) &&
			  (document.enquiryPeriod.StartDateEndDateHelperYearED.value == "" &&
			document.enquiryPeriod.StartDateEndDateHelperMonthED.value == "" && document.enquiryPeriod.StartDateEndDateHelperDayED.value == "" ))
		{

				parent.alertDialog("<%=UIUtil.toJavaScript(reportsRB.get("EndDateIsCurrentDate"))%>");
				document.enquiryPeriod.StartDateEndDateHelperYearED.value = getCurrentYear();
				document.enquiryPeriod.StartDateEndDateHelperMonthED.value = getCurrentMonth();
				document.enquiryPeriod.StartDateEndDateHelperDayED.value = getCurrentDay();
		}

	}

	function contractTypeChanged(contractElement) {
		if (contractElement != null && contractElement.selectedIndex == 0) {
			document.getElementById("ContractBuyerDiv").style.display = "block";
		}
		else if (contractElement != null && contractElement.selectedIndex == 1) {
			document.getElementById("ContractBuyerDiv").style.display = "none";
		}			
	}
	
	function contractStatusChanged(contractElement) {
		if (contractElement != null && contractElement.selectedIndex == 0) {
			document.getElementById("TimeDiv").style.display = "none";
		}
		else {
			document.getElementById("TimeDiv").style.display = "block";
		}			
	}
	
</SCRIPT>
<META name="GENERATOR" content="IBM WebSphere Studio">
</HEAD>

<BODY ONLOAD="initializeValues()" CLASS=content>

   <H1><%=reportsRB.get("ModifiedContractActivityReportWindowTitle") %></H1>
   <%=reportsRB.get("ModifiedContractActivityReportDescription")%>

   <p></p>
   <p></p>
   <DIV ID="ContractStatusDiv" STYLE="display: block; margin-left: 20">
   <label for="ContractStatus"><%=reportsRB.get("contractStatus")%></label><br>
	<select name="ContractStatus" id="ContractStatus" onchange="contractStatusChanged(this);">
		<option value="All" selected><%=reportsRB.get("statusAll")%></option>
		<option value="New"><%=reportsRB.get("statusNew")%></option>
		<option value="Modified"><%=reportsRB.get("statusModified")%></option>
	</select>
   </DIV>

   <p></p>
   <DIV ID="ContractTypeDiv" STYLE="display: block; margin-left: 20">
   <label for="ContractType"><%=reportsRB.get("contractType")%></label><br>
	<select name="ContractType" id="ContractType" onchange="contractTypeChanged(this);">
		<option value="Customer" selected><%=reportsRB.get("typeCustomer")%></option>
		<option value="Base"><%=reportsRB.get("typeBase")%></option>
	</select>
   </DIV>

   <p></p>
   <DIV ID="ContractBuyerDiv" STYLE="display: block; margin-left: 0">	
	<label for="ContractBuyer"><%=reportsRB.get("contractBuyer")%></label>
	<INPUT TYPE=TEXT NAME=ContractBuyer id="ContractBuyer" SIZE=20 MAXLENGTH=32>
   </DIV>

   <p></p>
   <p></p>
   <p></p>

  <DIV ID=TimeDiv STYLE="display: none; margin-left: 20">
   <%=reportsRB.get("ModifiedContractActivityReportSelection")%>
   <p></p>
  <label for="time"><%=reportsRB.get("timePeriod")%> </label><br>
	<select id="time">
		<option value="pleaseSelect" selected><%=reportsRB.get("pleaseSelect")%></option>
		<option value="Yesterday"><%=reportsRB.get("yesterdayTitle")%></option>
		<option value="Weekly"><%=reportsRB.get("thisWeekTitle")%></option>
		<option value="Monthly"><%=reportsRB.get("thisMonthTitle")%></option>
		<option value="Quarterly"><%=reportsRB.get("thisQuarterTitle")%></option>
		<option value="Yearly"><%=reportsRB.get("thisYearTitle")%></option>
	</select>
  <B><%=reportsRB.get("or")%></B>
      <%=generateStartDateEndDate("enquiryPeriod", reportsRB, null)%>
  </DIV>
  


   <br>

</BODY>
</HTML>